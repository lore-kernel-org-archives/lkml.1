Return-Path: <linux-kernel-owner+w=401wt.eu-S1763447AbYBMUWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763447AbYBMUWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbYBMUWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:22:32 -0500
Received: from twin.jikos.cz ([213.151.79.26]:60020 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756746AbYBMUWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:22:32 -0500
Date: Wed, 13 Feb 2008 21:22:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: losetup INFO: possible circular locking dependency detected
In-Reply-To: <Pine.LNX.4.64.0802131815430.7699@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0802132121220.7699@twin.jikos.cz>
References: <c4e36d110802130554m72a2d80dpe9786851fe294e88@mail.gmail.com>
 <Pine.LNX.4.64.0802131815430.7699@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Jiri Kosina wrote:

> From: Jiri Kosina <jkosina@suse.cz>
> 
> loop - fix deadlock against block
> 
> A:                                      B:
>         bdev_open() for ino X
>            (locks bd_mutex for bdev Y)
>                                           lo_ioctl(LOOP_CLR_FD) for ino X
>                                             (locks lo_ctl_mutex)
>                                           fput()
>                                           __fput()
>                                           blkdev_close()
>                                             (hangs on bd_mutex for bdev Y)
>         lo_open()
>            (hangs on lo_ctl_mutex)
> 
> Fix this by letting releasing the lock inside loop_clr_fd() after the 
> loopback structure has been completely deinitialized, but before calling 
> final fput().
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

OK, the previous one was buggy, could you please try this one instead?

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 91ebb00..bfb2e90 100644
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
@@ -1161,6 +1166,7 @@ static int lo_ioctl(struct inode * inode, struct file * file,
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
 	mutex_unlock(&lo->lo_ctl_mutex);
+out_unlocked:
 	return err;
 }
 
