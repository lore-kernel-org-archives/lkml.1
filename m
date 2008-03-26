Return-Path: <linux-kernel-owner+w=401wt.eu-S1762074AbYCZV0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762074AbYCZV0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761329AbYCZVYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:24:15 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57193 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549AbYCZVYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:24:13 -0400
Message-ID: <47EABF09.6090302@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2008 16:24:25 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
CC: Adam Litke <agl@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/4] allow arch specific function for allocating gigantic
 pages
References: <47EABE2D.7080400@linux.vnet.ibm.com>
In-Reply-To: <47EABE2D.7080400@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow alloc_bm_huge_page() to be overridden by architectures that can't always use bootmem.
This requires huge_boot_pages to be available for use by this function.  Also huge_page_size()
and other functions need to use a long so that they can handle the 16G page size.


Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
---

 include/linux/hugetlb.h |   10 +++++++++-
 mm/hugetlb.c            |   21 +++++++++------------
 2 files changed, 18 insertions(+), 13 deletions(-)


diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index a8de3c1..35a41be 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -35,6 +35,7 @@ void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 extern unsigned long hugepages_treat_as_movable;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
+extern struct list_head huge_boot_pages;
 
 /* arch callbacks */
 
@@ -219,9 +220,15 @@ struct hstate {
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 	unsigned long parsed_hugepages;
 };
+struct huge_bm_page {
+	struct list_head list;
+	struct hstate *hstate;
+};
 
 void __init huge_add_hstate(unsigned order);
 struct hstate *huge_lookup_hstate(unsigned long pagesize);
+/* arch callback */
+int alloc_bm_huge_page(struct hstate *h);
 
 #ifndef HUGE_MAX_HSTATE
 #define HUGE_MAX_HSTATE 1
@@ -248,7 +255,7 @@ static inline struct hstate *hstate_inode(struct inode *i)
 	return HUGETLBFS_I(i)->hstate;
 }
 
-static inline unsigned huge_page_size(struct hstate *h)
+static inline unsigned long huge_page_size(struct hstate *h)
 {
 	return PAGE_SIZE << h->order;
 }
@@ -273,6 +280,7 @@ extern unsigned long sysctl_overcommit_huge_pages[HUGE_MAX_HSTATE];
 
 #else
 struct hstate {};
+#define alloc_bm_huge_page(h) NULL
 #define hstate_file(f) NULL
 #define hstate_vma(v) NULL
 #define hstate_inode(i) NULL
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c28b8b6..a0017b0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -27,6 +27,7 @@ unsigned long max_huge_pages[HUGE_MAX_HSTATE];
 unsigned long sysctl_overcommit_huge_pages[HUGE_MAX_HSTATE];
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
+struct list_head huge_boot_pages;
 
 static int max_hstate = 1;
 
@@ -43,7 +44,8 @@ struct hstate *parsed_hstate __initdata = &global_hstate;
  */
 static DEFINE_SPINLOCK(hugetlb_lock);
 
-static void clear_huge_page(struct page *page, unsigned long addr, unsigned sz)
+static void clear_huge_page(struct page *page, unsigned long addr,
+			    unsigned long sz)
 {
 	int i;
 
@@ -521,14 +523,8 @@ static __init char *memfmt(char *buf, unsigned long n)
 	return buf;
 }
 
-static __initdata LIST_HEAD(huge_boot_pages);
-
-struct huge_bm_page {
-	struct list_head list;
-	struct hstate *hstate;
-};
-
-static int __init alloc_bm_huge_page(struct hstate *h)
+/* Can be overriden by architectures */
+__attribute__((weak)) int alloc_bm_huge_page(struct hstate *h)
 {
 	struct huge_bm_page *m;
 	m = __alloc_bootmem_node_nopanic(NODE_DATA(h->hugetlb_next_nid),
@@ -614,6 +610,7 @@ static int __init hugetlb_init(void)
 {
 	if (HPAGE_SHIFT == 0)
 		return 0;
+	INIT_LIST_HEAD(&huge_boot_pages);
 	return hugetlb_init_hstate(&global_hstate);
 }
 module_init(hugetlb_init);
@@ -866,7 +863,7 @@ int hugetlb_report_meminfo(char *buf)
 	n += dump_field(buf + n, offsetof(struct hstate, surplus_huge_pages));
 	n += sprintf(buf + n, "Hugepagesize:   ");
 	for_each_hstate (h)
-		n += sprintf(buf + n, " %5u", huge_page_size(h) / 1024);
+		n += sprintf(buf + n, " %5lu", huge_page_size(h) / 1024);
 	n += sprintf(buf + n, " kB\n");
 	return n;
 }
@@ -947,7 +944,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 	unsigned long addr;
 	int cow;
 	struct hstate *h = hstate_vma(vma);
-	unsigned sz = huge_page_size(h);
+	unsigned long sz = huge_page_size(h);
 
 	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 
@@ -992,7 +989,7 @@ void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 	struct page *page;
 	struct page *tmp;
 	struct hstate *h = hstate_vma(vma);
-	unsigned sz = huge_page_size(h);
+	unsigned long sz = huge_page_size(h);
 
 	/*
 	 * A page gathering list, protected by per file i_mmap_lock. The




