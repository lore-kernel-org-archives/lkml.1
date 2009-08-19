Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbZHSNDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbZHSNDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZHSNDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:03:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50591 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752036AbZHSNCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 44/47] KVM: convert bus to slots_lock
Date: Wed, 19 Aug 2009 16:02:40 +0300
Message-Id: <1250686963-8357-45-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

Use slots_lock to protect device list on the bus.  slots_lock is already
taken for read everywhere, so we only need to take it for write when
registering devices.  This is in preparation to removing in_range and
kvm->lock around it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c      |    5 +++--
 arch/x86/kvm/i8259.c      |    2 +-
 include/linux/kvm_host.h  |    5 ++++-
 virt/kvm/coalesced_mmio.c |    2 +-
 virt/kvm/ioapic.c         |    2 +-
 virt/kvm/kvm_main.c       |   12 +++++++++++-
 6 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index bcd00c7..4082cdd 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -583,6 +583,7 @@ static const struct kvm_io_device_ops speaker_dev_ops = {
 	.in_range = speaker_in_range,
 };
 
+/* Caller must have writers lock on slots_lock */
 struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 {
 	struct kvm_pit *pit;
@@ -621,11 +622,11 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
 	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
-	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	__kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
 
 	if (flags & KVM_PIT_SPEAKER_DUMMY) {
 		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
-		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+		__kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
 	}
 
 	return pit;
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 148c52a..1851aec 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -548,6 +548,6 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 	 * Initialize PIO device
 	 */
 	kvm_iodevice_init(&s->dev, &picdev_ops);
-	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
+	kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
 	return s;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4ea42c9..96c8c0b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -42,6 +42,7 @@
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID	0
 
+struct kvm;
 struct kvm_vcpu;
 extern struct kmem_cache *kvm_vcpu_cache;
 
@@ -61,7 +62,9 @@ void kvm_io_bus_init(struct kvm_io_bus *bus);
 void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 					  gpa_t addr, int len, int is_write);
-void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+void __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+			       struct kvm_io_device *dev);
+void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev);
 
 struct kvm_vcpu {
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index b40946c..7b7cc9f 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -102,7 +102,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
 	dev->kvm = kvm;
 	kvm->coalesced_mmio_dev = dev;
-	kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
+	kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &dev->dev);
 
 	return 0;
 }
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 0532fa6..0eca54e 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -343,7 +343,7 @@ int kvm_ioapic_init(struct kvm *kvm)
 	kvm_ioapic_reset(ioapic);
 	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
 	ioapic->kvm = kvm;
-	kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
+	kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &ioapic->dev);
 	return 0;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bbb4029..0edc366 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2527,7 +2527,17 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 	return NULL;
 }
 
-void kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
+void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
+			     struct kvm_io_device *dev)
+{
+	down_write(&kvm->slots_lock);
+	__kvm_io_bus_register_dev(bus, dev);
+	up_write(&kvm->slots_lock);
+}
+
+/* An unlocked version. Caller must have write lock on slots_lock. */
+void __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+			     struct kvm_io_device *dev)
 {
 	BUG_ON(bus->dev_count > (NR_IOBUS_DEVS-1));
 
-- 
1.6.3.3

