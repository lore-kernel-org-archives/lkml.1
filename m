Return-Path: <linux-kernel-owner+w=401wt.eu-S965533AbXDGIZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533AbXDGIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965635AbXDGIZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:25:01 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:60687 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965537AbXDGIX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=umJhsA6U6U+TQewbXli3Vx5VUt7dK3Ej5gK2bHxGlldZz+uhfugYwrxsRPfBL0Uejj+edDluCCJxLVAUHlX9CDWotc+at9sX3R2J9WHv04/qiC79S39WvTPugKgYDzbth2q9ZGBGwCOQp2Wa9JbBbeWzjc1aQJCmA2HZu1Qp818=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 06/14] sysfs: add sysfs_dirent->s_parent
In-Reply-To: <1175934226928-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 7 Apr 2007 17:23:47 +0900
Message-Id: <11759342272927-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs_dirent->s_parent.  With this patch, each sd points to and
holds a reference to its parent.  This allows walking sysfs tree
without referencing sd->s_dentry which can go away anytime if the user
doesn't control when it's deleted.

sd->s_parent is initialized and parent is referenced in
sysfs_attach_dirent().  Reference to parent is released when the sd is
released, so as long as reference to a sd is held, s_parent can be
followed.

dentry walk in sysfs_readdir() is convereted to s_parent walk.

This will be used to reimplement symlink such that it uses only
sysfs_dirent tree.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   27 ++++++++++++++++++++-------
 fs/sysfs/mount.c |    1 +
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 653c23c..ef45c3e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -34,6 +34,11 @@ struct kobject *sysfs_get_kobject(struct dentry *dentry)
 
 void release_sysfs_dirent(struct sysfs_dirent * sd)
 {
+	struct sysfs_dirent *parent_sd;
+
+ repeat:
+	parent_sd = sd->s_parent;
+
 	if (sd->s_type & SYSFS_KOBJ_LINK) {
 		struct sysfs_symlink * sl = sd->s_element;
 		kfree(sl->link_name);
@@ -42,6 +47,10 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	}
 	kfree(sd->s_iattr);
 	kmem_cache_free(sysfs_dir_cachep, sd);
+
+	sd = parent_sd;
+	if (sd && atomic_dec_and_test(&sd->s_count))
+		goto repeat;
 }
 
 static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
@@ -89,8 +98,10 @@ void sysfs_attach_dirent(struct sysfs_dirent *sd,
 		dentry->d_op = &sysfs_dentry_ops;
 	}
 
-	if (parent_sd)
+	if (parent_sd) {
+		sd->s_parent = sysfs_get(parent_sd);
 		list_add(&sd->s_sibling, &parent_sd->s_children);
+	}
 }
 
 /*
@@ -526,7 +537,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			i++;
 			/* fallthrough */
 		case 1:
-			ino = (unsigned long)dentry->d_parent->d_fsdata;
+			ino = (unsigned long)parent_sd->s_parent;
 			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -643,13 +654,13 @@ int sysfs_make_shadowed_dir(struct kobject *kobj,
 
 struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 {
+	struct dentry *dir = kobj->dentry;
+	struct inode *inode = dir->d_inode;
+	struct dentry *parent = dir->d_parent;
+	struct sysfs_dirent *parent_sd = parent->d_fsdata;
+	struct dentry *shadow;
 	struct sysfs_dirent *sd;
-	struct dentry *parent, *dir, *shadow;
-	struct inode *inode;
 
-	dir = kobj->dentry;
-	inode = dir->d_inode;
-	parent = dir->d_parent;
 	shadow = ERR_PTR(-EINVAL);
 	if (!sysfs_is_shadowed_inode(inode))
 		goto out;
@@ -661,6 +672,8 @@ struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 	sd = sysfs_new_dirent(kobj, inode->i_mode, SYSFS_DIR);
 	if (!sd)
 		goto nomem;
+	/* point to parent_sd but don't attach to it */
+	sd->s_parent = sysfs_get(parent_sd);
 	sysfs_attach_dirent(sd, NULL, shadow);
 
 	d_instantiate(shadow, igrab(inode));
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 23a48a3..141f7b1 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -28,6 +28,7 @@ static const struct super_operations sysfs_ops = {
 };
 
 static struct sysfs_dirent sysfs_root = {
+	.s_count	= ATOMIC_INIT(1),
 	.s_sibling	= LIST_HEAD_INIT(sysfs_root.s_sibling),
 	.s_children	= LIST_HEAD_INIT(sysfs_root.s_children),
 	.s_element	= NULL,
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 104649c..b4876de 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -1,5 +1,6 @@
 struct sysfs_dirent {
 	atomic_t		s_count;
+	struct sysfs_dirent	* s_parent;
 	struct list_head	s_sibling;
 	struct list_head	s_children;
 	void 			* s_element;
-- 
1.5.0.3


