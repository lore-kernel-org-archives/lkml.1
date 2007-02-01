Return-Path: <linux-kernel-owner+w=401wt.eu-S1422940AbXBATQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422940AbXBATQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422952AbXBATQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:16:49 -0500
Received: from brick.kernel.dk ([62.242.22.158]:27327 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422940AbXBATQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:16:48 -0500
Date: Thu, 1 Feb 2007 20:18:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070201191857.GQ10305@kernel.dk>
References: <20070129204528.eb8d695e.akpm@osdl.org> <Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com> <20070131162422.6bccc52c.akpm@osdl.org> <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com> <20070131163638.290f40c1.akpm@osdl.org> <20070201062018.GC33919298@melbourne.sgi.com> <20070131231253.fdebc9f5.akpm@osdl.org> <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01 2007, Christoph Lameter wrote:
> On Wed, 31 Jan 2007, Andrew Morton wrote:
> 
> > But usually none of that is necessary, because io_schedule() does all the
> > work for you.
> > 
> > err, this might help.
> 
> Well okay boot progresses further (maybe only on this boot) but system is 
> still hung.
> 
> Traces (this was a backtrace of all processes on the system. I removed 
> the irrelevant ones):
> 
> Delaying for 5 seconds...
> All OS INIT slaves have reached rendezvous
> Processes interrupted by INIT - 0 (cpu 0 task 0xa000000100b24000) 0 (cpu 1 
> task 0xe00000b003bd8000) 0 (cpu 2 task 0xe000023c38248000) 0 (cpu 3 task 
> 0xe00000b003d00000) 0 (cpu 4 task 0xe000023c38258000) 0 (cpu 5 task 
> 0xe00000b003d10000) 0 (cpu 6 task 0xe000023c38268000) 0 (cpu 7 task 
> 0xe00000b003d20000) 0 (cpu 8 task 0xe000023c382e8000) 0 (cpu 9 task 
> 0xe00000b003d30000) 0 (cpu 10 task 0xe000023c38380000) 0 (cpu 11 task 
> 0xe00000b003d40000)
> 
> 
> Backtrace of pid 1 (init)
> 
> Call Trace:
>  [<a000000100799bb0>] schedule+0x1bf0/0x1ec0
>                                 sp=e00000307bd178c0 bsp=e00000307bd11828
>  [<a000000100797b20>] __down+0x240/0x280
>                                 sp=e00000307bd179d0 bsp=e00000307bd117e8
>  [<a0000001003b8f10>] xfs_buf_iowait+0x50/0x80
>                                 sp=e00000307bd17a00 bsp=e00000307bd117c8

That down() probably wants a replug to precede it. Probably something
like:

        if (atomic_read(&bp->b_io_remaining))
                blk_replug_current_nested();

for xfs_buf_wait_unpin() and xfs_buf_lock(). Does this fix it?

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index f2bdf8b..1ef226e 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -909,6 +909,8 @@ xfs_buf_lock(
 	xfs_buf_t		*bp)
 {
 	XB_TRACE(bp, "lock", 0);
+	if (atomic_read(&bp->b_io_remaining))
+		blk_replug_current_nested();
 	down(&bp->b_sema);
 	XB_SET_OWNER(bp);
 	XB_TRACE(bp, "locked", 0);
@@ -979,7 +981,7 @@ xfs_buf_wait_unpin(
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (atomic_read(&bp->b_pin_count) == 0)
 			break;
-		schedule();
+		io_schedule();
 	}
 	remove_wait_queue(&bp->b_waiters, &wait);
 	set_current_state(TASK_RUNNING);
@@ -1291,6 +1293,8 @@ xfs_buf_iowait(
 	xfs_buf_t		*bp)
 {
 	XB_TRACE(bp, "iowait", 0);
+	if (atomic_read(&bp->b_io_remaining))
+		blk_replug_current_nested();
 	down(&bp->b_iodonesema);
 	XB_TRACE(bp, "iowaited", (long)bp->b_error);
 	return bp->b_error;
@@ -1682,6 +1686,7 @@ xfsbufd(
 	xfs_buf_t		*bp, *n;
 	struct list_head	*dwq = &target->bt_delwrite_queue;
 	spinlock_t		*dwlk = &target->bt_delwrite_lock;
+	int			count;
 
 	current->flags |= PF_MEMALLOC;
 
@@ -1697,6 +1702,7 @@ xfsbufd(
 		schedule_timeout_interruptible(
 			xfs_buf_timer_centisecs * msecs_to_jiffies(10));
 
+		count = 0;
 		age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
 		spin_lock(dwlk);
 		list_for_each_entry_safe(bp, n, dwq, b_list) {
@@ -1716,6 +1722,7 @@ xfsbufd(
 						 _XBF_RUN_QUEUES);
 				bp->b_flags |= XBF_WRITE;
 				list_move_tail(&bp->b_list, &tmp);
+				count++;
 			}
 		}
 		spin_unlock(dwlk);
@@ -1730,6 +1737,8 @@ xfsbufd(
 
 		if (as_list_len > 0)
 			purge_addresses();
+		if (count)
+			blk_replug_current_nested();
 
 		clear_bit(XBT_FORCE_FLUSH, &target->bt_flags);
 	} while (!kthread_should_stop());
@@ -1786,6 +1795,9 @@ xfs_flush_buftarg(
 		xfs_buf_iostrategy(bp);
 	}
 
+	if (wait)
+		blk_replug_current_nested();
+
 	/*
 	 * Remaining list items must be flushed before returning
 	 */

-- 
Jens Axboe

