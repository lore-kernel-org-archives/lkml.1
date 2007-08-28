Return-Path: <linux-kernel-owner+w=401wt.eu-S1762668AbXH1TRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762668AbXH1TRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbXH1TIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58427 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759397AbXH1THl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:41 -0400
Message-Id: <20070828190736.452897090@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:27 -0700
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
Subject: [36/36] Reiserfs: Fix up for mapping_set_gfp_mask
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
1.5.2.4

-- 
