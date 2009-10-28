Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbZJ1SvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbZJ1SvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbZJ1SvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:51:20 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39415 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZJ1SvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:51:19 -0400
Subject: Driver-Core: devtmpfs - use sys_mount()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 19:51:17 +0100
Message-Id: <1256755877.2618.322.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver-Core: devtmpfs - use sys_mount()

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/devtmpfs.c |    9 ++-------
 include/linux/device.h  |    2 +-
 2 files changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -330,9 +330,8 @@ out:
  * If configured, or requested by the commandline, devtmpfs will be
  * auto-mounted after the kernel mounted the root filesystem.
  */
-int devtmpfs_mount(const char *mountpoint)
+int devtmpfs_mount(const char *mntdir)
 {
-	struct path path;
 	int err;
 
 	if (!dev_mount)
@@ -341,15 +340,11 @@ int devtmpfs_mount(const char *mountpoin
 	if (!dev_mnt)
 		return 0;
 
-	err = kern_path(mountpoint, LOOKUP_FOLLOW, &path);
-	if (err)
-		return err;
-	err = do_add_mount(dev_mnt, &path, 0, NULL);
+	err = sys_mount("none", (char *)mntdir, "devtmpfs", MS_SILENT, NULL);
 	if (err)
 		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
 	else
 		printk(KERN_INFO "devtmpfs: mounted\n");
-	path_put(&path);
 	return err;
 }
 
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -556,7 +556,7 @@ extern void wait_for_device_probe(void);
 #ifdef CONFIG_DEVTMPFS
 extern int devtmpfs_create_node(struct device *dev);
 extern int devtmpfs_delete_node(struct device *dev);
-extern int devtmpfs_mount(const char *mountpoint);
+extern int devtmpfs_mount(const char *mntdir);
 #else
 static inline int devtmpfs_create_node(struct device *dev) { return 0; }
 static inline int devtmpfs_delete_node(struct device *dev) { return 0; }

