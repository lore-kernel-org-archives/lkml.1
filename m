Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbXGHL4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbXGHL4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbXGHLzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:38396 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbXGHLyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 05/20] KVM: Add support for in-kernel pio handlers
Date: Sun,  8 Jul 2007 14:54:34 +0300
Message-Id: <11838956891659-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Useful for the PIC and PIT.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    5 ++++-
 drivers/kvm/kvm_main.c |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 31846b1..a7c5e6b 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -241,6 +241,7 @@ struct kvm_pio_request {
 	struct page *guest_pages[2];
 	unsigned guest_page_offset;
 	int in;
+	int port;
 	int size;
 	int string;
 	int down;
@@ -303,7 +304,8 @@ static inline int kvm_iodevice_inrange(struct kvm_io_device *dev, gpa_t addr)
 
 static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
 {
-	dev->destructor(dev);
+	if (dev->destructor)
+		dev->destructor(dev);
 }
 
 /*
@@ -453,6 +455,7 @@ struct kvm {
 	struct list_head vm_list;
 	struct file *filp;
 	struct kvm_io_bus mmio_bus;
+	struct kvm_io_bus pio_bus;
 };
 
 struct descriptor_table {
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index e157e28..7826f16 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -361,6 +361,7 @@ static struct kvm *kvm_create_vm(void)
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
 
+	kvm_io_bus_init(&kvm->pio_bus);
 	spin_lock_init(&kvm->lock);
 	INIT_LIST_HEAD(&kvm->active_mmu_pages);
 	spin_lock(&kvm_lock);
@@ -475,6 +476,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	spin_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
+	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
 	kvm_free_vcpus(kvm);
 	kvm_free_physmem(kvm);
@@ -1110,6 +1112,12 @@ static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
 	return kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr);
 }
 
+static struct kvm_io_device *vcpu_find_pio_dev(struct kvm_vcpu *vcpu,
+					       gpa_t addr)
+{
+	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr);
+}
+
 static int emulator_read_emulated(unsigned long addr,
 				  void *val,
 				  unsigned int bytes,
@@ -1832,6 +1840,20 @@ static int complete_pio(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+void kernel_pio(struct kvm_io_device *pio_dev, struct kvm_vcpu *vcpu)
+{
+	/* TODO: String I/O for in kernel device */
+
+	if (vcpu->pio.in)
+		kvm_iodevice_read(pio_dev, vcpu->pio.port,
+				  vcpu->pio.size,
+				  vcpu->pio_data);
+	else
+		kvm_iodevice_write(pio_dev, vcpu->pio.port,
+				   vcpu->pio.size,
+				   vcpu->pio_data);
+}
+
 int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		  int size, unsigned long count, int string, int down,
 		  gva_t address, int rep, unsigned port)
@@ -1840,6 +1862,7 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	int i;
 	int nr_pages = 1;
 	struct page *page;
+	struct kvm_io_device *pio_dev;
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
@@ -1851,17 +1874,27 @@ int kvm_setup_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->pio.cur_count = count;
 	vcpu->pio.size = size;
 	vcpu->pio.in = in;
+	vcpu->pio.port = port;
 	vcpu->pio.string = string;
 	vcpu->pio.down = down;
 	vcpu->pio.guest_page_offset = offset_in_page(address);
 	vcpu->pio.rep = rep;
 
+	pio_dev = vcpu_find_pio_dev(vcpu, port);
 	if (!string) {
 		kvm_arch_ops->cache_regs(vcpu);
 		memcpy(vcpu->pio_data, &vcpu->regs[VCPU_REGS_RAX], 4);
 		kvm_arch_ops->decache_regs(vcpu);
+		if (pio_dev) {
+			kernel_pio(pio_dev, vcpu);
+			complete_pio(vcpu);
+			return 1;
+		}
 		return 0;
 	}
+	/* TODO: String I/O for in kernel device */
+	if (pio_dev)
+		printk(KERN_ERR "kvm_setup_pio: no string io support\n");
 
 	if (!count) {
 		kvm_arch_ops->skip_emulated_instruction(vcpu);
-- 
1.5.2.2

