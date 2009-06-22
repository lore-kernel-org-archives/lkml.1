Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZFVPRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZFVPRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZFVPRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:17:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48066 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbZFVPRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:17:03 -0400
Date: Mon, 22 Jun 2009 18:16:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: [PATCH RFC] pass write value to in_range pointers
Message-ID: <20090622151631.GA14780@redhat.com>
References: <20090619002224.15859.97977.stgit@dev.haskins.net> <20090619003045.15859.73197.stgit@dev.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619003045.15859.73197.stgit@dev.haskins.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that a lot of complexity and trickiness with iosignalfd is
handling the group/item relationship, which comes about because kvm does
not currently let a device on the bus claim a write transaction based on the
value written.  This could be greatly simplified if the value written
was passed to the in_range check for write operation.  We could then
simply make each kvm_iosignalfd a device on the bus.

What does everyone think of the following lightly tested patch?

-->

Subject: kvm: pass value to in_range callback

For write transactions, pass the value written to in_range checks so
that we can make each iosignalfd a separate device on kvm bus.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---


diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
index 55e8846..98a25af 100644
--- a/virt/kvm/iodev.h
+++ b/virt/kvm/iodev.h
@@ -28,7 +28,7 @@ struct kvm_io_device {
 		      int len,
 		      const void *val);
 	int (*in_range)(struct kvm_io_device *this, gpa_t addr, int len,
-			int is_write);
+			int is_write, void *write_val);
 	void (*destructor)(struct kvm_io_device *this);
 
 	void             *private;
@@ -51,9 +51,10 @@ static inline void kvm_iodevice_write(struct kvm_io_device *dev,
 }
 
 static inline int kvm_iodevice_inrange(struct kvm_io_device *dev,
-				       gpa_t addr, int len, int is_write)
+				       gpa_t addr, int len, int is_write,
+				       void *write_val)
 {
-	return dev->in_range(dev, addr, len, is_write);
+	return dev->in_range(dev, addr, len, is_write, write_val);
 }
 
 static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 80c57b0..8cfdf9d 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -211,11 +211,13 @@ int kvm_dev_ioctl_check_extension(long ext)
 }
 
 static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
-					gpa_t addr, int len, int is_write)
+					gpa_t addr, int len, int is_write,
+					void *write_val)
 {
 	struct kvm_io_device *dev;
 
-	dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len, is_write);
+	dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len, is_write,
+	                          write_val);
 
 	return dev;
 }
@@ -247,7 +247,8 @@ static int handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->exit_reason = KVM_EXIT_MMIO;
 	return 0;
 mmio:
-	mmio_dev = vcpu_find_mmio_dev(vcpu, p->addr, p->size, !p->dir);
+	mmio_dev = vcpu_find_mmio_dev(vcpu, p->addr, p->size,
+				      !p->dir, &p->data);
 	if (mmio_dev) {
 		if (!p->dir)
 			kvm_iodevice_write(mmio_dev, p->addr, p->size,
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 4d6f0d2..5ba21ff 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -485,7 +485,7 @@ static void pit_ioport_read(struct kvm_io_device *this,
 }
 
 static int pit_in_range(struct kvm_io_device *this, gpa_t addr,
-			int len, int is_write)
+			int len, int is_write, void *write_val)
 {
 	return ((addr >= KVM_PIT_BASE_ADDRESS) &&
 		(addr < KVM_PIT_BASE_ADDRESS + KVM_PIT_MEM_LENGTH));
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ae99d83..456fd53 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -721,7 +721,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 }
 
 static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr,
-			   int len, int size)
+			   int len, int is_write, void *write_val)
 {
 	struct kvm_lapic *apic = (struct kvm_lapic *)this->private;
 	int ret = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 249540f..9d29017 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2043,13 +2043,13 @@ static void kvm_init_msr_list(void)
  */
 static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
 						gpa_t addr, int len,
-						int is_write)
+						int is_write, void *write_val)
 {
 	struct kvm_io_device *dev;
 
 	if (vcpu->arch.apic) {
 		dev = &vcpu->arch.apic->dev;
-		if (dev->in_range(dev, addr, len, is_write))
+		if (dev->in_range(dev, addr, len, is_write, write_val))
 			return dev;
 	}
 	return NULL;
@@ -2058,14 +2058,14 @@ static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
 
 static struct kvm_io_device *vcpu_find_mmio_dev(struct kvm_vcpu *vcpu,
 						gpa_t addr, int len,
-						int is_write)
+						int is_write, void *write_val)
 {
 	struct kvm_io_device *dev;
 
-	dev = vcpu_find_pervcpu_dev(vcpu, addr, len, is_write);
+	dev = vcpu_find_pervcpu_dev(vcpu, addr, len, is_write, write_val);
 	if (dev == NULL)
 		dev = kvm_io_bus_find_dev(&vcpu->kvm->mmio_bus, addr, len,
-					  is_write);
+					  is_write, write_val);
 	return dev;
 }
 
@@ -2161,7 +2161,7 @@ mmio:
 	 * Is this MMIO handled locally?
 	 */
 	mutex_lock(&vcpu->kvm->lock);
-	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 0);
+	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 0, NULL);
 	if (mmio_dev) {
 		kvm_iodevice_read(mmio_dev, gpa, bytes, val);
 		mutex_unlock(&vcpu->kvm->lock);
@@ -2216,7 +2216,7 @@ mmio:
 	 * Is this MMIO handled locally?
 	 */
 	mutex_lock(&vcpu->kvm->lock);
-	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 1);
+	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 1, val);
 	if (mmio_dev) {
 		kvm_iodevice_write(mmio_dev, gpa, bytes, val);
 		mutex_unlock(&vcpu->kvm->lock);
@@ -2576,9 +2576,10 @@ static void pio_string_write(struct kvm_io_device *pio_dev,
 
 static struct kvm_io_device *vcpu_find_pio_dev(struct kvm_vcpu *vcpu,
 					       gpa_t addr, int len,
-					       int is_write)
+					       int is_write, void *write_val)
 {
-	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr, len, is_write);
+	return kvm_io_bus_find_dev(&vcpu->kvm->pio_bus, addr, len, is_write,
+	                           write_val);
 }
 
 int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
@@ -2608,7 +2608,8 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	val = kvm_register_read(vcpu, VCPU_REGS_RAX);
 	memcpy(vcpu->arch.pio_data, &val, 4);
 
-	pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in);
+	pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in,
+				    vcpu->arch.pio_data);
 	if (pio_dev) {
 		kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
 		complete_pio(vcpu);
@@ -2624,7 +2625,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 {
 	unsigned now, in_page;
 	int ret = 0;
-	struct kvm_io_device *pio_dev;
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
@@ -2672,9 +2672,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 
 	vcpu->arch.pio.guest_gva = address;
 
-	pio_dev = vcpu_find_pio_dev(vcpu, port,
-				    vcpu->arch.pio.cur_count,
-				    !vcpu->arch.pio.in);
 	if (!vcpu->arch.pio.in) {
 		/* string PIO write */
 		ret = pio_copy_data(vcpu);
@@ -2682,13 +2679,20 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 			kvm_inject_gp(vcpu, 0);
 			return 1;
 		}
-		if (ret == 0 && pio_dev) {
-			pio_string_write(pio_dev, vcpu);
-			complete_pio(vcpu);
-			if (vcpu->arch.pio.count == 0)
-				ret = 1;
+		if (ret == 0) {
+			struct kvm_io_device *pio_dev;
+			pio_dev = vcpu_find_pio_dev(vcpu, port,
+						    vcpu->arch.pio.cur_count,
+						    1, vcpu->arch.pio_data);
+			if (pio_dev) {
+				pio_string_write(pio_dev, vcpu);
+				complete_pio(vcpu);
+				if (vcpu->arch.pio.count == 0)
+					ret = 1;
+			}
 		}
-	} else if (pio_dev)
+	} else if (vcpu_find_pio_dev(vcpu, port, vcpu->arch.pio.cur_count, 0,
+				     NULL))
 		pr_unimpl(vcpu, "no string pio read support yet, "
 		       "port %x size %d count %ld\n",
 			port, size, count);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index aacc544..0fb7938 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -60,7 +60,8 @@ struct kvm_io_bus {
 void kvm_io_bus_init(struct kvm_io_bus *bus);
 void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
-					  gpa_t addr, int len, int is_write);
+					  gpa_t addr, int len, int is_write,
+					  void *write_val);
 void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev);
 
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 5ae620d..3a1cbfd 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -15,7 +15,8 @@
 #include "coalesced_mmio.h"
 
 static int coalesced_mmio_in_range(struct kvm_io_device *this,
-				   gpa_t addr, int len, int is_write)
+				   gpa_t addr, int len, int is_write,
+				   void *write_val)
 {
 	struct kvm_coalesced_mmio_dev *dev =
 				(struct kvm_coalesced_mmio_dev*)this->private;
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 1eddae9..2adbb1b 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -221,7 +221,8 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode)
 }
 
 static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr,
-			   int len, int is_write)
+			   int len, int is_write,
+			   void *write_val)
 {
 	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7645543..b97e390 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2445,14 +2445,15 @@ void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 }
 
 struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
-					  gpa_t addr, int len, int is_write)
+					  gpa_t addr, int len, int is_write,
+					  void *write_val)
 {
 	int i;
 
 	for (i = 0; i < bus->dev_count; i++) {
 		struct kvm_io_device *pos = bus->devs[i];
 
-		if (pos->in_range(pos, addr, len, is_write))
+		if (pos->in_range(pos, addr, len, is_write, write_val))
 			return pos;
 	}
 
