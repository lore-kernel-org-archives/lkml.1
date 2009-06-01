Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZFAQzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZFAQzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 12:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbZFAQy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 12:54:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:43727 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbZFAQyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 12:54:53 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v3 2/3] kvm: cleanup io_device code
To: avi@redhat.com
Cc: chrisw@sous-sol.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Jun 2009 12:54:50 -0400
Message-ID: <20090601165450.18202.70520.stgit@dev.haskins.net>
In-Reply-To: <20090601165134.18202.87598.stgit@dev.haskins.net>
References: <20090601165134.18202.87598.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We modernize the io_device code so that we use container_of() instead of
dev->private, and move the vtable to a separate ops structure
(theoretically allows better caching for multiple instances of the same
ops structure)

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/i8254.c      |   40 ++++++++++++++++++++++++++++------------
 arch/x86/kvm/i8259.c      |   20 ++++++++++++++------
 arch/x86/kvm/lapic.c      |   22 +++++++++++++++-------
 arch/x86/kvm/x86.c        |    2 +-
 virt/kvm/coalesced_mmio.c |   25 +++++++++++++++----------
 virt/kvm/ioapic.c         |   22 +++++++++++++++-------
 virt/kvm/iodev.h          |   29 ++++++++++++++++++++---------
 virt/kvm/kvm_main.c       |    2 +-
 8 files changed, 109 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 584e3d3..21301a2 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -347,10 +347,20 @@ void kvm_pit_load_count(struct kvm *kvm, int channel, u32 val)
 	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
 }
 
+static inline struct kvm_pit *dev_to_pit(struct kvm_io_device *dev)
+{
+	return container_of(dev, struct kvm_pit, dev);
+}
+
+static inline struct kvm_pit *speaker_to_pit(struct kvm_io_device *dev)
+{
+	return container_of(dev, struct kvm_pit, speaker_dev);
+}
+
 static void pit_ioport_write(struct kvm_io_device *this,
 			     gpa_t addr, int len, const void *data)
 {
-	struct kvm_pit *pit = (struct kvm_pit *)this->private;
+	struct kvm_pit *pit = dev_to_pit(this);
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	int channel, access;
@@ -423,7 +433,7 @@ static void pit_ioport_write(struct kvm_io_device *this,
 static void pit_ioport_read(struct kvm_io_device *this,
 			    gpa_t addr, int len, void *data)
 {
-	struct kvm_pit *pit = (struct kvm_pit *)this->private;
+	struct kvm_pit *pit = dev_to_pit(this);
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	int ret, count;
@@ -494,7 +504,7 @@ static int pit_in_range(struct kvm_io_device *this, gpa_t addr,
 static void speaker_ioport_write(struct kvm_io_device *this,
 				 gpa_t addr, int len, const void *data)
 {
-	struct kvm_pit *pit = (struct kvm_pit *)this->private;
+	struct kvm_pit *pit = speaker_to_pit(this);
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	u32 val = *(u32 *) data;
@@ -508,7 +518,7 @@ static void speaker_ioport_write(struct kvm_io_device *this,
 static void speaker_ioport_read(struct kvm_io_device *this,
 				gpa_t addr, int len, void *data)
 {
-	struct kvm_pit *pit = (struct kvm_pit *)this->private;
+	struct kvm_pit *pit = speaker_to_pit(this);
 	struct kvm_kpit_state *pit_state = &pit->pit_state;
 	struct kvm *kvm = pit->kvm;
 	unsigned int refresh_clock;
@@ -560,6 +570,18 @@ static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
 	}
 }
 
+static const struct kvm_io_device_ops pit_dev_ops = {
+	.read     = pit_ioport_read,
+	.write    = pit_ioport_write,
+	.in_range = pit_in_range,
+};
+
+static const struct kvm_io_device_ops speaker_dev_ops = {
+	.read     = speaker_ioport_read,
+	.write    = speaker_ioport_write,
+	.in_range = speaker_in_range,
+};
+
 struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 {
 	struct kvm_pit *pit;
@@ -580,17 +602,11 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	spin_lock_init(&pit->pit_state.inject_lock);
 
 	/* Initialize PIO device */
-	pit->dev.read = pit_ioport_read;
-	pit->dev.write = pit_ioport_write;
-	pit->dev.in_range = pit_in_range;
-	pit->dev.private = pit;
+	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
 	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
 
 	if (flags & KVM_PIT_SPEAKER_DUMMY) {
-		pit->speaker_dev.read = speaker_ioport_read;
-		pit->speaker_dev.write = speaker_ioport_write;
-		pit->speaker_dev.in_range = speaker_in_range;
-		pit->speaker_dev.private = pit;
+		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
 		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
 	}
 
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 1ccb50c..2520922 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -444,10 +444,15 @@ static int picdev_in_range(struct kvm_io_device *this, gpa_t addr,
 	}
 }
 
+static inline struct kvm_pic *to_pic(struct kvm_io_device *dev)
+{
+	return container_of(dev, struct kvm_pic, dev);
+}
+
 static void picdev_write(struct kvm_io_device *this,
 			 gpa_t addr, int len, const void *val)
 {
-	struct kvm_pic *s = this->private;
+	struct kvm_pic *s = to_pic(this);
 	unsigned char data = *(unsigned char *)val;
 
 	if (len != 1) {
@@ -474,7 +479,7 @@ static void picdev_write(struct kvm_io_device *this,
 static void picdev_read(struct kvm_io_device *this,
 			gpa_t addr, int len, void *val)
 {
-	struct kvm_pic *s = this->private;
+	struct kvm_pic *s = to_pic(this);
 	unsigned char data = 0;
 
 	if (len != 1) {
@@ -516,6 +521,12 @@ static void pic_irq_request(void *opaque, int level)
 	}
 }
 
+static const struct kvm_io_device_ops picdev_ops = {
+	.read     = picdev_read,
+	.write    = picdev_write,
+	.in_range = picdev_in_range,
+};
+
 struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 {
 	struct kvm_pic *s;
@@ -534,10 +545,7 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 	/*
 	 * Initialize PIO device
 	 */
-	s->dev.read = picdev_read;
-	s->dev.write = picdev_write;
-	s->dev.in_range = picdev_in_range;
-	s->dev.private = s;
+	kvm_iodevice_init(&s->dev, &picdev_ops);
 	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
 	return s;
 }
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ae99d83..4bfd458 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -522,10 +522,15 @@ static u32 __apic_read(struct kvm_lapic *apic, unsigned int offset)
 	return val;
 }
 
+static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
+{
+	return container_of(dev, struct kvm_lapic, dev);
+}
+
 static void apic_mmio_read(struct kvm_io_device *this,
 			   gpa_t address, int len, void *data)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)this->private;
+	struct kvm_lapic *apic = to_lapic(this);
 	unsigned int offset = address - apic->base_address;
 	unsigned char alignment = offset & 0xf;
 	u32 result;
@@ -606,7 +611,7 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 static void apic_mmio_write(struct kvm_io_device *this,
 			    gpa_t address, int len, const void *data)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)this->private;
+	struct kvm_lapic *apic = to_lapic(this);
 	unsigned int offset = address - apic->base_address;
 	unsigned char alignment = offset & 0xf;
 	u32 val;
@@ -723,7 +728,7 @@ static void apic_mmio_write(struct kvm_io_device *this,
 static int apic_mmio_range(struct kvm_io_device *this, gpa_t addr,
 			   int len, int size)
 {
-	struct kvm_lapic *apic = (struct kvm_lapic *)this->private;
+	struct kvm_lapic *apic = to_lapic(this);
 	int ret = 0;
 
 
@@ -917,6 +922,12 @@ static struct kvm_timer_ops lapic_timer_ops = {
 	.is_periodic = lapic_is_periodic,
 };
 
+static const struct kvm_io_device_ops apic_mmio_ops = {
+	.read     = apic_mmio_read,
+	.write    = apic_mmio_write,
+	.in_range = apic_mmio_range,
+};
+
 int kvm_create_lapic(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic;
@@ -951,10 +962,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE;
 
 	kvm_lapic_reset(vcpu);
-	apic->dev.read = apic_mmio_read;
-	apic->dev.write = apic_mmio_write;
-	apic->dev.in_range = apic_mmio_range;
-	apic->dev.private = apic;
+	kvm_iodevice_init(&apic->dev, &apic_mmio_ops);
 
 	return 0;
 nomem_free_apic:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6d44dd5..bff57f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2227,7 +2227,7 @@ static struct kvm_io_device *vcpu_find_pervcpu_dev(struct kvm_vcpu *vcpu,
 
 	if (vcpu->arch.apic) {
 		dev = &vcpu->arch.apic->dev;
-		if (dev->in_range(dev, addr, len, is_write))
+		if (kvm_iodevice_in_range(dev, addr, len, is_write))
 			return dev;
 	}
 	return NULL;
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 03ea280..c4c7ec2 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -14,11 +14,15 @@
 
 #include "coalesced_mmio.h"
 
+static inline struct kvm_coalesced_mmio_dev *to_mmio(struct kvm_io_device *dev)
+{
+	return container_of(dev, struct kvm_coalesced_mmio_dev, dev);
+}
+
 static int coalesced_mmio_in_range(struct kvm_io_device *this,
 				   gpa_t addr, int len, int is_write)
 {
-	struct kvm_coalesced_mmio_dev *dev =
-				(struct kvm_coalesced_mmio_dev*)this->private;
+	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_zone *zone;
 	int next;
 	int i;
@@ -63,8 +67,7 @@ static int coalesced_mmio_in_range(struct kvm_io_device *this,
 static void coalesced_mmio_write(struct kvm_io_device *this,
 				 gpa_t addr, int len, const void *val)
 {
-	struct kvm_coalesced_mmio_dev *dev =
-				(struct kvm_coalesced_mmio_dev*)this->private;
+	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
 
 	/* kvm->lock must be taken by caller before call to in_range()*/
@@ -80,12 +83,17 @@ static void coalesced_mmio_write(struct kvm_io_device *this,
 
 static void coalesced_mmio_destructor(struct kvm_io_device *this)
 {
-	struct kvm_coalesced_mmio_dev *dev =
-		(struct kvm_coalesced_mmio_dev *)this->private;
+	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 
 	kfree(dev);
 }
 
+static const struct kvm_io_device_ops coalesced_mmio_ops = {
+	.write      = coalesced_mmio_write,
+	.in_range   = coalesced_mmio_in_range,
+	.destructor = coalesced_mmio_destructor,
+};
+
 int kvm_coalesced_mmio_init(struct kvm *kvm)
 {
 	struct kvm_coalesced_mmio_dev *dev;
@@ -93,10 +101,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
-	dev->dev.write  = coalesced_mmio_write;
-	dev->dev.in_range  = coalesced_mmio_in_range;
-	dev->dev.destructor  = coalesced_mmio_destructor;
-	dev->dev.private  = dev;
+	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
 	dev->kvm = kvm;
 	kvm->coalesced_mmio_dev = dev;
 	kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 1eddae9..6b00433 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -220,10 +220,15 @@ void kvm_ioapic_update_eoi(struct kvm *kvm, int vector, int trigger_mode)
 			__kvm_ioapic_update_eoi(ioapic, i, trigger_mode);
 }
 
+static inline struct kvm_ioapic *to_ioapic(struct kvm_io_device *dev)
+{
+	return container_of(dev, struct kvm_ioapic, dev);
+}
+
 static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr,
 			   int len, int is_write)
 {
-	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
+	struct kvm_ioapic *ioapic = to_ioapic(this);
 
 	return ((addr >= ioapic->base_address &&
 		 (addr < ioapic->base_address + IOAPIC_MEM_LENGTH)));
@@ -232,7 +237,7 @@ static int ioapic_in_range(struct kvm_io_device *this, gpa_t addr,
 static void ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
 			     void *val)
 {
-	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
+	struct kvm_ioapic *ioapic = to_ioapic(this);
 	u32 result;
 
 	ioapic_debug("addr %lx\n", (unsigned long)addr);
@@ -269,7 +274,7 @@ static void ioapic_mmio_read(struct kvm_io_device *this, gpa_t addr, int len,
 static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 			      const void *val)
 {
-	struct kvm_ioapic *ioapic = (struct kvm_ioapic *)this->private;
+	struct kvm_ioapic *ioapic = to_ioapic(this);
 	u32 data;
 
 	ioapic_debug("ioapic_mmio_write addr=%p len=%d val=%p\n",
@@ -314,6 +319,12 @@ void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
 	ioapic->id = 0;
 }
 
+static const struct kvm_io_device_ops ioapic_mmio_ops = {
+	.read     = ioapic_mmio_read,
+	.write    = ioapic_mmio_write,
+	.in_range = ioapic_in_range,
+};
+
 int kvm_ioapic_init(struct kvm *kvm)
 {
 	struct kvm_ioapic *ioapic;
@@ -323,10 +334,7 @@ int kvm_ioapic_init(struct kvm *kvm)
 		return -ENOMEM;
 	kvm->arch.vioapic = ioapic;
 	kvm_ioapic_reset(ioapic);
-	ioapic->dev.read = ioapic_mmio_read;
-	ioapic->dev.write = ioapic_mmio_write;
-	ioapic->dev.in_range = ioapic_in_range;
-	ioapic->dev.private = ioapic;
+	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
 	ioapic->kvm = kvm;
 	kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
 	return 0;
diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
index 55e8846..2c67f5a 100644
--- a/virt/kvm/iodev.h
+++ b/virt/kvm/iodev.h
@@ -18,7 +18,9 @@
 
 #include <linux/kvm_types.h>
 
-struct kvm_io_device {
+struct kvm_io_device;
+
+struct kvm_io_device_ops {
 	void (*read)(struct kvm_io_device *this,
 		     gpa_t addr,
 		     int len,
@@ -30,16 +32,25 @@ struct kvm_io_device {
 	int (*in_range)(struct kvm_io_device *this, gpa_t addr, int len,
 			int is_write);
 	void (*destructor)(struct kvm_io_device *this);
+};
+
 
-	void             *private;
+struct kvm_io_device {
+	const struct kvm_io_device_ops *ops;
 };
 
+static inline void kvm_iodevice_init(struct kvm_io_device *dev,
+				     const struct kvm_io_device_ops *ops)
+{
+	dev->ops = ops;
+}
+
 static inline void kvm_iodevice_read(struct kvm_io_device *dev,
 				     gpa_t addr,
 				     int len,
 				     void *val)
 {
-	dev->read(dev, addr, len, val);
+	dev->ops->read(dev, addr, len, val);
 }
 
 static inline void kvm_iodevice_write(struct kvm_io_device *dev,
@@ -47,19 +58,19 @@ static inline void kvm_iodevice_write(struct kvm_io_device *dev,
 				      int len,
 				      const void *val)
 {
-	dev->write(dev, addr, len, val);
+	dev->ops->write(dev, addr, len, val);
 }
 
-static inline int kvm_iodevice_inrange(struct kvm_io_device *dev,
-				       gpa_t addr, int len, int is_write)
+static inline int kvm_iodevice_in_range(struct kvm_io_device *dev,
+					gpa_t addr, int len, int is_write)
 {
-	return dev->in_range(dev, addr, len, is_write);
+	return dev->ops->in_range(dev, addr, len, is_write);
 }
 
 static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
 {
-	if (dev->destructor)
-		dev->destructor(dev);
+	if (dev->ops->destructor)
+		dev->ops->destructor(dev);
 }
 
 #endif /* __KVM_IODEV_H__ */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f6a2c79..902fed9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2450,7 +2450,7 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 	for (i = 0; i < bus->dev_count; i++) {
 		struct kvm_io_device *pos = bus->devs[i];
 
-		if (pos->in_range(pos, addr, len, is_write))
+		if (kvm_iodevice_in_range(pos, addr, len, is_write))
 			return pos;
 	}
 

