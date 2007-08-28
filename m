Return-Path: <linux-kernel-owner+w=401wt.eu-S1762561AbXH1TRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762561AbXH1TRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761349AbXH1TIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58809 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759119AbXH1THl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:41 -0400
Message-Id: <20070828190728.141216711@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:05:53 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [02/36] Define functions for page cache handling
Content-Disposition: inline; filename=0002-Define-functions-for-page-cache-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We use the macros PAGE_CACHE_SIZE PAGE_CACHE_SHIFT PAGE_CACHE_MASK
and PAGE_CACHE_ALIGN in various places in the kernel. Many times
common operations like calculating the offset or the index are coded
using shifts and adds. This patch provides inline functions to
get the calculations accomplished without having to explicitly
shift and add constants.

All functions take an address_space pointer. The address space pointer
will be used in the future to eventually support a variable size
page cache. Information reachable via the mapping may then determine
page size.

New function                    Related base page constant
====================================================================
page_cache_shift(a)             PAGE_CACHE_SHIFT
page_cache_size(a)              PAGE_CACHE_SIZE
page_cache_mask(a)              PAGE_CACHE_MASK
page_cache_index(a, pos)        Calculate page number from position
page_cache_next(addr, pos)      Page number of next page
page_cache_offset(a, pos)       Calculate offset into a page
page_cache_pos(a, index, offset)
                                Form position based on page number
                                and an offset.

This provides a basis that would allow the conversion of all page cache
handling in the kernel and ultimately allow the removal of the PAGE_CACHE_*
constants.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/pagemap.h |   54 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 8a83537..836e9dd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -52,12 +52,66 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
  * space in smaller chunks for same flexibility).
  *
  * Or rather, it _will_ be done in larger chunks.
+ *
+ * The following constants can be used if a filesystem only supports a single
+ * page size.
  */
 #define PAGE_CACHE_SHIFT	PAGE_SHIFT
 #define PAGE_CACHE_SIZE		PAGE_SIZE
 #define PAGE_CACHE_MASK		PAGE_MASK
 #define PAGE_CACHE_ALIGN(addr)	(((addr)+PAGE_CACHE_SIZE-1)&PAGE_CACHE_MASK)
 
+/*
+ * Functions that are currently setup for a fixed PAGE_SIZEd. The use of
+ * these will allow a variable page size pagecache in the future.
+ */
+static inline int mapping_order(struct address_space *a)
+{
+	return 0;
+}
+
+static inline int page_cache_shift(struct address_space *a)
+{
+	return PAGE_SHIFT;
+}
+
+static inline unsigned int page_cache_size(struct address_space *a)
+{
+	return PAGE_SIZE;
+}
+
+static inline loff_t page_cache_mask(struct address_space *a)
+{
+	return (loff_t)PAGE_MASK;
+}
+
+static inline unsigned int page_cache_offset(struct address_space *a,
+		loff_t pos)
+{
+	return pos & ~PAGE_MASK;
+}
+
+static inline pgoff_t page_cache_index(struct address_space *a,
+		loff_t pos)
+{
+	return pos >> page_cache_shift(a);
+}
+
+/*
+ * Index of the page starting on or after the given position.
+ */
+static inline pgoff_t page_cache_next(struct address_space *a,
+		loff_t pos)
+{
+	return page_cache_index(a, pos + page_cache_size(a) - 1);
+}
+
+static inline loff_t page_cache_pos(struct address_space *a,
+		pgoff_t index, unsigned long offset)
+{
+	return ((loff_t)index << page_cache_shift(a)) + offset;
+}
+
 #define page_cache_get(page)		get_page(page)
 #define page_cache_release(page)	put_page(page)
 void release_pages(struct page **pages, int nr, int cold);
-- 
1.5.2.4

-- 
