Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZL3THx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZL3THx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZL3THw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:07:52 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:1313 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbZL3THv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:07:51 -0500
X-Trace: 313888744/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQBAO8yO0tPRRyw/2dsb2JhbAAI1zmEMQSBaA
X-IronPort-AV: E=Sophos;i="4.47,476,1257120000"; 
   d="scan'208";a="313888744"
Date: Wed, 30 Dec 2009 19:07:47 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Jens Axboe <jens.axboe@oracle.com>
cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] block: discard use gfp_mask
Message-ID: <alpine.LSU.2.00.0912301900460.25340@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkdev_issue_discard() takes a gfp_mask argument: usually GFP_KERNEL,
but GFP_NOIO from swap and GFP_NOFS from gfs2.  blkdev_issue_discard()
should use that for its alloc_page(), instead of assuming GFP_KERNEL.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 block/blk-barrier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.33-rc2/block/blk-barrier.c	2009-12-03 03:51:21.000000000 +0000
+++ linux/block/blk-barrier.c	2009-12-26 18:28:30.000000000 +0000
@@ -402,7 +402,7 @@ int blkdev_issue_discard(struct block_de
 		 * our current implementations need.  If we'll ever need
 		 * more the interface will need revisiting.
 		 */
-		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		page = alloc_page(gfp_mask | __GFP_ZERO);
 		if (!page)
 			goto out_free_bio;
 		if (bio_add_pc_page(q, bio, page, sector_size, 0) < sector_size)
