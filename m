Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZKPA3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZKPA3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZKPA3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:29:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZKPA1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:27:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Neil Brown <neilb@suse.de>,
       Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org
Subject: [PATCH 08/12] md: move compat_ioctl handling into md.c
Date: Mon, 16 Nov 2009 00:27:03 +0000
Message-Id: <1258331227-1694-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+zFC+4ksigyQ3C9vI2yz+tKyqD3xeWoxZdI9g
 TN9Zosw1oCeFwCJBno908v8LhWcBu6E96rRuNpHJ4hlTZ7pBdO
 lgBQw/QsV98Qb+HDAZi7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RAID ioctls are only implemented in md.c, so the
handling for them should also be moved there from
fs/compat_ioctl.c.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Neil Brown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
---
 drivers/md/md.c   |   23 +++++++++++++++++++++++
 fs/compat_ioctl.c |   23 -----------------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e64c971..e4eebaf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -44,6 +44,7 @@
 #include <linux/random.h>
 #include <linux/reboot.h>
 #include <linux/file.h>
+#include <linux/compat.h>
 #include <linux/delay.h>
 #include <linux/raid/md_p.h>
 #include <linux/raid/md_u.h>
@@ -5503,6 +5504,25 @@ done:
 abort:
 	return err;
 }
+#ifdef CONFIG_COMPAT
+static int md_compat_ioctl(struct block_device *bdev, fmode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case HOT_REMOVE_DISK:
+	case HOT_ADD_DISK:
+	case SET_DISK_FAULTY:
+	case SET_BITMAP_FILE:
+		/* These take in integer arg, do not convert */
+		break;
+	default:
+		arg = (unsigned long)compat_ptr(arg);
+		break;
+	}
+
+	return md_ioctl(bdev, mode, cmd, arg);
+}
+#endif /* CONFIG_COMPAT */
 
 static int md_open(struct block_device *bdev, fmode_t mode)
 {
@@ -5568,6 +5588,9 @@ static const struct block_device_operations md_fops =
 	.open		= md_open,
 	.release	= md_release,
 	.ioctl		= md_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= md_compat_ioctl,
+#endif
 	.getgeo		= md_getgeo,
 	.media_changed	= md_media_changed,
 	.revalidate_disk= md_revalidate,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index b419459..8adfc08 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -837,24 +837,6 @@ COMPATIBLE_IOCTL(FIGETBSZ)
 /* 'X' - originally XFS but some now in the VFS */
 COMPATIBLE_IOCTL(FIFREEZE)
 COMPATIBLE_IOCTL(FITHAW)
-/* RAID */
-COMPATIBLE_IOCTL(RAID_VERSION)
-COMPATIBLE_IOCTL(GET_ARRAY_INFO)
-COMPATIBLE_IOCTL(GET_DISK_INFO)
-COMPATIBLE_IOCTL(PRINT_RAID_DEBUG)
-COMPATIBLE_IOCTL(RAID_AUTORUN)
-COMPATIBLE_IOCTL(CLEAR_ARRAY)
-COMPATIBLE_IOCTL(ADD_NEW_DISK)
-COMPATIBLE_IOCTL(SET_ARRAY_INFO)
-COMPATIBLE_IOCTL(SET_DISK_INFO)
-COMPATIBLE_IOCTL(WRITE_RAID_INFO)
-COMPATIBLE_IOCTL(UNPROTECT_ARRAY)
-COMPATIBLE_IOCTL(PROTECT_ARRAY)
-COMPATIBLE_IOCTL(RUN_ARRAY)
-COMPATIBLE_IOCTL(STOP_ARRAY)
-COMPATIBLE_IOCTL(STOP_ARRAY_RO)
-COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
-COMPATIBLE_IOCTL(GET_BITMAP_FILE)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
 COMPATIBLE_IOCTL(KDGKBTYPE)
@@ -1450,11 +1432,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case TCSBRKP:
 	case TIOCMIWAIT:
 	case TIOCSCTTY:
-	/* RAID */
-	case HOT_REMOVE_DISK:
-	case HOT_ADD_DISK:
-	case SET_DISK_FAULTY:
-	case SET_BITMAP_FILE:
 	/* Big K */
 	case KDSIGACCEPT:
 	case KIOCSOUND:
-- 
1.6.3.3

