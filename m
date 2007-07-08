Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbXGHL4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbXGHL4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbXGHLzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:09 -0400
Received: from il.qumranet.com ([82.166.9.18]:38359 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbXGHLyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 03/20] KVM: Adds support for in-kernel mmio handlers
Date: Sun,  8 Jul 2007 14:54:32 +0300
Message-Id: <11838956894049-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   60 ++++++++++++++++++++++++++++++
 drivers/kvm/kvm_main.c |   94 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 142 insertions(+), 12 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index b08272b..31846b1 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -265,6 +265,65 @@ struct kvm_stat {
 	u32 efer_reload;
 };
 
+struct kvm_io_device {
+	void (*read)(struct kvm_io_device *this,
+		     gpa_t addr,
+		     int len,
+		     void *val);
+	void (*write)(struct kvm_io_device *this,
+		      gpa_t addr,
+		      int len,
+		      const void *val);
+	int (*in_range)(struct kvm_io_device *this, gpa_t addr);
+	void (*destructor)(struct kvm_io_device *this);
+
+	void             *private;
+};
+
+static inline void kvm_iodevice_read(struct kvm_io_device *dev,
+				     gpa_t addr,
+				     int len,
+				     void *val)
+{
+	dev->read(dev, addr, len, val);
+}
+
+static inline void kvm_iodevice_write(struct kvm_io_device *dev,
+				      gpa_t addr,
+				      int len,
+				      const void *val)
+{
+	dev->write(dev, addr, len, val);
+}
+
+static inline int kvm_iodevice_inrange(struct kvm_io_device *dev, gpa_t addr)
+{
+	return dev->in_range(dev, addr);
+}
+
+static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
+{
+	dev->destructor(dev);
+}
+
+/*
+ * It would be nice to use something smarter than a linear search, TBD...
+ * Thankfully we dont expect many devices to register (famous last words :),
+ * so until then it will suffice.  At least its abstracted so we can change
+ * in one place.
+ */
+struct kvm_io_bus {
+	int                   dev_count;
+#define NR_IOBUS_DEVS 6
+	struct kvm_io_device *devs[NR_IOBUS_DEVS];
+};
+
+void kvm_io_bus_init(struct kvm_io_bus *bus);
+void kvm_io_bus_destroy(struct kvm_io_bus *bus);
+struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus, gpa_t addr);
+void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+			     struct kvm_io_device *dev);
+
 struct kvm_vcpu {
 	struct kvm *kvm;
 	union {
@@ -393,6 +452,7 @@ struct kvm {
 	unsigned long rmap_overflow;
 	struct list_head vm_list;
 	struct file *filp;
+	struct kvm_io_bus mmio_bus;
 };
 
 struct descriptor_table {
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 633c2ed..e157e28 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -366,6 +366,7 @@ static struct kvm *kvm_create_vm(void)
 	spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	spin_unlock(&kvm_lock);
+	kvm_io_bus_init(&kvm->mmio_bus);
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		struct kvm_vcpu *vcpu = &kvm->vcpus[i];
 
@@ -474,6 +475,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	spin_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
+	kvm_io_bus_destroy(&kvm->mmio_bus);
 	kvm_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
 	kfree(kvm);
@@ -1097,12 +1099,25 @@ static int emulator_write_std(unsigned long addr,
 	return X86EMUL_UNHANDLEABLE;
 }
 
+static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
+						gpa_t addr)
+{
+	/*
+	 * Note that its important to have this wrapper function because
+	 * in the very near future we will be checking for MMIOs against
+	 * the LAPIC as well as the general MMIO bus
+	 */
+	return kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr);
+}
+
 static int emulator_read_emulated(unsigned long addr,
 				  void *val,
 				  unsigned int bytes,
 				  struct x86_emulate_ctxt *ctxt)
 {
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
+	struct kvm_vcpu      *vcpu = ctxt->vcpu;
+	struct kvm_io_device *mmio_dev;
+	gpa_t                 gpa;
 
 	if (vcpu->mmio_read_completed) {
 		memcpy(val, vcpu->mmio_data, bytes);
@@ -1111,18 +1126,26 @@ static int emulator_read_emulated(unsigned long addr,
 	} else if (emulator_read_std(addr, val, bytes, ctxt)
 		   == X86EMUL_CONTINUE)
 		return X86EMUL_CONTINUE;
-	else {
-		gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
 
-		if (gpa == UNMAPPED_GVA)
-			return X86EMUL_PROPAGATE_FAULT;
-		vcpu->mmio_needed = 1;
-		vcpu->mmio_phys_addr = gpa;
-		vcpu->mmio_size = bytes;
-		vcpu->mmio_is_write = 0;
+	gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+	if (gpa == UNMAPPED_GVA)
+		return X86EMUL_PROPAGATE_FAULT;
 
-		return X86EMUL_UNHANDLEABLE;
+	/*
+	 * Is this MMIO handled locally?
+	 */
+	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa);
+	if (mmio_dev) {
+		kvm_iodevice_read(mmio_dev, gpa, bytes, val);
+		return X86EMUL_CONTINUE;
 	}
+
+	vcpu->mmio_needed = 1;
+	vcpu->mmio_phys_addr = gpa;
+	vcpu->mmio_size = bytes;
+	vcpu->mmio_is_write = 0;
+
+	return X86EMUL_UNHANDLEABLE;
 }
 
 static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
@@ -1150,8 +1173,9 @@ static int emulator_write_emulated(unsigned long addr,
 				   unsigned int bytes,
 				   struct x86_emulate_ctxt *ctxt)
 {
-	struct kvm_vcpu *vcpu = ctxt->vcpu;
-	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+	struct kvm_vcpu      *vcpu = ctxt->vcpu;
+	struct kvm_io_device *mmio_dev;
+	gpa_t                 gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
 
 	if (gpa == UNMAPPED_GVA) {
 		kvm_arch_ops->inject_page_fault(vcpu, addr, 2);
@@ -1161,6 +1185,15 @@ static int emulator_write_emulated(unsigned long addr,
 	if (emulator_write_phys(vcpu, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
 
+	/*
+	 * Is this MMIO handled locally?
+	 */
+	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa);
+	if (mmio_dev) {
+		kvm_iodevice_write(mmio_dev, gpa, bytes, val);
+		return X86EMUL_CONTINUE;
+	}
+
 	vcpu->mmio_needed = 1;
 	vcpu->mmio_phys_addr = gpa;
 	vcpu->mmio_size = bytes;
@@ -3031,6 +3064,43 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	return NOTIFY_OK;
 }
 
+void kvm_io_bus_init(struct kvm_io_bus *bus)
+{
+	memset(bus, 0, sizeof(*bus));
+}
+
+void kvm_io_bus_destroy(struct kvm_io_bus *bus)
+{
+	int i;
+
+	for (i = 0; i < bus->dev_count; i++) {
+		struct kvm_io_device *pos = bus->devs[i];
+
+		kvm_iodevice_destructor(pos);
+	}
+}
+
+struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus, gpa_t addr)
+{
+	int i;
+
+	for (i = 0; i < bus->dev_count; i++) {
+		struct kvm_io_device *pos = bus->devs[i];
+
+		if (pos->in_range(pos, addr))
+			return pos;
+	}
+
+	return NULL;
+}
+
+void kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
+{
+	BUG_ON(bus->dev_count > (NR_IOBUS_DEVS-1));
+
+	bus->devs[bus->dev_count++] = dev;
+}
+
 static struct notifier_block kvm_cpu_notifier = {
 	.notifier_call = kvm_cpu_hotplug,
 	.priority = 20, /* must be > scheduler priority */
-- 
1.5.2.2

