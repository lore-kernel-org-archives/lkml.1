Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbZLKWZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbZLKWZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762734AbZLKWZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:09 -0500
Received: from kroah.org ([198.145.64.141]:60997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762691AbZLKWYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:24:55 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/27] Driver core: devtmpfs: prevent concurrent subdirectory creation and removal
Date: Fri, 11 Dec 2009 14:24:26 -0800
Message-Id: <1260570289-6997-4-git-send-email-gregkh@suse.de>
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
 drivers/base/devtmpfs.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 48526b9..1cf498f 100644
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
@@ -86,16 +88,12 @@ static int dev_mkdir(const char *name, mode_t mode)
 
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
 
@@ -107,14 +105,17 @@ static int create_path(const char *nodepath)
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
@@ -125,9 +126,10 @@ static int create_path(const char *nodepath)
 			s[0] = '/';
 			s++;
 		}
+		kfree(path);
 	}
+	read_unlock(&dirlock);
 
-	kfree(path);
 	return err;
 }
 
@@ -234,7 +236,8 @@ static int delete_path(const char *nodepath)
 	if (!path)
 		return -ENOMEM;
 
-	while (1) {
+	write_lock(&dirlock);
+	for (;;) {
 		char *base;
 
 		base = strrchr(path, '/');
@@ -245,6 +248,7 @@ static int delete_path(const char *nodepath)
 		if (err)
 			break;
 	}
+	write_unlock(&dirlock);
 
 	kfree(path);
 	return err;
@@ -360,6 +364,8 @@ int __init devtmpfs_init(void)
 	int err;
 	struct vfsmount *mnt;
 
+	rwlock_init(&dirlock);
+
 	err = register_filesystem(&dev_fs_type);
 	if (err) {
 		printk(KERN_ERR "devtmpfs: unable to register devtmpfs "
-- 
1.6.5.5

