Return-Path: <linux-kernel-owner+w=401wt.eu-S1762795AbXFTSll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762795AbXFTSll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759529AbXFTSbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46752 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757361AbXFTSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:11 -0400
Message-Id: <20070620183010.870024277@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:28 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [21/37] Use page_cache_xxx in drivers/block/loop.c
Content-Disposition: inline; filename=vps_drivers_block_loop
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/block/loop.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/block/loop.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/block/loop.c	2007-06-19 20:50:30.000000000 -0700
+++ linux-2.6.22-rc4-mm2/drivers/block/loop.c	2007-06-20 00:34:46.000000000 -0700
@@ -215,8 +215,8 @@ static int do_lo_send_aops(struct loop_d
 	int len, ret;
 
 	mutex_lock(&mapping->host->i_mutex);
-	index = pos >> PAGE_CACHE_SHIFT;
-	offset = pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
+	index = page_cache_index(mapping, pos);
+	offset = page_cache_offset(mapping, pos);
 	bv_offs = bvec->bv_offset;
 	len = bvec->bv_len;
 	while (len > 0) {
@@ -226,8 +226,9 @@ static int do_lo_send_aops(struct loop_d
 		struct page *page;
 		void *fsdata;
 
-		IV = ((sector_t)index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9);
-		size = PAGE_CACHE_SIZE - offset;
+		IV = ((sector_t)index << (page_cache_shift(mapping) - 9))
+							+ (offset >> 9);
+		size = page_cache_size(mapping) - offset;
 		if (size > len)
 			size = len;
 
@@ -393,7 +394,9 @@ lo_read_actor(read_descriptor_t *desc, s
 	struct loop_device *lo = p->lo;
 	sector_t IV;
 
-	IV = ((sector_t) page->index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9);
+	IV = ((sector_t) page->index <<
+			(page_cache_shift(page_mapping(page)) - 9))
+			+ (offset >> 9);
 
 	if (size > count)
 		size = count;

-- 
