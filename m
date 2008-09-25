Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbYIYMDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbYIYMDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYIYL4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:56:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48594 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbYIYL4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:56:05 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 26/39] KVM: MMU: Add generic shadow walker
Date: Thu, 25 Sep 2008 14:54:58 +0300
Message-Id: <1222343711-12508-27-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

We currently walk the shadow page tables in two places: direct map (for
real mode and two dimensional paging) and paging mode shadow.  Since we
anticipate requiring a third walk (for invlpg), it makes sense to have
a generic facility for shadow walk.

This patch adds such a shadow walker, walks the page tables and calls a
method for every spte encountered.  The method can examine the spte,
modify it, or even instantiate it.  The walk can be aborted by returning
nonzero from the method.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 72f739a..8b95cf7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -142,6 +142,11 @@ struct kvm_rmap_desc {
 	struct kvm_rmap_desc *more;
 };
 
+struct kvm_shadow_walk {
+	int (*entry)(struct kvm_shadow_walk *walk, struct kvm_vcpu *vcpu,
+		     gva_t addr, u64 *spte, int level);
+};
+
 static struct kmem_cache *pte_chain_cache;
 static struct kmem_cache *rmap_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
@@ -935,6 +940,35 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
+static int walk_shadow(struct kvm_shadow_walk *walker,
+		       struct kvm_vcpu *vcpu, gva_t addr)
+{
+	hpa_t shadow_addr;
+	int level;
+	int r;
+	u64 *sptep;
+	unsigned index;
+
+	shadow_addr = vcpu->arch.mmu.root_hpa;
+	level = vcpu->arch.mmu.shadow_root_level;
+	if (level == PT32E_ROOT_LEVEL) {
+		shadow_addr = vcpu->arch.mmu.pae_root[(addr >> 30) & 3];
+		shadow_addr &= PT64_BASE_ADDR_MASK;
+		--level;
+	}
+
+	while (level >= PT_PAGE_TABLE_LEVEL) {
+		index = SHADOW_PT_INDEX(addr, level);
+		sptep = ((u64 *)__va(shadow_addr)) + index;
+		r = walker->entry(walker, vcpu, addr, sptep, level);
+		if (r)
+			return r;
+		shadow_addr = *sptep & PT64_BASE_ADDR_MASK;
+		--level;
+	}
+	return 0;
+}
+
 static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 					 struct kvm_mmu_page *sp)
 {
-- 
1.6.0.1

