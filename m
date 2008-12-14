Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbYLNIQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbYLNIQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYLNIHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59933 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbYLNIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:17 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 35/36] KVM: MMU: prepopulate the shadow on invlpg
Date: Sun, 14 Dec 2008 10:07:08 +0200
Message-Id: <1229242029-13410-36-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

If the guest executes invlpg, peek into the pagetable and attempt to
prepopulate the shadow entry.

Also stop dirty fault updates from interfering with the fork detector.

2% improvement on RHEL3/AIM7.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    3 ++-
 arch/x86/kvm/mmu.c              |   25 +++++++++++++------------
 arch/x86/kvm/paging_tmpl.h      |   25 ++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |    2 +-
 4 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 65b1ed2..97215a4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -602,7 +602,8 @@ unsigned long segment_base(u16 selector);
 
 void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu);
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-		       const u8 *new, int bytes);
+		       const u8 *new, int bytes,
+		       bool guest_initiated);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cbac9e4..863baf7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2441,7 +2441,8 @@ static void kvm_mmu_access_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 }
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
-		       const u8 *new, int bytes)
+		       const u8 *new, int bytes,
+		       bool guest_initiated)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *sp;
@@ -2467,15 +2468,17 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
 	kvm_mmu_audit(vcpu, "pre pte write");
-	if (gfn == vcpu->arch.last_pt_write_gfn
-	    && !last_updated_pte_accessed(vcpu)) {
-		++vcpu->arch.last_pt_write_count;
-		if (vcpu->arch.last_pt_write_count >= 3)
-			flooded = 1;
-	} else {
-		vcpu->arch.last_pt_write_gfn = gfn;
-		vcpu->arch.last_pt_write_count = 1;
-		vcpu->arch.last_pte_updated = NULL;
+	if (guest_initiated) {
+		if (gfn == vcpu->arch.last_pt_write_gfn
+		    && !last_updated_pte_accessed(vcpu)) {
+			++vcpu->arch.last_pt_write_count;
+			if (vcpu->arch.last_pt_write_count >= 3)
+				flooded = 1;
+		} else {
+			vcpu->arch.last_pt_write_gfn = gfn;
+			vcpu->arch.last_pt_write_count = 1;
+			vcpu->arch.last_pte_updated = NULL;
+		}
 	}
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
@@ -2615,9 +2618,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	spin_lock(&vcpu->kvm->mmu_lock);
 	vcpu->arch.mmu.invlpg(vcpu, gva);
-	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_flush_tlb(vcpu);
 	++vcpu->stat.invlpg;
 }
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index e644d81..d206401 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -82,6 +82,7 @@ struct shadow_walker {
 	int *ptwrite;
 	pfn_t pfn;
 	u64 *sptep;
+	gpa_t pte_gpa;
 };
 
 static gfn_t gpte_to_gfn(pt_element_t gpte)
@@ -222,7 +223,7 @@ walk:
 		if (ret)
 			goto walk;
 		pte |= PT_DIRTY_MASK;
-		kvm_mmu_pte_write(vcpu, pte_gpa, (u8 *)&pte, sizeof(pte));
+		kvm_mmu_pte_write(vcpu, pte_gpa, (u8 *)&pte, sizeof(pte), 0);
 		walker->ptes[walker->level - 1] = pte;
 	}
 
@@ -468,8 +469,15 @@ static int FNAME(shadow_invlpg_entry)(struct kvm_shadow_walk *_sw,
 				      struct kvm_vcpu *vcpu, u64 addr,
 				      u64 *sptep, int level)
 {
+	struct shadow_walker *sw =
+		container_of(_sw, struct shadow_walker, walker);
 
 	if (level == PT_PAGE_TABLE_LEVEL) {
+		struct kvm_mmu_page *sp = page_header(__pa(sptep));
+
+		sw->pte_gpa = (sp->gfn << PAGE_SHIFT);
+		sw->pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
+
 		if (is_shadow_present_pte(*sptep))
 			rmap_remove(vcpu->kvm, sptep);
 		set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
@@ -482,11 +490,26 @@ static int FNAME(shadow_invlpg_entry)(struct kvm_shadow_walk *_sw,
 
 static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 {
+	pt_element_t gpte;
 	struct shadow_walker walker = {
 		.walker = { .entry = FNAME(shadow_invlpg_entry), },
+		.pte_gpa = -1,
 	};
 
+	spin_lock(&vcpu->kvm->mmu_lock);
 	walk_shadow(&walker.walker, vcpu, gva);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	if (walker.pte_gpa == -1)
+		return;
+	if (kvm_read_guest_atomic(vcpu->kvm, walker.pte_gpa, &gpte,
+				  sizeof(pt_element_t)))
+		return;
+	if (is_present_pte(gpte) && (gpte & PT_ACCESSED_MASK)) {
+		if (mmu_topup_memory_caches(vcpu))
+			return;
+		kvm_mmu_pte_write(vcpu, walker.pte_gpa, (const u8 *)&gpte,
+				  sizeof(pt_element_t), 0);
+	}
 }
 
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 774db00..ba10287 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2046,7 +2046,7 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
 	if (ret < 0)
 		return 0;
-	kvm_mmu_pte_write(vcpu, gpa, val, bytes);
+	kvm_mmu_pte_write(vcpu, gpa, val, bytes, 1);
 	return 1;
 }
 
-- 
1.6.0.3

