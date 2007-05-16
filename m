Return-Path: <linux-kernel-owner+w=401wt.eu-S1759697AbXEPWvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697AbXEPWvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbXEPWsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:48:40 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50152 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758534AbXEPWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:48:33 -0400
Message-ID: <379355696.96896@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070516224819.281192313@mail.ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Thu, 17 May 2007 06:48:00 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 8/9] readahead: convert ext3/ext4 invocations
Content-Disposition: inline; filename=readahead-invocations-dir.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert ext3/ext4 dir reads to use on-demand readahead.

Readahead for dirs operates _not_ on file level, but on blockdev level.
This makes a difference when the data blocks are not continuous.
And the read routine is somehow opaque: there's no handy info about the status
of current page. So a simplified call scheme is employed: to call into
readahead whenever the current page falls out of readahead windows.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 fs/ext3/dir.c |   14 ++++++++------
 fs/ext4/dir.c |   14 ++++++++------
 2 files changed, 16 insertions(+), 12 deletions(-)

--- linux-2.6.22-rc1-mm1.orig/fs/ext3/dir.c
+++ linux-2.6.22-rc1-mm1/fs/ext3/dir.c
@@ -136,12 +136,14 @@ static int ext3_readdir(struct file * fi
 		err = ext3_get_blocks_handle(NULL, inode, blk, 1,
 						&map_bh, 0, 0);
 		if (err > 0) {
-			page_cache_readahead(sb->s_bdev->bd_inode->i_mapping,
-				&filp->f_ra,
-				filp,
-				map_bh.b_blocknr >>
-					(PAGE_CACHE_SHIFT - inode->i_blkbits),
-				1);
+			pgoff_t index = map_bh.b_blocknr >>
+					(PAGE_CACHE_SHIFT - inode->i_blkbits);
+			if (!ra_has_index(&filp->f_ra, index))
+				page_cache_readahead_ondemand(
+					sb->s_bdev->bd_inode->i_mapping,
+					&filp->f_ra, filp,
+					NULL, index, 1);
+			filp->f_ra.prev_index = index;
 			bh = ext3_bread(NULL, inode, blk, 0, &err);
 		}
 
--- linux-2.6.22-rc1-mm1.orig/fs/ext4/dir.c
+++ linux-2.6.22-rc1-mm1/fs/ext4/dir.c
@@ -135,12 +135,14 @@ static int ext4_readdir(struct file * fi
 		map_bh.b_state = 0;
 		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh, 0, 0);
 		if (err > 0) {
-			page_cache_readahead(sb->s_bdev->bd_inode->i_mapping,
-				&filp->f_ra,
-				filp,
-				map_bh.b_blocknr >>
-					(PAGE_CACHE_SHIFT - inode->i_blkbits),
-				1);
+			pgoff_t index = map_bh.b_blocknr >>
+					(PAGE_CACHE_SHIFT - inode->i_blkbits);
+			if (!ra_has_index(&filp->f_ra, index))
+				page_cache_readahead_ondemand(
+					sb->s_bdev->bd_inode->i_mapping,
+					&filp->f_ra, filp,
+					NULL, index, 1);
+			filp->f_ra.prev_index = index;
 			bh = ext4_bread(NULL, inode, blk, 0, &err);
 		}
 

--
