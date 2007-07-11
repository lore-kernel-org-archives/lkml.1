Return-Path: <linux-kernel-owner+w=401wt.eu-S935835AbXGKXqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935835AbXGKXqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932971AbXGKXe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:59 -0400
Received: from mail.suse.de ([195.135.220.2]:33876 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935174AbXGKXe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/61] sysfs: add sysfs_dirent->s_parent
Date: Wed, 11 Jul 2007 16:31:48 -0700
Message-Id: <11841968731843-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968683554-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   30 +++++++++++++++++++++++-------
 fs/sysfs/mount.c |    1 +
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f16aa7e..5d50e1d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -47,6 +47,11 @@ static void sysfs_free_ino(ino_t ino)
 
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
@@ -56,6 +61,10 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	kfree(sd->s_iattr);
 	sysfs_free_ino(sd->s_ino);
 	kmem_cache_free(sysfs_dir_cachep, sd);
+
+	sd = parent_sd;
+	if (sd && atomic_dec_and_test(&sd->s_count))
+		goto repeat;
 }
 
 static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
@@ -119,8 +128,10 @@ void sysfs_attach_dirent(struct sysfs_dirent *sd,
 		dentry->d_op = &sysfs_dentry_ops;
 	}
 
-	if (parent_sd)
+	if (parent_sd) {
+		sd->s_parent = sysfs_get(parent_sd);
 		list_add(&sd->s_sibling, &parent_sd->s_children);
+	}
 }
 
 /*
@@ -571,7 +582,10 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			i++;
 			/* fallthrough */
 		case 1:
-			ino = parent_ino(dentry);
+			if (parent_sd->s_parent)
+				ino = parent_sd->s_parent->s_ino;
+			else
+				ino = parent_sd->s_ino;
 			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
 				break;
 			filp->f_pos++;
@@ -688,13 +702,13 @@ int sysfs_make_shadowed_dir(struct kobject *kobj,
 
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
@@ -706,6 +720,8 @@ struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 	sd = sysfs_new_dirent(kobj, inode->i_mode, SYSFS_DIR);
 	if (!sd)
 		goto nomem;
+	/* point to parent_sd but don't attach to it */
+	sd->s_parent = sysfs_get(parent_sd);
 	sysfs_attach_dirent(sd, NULL, shadow);
 
 	d_instantiate(shadow, igrab(inode));
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 00ab912..31c1fc6 100644
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
index f8f49cc..ce05d6f 100644
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
1.5.2.2

