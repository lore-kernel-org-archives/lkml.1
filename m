Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbZFCUSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbZFCUSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZFCUR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:17:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38176 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbZFCUR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:17:56 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v5 1/2] kvm: make io_bus interface more robust
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Date: Wed, 03 Jun 2009 16:17:43 -0400
Message-ID: <20090603201743.8206.35971.stgit@dev.haskins.net>
In-Reply-To: <20090603200835.8206.8039.stgit@dev.haskins.net>
References: <20090603200835.8206.8039.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today kvm_io_bus_regsiter_dev() returns void and will internally BUG_ON if it
fails.  We want to create dynamic MMIO/PIO entries driven from userspace later
in the series, so we need to enhance the code to be more robust with the
following changes:

   1) Add a return value to the registration function
   2) Fix up all the callsites to check the return code, handle any
      failures, and percolate the error up to the caller.
   3) Add an unregister function that collapses holes in the array

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/i8254.c      |   22 ++++++++++++++++++++--
 arch/x86/kvm/i8259.c      |    9 ++++++++-
 include/linux/kvm_host.h  |    6 ++++--
 virt/kvm/coalesced_mmio.c |    8 ++++++--
 virt/kvm/ioapic.c         |    9 +++++++--
 virt/kvm/kvm_main.c       |   30 ++++++++++++++++++++++++++++--
 6 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index f91b0e3..f01eabe 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -586,6 +586,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 {
 	struct kvm_pit *pit;
 	struct kvm_kpit_state *pit_state;
+	int ret;
 
 	pit = kzalloc(sizeof(struct kvm_pit), GFP_KERNEL);
 	if (!pit)
@@ -620,14 +621,31 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
 	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
-	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	ret = kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	if (ret < 0)
+		goto fail;
 
 	if (flags & KVM_PIT_SPEAKER_DUMMY) {
 		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
-		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+		ret = kvm_io_bus_register_dev(&kvm->pio_bus,
+					      &pit->speaker_dev);
+		if (ret < 0)
+			goto fail;
 	}
 
 	return pit;
+
+fail:
+	if (flags & KVM_PIT_SPEAKER_DUMMY)
+		kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->speaker_dev);
+
+	kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->dev);
+
+	if (pit->irq_source_id >= 0)
+		kvm_free_irq_source_id(kvm, pit->irq_source_id);
+
+	kfree(pit);
+	return NULL;
 }
 
 void kvm_free_pit(struct kvm *kvm)
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 2520922..af9b8b4 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -530,6 +530,8 @@ static const struct kvm_io_device_ops picdev_ops = {
 struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 {
 	struct kvm_pic *s;
+	int ret;
+
 	s = kzalloc(sizeof(struct kvm_pic), GFP_KERNEL);
 	if (!s)
 		return NULL;
@@ -546,6 +548,11 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 	 * Initialize PIO device
 	 */
 	kvm_iodevice_init(&s->dev, &picdev_ops);
-	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
+	ret = kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
+	if (ret < 0) {
+		kfree(s);
+		return NULL;
+	}
+
 	return s;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bcb94eb..216fe07 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -61,8 +61,10 @@ void kvm_io_bus_init(struct kvm_io_bus *bus);
 void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 					  gpa_t addr, int len, int is_write);
-void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
-			     struct kvm_io_device *dev);
+int kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+			    struct kvm_io_device *dev);
+void kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
+			    struct kvm_io_device *dev);
 
 struct kvm_vcpu {
 	struct kvm *kvm;
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index c4c7ec2..282fcde 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -97,6 +97,7 @@ static const struct kvm_io_device_ops coalesced_mmio_ops = {
 int kvm_coalesced_mmio_init(struct kvm *kvm)
 {
 	struct kvm_coalesced_mmio_dev *dev;
+	int ret;
 
 	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
 	if (!dev)
@@ -104,9 +105,12 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
 	dev->kvm = kvm;
 	kvm->coalesced_mmio_dev = dev;
-	kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
 
-	return 0;
+	ret = kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
+	if (ret < 0)
+		kfree(dev);
+
+	return ret;
 }
 
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 6b00433..4a37ea1 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -328,6 +328,7 @@ static const struct kvm_io_device_ops ioapic_mmio_ops = {
 int kvm_ioapic_init(struct kvm *kvm)
 {
 	struct kvm_ioapic *ioapic;
+	int ret;
 
 	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
 	if (!ioapic)
@@ -336,7 +337,11 @@ int kvm_ioapic_init(struct kvm *kvm)
 	kvm_ioapic_reset(ioapic);
 	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
 	ioapic->kvm = kvm;
-	kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
-	return 0;
+
+	ret = kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
+	if (ret < 0)
+		kfree(ioapic);
+
+	return ret;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 902fed9..179c650 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2457,11 +2457,37 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 	return NULL;
 }
 
-void kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
+/* assumes kvm->lock held */
+int kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
 {
-	BUG_ON(bus->dev_count > (NR_IOBUS_DEVS-1));
+	if (bus->dev_count > (NR_IOBUS_DEVS-1))
+		return -ENOSPC;
 
 	bus->devs[bus->dev_count++] = dev;
+
+	return 0;
+}
+
+/* assumes kvm->lock held */
+void kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
+			       struct kvm_io_device *dev)
+{
+	int i;
+
+	for (i = 0; i < bus->dev_count; i++) {
+
+		if (bus->devs[i] == dev) {
+			int j;
+
+			/* backfill the hole */
+			for (j = i; j < bus->dev_count-1; j++)
+				bus->devs[j] = bus->devs[j+1];
+
+			bus->dev_count--;
+
+			break;
+		}
+	}
 }
 
 static struct notifier_block kvm_cpu_notifier = {

