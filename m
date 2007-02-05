Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbXBEOKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbXBEOKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbXBEOKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:10:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697AbXBEOKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:10:17 -0500
Subject: [GFS2] Fix change nlink deadlock [11/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "S. Wendy Cheng" <wcheng@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:18:20 +0000
Message-Id: <1170685100.11001.292.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From ca2e3f566e7db956c046f8737192c022302a84b4 Mon Sep 17 00:00:00 2001
From: S. Wendy Cheng <wcheng@redhat.com>
Date: Thu, 18 Jan 2007 15:56:34 -0500
Subject: [PATCH] [GFS2] Fix change nlink deadlock

Bugzilla 215088

Fix deadlock in gfs2_change_nlink() while installing RHEL5 into GFS2
partition. The gfs2_rename() apparently needs block allocation for the
new name (into the directory) where it requires rg locks. At the same
time, while updating the nlink count for the replaced file,
gfs2_change_nlink() tries to return the inode meta-data back to resource
group where it needs rg locks too. Our logic doesn't allow process to
acquire these locks recursively by the same process  (RHEL installer)
that results a BUG call. This only happens within rename code path and
only if the destination file exists before the rename operation.

Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index d122074..6bc4436 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -281,16 +281,14 @@ out:
 }
 
 /**
- * gfs2_change_nlink - Change nlink count on inode
+ * gfs2_change_nlink_i - Change nlink count on inode
  * @ip: The GFS2 inode
  * @diff: The change in the nlink count required
  *
  * Returns: errno
  */
-
-int gfs2_change_nlink(struct gfs2_inode *ip, int diff)
+int gfs2_change_nlink_i(struct gfs2_inode *ip, int diff)
 {
-	struct gfs2_sbd *sdp = ip->i_inode.i_sb->s_fs_info;
 	struct buffer_head *dibh;
 	u32 nlink;
 	int error;
@@ -322,6 +320,20 @@ int gfs2_change_nlink(struct gfs2_inode *ip, int diff)
 	brelse(dibh);
 	mark_inode_dirty(&ip->i_inode);
 
+	return error;
+}
+
+int gfs2_change_nlink(struct gfs2_inode *ip, int diff)
+{
+	struct gfs2_sbd *sdp = ip->i_inode.i_sb->s_fs_info;
+	int error;
+
+	/* update the nlink */
+	error = gfs2_change_nlink_i(ip, diff);
+	if (error)
+		return error;
+
+	/* return meta data block back to rg */
 	if (ip->i_inode.i_nlink == 0) {
 		struct gfs2_rgrpd *rgd;
 		struct gfs2_holder ri_gh, rg_gh;
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index b57f448..85c67cb 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -40,6 +40,7 @@ int gfs2_inode_refresh(struct gfs2_inode *ip);
 
 int gfs2_dinode_dealloc(struct gfs2_inode *inode);
 int gfs2_change_nlink(struct gfs2_inode *ip, int diff);
+int gfs2_change_nlink_i(struct gfs2_inode *ip, int diff);
 struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 			   int is_root, struct nameidata *nd);
 struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 636dda4..919e894 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -553,6 +553,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	int alloc_required;
 	unsigned int x;
 	int error;
+	struct gfs2_rgrpd *rgd;
 
 	if (ndentry->d_inode) {
 		nip = GFS2_I(ndentry->d_inode);
@@ -684,12 +685,12 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
 					 al->al_rgd->rd_ri.ri_length +
 					 4 * RES_DINODE + 4 * RES_LEAF +
-					 RES_STATFS + RES_QUOTA, 0);
+					 RES_STATFS + RES_QUOTA + 1, 0);
 		if (error)
 			goto out_ipreserv;
 	} else {
 		error = gfs2_trans_begin(sdp, 4 * RES_DINODE +
-					 5 * RES_LEAF, 0);
+					 5 * RES_LEAF + 1, 0);
 		if (error)
 			goto out_gunlock;
 	}
@@ -703,7 +704,25 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			error = gfs2_dir_del(ndip, &ndentry->d_name);
 			if (error)
 				goto out_end_trans;
-			error = gfs2_change_nlink(nip, -1);
+			error = gfs2_change_nlink_i(nip, -1);
+			if ((!error) && (nip->i_inode.i_nlink == 0)) {
+				error = -EIO;
+				rgd = gfs2_blk2rgrpd(sdp, nip->i_num.no_addr);
+				if (rgd) {
+					struct gfs2_holder nlink_rg_gh;
+					if (rgd != nip->i_alloc.al_rgd)
+						error = gfs2_glock_nq_init(
+						rgd->rd_gl, LM_ST_EXCLUSIVE,
+						0, &nlink_rg_gh);
+					else
+						error = 0;
+                			if (!error) {
+						gfs2_unlink_di(&nip->i_inode);
+						if (rgd != nip->i_alloc.al_rgd)
+							gfs2_glock_dq_uninit(&nlink_rg_gh);
+					}
+				}
+			}
 		}
 		if (error)
 			goto out_end_trans;
-- 
1.4.4.2



