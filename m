Return-Path: <linux-kernel-owner+w=401wt.eu-S935805AbZLPWAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935805AbZLPWAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935651AbZLPWAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:00:30 -0500
Received: from www.tglx.de ([62.245.132.106]:52771 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932602AbZLPWA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:00:27 -0500
Message-Id: <20091216212730.308081108@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 16 Dec 2009 21:31:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 1/1] devtmpfs: Convert dirlock to a mutex
Content-Disposition: inline; filename=devfs-fix-locking-madness.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devtmpfs has a rw_lock dirlock which serializes delete_path and
create_path.

This code was obviously never tested with the usual set of debugging
facilities enabled. In the dirlock held sections the code calls:

 - vfs functions which take mutexes
 - kmalloc(, GFP_KERNEL)

In both code pathes the might sleep warning triggers and spams dmesg.

Convert the rw_lock to a mutex. There is no reason why this needs to
be a rwlock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devtmpfs.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/base/devtmpfs.c
===================================================================
--- linux-2.6.orig/drivers/base/devtmpfs.c
+++ linux-2.6/drivers/base/devtmpfs.c
@@ -32,7 +32,7 @@ static int dev_mount = 1;
 static int dev_mount;
 #endif
 
-static rwlock_t dirlock;
+static DEFINE_MUTEX(dirlock);
 
 static int __init mount_param(char *str)
 {
@@ -93,7 +93,7 @@ static int create_path(const char *nodep
 {
 	int err;
 
-	read_lock(&dirlock);
+	mutex_lock(&dirlock);
 	err = dev_mkdir(nodepath, 0755);
 	if (err == -ENOENT) {
 		char *path;
@@ -117,7 +117,7 @@ static int create_path(const char *nodep
 		}
 		kfree(path);
 	}
-	read_unlock(&dirlock);
+	mutex_unlock(&dirlock);
 	return err;
 }
 
@@ -229,7 +229,7 @@ static int delete_path(const char *nodep
 	if (!path)
 		return -ENOMEM;
 
-	write_lock(&dirlock);
+	mutex_lock(&dirlock);
 	for (;;) {
 		char *base;
 
@@ -241,7 +241,7 @@ static int delete_path(const char *nodep
 		if (err)
 			break;
 	}
-	write_unlock(&dirlock);
+	mutex_unlock(&dirlock);
 
 	kfree(path);
 	return err;
@@ -352,8 +352,6 @@ int __init devtmpfs_init(void)
 	int err;
 	struct vfsmount *mnt;
 
-	rwlock_init(&dirlock);
-
 	err = register_filesystem(&dev_fs_type);
 	if (err) {
 		printk(KERN_ERR "devtmpfs: unable to register devtmpfs "


