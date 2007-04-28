Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbXD1Nk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbXD1Nk6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXD1Nk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:45348 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030358AbXD1NkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=U+aXNt1OFeHldemwZRZE6xooPzsdo7AfO9vlwKiq0TMVm/ixyZFVaFS7ccBM5xVgiBSUYXWGp7gFmrwZhSugNe/FlnwlVYt/xj0AlhvGhcEaq6s+KiB0YRzKKPY/VeZCy143H1+zTDV696tnPjX64lfT5JIifPi24XmntQ3qpzc=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 20/21] sysfs: separate out sysfs_attach_dentry()
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:42 +0900
Message-Id: <11777675822227-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate sd <-> dentry association into sysfs_attach_dentry() and
call it after dentry and inode are properly set up.  This is in
preparation of sysfs_drop_dentry() updates.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |   48 +++++++++++++++++++++---------------------------
 fs/sysfs/inode.c |    4 ++--
 fs/sysfs/sysfs.h |    3 ++-
 3 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 265042a..1a45a1d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -130,14 +130,19 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	return NULL;
 }
 
+static void sysfs_attach_dentry(struct sysfs_dirent *sd, struct dentry *dentry)
+{
+	dentry->d_op = &sysfs_dentry_ops;
+	dentry->d_fsdata = sysfs_get(sd);
+	sd->s_dentry = dentry;
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
@@ -217,15 +222,13 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
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
@@ -296,36 +299,28 @@ static int sysfs_attach_attr(struct sysfs_dirent * sd, struct dentry * dentry)
                 init = init_file;
         }
 
-	dentry->d_fsdata = sysfs_get(sd);
-	sd->s_dentry = dentry;
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
-	sd->s_dentry = dentry;
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
@@ -755,7 +750,6 @@ struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 	d_instantiate(shadow, igrab(inode));
 	inc_nlink(inode);
 	inc_nlink(parent->d_inode);
-	shadow->d_op = &sysfs_dentry_ops;
 
 	dget(shadow);		/* Extra count - pin the dentry in core */
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index b72d18a..10aa33f 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -155,13 +155,13 @@ struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent * sd)
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
index 537c64b..06a237e 100644
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
1.5.0.3


