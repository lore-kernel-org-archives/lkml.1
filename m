Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZETIy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZETIy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZETIys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:54:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33601 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZETIyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:54:46 -0400
Date: Wed, 20 May 2009 10:54:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
Message-ID: <20090520085446.GN11363@kernel.dk>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <1242713463.2560.5.camel@ymzhang> <20090519062049.GP4140@kernel.dk> <1242805911.2560.28.camel@ymzhang> <20090520080938.GM11363@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20090520080938.GM11363@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 20 2009, Jens Axboe wrote:
> On Wed, May 20 2009, Zhang, Yanmin wrote:
> > On Tue, 2009-05-19 at 08:20 +0200, Jens Axboe wrote:
> > > On Tue, May 19 2009, Zhang, Yanmin wrote:
> > > > On Mon, 2009-05-18 at 14:19 +0200, Jens Axboe wrote:
> > > > > Hi,
> > > > >
> > > > > This is the fourth version of this patchset. Chances since v3:
> > > > >
> > > > > - Dropped a prep patch, it has been included in mainline since.
> > > > >
> > > > > - Add a work-to-do list to the bdi. This is struct bdi_work. Each
> > > > >   wb thread will notice and execute work on bdi->work_list. The arguments
> > > > >   are which sb (or NULL for all) to flush and how many pages to flush.
> > > > >
> > > > > - Fix a bug where not all bdi's would end up on the bdi_list, so potentially
> > > > >   some data would not be flushed.
> > > > >
> > > > > - Make wb_kupdated() pass on wbc->older_than_this so we maintain the same
> > > > >   behaviour for kupdated flushes.
> > > > >
> > > > > - Have the wb thread flush first before sleeping, to avoid losing the
> > > > >   first flush on lazy register.
> > > > >
> > > > > - Rebase to newer kernels.
> > 
> > > I'm attaching two patches - apply #1 to -rc6, and then #2 is a roll-up
> > > of the patch series that you can apply next.
> > Jens,
> > 
> > I run into 2 issues with kernel 2.6.30-rc6+BDI_Flusher_V4. Below is one.
> > 
> > Tue May 19 00:00:00 CST 2009
> > BUG: unable to handle kernel NULL pointer dereference at 00000000000001d8
> > IP: [<ffffffff803f3c4c>] generic_make_request+0x10a/0x384
> > PGD 0
> > Oops: 0000 [#1] SMP
> > last sysfs file: /sys/block/sdb/stat
> > CPU 0
> > Modules linked in: igb
> > Pid: 1445, comm: bdi-8:16 Not tainted 2.6.30-rc6-bdiflusherv4 #1 X8DTN
> > RIP: 0010:[<ffffffff803f3c4c>]  [<ffffffff803f3c4c>] generic_make_request+0x10a/0x384
> > RSP: 0018:ffff8800bd04da60  EFLAGS: 00010206
> > RAX: 0000000000000000 RBX: ffff8801be45d500 RCX: 00000000038a0df8
> > RDX: 0000000000000008 RSI: 0000000000000576 RDI: ffff8801bf408680
> > RBP: ffff8801be45d500 R08: ffffe20001ee8140 R09: ffff8800bd04da98
> > R10: 0000000000000000 R11: ffff8800bd72eb40 R12: ffff8801be45d500
> > R13: ffff88005f51f310 R14: 0000000000000008 R15: ffff8800b15a5458
> > FS:  0000000000000000(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 00000000000001d8 CR3: 0000000000201000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process bdi-8:16 (pid: 1445, threadinfo ffff8800bd04c000, task ffff8800bd1b75f0)
> > Stack:
> >  0000000000000008 ffffffff8027a613 00000000848dc000 ffffffffffffffff
> >  ffff8800a8190f50 ffffffff00000012 ffff8800a81938e0 ffffc2000000001b
> >  0000000000000000 0000000000000000 ffffe200026f9c30 0000000000000000
> > Call Trace:
> >  [<ffffffff8027a613>] ? mempool_alloc+0x59/0x10f
> >  [<ffffffff803f3f70>] ? submit_bio+0xaa/0xb1
> >  [<ffffffff802c6a3f>] ? submit_bh+0xe3/0x103
> >  [<ffffffff802c92ea>] ? __block_write_full_page+0x1fb/0x2f2
> >  [<ffffffff802c7d6a>] ? end_buffer_async_write+0x0/0xfb
> >  [<ffffffff8027e8d2>] ? __writepage+0xa/0x25
> >  [<ffffffff8027f036>] ? write_cache_pages+0x21c/0x338
> >  [<ffffffff8027e8c8>] ? __writepage+0x0/0x25
> >  [<ffffffff8027f195>] ? do_writepages+0x27/0x2d
> >  [<ffffffff802c22c1>] ? __writeback_single_inode+0x159/0x2b3
> >  [<ffffffff8071e52a>] ? thread_return+0x3e/0xaa
> >  [<ffffffff8027f267>] ? determine_dirtyable_memory+0xd/0x1d
> >  [<ffffffff8027f2dd>] ? get_dirty_limits+0x1d/0x255
> >  [<ffffffff802c27bc>] ? generic_sync_wb_inodes+0x1b4/0x220
> >  [<ffffffff802c3130>] ? wb_do_writeback+0x16c/0x215
> >  [<ffffffff802c323e>] ? bdi_writeback_task+0x65/0x10d
> >  [<ffffffff8024cc06>] ? autoremove_wake_function+0x0/0x2e
> >  [<ffffffff8024cb27>] ? bit_waitqueue+0x10/0xa0
> >  [<ffffffff80289257>] ? bdi_start_fn+0x0/0xba
> >  [<ffffffff802892c6>] ? bdi_start_fn+0x6f/0xba
> >  [<ffffffff8024c860>] ? kthread+0x54/0x80
> >  [<ffffffff8020c97a>] ? child_rip+0xa/0x20
> >  [<ffffffff8024c80c>] ? kthread+0x0/0x80
> >  [<ffffffff8020c970>] ? child_rip+0x0/0x20
> > 
> > The panic happened at the beginging of a mmap randrw after a mmap randwrite.
> > 
> > It's triggered in __generic_make_request => bdev_get_queue(bio->bi_bdev),
> > because ???bio->bi_bdev->bd_disk is equal to NULL.
> > 
> > The callchain is:
> > ???bdi_writeback_task =>
> > 	wb_do_writeback =>
> > 		???generic_sync_wb_inodes =>
> > 			???__writeback_single_inode =>
> > 				...
> > 				???__block_write_full_page =>
> > 				???submit_bh =>
> > 				submit_bio=>
> > 				???generic_make_request
> 
> Wow, that is really odd. Can you pass the details of the test you ran?

I found one issue yesterday and one today that could cause issues, not
sure it would explain this one. But at least it's worth a try, if it's
reproducible. I'm attaching the three patches I have against the posted
series. The one in the middle is just an optimization, the first and
third are the bug fixes.

-- 
Jens Axboe


--cWoXeonUoKmBZSoM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-writeback-add-memory-barrier-before-wake_up_bit-in-b.patch"

>From 9025f9ffc675c3d8bf6c25fdebe30ca98082bab6 Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 19 May 2009 09:47:02 +0200
Subject: [PATCH 1/3] writeback: add memory barrier before wake_up_bit() in bdi_work_free()

As per wake_up_bit() documentation, was also triggered in the wild.
Process got stuck forever waiting for a bit clear that had happened.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a287c09..6052701 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -102,6 +102,7 @@ static void bdi_work_free(struct rcu_head *head)
 		kfree(work);
 	else {
 		clear_bit(0, &work->state);
+		smp_mb__after_clear_bit();
 		wake_up_bit(&work->state, 0);
 	}
 }
-- 
1.6.3.9.g6345


--cWoXeonUoKmBZSoM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-writeback-attempt-to-allocate-work-struct-in-bdi_sta.patch"

>From b4c4af0be4ff04648d2033dc3ac4dd4d50d5864d Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 19 May 2009 11:26:58 +0200
Subject: [PATCH 2/3] writeback: attempt to allocate work struct in bdi_start_writeback()

If the allocation works, then we don't have to wait for the threads
to wake up and notice the work. So it would potentially cause less
lag in bdi_start_writeback(). If it fails, just fall back to an on-stack
work struct again.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/fs-writeback.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6052701..f80afaa 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -191,14 +191,25 @@ static void bdi_wait_on_work_start(struct bdi_work *work)
 int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
 			 long nr_pages)
 {
-	struct bdi_work work;
+	struct bdi_work work_stack, *work;
 	int ret;
 
-	bdi_work_init_on_stack(&work, sb, nr_pages);
+	work = kmalloc(sizeof(*work), GFP_ATOMIC);
+	if (work)
+		bdi_work_init(work, sb, nr_pages);
+	else {
+		work = &work_stack;
+		bdi_work_init_on_stack(work, sb, nr_pages);
+	}
 
-	ret = bdi_queue_writeback(bdi, &work);
+	ret = bdi_queue_writeback(bdi, work);
 
-	bdi_wait_on_work_start(&work);
+	/*
+	 * If this came from our stack, we need to wait until the wb threads
+	 * have noticed this work before we return (and invalidate the stack)
+	 */
+	if (work == &work_stack)
+		bdi_wait_on_work_start(work);
 
 	return ret;
 }
-- 
1.6.3.9.g6345


--cWoXeonUoKmBZSoM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0003-writeback-mm-backing-dev.c-bdi_start_fn-should-use-b.patch"

>From 81eabcf5ca618e2453d97a8822bc6b00fdad81c2 Mon Sep 17 00:00:00 2001
From: Jens Axboe <jens.axboe@oracle.com>
Date: Wed, 20 May 2009 10:53:44 +0200
Subject: [PATCH 3/3] writeback: mm/backing-dev.c:bdi_start_fn() should use bh disabling locks

bdi_lock is grabbed from softirq context, so we need to always use
bh disabling spinlocks. All the other callsites are OK, but this one
missed the _bh() postfix.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 mm/backing-dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d45251f..60578bc 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -365,9 +365,9 @@ static int bdi_start_fn(void *ptr)
 	/*
 	 * Make us discoverable on the bdi_list again
 	 */
-	spin_lock(&bdi_lock);
+	spin_lock_bh(&bdi_lock);
 	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-	spin_unlock(&bdi_lock);
+	spin_unlock_bh(&bdi_lock);
 
 	ret = bdi_writeback_task(wb);
 
-- 
1.6.3.9.g6345


--cWoXeonUoKmBZSoM--
