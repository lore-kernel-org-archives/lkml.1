Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbZF2MKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbZF2MKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbZF2MJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:09:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58036 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397AbZF2MJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:09:41 -0400
Date: Mon, 29 Jun 2009 15:09:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: [PATCHv3 3/4] kvm: convert bus to slots_lock
Message-ID: <20090629120911.GD21273@redhat.com>
References: <cover.1246276816.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1246276816.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use slots_lock to protect device list on the bus.  slots_lock is already
taken for read everywhere, so we only need to take it for write when
registering devices.  This is in preparation to removing in_range and
kvm->lock around it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/i8254.c     |    4 ++--
 arch/x86/kvm/i8259.c     |    2 +-
 include/linux/kvm_host.h |    3 ++-
 virt/kvm/ioapic.c        |    2 +-
 virt/kvm/kvm_main.c      |    5 ++++-
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 331705f..c2387ec 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -620,11 +620,11 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 	kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 
 	kvm_iodevice_init(&pit->dev, &pit_dev_ops);
-	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &pit->dev);
 
 	if (flags & KVM_PIT_SPEAKER_DUMMY) {
 		kvm_iodevice_init(&pit->speaker_dev, &speaker_dev_ops);
-		kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+		kvm_io_bus_register_dev(kvm, &kvm->pio_bus, &pit->speaker_dev);
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
index 2451f48..8b1ee3f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -42,6 +42,7 @@
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID	0
 
+struct kvm;
 struct kvm_vcpu;
 extern struct kmem_cache *kvm_vcpu_cache;
 
@@ -61,7 +62,7 @@ void kvm_io_bus_init(struct kvm_io_bus *bus);
 void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 					  gpa_t addr, int len, int is_write);
-void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
+void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
 			     struct kvm_io_device *dev);
 
 struct kvm_vcpu {
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index d8b2eca..ad80ead 100644
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
index 58d6bc6..7bb2821 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2499,11 +2499,14 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
 	return NULL;
 }
 
-void kvm_io_bus_register_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev)
+void kvm_io_bus_register_dev(struct kvm *kvm, struct kvm_io_bus *bus,
+			     struct kvm_io_device *dev)
 {
+	down_write(&kvm->slots_lock);
 	BUG_ON(bus->dev_count > (NR_IOBUS_DEVS-1));
 
 	bus->devs[bus->dev_count++] = dev;
+	up_write(&kvm->slots_lock);
 }
 
 static struct notifier_block kvm_cpu_notifier = {
-- 
1.6.2.2

