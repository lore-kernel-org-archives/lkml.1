Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbZFSAbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbZFSAbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZFSAax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:30:53 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36219 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbZFSAav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:30:51 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v8 2/3] KVM: add per-vm limit on the maximum number of
	io-devices supported
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
       paulmck@linux.vnet.ibm.com, markmc@redhat.com
Date: Thu, 18 Jun 2009 20:30:40 -0400
Message-ID: <20090619003040.15859.87747.stgit@dev.haskins.net>
In-Reply-To: <20090619002224.15859.97977.stgit@dev.haskins.net>
References: <20090619002224.15859.97977.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a .config option for setting a upper resource limit on
the number of iodevice-like constructs that can be allocated on a per-guest
basis.  It also adds a per-vm variable (io_device_count) that tracks
the aggregate number of io_devices registered.  Today this is limited
purely to PIO/MMIO devices, though it is intended that this will grow in
the future (such as including iosignalfd aliases, etc).

This patch has no bearing on the number of devices that a given subsystem
may _actually_ support, so other limits may be in play at any given moment.
For instance, each PIO/MMIO bus is currently limited to 6 devices max.  This
will likely need to change soon to accomodate upcoming features, but that
work is beyond the scope of this patch.

The primary point of this patch is to offer a single, easy to understand
upper limit on the number of kmalloc's that may occur as the result of a
userspace request.  In this way, we are free to design future io subsystems
with arbitrary constructs (such as lists and btrees) and to know that they
will not be allowed to grow without bound in a way that the userspace side
should hopefully understand.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/Kconfig      |    8 ++++++++
 arch/x86/kvm/i8254.c      |    9 +++++----
 arch/x86/kvm/i8259.c      |    2 +-
 include/linux/kvm_host.h  |    9 ++++++---
 virt/kvm/coalesced_mmio.c |    2 +-
 virt/kvm/ioapic.c         |    2 +-
 virt/kvm/kvm_main.c       |   12 ++++++++++--
 7 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 7fbedfd..0fcf660 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -74,6 +74,14 @@ config KVM_TRACE
 	  relayfs.  Note the ABI is not considered stable and will be
 	  modified in future updates.
 
+config KVM_MAX_IO_DEVICES
+	int "Maximum IO devices support per VM"
+	depends on KVM
+	default "256"
+	---help---
+	  This option influences the maximum number of MMIO, PIO, and other
+	  io-devices that can simultaneously register on a per-guest basis.
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/lguest/Kconfig
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 1c41715..f24a8ea 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -621,13 +621,13 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
 	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
-	ret = kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	ret = kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &pit->dev);
 	if (ret < 0)
 		goto fail;
 
 	if (flags & KVM_PIT_SPEAKER_DUMMY) {
 		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
-		ret = kvm_io_bus_register_dev(&kvm->pio_bus,
+		ret = kvm_io_bus_register_dev(kvm, &kvm->pio_bus,
 					      &pit->speaker_dev);
 		if (ret < 0)
 			goto fail;
@@ -637,9 +637,10 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 
 fail:
 	if (flags & KVM_PIT_SPEAKER_DUMMY)
-		kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->speaker_dev);
+		kvm_io_bus_unregister_dev(kvm, &kvm->pio_bus,
+					  &pit->speaker_dev);
 
-	kvm_io_bus_unregister_dev(&kvm->pio_bus, &pit->dev);
+	kvm_io_bus_unregister_dev(kvm, &kvm->pio_bus, &pit->dev);
 
 	if (pit->irq_source_id >= 0)
 		kvm_free_irq_source_id(kvm, pit->irq_source_id);
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 66e37c2..cfe3433 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -550,7 +550,7 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 	 * Initialize PIO device
 	 */
 	kvm_iodevice_init(&s->dev, &picdev_ops);
-	ret = kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
+	ret = kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &s->dev);
 	if (ret < 0) {
 		kfree(s);
 		return NULL;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eafa2b3..707c4d8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -61,10 +61,12 @@ void kvm_io_bus_init(struct kvm_io_bus *bus);
 void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 					  gpa_t addr, int len, int is_write);
-int kvm_io_bus_register_dev(struct kvm_io_bus *bus,
-			    struct kvm_io_device *dev);
-void kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
+int kvm_io_bus_register_dev(struct kvm *kvm,
+			    struct kvm_io_bus *bus,
 			    struct kvm_io_device *dev);
+void kvm_io_bus_unregister_dev(struct kvm *kvm,
+			       struct kvm_io_bus *bus,
+			       struct kvm_io_device *dev);
 
 struct kvm_vcpu {
 	struct kvm *kvm;
@@ -139,6 +141,7 @@ struct kvm {
 	atomic_t online_vcpus;
 	struct list_head vm_list;
 	struct mutex lock;
+	unsigned long io_device_count;
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
 #ifdef CONFIG_HAVE_KVM_EVENTFD
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 3e89db8..09aae26 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -104,7 +104,7 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	dev->kvm = kvm;
 	kvm->coalesced_mmio_dev = dev;
 
-	ret = kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
+	ret = kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &dev->dev);
 	if (ret < 0)
 		kfree(dev);
 
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 28adb05..bc7ad68 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -345,7 +345,7 @@ int kvm_ioapic_init(struct kvm *kvm)
 	kvm_iodevice_init(&ioapic->dev, &ioapic_mmio_ops);
 	ioapic->kvm = kvm;
 
-	ret = kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
+	ret = kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &ioapic->dev);
 	if (ret < 0)
 		kfree(ioapic);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6bd71f7..42cbea7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2482,18 +2482,25 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 }
 
 /* assumes kvm->lock held */
-int kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
+int kvm_io_bus_register_dev(struct kvm *kvm,
+			    struct kvm_io_bus *bus,
+			    struct kvm_io_device *dev)
 {
 	if (bus->dev_count > (NR_IOBUS_DEVS-1))
 		return -ENOSPC;
 
+	if (kvm->io_device_count >= CONFIG_KVM_MAX_IO_DEVICES)
+		return -ENOSPC;
+
 	bus->devs[bus->dev_count++] = dev;
+	kvm->io_device_count++;
 
 	return 0;
 }
 
 /* assumes kvm->lock held */
-void kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
+void kvm_io_bus_unregister_dev(struct kvm *kvm,
+			       struct kvm_io_bus *bus,
 			       struct kvm_io_device *dev)
 {
 	int i;
@@ -2502,6 +2509,7 @@ void kvm_io_bus_unregister_dev(struct kvm_io_bus *bus,
 
 		if (bus->devs[i] == dev) {
 			bus->devs[i] = bus->devs[--bus->dev_count];
+			kvm->io_device_count--;
 			return;
 		}
 	}

