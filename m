Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbZKJVv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbZKJVv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbZKJVvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:51:55 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:13844 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758268AbZKJVvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:51:54 -0500
X-Trace: 284012177/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.44.180/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.44.180
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkFAMdv+UpPRSy0/2dsb2JhbACBTt01hD4E
X-IronPort-AV: E=Sophos;i="4.44,718,1249254000"; 
   d="scan'208";a="284012177"
Date: Tue, 10 Nov 2009 21:51:46 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/6] mm: define PAGE_MAPPING_FLAGS
In-Reply-To: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
Message-ID: <Pine.LNX.4.64.0911102150350.2816@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present we define PageAnon(page) by the low PAGE_MAPPING_ANON bit
set in page->mapping, with the higher bits a pointer to the anon_vma;
and have defined PageKsm(page) as that with NULL anon_vma.

But KSM swapping will need to store a pointer there: so in preparation
for that, now define PAGE_MAPPING_FLAGS as the low two bits, including
PAGE_MAPPING_KSM (always set along with PAGE_MAPPING_ANON, until some
other use for the bit emerges).

Declare page_rmapping(page) to return the pointer part of page->mapping,
and page_anon_vma(page) to return the anon_vma pointer when that's what
it is.  Use these in a few appropriate places: notably, unuse_vma() has
been testing page->mapping, but is better to be testing page_anon_vma()
(cases may be added in which flag bits are set without any pointer).

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 include/linux/ksm.h  |    5 +++--
 include/linux/mm.h   |   17 ++++++++++++++++-
 include/linux/rmap.h |    8 ++++++++
 mm/migrate.c         |   11 ++++-------
 mm/rmap.c            |    7 +++----
 mm/swapfile.c        |    2 +-
 6 files changed, 35 insertions(+), 15 deletions(-)

--- mm0/include/linux/ksm.h	2009-09-28 00:28:38.000000000 +0100
+++ mm1/include/linux/ksm.h	2009-11-04 10:52:45.000000000 +0000
@@ -38,7 +38,8 @@ static inline void ksm_exit(struct mm_st
  */
 static inline int PageKsm(struct page *page)
 {
-	return ((unsigned long)page->mapping == PAGE_MAPPING_ANON);
+	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
+				(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
 }
 
 /*
@@ -47,7 +48,7 @@ static inline int PageKsm(struct page *p
 static inline void page_add_ksm_rmap(struct page *page)
 {
 	if (atomic_inc_and_test(&page->_mapcount)) {
-		page->mapping = (void *) PAGE_MAPPING_ANON;
+		page->mapping = (void *) (PAGE_MAPPING_ANON | PAGE_MAPPING_KSM);
 		__inc_zone_page_state(page, NR_ANON_PAGES);
 	}
 }
--- mm0/include/linux/mm.h	2009-11-02 12:32:34.000000000 +0000
+++ mm1/include/linux/mm.h	2009-11-04 10:52:45.000000000 +0000
@@ -620,13 +620,22 @@ void page_address_init(void);
 /*
  * On an anonymous page mapped into a user virtual memory area,
  * page->mapping points to its anon_vma, not to a struct address_space;
- * with the PAGE_MAPPING_ANON bit set to distinguish it.
+ * with the PAGE_MAPPING_ANON bit set to distinguish it.  See rmap.h.
+ *
+ * On an anonymous page in a VM_MERGEABLE area, if CONFIG_KSM is enabled,
+ * the PAGE_MAPPING_KSM bit may be set along with the PAGE_MAPPING_ANON bit;
+ * and then page->mapping points, not to an anon_vma, but to a private
+ * structure which KSM associates with that merged page.  See ksm.h.
+ *
+ * PAGE_MAPPING_KSM without PAGE_MAPPING_ANON is currently never used.
  *
  * Please note that, confusingly, "page_mapping" refers to the inode
  * address_space which maps the page from disk; whereas "page_mapped"
  * refers to user virtual address space into which the page is mapped.
  */
 #define PAGE_MAPPING_ANON	1
+#define PAGE_MAPPING_KSM	2
+#define PAGE_MAPPING_FLAGS	(PAGE_MAPPING_ANON | PAGE_MAPPING_KSM)
 
 extern struct address_space swapper_space;
 static inline struct address_space *page_mapping(struct page *page)
@@ -644,6 +653,12 @@ static inline struct address_space *page
 	return mapping;
 }
 
+/* Neutral page->mapping pointer to address_space or anon_vma or other */
+static inline void *page_rmapping(struct page *page)
+{
+	return (void *)((unsigned long)page->mapping & ~PAGE_MAPPING_FLAGS);
+}
+
 static inline int PageAnon(struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_ANON) != 0;
--- mm0/include/linux/rmap.h	2009-09-28 00:28:39.000000000 +0100
+++ mm1/include/linux/rmap.h	2009-11-04 10:52:45.000000000 +0000
@@ -39,6 +39,14 @@ struct anon_vma {
 
 #ifdef CONFIG_MMU
 
+static inline struct anon_vma *page_anon_vma(struct page *page)
+{
+	if (((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) !=
+					    PAGE_MAPPING_ANON)
+		return NULL;
+	return page_rmapping(page);
+}
+
 static inline void anon_vma_lock(struct vm_area_struct *vma)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
--- mm0/mm/migrate.c	2009-11-02 12:32:34.000000000 +0000
+++ mm1/mm/migrate.c	2009-11-04 10:52:45.000000000 +0000
@@ -172,17 +172,14 @@ static void remove_anon_migration_ptes(s
 {
 	struct anon_vma *anon_vma;
 	struct vm_area_struct *vma;
-	unsigned long mapping;
-
-	mapping = (unsigned long)new->mapping;
-
-	if (!mapping || (mapping & PAGE_MAPPING_ANON) == 0)
-		return;
 
 	/*
 	 * We hold the mmap_sem lock. So no need to call page_lock_anon_vma.
 	 */
-	anon_vma = (struct anon_vma *) (mapping - PAGE_MAPPING_ANON);
+	anon_vma = page_anon_vma(new);
+	if (!anon_vma)
+		return;
+
 	spin_lock(&anon_vma->lock);
 
 	list_for_each_entry(vma, &anon_vma->head, anon_vma_node)
--- mm0/mm/rmap.c	2009-11-02 12:32:34.000000000 +0000
+++ mm1/mm/rmap.c	2009-11-04 10:52:45.000000000 +0000
@@ -203,7 +203,7 @@ struct anon_vma *page_lock_anon_vma(stru
 
 	rcu_read_lock();
 	anon_mapping = (unsigned long) page->mapping;
-	if (!(anon_mapping & PAGE_MAPPING_ANON))
+	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
 	if (!page_mapped(page))
 		goto out;
@@ -248,8 +248,7 @@ vma_address(struct page *page, struct vm
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	if (PageAnon(page)) {
-		if ((void *)vma->anon_vma !=
-		    (void *)page->mapping - PAGE_MAPPING_ANON)
+		if (vma->anon_vma != page_anon_vma(page))
 			return -EFAULT;
 	} else if (page->mapping && !(vma->vm_flags & VM_NONLINEAR)) {
 		if (!vma->vm_file ||
@@ -512,7 +511,7 @@ int page_referenced(struct page *page,
 		referenced++;
 
 	*vm_flags = 0;
-	if (page_mapped(page) && page->mapping) {
+	if (page_mapped(page) && page_rmapping(page)) {
 		if (PageAnon(page))
 			referenced += page_referenced_anon(page, mem_cont,
 								vm_flags);
--- mm0/mm/swapfile.c	2009-11-04 10:21:17.000000000 +0000
+++ mm1/mm/swapfile.c	2009-11-04 10:52:45.000000000 +0000
@@ -937,7 +937,7 @@ static int unuse_vma(struct vm_area_stru
 	unsigned long addr, end, next;
 	int ret;
 
-	if (page->mapping) {
+	if (page_anon_vma(page)) {
 		addr = page_address_in_vma(page, vma);
 		if (addr == -EFAULT)
 			return 0;
