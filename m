Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbZEZTgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbZEZTgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbZEZTgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:36:18 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35508 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbZEZTgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:36:17 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v4 2/3] kvm: make io_bus interface more robust
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davide@xmailserver.org,
       mtosatti@redhat.com
Date: Tue, 26 May 2009 15:15:34 -0400
Message-ID: <20090526191534.20860.38511.stgit@dev.haskins.net>
In-Reply-To: <20090526191010.20860.75372.stgit@dev.haskins.net>
References: <20090526191010.20860.75372.stgit@dev.haskins.net>
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
   3) Refactor io_bus to allow "holes" in the array so device hotplug
      can add/remove devices arbitrarily.
   4) Add an unregister function

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/i8254.c      |   34 ++++++++++++++++++++++---------
 arch/x86/kvm/i8259.c      |    9 +++++++-
 include/linux/kvm_host.h  |    8 +++++--
 virt/kvm/coalesced_mmio.c |    8 ++++++-
 virt/kvm/ioapic.c         |    9 ++++++--
 virt/kvm/kvm_main.c       |   49 +++++++++++++++++++++++++++++++++++++++------
 6 files changed, 92 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 584e3d3..6cf84d4 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -564,36 +564,40 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
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
 
 	if (flags & KVM_PIT_SPEAKER_DUMMY) {
 		pit->speaker_dev.read = speaker_ioport_read;
 		pit->speaker_dev.write = speaker_ioport_write;
 		pit->speaker_dev.in_range = speaker_in_range;
 		pit->speaker_dev.private = pit;
-		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+		ret = kvm_io_bus_register_dev(&kvm->pio_bus,
+					      &pit->speaker_dev);
+		if (ret < 0)
+			goto fail;
 	}
 
+	mutex_init(&pit->pit_state.lock);
+	mutex_lock(&pit->pit_state.lock);
+	spin_lock_init(&pit->pit_state.inject_lock);
+
 	kvm->arch.vpit = pit;
 	pit->kvm = kvm;
 
@@ -613,6 +617,16 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
 	return pit;
+
+fail:
+	kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->speaker_dev);
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
index 28bd112..7dcae4b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -52,7 +52,7 @@ extern struct kmem_cache *kvm_vcpu_cache;
  * in one place.
  */
 struct kvm_io_bus {
-	int                   dev_count;
+	spinlock_t lock;
 #define NR_IOBUS_DEVS 6
 	struct kvm_io_device *devs[NR_IOBUS_DEVS];
 };
@@ -61,8 +61,10 @@ void kvm_io_bus_init(struct kvm_io_bus *bus);
 void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 					  gpa_t addr, int len, int is_write);
-void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
-			     struct kvm_io_device *dev);
+int kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+			    struct kvm_io_device *dev);
+int kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
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
index de042cb..4c36ac8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2435,16 +2435,18 @@ static struct notifier_block kvm_reboot_notifier = {
 void kvm_io_bus_init(struct kvm_io_bus *bus)
 {
 	memset(bus, 0, sizeof(*bus));
+	spin_lock_init(&bus->lock);
 }
 
 void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 {
 	int i;
 
-	for (i = 0; i < bus->dev_count; i++) {
+	for (i = 0; i < NR_IOBUS_DEVS; i++) {
 		struct kvm_io_device *pos = bus->devs[i];
 
-		kvm_iodevice_destructor(pos);
+		if (pos)
+			kvm_iodevice_destructor(pos);
 	}
 }
 
@@ -2453,21 +2455,54 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 {
 	int i;
 
-	for (i = 0; i < bus->dev_count; i++) {
+	for (i = 0; i < NR_IOBUS_DEVS; i++) {
 		struct kvm_io_device *pos = bus->devs[i];
 
-		if (pos->in_range(pos, addr, len, is_write))
+		if (pos && pos->in_range(pos, addr, len, is_write))
 			return pos;
 	}
 
 	return NULL;
 }
 
-void kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
+int kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
 {
-	BUG_ON(bus->dev_count > (NR_IOBUS_DEVS-1));
+	int i;
+
+	spin_lock(&bus->lock);
+
+	for (i = 0; i < NR_IOBUS_DEVS; i++) {
+		if (bus->devs[i])
+			continue;
+
+		bus->devs[i] = dev;
+		spin_unlock(&bus->lock);
+		return 0;
+	}
+
+	spin_unlock(&bus->lock);
+
+	return -ENOSPC;
+}
+
+int kvm_io_bus_unregister_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
+{
+	int i;
+
+	spin_lock(&bus->lock);
+
+	for (i = 0; i < NR_IOBUS_DEVS; i++) {
+
+		if (bus->devs[i] == dev) {
+			bus->devs[i] = NULL;
+			spin_unlock(&bus->lock);
+			return 0;
+		}
+	}
+
+	spin_unlock(&bus->lock);
 
-	bus->devs[bus->dev_count++] = dev;
+	return -ENOENT;
 }
 
 static struct notifier_block kvm_cpu_notifier = {

