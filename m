Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbXIZDbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbXIZDbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758091AbXIZDaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:30:25 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35262 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881AbXIZDaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:30:22 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 22/25] Unionfs: add un/likely conditionals on common subr
Date: Tue, 25 Sep 2007 23:10:01 -0400
Message-Id: <11907762141716-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/sioq.c |    4 ++--
 fs/unionfs/subr.c |   26 +++++++++++++-------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/unionfs/sioq.c b/fs/unionfs/sioq.c
index 2a8c88e..35d9fc3 100644
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -28,7 +28,7 @@ int __init init_sioq(void)
 	int err;
 
 	superio_workqueue = create_workqueue("unionfs_siod");
-	if (!IS_ERR(superio_workqueue))
+	if (unlikely(!IS_ERR(superio_workqueue)))
 		return 0;
 
 	err = PTR_ERR(superio_workqueue);
@@ -39,7 +39,7 @@ int __init init_sioq(void)
 
 void stop_sioq(void)
 {
-	if (superio_workqueue)
+	if (likely(superio_workqueue))
 		destroy_workqueue(superio_workqueue);
 }
 
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index 6b93b64..6067d65 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -40,7 +40,7 @@ int create_whiteout(struct dentry *dentry, int start)
 
 	/* create dentry's whiteout equivalent */
 	name = alloc_whname(dentry->d_name.name, dentry->d_name.len);
-	if (IS_ERR(name)) {
+	if (unlikely(IS_ERR(name))) {
 		err = PTR_ERR(name);
 		goto out;
 	}
@@ -60,7 +60,7 @@ int create_whiteout(struct dentry *dentry, int start)
 						      dentry,
 						      dentry->d_name.name,
 						      bindex);
-			if (!lower_dentry || IS_ERR(lower_dentry)) {
+			if (unlikely(!lower_dentry || IS_ERR(lower_dentry))) {
 				printk(KERN_DEBUG "unionfs: create_parents "
 				       "failed for bindex = %d\n", bindex);
 				continue;
@@ -70,7 +70,7 @@ int create_whiteout(struct dentry *dentry, int start)
 		lower_wh_dentry =
 			lookup_one_len(name, lower_dentry->d_parent,
 				       dentry->d_name.len + UNIONFS_WHLEN);
-		if (IS_ERR(lower_wh_dentry))
+		if (unlikely(IS_ERR(lower_wh_dentry)))
 			continue;
 
 		/*
@@ -84,7 +84,7 @@ int create_whiteout(struct dentry *dentry, int start)
 		}
 
 		err = init_lower_nd(&nd, LOOKUP_CREATE);
-		if (err < 0)
+		if (unlikely(err < 0))
 			goto out;
 		lower_dir_dentry = lock_parent(lower_wh_dentry);
 		if (!(err = is_robranch_super(dentry->d_sb, bindex)))
@@ -96,12 +96,12 @@ int create_whiteout(struct dentry *dentry, int start)
 		dput(lower_wh_dentry);
 		release_lower_nd(&nd, err);
 
-		if (!err || !IS_COPYUP_ERR(err))
+		if (unlikely(!err || !IS_COPYUP_ERR(err)))
 			break;
 	}
 
 	/* set dbopaque so that lookup will not proceed after this branch */
-	if (!err)
+	if (likely(!err))
 		set_dbopaque(dentry, bindex);
 
 out:
@@ -129,7 +129,7 @@ int unionfs_refresh_lower_dentry(struct dentry *dentry, int bindex)
 
 	lower_dentry = lookup_one_len(dentry->d_name.name, lower_parent,
 				      dentry->d_name.len);
-	if (IS_ERR(lower_dentry)) {
+	if (unlikely(IS_ERR(lower_dentry))) {
 		err = PTR_ERR(lower_dentry);
 		goto out;
 	}
@@ -138,7 +138,7 @@ int unionfs_refresh_lower_dentry(struct dentry *dentry, int bindex)
 	iput(unionfs_lower_inode_idx(dentry->d_inode, bindex));
 	unionfs_set_lower_inode_idx(dentry->d_inode, bindex, NULL);
 
-	if (!lower_dentry->d_inode) {
+	if (unlikely(!lower_dentry->d_inode)) {
 		dput(lower_dentry);
 		unionfs_set_lower_dentry_idx(dentry, bindex, NULL);
 	} else {
@@ -166,17 +166,17 @@ int make_dir_opaque(struct dentry *dentry, int bindex)
 	mutex_lock(&lower_dir->i_mutex);
 	diropq = lookup_one_len(UNIONFS_DIR_OPAQUE, lower_dentry,
 				sizeof(UNIONFS_DIR_OPAQUE) - 1);
-	if (IS_ERR(diropq)) {
+	if (unlikely(IS_ERR(diropq))) {
 		err = PTR_ERR(diropq);
 		goto out;
 	}
 
 	err = init_lower_nd(&nd, LOOKUP_CREATE);
-	if (err < 0)
+	if (unlikely(err < 0))
 		goto out;
 	if (!diropq->d_inode)
 		err = vfs_create(lower_dir, diropq, S_IRUGO, &nd);
-	if (!err)
+	if (likely(!err))
 		set_dbopaque(dentry, bindex);
 	release_lower_nd(&nd, err);
 
@@ -193,7 +193,7 @@ out:
 int unionfs_get_nlinks(const struct inode *inode)
 {
 	/* don't bother to do all the work since we're unlinked */
-	if (inode->i_nlink == 0)
+	if (unlikely(inode->i_nlink == 0))
 		return 0;
 
 	if (!S_ISDIR(inode->i_mode))
@@ -213,7 +213,7 @@ char *alloc_whname(const char *name, int len)
 	char *buf;
 
 	buf = kmalloc(len + UNIONFS_WHLEN + 1, GFP_KERNEL);
-	if (!buf)
+	if (unlikely(!buf))
 		return ERR_PTR(-ENOMEM);
 
 	strcpy(buf, UNIONFS_WHPFX);
-- 
1.5.2.2

