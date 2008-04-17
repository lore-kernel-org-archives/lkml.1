Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYDQJy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYDQJy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933763AbYDQJ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574AbYDQJ0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:42 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 43/48] [GFS2] Streamline quota lock/check for no-quota case
Date: Thu, 17 Apr 2008 09:39:19 +0100
Message-Id: <1208421657826-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12084216553542-git-send-email-swhiteho@redhat.com>
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
 <12084216511207-git-send-email-swhiteho@redhat.com>
 <12084216533319-git-send-email-swhiteho@redhat.com>
 <12084216553542-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

This patch streamlines the quota checking in the "no quota" case by
making the check inline in the calling function, thus reducing the
number of function calls. Eventually we might be able to remove the
checks from the gfs2_quota_lock() and gfs2_quota_check() functions, but
currently we can't as there are a very few places in the code which need
to call these functions directly still.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index f7093aa..c19184f 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -903,14 +903,10 @@ static int do_grow(struct gfs2_inode *ip, u64 size)
 	if (!al)
 		return -ENOMEM;
 
-	error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	error = gfs2_quota_lock_check(ip);
 	if (error)
 		goto out;
 
-	error = gfs2_quota_check(ip, ip->i_inode.i_uid, ip->i_inode.i_gid);
-	if (error)
-		goto out_gunlock_q;
-
 	al->al_requested = sdp->sd_max_height + RES_DATA;
 
 	error = gfs2_inplace_reserve(ip);
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index 288d5e6..8175592 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -686,14 +686,10 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	if (!al)
 		return -ENOMEM;
 
-	error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	error = gfs2_quota_lock_check(ip);
 	if (error)
 		goto out;
 
-	error = gfs2_quota_check(ip, ip->i_inode.i_uid, ip->i_inode.i_gid);
-	if (error)
-		goto out_gunlock_q;
-
 	al->al_requested = blks;
 
 	error = gfs2_inplace_reserve(ip);
diff --git a/fs/gfs2/ops_address.c b/fs/gfs2/ops_address.c
index e72fd47..90a04a6 100644
--- a/fs/gfs2/ops_address.c
+++ b/fs/gfs2/ops_address.c
@@ -653,14 +653,10 @@ static int gfs2_write_begin(struct file *file, struct address_space *mapping,
 			goto out_unlock;
 		}
 
-		error = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+		error = gfs2_quota_lock_check(ip);
 		if (error)
 			goto out_alloc_put;
 
-		error = gfs2_quota_check(ip, ip->i_inode.i_uid, ip->i_inode.i_gid);
-		if (error)
-			goto out_qunlock;
-
 		al->al_requested = data_blocks + ind_blocks;
 		error = gfs2_inplace_reserve(ip);
 		if (error)
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 2b25a5f..e1b7d52 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -369,12 +369,9 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	if (al == NULL)
 		goto out_unlock;
 
-	ret = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	ret = gfs2_quota_lock_check(ip);
 	if (ret)
 		goto out_alloc_put;
-	ret = gfs2_quota_check(ip, ip->i_inode.i_uid, ip->i_inode.i_gid);
-	if (ret)
-		goto out_quota_unlock;
 	al->al_requested = data_blocks + ind_blocks;
 	ret = gfs2_inplace_reserve(ip);
 	if (ret)
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 34fe571..2686ad4 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -205,14 +205,10 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 			goto out_gunlock;
 		}
 
-		error = gfs2_quota_lock(dip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+		error = gfs2_quota_lock_check(dip);
 		if (error)
 			goto out_alloc;
 
-		error = gfs2_quota_check(dip, dip->i_inode.i_uid, dip->i_inode.i_gid);
-		if (error)
-			goto out_gunlock_q;
-
 		al->al_requested = sdp->sd_max_dirres;
 
 		error = gfs2_inplace_reserve(dip);
@@ -725,14 +721,10 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			goto out_gunlock;
 		}
 
-		error = gfs2_quota_lock(ndip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+		error = gfs2_quota_lock_check(ndip);
 		if (error)
 			goto out_alloc;
 
-		error = gfs2_quota_check(ndip, ndip->i_inode.i_uid, ndip->i_inode.i_gid);
-		if (error)
-			goto out_gunlock_q;
-
 		al->al_requested = sdp->sd_max_dirres;
 
 		error = gfs2_inplace_reserve(ndip);
diff --git a/fs/gfs2/quota.h b/fs/gfs2/quota.h
index a8be141..3b7f4b0 100644
--- a/fs/gfs2/quota.h
+++ b/fs/gfs2/quota.h
@@ -32,4 +32,21 @@ int gfs2_quota_init(struct gfs2_sbd *sdp);
 void gfs2_quota_scan(struct gfs2_sbd *sdp);
 void gfs2_quota_cleanup(struct gfs2_sbd *sdp);
 
+static inline int gfs2_quota_lock_check(struct gfs2_inode *ip)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	int ret;
+	if (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF)
+		return 0;
+	ret = gfs2_quota_lock(ip, NO_QUOTA_CHANGE, NO_QUOTA_CHANGE);
+	if (ret)
+		return ret;
+	if (sdp->sd_args.ar_quota != GFS2_QUOTA_ON)
+		return 0;
+	ret = gfs2_quota_check(ip, ip->i_inode.i_uid, ip->i_inode.i_gid);
+	if (ret)
+		gfs2_quota_unlock(ip);
+	return ret;
+}
+
 #endif /* __QUOTA_DOT_H__ */
-- 
1.5.1.2

