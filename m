Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128Ab0AEAtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab0AEAtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837Ab0AEAtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:49:21 -0500
Received: from kroah.org ([198.145.64.141]:34217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab0AEAfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
       Avi Kivity <avi@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/97] KVM: MMU: remove prefault from invlpg handler
Date: Mon,  4 Jan 2010 16:32:50 -0800
Message-Id: <1262651630-7354-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

commit fb341f572d26e0786167cd96b90cc4febed830cf upstream.

The invlpg prefault optimization breaks Windows 2008 R2 occasionally.

The visible effect is that the invlpg handler instantiates a pte which
is, microseconds later, written with a different gfn by another vcpu.

The OS could have other mechanisms to prevent a present translation from
being used, which the hypervisor is unaware of.

While the documentation states that the cpu is at liberty to prefetch tlb
entries, it looks like this is not heeded, so remove tlb prefetch from
invlpg.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/paging_tmpl.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 72558f8..85e12cd 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -455,8 +455,6 @@ out_unlock:
 static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	pt_element_t gpte;
-	gpa_t pte_gpa = -1;
 	int level;
 	u64 *sptep;
 	int need_flush = 0;
@@ -471,10 +469,6 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		if (level == PT_PAGE_TABLE_LEVEL  ||
 		    ((level == PT_DIRECTORY_LEVEL && is_large_pte(*sptep))) ||
 		    ((level == PT_PDPE_LEVEL && is_large_pte(*sptep)))) {
-			struct kvm_mmu_page *sp = page_header(__pa(sptep));
-
-			pte_gpa = (sp->gfn << PAGE_SHIFT);
-			pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
 
 			if (is_shadow_present_pte(*sptep)) {
 				rmap_remove(vcpu->kvm, sptep);
@@ -493,18 +487,6 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 	if (need_flush)
 		kvm_flush_remote_tlbs(vcpu->kvm);
 	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	if (pte_gpa == -1)
-		return;
-	if (kvm_read_guest_atomic(vcpu->kvm, pte_gpa, &gpte,
-				  sizeof(pt_element_t)))
-		return;
-	if (is_present_gpte(gpte) && (gpte & PT_ACCESSED_MASK)) {
-		if (mmu_topup_memory_caches(vcpu))
-			return;
-		kvm_mmu_pte_write(vcpu, pte_gpa, (const u8 *)&gpte,
-				  sizeof(pt_element_t), 0);
-	}
 }
 
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr)
-- 
1.6.6

