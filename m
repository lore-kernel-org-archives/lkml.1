Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbZG3Mqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbZG3Mqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZG3Mqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:46:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46425 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbZG3Mqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:46:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/7] GFS2: Don't try and dealloc own inode
Date: Thu, 30 Jul 2009 14:45:21 +0100
Message-Id: <1248961524-30913-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1248961524-30913-4-git-send-email-swhiteho@redhat.com>
References: <1248961524-30913-1-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-2-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-3-git-send-email-swhiteho@redhat.com>
 <1248961524-30913-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When searching for unlinked, but still allocated inodes during block
allocation, avoid the block relating to the inode that is doing the
allocation. This fixes a hang caused when an unlinked, but still
open, inode tries to allocate some more blocks and lands up
finding itself during the search for deallocatable inodes.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/rgrp.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index daa4ae3..5e50741 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -961,7 +961,8 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
  * Returns: The inode, if one has been found
  */
 
-static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
+static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked,
+				     u64 skip)
 {
 	struct inode *inode;
 	u32 goal = 0, block;
@@ -985,6 +986,8 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 		goal++;
 		if (*last_unlinked != NO_BLOCK && no_addr <= *last_unlinked)
 			continue;
+		if (no_addr == skip)
+			continue;
 		*last_unlinked = no_addr;
 		inode = gfs2_inode_lookup(rgd->rd_sbd->sd_vfs, DT_UNKNOWN,
 					  no_addr, -1, 1);
@@ -1104,7 +1107,7 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			if (try_rgrp_fit(rgd, al))
 				goto out;
 			if (rgd->rd_flags & GFS2_RDF_CHECK)
-				inode = try_rgrp_unlink(rgd, last_unlinked);
+				inode = try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&al->al_rgd_gh);
 			if (inode)
@@ -1138,7 +1141,7 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 			if (try_rgrp_fit(rgd, al))
 				goto out;
 			if (rgd->rd_flags & GFS2_RDF_CHECK)
-				inode = try_rgrp_unlink(rgd, last_unlinked);
+				inode = try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&al->al_rgd_gh);
 			if (inode)
-- 
1.6.2.2

