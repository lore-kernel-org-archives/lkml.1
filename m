Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0BJR2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:28:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/40] KVM: Remove ifdefs from mmu notifier initialization
Date: Wed, 10 Feb 2010 19:22:47 +0200
Message-Id: <1265822589-11155-19-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 92f5c98..c10d117 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -341,6 +341,20 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 	.change_pte		= kvm_mmu_notifier_change_pte,
 	.release		= kvm_mmu_notifier_release,
 };
+
+static int kvm_init_mmu_notifier(struct kvm *kvm)
+{
+	kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
+	return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
+}
+
+#else  /* !(CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER) */
+
+static int kvm_init_mmu_notifier(struct kvm *kvm)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
 static struct kvm *kvm_create_vm(void)
@@ -373,11 +387,7 @@ static struct kvm *kvm_create_vm(void)
 			(struct kvm_coalesced_mmio_ring *)page_address(page);
 #endif
 
-#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
-	kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
-	r = mmu_notifier_register(&kvm->mmu_notifier, current->mm);
-#endif
-
+	r = kvm_init_mmu_notifier(kvm);
 	if (r) {
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
 		put_page(page);
-- 
1.6.5.3

