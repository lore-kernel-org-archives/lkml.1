Return-Path: <linux-kernel-owner+w=401wt.eu-S934822AbYDQJpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934822AbYDQJpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763895AbYDQJ0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933691AbYDQJ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:06 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/48] [GFS2] Reduce inode size by merging fields
Date: Thu, 17 Apr 2008 09:38:57 +0100
Message-Id: <12084216121811-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216101961-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

There were three fields being used to keep track of the location
of the most recently allocated block for each inode. These have
been merged into a single field in order to better keep the
data and metadata for an inode close on disk, and also to reduce
the space required for storage.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 2011dd2..30d718b 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1020,9 +1020,7 @@ static int trunc_end(struct gfs2_inode *ip)
 
 	if (!ip->i_di.di_size) {
 		ip->i_height = 0;
-		ip->i_di.di_goal_meta =
-			ip->i_di.di_goal_data =
-			ip->i_no_addr;
+		ip->i_goal = ip->i_no_addr;
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 	}
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index b67e44b..c50dcdf 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -241,8 +241,6 @@ enum {
 struct gfs2_dinode_host {
 	u64 di_size;		/* number of bytes in file */
 	u64 di_blocks;		/* number of blocks in file */
-	u64 di_goal_meta;	/* rgrp to alloc from next */
-	u64 di_goal_data;	/* data block goal */
 	u64 di_generation;	/* generation number for NFS */
 	u32 di_flags;		/* GFS2_DIF_... */
 	/* These only apply to directories  */
@@ -262,8 +260,7 @@ struct gfs2_inode {
 	struct gfs2_holder i_iopen_gh;
 	struct gfs2_holder i_gh; /* for prepare/commit_write only */
 	struct gfs2_alloc *i_alloc;
-	u64 i_last_rg_alloc;
-
+	u64 i_goal;	/* goal block for allocations */
 	struct rw_semaphore i_rw_mutex;
 	u8 i_height;
 	u8 i_depth;
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 65fdfee..c3fe8aa 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -282,8 +282,7 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_inode.i_ctime.tv_sec = be64_to_cpu(str->di_ctime);
 	ip->i_inode.i_ctime.tv_nsec = be32_to_cpu(str->di_ctime_nsec);
 
-	di->di_goal_meta = be64_to_cpu(str->di_goal_meta);
-	di->di_goal_data = be64_to_cpu(str->di_goal_data);
+	ip->i_goal = be64_to_cpu(str->di_goal_meta);
 	di->di_generation = be64_to_cpu(str->di_generation);
 
 	di->di_flags = be32_to_cpu(str->di_flags);
@@ -1404,8 +1403,8 @@ void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf)
 	str->di_mtime = cpu_to_be64(ip->i_inode.i_mtime.tv_sec);
 	str->di_ctime = cpu_to_be64(ip->i_inode.i_ctime.tv_sec);
 
-	str->di_goal_meta = cpu_to_be64(di->di_goal_meta);
-	str->di_goal_data = cpu_to_be64(di->di_goal_data);
+	str->di_goal_meta = cpu_to_be64(ip->i_goal);
+	str->di_goal_data = cpu_to_be64(ip->i_goal);
 	str->di_generation = cpu_to_be64(di->di_generation);
 
 	str->di_flags = cpu_to_be32(di->di_flags);
@@ -1433,10 +1432,8 @@ void gfs2_dinode_print(const struct gfs2_inode *ip)
 	printk(KERN_INFO "  di_size = %llu\n", (unsigned long long)di->di_size);
 	printk(KERN_INFO "  di_blocks = %llu\n",
 	       (unsigned long long)di->di_blocks);
-	printk(KERN_INFO "  di_goal_meta = %llu\n",
-	       (unsigned long long)di->di_goal_meta);
-	printk(KERN_INFO "  di_goal_data = %llu\n",
-	       (unsigned long long)di->di_goal_data);
+	printk(KERN_INFO "  i_goal = %llu\n",
+	       (unsigned long long)ip->i_goal);
 	printk(KERN_INFO "  di_flags = 0x%.8X\n", di->di_flags);
 	printk(KERN_INFO "  i_height = %u\n", ip->i_height);
 	printk(KERN_INFO "  i_depth = %u\n", ip->i_depth);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 3f10b1f..66193b4 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -915,24 +915,20 @@ static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
 static struct gfs2_rgrpd *recent_rgrp_first(struct gfs2_sbd *sdp,
 					    u64 rglast)
 {
-	struct gfs2_rgrpd *rgd = NULL;
+	struct gfs2_rgrpd *rgd;
 
 	spin_lock(&sdp->sd_rindex_spin);
 
-	if (list_empty(&sdp->sd_rindex_recent_list))
-		goto out;
-
-	if (!rglast)
-		goto first;
-
-	list_for_each_entry(rgd, &sdp->sd_rindex_recent_list, rd_recent) {
-		if (rgd->rd_addr == rglast)
-			goto out;
+	if (rglast) {
+		list_for_each_entry(rgd, &sdp->sd_rindex_recent_list, rd_recent) {
+			if (rgrp_contains_block(rgd, rglast))
+				goto out;
+		}
 	}
-
-first:
-	rgd = list_entry(sdp->sd_rindex_recent_list.next, struct gfs2_rgrpd,
-			 rd_recent);
+	rgd = NULL;
+	if (!list_empty(&sdp->sd_rindex_recent_list))
+		rgd = list_entry(sdp->sd_rindex_recent_list.next,
+				 struct gfs2_rgrpd, rd_recent);
 out:
 	spin_unlock(&sdp->sd_rindex_spin);
 	return rgd;
@@ -1078,7 +1074,7 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 
 	/* Try recently successful rgrps */
 
-	rgd = recent_rgrp_first(sdp, ip->i_last_rg_alloc);
+	rgd = recent_rgrp_first(sdp, ip->i_goal);
 
 	while (rgd) {
 		rg_locked = 0;
@@ -1162,8 +1158,6 @@ static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	}
 
 out:
-	ip->i_last_rg_alloc = rgd->rd_addr;
-
 	if (begin) {
 		recent_rgrp_add(rgd);
 		rgd = gfs2_rgrpd_get_next(rgd);
@@ -1425,8 +1419,8 @@ u64 gfs2_alloc_data(struct gfs2_inode *ip)
 	u32 goal, blk;
 	u64 block;
 
-	if (rgrp_contains_block(rgd, ip->i_di.di_goal_data))
-		goal = ip->i_di.di_goal_data - rgd->rd_data0;
+	if (rgrp_contains_block(rgd, ip->i_goal))
+		goal = ip->i_goal - rgd->rd_data0;
 	else
 		goal = rgd->rd_last_alloc_data;
 
@@ -1435,7 +1429,7 @@ u64 gfs2_alloc_data(struct gfs2_inode *ip)
 	rgd->rd_last_alloc_data = blk;
 
 	block = rgd->rd_data0 + blk;
-	ip->i_di.di_goal_data = block;
+	ip->i_goal = block;
 
 	gfs2_assert_withdraw(sdp, rgd->rd_rg.rg_free);
 	rgd->rd_rg.rg_free--;
@@ -1470,8 +1464,8 @@ u64 gfs2_alloc_meta(struct gfs2_inode *ip)
 	u32 goal, blk;
 	u64 block;
 
-	if (rgrp_contains_block(rgd, ip->i_di.di_goal_meta))
-		goal = ip->i_di.di_goal_meta - rgd->rd_data0;
+	if (rgrp_contains_block(rgd, ip->i_goal))
+		goal = ip->i_goal - rgd->rd_data0;
 	else
 		goal = rgd->rd_last_alloc_meta;
 
@@ -1480,7 +1474,7 @@ u64 gfs2_alloc_meta(struct gfs2_inode *ip)
 	rgd->rd_last_alloc_meta = blk;
 
 	block = rgd->rd_data0 + blk;
-	ip->i_di.di_goal_meta = block;
+	ip->i_goal = block;
 
 	gfs2_assert_withdraw(sdp, rgd->rd_rg.rg_free);
 	rgd->rd_rg.rg_free--;
-- 
1.5.1.2

