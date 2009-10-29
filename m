Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbZJ2T3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbZJ2T3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZJ2T3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:29:06 -0400
Received: from kroah.org ([198.145.64.141]:34057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545AbZJ2T3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:29:04 -0400
Subject: patch driver-core-devtmpfs-do-not-remove-non-kernel-created-directories.patch added to gregkh-2.6 tree
To: kay.sievers@vrfy.org, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 29 Oct 2009 12:29:05 -0700
In-Reply-To: <1256755886.2618.323.camel@yio.site>
Message-ID: <12568445452811@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Driver Core: devtmpfs: do not remove non-kernel-created directories

to my gregkh-2.6 tree.  Its filename is

    driver-core-devtmpfs-do-not-remove-non-kernel-created-directories.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kay.sievers@vrfy.org  Thu Oct 29 12:00:12 2009
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 28 Oct 2009 19:51:26 +0100
Subject: Driver Core: devtmpfs: do not remove non-kernel-created directories
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1256755886.2618.323.camel@yio.site>


From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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

