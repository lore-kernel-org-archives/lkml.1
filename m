Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbXGIQYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbXGIQYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXGIQXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755895AbXGIQXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:13 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Robert Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Kernel changes to support new gfs2_grow command (part 2)
Date: Mon,  9 Jul 2007 17:02:10 +0100
Message-Id: <11839969982134-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1183996996300-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Peterson <rpeterso@redhat.com>

To avoid code redundancy, I separated out the operational "guts" into
a new function called read_rindex_entry.  Then I made two functions:
the closer-to-original gfs2_ri_update (without the special condition
checks) and gfs2_ri_update_special that's designed with that condition
in mind.  (I don't like the name, but if you have a suggestion, I'm
all ears).

Oh, and there's an added benefit:  we don't need all the ugly gotos
anymore.  ;)

This patch has been tested with gfs2_fsck_hellfire (which runs for
three and a half hours, btw).

Signed-off-By: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index 846c0ff..e0b4e8c 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -469,7 +469,8 @@ static void adjust_fs_space(struct inode *inode)
 	else
 		new_free = 0;
 	spin_unlock(&sdp->sd_statfs_spin);
-	fs_warn(sdp, "File system extended by %llu blocks.\n", new_free);
+	fs_warn(sdp, "File system extended by %llu blocks.\n",
+		(unsigned long long)new_free);
 	gfs2_statfs_change(sdp, new_free, new_free, 0);
 }
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index e857f40..48a6461 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -463,9 +463,62 @@ u64 gfs2_ri_total(struct gfs2_sbd *sdp)
 }
 
 /**
- * gfs2_ri_update - Pull in a new resource index from the disk
+ * read_rindex_entry - Pull in a new resource index entry from the disk
  * @gl: The glock covering the rindex inode
  *
+ * Returns: 0 on success, error code otherwise
+ */
+
+static int read_rindex_entry(struct gfs2_inode *ip,
+			     struct file_ra_state *ra_state)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	loff_t pos = sdp->sd_rgrps * sizeof(struct gfs2_rindex);
+	char buf[sizeof(struct gfs2_rindex)];
+	int error;
+	struct gfs2_rgrpd *rgd;
+
+	error = gfs2_internal_read(ip, ra_state, buf, &pos,
+				   sizeof(struct gfs2_rindex));
+	if (!error)
+		return 0;
+	if (error != sizeof(struct gfs2_rindex)) {
+		if (error > 0)
+			error = -EIO;
+		return error;
+	}
+
+	rgd = kzalloc(sizeof(struct gfs2_rgrpd), GFP_NOFS);
+	error = -ENOMEM;
+	if (!rgd)
+		return error;
+
+	mutex_init(&rgd->rd_mutex);
+	lops_init_le(&rgd->rd_le, &gfs2_rg_lops);
+	rgd->rd_sbd = sdp;
+
+	list_add_tail(&rgd->rd_list, &sdp->sd_rindex_list);
+	list_add_tail(&rgd->rd_list_mru, &sdp->sd_rindex_mru_list);
+
+	gfs2_rindex_in(&rgd->rd_ri, buf);
+	error = compute_bitstructs(rgd);
+	if (error)
+		return error;
+
+	error = gfs2_glock_get(sdp, rgd->rd_ri.ri_addr,
+			       &gfs2_rgrp_glops, CREATE, &rgd->rd_gl);
+	if (error)
+		return error;
+
+	rgd->rd_gl->gl_object = rgd;
+	rgd->rd_rg_vn = rgd->rd_gl->gl_vn - 1;
+	return error;
+}
+
+/**
+ * gfs2_ri_update - Pull in a new resource index from the disk
+ * @ip: pointer to the rindex inode
+ *
  * Returns: 0 on successful update, error code otherwise
  */
 
@@ -473,18 +526,11 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct inode *inode = &ip->i_inode;
-	struct gfs2_rgrpd *rgd;
-	char buf[sizeof(struct gfs2_rindex)];
 	struct file_ra_state ra_state;
 	u64 junk = ip->i_di.di_size;
 	int error;
 
-	/* If someone is holding the rindex file with a glock, they must
-	   be updating it, in which case we may have partial entries.
-	   In this case, we ignore the partials. */
-	if (!gfs2_glock_is_held_excl(ip->i_gl) &&
-	    !gfs2_glock_is_held_shrd(ip->i_gl) &&
-	    do_div(junk, sizeof(struct gfs2_rindex))) {
+	if (do_div(junk, sizeof(struct gfs2_rindex))) {
 		gfs2_consist_inode(ip);
 		return -EIO;
 	}
@@ -493,52 +539,49 @@ static int gfs2_ri_update(struct gfs2_inode *ip)
 
 	file_ra_state_init(&ra_state, inode->i_mapping);
 	for (sdp->sd_rgrps = 0;; sdp->sd_rgrps++) {
-		loff_t pos = sdp->sd_rgrps * sizeof(struct gfs2_rindex);
-
-		if (pos + sizeof(struct gfs2_rindex) >= ip->i_di.di_size)
-			break;
-		error = gfs2_internal_read(ip, &ra_state, buf, &pos,
-					    sizeof(struct gfs2_rindex));
-		if (!error)
-			break;
-		if (error != sizeof(struct gfs2_rindex)) {
-			if (error > 0)
-				error = -EIO;
-			goto fail;
+		error = read_rindex_entry(ip, &ra_state);
+		if (error) {
+			clear_rgrpdi(sdp);
+			return error;
 		}
+	}
 
-		rgd = kzalloc(sizeof(struct gfs2_rgrpd), GFP_NOFS);
-		error = -ENOMEM;
-		if (!rgd)
-			goto fail;
-
-		mutex_init(&rgd->rd_mutex);
-		lops_init_le(&rgd->rd_le, &gfs2_rg_lops);
-		rgd->rd_sbd = sdp;
-
-		list_add_tail(&rgd->rd_list, &sdp->sd_rindex_list);
-		list_add_tail(&rgd->rd_list_mru, &sdp->sd_rindex_mru_list);
-
-		gfs2_rindex_in(&rgd->rd_ri, buf);
-		error = compute_bitstructs(rgd);
-		if (error)
-			goto fail;
+	sdp->sd_rindex_vn = ip->i_gl->gl_vn;
+	return 0;
+}
 
-		error = gfs2_glock_get(sdp, rgd->rd_ri.ri_addr,
-				       &gfs2_rgrp_glops, CREATE, &rgd->rd_gl);
-		if (error)
-			goto fail;
+/**
+ * gfs2_ri_update_special - Pull in a new resource index from the disk
+ *
+ * This is a special version that's safe to call from gfs2_inplace_reserve_i.
+ * In this case we know that we don't have any resource groups in memory yet.
+ *
+ * @ip: pointer to the rindex inode
+ *
+ * Returns: 0 on successful update, error code otherwise
+ */
+static int gfs2_ri_update_special(struct gfs2_inode *ip)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct inode *inode = &ip->i_inode;
+	struct file_ra_state ra_state;
+	int error;
 
-		rgd->rd_gl->gl_object = rgd;
-		rgd->rd_rg_vn = rgd->rd_gl->gl_vn - 1;
+	file_ra_state_init(&ra_state, inode->i_mapping);
+	for (sdp->sd_rgrps = 0;; sdp->sd_rgrps++) {
+		/* Ignore partials */
+		if ((sdp->sd_rgrps + 1) * sizeof(struct gfs2_rindex) >
+		    ip->i_di.di_size)
+			break;
+		error = read_rindex_entry(ip, &ra_state);
+		if (error) {
+			clear_rgrpdi(sdp);
+			return error;
+		}
 	}
 
 	sdp->sd_rindex_vn = ip->i_gl->gl_vn;
 	return 0;
-
-fail:
-	clear_rgrpdi(sdp);
-	return error;
 }
 
 /**
@@ -1028,7 +1071,7 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file, unsigned int line)
 	if (ip != GFS2_I(sdp->sd_rindex))
 		error = gfs2_rindex_hold(sdp, &al->al_ri_gh);
 	else if (!sdp->sd_rgrps) /* We may not have the rindex read in, so: */
-		error = gfs2_ri_update(ip);
+		error = gfs2_ri_update_special(ip);
 
 	if (error)
 		return error;
-- 
1.5.1.2

