Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbZBZOUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbZBZOUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbZBZOQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43057 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/40] KVM: MMU: Add for_each_shadow_entry(), a simpler alternative to walk_shadow()
Date: Thu, 26 Feb 2009 16:15:15 +0200
Message-Id: <1235657730-27683-26-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a for_each loop style removes the need to write callback and nasty
casts.

Implement the walk_shadow() using the for_each_shadow_entry().

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   69 +++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 49 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5f03ec3..c669f2a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -150,6 +150,20 @@ struct kvm_shadow_walk {
 		     u64 addr, u64 *spte, int level);
 };
 
+struct kvm_shadow_walk_iterator {
+	u64 addr;
+	hpa_t shadow_addr;
+	int level;
+	u64 *sptep;
+	unsigned index;
+};
+
+#define for_each_shadow_entry(_vcpu, _addr, _walker)    \
+	for (shadow_walk_init(&(_walker), _vcpu, _addr);	\
+	     shadow_walk_okay(&(_walker));			\
+	     shadow_walk_next(&(_walker)))
+
+
 struct kvm_unsync_walk {
 	int (*entry) (struct kvm_mmu_page *sp, struct kvm_unsync_walk *walk);
 };
@@ -1254,33 +1268,48 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
+static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
+			     struct kvm_vcpu *vcpu, u64 addr)
+{
+	iterator->addr = addr;
+	iterator->shadow_addr = vcpu->arch.mmu.root_hpa;
+	iterator->level = vcpu->arch.mmu.shadow_root_level;
+	if (iterator->level == PT32E_ROOT_LEVEL) {
+		iterator->shadow_addr
+			= vcpu->arch.mmu.pae_root[(addr >> 30) & 3];
+		iterator->shadow_addr &= PT64_BASE_ADDR_MASK;
+		--iterator->level;
+		if (!iterator->shadow_addr)
+			iterator->level = 0;
+	}
+}
+
+static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
+{
+	if (iterator->level < PT_PAGE_TABLE_LEVEL)
+		return false;
+	iterator->index = SHADOW_PT_INDEX(iterator->addr, iterator->level);
+	iterator->sptep	= ((u64 *)__va(iterator->shadow_addr)) + iterator->index;
+	return true;
+}
+
+static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
+{
+	iterator->shadow_addr = *iterator->sptep & PT64_BASE_ADDR_MASK;
+	--iterator->level;
+}
+
 static int walk_shadow(struct kvm_shadow_walk *walker,
 		       struct kvm_vcpu *vcpu, u64 addr)
 {
-	hpa_t shadow_addr;
-	int level;
+	struct kvm_shadow_walk_iterator iterator;
 	int r;
-	u64 *sptep;
-	unsigned index;
-
-	shadow_addr = vcpu->arch.mmu.root_hpa;
-	level = vcpu->arch.mmu.shadow_root_level;
-	if (level == PT32E_ROOT_LEVEL) {
-		shadow_addr = vcpu->arch.mmu.pae_root[(addr >> 30) & 3];
-		shadow_addr &= PT64_BASE_ADDR_MASK;
-		if (!shadow_addr)
-			return 1;
-		--level;
-	}
 
-	while (level >= PT_PAGE_TABLE_LEVEL) {
-		index = SHADOW_PT_INDEX(addr, level);
-		sptep = ((u64 *)__va(shadow_addr)) + index;
-		r = walker->entry(walker, vcpu, addr, sptep, level);
+	for_each_shadow_entry(vcpu, addr, iterator) {
+		r = walker->entry(walker, vcpu, addr,
+				  iterator.sptep, iterator.level);
 		if (r)
 			return r;
-		shadow_addr = *sptep & PT64_BASE_ADDR_MASK;
-		--level;
 	}
 	return 0;
 }
-- 
1.6.0.6

