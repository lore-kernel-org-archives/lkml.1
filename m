Return-Path: <linux-kernel-owner+w=401wt.eu-S1762691AbZLKWZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762691AbZLKWZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762711AbZLKWZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:07 -0500
Received: from kroah.org ([198.145.64.141]:60997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762708AbZLKWY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:24:56 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/27] Driver Core: devtmpfs: do not remove non-kernel-created directories
Date: Fri, 11 Dec 2009 14:24:28 -0800
Message-Id: <1260570289-6997-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devtmpfs.c |   39 ++++++++++++++++-----------------------
 1 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 880a203..c7f5c08 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -76,37 +76,26 @@ static int dev_mkdir(const char *name, mode_t mode)
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
 
@@ -129,7 +118,6 @@ static int create_path(const char *nodepath)
 		kfree(path);
 	}
 	read_unlock(&dirlock);
-
 	return err;
 }
 
@@ -213,16 +201,21 @@ static int dev_rmdir(const char *name)
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
-- 
1.6.5.5

