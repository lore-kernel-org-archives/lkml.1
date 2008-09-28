Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbYI1PsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbYI1PsU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYI1Ppb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50856 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYI1PpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:24 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 09/25] KVM: ppc: kvmppc_44x_shadow_release() does not require mmap_sem to be locked
Date: Sun, 28 Sep 2008 18:44:45 +0300
Message-Id: <1222616701-1206-10-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

And it gets in the way of get_user_pages_fast().

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/kvm/44x_tlb.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 3594bbd..7b11fd7 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -110,7 +110,6 @@ static int kvmppc_44x_tlbe_is_writable(struct tlbe *tlbe)
 	return tlbe->word2 & (PPC44x_TLB_SW|PPC44x_TLB_UW);
 }
 
-/* Must be called with mmap_sem locked for writing. */
 static void kvmppc_44x_shadow_release(struct kvm_vcpu *vcpu,
                                       unsigned int index)
 {
@@ -150,17 +149,16 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 	/* Get reference to new page. */
 	down_read(&current->mm->mmap_sem);
 	new_page = gfn_to_page(vcpu->kvm, gfn);
+	up_read(&current->mm->mmap_sem);
 	if (is_error_page(new_page)) {
 		printk(KERN_ERR "Couldn't get guest page for gfn %lx!\n", gfn);
 		kvm_release_page_clean(new_page);
-		up_read(&current->mm->mmap_sem);
 		return;
 	}
 	hpaddr = page_to_phys(new_page);
 
 	/* Drop reference to old page. */
 	kvmppc_44x_shadow_release(vcpu, victim);
-	up_read(&current->mm->mmap_sem);
 
 	vcpu->arch.shadow_pages[victim] = new_page;
 
@@ -194,7 +192,6 @@ void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
 	int i;
 
 	/* XXX Replace loop with fancy data structures. */
-	down_write(&current->mm->mmap_sem);
 	for (i = 0; i <= tlb_44x_hwater; i++) {
 		struct tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
 		unsigned int tid;
@@ -219,7 +216,6 @@ void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
 				stlbe->tid, stlbe->word0, stlbe->word1,
 				stlbe->word2, handler);
 	}
-	up_write(&current->mm->mmap_sem);
 }
 
 /* Invalidate all mappings on the privilege switch after PID has been changed.
@@ -231,7 +227,6 @@ void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 
 	if (vcpu->arch.swap_pid) {
 		/* XXX Replace loop with fancy data structures. */
-		down_write(&current->mm->mmap_sem);
 		for (i = 0; i <= tlb_44x_hwater; i++) {
 			struct tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
 
@@ -243,7 +238,6 @@ void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 			            stlbe->tid, stlbe->word0, stlbe->word1,
 			            stlbe->word2, handler);
 		}
-		up_write(&current->mm->mmap_sem);
 		vcpu->arch.swap_pid = 0;
 	}
 
-- 
1.6.0.1

