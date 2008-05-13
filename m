Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbYEMV1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbYEMV1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbYEMV06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:26:58 -0400
Received: from de01egw01.freescale.net ([192.88.165.102]:62199 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbYEMV05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:26:57 -0400
From: Timur Tabi <timur@freescale.com>
To: andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: [PATCH][RFC] Add alloc_pages_exact() and free_pages_exact()
Date: Tue, 13 May 2008 16:26:46 -0500
Message-Id: <1210714006-8976-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_pages_exact() is similar to alloc_pages(), except that it allocates
the minimum number of pages to fulfill the request.  This is useful if you
want to allocate a very large buffer that is slightly larger than an
even power-of-two number of pages.  In that case, alloc_pages() will waste
a lot of memory.

I have a video driver that wants to allocate a 5MB buffer.  alloc_pages()
will waste 3MB of physically-contiguous memory.  Therefore, I would
like to see alloc_pages_exact() added to 2.6.27.

Please note that I am not a Linux VM expert.  I wrote these functions based
on guidance from Andi Kleen.  I have no familiarity with NUMA, so I don't know
how to handle that.  Any and all suggestions are welcome.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 include/linux/gfp.h |    3 ++
 mm/page_alloc.c     |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b414be3..1054801 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -215,6 +215,9 @@ extern struct page *alloc_page_vma(gfp_t gfp_mask,
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
+void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
+void free_pages_exact(void *virt, size_t size);
+
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask),0)
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bdd5c43..2b685eb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1736,6 +1736,59 @@ void free_pages(unsigned long addr, unsigned int order)
 
 EXPORT_SYMBOL(free_pages);
 
+/**
+ * Allocate an exact number of pages of physically-contiguous memory.
+ *
+ * This function is similar to alloc_pages(), except that it allocates the
+ * minimum number of pages to satisfy the request.  alloc_pages() can only
+ * allocate memory in power-of-two pages.
+ *
+ * This function is also limited by MAX_ORDER.
+ *
+ * Memory allocated by this function must be released by free_pages_exact().
+ */
+void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
+{
+	unsigned int order = get_order(size);
+	unsigned long addr;
+
+	addr = __get_free_pages(gfp_mask, order);
+	if (addr) {
+		unsigned long alloc_end = addr + (PAGE_SIZE << order);
+		unsigned long used = addr + PAGE_ALIGN(size);
+
+		split_page(virt_to_page(addr), order);
+		while (used < alloc_end) {
+			free_page(used);
+			used += PAGE_SIZE;
+		}
+	}
+
+	return (void *)addr;
+}
+EXPORT_SYMBOL(alloc_pages_exact);
+
+/**
+ * Releases memory allocated via alloc_pages_exact()
+ *
+ * Release the memory allocated by a previous call to alloc_pages_exact.
+ *
+ * The first parameter must be the value returned by alloc_pages_exact(),
+ * and the 'size' parameter must be the same as was passed to
+ * alloc_pages_exact().
+ */
+void free_pages_exact(void *virt, size_t size)
+{
+	unsigned long addr = (unsigned long)virt;
+	unsigned long end = addr + PAGE_ALIGN(size);
+
+	while (addr < end) {
+		free_page(addr);
+		addr += PAGE_SIZE;
+	}
+}
+EXPORT_SYMBOL(free_pages_exact);
+
 static unsigned int nr_free_zone_pages(int offset)
 {
 	struct zoneref *z;
-- 
1.5.5

