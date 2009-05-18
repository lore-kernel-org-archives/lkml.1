Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbZERJbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbZERJbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZERJXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:23:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38416 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbZERJXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:23:10 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 31/43] KVM: MMU: do not free active mmu pages in free_mmu_pages()
Date: Mon, 18 May 2009 12:22:53 +0300
Message-Id: <1242638585-18470-32-git-send-email-avi@redhat.com>
In-Reply-To: <1242638585-18470-1-git-send-email-avi@redhat.com>
References: <1242638585-18470-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

free_mmu_pages() should only undo what alloc_mmu_pages() does.
Free mmu pages from the generic VM destruction function, kvm_destroy_vm().

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c  |    8 --------
 virt/kvm/kvm_main.c |    2 ++
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b6caf13..9256484 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2638,14 +2638,6 @@ EXPORT_SYMBOL_GPL(kvm_disable_tdp);
 
 static void free_mmu_pages(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu_page *sp;
-
-	while (!list_empty(&vcpu->kvm->arch.active_mmu_pages)) {
-		sp = container_of(vcpu->kvm->arch.active_mmu_pages.next,
-				  struct kvm_mmu_page, link);
-		kvm_mmu_zap_page(vcpu->kvm, sp);
-		cond_resched();
-	}
 	free_page((unsigned long)vcpu->arch.mmu.pae_root);
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 231ca3c..7379eab 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1032,6 +1032,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #endif
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
+#else
+	kvm_arch_flush_shadow(kvm);
 #endif
 	kvm_arch_destroy_vm(kvm);
 	mmdrop(mm);
-- 
1.6.0.6

