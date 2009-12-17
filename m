Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbZLQOzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbZLQOzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 09:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbZLQOzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 09:55:49 -0500
Received: from kroah.org ([198.145.64.141]:34588 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbZLQOzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 09:55:45 -0500
Subject: patch devtmpfs-convert-dirlock-to-a-mutex.patch added to gregkh-2.6 tree
To: tglx@linutronix.de, gregkh@suse.de, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
From: <gregkh@suse.de>
Date: Thu, 17 Dec 2009 06:55:25 -0800
In-Reply-To: <20091216212730.308081108@linutronix.de>
Message-ID: <12610617252519@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: devtmpfs: Convert dirlock to a mutex

to my gregkh-2.6 tree.  Its filename is

    devtmpfs-convert-dirlock-to-a-mutex.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From tglx@linutronix.de  Thu Dec 17 06:44:07 2009
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 16 Dec 2009 21:31:33 -0000
Subject: devtmpfs: Convert dirlock to a mutex
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <20091216212730.308081108@linutronix.de>


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
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
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

