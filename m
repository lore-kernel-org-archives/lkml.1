Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbYAZFFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbYAZFFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbYAZFFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:05:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:52692 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbYAZFFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:05:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,253,1199692800"; 
   d="scan'208";a="330205246"
From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] block: look up block device path in sysfs
To: akpm@linux-foundation.org, jens.axboe@oracle.com
Cc: neilb@suse.de, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Date: Fri, 25 Jan 2008 22:04:51 -0700
Message-ID: <20080126050313.3756.13442.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given an fd on a block device, returns a string like

	/block/sda/sda1

which can be used to find related information in /sys.

Ideally we should have an ioctl that works on char devices as well,
but that seems far from trivial, so it seems reasonable to have
this until the latter can be implemented.

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Things have been quiet since this was posted about a month ago, and I am
hoping to see this in 2.6.25.  It is based on Neil's BLKGETNAME patch
and is updated with Kay's comments.

Regards,
Dan

 block/compat_ioctl.c |    1 +
 block/ioctl.c        |   28 ++++++++++++++++++++++++++++
 include/linux/fs.h   |    1 +
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index cae0a85..d71d287 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -784,6 +784,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	switch (cmd) {
 	case HDIO_GETGEO:
 		return compat_hdio_getgeo(disk, bdev, compat_ptr(arg));
+	case BLKGETDEVPATH:
 	case BLKFLSBUF:
 	case BLKROSET:
 	/*
diff --git a/block/ioctl.c b/block/ioctl.c
index 52d6385..d048ae4 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -229,6 +229,34 @@ int blkdev_ioctl(struct inode *inode, struct file *file, unsigned cmd,
 	int ret, n;
 
 	switch(cmd) {
+	case BLKGETDEVPATH: {
+		char *path;
+		char b[BDEVNAME_SIZE];
+		size_t len;
+
+		path = kobject_get_path(&disk->kobj, GFP_KERNEL);
+
+		if (!path)
+			return -ENOMEM;
+
+		len = strlen(path);
+		if (copy_to_user((char __user *)arg, path, len + 1)) {
+			kfree(path);
+			return -EFAULT;
+		}
+		kfree(path);
+
+		if (bdev->bd_contains == bdev)
+			return 0;
+
+		bdevname(bdev, b);
+		if (copy_to_user((char __user *)arg + len, "/", 2))
+			return -EFAULT;
+		if (copy_to_user((char __user *)arg + len + 1, b,
+				 strlen(b) + 1))
+			return -EFAULT;
+		return 0;
+	}
 	case BLKFLSBUF:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..b4cf8f3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -217,6 +217,7 @@ extern int dir_notify_enable;
 #define BLKTRACESTART _IO(0x12,116)
 #define BLKTRACESTOP _IO(0x12,117)
 #define BLKTRACETEARDOWN _IO(0x12,118)
+#define BLKGETDEVPATH _IOR(0x12, 119, char [1024])
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */

