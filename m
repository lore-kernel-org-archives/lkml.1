Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbZGZIWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbZGZIWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZGZIV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:21:59 -0400
Received: from www.tglx.de ([62.245.132.106]:33961 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZGZIVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:21:52 -0400
Message-Id: <20090726081558.081388099@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:20:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [Patch RFC 36/37] fs: Convert bd_mount_sem to mutex
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=fs-convert-bd-mount-sem-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bd_mount_sem is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/block_dev.c     |    8 ++++----
 fs/super.c         |    4 ++--
 include/linux/fs.h |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/fs/block_dev.c
===================================================================
--- linux-2.6-tip.orig/fs/block_dev.c
+++ linux-2.6-tip/fs/block_dev.c
@@ -240,7 +240,7 @@ struct super_block *freeze_bdev(struct b
 	}
 	bdev->bd_fsfreeze_count++;
 
-	down(&bdev->bd_mount_sem);
+	mutex_lock(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
 	if (sb && !(sb->s_flags & MS_RDONLY)) {
 		sb->s_frozen = SB_FREEZE_WRITE;
@@ -260,7 +260,7 @@ struct super_block *freeze_bdev(struct b
 					"VFS:Filesystem freeze failed\n");
 				sb->s_frozen = SB_UNFROZEN;
 				drop_super(sb);
-				up(&bdev->bd_mount_sem);
+				mutex_unlock(&bdev->bd_mount_sem);
 				bdev->bd_fsfreeze_count--;
 				mutex_unlock(&bdev->bd_fsfreeze_mutex);
 				return ERR_PTR(error);
@@ -321,7 +321,7 @@ int thaw_bdev(struct block_device *bdev,
 		drop_super(sb);
 	}
 
-	up(&bdev->bd_mount_sem);
+	mutex_unlock(&bdev->bd_mount_sem);
 	mutex_unlock(&bdev->bd_fsfreeze_mutex);
 	return 0;
 }
@@ -431,7 +431,7 @@ static void init_once(void *foo)
 
 	memset(bdev, 0, sizeof(*bdev));
 	mutex_init(&bdev->bd_mutex);
-	sema_init(&bdev->bd_mount_sem, 1);
+	mutex_init(&bdev->bd_mount_sem);
 	INIT_LIST_HEAD(&bdev->bd_inodes);
 	INIT_LIST_HEAD(&bdev->bd_list);
 #ifdef CONFIG_SYSFS
Index: linux-2.6-tip/fs/super.c
===================================================================
--- linux-2.6-tip.orig/fs/super.c
+++ linux-2.6-tip/fs/super.c
@@ -740,9 +740,9 @@ int get_sb_bdev(struct file_system_type 
 	 * will protect the lockfs code from trying to start a snapshot
 	 * while we are mounting
 	 */
-	down(&bdev->bd_mount_sem);
+	mutex_lock(&bdev->bd_mount_sem);
 	s = sget(fs_type, test_bdev_super, set_bdev_super, bdev);
-	up(&bdev->bd_mount_sem);
+	mutex_unlock(&bdev->bd_mount_sem);
 	if (IS_ERR(s))
 		goto error_s;
 
Index: linux-2.6-tip/include/linux/fs.h
===================================================================
--- linux-2.6-tip.orig/include/linux/fs.h
+++ linux-2.6-tip/include/linux/fs.h
@@ -640,7 +640,7 @@ struct block_device {
 	struct super_block *	bd_super;
 	int			bd_openers;
 	struct mutex		bd_mutex;	/* open/close mutex */
-	struct semaphore	bd_mount_sem;
+	struct mutex		bd_mount_sem;
 	struct list_head	bd_inodes;
 	void *			bd_holder;
 	int			bd_holders;


