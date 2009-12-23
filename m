Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZLWTxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZLWTxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZLWTxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:53:14 -0500
Received: from kroah.org ([198.145.64.141]:52932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534AbZLWTxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:53:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Kay Sievers <kay.sievers@vrfy.org>,
       stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/10] devtmpfs: Convert dirlock to a mutex
Date: Wed, 23 Dec 2009 11:52:34 -0800
Message-Id: <1261597963-18323-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.6
In-Reply-To: <20091223194955.GB18101@kroah.com>
References: <20091223194955.GB18101@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

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
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devtmpfs.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 50375bb..278371c 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -32,7 +32,7 @@ static int dev_mount = 1;
 static int dev_mount;
 #endif
 
-static rwlock_t dirlock;
+static DEFINE_MUTEX(dirlock);
 
 static int __init mount_param(char *str)
 {
@@ -93,7 +93,7 @@ static int create_path(const char *nodepath)
 {
 	int err;
 
-	read_lock(&dirlock);
+	mutex_lock(&dirlock);
 	err = dev_mkdir(nodepath, 0755);
 	if (err == -ENOENT) {
 		char *path;
@@ -117,7 +117,7 @@ static int create_path(const char *nodepath)
 		}
 		kfree(path);
 	}
-	read_unlock(&dirlock);
+	mutex_unlock(&dirlock);
 	return err;
 }
 
@@ -229,7 +229,7 @@ static int delete_path(const char *nodepath)
 	if (!path)
 		return -ENOMEM;
 
-	write_lock(&dirlock);
+	mutex_lock(&dirlock);
 	for (;;) {
 		char *base;
 
@@ -241,7 +241,7 @@ static int delete_path(const char *nodepath)
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
-- 
1.6.5.7

