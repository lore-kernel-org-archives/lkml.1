Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYIYMGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYIYMGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755069AbYIYL42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48597 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbYIYL4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:07 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 27/39] KVM: MMU: Convert direct maps to use the generic shadow walker
Date: Thu, 25 Sep 2008 14:54:59 +0300
Message-Id: <1222343711-12508-28-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |   93 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8b95cf7..a1ca4ff 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1260,49 +1260,66 @@ static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
 {
 }
 
-static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
-			int largepage, gfn_t gfn, pfn_t pfn)
-{
-	hpa_t table_addr = vcpu->arch.mmu.root_hpa;
-	int pt_write = 0;
-	int level = vcpu->arch.mmu.shadow_root_level;
-
-	for (; ; level--) {
-		u32 index = PT64_INDEX(v, level);
-		u64 *table;
+struct direct_shadow_walk {
+	struct kvm_shadow_walk walker;
+	pfn_t pfn;
+	int write;
+	int largepage;
+	int pt_write;
+};
 
-		ASSERT(VALID_PAGE(table_addr));
-		table = __va(table_addr);
+static int direct_map_entry(struct kvm_shadow_walk *_walk,
+			    struct kvm_vcpu *vcpu,
+			    gva_t addr, u64 *sptep, int level)
+{
+	struct direct_shadow_walk *walk =
+		container_of(_walk, struct direct_shadow_walk, walker);
+	struct kvm_mmu_page *sp;
+	gfn_t pseudo_gfn;
+	gfn_t gfn = addr >> PAGE_SHIFT;
+
+	if (level == PT_PAGE_TABLE_LEVEL
+	    || (walk->largepage && level == PT_DIRECTORY_LEVEL)) {
+		mmu_set_spte(vcpu, sptep, ACC_ALL, ACC_ALL,
+			     0, walk->write, 1, &walk->pt_write,
+			     walk->largepage, gfn, walk->pfn, false);
+		return 1;
+	}
 
-		if (level == 1 || (largepage && level == 2)) {
-			mmu_set_spte(vcpu, &table[index], ACC_ALL, ACC_ALL,
-				     0, write, 1, &pt_write, largepage,
-				     gfn, pfn, false);
-			return pt_write;
+	if (*sptep == shadow_trap_nonpresent_pte) {
+		pseudo_gfn = (addr & PT64_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
+		sp = kvm_mmu_get_page(vcpu, pseudo_gfn, addr, level - 1,
+				      1, ACC_ALL, sptep);
+		if (!sp) {
+			pgprintk("nonpaging_map: ENOMEM\n");
+			kvm_release_pfn_clean(walk->pfn);
+			return -ENOMEM;
 		}
 
-		if (table[index] == shadow_trap_nonpresent_pte) {
-			struct kvm_mmu_page *new_table;
-			gfn_t pseudo_gfn;
-
-			pseudo_gfn = (v & PT64_DIR_BASE_ADDR_MASK)
-				>> PAGE_SHIFT;
-			new_table = kvm_mmu_get_page(vcpu, pseudo_gfn,
-						     v, level - 1,
-						     1, ACC_ALL, &table[index]);
-			if (!new_table) {
-				pgprintk("nonpaging_map: ENOMEM\n");
-				kvm_release_pfn_clean(pfn);
-				return -ENOMEM;
-			}
-
-			set_shadow_pte(&table[index],
-				       __pa(new_table->spt)
-				       | PT_PRESENT_MASK | PT_WRITABLE_MASK
-				       | shadow_user_mask | shadow_x_mask);
-		}
-		table_addr = table[index] & PT64_BASE_ADDR_MASK;
+		set_shadow_pte(sptep,
+			       __pa(sp->spt)
+			       | PT_PRESENT_MASK | PT_WRITABLE_MASK
+			       | shadow_user_mask | shadow_x_mask);
 	}
+	return 0;
+}
+
+static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
+			int largepage, gfn_t gfn, pfn_t pfn)
+{
+	int r;
+	struct direct_shadow_walk walker = {
+		.walker = { .entry = direct_map_entry, },
+		.pfn = pfn,
+		.largepage = largepage,
+		.write = write,
+		.pt_write = 0,
+	};
+
+	r = walk_shadow(&walker.walker, vcpu, (gva_t)gfn << PAGE_SHIFT);
+	if (r < 0)
+		return r;
+	return walker.pt_write;
 }
 
 static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
-- 
1.6.0.1

