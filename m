Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbZEVUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbZEVUoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbZEVUoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:44:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45836 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936AbZEVUoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:44:01 -0400
Date: Fri, 22 May 2009 22:44:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
Message-ID: <20090522204401.GQ11363@kernel.dk>
References: <1242805911.2560.28.camel@ymzhang> <20090520080938.GM11363@kernel.dk> <20090520085446.GN11363@kernel.dk> <1242811142.2560.33.camel@ymzhang> <20090520092528.GP11363@kernel.dk> <20090520111910.GS11363@kernel.dk> <1242887627.2560.45.camel@ymzhang> <20090521091033.GA6987@duck.suse.cz> <1242955708.2560.52.camel@ymzhang> <20090522081539.GM11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090522081539.GM11363@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22 2009, Jens Axboe wrote:
> On Fri, May 22 2009, Zhang, Yanmin wrote:
> > On Thu, 2009-05-21 at 11:10 +0200, Jan Kara wrote:
> > > On Thu 21-05-09 14:33:47, Zhang, Yanmin wrote:
> > > > On Wed, 2009-05-20 at 13:19 +0200, Jens Axboe wrote:
> > > > > On Wed, May 20 2009, Jens Axboe wrote:
> > > > > > On Wed, May 20 2009, Zhang, Yanmin wrote:
> > > > > > > On Wed, 2009-05-20 at 10:54 +0200, Jens Axboe wrote:
> > > > > > > > On Wed, May 20 2009, Jens Axboe wrote:
> > > > > > > > > On Wed, May 20 2009, Zhang, Yanmin wrote:
> > > > > > > > > > On Tue, 2009-05-19 at 08:20 +0200, Jens Axboe wrote:
> > > > > > > > > > > On Tue, May 19 2009, Zhang, Yanmin wrote:
> > > > > > > > > > > > On Mon, 2009-05-18 at 14:19 +0200, Jens Axboe wrote:
> > > > > > > > > > > > > Hi,
> > > > > > > > > > > > >
> > > > > > > > > > > > > This is the fourth version of this patchset. Chances since v3:
> > > > > > > > > > > > >
> > > > > > > > > > > > > - Dropped a prep patch, it has been included in mainline since.
> > > > > > > > > > > > >
> > > > > > > > > > > > > - Add a work-to-do list to the bdi. This is struct bdi_work. Each
> > > > > > > > > > > > >   wb thread will notice and execute work on bdi->work_list. The arguments
> > > > > > > > > > > > >   are which sb (or NULL for all) to flush and how many pages to flush.
> > > > > > > > > > > > >
> > > > > > > > > > > > > - Fix a bug where not all bdi's would end up on the bdi_list, so potentially
> > > > > > > > > > > > >   some data would not be flushed.
> > > > > > > > > > > > >
> > > > > > > > > > > > > - Make wb_kupdated() pass on wbc->older_than_this so we maintain the same
> > > > > > > > > > > > >   behaviour for kupdated flushes.
> > > > > > > > > > > > >
> > > > > > > > > > > > > - Have the wb thread flush first before sleeping, to avoid losing the
> > > > > > > > > > > > >   first flush on lazy register.
> > > > > > > > > > > > >
> > > > > > > > > > > > > - Rebase to newer kernels.
> > > > > > > > > > 
> > > > > > > > > > > I'm attaching two patches - apply #1 to -rc6, and then #2 is a roll-up
> > > > > > > > > > > of the patch series that you can apply next.
> > > > > > > > > > Jens,
> > > > > > > > > > 
> > > > > > > > > > I run into 2 issues with kernel 2.6.30-rc6+BDI_Flusher_V4. Below is one.
> > > > > > > > > > 
> > > > > > > > > > Tue May 19 00:00:00 CST 2009
> > > > > > > > > > BUG: unable to handle kernel NULL pointer dereference at 00000000000001d8
> > > > > > > > > > IP: [<ffffffff803f3c4c>] generic_make_request+0x10a/0x384
> > > > > > > > > > PGD 0
> > > > > > > > > > Oops: 0000 [#1] SMP
> > > > > > > > > > last sysfs file: /sys/block/sdb/stat
> > > > > > > > > > CPU 0
> > > > > > > > > > Modules linked in: igb
> > > > > > > > > > Pid: 1445, comm: bdi-8:16 Not tainted 2.6.30-rc6-bdiflusherv4 #1 X8DTN
> > > > > > > > > > RIP: 0010:[<ffffffff803f3c4c>]  [<ffffffff803f3c4c>] generic_make_request+0x10a/0x384
> > > > > > > > > > RSP: 0018:ffff8800bd04da60  EFLAGS: 00010206
> > > > > > > > > > RAX: 0000000000000000 RBX: ffff8801be45d500 RCX: 00000000038a0df8
> > > > > > > > > > RDX: 0000000000000008 RSI: 0000000000000576 RDI: ffff8801bf408680
> > > > > > > > > > RBP: ffff8801be45d500 R08: ffffe20001ee8140 R09: ffff8800bd04da98
> > > > > > > > > > R10: 0000000000000000 R11: ffff8800bd72eb40 R12: ffff8801be45d500
> > > > > > > > > > R13: ffff88005f51f310 R14: 0000000000000008 R15: ffff8800b15a5458
> > > > > > > > > > FS:  0000000000000000(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
> > > > > > > > > > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > > > > > > > > > CR2: 00000000000001d8 CR3: 0000000000201000 CR4: 00000000000006e0
> > > > > > > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > > > > > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > > > > > > > Process bdi-8:16 (pid: 1445, threadinfo ffff8800bd04c000, task ffff8800bd1b75f0)
> > > > > > > > > > Stack:
> > > > > > > > > >  0000000000000008 ffffffff8027a613 00000000848dc000 ffffffffffffffff
> > > > > > > > > >  ffff8800a8190f50 ffffffff00000012 ffff8800a81938e0 ffffc2000000001b
> > > > > > > > > >  0000000000000000 0000000000000000 ffffe200026f9c30 0000000000000000
> > > > > > > > > > Call Trace:
> > > > > > > > > >  [<ffffffff8027a613>] ? mempool_alloc+0x59/0x10f
> > > > > > > > > >  [<ffffffff803f3f70>] ? submit_bio+0xaa/0xb1
> > > > > > > > > >  [<ffffffff802c6a3f>] ? submit_bh+0xe3/0x103
> > > > > > > > > >  [<ffffffff802c92ea>] ? __block_write_full_page+0x1fb/0x2f2
> > > > > > > > > >  [<ffffffff802c7d6a>] ? end_buffer_async_write+0x0/0xfb
> > > > > > > > > >  [<ffffffff8027e8d2>] ? __writepage+0xa/0x25
> > > > > > > > > >  [<ffffffff8027f036>] ? write_cache_pages+0x21c/0x338
> > > > > > > > > >  [<ffffffff8027e8c8>] ? __writepage+0x0/0x25
> > > > > > > > > >  [<ffffffff8027f195>] ? do_writepages+0x27/0x2d
> > > > > > > > > >  [<ffffffff802c22c1>] ? __writeback_single_inode+0x159/0x2b3
> > > > > > > > > >  [<ffffffff8071e52a>] ? thread_return+0x3e/0xaa
> > > > > > > > > >  [<ffffffff8027f267>] ? determine_dirtyable_memory+0xd/0x1d
> > > > > > > > > >  [<ffffffff8027f2dd>] ? get_dirty_limits+0x1d/0x255
> > > > > > > > > >  [<ffffffff802c27bc>] ? generic_sync_wb_inodes+0x1b4/0x220
> > > > > > > > > >  [<ffffffff802c3130>] ? wb_do_writeback+0x16c/0x215
> > > > > > > > > >  [<ffffffff802c323e>] ? bdi_writeback_task+0x65/0x10d
> > > > > > > > > >  [<ffffffff8024cc06>] ? autoremove_wake_function+0x0/0x2e
> > > > > > > > > >  [<ffffffff8024cb27>] ? bit_waitqueue+0x10/0xa0
> > > > > > > > > >  [<ffffffff80289257>] ? bdi_start_fn+0x0/0xba
> > > > > > > > > >  [<ffffffff802892c6>] ? bdi_start_fn+0x6f/0xba
> > > > > > > > > >  [<ffffffff8024c860>] ? kthread+0x54/0x80
> > > > > > > > > >  [<ffffffff8020c97a>] ? child_rip+0xa/0x20
> > > > > > > > > >  [<ffffffff8024c80c>] ? kthread+0x0/0x80
> > > > > > > > > >  [<ffffffff8020c970>] ? child_rip+0x0/0x20
> > > > > > > > > > 
> > > > > > > 
> > > > > > > 
> > > > > > > > 
> > > > > > > > I found one issue yesterday and one today that could cause issues, not
> > > > > > > > sure it would explain this one. But at least it's worth a try, if it's
> > > > > > > > reproducible.
> > > > > > > I just reproduced it a moment ago manually.
> > > > > > > 
> > > > > > > [global]
> > > > > > > direct=0
> > > > > > > ioengine=mmap
> > > > > > > iodepth=256
> > > > > > > iodepth_batch=32
> > > > > > > size=4G
> > > > > > > bs=4k
> > > > > > > pre_read=1
> > > > > > > overwrite=1
> > > > > > > numjobs=1
> > > > > > > loops=5
> > > > > > > runtime=600
> > > > > > > group_reporting
> > > > > > > directory=/mnt/stp/fiodata
> > > > > > > [job_group0_sub0]
> > > > > > > startdelay=0
> > > > > > > rw=randwrite
> > > > > > > filename=data0/f1:data0/f2
> > > > > > > 
> > > > > > > 
> > > > > > > The fio includes my preread patch to flush files to memory.
> > > > > > > 
> > > > > > > Before starting the second testing, I did a cache dropping by:
> > > > > > > #echo "3">/proc/sys/vm/drop_caches.
> > > > > > > 
> > > > > > > I suspect the drop_caches trigger it.
> > > > > > 
> > > > > > Thanks, will try this. What filesystem and mount options did you use?
> > > > > 
> > > > > No luck reproducing so far.
> > > > All my testing are started with automation scripts. I found below step could
> > > > trigger it.
> > > > 1) Use an exclusive partition to test it; for example I use /dev/sdb1 on this
> > > > machine;
> > > > 2) After running the fio test case, immediately umount and mount the disk back:
> > > > #sudo umount /dev/sdb1
> > > > #sudo mount /dev/sdb1 /mnt/stp
> > > > 
> > > > 
> > > > >  In other news, I have finally merged your
> > > > > fio pre_read patch :-)
> > > > Thanks.
> > > > 
> > > > > 
> > > > > I've run it here many times, works fine with the current writeback
> > > > > branch. Since I did the runs anyway, I did comparisons between mainline
> > > > > and writeback for this test. Each test was run 10 times, averages below.
> > > > > The throughput deviated less than 1MB/sec, so results are very stable.
> > > > > CPU usage percentages were always within 0.5%.
> > > > > 
> > > > > Kernel          Throughput       usr         sys        disk util
> > > > > -----------------------------------------------------------------
> > > > > writeback       175MB/sec        17.55%      43.04%     97.80%
> > > > > vanilla         147MB/sec        13.44%      47.33%     85.98%
> > > > > 
> > > > > The results for this test is particularly interesting, since it's very
> > > > > heavy on the writeback side. pdflush/bdi threads were pretty busy. User
> > > > > time is up (even if corrected for higher throughput), but system time is
> > > > > down a lot. Vanilla isn't close to keeping the disk busy, with the
> > > > > writeback patches we are basically there (100% would be pretty much
> > > > > impossible to reach).
> > > > > 
> > > > > Please try with the patches I sent. If you still see problems, we need
> > > > > to look more closely into that.
> > > > I tried the new patches. It seems it improves fio mmap randwrite 4k for about
> > > > 50% on the machine (single disk). The old panic disappears, but there is a new panic.
> > > > 
> > > > [ROOT@LKP-NE01 ~]# BUG: unable to handle kernel NULL pointer dereference at 0000000000000190
> > > > IP: [<ffffffff803270b6>] ext3_invalidatepage+0x18/0x38
> > > > PGD 0
> > > > Oops: 0000 [#1] SMP
> > > > last sysfs file: /sys/block/sdb/stat
> > > > CPU 0
> > > > Modules linked in: igb
> > > > Pid: 7681, comm: umount Not tainted 2.6.30-rc6-bdiflusherv4fix #1 X8DTN
> > > > RIP: 0010:[<ffffffff803270b6>]  [<ffffffff803270b6>] ext3_invalidatepage+0x18/0x38
> > > > RSP: 0018:ffff8801bdc47d20  EFLAGS: 00010246
> > > > RAX: 0000000000000000 RBX: ffffe200058514a0 RCX: 0000000000000002
> > > > RDX: 000000000000000e RSI: 0000000000000000 RDI: ffffe200058514a0
> > > > RBP: 0000000000000000 R08: 0000000000000003 R09: 000000000000000e
> > > > R10: 000000000000000d R11: ffffffff8032709e R12: 0000000000000000
> > > > R13: 0000000000000000 R14: ffff8801bdc47d78 R15: ffff8800bc0dd888
> > > > FS:  00007f48d77237d0(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > > CR2: 0000000000000190 CR3: 00000000bc867000 CR4: 00000000000006e0
> > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > Process umount (pid: 7681, threadinfo ffff8801bdc46000, task ffff8801bde194d0)
> > > > Stack:
> > > >  ffffffff80280ef7 ffffe200058514a0 ffffffff80280ffd ffff8801bdc47d78
> > > >  0000000e0290c538 000000000049d801 0000000000000000 0000000000000000
> > > >  ffffffffffffffff 000000000000000e 0000000000000000 ffffe200058514a0
> > > > Call Trace:
> > > >  [<ffffffff80280ef7>] ? truncate_complete_page+0x1d/0x59
> > > >  [<ffffffff80280ffd>] ? truncate_inode_pages_range+0xca/0x32e
> > > >  [<ffffffff802ba8bc>] ? dispose_list+0x39/0xe4
> > > >  [<ffffffff802bac68>] ? invalidate_inodes+0xf1/0x10f
> > > >  [<ffffffff802ab77b>] ? generic_shutdown_super+0x78/0xde
> > > >  [<ffffffff802ab803>] ? kill_block_super+0x22/0x3a
> > > >  [<ffffffff802abe49>] ? deactivate_super+0x5f/0x76
> > > >  [<ffffffff802bdf2f>] ? sys_umount+0x2cd/0x2fc
> > > >  [<ffffffff8020ba2b>] ? system_call_fastpath+0x16/0x1b
> > > > 
> > > > 
> > > > 
> > > > ext3_invalidatepage =>  EXT3_JOURNAL(page->mapping->host) while
> > > > EXT3_SB((inode)->i_sb) is equal to NULL.
> > > > 
> > > > It seems umount triggers the new panic.
> > >   Hmm, unlike previous oops in ext3, this does not seem to be ext3 problem
> > > (at least at the first sight). Somehow invalidate_inodes() is able to find
> > > invalidated inodes on i_sb_list...
> > Caught previous oops again.
> > I(my script) do a sync after fio testing and before umount /dev/sdb1.
> > 
> > 
> >                             BUG: unable to handle kernel NULL pointer dereference at 00000000000001d8
> > IP: [<ffffffff803f3cec>] generic_make_request+0x10a/0x384
> > PGD 0 
> > Oops: 0000 [#1] SMP 
> > last sysfs file: /sys/block/sdb/stat
> > CPU 0 
> > Modules linked in: igb
> > Pid: 1446, comm: bdi-8:16 Not tainted 2.6.30-rc6-bdiflusherV4fix #1 X8DTN
> > RIP: 0010:[<ffffffff803f3cec>]  [<ffffffff803f3cec>] generic_make_request+0x10a/0x384
> > RSP: 0018:ffff8800bd295a60  EFLAGS: 00010206
> > RAX: 0000000000000000 RBX: ffff8800bd405b00 RCX: 0000000002cd1a40
> > RDX: 0000000000000008 RSI: 0000000000000576 RDI: ffff8801bf4096c0
> > RBP: ffff8800bd405b00 R08: ffffe20006141cf8 R09: ffff8800bd295a98
> > R10: 0000000000000000 R11: ffff8800bd405c80 R12: ffff8800bd405b00
> > R13: ffff88008bc4c150 R14: 0000000000000008 R15: ffff88008059dda0
> > FS:  0000000000000000(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 00000000000001d8 CR3: 0000000000201000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process bdi-8:16 (pid: 1446, threadinfo ffff8800bd294000, task ffff8800bd2375f0)
> > Stack:
> >  0000000000000008 ffffffff8027a613 00000000bd0f60d0 ffffffffffffffff
> >  ffff88007b5cfb10 0000000000000001 ffff88007d504000 ffff880000000006
> >  0000000000011200 ffff8800bd61d444 ffffffffffffffcf 0000000000000000
> > Call Trace:
> >  [<ffffffff8027a613>] ? mempool_alloc+0x59/0x10f
> >  [<ffffffff803f4010>] ? submit_bio+0xaa/0xb1
> >  [<ffffffff802c6aeb>] ? submit_bh+0xe3/0x103
> >  [<ffffffff802c9396>] ? __block_write_full_page+0x1fb/0x2f2
> >  [<ffffffff802c7e16>] ? end_buffer_async_write+0x0/0xfb
> >  [<ffffffff8027e8d2>] ? __writepage+0xa/0x25
> >  [<ffffffff8027f036>] ? write_cache_pages+0x21c/0x338
> >  [<ffffffff8027e8c8>] ? __writepage+0x0/0x25
> >  [<ffffffff8027f195>] ? do_writepages+0x27/0x2d
> >  [<ffffffff802c22c9>] ? __writeback_single_inode+0x159/0x2b3
> >  [<ffffffff8071e5ca>] ? thread_return+0x3e/0xaa
> >  [<ffffffff8027f267>] ? determine_dirtyable_memory+0xd/0x1d
> >  [<ffffffff8027f2dd>] ? get_dirty_limits+0x1d/0x255
> >  [<ffffffff802c27c4>] ? generic_sync_wb_inodes+0x1b4/0x220
> >  [<ffffffff802c31dd>] ? wb_do_writeback+0x16c/0x215
> >  [<ffffffff802c32eb>] ? bdi_writeback_task+0x65/0x10d
> >  [<ffffffff8024cc06>] ? autoremove_wake_function+0x0/0x2e
> >  [<ffffffff8024cb27>] ? bit_waitqueue+0x10/0xa0
> >  [<ffffffff80289257>] ? bdi_start_fn+0x0/0xc0
> >  [<ffffffff802892cc>] ? bdi_start_fn+0x75/0xc0
> >  [<ffffffff8024c860>] ? kthread+0x54/0x80
> >  [<ffffffff8020c97a>] ? child_rip+0xa/0x20
> >  [<ffffffff8024c80c>] ? kthread+0x0/0x80
> >  [<ffffffff8020c970>] ? child_rip+0x0/0x20
> > Code: 39 c8 0f 82 ba 01 00 00 44 89 f0 c7 44 24 14 00 00 00 00 48 c7 44 24 18 ff ff ff ff 48 89 04 24 48 8b 7d 10 48 8b 87  
> > RIP  [<ffffffff803f3cec>] generic_make_request+0x10a/0x384
> 
> Thanks, I'll get this reproduced and fixed. Can you post the results
> you got comparing writeback and vanilla meanwhile?

Please try with this combined patch against what you are running now, it
should resolve the issue. It needs a bit more work, but I'm running out
of time today. I'l get it finalized, cleaned up, and integrated. Then
I'll post a new revision of the patch set.

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f80afaa..e9fc346 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -50,6 +50,7 @@ struct bdi_work {
 
 	unsigned long sb_data;
 	unsigned long nr_pages;
+	enum writeback_sync_modes sync_mode;
 
 	unsigned long state;
 };
@@ -65,19 +66,22 @@ static inline bool bdi_work_on_stack(struct bdi_work *work)
 }
 
 static inline void bdi_work_init(struct bdi_work *work, struct super_block *sb,
-				 unsigned long nr_pages)
+				 unsigned long nr_pages,
+				 enum writeback_sync_modes sync_mode)
 {
 	INIT_RCU_HEAD(&work->rcu_head);
 	work->sb_data = (unsigned long) sb;
 	work->nr_pages = nr_pages;
+	work->sync_mode = sync_mode;
 	work->state = 0;
 }
 
 static inline void bdi_work_init_on_stack(struct bdi_work *work,
 					  struct super_block *sb,
-					  unsigned long nr_pages)
+					  unsigned long nr_pages,
+				 	  enum writeback_sync_modes sync_mode)
 {
-	bdi_work_init(work, sb, nr_pages);
+	bdi_work_init(work, sb, nr_pages, sync_mode);
 	set_bit(0, &work->state);
 	work->sb_data |= 1UL;
 }
@@ -189,17 +193,17 @@ static void bdi_wait_on_work_start(struct bdi_work *work)
 }
 
 int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
-			 long nr_pages)
+			 long nr_pages, enum writeback_sync_modes sync_mode)
 {
 	struct bdi_work work_stack, *work;
 	int ret;
 
 	work = kmalloc(sizeof(*work), GFP_ATOMIC);
 	if (work)
-		bdi_work_init(work, sb, nr_pages);
+		bdi_work_init(work, sb, nr_pages, sync_mode);
 	else {
 		work = &work_stack;
-		bdi_work_init_on_stack(work, sb, nr_pages);
+		bdi_work_init_on_stack(work, sb, nr_pages, sync_mode);
 	}
 
 	ret = bdi_queue_writeback(bdi, work);
@@ -274,11 +278,12 @@ static long wb_kupdated(struct bdi_writeback *wb)
 }
 
 static long __wb_writeback(struct bdi_writeback *wb, long nr_pages,
-			   struct super_block *sb)
+			   struct super_block *sb,
+			   enum writeback_sync_modes sync_mode)
 {
 	struct writeback_control wbc = {
 		.bdi			= wb->bdi,
-		.sync_mode		= WB_SYNC_NONE,
+		.sync_mode		= sync_mode,
 		.older_than_this	= NULL,
 		.range_cyclic		= 1,
 	};
@@ -345,9 +350,10 @@ static long wb_writeback(struct bdi_writeback *wb)
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
 		struct super_block *sb = bdi_work_sb(work);
 		long nr_pages = work->nr_pages;
+		enum writeback_sync_modes sync_mode = work->sync_mode;
 
 		wb_clear_pending(wb, work);
-		wrote += __wb_writeback(wb, nr_pages, sb);
+		wrote += __wb_writeback(wb, nr_pages, sb, sync_mode);
 	}
 
 	return wrote;
@@ -420,39 +426,36 @@ int bdi_writeback_task(struct bdi_writeback *wb)
 	return 0;
 }
 
-void bdi_writeback_all(struct super_block *sb, long nr_pages)
+/*
+ * Do in-line writeback of all backing devices. Expensive!
+ */
+void bdi_writeback_all(struct super_block *sb, long nr_pages,
+		       enum writeback_sync_modes sync_mode)
 {
-	struct list_head *entry = &bdi_list;
+	struct backing_dev_info *bdi;
 
-	rcu_read_lock();
+	mutex_lock(&bdi_mutex);
 
-	list_for_each_continue_rcu(entry, &bdi_list) {
-		struct backing_dev_info *bdi;
-		struct list_head *next;
-		struct bdi_work *work;
-
-		bdi = list_entry(entry, struct backing_dev_info, bdi_list);
+	list_for_each_entry(bdi, &bdi_list, bdi_list) {
 		if (!bdi_has_dirty_io(bdi))
 			continue;
 
-		/*
-		 * If this allocation fails, we just wakeup the thread and
-		 * let it do kupdate writeback
-		 */
-		work = kmalloc(sizeof(*work), GFP_ATOMIC);
-		if (work)
-			bdi_work_init(work, sb, nr_pages);
+		if (!bdi_wblist_needs_lock(bdi))
+			r = __wb_writeback(&bdi->wb, 0, sb, sync_mode);
+		else {
+			struct bdi_writeback *wb;
+			int idx;
 
-		/*
-		 * Prepare to start from previous entry if this one gets moved
-		 * to the bdi_pending list.
-		 */
-		next = entry->prev;
-		if (bdi_queue_writeback(bdi, work))
-			entry = next;
+			idx = srcu_read_lock(&bdi->srcu);
+
+			list_for_each_entry_rcu(wb, &bdi->wb_list, list)
+				r += __wb_writeback(&bdi->wb, 0, sb, sync_mode);
+
+			srcu_read_unlock(&bdi->srcu, idx);
+		}
 	}
 
-	rcu_read_unlock();
+	mutex_unlock(&bdi_mutex);
 }
 
 /*
@@ -972,9 +975,9 @@ void generic_sync_sb_inodes(struct super_block *sb,
 				struct writeback_control *wbc)
 {
 	if (wbc->bdi)
-		bdi_start_writeback(wbc->bdi, sb, 0);
+		generic_sync_bdi_inodes(sb, wbc);
 	else
-		bdi_writeback_all(sb, 0);
+		bdi_writeback_all(sb, 0, wbc->sync_mode);
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		struct inode *inode, *old_inode = NULL;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 7c2874f..c9ddca4 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -15,6 +15,7 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/srcu.h>
+#include <linux/writeback.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -60,7 +61,6 @@ struct bdi_writeback {
 #define BDI_MAX_FLUSHERS	32
 
 struct backing_dev_info {
-	struct rcu_head rcu_head;
 	struct srcu_struct srcu; /* for wb_list read side protection */
 	struct list_head bdi_list;
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
@@ -105,14 +105,15 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
 void bdi_unregister(struct backing_dev_info *bdi);
 int bdi_start_writeback(struct backing_dev_info *bdi, struct super_block *sb,
-			 long nr_pages);
+			 long nr_pages, enum writeback_sync_modes sync_mode);
 int bdi_writeback_task(struct bdi_writeback *wb);
-void bdi_writeback_all(struct super_block *sb, long nr_pages);
+void bdi_writeback_all(struct super_block *sb, long nr_pages,
+			enum writeback_sync_modes sync_mode);
 void bdi_add_default_flusher_task(struct backing_dev_info *bdi);
 void bdi_add_flusher_task(struct backing_dev_info *bdi);
 int bdi_has_dirty_io(struct backing_dev_info *bdi);
 
-extern spinlock_t bdi_lock;
+extern struct mutex bdi_mutex;
 extern struct list_head bdi_list;
 
 static inline int wb_is_default_task(struct bdi_writeback *wb)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 60578bc..0e09051 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -26,7 +26,7 @@ struct backing_dev_info default_backing_dev_info = {
 EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 static struct class *bdi_class;
-DEFINE_SPINLOCK(bdi_lock);
+DEFINE_MUTEX(bdi_mutex);
 LIST_HEAD(bdi_list);
 LIST_HEAD(bdi_pending_list);
 
@@ -360,14 +360,15 @@ static int bdi_start_fn(void *ptr)
 	 * Clear pending bit and wakeup anybody waiting to tear us down
 	 */
 	clear_bit(BDI_pending, &bdi->state);
+	smp_mb__after_clear_bit();
 	wake_up_bit(&bdi->state, BDI_pending);
 
 	/*
 	 * Make us discoverable on the bdi_list again
 	 */
-	spin_lock_bh(&bdi_lock);
-	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-	spin_unlock_bh(&bdi_lock);
+	mutex_lock(&bdi_mutex);
+	list_add_tail(&bdi->bdi_list, &bdi_list);
+	mutex_unlock(&bdi_mutex);
 
 	ret = bdi_writeback_task(wb);
 
@@ -422,12 +423,6 @@ static int bdi_forker_task(void *ptr)
 		struct backing_dev_info *bdi;
 		struct bdi_writeback *wb;
 
-		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
-
-		smp_mb();
-		if (list_empty(&bdi_pending_list))
-			schedule();
-
 		/*
 		 * Ideally we'd like not to see any dirty inodes on the
 		 * default_backing_dev_info. Until these are tracked down,
@@ -438,19 +433,23 @@ static int bdi_forker_task(void *ptr)
 		if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list))
 			wb_do_writeback(me);
 
+		prepare_to_wait(&me->wait, &wait, TASK_INTERRUPTIBLE);
+
+		mutex_lock(&bdi_mutex);
+		if (list_empty(&bdi_pending_list)) {
+			mutex_unlock(&bdi_mutex);
+			schedule();
+			continue;
+		}
+
 		/*
 		 * This is our real job - check for pending entries in
 		 * bdi_pending_list, and create the tasks that got added
 		 */
-repeat:
-		bdi = NULL;
-		spin_lock_bh(&bdi_lock);
-		if (!list_empty(&bdi_pending_list)) {
-			bdi = list_entry(bdi_pending_list.next,
+		bdi = list_entry(bdi_pending_list.next,
 					 struct backing_dev_info, bdi_list);
-			list_del_init(&bdi->bdi_list);
-		}
-		spin_unlock_bh(&bdi_lock);
+		list_del_init(&bdi->bdi_list);
+		mutex_unlock(&bdi_mutex);
 
 		if (!bdi)
 			continue;
@@ -475,12 +474,11 @@ readd_flush:
 			 * a chance to flush other bdi's to free
 			 * memory.
 			 */
-			spin_lock_bh(&bdi_lock);
+			mutex_lock(&bdi_mutex);
 			list_add_tail(&bdi->bdi_list, &bdi_pending_list);
-			spin_unlock_bh(&bdi_lock);
+			mutex_unlock(&bdi_mutex);
 
 			bdi_flush_io(bdi);
-			goto repeat;
 		}
 	}
 
@@ -488,26 +486,6 @@ readd_flush:
 	return 0;
 }
 
-/*
- * Grace period has now ended, init bdi->bdi_list and add us to the
- * list of bdi's that are pending for task creation. Wake up
- * bdi_forker_task() to finish the job and add us back to the
- * active bdi_list.
- */
-static void bdi_add_to_pending(struct rcu_head *head)
-{
-	struct backing_dev_info *bdi;
-
-	bdi = container_of(head, struct backing_dev_info, rcu_head);
-	INIT_LIST_HEAD(&bdi->bdi_list);
-
-	spin_lock(&bdi_lock);
-	list_add_tail(&bdi->bdi_list, &bdi_pending_list);
-	spin_unlock(&bdi_lock);
-
-	wake_up(&default_backing_dev_info.wb.wait);
-}
-
 static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
 				     int(*func)(struct backing_dev_info *))
 {
@@ -526,17 +504,15 @@ static void bdi_add_one_flusher_task(struct backing_dev_info *bdi,
 	 * waiting for previous additions to finish.
 	 */
 	if (!func(bdi)) {
-		spin_lock_bh(&bdi_lock);
-		list_del_rcu(&bdi->bdi_list);
-		spin_unlock_bh(&bdi_lock);
+		mutex_lock(&bdi_mutex);
+		list_move_tail(&bdi->bdi_list, &bdi_pending_list);
+		mutex_unlock(&bdi_mutex);
 
 		/*
-		 * We need to wait for the current grace period to end,
-		 * in case others were browsing the bdi_list as well.
-		 * So defer the adding and wakeup to after the RCU
-		 * grace period has ended.
+		 * We are now on the pending list, wake up bdi_forker_task()
+		 * to finish the job and add us abck to the active bdi_list
 		 */
-		call_rcu(&bdi->rcu_head, bdi_add_to_pending);
+		wake_up(&default_backing_dev_info.wb.wait);
 	}
 }
 
@@ -593,6 +569,14 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		goto exit;
 	}
 
+	mutex_lock(&bdi_mutex);
+	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
+	mutex_unlock(&bdi_mutex);
+
+	bdi->dev = dev;
+	bdi_debug_register(bdi, dev_name(dev));
+	set_bit(BDI_registered, &bdi->state);
+
 	/*
 	 * Just start the forker thread for our default backing_dev_info,
 	 * and add other bdi's to the list. They will get a thread created
@@ -614,16 +598,16 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 			ret = -ENOMEM;
 			goto exit;
 		}
+	} else {
+		/*
+		 * start the default thread. this will exit if nothing
+		 * happens for a while, but it's important to start it here
+		 * or we will not notice that we have dirty data there,
+		 * until memory pressure sets in.
+		 */
+		bdi_add_default_flusher_task(bdi);
 	}
 
-	spin_lock_bh(&bdi_lock);
-	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
-	spin_unlock_bh(&bdi_lock);
-
-	bdi->dev = dev;
-	bdi_debug_register(bdi, dev_name(dev));
-	set_bit(BDI_registered, &bdi->state);
-
 exit:
 	return ret;
 }
@@ -655,15 +639,9 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	/*
 	 * Make sure nobody finds us on the bdi_list anymore
 	 */
-	spin_lock_bh(&bdi_lock);
+	mutex_lock(&bdi_mutex);
 	list_del_rcu(&bdi->bdi_list);
-	spin_unlock_bh(&bdi_lock);
-
-	/*
-	 * Now make sure that anybody who is currently looking at us from
-	 * the bdi_list iteration have exited.
-	 */
-	synchronize_rcu();
+	mutex_unlock(&bdi_mutex);
 
 	/*
 	 * Finally, kill the kernel threads. We don't need to be RCU
@@ -689,7 +667,6 @@ int bdi_init(struct backing_dev_info *bdi)
 {
 	int i, err;
 
-	INIT_RCU_HEAD(&bdi->rcu_head);
 	bdi->dev = NULL;
 
 	bdi->min_ratio = 0;
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index de3178a..f1785bb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -313,9 +313,8 @@ static unsigned int bdi_min_ratio;
 int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 {
 	int ret = 0;
-	unsigned long flags;
 
-	spin_lock_irqsave(&bdi_lock, flags);
+	mutex_lock(&bdi_mutex);
 	if (min_ratio > bdi->max_ratio) {
 		ret = -EINVAL;
 	} else {
@@ -327,27 +326,26 @@ int bdi_set_min_ratio(struct backing_dev_info *bdi, unsigned int min_ratio)
 			ret = -EINVAL;
 		}
 	}
-	spin_unlock_irqrestore(&bdi_lock, flags);
+	mutex_unlock(&bdi_mutex);
 
 	return ret;
 }
 
 int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned max_ratio)
 {
-	unsigned long flags;
 	int ret = 0;
 
 	if (max_ratio > 100)
 		return -EINVAL;
 
-	spin_lock_irqsave(&bdi_lock, flags);
+	mutex_lock(&bdi_mutex);
 	if (bdi->min_ratio > max_ratio) {
 		ret = -EINVAL;
 	} else {
 		bdi->max_ratio = max_ratio;
 		bdi->max_prop_frac = (PROP_FRAC_BASE * max_ratio) / 100;
 	}
-	spin_unlock_irqrestore(&bdi_lock, flags);
+	mutex_unlock(&bdi_mutex);
 
 	return ret;
 }
@@ -581,7 +579,7 @@ static void balance_dirty_pages(struct address_space *mapping)
 			(!laptop_mode && (global_page_state(NR_FILE_DIRTY)
 					  + global_page_state(NR_UNSTABLE_NFS)
 					  > background_thresh)))
-		bdi_start_writeback(bdi, NULL, 0);
+		bdi_start_writeback(bdi, NULL, 0, WB_SYNC_NONE);
 }
 
 void set_page_dirty_balance(struct page *page, int page_mkwrite)
@@ -674,7 +672,7 @@ void wakeup_flusher_threads(long nr_pages)
 	if (nr_pages == 0)
 		nr_pages = global_page_state(NR_FILE_DIRTY) +
 				global_page_state(NR_UNSTABLE_NFS);
-	bdi_writeback_all(NULL, nr_pages);
+	bdi_writeback_all(NULL, nr_pages, WB_SYNC_NONE);
 }
 
 static void laptop_timer_fn(unsigned long unused);

-- 
Jens Axboe

