Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0BJR2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:28:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/40] KVM: Simplify coalesced mmio initialization
Date: Wed, 10 Feb 2010 19:22:49 +0200
Message-Id: <1265822589-11155-21-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add destructor function
- move related allocation into constructor
- add stubs for !CONFIG_KVM_MMIO

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/coalesced_mmio.c |   25 +++++++++++++++++++++++--
 virt/kvm/coalesced_mmio.h |   10 ++++++++++
 virt/kvm/kvm_main.c       |    7 +------
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 04d69cd..d68e6c6 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -92,11 +92,19 @@ static const struct kvm_io_device_ops coalesced_mmio_ops = {
 int kvm_coalesced_mmio_init(struct kvm *kvm)
 {
 	struct kvm_coalesced_mmio_dev *dev;
+	struct page *page;
 	int ret;
 
+	ret = -ENOMEM;
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		goto out_err;
+	kvm->coalesced_mmio_ring = page_address(page);
+
+	ret = -ENOMEM;
 	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
 	if (!dev)
-		return -ENOMEM;
+		goto out_free_page;
 	spin_lock_init(&dev->lock);
 	kvm_iodevice_init(&dev->dev, &coalesced_mmio_ops);
 	dev->kvm = kvm;
@@ -104,11 +112,24 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
 
 	ret = kvm_io_bus_register_dev(kvm, &kvm->mmio_bus, &dev->dev);
 	if (ret < 0)
-		kfree(dev);
+		goto out_free_dev;
+
+	return ret;
 
+out_free_dev:
+	kfree(dev);
+out_free_page:
+	__free_page(page);
+out_err:
 	return ret;
 }
 
+void kvm_coalesced_mmio_free(struct kvm *kvm)
+{
+	if (kvm->coalesced_mmio_ring)
+		free_page((unsigned long)kvm->coalesced_mmio_ring);
+}
+
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
 				         struct kvm_coalesced_mmio_zone *zone)
 {
diff --git a/virt/kvm/coalesced_mmio.h b/virt/kvm/coalesced_mmio.h
index e703346..8a5959e 100644
--- a/virt/kvm/coalesced_mmio.h
+++ b/virt/kvm/coalesced_mmio.h
@@ -10,6 +10,8 @@
  *
  */
 
+#ifdef CONFIG_KVM_MMIO
+
 #define KVM_COALESCED_MMIO_ZONE_MAX 100
 
 struct kvm_coalesced_mmio_dev {
@@ -21,9 +23,17 @@ struct kvm_coalesced_mmio_dev {
 };
 
 int kvm_coalesced_mmio_init(struct kvm *kvm);
+void kvm_coalesced_mmio_free(struct kvm *kvm);
 int kvm_vm_ioctl_register_coalesced_mmio(struct kvm *kvm,
                                        struct kvm_coalesced_mmio_zone *zone);
 int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
                                          struct kvm_coalesced_mmio_zone *zone);
 
+#else
+
+static inline int kvm_coalesced_mmio_init(struct kvm *kvm) { return 0; }
+static inline void kvm_coalesced_mmio_free(struct kvm *kvm) { }
+
+#endif
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c10d117..bc23b8e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -51,9 +51,7 @@
 #include <asm/pgtable.h>
 #include <asm-generic/bitops/le.h>
 
-#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 #include "coalesced_mmio.h"
-#endif
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/kvm.h>
@@ -468,10 +466,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_free_irq_routing(kvm);
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
-#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
-	if (kvm->coalesced_mmio_ring != NULL)
-		free_page((unsigned long)kvm->coalesced_mmio_ring);
-#endif
+	kvm_coalesced_mmio_free(kvm);
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
 #else
-- 
1.6.5.3

