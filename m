Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZJ2T30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZJ2T30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbZJ2T3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:29:24 -0400
Received: from kroah.org ([198.145.64.141]:34082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684AbZJ2T3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:29:09 -0400
Subject: patch driver-core-devtmpfs-prevent-concurrent-subdirectory-creation-and-removal.patch added to gregkh-2.6 tree
To: kay.sievers@vrfy.org, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 29 Oct 2009 12:29:06 -0700
In-Reply-To: <1256755866.2618.321.camel@yio.site>
Message-ID: <1256844546706@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Driver core: devtmpfs: prevent concurrent subdirectory creation and removal

to my gregkh-2.6 tree.  Its filename is

    driver-core-devtmpfs-prevent-concurrent-subdirectory-creation-and-removal.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From kay.sievers@vrfy.org  Thu Oct 29 11:59:28 2009
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 28 Oct 2009 19:51:06 +0100
Subject: Driver core: devtmpfs: prevent concurrent subdirectory creation and removal
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1256755866.2618.321.camel@yio.site>


From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/devtmpfs.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -32,6 +32,8 @@ static int dev_mount = 1;
 static int dev_mount;
 #endif
 
+static rwlock_t dirlock;
+
 static int __init mount_param(char *str)
 {
 	dev_mount = simple_strtoul(str, NULL, 0);
@@ -86,16 +88,12 @@ static int dev_mkdir(const char *name, m
 
 static int create_path(const char *nodepath)
 {
-	char *path;
 	struct nameidata nd;
 	int err = 0;
 
-	path = kstrdup(nodepath, GFP_KERNEL);
-	if (!path)
-		return -ENOMEM;
-
+	read_lock(&dirlock);
 	err = vfs_path_lookup(dev_mnt->mnt_root, dev_mnt,
-			      path, LOOKUP_PARENT, &nd);
+			      nodepath, LOOKUP_PARENT, &nd);
 	if (err == 0) {
 		struct dentry *dentry;
 
@@ -107,14 +105,17 @@ static int create_path(const char *nodep
 			dput(dentry);
 		}
 		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
-
 		path_put(&nd.path);
 	} else if (err == -ENOENT) {
+		char *path;
 		char *s;
 
 		/* parent directories do not exist, create them */
+		path = kstrdup(nodepath, GFP_KERNEL);
+		if (!path)
+			return -ENOMEM;
 		s = path;
-		while (1) {
+		for (;;) {
 			s = strchr(s, '/');
 			if (!s)
 				break;
@@ -125,9 +126,10 @@ static int create_path(const char *nodep
 			s[0] = '/';
 			s++;
 		}
+		kfree(path);
 	}
+	read_unlock(&dirlock);
 
-	kfree(path);
 	return err;
 }
 
@@ -232,7 +234,8 @@ static int delete_path(const char *nodep
 	if (!path)
 		return -ENOMEM;
 
-	while (1) {
+	write_lock(&dirlock);
+	for (;;) {
 		char *base;
 
 		base = strrchr(path, '/');
@@ -243,6 +246,7 @@ static int delete_path(const char *nodep
 		if (err)
 			break;
 	}
+	write_unlock(&dirlock);
 
 	kfree(path);
 	return err;
@@ -358,6 +362,8 @@ int __init devtmpfs_init(void)
 	int err;
 	struct vfsmount *mnt;
 
+	rwlock_init(&dirlock);
+
 	err = register_filesystem(&dev_fs_type);
 	if (err) {
 		printk(KERN_ERR "devtmpfs: unable to register devtmpfs "

