Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbXGIQX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbXGIQX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755952AbXGIQXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbXGIQXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:11 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Robert Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] kernel changes to support new gfs2_grow command
Date: Mon,  9 Jul 2007 17:02:09 +0100
Message-Id: <1183996996300-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839969911617-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Peterson <rpeterso@redhat.com>

This is another revision of my gfs2 kernel patch that allows
gfs2_grow to function properly.

Steve Whitehouse expressed some concerns about the previous
patch and I restructured it based on his comments.
The previous patch was doing the statfs_change at file close time,
under its own transaction.  The current patch does the statfs_change
inside the gfs2_commit_write function, which keeps it under the
umbrella of the inode transaction.

I can't call ri_update to re-read the rindex file during the
transaction because the transaction may have outstanding unwritten
buffers attached to the rgrps that would be otherwise blown away.
So instead, I created a new function, gfs2_ri_total, that will
re-read the rindex file just to total the file system space
for the sake of the statfs_change.  The ri_update will happen
later, when gfs2 realizes the version number has changed, as it
happened before my patch.

Since the statfs_change is happening at write_commit time and there
may be multiple writes to the rindex file for one grow operation.
So one consequence of this restructuring is that instead of getting
one kernel message to indicate the change, you may see several.
For example, before when you did a gfs2_grow, you'd get a single
message like:

GFS2: File system extended by 247876 blocks (968MB)

Now you get something like:

GFS2: File system extended by 207896 blocks (812MB)
GFS2: File system extended by 39980 blocks (156MB)

This version has also been successfully run against the hours-long
"gfs2_fsck_hellfire" test that does several gfs2_grow and gfs2_fsck
while interjecting file system damage.  It does this repeatedly
under a variety Resource Group conditions.

Signed-off-By: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 30c1562..846c0ff 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -450,6 +450,30 @@ out_uninit:
 }
 
 /**
+ * adjust_fs_space - Adjusts the free space available due to gfs2_grow
+ * @inode: the rindex inode
+ */
+static void adjust_fs_space(struct inode *inode)
+{
+	struct gfs2_sbd *sdp = inode->i_sb->s_fs_info;
+	struct gfs2_statfs_change_host *m_sc = &sdp->sd_statfs_master;
+	struct gfs2_statfs_change_host *l_sc = &sdp->sd_statfs_local;
+	u64 fs_total, new_free;
+
+	/* Total up the file system space, according to the latest rindex. */
+	fs_total = gfs2_ri_total(sdp);
+
+	spin_lock(&sdp->sd_statfs_spin);
+	if (fs_total > (m_sc->sc_total + l_sc->sc_total))
+		new_free = fs_total - (m_sc->sc_total + l_sc->sc_total);
+	else
+		new_free = 0;
+	spin_unlock(&sdp->sd_statfs_spin);
+	fs_warn(sdp, "File system extended by %llu blocks.\n", new_free);
+	gfs2_statfs_change(sdp, new_free, new_free, 0);
+}
+
+/**
  * gfs2_commit_write - Commit write to a file
  * @file: The file to write to
  * @page: The page containing the data
@@ -511,6 +535,9 @@ static int gfs2_commit_write(struct file *file, struct page *page,
 		di->di_size = cpu_to_be64(inode->i_size);
 	}
 
+	if (inode == sdp->sd_rindex)
+		adjust_fs_space(inode);
+
 	brelse(dibh);
 	gfs2_trans_end(sdp);
 	if (al->al_requested) {
diff --git a/fs/gfs2/ops_address.h b/fs/gfs2/ops_address.h
index 35aaee4..56c30da 100644
--- a/fs/gfs2/ops_address.h
+++ b/fs/gfs2/ops_address.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -18,5 +18,8 @@ extern const struct address_space_operations gfs2_file_aops;
 extern int gfs2_get_block(struct inode *inode, sector_t lblock,
 			  struct buffer_head *bh_result, int create);
 extern int gfs2_releasepage(struct page *page, gfp_t gfp_mask);
+extern u64 gfs2_ri_total(struct gfs2_sbd *sdp);
+extern void gfs2_statfs_change(struct gfs2_sbd *sdp, s64 total, s64 free,
+			       s64 dinodes);
 
 #endif /* __OPS_ADDRESS_DOT_H__ */
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 1727f50..e857f40 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) Sistina Software, Inc.  1997-2003 All rights reserved.
- * Copyright (C) 2004-2006 Red Hat, Inc.  All rights reserved.
+ * Copyright (C) 2004-2007 Red Hat, Inc.  All rights reserved.
  *
  * This copyrighted material is made available to anyone wishing to use,
  * modify, copy, or redistribute it subject to the terms and conditions
@@ -431,6 +431,38 @@ static int compute_bitstructs(struct gfs2_rgrpd *rgd)
 }
 
 /**
+ * gfs2_ri_total - Total up the file system space, according to the rindex.
+ *
+ */
+u64 gfs2_ri_total(struct gfs2_sbd *sdp)
+{
+	u64 total_data = 0;	
+	struct inode *inode = sdp->sd_rindex;
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_rindex_host ri;
+	char buf[sizeof(struct gfs2_rindex)];
+	struct file_ra_state ra_state;
+	int error, rgrps;
+
+	mutex_lock(&sdp->sd_rindex_mutex);
+	file_ra_state_init(&ra_state, inode->i_mapping);
+	for (rgrps = 0;; rgrps++) {
+		loff_t pos = rgrps * sizeof(struct gfs2_rindex);
+
+		if (pos + sizeof(struct gfs2_rindex) >= ip->i_di.di_size)
+			break;
+		error = gfs2_internal_read(ip, &ra_state, buf, &pos,
+					   sizeof(struct gfs2_rindex));
+		if (error != sizeof(struct gfs2_rindex))
+			break;
+		gfs2_rindex_in(&ri, buf);
+		total_data += ri.ri_data;
+	}
+	mutex_unlock(&sdp->sd_rindex_mutex);
+	return total_data;
+}
+
+/**
  * gfs2_ri_update - Pull in a new resource index from the disk
  * @gl: The glock covering the rindex inode
  *
@@ -447,7 +479,12 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 	u64 junk = ip->i_di.di_size;
 	int error;
 
-	if (do_div(junk, sizeof(struct gfs2_rindex))) {
+	/* If someone is holding the rindex file with a glock, they must
+	   be updating it, in which case we may have partial entries.
+	   In this case, we ignore the partials. */
+	if (!gfs2_glock_is_held_excl(ip->i_gl) &&
+	    !gfs2_glock_is_held_shrd(ip->i_gl) &&
+	    do_div(junk, sizeof(struct gfs2_rindex))) {
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
@@ -457,6 +494,9 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 	file_ra_state_init(&ra_state, inode->i_mapping);
 	for (sdp->sd_rgrps = 0;; sdp->sd_rgrps++) {
 		loff_t pos = sdp->sd_rgrps * sizeof(struct gfs2_rindex);
+
+		if (pos + sizeof(struct gfs2_rindex) >= ip->i_di.di_size)
+			break;
 		error = gfs2_internal_read(ip, &ra_state, buf, &pos,
 					    sizeof(struct gfs2_rindex));
 		if (!error)
@@ -978,18 +1018,25 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file, unsigned int line)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_alloc *al = &ip->i_alloc;
-	int error;
+	int error = 0;
 
 	if (gfs2_assert_warn(sdp, al->al_requested))
 		return -EINVAL;
 
-	error = gfs2_rindex_hold(sdp, &al->al_ri_gh);
+	/* We need to hold the rindex unless the inode we're using is
+	   the rindex itself, in which case it's already held. */
+	if (ip != GFS2_I(sdp->sd_rindex))
+		error = gfs2_rindex_hold(sdp, &al->al_ri_gh);
+	else if (!sdp->sd_rgrps) /* We may not have the rindex read in, so: */
+		error = gfs2_ri_update(ip);
+
 	if (error)
 		return error;
 
 	error = get_local_rgrp(ip);
 	if (error) {
-		gfs2_glock_dq_uninit(&al->al_ri_gh);
+		if (ip != GFS2_I(sdp->sd_rindex))
+			gfs2_glock_dq_uninit(&al->al_ri_gh);
 		return error;
 	}
 
@@ -1019,7 +1066,8 @@ void gfs2_inplace_release(struct gfs2_inode *ip)
 
 	al->al_rgd = NULL;
 	gfs2_glock_dq_uninit(&al->al_rgd_gh);
-	gfs2_glock_dq_uninit(&al->al_ri_gh);
+	if (ip != GFS2_I(sdp->sd_rindex))
+		gfs2_glock_dq_uninit(&al->al_ri_gh);
 }
 
 /**
-- 
1.5.1.2

