Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbZB0Khm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbZB0Khm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbZB0K2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447AbZB0K1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/37] KVM: MMU: Rename "metaphysical" attribute to "direct"
Date: Fri, 27 Feb 2009 12:26:53 +0200
Message-Id: <1235730420-7929-31-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This actually describes what is going on, rather than alerting the reader
that something strange is going on.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    5 +++--
 arch/x86/kvm/mmu.c              |   32 ++++++++++++++++----------------
 arch/x86/kvm/paging_tmpl.h      |   12 ++++++------
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 863ea73..55fd4c5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -170,7 +170,8 @@ struct kvm_pte_chain {
  *   bits 0:3 - total guest paging levels (2-4, or zero for real mode)
  *   bits 4:7 - page table level for this shadow (1-4)
  *   bits 8:9 - page table quadrant for 2-level guests
- *   bit   16 - "metaphysical" - gfn is not a real page (huge page/real mode)
+ *   bit   16 - direct mapping of virtual to physical mapping at gfn
+ *              used for real mode and two-dimensional paging
  *   bits 17:19 - common access permissions for all ptes in this shadow page
  */
 union kvm_mmu_page_role {
@@ -180,7 +181,7 @@ union kvm_mmu_page_role {
 		unsigned level:4;
 		unsigned quadrant:2;
 		unsigned pad_for_nice_hex_output:6;
-		unsigned metaphysical:1;
+		unsigned direct:1;
 		unsigned access:3;
 		unsigned invalid:1;
 		unsigned cr4_pge:1;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index de9a9fb..ef060ec 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1066,7 +1066,7 @@ static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry(sp, node, bucket, hash_link)
-		if (sp->gfn == gfn && !sp->role.metaphysical
+		if (sp->gfn == gfn && !sp->role.direct
 		    && !sp->role.invalid) {
 			pgprintk("%s: found role %x\n",
 				 __func__, sp->role.word);
@@ -1200,7 +1200,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 					     gfn_t gfn,
 					     gva_t gaddr,
 					     unsigned level,
-					     int metaphysical,
+					     int direct,
 					     unsigned access,
 					     u64 *parent_pte)
 {
@@ -1213,7 +1213,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 
 	role = vcpu->arch.mmu.base_role;
 	role.level = level;
-	role.metaphysical = metaphysical;
+	role.direct = direct;
 	role.access = access;
 	if (vcpu->arch.mmu.root_level <= PT32_ROOT_LEVEL) {
 		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
@@ -1250,7 +1250,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	sp->role = role;
 	sp->global = role.cr4_pge;
 	hlist_add_head(&sp->hash_link, bucket);
-	if (!metaphysical) {
+	if (!direct) {
 		if (rmap_write_protect(vcpu->kvm, gfn))
 			kvm_flush_remote_tlbs(vcpu->kvm);
 		account_shadowed(vcpu->kvm, gfn);
@@ -1395,7 +1395,7 @@ static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	kvm_mmu_page_unlink_children(kvm, sp);
 	kvm_mmu_unlink_parents(kvm, sp);
 	kvm_flush_remote_tlbs(kvm);
-	if (!sp->role.invalid && !sp->role.metaphysical)
+	if (!sp->role.invalid && !sp->role.direct)
 		unaccount_shadowed(kvm, sp->gfn);
 	if (sp->unsync)
 		kvm_unlink_unsync_page(kvm, sp);
@@ -1458,7 +1458,7 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link)
-		if (sp->gfn == gfn && !sp->role.metaphysical) {
+		if (sp->gfn == gfn && !sp->role.direct) {
 			pgprintk("%s: gfn %lx role %x\n", __func__, gfn,
 				 sp->role.word);
 			r = 1;
@@ -1478,7 +1478,7 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, nn, bucket, hash_link) {
-		if (sp->gfn == gfn && !sp->role.metaphysical
+		if (sp->gfn == gfn && !sp->role.direct
 		    && !sp->role.invalid) {
 			pgprintk("%s: zap %lx %x\n",
 				 __func__, gfn, sp->role.word);
@@ -1638,7 +1638,7 @@ static int kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	/* don't unsync if pagetable is shadowed with multiple roles */
 	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
-		if (s->gfn != sp->gfn || s->role.metaphysical)
+		if (s->gfn != sp->gfn || s->role.direct)
 			continue;
 		if (s->role.word != sp->role.word)
 			return 1;
@@ -1951,7 +1951,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 	int i;
 	gfn_t root_gfn;
 	struct kvm_mmu_page *sp;
-	int metaphysical = 0;
+	int direct = 0;
 
 	root_gfn = vcpu->arch.cr3 >> PAGE_SHIFT;
 
@@ -1960,18 +1960,18 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 
 		ASSERT(!VALID_PAGE(root));
 		if (tdp_enabled)
-			metaphysical = 1;
+			direct = 1;
 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
-				      PT64_ROOT_LEVEL, metaphysical,
+				      PT64_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
 		vcpu->arch.mmu.root_hpa = root;
 		return;
 	}
-	metaphysical = !is_paging(vcpu);
+	direct = !is_paging(vcpu);
 	if (tdp_enabled)
-		metaphysical = 1;
+		direct = 1;
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
@@ -1985,7 +1985,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		} else if (vcpu->arch.mmu.root_level == 0)
 			root_gfn = 0;
 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
-				      PT32_ROOT_LEVEL, metaphysical,
+				      PT32_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
@@ -2487,7 +2487,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link) {
-		if (sp->gfn != gfn || sp->role.metaphysical || sp->role.invalid)
+		if (sp->gfn != gfn || sp->role.direct || sp->role.invalid)
 			continue;
 		pte_size = sp->role.glevels == PT32_ROOT_LEVEL ? 4 : 8;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
@@ -3125,7 +3125,7 @@ static void audit_write_protection(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 
 	list_for_each_entry(sp, &vcpu->kvm->arch.active_mmu_pages, link) {
-		if (sp->role.metaphysical)
+		if (sp->role.direct)
 			continue;
 
 		gfn = unalias_gfn(vcpu->kvm, sp->gfn);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 46b68f9..7314c09 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -277,7 +277,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	unsigned access = gw->pt_access;
 	struct kvm_mmu_page *shadow_page;
 	u64 spte, *sptep;
-	int metaphysical;
+	int direct;
 	gfn_t table_gfn;
 	int r;
 	int level;
@@ -313,17 +313,17 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 
 		if (level == PT_DIRECTORY_LEVEL
 		    && gw->level == PT_DIRECTORY_LEVEL) {
-			metaphysical = 1;
+			direct = 1;
 			if (!is_dirty_pte(gw->ptes[level - 1]))
 				access &= ~ACC_WRITE_MASK;
 			table_gfn = gpte_to_gfn(gw->ptes[level - 1]);
 		} else {
-			metaphysical = 0;
+			direct = 0;
 			table_gfn = gw->table_gfn[level - 2];
 		}
 		shadow_page = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
-					       metaphysical, access, sptep);
-		if (!metaphysical) {
+					       direct, access, sptep);
+		if (!direct) {
 			r = kvm_read_guest_atomic(vcpu->kvm,
 						  gw->pte_gpa[level - 2],
 						  &curr_pte, sizeof(curr_pte));
@@ -512,7 +512,7 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 	pt_element_t pt[256 / sizeof(pt_element_t)];
 	gpa_t pte_gpa;
 
-	if (sp->role.metaphysical
+	if (sp->role.direct
 	    || (PTTYPE == 32 && sp->role.level > PT_PAGE_TABLE_LEVEL)) {
 		nonpaging_prefetch_page(vcpu, sp);
 		return;
-- 
1.6.0.6

