Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZBZOTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZBZOTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbZBZOP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:15:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43055 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbZBZOPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/40] KVM: MMU: Initialize a shadow page's global attribute from cr4.pge
Date: Thu, 26 Feb 2009 16:15:12 +0200
Message-Id: <1235657730-27683-23-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If cr4.pge is cleared, we ought to treat any ptes in the page as non-global.
This allows us to remove the check from set_spte().

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f15023c..5f03ec3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -797,7 +797,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	ASSERT(is_empty_shadow_page(sp->spt));
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
-	sp->global = 1;
 	sp->parent_pte = parent_pte;
 	--vcpu->kvm->arch.n_free_mmu_pages;
 	return sp;
@@ -1241,6 +1240,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	pgprintk("%s: adding gfn %lx role %x\n", __func__, gfn, role.word);
 	sp->gfn = gfn;
 	sp->role = role;
+	sp->global = role.cr4_pge;
 	hlist_add_head(&sp->hash_link, bucket);
 	if (!metaphysical) {
 		if (rmap_write_protect(vcpu->kvm, gfn))
@@ -1668,8 +1668,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *shadow_pte,
 	u64 mt_mask = shadow_mt_mask;
 	struct kvm_mmu_page *sp = page_header(__pa(shadow_pte));
 
-	if (!(vcpu->arch.cr4 & X86_CR4_PGE))
-		global = 0;
 	if (!global && sp->global) {
 		sp->global = 0;
 		if (sp->unsync) {
-- 
1.6.0.6

