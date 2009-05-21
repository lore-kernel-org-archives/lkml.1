Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZEUQue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZEUQue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZEUQtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:49:49 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45722 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbZEUQtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:49:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v3 2/4] kvm: add return value to kvm_io_bus_register_dev
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, --cc=mtosatti@redhat.com
Date: Thu, 21 May 2009 12:49:37 -0400
Message-ID: <20090521164936.14617.4458.stgit@dev.haskins.net>
In-Reply-To: <20090521164241.14617.92951.stgit@dev.haskins.net>
References: <20090521164241.14617.92951.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today this function returns void and will internally BUG_ON if it fails.
We want to create dynamic MMIO/PIO entries driven from userspace later in
the series, so enhance this API to return an error code on failure.

We also fix up all the callsites to check the return code, handle any
failures, and percolate the error up to the caller.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/i8254.c      |   27 +++++++++++++++++----------
 arch/x86/kvm/i8259.c      |    9 ++++++++-
 include/linux/kvm_host.h  |    4 ++--
 virt/kvm/coalesced_mmio.c |    8 ++++++--
 virt/kvm/ioapic.c         |    9 +++++++--
 virt/kvm/kvm_main.c       |    7 +++++--
 6 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 4d6f0d2..3ef8b1b 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -564,33 +564,36 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
 {
 	struct kvm_pit *pit;
 	struct kvm_kpit_state *pit_state;
+	int ret;
 
 	pit = kzalloc(sizeof(struct kvm_pit), GFP_KERNEL);
 	if (!pit)
 		return NULL;
 
 	pit->irq_source_id = kvm_request_irq_source_id(kvm);
-	if (pit->irq_source_id < 0) {
-		kfree(pit);
-		return NULL;
-	}
-
-	mutex_init(&pit->pit_state.lock);
-	mutex_lock(&pit->pit_state.lock);
-	spin_lock_init(&pit->pit_state.inject_lock);
+	if (pit->irq_source_id < 0)
+		goto fail;
 
 	/* Initialize PIO device */
 	pit->dev.read = pit_ioport_read;
 	pit->dev.write = pit_ioport_write;
 	pit->dev.in_range = pit_in_range;
 	pit->dev.private = pit;
-	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	ret = kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	if (ret < 0)
+		goto fail;
 
 	pit->speaker_dev.read = speaker_ioport_read;
 	pit->speaker_dev.write = speaker_ioport_write;
 	pit->speaker_dev.in_range = speaker_in_range;
 	pit->speaker_dev.private = pit;
-	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+	ret = kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+	if (ret < 0)
+		goto fail;
+
+	mutex_init(&pit->pit_state.lock);
+	mutex_lock(&pit->pit_state.lock);
+	spin_lock_init(&pit->pit_state.inject_lock);
 
 	kvm->arch.vpit = pit;
 	pit->kvm = kvm;
@@ -611,6 +614,10 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
 	return pit;
+
+fail:
+	kfree(pit);
+	return NULL;
 }
 
 void kvm_free_pit(struct kvm *kvm)
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 1ccb50c..0caf7d4 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -519,6 +519,8 @@ static void pic_irq_request(void *opaque, int level)
 struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 {
 	struct kvm_pic *s;
+	int ret;
+
 	s = kzalloc(sizeof(struct kvm_pic), GFP_KERNEL);
 	if (!s)
 		return NULL;
@@ -538,6 +540,11 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 	s->dev.write = picdev_write;
 	s->dev.in_range = picdev_in_range;
 	s->dev.private = s;
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
index 28bd112..5289552 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -61,8 +61,8 @@ void kvm_io_bus_init(struct kvm_io_bus *bus);
 void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 					  gpa_t addr, int len, int is_write);
-void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
-			     struct kvm_io_device *dev);
+int kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+			    struct kvm_io_device *dev);
 
 struct kvm_vcpu {
 	struct kvm *kvm;
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 5ae620d..ede9087 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -86,6 +86,7 @@ static void coalesced_mmio_destructor(struct kvm_io_device *this)
 int kvm_coalesced_mmio_init(struct kvm *kvm)
 {
 	struct kvm_coalesced_mmio_dev *dev;
+	int ret;
 
 	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
 	if (!dev)
@@ -96,9 +97,12 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	dev->dev.private  = dev;
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
index 1eddae9..9be89f5 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -317,6 +317,7 @@ void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
 int kvm_ioapic_init(struct kvm *kvm)
 {
 	struct kvm_ioapic *ioapic;
+	int ret;
 
 	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
 	if (!ioapic)
@@ -328,7 +329,11 @@ int kvm_ioapic_init(struct kvm *kvm)
 	ioapic->dev.in_range = ioapic_in_range;
 	ioapic->dev.private = ioapic;
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
index de042cb..c71f276 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2463,11 +2463,14 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 	return NULL;
 }
 
-void kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
+int kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
 {
-	BUG_ON(bus->dev_count > (NR_IOBUS_DEVS-1));
+	if (bus->dev_count > (NR_IOBUS_DEVS-1))
+		return -ENOSPC;
 
 	bus->devs[bus->dev_count++] = dev;
+
+	return 0;
 }
 
 static struct notifier_block kvm_cpu_notifier = {

