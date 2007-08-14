Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbXHNKQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbXHNKQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbXHNKK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbXHNKKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:50 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] soft lockup in rgblk_search
Date: Tue, 14 Aug 2007 10:47:12 +0100
Message-Id: <11870848551556-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch seems to fix the problem described in bugzilla bug 246114.
It was written by Steve Whitehouse with some tweaking by me.

The code was looping in the relatively new section of code designed to
search for and reuse unlinked inodes.  In cases where it was finding an
appropriate inode to reuse, it was looping around and finding the same
block over and over because a "<=" check should have been a "<" when
comparing the goal block to the last unlinked block found.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index e4e0406..bb58e69 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -863,16 +863,19 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 	u64 no_addr;
 
 	for(;;) {
+		if (goal >= rgd->rd_data)
+			break;
 		goal = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED,
 				    GFS2_BLKST_UNLINKED);
 		if (goal == 0)
-			return 0;
+			break;
 		no_addr = goal + rgd->rd_data0;
-		if (no_addr <= *last_unlinked)
+		goal++;
+		if (no_addr < *last_unlinked)
 			continue;
 		*last_unlinked = no_addr;
 		inode = gfs2_inode_lookup(rgd->rd_sbd->sd_vfs, DT_UNKNOWN,
-					no_addr, -1);
+					  no_addr, -1);
 		if (!IS_ERR(inode))
 			return inode;
 	}
-- 
1.5.1.2

