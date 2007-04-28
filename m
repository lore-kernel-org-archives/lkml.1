Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbXD1Npe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbXD1Npe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbXD1Nkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:45348 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbXD1Njw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=DrcfEmniay5nF1P6NxnFGckjIDh4eSoKdW689TUJj3iW0y8RBl0jPTDYH/uPC0/6m0QdeI6Cdk/ZffqfuYOspFJzebiejk2bq0CD5ymMibgW6Dsq6pjxUtNj6uC0/KKL2OHVhCw1Z+kNfpH8FGsx6w0ks6encodBrHIM35wI68c=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 08/21] sysfs: flatten cleanup paths in sysfs_add_link() and create_dir()
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:41 +0900
Message-Id: <11777675813363-git-send-email-htejun@gmail.com>
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

Flatten cleanup paths in sysfs_add_link() and create_dir() to improve
readability and ease further changes to these functions.  This is in
preparation of object reference simplification.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |   73 ++++++++++++++++++++++++++++++---------------------
 fs/sysfs/symlink.c |   27 ++++++++++--------
 2 files changed, 58 insertions(+), 42 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ada8405..0dca2c4 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -195,40 +195,53 @@ static int init_symlink(struct inode * inode)
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
1.5.0.3


