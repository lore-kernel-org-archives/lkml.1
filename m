Return-Path: <linux-kernel-owner+w=401wt.eu-S1762950AbZEOQ3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762950AbZEOQ3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762601AbZEOQ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:28:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42991 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762915AbZEOQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:28:30 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 2/4] kvm: add return value to kvm_io_bus_register_dev
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Date: Fri, 15 May 2009 12:28:13 -0400
Message-ID: <20090515162813.26209.49515.stgit@dev.haskins.net>
In-Reply-To: <20090515162047.26209.93545.stgit@dev.haskins.net>
References: <20090515162047.26209.93545.stgit@dev.haskins.net>
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

We also fix up all the callsites to check the return code and BUG_ON if
it fails.

The net result should be identical behavior both before and after this
patch.  We are simply laying the groundwork for the dynamic usage

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 arch/x86/kvm/i8254.c      |    7 +++++--
 arch/x86/kvm/i8259.c      |    5 ++++-
 include/linux/kvm_host.h  |    4 ++--
 virt/kvm/coalesced_mmio.c |    4 +++-
 virt/kvm/ioapic.c         |    4 +++-
 virt/kvm/kvm_main.c       |    7 +++++--
 6 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 4d6f0d2..cc274d6 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -564,6 +564,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
 {
 	struct kvm_pit *pit;
 	struct kvm_kpit_state *pit_state;
+	int ret;
 
 	pit = kzalloc(sizeof(struct kvm_pit), GFP_KERNEL);
 	if (!pit)
@@ -584,13 +585,15 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
 	pit->dev.write = pit_ioport_write;
 	pit->dev.in_range = pit_in_range;
 	pit->dev.private = pit;
-	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	ret = kvm_io_bus_register_dev(&kvm->pio_bus, &pit->dev);
+	BUG_ON(ret < 0);
 
 	pit->speaker_dev.read = speaker_ioport_read;
 	pit->speaker_dev.write = speaker_ioport_write;
 	pit->speaker_dev.in_range = speaker_in_range;
 	pit->speaker_dev.private = pit;
-	kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+	ret = kvm_io_bus_register_dev(&kvm->pio_bus, &pit->speaker_dev);
+	BUG_ON(ret < 0);
 
 	kvm->arch.vpit = pit;
 	pit->kvm = kvm;
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 1ccb50c..7d39b5b 100644
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
@@ -538,6 +540,7 @@ struct kvm_pic *kvm_create_pic(struct kvm *kvm)
 	s->dev.write = picdev_write;
 	s->dev.in_range = picdev_in_range;
 	s->dev.private = s;
-	kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
+	ret = kvm_io_bus_register_dev(&kvm->pio_bus, &s->dev);
+	BUG_ON(ret < 0);
 	return s;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index dc91610..94c1a11 100644
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
index 5ae620d..19945e1 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -86,6 +86,7 @@ static void coalesced_mmio_destructor(struct kvm_io_device *this)
 int kvm_coalesced_mmio_init(struct kvm *kvm)
 {
 	struct kvm_coalesced_mmio_dev *dev;
+	int ret;
 
 	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
 	if (!dev)
@@ -96,7 +97,8 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 	dev->dev.private  = dev;
 	dev->kvm = kvm;
 	kvm->coalesced_mmio_dev = dev;
-	kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
+	ret = kvm_io_bus_register_dev(&kvm->mmio_bus, &dev->dev);
+	BUG_ON(ret < 0);
 
 	return 0;
 }
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 1eddae9..3eee4c9 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -317,6 +317,7 @@ void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
 int kvm_ioapic_init(struct kvm *kvm)
 {
 	struct kvm_ioapic *ioapic;
+	int ret;
 
 	ioapic = kzalloc(sizeof(struct kvm_ioapic), GFP_KERNEL);
 	if (!ioapic)
@@ -328,7 +329,8 @@ int kvm_ioapic_init(struct kvm *kvm)
 	ioapic->dev.in_range = ioapic_in_range;
 	ioapic->dev.private = ioapic;
 	ioapic->kvm = kvm;
-	kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
+	ret = kvm_io_bus_register_dev(&kvm->mmio_bus, &ioapic->dev);
+	BUG_ON(ret < 0);
 	return 0;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b2db766..60ba0cf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2461,11 +2461,14 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct kvm_io_bus *bus,
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

