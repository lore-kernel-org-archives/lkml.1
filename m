Return-Path: <linux-kernel-owner+w=401wt.eu-S1761745AbXFTSjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbXFTSjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759270AbXFTSbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:31:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46753 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758252AbXFTSaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:15 -0400
Message-Id: <20070620183014.699765111@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:44 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [37/37] Reiserfs: Fix up for mapping_set_gfp_mask
Content-Disposition: inline; filename=vps_filesystem_reiserfs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mapping_set_gfp_mask only works on order 0 page cache operations. Reiserfs
can use 8k pages (order 1). Replace the mapping_set_gfp_mask with
mapping_setup to make this work properly.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/reiserfs/xattr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm2/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/fs/reiserfs/xattr.c	2007-06-19 23:54:38.000000000 -0700
+++ linux-2.6.22-rc4-mm2/fs/reiserfs/xattr.c	2007-06-19 23:56:40.000000000 -0700
@@ -405,9 +405,10 @@ static struct page *reiserfs_get_page(st
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
