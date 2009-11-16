Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZKPA1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZKPA1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbZKPA1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:27:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZKPA1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:27:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Paul Clements <Paul.Clements@steeleye.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@suse.cz>,
       Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/12] nbd: add compat_ioctl method
Date: Mon, 16 Nov 2009 00:27:00 +0000
Message-Id: <1258331227-1694-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19/dS+SAKta9yq7plRaiTZB+blcN3A5Q2g6je+
 P4ERjYbjHE4rLXBpVgFTRN5Yore/AuKcqc169MhY6sTws0v5na
 XSBo0K7FJSF4R8jCjCz1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nbd driver needs a special case for its compat_ioctl
handling, because it treats the ioctl argument as an
integer instead of a pointer.

Move that handling into the nbd driver itself from
fs/compat_ioctl.c in order to keep it local.

Push down the BKL into the ioctl method at the
same time.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/block/nbd.c |    7 ++++++-
 fs/compat_ioctl.c   |   11 -----------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index cc923a5..758b75d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -30,6 +30,8 @@
 #include <net/sock.h>
 #include <linux/net.h>
 #include <linux/kthread.h>
+#include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -715,9 +717,11 @@ static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
 	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
 			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
 
+	lock_kernel();
 	mutex_lock(&lo->tx_lock);
 	error = __nbd_ioctl(bdev, lo, cmd, arg);
 	mutex_unlock(&lo->tx_lock);
+	unlock_kernel();
 
 	return error;
 }
@@ -725,7 +729,8 @@ static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
 static const struct block_device_operations nbd_fops =
 {
 	.owner =	THIS_MODULE,
-	.locked_ioctl =	nbd_ioctl,
+	.ioctl =	nbd_ioctl,
+	.compat_ioctl =	nbd_ioctl,
 };
 
 /*
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 80f1a92..376d907 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1362,12 +1362,6 @@ COMPATIBLE_IOCTL(USBDEVFS_SUBMITURB32)
 COMPATIBLE_IOCTL(USBDEVFS_REAPURB32)
 COMPATIBLE_IOCTL(USBDEVFS_REAPURBNDELAY32)
 COMPATIBLE_IOCTL(USBDEVFS_CLEAR_HALT)
-/* NBD */
-COMPATIBLE_IOCTL(NBD_DO_IT)
-COMPATIBLE_IOCTL(NBD_CLEAR_SOCK)
-COMPATIBLE_IOCTL(NBD_CLEAR_QUE)
-COMPATIBLE_IOCTL(NBD_PRINT_DEBUG)
-COMPATIBLE_IOCTL(NBD_DISCONNECT)
 /* i2c */
 COMPATIBLE_IOCTL(I2C_SLAVE)
 COMPATIBLE_IOCTL(I2C_SLAVE_FORCE)
@@ -1614,11 +1608,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case KDSKBMETA:
 	case KDSKBLED:
 	case KDSETLED:
-	/* NBD */
-	case NBD_SET_SOCK:
-	case NBD_SET_BLKSIZE:
-	case NBD_SET_SIZE:
-	case NBD_SET_SIZE_BLOCKS:
 		return do_vfs_ioctl(file, fd, cmd, arg);
 	}
 
-- 
1.6.3.3

