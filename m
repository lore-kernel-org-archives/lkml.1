Return-Path: <linux-kernel-owner+w=401wt.eu-S933691AbYBMRr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691AbYBMRr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYBMRrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:47:11 -0500
Received: from twin.jikos.cz ([213.151.79.26]:47610 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764187AbYBMRrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:47:09 -0500
Date: Wed, 13 Feb 2008 18:47:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: losetup INFO: possible circular locking dependency detected
In-Reply-To: <c4e36d110802130554m72a2d80dpe9786851fe294e88@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802131815430.7699@twin.jikos.cz>
References: <c4e36d110802130554m72a2d80dpe9786851fe294e88@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Zdenek Kabelac wrote:

>  =======================================================
>  [ INFO: possible circular locking dependency detected ]
>  2.6.25-rc1 #29
>  -------------------------------------------------------
>  losetup/26595 is trying to acquire lock:
>   (&bdev->bd_mutex){--..}, at: [<ffffffff810e6258>] __blkdev_put+0x38/0x1e0
>  but task is already holding lock:
>   (&lo->lo_ctl_mutex){--..}, at: [<ffffffff883d097e>] lo_ioctl+0x4e/0xaf0 [loop]
>  which lock already depends on the new lock.

Seems to me that this is valid and there indeed is a AB-BA deadlock in 
loop code.

(BTW when looking at this, there seem to be other locking problems in 
loop.c, the code for example doesn't seem to be consistent whether 
accessing lo->lo_state needs to be protected by lo->lo_lock or not).

What about this ugly fix?



From: Jiri Kosina <jkosina@suse.cz>

loop - fix deadlock against block

A:                                      B:
        bdev_open() for ino X
           (locks bd_mutex for bdev Y)
                                          lo_ioctl(LOOP_CLR_FD) for ino X
                                            (locks lo_ctl_mutex)
                                          fput()
                                          __fput()
                                          blkdev_close()
                                            (hangs on bd_mutex for bdev Y)
        lo_open()
           (hangs on lo_ctl_mutex)

Fix this by letting releasing the lock inside loop_clr_fd() after the 
loopback structure has been completely deinitialized, but before calling 
final fput().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 91ebb00..eb9e091 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -881,6 +881,7 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	struct file *filp = lo->lo_backing_file;
 	gfp_t gfp = lo->old_gfp_mask;
 
+	mutex_lock(&lo->lo_ctl_mutex);
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
 
@@ -916,6 +917,7 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	bd_set_size(bdev, 0);
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
 	lo->lo_state = Lo_unbound;
+	mutex_unlock(&lo->lo_ctl_mutex);
 	fput(filp);
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
@@ -1143,8 +1145,11 @@ static int lo_ioctl(struct inode * inode, struct file * file,
 		err = loop_change_fd(lo, file, inode->i_bdev, arg);
 		break;
 	case LOOP_CLR_FD:
+		/* loop_clr_fd must do the locking itself, so that it
+		 * doesn't deadlock with bdev */
+		mutex_unlock(&lo->lo_ctl_mutex);
 		err = loop_clr_fd(lo, inode->i_bdev);
-		break;
+		goto out_unlocked;
 	case LOOP_SET_STATUS:
 		err = loop_set_status_old(lo, (struct loop_info __user *) arg);
 		break;
@@ -1160,6 +1165,7 @@ static int lo_ioctl(struct inode * inode, struct file * file,
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
+out_unlocked:
 	mutex_unlock(&lo->lo_ctl_mutex);
 	return err;
 }
