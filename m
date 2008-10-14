Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYJNBqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYJNBqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYJNBp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:45:58 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:52365 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYJNBp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:45:58 -0400
X-Greylist: delayed 448 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2008 21:45:57 EDT
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH/RFC] Add helper for allocating and freeing discontiguous  page array.
Date: Tue, 14 Oct 2008 03:38:17 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810140338.18548.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

you suggested this helper and so I implemented it :-)
Diff is against Linus' current git. Compile tested with allyesconfig.
Checked with checkpatch.

Best Regards

Ingo Oeser

Signed-off-by: Ingo Oeser <ioe-lkml@rameria.de>
---
 include/linux/gfp.h |    2 ++
 mm/page_alloc.c     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index e8003af..0e2453a 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -249,5 +249,7 @@ void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(void);
 void drain_local_pages(void *dummy);
+int alloc_page_array(struct page **pages, unsigned int count, gfp_t gfp_mask);
+void free_page_array(struct page **pages, unsigned int count);
 
 #endif /* __LINUX_GFP_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 27b8681..459e4bb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1757,6 +1757,54 @@ void free_pages_exact(void *virt, size_t size)
 }
 EXPORT_SYMBOL(free_pages_exact);
 
+
+/**
+ * free_page_array - free a number of physically non-contiguous pages.
+ * @pages: the array for pages to free
+ * @count: the number of pages to free
+ */
+void free_page_array(struct page **pages, unsigned int count)
+{
+	unsigned int i;
+
+	for (i = 0; i < count; ++i) {
+		if (pages[i])
+			__free_page(pages[i]);
+	}
+}
+EXPORT_SYMBOL_GPL(free_page_array);
+
+/**
+ * alloc_page_array - allocate a number of physically non-contiguous pages.
+ * @pages: the array for pages to allocate into
+ * @count: the number of pages to allocate
+ * @gfp_mask: GFP flags for the allocation
+ *
+ * alloc_page_array can satisfy any number of pages.
+ *
+ * NOTE:  The array of pages in pages is NOT physically or virtually contiguous!
+ * Use alloc_pages or similiar for physically contiguous pages or vmalloc
+ * and friends for virtually contiguous pages.
+ *
+ * Memory allocated by this function can be release via free_page_array.
+ *
+ * Returns 0 on success and %-ENOMEM on failure.
+ */
+int alloc_page_array(struct page **pages, unsigned int count, gfp_t gfp_mask)
+{
+	unsigned int i;
+
+	for (i = 0; i < count; ++i) {
+		pages[i] = alloc_page(gfp_mask);
+		if (!pages[i] && i > 0) {
+			free_page_array(pages, i);
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(alloc_page_array);
+
 static unsigned int nr_free_zone_pages(int offset)
 {
 	struct zoneref *z;
-- 
1.5.4.3

