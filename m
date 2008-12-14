Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYLNIVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYLNIVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYLNIIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:08:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59932 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbYLNIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:17 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 32/36] KVM: MMU: use page array in unsync walk
Date: Sun, 14 Dec 2008 10:07:05 +0200
Message-Id: <1229242029-13410-33-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Instead of invoking the handler directly collect pages into
an array so the caller can work with it.

Simplifies TLB flush collapsing.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/mmu.c              |  195 ++++++++++++++++++++++++++++-----------
 2 files changed, 141 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f58f7eb..93d0aed 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -200,7 +200,7 @@ struct kvm_mmu_page {
 	int multimapped;         /* More than one parent_pte? */
 	int root_count;          /* Currently serving as active root */
 	bool unsync;
-	bool unsync_children;
+	unsigned int unsync_children;
 	union {
 		u64 *parent_pte;               /* !multimapped */
 		struct hlist_head parent_ptes; /* multimapped, kvm_pte_chain */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index dd20b19..7ce92f7 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -908,8 +908,9 @@ static void kvm_mmu_update_unsync_bitmap(u64 *spte)
 	struct kvm_mmu_page *sp = page_header(__pa(spte));
 
 	index = spte - sp->spt;
-	__set_bit(index, sp->unsync_child_bitmap);
-	sp->unsync_children = 1;
+	if (!__test_and_set_bit(index, sp->unsync_child_bitmap))
+		sp->unsync_children++;
+	WARN_ON(!sp->unsync_children);
 }
 
 static void kvm_mmu_update_parents_unsync(struct kvm_mmu_page *sp)
@@ -936,7 +937,6 @@ static void kvm_mmu_update_parents_unsync(struct kvm_mmu_page *sp)
 
 static int unsync_walk_fn(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
-	sp->unsync_children = 1;
 	kvm_mmu_update_parents_unsync(sp);
 	return 1;
 }
@@ -967,18 +967,41 @@ static void nonpaging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
 }
 
+#define KVM_PAGE_ARRAY_NR 16
+
+struct kvm_mmu_pages {
+	struct mmu_page_and_offset {
+		struct kvm_mmu_page *sp;
+		unsigned int idx;
+	} page[KVM_PAGE_ARRAY_NR];
+	unsigned int nr;
+};
+
 #define for_each_unsync_children(bitmap, idx)		\
 	for (idx = find_first_bit(bitmap, 512);		\
 	     idx < 512;					\
 	     idx = find_next_bit(bitmap, 512, idx+1))
 
-static int mmu_unsync_walk(struct kvm_mmu_page *sp,
-			   struct kvm_unsync_walk *walker)
+int mmu_pages_add(struct kvm_mmu_pages *pvec, struct kvm_mmu_page *sp,
+		   int idx)
 {
-	int i, ret;
+	int i;
 
-	if (!sp->unsync_children)
-		return 0;
+	if (sp->unsync)
+		for (i=0; i < pvec->nr; i++)
+			if (pvec->page[i].sp == sp)
+				return 0;
+
+	pvec->page[pvec->nr].sp = sp;
+	pvec->page[pvec->nr].idx = idx;
+	pvec->nr++;
+	return (pvec->nr == KVM_PAGE_ARRAY_NR);
+}
+
+static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
+			   struct kvm_mmu_pages *pvec)
+{
+	int i, ret, nr_unsync_leaf = 0;
 
 	for_each_unsync_children(sp->unsync_child_bitmap, i) {
 		u64 ent = sp->spt[i];
@@ -988,17 +1011,22 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,
 			child = page_header(ent & PT64_BASE_ADDR_MASK);
 
 			if (child->unsync_children) {
-				ret = mmu_unsync_walk(child, walker);
-				if (ret)
+				if (mmu_pages_add(pvec, child, i))
+					return -ENOSPC;
+
+				ret = __mmu_unsync_walk(child, pvec);
+				if (!ret)
+					__clear_bit(i, sp->unsync_child_bitmap);
+				else if (ret > 0)
+					nr_unsync_leaf += ret;
+				else
 					return ret;
-				__clear_bit(i, sp->unsync_child_bitmap);
 			}
 
 			if (child->unsync) {
-				ret = walker->entry(child, walker);
-				__clear_bit(i, sp->unsync_child_bitmap);
-				if (ret)
-					return ret;
+				nr_unsync_leaf++;
+				if (mmu_pages_add(pvec, child, i))
+					return -ENOSPC;
 			}
 		}
 	}
@@ -1006,7 +1034,17 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,
 	if (find_first_bit(sp->unsync_child_bitmap, 512) == 512)
 		sp->unsync_children = 0;
 
-	return 0;
+	return nr_unsync_leaf;
+}
+
+static int mmu_unsync_walk(struct kvm_mmu_page *sp,
+			   struct kvm_mmu_pages *pvec)
+{
+	if (!sp->unsync_children)
+		return 0;
+
+	mmu_pages_add(pvec, sp, 0);
+	return __mmu_unsync_walk(sp, pvec);
 }
 
 static struct kvm_mmu_page *kvm_mmu_lookup_page(struct kvm *kvm, gfn_t gfn)
@@ -1056,30 +1094,81 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	return 0;
 }
 
-struct sync_walker {
-	struct kvm_vcpu *vcpu;
-	struct kvm_unsync_walk walker;
+struct mmu_page_path {
+	struct kvm_mmu_page *parent[PT64_ROOT_LEVEL-1];
+	unsigned int idx[PT64_ROOT_LEVEL-1];
 };
 
-static int mmu_sync_fn(struct kvm_mmu_page *sp, struct kvm_unsync_walk *walk)
+#define for_each_sp(pvec, sp, parents, i)			\
+		for (i = mmu_pages_next(&pvec, &parents, -1),	\
+			sp = pvec.page[i].sp;			\
+			i < pvec.nr && ({ sp = pvec.page[i].sp; 1;});	\
+			i = mmu_pages_next(&pvec, &parents, i))
+
+int mmu_pages_next(struct kvm_mmu_pages *pvec, struct mmu_page_path *parents,
+		   int i)
 {
-	struct sync_walker *sync_walk = container_of(walk, struct sync_walker,
-						     walker);
-	struct kvm_vcpu *vcpu = sync_walk->vcpu;
+	int n;
+
+	for (n = i+1; n < pvec->nr; n++) {
+		struct kvm_mmu_page *sp = pvec->page[n].sp;
+
+		if (sp->role.level == PT_PAGE_TABLE_LEVEL) {
+			parents->idx[0] = pvec->page[n].idx;
+			return n;
+		}
 
-	kvm_sync_page(vcpu, sp);
-	return (need_resched() || spin_needbreak(&vcpu->kvm->mmu_lock));
+		parents->parent[sp->role.level-2] = sp;
+		parents->idx[sp->role.level-1] = pvec->page[n].idx;
+	}
+
+	return n;
 }
 
-static void mmu_sync_children(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+void mmu_pages_clear_parents(struct mmu_page_path *parents)
 {
-	struct sync_walker walker = {
-		.walker = { .entry = mmu_sync_fn, },
-		.vcpu = vcpu,
-	};
+	struct kvm_mmu_page *sp;
+	unsigned int level = 0;
+
+	do {
+		unsigned int idx = parents->idx[level];
+
+		sp = parents->parent[level];
+		if (!sp)
+			return;
+
+		--sp->unsync_children;
+		WARN_ON((int)sp->unsync_children < 0);
+		__clear_bit(idx, sp->unsync_child_bitmap);
+		level++;
+	} while (level < PT64_ROOT_LEVEL-1 && !sp->unsync_children);
+}
+
+static void kvm_mmu_pages_init(struct kvm_mmu_page *parent,
+			       struct mmu_page_path *parents,
+			       struct kvm_mmu_pages *pvec)
+{
+	parents->parent[parent->role.level-1] = NULL;
+	pvec->nr = 0;
+}
 
-	while (mmu_unsync_walk(sp, &walker.walker))
+static void mmu_sync_children(struct kvm_vcpu *vcpu,
+			      struct kvm_mmu_page *parent)
+{
+	int i;
+	struct kvm_mmu_page *sp;
+	struct mmu_page_path parents;
+	struct kvm_mmu_pages pages;
+
+	kvm_mmu_pages_init(parent, &parents, &pages);
+	while (mmu_unsync_walk(parent, &pages)) {
+		for_each_sp(pages, sp, parents, i) {
+			kvm_sync_page(vcpu, sp);
+			mmu_pages_clear_parents(&parents);
+		}
 		cond_resched_lock(&vcpu->kvm->mmu_lock);
+		kvm_mmu_pages_init(parent, &parents, &pages);
+	}
 }
 
 static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
@@ -1245,33 +1334,29 @@ static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 	}
 }
 
-struct zap_walker {
-	struct kvm_unsync_walk walker;
-	struct kvm *kvm;
-	int zapped;
-};
-
-static int mmu_zap_fn(struct kvm_mmu_page *sp, struct kvm_unsync_walk *walk)
-{
-	struct zap_walker *zap_walk = container_of(walk, struct zap_walker,
-						     walker);
-	kvm_mmu_zap_page(zap_walk->kvm, sp);
-	zap_walk->zapped = 1;
-	return 0;
-}
-
-static int mmu_zap_unsync_children(struct kvm *kvm, struct kvm_mmu_page *sp)
+static int mmu_zap_unsync_children(struct kvm *kvm,
+				   struct kvm_mmu_page *parent)
 {
-	struct zap_walker walker = {
-		.walker = { .entry = mmu_zap_fn, },
-		.kvm = kvm,
-		.zapped = 0,
-	};
+	int i, zapped = 0;
+	struct mmu_page_path parents;
+	struct kvm_mmu_pages pages;
 
-	if (sp->role.level == PT_PAGE_TABLE_LEVEL)
+	if (parent->role.level == PT_PAGE_TABLE_LEVEL)
 		return 0;
-	mmu_unsync_walk(sp, &walker.walker);
-	return walker.zapped;
+
+	kvm_mmu_pages_init(parent, &parents, &pages);
+	while (mmu_unsync_walk(parent, &pages)) {
+		struct kvm_mmu_page *sp;
+
+		for_each_sp(pages, sp, parents, i) {
+			kvm_mmu_zap_page(kvm, sp);
+			mmu_pages_clear_parents(&parents);
+		}
+		zapped += pages.nr;
+		kvm_mmu_pages_init(parent, &parents, &pages);
+	}
+
+	return zapped;
 }
 
 static int kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
-- 
1.6.0.3

