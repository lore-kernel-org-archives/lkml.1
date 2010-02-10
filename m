Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab0BJR3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:29:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/40] KVM: Disentangle mmu notifiers and coalesced_mmio registration
Date: Wed, 10 Feb 2010 19:22:45 +0200
Message-Id: <1265822589-11155-17-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They aren't related.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a944be3..92f5c98 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -374,17 +374,16 @@ static struct kvm *kvm_create_vm(void)
 #endif
 
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
-	{
-		kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
-		r = mmu_notifier_register(&kvm->mmu_notifier, current->mm);
-		if (r) {
+	kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
+	r = mmu_notifier_register(&kvm->mmu_notifier, current->mm);
+#endif
+
+	if (r) {
 #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
-			put_page(page);
+		put_page(page);
 #endif
-			goto out_err;
-		}
+		goto out_err;
 	}
-#endif
 
 	kvm->mm = current->mm;
 	atomic_inc(&kvm->mm->mm_count);
@@ -406,11 +405,8 @@ static struct kvm *kvm_create_vm(void)
 out:
 	return kvm;
 
-#if defined(KVM_COALESCED_MMIO_PAGE_OFFSET) || \
-    (defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER))
 out_err:
 	hardware_disable_all();
-#endif
 out_err_nodisable:
 	kfree(kvm);
 	return ERR_PTR(r);
-- 
1.6.5.3

