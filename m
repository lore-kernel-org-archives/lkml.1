Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZHQWdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZHQWdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 18:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbZHQWdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 18:33:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:46744 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZHQWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 18:33:40 -0400
Date: Mon, 17 Aug 2009 23:33:38 +0100 (BST)
From: Alexey Korolev <akorolev@infradead.org>
To: mel@csn.ul.ie, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3]HTLB mapping for drivers. Alloc functions & some export
 symbols(take 2)
Message-ID: <alpine.LFD.2.00.0908172324130.32114@casper.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <akorolev@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains definitions of the hugetlb_alloc_pages_immediate & 
hugetlb_free_pages_immediate functions. The function hugetlb_alloc_pages_immediate 
allocates a single huge page. The allocation allows the selection of gfp mask and numa 
node. The allocation is immediate, i.e. it is not processed by hugetlbfs counting, 
because otherwise user must specify how much memory should be allocated, in case of 
a driver it could be hard to do. 

Also this patch adds some symbol exports. Since drivers need to create and 
populate/depopulate hugetlb file pg cache with pages we need to add export of 
hugetlb_file_setup and remove_from_page_cache. 

Signed-off-by: Alexey Korolev <akorolev@infradead.org>

---
 fs/hugetlbfs/inode.c    |    1 +
 include/linux/hugetlb.h |    5 ++++
 mm/filemap.c            |    1 +
 mm/hugetlb.c            |   60 ++++++++++++++++++++++++++++++++++++----------
 4 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 941c842..f53cf64 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1000,6 +1000,7 @@ out_shm_unlock:
 		user_shm_unlock(size, user);
 	return ERR_PTR(error);
 }
+EXPORT_SYMBOL(hugetlb_file_setup);
 
 static int __init init_hugetlbfs_fs(void)
 {
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2723513..e42fa32 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -204,6 +204,9 @@ struct huge_bootmem_page {
 	struct hstate *hstate;
 };
 
+struct page *hugetlb_alloc_pages_immediate(struct hstate *h, int nid, gfp_t gfp_mask);
+void hugetlb_free_pages_immediate(struct hstate *h, struct page *page);
+
 /* arch callback */
 int __init alloc_bootmem_huge_page(struct hstate *h);
 
@@ -279,6 +282,8 @@ static inline struct hstate *page_hstate(struct page *page)
 
 #else
 struct hstate {};
+#define hugetlb_alloc_pages_immediate(h, n, m) NULL
+#define hugetlb_free_pages_immediate(h, p)
 #define alloc_bootmem_huge_page(h) NULL
 #define hstate_file(f) NULL
 #define hstate_vma(v) NULL
diff --git a/mm/filemap.c b/mm/filemap.c
index ccea3b6..dc6da1a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -146,6 +146,7 @@ void remove_from_page_cache(struct page *page)
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
 }
+EXPORT_SYMBOL(remove_from_page_cache);
 
 static int sync_page(void *word)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cafdcee..d278210 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -522,21 +522,9 @@ static struct page *dequeue_huge_page_vma(struct hstate *h,
 
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
-	int i;
-
-	VM_BUG_ON(h->order >= MAX_ORDER);
-
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[page_to_nid(page)]--;
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		page[i].flags &= ~(1 << PG_locked | 1 << PG_error | 1 << PG_referenced |
-				1 << PG_dirty | 1 << PG_active | 1 << PG_reserved |
-				1 << PG_private | 1<< PG_writeback);
-	}
-	set_compound_page_dtor(page, NULL);
-	set_page_refcounted(page);
-	arch_release_hugepage(page);
-	__free_pages(page, huge_page_order(h));
+	hugetlb_free_pages_immediate(h, page);
 }
 
 struct hstate *size_to_hstate(unsigned long size)
@@ -639,6 +627,52 @@ static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 }
 
 /*
+ * alloc_huge_pages_immediate - Allocate a single huge page for use
+ * with a driver
+ * @nid: The node to allocate memory on
+ * @gfp_mask: GFP flags for the allocation
+ * alloc_huge_page() is intended for use by device drivers that want to
+ * back regions of memory with huge pages that will be later mapped to
+ * userspace. Allocation are immediate. They done directly from the
+ * buddy allocator without touching hugepage pool reservations.
+ */
+struct page *hugetlb_alloc_pages_immediate(struct hstate *h,
+					int nid, gfp_t gfp_mask)
+{
+	struct page *page;
+
+	if (huge_page_order(h) >= MAX_ORDER)
+		return NULL;
+
+	page = alloc_pages_exact_node(nid, gfp_mask|__GFP_COMP,
+					huge_page_order(h));
+	if (page && arch_prepare_hugepage(page)) {
+		__free_pages(page, huge_page_order(h));
+		return NULL;
+	}
+	return page;
+}
+EXPORT_SYMBOL(hugetlb_alloc_pages_immediate);
+
+void hugetlb_free_pages_immediate(struct hstate *h, struct page *page)
+{
+	int i;
+
+	VM_BUG_ON(huge_page_order(h) >= MAX_ORDER);
+
+	for (i = 0; i < pages_per_huge_page(h); i++) {
+		page[i].flags &= ~(1 << PG_locked | 1 << PG_error |
+			1 << PG_referenced | 1 << PG_dirty | 1 << PG_active |
+			1 << PG_reserved | 1 << PG_private | 1 << PG_writeback);
+	}
+	set_compound_page_dtor(page, NULL);
+	set_page_refcounted(page);
+	arch_release_hugepage(page);
+	__free_pages(page, huge_page_order(h));
+}
+EXPORT_SYMBOL(hugetlb_free_pages_immediate);
+
+/*
  * Use a helper variable to find the next node and then
  * copy it back to hugetlb_next_nid afterwards:
  * otherwise there's a window in which a racer might
-- 


Alternativelly the patch could be taken from git:
http://git.infradead.org/users/akorolev/mm-patches.git/commit/7746e1c5d826d90286ae797a2551e232e8057a0e

