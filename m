Return-Path: <linux-kernel-owner+w=401wt.eu-S1423181AbXDXWXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423181AbXDXWXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423177AbXDXWXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:23:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56778 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423157AbXDXWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:06 -0400
Message-Id: <20070424222304.884706862@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:07 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [02/17] Fix page allocation flags in grow_dev_page()
Content-Disposition: inline; filename=fix_buffer_alloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grow dev page simply passes GFP_NOFS to find_or_create_page. This means the
allocation of radix tree nodes is done with GFP_NOFS and the allocation
of a new page is done using GFP_NOFS.

The mapping has a flags field that contains the necessary allocation flags for
the page cache allocation. These need to be consulted in order to get DMA
and HIGHMEM allocations etc right.

So fix grow_dev_page to do the same as __page_symlink calls. Retrieve the
mask from the mapping and then remove __GFP_FS.

[mm has other changes to this code. Will post a different patch when diffing against mm]

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/buffer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc7/fs/buffer.c
===================================================================
--- linux-2.6.21-rc7.orig/fs/buffer.c	2007-04-23 15:29:18.000000000 -0700
+++ linux-2.6.21-rc7/fs/buffer.c	2007-04-23 15:29:43.000000000 -0700
@@ -988,7 +988,8 @@ grow_dev_page(struct block_device *bdev,
 	struct page *page;
 	struct buffer_head *bh;
 
-	page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
+	page = find_or_create_page(inode->i_mapping, index,
+		mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 	if (!page)
 		return NULL;
 

--
