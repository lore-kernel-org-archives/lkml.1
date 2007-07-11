Return-Path: <linux-kernel-owner+w=401wt.eu-S936080AbXGKXuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936080AbXGKXuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935191AbXGKXfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:35:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:33372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935187AbXGKXfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:35:33 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/61] sysfs: separate out sysfs_attach_dentry()
Date: Wed, 11 Jul 2007 16:31:56 -0700
Message-Id: <11841969101299-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196905515-git-send-email-gregkh@suse.de>
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
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
 <1184196905515-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Consolidate sd <-> dentry association into sysfs_attach_dentry() and
call it after dentry and inode are properly set up.  This is in
preparation of sysfs_drop_dentry() updates.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |   59 +++++++++++++++++++++++------------------------------
 fs/sysfs/inode.c |    4 +-
 fs/sysfs/sysfs.h |    3 +-
 3 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e0d377a..01eeb4b 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -142,14 +142,24 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	return NULL;
 }
 
+static void sysfs_attach_dentry(struct sysfs_dirent *sd, struct dentry *dentry)
+{
+	dentry->d_op = &sysfs_dentry_ops;
+	dentry->d_fsdata = sysfs_get(sd);
+
+	/* protect sd->s_dentry against sysfs_d_iput */
+	spin_lock(&sysfs_lock);
+	sd->s_dentry = dentry;
+	spin_unlock(&sysfs_lock);
+
+	d_rehash(dentry);
+}
+
 void sysfs_attach_dirent(struct sysfs_dirent *sd,
 			 struct sysfs_dirent *parent_sd, struct dentry *dentry)
 {
-	if (dentry) {
-		sd->s_dentry = dentry;
-		dentry->d_fsdata = sysfs_get(sd);
-		dentry->d_op = &sysfs_dentry_ops;
-	}
+	if (dentry)
+		sysfs_attach_dentry(sd, dentry);
 
 	if (parent_sd) {
 		sd->s_parent = sysfs_get(parent_sd);
@@ -229,15 +239,13 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 	if (!sd)
 		goto out_drop;
 	sd->s_elem.dir.kobj = kobj;
-	sysfs_attach_dirent(sd, parent->d_fsdata, dentry);
 
-	error = sysfs_create(dentry, mode, init_dir);
+	error = sysfs_create(sd, dentry, mode, init_dir);
 	if (error)
 		goto out_sput;
 
 	inc_nlink(parent->d_inode);
-	dentry->d_op = &sysfs_dentry_ops;
-	d_rehash(dentry);
+	sysfs_attach_dirent(sd, parent->d_fsdata, dentry);
 
 	*p_dentry = dentry;
 	error = 0;
@@ -308,42 +316,28 @@ static int sysfs_attach_attr(struct sysfs_dirent * sd, struct dentry * dentry)
                 init = init_file;
         }
 
-	dentry->d_fsdata = sysfs_get(sd);
-	/* protect sd->s_dentry against sysfs_d_iput */
-	spin_lock(&sysfs_lock);
-	sd->s_dentry = dentry;
-	spin_unlock(&sysfs_lock);
-	error = sysfs_create(dentry, (attr->mode & S_IALLUGO) | S_IFREG, init);
-	if (error) {
-		sysfs_put(sd);
+	error = sysfs_create(sd, dentry,
+			     (attr->mode & S_IALLUGO) | S_IFREG, init);
+	if (error)
 		return error;
-	}
 
         if (bin_attr) {
 		dentry->d_inode->i_size = bin_attr->size;
 		dentry->d_inode->i_fop = &bin_fops;
 	}
-	dentry->d_op = &sysfs_dentry_ops;
-	d_rehash(dentry);
+
+	sysfs_attach_dentry(sd, dentry);
 
 	return 0;
 }
 
 static int sysfs_attach_link(struct sysfs_dirent * sd, struct dentry * dentry)
 {
-	int err = 0;
+	int err;
 
-	dentry->d_fsdata = sysfs_get(sd);
-	/* protect sd->s_dentry against sysfs_d_iput */
-	spin_lock(&sysfs_lock);
-	sd->s_dentry = dentry;
-	spin_unlock(&sysfs_lock);
-	err = sysfs_create(dentry, S_IFLNK|S_IRWXUGO, init_symlink);
-	if (!err) {
-		dentry->d_op = &sysfs_dentry_ops;
-		d_rehash(dentry);
-	} else
-		sysfs_put(sd);
+	err = sysfs_create(sd, dentry, S_IFLNK|S_IRWXUGO, init_symlink);
+	if (!err)
+		sysfs_attach_dentry(sd, dentry);
 
 	return err;
 }
@@ -773,7 +767,6 @@ struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 	d_instantiate(shadow, igrab(inode));
 	inc_nlink(inode);
 	inc_nlink(parent->d_inode);
-	shadow->d_op = &sysfs_dentry_ops;
 
 	dget(shadow);		/* Extra count - pin the dentry in core */
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index d9ccc83..88857a3 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -156,13 +156,13 @@ struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent * sd)
 	return inode;
 }
 
-int sysfs_create(struct dentry * dentry, int mode, int (*init)(struct inode *))
+int sysfs_create(struct sysfs_dirent *sd, struct dentry *dentry, int mode,
+		 int (*init)(struct inode *))
 {
 	int error = 0;
 	struct inode * inode = NULL;
 	if (dentry) {
 		if (!dentry->d_inode) {
-			struct sysfs_dirent * sd = dentry->d_fsdata;
 			if ((inode = sysfs_new_inode(mode, sd))) {
 				if (dentry->d_parent && dentry->d_parent->d_inode) {
 					struct inode *p_inode = dentry->d_parent->d_inode;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 8b09e9d..9fa77d6 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -58,7 +58,8 @@ extern struct kmem_cache *sysfs_dir_cachep;
 
 extern void sysfs_delete_inode(struct inode *inode);
 extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
-extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
+extern int sysfs_create(struct sysfs_dirent *sd, struct dentry *dentry,
+			int mode, int (*init)(struct inode *));
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
-- 
1.5.2.2

