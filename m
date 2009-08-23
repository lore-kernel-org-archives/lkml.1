Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbZHWL6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbZHWL6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbZHWL6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:58:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933558AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/46] KVM: make io_bus interface more robust
Date: Sun, 23 Aug 2009 14:56:20 +0300
Message-Id: <1251028605-31977-22-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

Today kvm_io_bus_regsiter_dev() returns void and will internally BUG_ON
if it fails.  We want to create dynamic MMIO/PIO entries driven from
userspace later in the series, so we need to enhance the code to be more
robust with the following changes:

   1) Add a return value to the registration function
   2) Fix up all the callsites to check the return code, handle any
      failures, and percolate the error up to the caller.
   3) Add an unregister function that collapses holes in the array

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c      |   20 ++++++++++++++++++--
 arch/x86/kvm/i8259.c      |    9 ++++++++-
 include/linux/kvm_host.h  |   10 +++++++---
 virt/kvm/coalesced_mmio.c |    8 ++++++--
 virt/kvm/ioapic.c         |    8 ++++++--
 virt/kvm/kvm_main.c       |   39 ++++++++++++++++++++++++++++++++++-----
 6 files changed, 79 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 9b62c57..137e548 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -605,6 +605,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 {
 	struct kvm_pit *pit;
 	struct kvm_kpit_state *pit_state;
+	int ret;
 
 	pit = kzalloc(sizeof(struct kvm_pit), GFP_KERNEL);
 	if (!pit)
@@ -639,14 +640,29 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
 	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
-	__kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	ret = __kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	if (ret < 0)
+		goto fail;
 
 	if (flags & KVM_PIT_SPEAKER_DUMMY) {
 		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
-		__kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+		ret = __kvm_io_bus_register_dev(&kvm->pio_bus,
+						&pit->speaker_dev);
+		if (ret < 0)
+			goto fail_unregister;
 	}
 
 	return pit;
+
+fail_unregister:
+	__kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->dev);
+
+fail:
+	if (pit->irq_source_id >= 0)
+		kvm_free_irq_source_id(kvm, pit->irq_source_id);
+
+	kfree(pit);
+	return NULL;
 }
 
 void kvm_free_pit(struct kvm *kvm)
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index e4bcbdd..daf4606 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -539,6 +539,8 @@ static const struct kvm_io_device_ops picdev_ops = {
 struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 {
 	struct kvm_pic *s;
+	int ret;
+
 	s = kzalloc(sizeof(struct kvm_pic), GFP_KERNEL);
 	if (!s)
 		return NULL;
@@ -555,6 +557,11 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 	 * Initialize PIO device
 	 */
 	kvm_iodevice_init(&s->dev, &picdev_ops);
-	kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
+	ret = kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
+	if (ret < 0) {
+		kfree(s);
+		return NULL;
+	}
+
 	return s;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 077e8bb..983b0bd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -64,10 +64,14 @@ int kvm_io_bus_write(struct kvm_io_bus *bus, gpa_t addr, int len,
 		     const void *val);
 int kvm_io_bus_read(struct kvm_io_bus *bus, gpa_t addr, int len,
 		    void *val);
-void __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+int __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+			       struct kvm_io_device *dev);
+int kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
+			    struct kvm_io_device *dev);
+void __kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
+				 struct kvm_io_device *dev);
+void kvm_io_bus_unregister_dev(struct kvm *kvm, struct kvm_io_bus *bus,
 			       struct kvm_io_device *dev);
-void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
-			     struct kvm_io_device *dev);
 
 struct kvm_vcpu {
 	struct kvm *kvm;
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 0352f81..04d69cd 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -92,6 +92,7 @@ static const struct kvm_io_device_ops coalesced_mmio_ops = {
 int kvm_coalesced_mmio_init(struct kvm *kvm)
 {
 	struct kvm_coalesced_mmio_dev *dev;
+	int ret;
 
 	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
 	if (!dev)
@@ -100,9 +101,12 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
 	dev->kvm = kvm;
 	kvm->coalesced_mmio_dev = dev;
-	kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &dev->dev);
 
-	return 0;
+	ret = kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &dev->dev);
+	if (ret < 0)
+		kfree(dev);
+
+	return ret;
 }
 
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index b91fbb2..fa05f67 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -342,6 +342,7 @@ static const struct kvm_io_device_ops ioapic_mmio_ops = {
 int kvm_ioapic_init(struct kvm *kvm)
 {
 	struct kvm_ioapic *ioapic;
+	int ret;
 
 	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
 	if (!ioapic)
@@ -350,7 +351,10 @@ int kvm_ioapic_init(struct kvm *kvm)
 	kvm_ioapic_reset(ioapic);
 	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
 	ioapic->kvm = kvm;
-	kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &ioapic->dev);
-	return 0;
+	ret = kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &ioapic->dev);
+	if (ret < 0)
+		kfree(ioapic);
+
+	return ret;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fc1b58a..9c2fd02 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2533,21 +2533,50 @@ int kvm_io_bus_read(struct kvm_io_bus *bus, gpa_t addr, int len, void *val)
 	return -EOPNOTSUPP;
 }
 
-void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
+int kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev)
 {
+	int ret;
+
 	down_write(&kvm->slots_lock);
-	__kvm_io_bus_register_dev(bus, dev);
+	ret = __kvm_io_bus_register_dev(bus, dev);
 	up_write(&kvm->slots_lock);
+
+	return ret;
 }
 
 /* An unlocked version. Caller must have write lock on slots_lock. */
-void __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
-			     struct kvm_io_device *dev)
+int __kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+			      struct kvm_io_device *dev)
 {
-	BUG_ON(bus->dev_count > (NR_IOBUS_DEVS-1));
+	if (bus->dev_count > NR_IOBUS_DEVS-1)
+		return -ENOSPC;
 
 	bus->devs[bus->dev_count++] = dev;
+
+	return 0;
+}
+
+void kvm_io_bus_unregister_dev(struct kvm *kvm,
+			       struct kvm_io_bus *bus,
+			       struct kvm_io_device *dev)
+{
+	down_write(&kvm->slots_lock);
+	__kvm_io_bus_unregister_dev(bus, dev);
+	up_write(&kvm->slots_lock);
+}
+
+/* An unlocked version. Caller must have write lock on slots_lock. */
+void __kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
+				 struct kvm_io_device *dev)
+{
+	int i;
+
+	for (i = 0; i < bus->dev_count; i++)
+		if (bus->devs[i] == dev) {
+			bus->devs[i] = bus->devs[--bus->dev_count];
+			break;
+		}
 }
 
 static struct notifier_block kvm_cpu_notifier = {
-- 
1.6.4.1

