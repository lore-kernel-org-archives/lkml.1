Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYI1Pqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYI1Pqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYI1PpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50834 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbYI1PpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:10 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 03/25] KVM: MMU: Modify kvm_shadow_walk.entry to accept u64 addr
Date: Sun, 28 Sep 2008 18:44:39 +0300
Message-Id: <1222616701-1206-4-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

EPT is 4 level by default in 32pae(48 bits), but the addr parameter
of kvm_shadow_walk->entry() only accept unsigned long as virtual
address, which is 32bit in 32pae. This result in SHADOW_PT_INDEX()
overflow when try to fetch level 4 index.

Fix it by extend kvm_shadow_walk->entry() to accept 64bit addr in
parameter.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   10 +++++-----
 arch/x86/kvm/paging_tmpl.h |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 866d713..bce3e25 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -144,7 +144,7 @@ struct kvm_rmap_desc {
 
 struct kvm_shadow_walk {
 	int (*entry)(struct kvm_shadow_walk *walk, struct kvm_vcpu *vcpu,
-		     gva_t addr, u64 *spte, int level);
+		     u64 addr, u64 *spte, int level);
 };
 
 static struct kmem_cache *pte_chain_cache;
@@ -941,7 +941,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 }
 
 static int walk_shadow(struct kvm_shadow_walk *walker,
-		       struct kvm_vcpu *vcpu, gva_t addr)
+		       struct kvm_vcpu *vcpu, u64 addr)
 {
 	hpa_t shadow_addr;
 	int level;
@@ -1270,7 +1270,7 @@ struct direct_shadow_walk {
 
 static int direct_map_entry(struct kvm_shadow_walk *_walk,
 			    struct kvm_vcpu *vcpu,
-			    gva_t addr, u64 *sptep, int level)
+			    u64 addr, u64 *sptep, int level)
 {
 	struct direct_shadow_walk *walk =
 		container_of(_walk, struct direct_shadow_walk, walker);
@@ -1289,7 +1289,7 @@ static int direct_map_entry(struct kvm_shadow_walk *_walk,
 
 	if (*sptep == shadow_trap_nonpresent_pte) {
 		pseudo_gfn = (addr & PT64_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
-		sp = kvm_mmu_get_page(vcpu, pseudo_gfn, addr, level - 1,
+		sp = kvm_mmu_get_page(vcpu, pseudo_gfn, (gva_t)addr, level - 1,
 				      1, ACC_ALL, sptep);
 		if (!sp) {
 			pgprintk("nonpaging_map: ENOMEM\n");
@@ -1317,7 +1317,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
 		.pt_write = 0,
 	};
 
-	r = walk_shadow(&walker.walker, vcpu, (gva_t)gfn << PAGE_SHIFT);
+	r = walk_shadow(&walker.walker, vcpu, gfn << PAGE_SHIFT);
 	if (r < 0)
 		return r;
 	return walker.pt_write;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index b7064e1..b671f61 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -286,7 +286,7 @@ static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
  * Fetch a shadow pte for a specific level in the paging hierarchy.
  */
 static int FNAME(shadow_walk_entry)(struct kvm_shadow_walk *_sw,
-				    struct kvm_vcpu *vcpu, gva_t addr,
+				    struct kvm_vcpu *vcpu, u64 addr,
 				    u64 *sptep, int level)
 {
 	struct shadow_walker *sw =
@@ -326,7 +326,7 @@ static int FNAME(shadow_walk_entry)(struct kvm_shadow_walk *_sw,
 		metaphysical = 0;
 		table_gfn = gw->table_gfn[level - 2];
 	}
-	shadow_page = kvm_mmu_get_page(vcpu, table_gfn, addr, level-1,
+	shadow_page = kvm_mmu_get_page(vcpu, table_gfn, (gva_t)addr, level-1,
 				       metaphysical, access, sptep);
 	if (!metaphysical) {
 		r = kvm_read_guest_atomic(vcpu->kvm, gw->pte_gpa[level - 2],
-- 
1.6.0.1

