Return-Path: <linux-kernel-owner+w=401wt.eu-S1945946AbXBPKsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945946AbXBPKsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945950AbXBPKsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:48:12 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:7603 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1945946AbXBPKsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:48:11 -0500
Subject: [PATCH] lockdep: annotate BLKPG_DEL_PARTITION
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       arjan <arjan@infradead.org>, Neil Brown <neilb@suse.de>,
       Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 11:45:39 +0100
Message-Id: <1171622739.24923.64.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>=============================================
>[ INFO: possible recursive locking detected ]
>2.6.19-1.2909.fc7 #1
>---------------------------------------------
>anaconda/587 is trying to acquire lock:
> (&bdev->bd_mutex){--..}, at: [<c05fb380>] mutex_lock+0x21/0x24
>
>but task is already holding lock:
> (&bdev->bd_mutex){--..}, at: [<c05fb380>] mutex_lock+0x21/0x24
>
>other info that might help us debug this:
>1 lock held by anaconda/587:
> #0:  (&bdev->bd_mutex){--..}, at: [<c05fb380>] mutex_lock+0x21/0x24
>
>stack backtrace:
> [<c0405812>] show_trace_log_lvl+0x1a/0x2f
> [<c0405db2>] show_trace+0x12/0x14
> [<c0405e36>] dump_stack+0x16/0x18
> [<c043bd84>] __lock_acquire+0x116/0xa09
> [<c043c960>] lock_acquire+0x56/0x6f
> [<c05fb1fa>] __mutex_lock_slowpath+0xe5/0x24a
> [<c05fb380>] mutex_lock+0x21/0x24
> [<c04d82fb>] blkdev_ioctl+0x600/0x76d
> [<c04946b1>] block_ioctl+0x1b/0x1f
> [<c047ed5a>] do_ioctl+0x22/0x68
> [<c047eff2>] vfs_ioctl+0x252/0x265
> [<c047f04e>] sys_ioctl+0x49/0x63
> [<c0404070>] syscall_call+0x7/0xb

Annotate BLKPG_DEL_PARTITION's bd_mutex locking and add a little comment
clarifying the bd_mutex locking, because I confused myself and initially
thought the lock order was wrong too.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/ioctl.c  |    2 +-
 fs/block_dev.c |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.20.noarch/block/ioctl.c
===================================================================
--- linux-2.6.20.noarch.orig/block/ioctl.c
+++ linux-2.6.20.noarch/block/ioctl.c
@@ -82,7 +82,7 @@ static int blkpg_ioctl(struct block_devi
 			fsync_bdev(bdevp);
 			invalidate_bdev(bdevp, 0);
 
-			mutex_lock(&bdev->bd_mutex);
+			mutex_lock_nested(&bdev->bd_mutex, 1);
 			delete_partition(disk, part);
 			mutex_unlock(&bdev->bd_mutex);
 			mutex_unlock(&bdevp->bd_mutex);
Index: linux-2.6.20.noarch/fs/block_dev.c
===================================================================
--- linux-2.6.20.noarch.orig/fs/block_dev.c
+++ linux-2.6.20.noarch/fs/block_dev.c
@@ -1101,6 +1101,13 @@ static int __blkdev_get(struct block_dev
 			int for_part);
 static int __blkdev_put(struct block_device *bdev, int for_part);
 
+/*
+ * bd_mutex locking:
+ *
+ *  mutex_lock(part->bd_mutex)
+ *    mutex_lock_nested(whole->bd_mutex, 1)
+ */
+
 static int do_open(struct block_device *bdev, struct file *file, int for_part)
 {
 	struct module *owner = NULL;


