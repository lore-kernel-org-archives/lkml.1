Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZH0OFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZH0OFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZH0OFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:05:50 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:34353 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZH0OFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:05:50 -0400
Message-ID: <4A9692BF.2000400@oss.ntt.co.jp>
Date: Thu, 27 Aug 2009 23:05:51 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: t-sato@yk.jp.nec.com, m-hamaguchi@ys.jp.nec.com,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/4] freeze_bdev: kill bd_mount_sem
References: <4A94C151.8020900@oss.ntt.co.jp> <20090826173839.GA20175@lst.de> <4A965BD1.205@oss.ntt.co.jp>
In-Reply-To: <4A965BD1.205@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] freeze_bdev: kill bd_mount_sem

Now that we have the freeze count there is not much reason for bd_mount_sem
anymore.  The actual freeze/thaw operations are serialized using the
bd_fsfreeze_mutex, and the only other place we take bd_mount_sem is
get_sb_bdev which tries to prevent mounting a filesystem while the block
device is frozen.  Instead of add a check for bd_fsfreeze_count and
return -EBUSY if a filesystem is frozen.  While that is a change in user
visible behaviour a failing mount is much better for this case rather
than having the mount process stuck uninterruptible for a long time.


Signed-off-by: Christoph Hellwig <hch@lst.de>
---

diff -urNp linux-2.6.31-rc7-orig/fs/block_dev.c linux-2.6.31-rc7/fs/block_dev.c
--- linux-2.6.31-rc7-orig/fs/block_dev.c	2009-08-27 19:34:35.000000000 +0900
+++ linux-2.6.31-rc7/fs/block_dev.c	2009-08-27 19:36:22.000000000 +0900
@@ -216,8 +216,6 @@ EXPORT_SYMBOL(fsync_bdev);
   * freeze_bdev  --  lock a filesystem and force it into a consistent state
   * @bdev:	blockdevice to lock
   *
- * This takes the block device bd_mount_sem to make sure no new mounts
- * happen on bdev until thaw_bdev() is called.
   * If a superblock is found on this device, we take the s_umount semaphore
   * on it to make sure nobody unmounts until the snapshot creation is done.
   * The reference counter (bd_fsfreeze_count) guarantees that only the last
@@ -240,7 +238,6 @@ struct super_block *freeze_bdev(struct b
  	}
  	bdev->bd_fsfreeze_count++;

-	down(&bdev->bd_mount_sem);
  	sb = get_super(bdev);
  	if (sb && !(sb->s_flags & MS_RDONLY)) {
  		sb->s_frozen = SB_FREEZE_WRITE;
@@ -260,7 +257,6 @@ struct super_block *freeze_bdev(struct b
  					"VFS:Filesystem freeze failed\n");
  				sb->s_frozen = SB_UNFROZEN;
  				drop_super(sb);
-				up(&bdev->bd_mount_sem);
  				bdev->bd_fsfreeze_count--;
  				mutex_unlock(&bdev->bd_fsfreeze_mutex);
  				return ERR_PTR(error);
@@ -271,7 +267,7 @@ struct super_block *freeze_bdev(struct b
  	sync_blockdev(bdev);
  	mutex_unlock(&bdev->bd_fsfreeze_mutex);

-	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
+	return sb;	/* thaw_bdev releases s->s_umount */
  }
  EXPORT_SYMBOL(freeze_bdev);

@@ -321,7 +317,6 @@ int thaw_bdev(struct block_device *bdev,
  		drop_super(sb);
  	}

-	up(&bdev->bd_mount_sem);
  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
  	return 0;
  }
@@ -431,7 +426,6 @@ static void init_once(void *foo)

  	memset(bdev, 0, sizeof(*bdev));
  	mutex_init(&bdev->bd_mutex);
-	sema_init(&bdev->bd_mount_sem, 1);
  	INIT_LIST_HEAD(&bdev->bd_inodes);
  	INIT_LIST_HEAD(&bdev->bd_list);
  #ifdef CONFIG_SYSFS
diff -urNp linux-2.6.31-rc7-orig/fs/super.c linux-2.6.31-rc7/fs/super.c
--- linux-2.6.31-rc7-orig/fs/super.c	2009-08-27 19:34:35.000000000 +0900
+++ linux-2.6.31-rc7/fs/super.c	2009-08-27 19:36:22.000000000 +0900
@@ -740,9 +740,14 @@ int get_sb_bdev(struct file_system_type
  	 * will protect the lockfs code from trying to start a snapshot
  	 * while we are mounting
  	 */
-	down(&bdev->bd_mount_sem);
+	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	if (bdev->bd_fsfreeze_count > 0) {
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		error = -EBUSY;
+		goto error_bdev;
+	}
  	s = sget(fs_type, test_bdev_super, set_bdev_super, bdev);
-	up(&bdev->bd_mount_sem);
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
  	if (IS_ERR(s))
  		goto error_s;

diff -urNp linux-2.6.31-rc7-orig/include/linux/fs.h linux-2.6.31-rc7/include/linux/fs.h
--- linux-2.6.31-rc7-orig/include/linux/fs.h	2009-08-27 19:34:35.000000000 +0900
+++ linux-2.6.31-rc7/include/linux/fs.h	2009-08-27 19:36:22.000000000 +0900
@@ -640,7 +640,6 @@ struct block_device {
  	struct super_block *	bd_super;
  	int			bd_openers;
  	struct mutex		bd_mutex;	/* open/close mutex */
-	struct semaphore	bd_mount_sem;
  	struct list_head	bd_inodes;
  	void *			bd_holder;
  	int			bd_holders;
