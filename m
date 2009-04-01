Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbZDAWyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbZDAWyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZDAWyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:54:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58212 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbZDAWyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:54:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JBlSu35ZXgqWUiOvHT6MSR7sVdI20tKaUbbu3CcyqbyFIxd+egZWOWpJBqBzt5reNX
         WzyREuGNTy1IOBem49E8KjXzi+12WRKC/uioc0/+3BZMRHKxqZb2OsAmKW1xGbJOTyA4
         3K+WbDA+8JIeX9OUgqiAcU+K+wlaL/QyTYpT4=
Date: Thu, 2 Apr 2009 02:53:51 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-git: cannot mount ext4/loop
Message-ID: <20090401225351.GA22621@orion>
References: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670904011423x4174a81cj901bc140944412ea@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 01:23:28AM +0400, Alexander Beregalov wrote:
> Hi Theodore, Jens
> 
> kernel is 2.6.29-07099-g8b53ef3
> 
> Mount failed:
> 
> EXT4-fs: barriers enabled
> kjournald2 starting: pid 1867, dev loop0:8, commit interval 5 seconds
> EXT4-fs error (device loop0): ext4_iget: block reference 2703228928 >=
> max (524288) in inode #2, offset=0
> EXT4-fs: get root inode failed
> EXT4-fs (device loop0): mount failed
> 
> =====================================
> [ BUG: bad unlock balance detected! ]
> -------------------------------------
> mount/1865 is trying to release lock (&lo->lo_ctl_mutex) at:
> [<00000000006fa1c0>] mutex_unlock+0x10/0x20
> but there are no more locks to release!
> 
> other info that might help us debug this:
> 1 lock held by mount/1865:
>  #0:  (&bdev->bd_mutex){+.+.+.}, at: [<00000000004dd570>]
> __blkdev_put+0x1c/0x14c
> 
> stack backtrace:
> Call Trace:
>  [0000000000477538] print_unlock_inbalance_bug+0xe8/0xf8
>  [0000000000477624] lock_release_non_nested+0xdc/0x290
>  [0000000000477984] lock_release+0x1ac/0x1d8
>  [00000000006fa120] __mutex_unlock_slowpath+0xe8/0x178
>  [00000000006fa1c0] mutex_unlock+0x10/0x20
>  [0000000000621e38] lo_release+0x70/0x80
>  [00000000004dd5fc] __blkdev_put+0xa8/0x14c
>  [00000000004dd6b8] blkdev_put+0x18/0x2c
>  [00000000004dd704] blkdev_close+0x38/0x4c
>  [00000000004b6f0c] __fput+0xfc/0x1e4
>  [00000000004b701c] fput+0x28/0x38
>  [00000000004b4198] filp_close+0x74/0x88
>  [00000000004529e0] put_files_struct+0x9c/0xfc
>  [0000000000452a70] exit_files+0x30/0x40
>  [000000000045406c] do_exit+0x160/0x734
>  [00000000004546cc] do_group_exit+0x8c/0xc4

From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] loop: mutex already unlocked in loop_clr_fd()

mount/1865 is trying to release lock (&lo->lo_ctl_mutex) at:
but there are no more locks to release!

mutex is already unlocked in loop_clr_fd(), we should not
try to unlock it in lo_release() again.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/block/loop.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 40b17d3..ddae808 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1431,6 +1431,7 @@ static int lo_open(struct block_device *bdev, fmode_t mode)
 static int lo_release(struct gendisk *disk, fmode_t mode)
 {
 	struct loop_device *lo = disk->private_data;
+	int err;
 
 	mutex_lock(&lo->lo_ctl_mutex);
 
@@ -1442,7 +1443,9 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 		 * In autoclear mode, stop the loop thread
 		 * and remove configuration after last close.
 		 */
-		loop_clr_fd(lo, NULL);
+		err = loop_clr_fd(lo, NULL);
+		if (!err)
+			goto out_unlocked;
 	} else {
 		/*
 		 * Otherwise keep thread (if running) and config,
@@ -1453,7 +1456,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 
 out:
 	mutex_unlock(&lo->lo_ctl_mutex);
-
+out_unlocked:
 	return 0;
 }
 
