Return-Path: <linux-kernel-owner+w=401wt.eu-S1750747AbZJ1Svf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750747AbZJ1Svf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZJ1Svc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:51:32 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39415 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZJ1Sv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:51:28 -0400
Subject: Driver-Core: devtmpfs - do not remove non-kernel-created
 directories
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 19:51:26 +0100
Message-Id: <1256755886.2618.323.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver-Core: devtmpfs - do not remove non-kernel-created directories

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/devtmpfs.c |   39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -76,37 +76,26 @@ static int dev_mkdir(const char *name, m
 	dentry = lookup_create(&nd, 1);
 	if (!IS_ERR(dentry)) {
 		err = vfs_mkdir(nd.path.dentry->d_inode, dentry, mode);
+		if (!err)
+			/* mark as kernel-created inode */
+			dentry->d_inode->i_private = &dev_mnt;
 		dput(dentry);
 	} else {
 		err = PTR_ERR(dentry);
 	}
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	path_put(&nd.path);
 	return err;
 }
 
 static int create_path(const char *nodepath)
 {
-	struct nameidata nd;
-	int err = 0;
+	int err;
 
 	read_lock(&dirlock);
-	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
-			      nodepath, LOOKUP_PARENT, &nd);
-	if (err == 0) {
-		struct dentry *dentry;
-
-		/* create directory right away */
-		dentry = lookup_create(&nd, 1);
-		if (!IS_ERR(dentry)) {
-			err = vfs_mkdir(nd.path.dentry->d_inode,
-					dentry, 0755);
-			dput(dentry);
-		}
-		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-		path_put(&nd.path);
-	} else if (err == -ENOENT) {
+	err = dev_mkdir(nodepath, 0755);
+	if (err == -ENOENT) {
 		char *path;
 		char *s;
 
@@ -129,7 +118,6 @@ static int create_path(const char *nodep
 		kfree(path);
 	}
 	read_unlock(&dirlock);
-
 	return err;
 }
 
@@ -211,16 +199,21 @@ static int dev_rmdir(const char *name)
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_one_len(nd.last.name, nd.path.dentry, nd.last.len);
 	if (!IS_ERR(dentry)) {
-		if (dentry->d_inode)
-			err = vfs_rmdir(nd.path.dentry->d_inode, dentry);
-		else
+		if (dentry->d_inode) {
+			if (dentry->d_inode->i_private == &dev_mnt)
+				err = vfs_rmdir(nd.path.dentry->d_inode,
+						dentry);
+			else
+				err = -EPERM;
+		} else {
 			err = -ENOENT;
+		}
 		dput(dentry);
 	} else {
 		err = PTR_ERR(dentry);
 	}
-	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 
+	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 	path_put(&nd.path);
 	return err;
 }

