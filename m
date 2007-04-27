Return-Path: <linux-kernel-owner+w=401wt.eu-S1757118AbXD0TG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118AbXD0TG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbXD0TGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:06:12 -0400
Received: from ns.suse.de ([195.135.220.2]:50784 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091AbXD0S63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:58:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/46] the overdue removal of the mount/umount uevents
Date: Fri, 27 Apr 2007 11:53:48 -0700
Message-Id: <11777001642551-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1177700160896-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
 <1177700148815-git-send-email-gregkh@suse.de>
 <11777001521006-git-send-email-gregkh@suse.de>
 <1177700156641-git-send-email-gregkh@suse.de>
 <1177700160896-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>

This patch contains the overdue removal of the mount/umount uevents.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/feature-removal-schedule.txt |    9 ---------
 fs/super.c                                 |   12 ------------
 include/linux/kobject.h                    |    8 +++-----
 lib/kobject_uevent.c                       |    4 ----
 4 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 6da6636..ec0b484 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -134,15 +134,6 @@ Who:	Arjan van de Ven <arjan@linux.intel.com>
 
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
diff --git a/fs/super.c b/fs/super.c
index 60b1e50..8341e4e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -725,16 +725,6 @@ static int test_bdev_super(struct super_block *s, void *data)
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
@@ -782,7 +772,6 @@ int get_sb_bdev(struct file_system_type *fs_type,
 		}
 
 		s->s_flags |= MS_ACTIVE;
-		bdev_uevent(bdev, KOBJ_MOUNT);
 	}
 
 	return simple_set_mnt(mnt, s);
@@ -801,7 +790,6 @@ void kill_block_super(struct super_block *sb)
 {
 	struct block_device *bdev = sb->s_bdev;
 
-	bdev_uevent(bdev, KOBJ_UMOUNT);
 	generic_shutdown_super(sb);
 	sync_blockdev(bdev);
 	close_bdev_excl(bdev);
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index a659a97..eb0e63e 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -42,11 +42,9 @@ enum kobject_action {
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
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index d9a3510..12e311d 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -42,10 +42,6 @@ static char *action_to_string(enum kobject_action action)
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
-- 
1.5.1.2

