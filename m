Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbZLKWZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbZLKWZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762711AbZLKWZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:01 -0500
Received: from kroah.org ([198.145.64.141]:32769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762701AbZLKWY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:24:56 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/27] Driver Core: devtmpfs: use sys_mount()
Date: Fri, 11 Dec 2009 14:24:27 -0800
Message-Id: <1260570289-6997-5-git-send-email-gregkh@suse.de>
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
 drivers/base/devtmpfs.c |    9 ++-------
 include/linux/device.h  |    2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 1cf498f..880a203 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -332,9 +332,8 @@ out:
  * If configured, or requested by the commandline, devtmpfs will be
  * auto-mounted after the kernel mounted the root filesystem.
  */
-int devtmpfs_mount(const char *mountpoint)
+int devtmpfs_mount(const char *mntdir)
 {
-	struct path path;
 	int err;
 
 	if (!dev_mount)
@@ -343,15 +342,11 @@ int devtmpfs_mount(const char *mountpoint)
 	if (!dev_mnt)
 		return 0;
 
-	err = kern_path(mountpoint, LOOKUP_FOLLOW, &path);
-	if (err)
-		return err;
-	err = do_add_mount(dev_mnt, &path, 0, NULL);
+	err = sys_mount("devtmpfs", (char *)mntdir, "devtmpfs", MS_SILENT, NULL);
 	if (err)
 		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
 	else
 		printk(KERN_INFO "devtmpfs: mounted\n");
-	path_put(&path);
 	return err;
 }
 
diff --git a/include/linux/device.h b/include/linux/device.h
index 2ea3e49..2a73d9b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -558,7 +558,7 @@ extern void wait_for_device_probe(void);
 #ifdef CONFIG_DEVTMPFS
 extern int devtmpfs_create_node(struct device *dev);
 extern int devtmpfs_delete_node(struct device *dev);
-extern int devtmpfs_mount(const char *mountpoint);
+extern int devtmpfs_mount(const char *mntdir);
 #else
 static inline int devtmpfs_create_node(struct device *dev) { return 0; }
 static inline int devtmpfs_delete_node(struct device *dev) { return 0; }
-- 
1.6.5.5

