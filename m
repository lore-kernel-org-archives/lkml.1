Return-Path: <linux-kernel-owner+w=401wt.eu-S1767564AbXDFKVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767564AbXDFKVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767570AbXDFKVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:21:47 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44160 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767564AbXDFKVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:21:45 -0400
Date: Fri, 6 Apr 2007 12:21:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] the overdue removal of the mount/umount uevents
Message-ID: <20070406102145.GG29169@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the overdue removal of the mount/umount uevents.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 Documentation/feature-removal-schedule.txt |    9 ---------
 fs/super.c                                 |   12 ------------
 include/linux/kobject.h                    |    8 +++-----
 lib/kobject_uevent.c                       |    4 ----
 4 files changed, 3 insertions(+), 30 deletions(-)

--- linux-2.6.21-rc5-mm4/Documentation/feature-removal-schedule.txt.old	2007-04-05 20:52:35.000000000 +0200
+++ linux-2.6.21-rc5-mm4/Documentation/feature-removal-schedule.txt	2007-04-05 20:52:43.000000000 +0200
@@ -126,15 +126,6 @@
 
 ---------------------------
 
-What:	mount/umount uevents
-When:	February 2007
-Why:	These events are not correct, and do not properly let userspace know
-	when a file system has been mounted or unmounted.  Userspace should
-	poll the /proc/mounts file instead to detect this properly.
-Who:	Greg Kroah-Hartman <gregkh@suse.de>
-
----------------------------
-
 What:	USB driver API moves to EXPORT_SYMBOL_GPL
 When:	February 2008
 Files:	include/linux/usb.h, drivers/usb/core/driver.c
--- linux-2.6.21-rc5-mm4/include/linux/kobject.h.old	2007-04-05 20:52:52.000000000 +0200
+++ linux-2.6.21-rc5-mm4/include/linux/kobject.h	2007-04-05 20:53:53.000000000 +0200
@@ -43,11 +43,9 @@ enum kobject_action {
 	KOBJ_ADD	= (__force kobject_action_t) 0x01,	/* exclusive to core */
 	KOBJ_REMOVE	= (__force kobject_action_t) 0x02,	/* exclusive to core */
 	KOBJ_CHANGE	= (__force kobject_action_t) 0x03,	/* device state change */
-	KOBJ_MOUNT	= (__force kobject_action_t) 0x04,	/* mount event for block devices (broken) */
-	KOBJ_UMOUNT	= (__force kobject_action_t) 0x05,	/* umount event for block devices (broken) */
-	KOBJ_OFFLINE	= (__force kobject_action_t) 0x06,	/* device offline */
-	KOBJ_ONLINE	= (__force kobject_action_t) 0x07,	/* device online */
-	KOBJ_MOVE	= (__force kobject_action_t) 0x08,	/* device move */
+	KOBJ_OFFLINE	= (__force kobject_action_t) 0x04,	/* device offline */
+	KOBJ_ONLINE	= (__force kobject_action_t) 0x05,	/* device online */
+	KOBJ_MOVE	= (__force kobject_action_t) 0x06,	/* device move */
 };
 
 struct kobject {
--- linux-2.6.21-rc5-mm4/fs/super.c.old	2007-04-05 20:54:02.000000000 +0200
+++ linux-2.6.21-rc5-mm4/fs/super.c	2007-04-05 20:54:43.000000000 +0200
@@ -726,16 +726,6 @@ static int test_bdev_super(struct super_
 	return (void *)s->s_bdev == data;
 }
 
-static void bdev_uevent(struct block_device *bdev, enum kobject_action action)
-{
-	if (bdev->bd_disk) {
-		if (bdev->bd_part)
-			kobject_uevent(&bdev->bd_part->kobj, action);
-		else
-			kobject_uevent(&bdev->bd_disk->kobj, action);
-	}
-}
-
 int get_sb_bdev(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data,
 	int (*fill_super)(struct super_block *, void *, int),
@@ -783,7 +773,6 @@ int get_sb_bdev(struct file_system_type 
 		}
 
 		s->s_flags |= MS_ACTIVE;
-		bdev_uevent(bdev, KOBJ_MOUNT);
 	}
 
 	return simple_set_mnt(mnt, s);
@@ -802,7 +791,6 @@ void kill_block_super(struct super_block
 {
 	struct block_device *bdev = sb->s_bdev;
 
-	bdev_uevent(bdev, KOBJ_UMOUNT);
 	generic_shutdown_super(sb);
 	sync_blockdev(bdev);
 	close_bdev_excl(bdev);
--- linux-2.6.21-rc5-mm4/lib/kobject_uevent.c.old	2007-04-05 20:54:49.000000000 +0200
+++ linux-2.6.21-rc5-mm4/lib/kobject_uevent.c	2007-04-05 20:56:11.000000000 +0200
@@ -42,10 +42,6 @@ static char *action_to_string(enum kobje
 		return "remove";
 	case KOBJ_CHANGE:
 		return "change";
-	case KOBJ_MOUNT:
-		return "mount";
-	case KOBJ_UMOUNT:
-		return "umount";
 	case KOBJ_OFFLINE:
 		return "offline";
 	case KOBJ_ONLINE:
