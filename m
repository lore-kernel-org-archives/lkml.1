Return-Path: <linux-kernel-owner+w=401wt.eu-S934317AbXGXCNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317AbXGXCNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 22:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761245AbXGXCMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 22:12:17 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:40678 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756972AbXGXCMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 22:12:13 -0400
Message-ID: <385243123.22470@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070724020042.588573597@mail.ustc.edu.cn>
References: <20070724020009.677809022@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Tue, 24 Jul 2007 10:00:15 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH 06/10] readahead: remove the local copy of ra in do_generic_mapping_read()
Content-Disposition: inline; filename=remove-duplicate-ra.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The local copy of ra in do_generic_mapping_read() can now go away.

It predates readanead(req_size).  In a time when the readahead code was called
on *every* single page. Hence a local has to be made to reduce the chance of
the readahead state being overwritten by a concurrent reader. More details in:
Linux: Random File I/O Regressions In 2.6 <http://kerneltrap.org/node/3039>

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/filemap.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/mm/filemap.c
+++ linux-2.6.22-rc6-mm1/mm/filemap.c
@@ -863,7 +863,7 @@ static void shrink_readahead_size_eio(st
  * It may be NULL.
  */
 void do_generic_mapping_read(struct address_space *mapping,
-			     struct file_ra_state *_ra,
+			     struct file_ra_state *ra,
 			     struct file *filp,
 			     loff_t *ppos,
 			     read_descriptor_t *desc,
@@ -877,12 +877,11 @@ void do_generic_mapping_read(struct addr
 	unsigned long prev_index;
 	unsigned int prev_offset;
 	int error;
-	struct file_ra_state ra = *_ra;
 
 	index = *ppos >> PAGE_CACHE_SHIFT;
 	next_index = index;
-	prev_index = ra.prev_pos >> PAGE_CACHE_SHIFT;
-	prev_offset = ra.prev_pos & (PAGE_CACHE_SIZE-1);
+	prev_index = ra->prev_pos >> PAGE_CACHE_SHIFT;
+	prev_offset = ra->prev_pos & (PAGE_CACHE_SIZE-1);
 	last_index = (*ppos + desc->count + PAGE_CACHE_SIZE-1) >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 
@@ -897,7 +896,7 @@ find_page:
 		page = find_get_page(mapping, index);
 		if (!page) {
 			page_cache_sync_readahead(mapping,
-					&ra, filp,
+					ra, filp,
 					index, last_index - index);
 			page = find_get_page(mapping, index);
 			if (unlikely(page == NULL))
@@ -905,7 +904,7 @@ find_page:
 		}
 		if (PageReadahead(page)) {
 			page_cache_async_readahead(mapping,
-					&ra, filp, page,
+					ra, filp, page,
 					index, last_index - index);
 		}
 		if (!PageUptodate(page))
@@ -1016,7 +1015,7 @@ readpage:
 				}
 				unlock_page(page);
 				error = -EIO;
-				shrink_readahead_size_eio(filp, &ra);
+				shrink_readahead_size_eio(filp, ra);
 				goto readpage_error;
 			}
 			unlock_page(page);
@@ -1053,10 +1052,9 @@ no_cached_page:
 	}
 
 out:
-	*_ra = ra;
-	_ra->prev_pos = prev_index;
-	_ra->prev_pos <<= PAGE_CACHE_SHIFT;
-	_ra->prev_pos |= prev_offset;
+	ra->prev_pos = prev_index;
+	ra->prev_pos <<= PAGE_CACHE_SHIFT;
+	ra->prev_pos |= prev_offset;
 
 	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
 	if (filp)

--
