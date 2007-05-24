Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbXEXQsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbXEXQsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXEXQsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:48:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:53992 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750718AbXEXQsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:48:16 -0400
Date: Thu, 24 May 2007 18:59:35 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 1/2] Fix possible UDF data corruption
Message-ID: <20070524165935.GB19709@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi Andrew,

  attached patch fixes possible data corruption in UDF - this bug was actually
introduced by one of my fixes :-( and should (if possible) go to Linus before
2.6.22 is out (that's why I'm diffing against Linus's tree and not the
latest changes in -mm tree)... Thanks.

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--UHN/qo2QbUvPLonB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="udf-2.6.22-rc2-1-udf_data_corruption.diff"

update_next_aext() could possibly rewrite values in elen and eloc, possibly
leading to data corruption when rewriting a file. Use temporary variables
instead. Also advance cur_epos as it can also point to an indirect extent
pointer.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.22-rc2/fs/udf/inode.c linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/inode.c
--- linux-2.6.22-rc2/fs/udf/inode.c	2007-05-24 18:00:05.000000000 +0200
+++ linux-2.6.22-rc2-1-udf_data_corruption/fs/udf/inode.c	2007-05-24 18:16:36.000000000 +0200
@@ -460,8 +460,8 @@ static struct buffer_head * inode_getblk
 	kernel_long_ad laarr[EXTENT_MERGE_SIZE];
 	struct extent_position prev_epos, cur_epos, next_epos;
 	int count = 0, startnum = 0, endnum = 0;
-	uint32_t elen = 0;
-	kernel_lb_addr eloc;
+	uint32_t elen = 0, tmpelen;
+	kernel_lb_addr eloc, tmpeloc;
 	int c = 1;
 	loff_t lbcount = 0, b_off = 0;
 	uint32_t newblocknum, newblock;
@@ -520,8 +520,12 @@ static struct buffer_head * inode_getblk
 
 	b_off -= lbcount;
 	offset = b_off >> inode->i_sb->s_blocksize_bits;
-	/* Move into indirect extent if we are at a pointer to it */
-	udf_next_aext(inode, &prev_epos, &eloc, &elen, 0);
+	/*
+	 * Move prev_epos and cur_epos into indirect extent if we are at
+	 * the pointer to it
+	 */
+	udf_next_aext(inode, &prev_epos, &tmpeloc, &tmpelen, 0);
+	udf_next_aext(inode, &cur_epos, &tmpeloc, &tmpelen, 0);
 
 	/* if the extent is allocated and recorded, return the block
        if the extent is not a multiple of the blocksize, round up */

--UHN/qo2QbUvPLonB--
