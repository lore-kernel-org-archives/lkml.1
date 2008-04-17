Return-Path: <linux-kernel-owner+w=401wt.eu-S935291AbYDQJwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935291AbYDQJwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756530AbYDQJ0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933742AbYDQJ0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:37 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Cyrill Gorcunov <gorcunov@gamil.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 40/48] [GFS2] possible null pointer dereference fixup
Date: Thu, 17 Apr 2008 09:39:16 +0100
Message-Id: <12084216511207-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216494161-git-send-email-swhiteho@redhat.com>
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
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
 <12084216182363-git-send-email-swhiteho@redhat.com>
 <12084216204027-git-send-email-swhiteho@redhat.com>
 <12084216222853-git-send-email-swhiteho@redhat.com>
 <12084216241802-git-send-email-swhiteho@redhat.com>
 <12084216262937-git-send-email-swhiteho@redhat.com>
 <12084216281152-git-send-email-swhiteho@redhat.com>
 <12084216301107-git-send-email-swhiteho@redhat.com>
 <12084216323165-git-send-email-swhiteho@redhat.com>
 <1208421634101-git-send-email-swhiteho@redhat.com>
 <12084216372363-git-send-email-swhiteho@redhat.com>
 <12084216391215-git-send-email-swhiteho@redhat.com>
 <12084216402644-git-send-email-swhiteho@redhat.com>
 <12084216431261-git-send-email-swhiteho@redhat.com>
 <1208421645785-git-send-email-swhiteho@redhat.com>
 <1208421647805-git-send-email-swhiteho@redhat.com>
 <12084216494161-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

gfs2_alloc_get may fail so we have to check it to prevent
NULL pointer dereference.

Signed-off-by: Cyrill Gorcunov <gorcunov@gamil.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index c1ee635..f7093aa 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -900,6 +900,8 @@ static int do_grow(struct gfs2_inode *ip, u64 size)
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -1081,7 +1083,8 @@ static int trunc_dealloc(struct gfs2_inode *ip, u64 size)
 		lblock = (size - 1) >> sdp->sd_sb.sb_bsize_shift;
 
 	find_metapath(sdp, lblock, &mp, ip->i_height);
-	gfs2_alloc_get(ip);
+	if (!gfs2_alloc_get(ip))
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index a3753c7..94070ad 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -1868,11 +1868,14 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 	if (!ht)
 		return -ENOMEM;
 
-	gfs2_alloc_get(dip);
+	if (!gfs2_alloc_get(dip)) {
+		error = -ENOMEM;
+		goto out;
+	}
 
 	error = gfs2_quota_hold(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
-		goto out;
+		goto out_put;
 
 	error = gfs2_rindex_hold(sdp, &dip->i_alloc->al_ri_gh);
 	if (error)
@@ -1946,8 +1949,9 @@ out_rlist:
 	gfs2_glock_dq_uninit(&dip->i_alloc->al_ri_gh);
 out_qs:
 	gfs2_quota_unhold(dip);
-out:
+out_put:
 	gfs2_alloc_put(dip);
+out:
 	kfree(ht);
 	return error;
 }
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index 76ead1a..288d5e6 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -318,6 +318,8 @@ static int ea_remove_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -681,6 +683,8 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -1464,6 +1468,8 @@ int gfs2_ea_dealloc(struct gfs2_inode *ip)
 	int error;
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 92ea9af..dcae2aa 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -351,6 +351,8 @@ int gfs2_dinode_dealloc(struct gfs2_inode *ip)
 	}
 
 	al = gfs2_alloc_get(ip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_hold(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
@@ -825,7 +827,8 @@ static int make_dinode(struct gfs2_inode *dip, struct gfs2_glock *gl,
 	int error;
 
 	munge_mode_uid_gid(dip, &mode, &uid, &gid);
-	gfs2_alloc_get(dip);
+	if (!gfs2_alloc_get(dip))
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(dip, uid, gid);
 	if (error)
@@ -860,6 +863,8 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 	int error;
 
 	al = gfs2_alloc_get(dip);
+	if (!al)
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 	if (error)
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index fbb4a6a..2483d87 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -649,6 +649,10 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 
 	if (alloc_required) {
 		al = gfs2_alloc_get(ip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_unlock;
+		}
 
 		error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 		if (error)
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 6cbbb5b..34fe571 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -200,6 +200,10 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 
 	if (alloc_required) {
 		struct gfs2_alloc *al = gfs2_alloc_get(dip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_gunlock;
+		}
 
 		error = gfs2_quota_lock(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 		if (error)
@@ -716,6 +720,10 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 
 	if (alloc_required) {
 		struct gfs2_alloc *al = gfs2_alloc_get(ndip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_gunlock;
+		}
 
 		error = gfs2_quota_lock(ndip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
 		if (error)
@@ -953,7 +961,8 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	if (!(attr->ia_valid & ATTR_GID) || ogid == ngid)
 		ogid = ngid = NO_QUOTA_CHANGE;
 
-	gfs2_alloc_get(ip);
+	if (!gfs2_alloc_get(ip))
+		return -ENOMEM;
 
 	error = gfs2_quota_lock(ip, nuid, ngid);
 	if (error)
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index a08dabd..636bccf 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -617,8 +617,9 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 	int err = -EIO;
 
 	if (gfs2_is_stuffed(ip)) {
-		struct gfs2_alloc *al = NULL;
-		al = gfs2_alloc_get(ip);
+		struct gfs2_alloc *al = gfs2_alloc_get(ip);
+		if (!al)
+			return -ENOMEM;
 		/* just request 1 blk */
 		al->al_requested = 1;
 		gfs2_inplace_reserve(ip);
@@ -729,6 +730,10 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 
 	if (nalloc) {
 		al = gfs2_alloc_get(ip);
+		if (!al) {
+			error = -ENOMEM;
+			goto out_gunlock;
+		}
 
 		al->al_requested = nalloc * (data_blocks + ind_blocks);
 
-- 
1.5.1.2

