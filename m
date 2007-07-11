Return-Path: <linux-kernel-owner+w=401wt.eu-S935613AbXGKXoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935613AbXGKXoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935143AbXGKXep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:33302 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935137AbXGKXen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/61] sysfs: flatten cleanup paths in sysfs_add_link() and create_dir()
Date: Wed, 11 Jul 2007 16:31:45 -0700
Message-Id: <1184196860992-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184196856662-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Flatten cleanup paths in sysfs_add_link() and create_dir() to improve
readability and ease further changes to these functions.  This is in
preparation of object reference simplification.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |   73 ++++++++++++++++++++++++++++++---------------------
 fs/sysfs/symlink.c |   27 ++++++++++--------
 2 files changed, 58 insertions(+), 42 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f09626c..b4c4824 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -207,40 +207,53 @@ static int init_symlink(struct inode * inode)
 	return 0;
 }
 
-static int create_dir(struct kobject * k, struct dentry * p,
-		      const char * n, struct dentry ** d)
+static int create_dir(struct kobject *kobj, struct dentry *parent,
+		      const char *name, struct dentry **p_dentry)
 {
 	int error;
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
+	struct dentry *dentry;
+	struct sysfs_dirent *sd;
 
-	mutex_lock(&p->d_inode->i_mutex);
-	*d = lookup_one_len(n, p, strlen(n));
-	if (!IS_ERR(*d)) {
- 		if (sysfs_dirent_exist(p->d_fsdata, n))
-  			error = -EEXIST;
-  		else
-			error = sysfs_make_dirent(p->d_fsdata, *d, k, mode,
-								SYSFS_DIR);
-		if (!error) {
-			error = sysfs_create(*d, mode, init_dir);
-			if (!error) {
-				inc_nlink(p->d_inode);
-				(*d)->d_op = &sysfs_dentry_ops;
-				d_rehash(*d);
-			}
-		}
-		if (error && (error != -EEXIST)) {
-			struct sysfs_dirent *sd = (*d)->d_fsdata;
-			if (sd) {
- 				list_del_init(&sd->s_sibling);
-				sysfs_put(sd);
-			}
-			d_drop(*d);
-		}
-		dput(*d);
-	} else
-		error = PTR_ERR(*d);
-	mutex_unlock(&p->d_inode->i_mutex);
+	mutex_lock(&parent->d_inode->i_mutex);
+
+	dentry = lookup_one_len(name, parent, strlen(name));
+	if (IS_ERR(dentry)) {
+		error = PTR_ERR(dentry);
+		goto out_unlock;
+	}
+
+	error = -EEXIST;
+	if (sysfs_dirent_exist(parent->d_fsdata, name))
+		goto out_dput;
+
+	error = sysfs_make_dirent(parent->d_fsdata, dentry, kobj, mode,
+				  SYSFS_DIR);
+	if (error)
+		goto out_drop;
+
+	error = sysfs_create(dentry, mode, init_dir);
+	if (error)
+		goto out_sput;
+
+	inc_nlink(parent->d_inode);
+	dentry->d_op = &sysfs_dentry_ops;
+	d_rehash(dentry);
+
+	*p_dentry = dentry;
+	error = 0;
+	goto out_dput;
+
+ out_sput:
+	sd = dentry->d_fsdata;
+	list_del_init(&sd->s_sibling);
+	sysfs_put(sd);
+ out_drop:
+	d_drop(dentry);
+ out_dput:
+	dput(dentry);
+ out_unlock:
+	mutex_unlock(&parent->d_inode->i_mutex);
 	return error;
 }
 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 7b9c5bf..b463f17 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -49,30 +49,33 @@ static int sysfs_add_link(struct dentry * parent, const char * name, struct kobj
 {
 	struct sysfs_dirent * parent_sd = parent->d_fsdata;
 	struct sysfs_symlink * sl;
-	int error = 0;
+	int error;
 
 	error = -ENOMEM;
-	sl = kmalloc(sizeof(*sl), GFP_KERNEL);
+	sl = kzalloc(sizeof(*sl), GFP_KERNEL);
 	if (!sl)
-		goto exit1;
+		goto err_out;
 
 	sl->link_name = kmalloc(strlen(name) + 1, GFP_KERNEL);
 	if (!sl->link_name)
-		goto exit2;
+		goto err_out;
 
 	strcpy(sl->link_name, name);
 	sl->target_kobj = kobject_get(target);
 
 	error = sysfs_make_dirent(parent_sd, NULL, sl, S_IFLNK|S_IRWXUGO,
 				SYSFS_KOBJ_LINK);
-	if (!error)
-		return 0;
-
-	kobject_put(target);
-	kfree(sl->link_name);
-exit2:
-	kfree(sl);
-exit1:
+	if (error)
+		goto err_out;
+
+	return 0;
+
+ err_out:
+	if (sl) {
+		kobject_put(sl->target_kobj);
+		kfree(sl->link_name);
+		kfree(sl);
+	}
 	return error;
 }
 
-- 
1.5.2.2

