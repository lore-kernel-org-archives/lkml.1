Return-Path: <linux-kernel-owner+w=401wt.eu-S1423169AbXDXWXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423169AbXDXWXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423184AbXDXWXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:23:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43896 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423169AbXDXWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:06 -0400
Message-Id: <20070424222305.173727019@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:08 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [03/17] Fix: find_or_create_page does not spread memory.
Content-Disposition: inline; filename=fix_find_or_create
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The find_or_create function calls alloc_page with the gfp_mask passed to it
which is derived from the mappings gfp mask. So the allocation flags are right
(assuming my bugfix to fs/buffer.c is applied).

However, we call a alloc_page instead of page_cache_alloc in find_or_create_page.
This means that the page cache allocation will not obey cpuset memory spreading.

We really need to call __page_cache_alloc there.

Also stick a comment in there explaining how the allocation mask passed to
find_or_create_page needs to be handled.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/filemap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc7/mm/filemap.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/filemap.c	2007-04-23 15:37:27.000000000 -0700
+++ linux-2.6.21-rc7/mm/filemap.c	2007-04-23 15:38:09.000000000 -0700
@@ -648,7 +648,8 @@ EXPORT_SYMBOL(find_lock_page);
  * find_or_create_page - locate or add a pagecache page
  * @mapping: the page's address_space
  * @index: the page's index into the mapping
- * @gfp_mask: page allocation mode
+ * @gfp_mask: page allocation mode. This must be derived from the
+ * 	allocation flags of the mapping!
  *
  * Locates a page in the pagecache.  If the page is not present, a new page
  * is allocated using @gfp_mask and is added to the pagecache and to the VM's
@@ -670,7 +671,8 @@ repeat:
 	page = find_lock_page(mapping, index);
 	if (!page) {
 		if (!cached_page) {
-			cached_page = alloc_page(gfp_mask);
+			cached_page =
+				__page_cache_alloc(gfp_mask);
 			if (!cached_page)
 				return NULL;
 		}

--
