Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZFYMwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZFYMwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZFYMwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:52:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56308 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbZFYMwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:52:31 -0400
Date: Thu, 25 Jun 2009 15:52:01 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com
Message-ID: <20090625125201.GA7166@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

markmc@redhat.com
Subject: [PATCH] kvm: pass value to in_range callback
Reply-To: 

For write transactions, pass the value written to in_range checks so
that we can make each iosignalfd a separate device on kvm bus.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Avi, can you please merge this patch in kvm.git so that
Gregory can use it for iosignalfd? Once bus has RCU
we'll be able to remove in_range completely, but
let's do it step by step.

 arch/ia64/kvm/kvm-ia64.c  |    9 ++++--
 arch/x86/kvm/i8254.c      |    2 +-
 arch/x86/kvm/lapic.c      |    2 +-
 arch/x86/kvm/x86.c        |   60 +++++++++++++++++++++++++-------------------
 include/linux/kvm_host.h  |    3 +-
 virt/kvm/coalesced_mmio.c |    3 +-
 virt/kvm/ioapic.c         |    3 +-
 virt/kvm/iodev.h          |    9 +++---
 virt/kvm/kvm_main.c       |    5 ++-
 9 files changed, 56 insertions(+), 40 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index c1c5cb6..68058c2 100644
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
@@ -247,7 +249,8 @@ static int handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
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
index 331705f..6f84cb2 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -495,7 +495,7 @@ static void pit_ioport_read(struct kvm_io_device *this,
 }
 
 static int pit_in_range(struct kvm_io_device *this, gpa_t addr,
-			int len, int is_write)
+			int len, int is_write, void *write_val)
 {
 	return ((addr >= KVM_PIT_BASE_ADDRESS) &&
 		(addr < KVM_PIT_BASE_ADDRESS + KVM_PIT_MEM_LENGTH));
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2e02865..3d08b1d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -747,7 +747,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 }
 
 static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr,
-			   int len, int size)
+			   int len, int is_write, void *write_val)
 {
 	struct kvm_lapic *apic = to_lapic(this);
 	int ret = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5a66bb9..73a56ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2265,13 +2265,13 @@ static void kvm_init_msr_list(void)
  */
 static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
 						gpa_t addr, int len,
-						int is_write)
+						int is_write, void *write_val)
 {
 	struct kvm_io_device *dev;
 
 	if (vcpu->arch.apic) {
 		dev = &vcpu->arch.apic->dev;
-		if (kvm_iodevice_in_range(dev, addr, len, is_write))
+		if (kvm_iodevice_in_range(dev, addr, len, is_write, write_val))
 			return dev;
 	}
 	return NULL;
@@ -2280,14 +2280,14 @@ static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
 
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
 
@@ -2383,7 +2383,7 @@ mmio:
 	 * Is this MMIO handled locally?
 	 */
 	mutex_lock(&vcpu->kvm->lock);
-	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 0);
+	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 0, NULL);
 	mutex_unlock(&vcpu->kvm->lock);
 	if (mmio_dev) {
 		kvm_iodevice_read(mmio_dev, gpa, bytes, val);
@@ -2437,7 +2437,7 @@ mmio:
 	 * Is this MMIO handled locally?
 	 */
 	mutex_lock(&vcpu->kvm->lock);
-	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 1);
+	mmio_dev = vcpu_find_mmio_dev(vcpu, gpa, bytes, 1, val);
 	mutex_unlock(&vcpu->kvm->lock);
 	if (mmio_dev) {
 		kvm_iodevice_write(mmio_dev, gpa, bytes, val);
@@ -2791,9 +2791,10 @@ static void pio_string_write(struct kvm_io_device *pio_dev,
 
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
@@ -2820,7 +2821,8 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	memcpy(vcpu->arch.pio_data, &val, 4);
 
 	mutex_lock(&vcpu->kvm->lock);
-	pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in);
+	pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in,
+				    vcpu->arch.pio_data);
 	mutex_unlock(&vcpu->kvm->lock);
 	if (pio_dev) {
 		kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
@@ -2837,7 +2839,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 {
 	unsigned now, in_page;
 	int ret = 0;
-	struct kvm_io_device *pio_dev;
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
 	vcpu->run->io.direction = in ? KVM_EXIT_IO_IN : KVM_EXIT_IO_OUT;
@@ -2881,12 +2882,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 
 	vcpu->arch.pio.guest_gva = address;
 
-	mutex_lock(&vcpu->kvm->lock);
-	pio_dev = vcpu_find_pio_dev(vcpu, port,
-				    vcpu->arch.pio.cur_count,
-				    !vcpu->arch.pio.in);
-	mutex_unlock(&vcpu->kvm->lock);
-
 	if (!vcpu->arch.pio.in) {
 		/* string PIO write */
 		ret = pio_copy_data(vcpu);
@@ -2894,16 +2889,29 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
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
+			mutex_lock(&vcpu->kvm->lock);
+			pio_dev = vcpu_find_pio_dev(vcpu, port,
+						    vcpu->arch.pio.cur_count,
+						    1, vcpu->arch.pio_data);
+			mutex_unlock(&vcpu->kvm->lock);
+			if (pio_dev) {
+				pio_string_write(pio_dev, vcpu);
+				complete_pio(vcpu);
+				if (vcpu->arch.pio.count == 0)
+					ret = 1;
+			}
 		}
-	} else if (pio_dev)
-		pr_unimpl(vcpu, "no string pio read support yet, "
-		       "port %x size %d count %ld\n",
-			port, size, count);
+	} else {
+		mutex_lock(&vcpu->kvm->lock);
+		if (vcpu_find_pio_dev(vcpu, port, vcpu->arch.pio.cur_count, 0,
+				     NULL))
+			pr_unimpl(vcpu, "no string pio read support yet, "
+				  "port %x size %d count %ld\n",
+				  port, size, count);
+		mutex_unlock(&vcpu->kvm->lock);
+	}
 
 	return ret;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2451f48..7b2bd9b 100644
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
index 397f419..9561bc2 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -20,7 +20,8 @@ static inline struct kvm_coalesced_mmio_dev *to_mmio(struct kvm_io_device *dev)
 }
 
 static int coalesced_mmio_in_range(struct kvm_io_device *this,
-				   gpa_t addr, int len, int is_write)
+				   gpa_t addr, int len, int is_write,
+				   void *write_val)
 {
 	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_zone *zone;
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index d8b2eca..fa3f4fb 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -228,7 +228,8 @@ static inline struct kvm_ioapic *to_ioapic(struct kvm_io_device *dev)
 }
 
 static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr,
-			   int len, int is_write)
+			   int len, int is_write,
+			   void *write_val)
 {
 	struct kvm_ioapic *ioapic = to_ioapic(this);
 
diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
index 2c67f5a..d8cf9e2 100644
--- a/virt/kvm/iodev.h
+++ b/virt/kvm/iodev.h
@@ -30,7 +30,7 @@ struct kvm_io_device_ops {
 		      int len,
 		      const void *val);
 	int (*in_range)(struct kvm_io_device *this, gpa_t addr, int len,
-			int is_write);
+			int is_write, void *write_val);
 	void (*destructor)(struct kvm_io_device *this);
 };
 
@@ -61,10 +61,11 @@ static inline void kvm_iodevice_write(struct kvm_io_device *dev,
 	dev->ops->write(dev, addr, len, val);
 }
 
-static inline int kvm_iodevice_in_range(struct kvm_io_device *dev,
-					gpa_t addr, int len, int is_write)
+static inline int kvm_iodevice_inrange(struct kvm_io_device *dev,
+				       gpa_t addr, int len, int is_write,
+				       void *write_val)
 {
-	return dev->ops->in_range(dev, addr, len, is_write);
+	return dev->ops->in_range(dev, addr, len, is_write, write_val);
 }
 
 static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 58d6bc6..f5dfe02 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2485,14 +2485,15 @@ void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 }
 
 struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
-					  gpa_t addr, int len, int is_write)
+					  gpa_t addr, int len, int is_write,
+					  void *write_val)
 {
 	int i;
 
 	for (i = 0; i < bus->dev_count; i++) {
 		struct kvm_io_device *pos = bus->devs[i];
 
-		if (kvm_iodevice_in_range(pos, addr, len, is_write))
+		if (kvm_iodevice_in_range(pos, addr, len, is_write, write_val))
 			return pos;
 	}
 
-- 
1.6.2.2
