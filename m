Return-Path: <linux-kernel-owner+w=401wt.eu-S1763026AbXIKGRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763026AbXIKGRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbXIKGGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:06:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50588 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761648AbXIKGEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:34 -0400
Message-Id: <20070911060433.722347749@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:25 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [35/41] Reiserfs: Fix up mapping_set_gfp_mask()
Content-Disposition: inline; filename=0036-Reiserfs-Fix-up-for-mapping_set_gfp_mask.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mapping_set_gfp_mask only works on order 0 page cache operations. Reiserfs
can use 8k pages (order 1). Replace the mapping_set_gfp_mask with
mapping_setup to make this work properly.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 fs/reiserfs/xattr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index c86f570..5ca01f3 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -405,9 +405,10 @@ static struct page *reiserfs_get_page(struct inode *dir, unsigned long n)
 {
 	struct address_space *mapping = dir->i_mapping;
 	struct page *page;
+
 	/* We can deadlock if we try to free dentries,
 	   and an unlink/rmdir has just occured - GFP_NOFS avoids this */
-	mapping_set_gfp_mask(mapping, GFP_NOFS);
+	mapping_setup(mapping, GFP_NOFS, page_cache_shift(mapping));
 	page = read_mapping_page(mapping, n, NULL);
 	if (!IS_ERR(page)) {
 		kmap(page);
-- 
1.5.2.5

-- 
