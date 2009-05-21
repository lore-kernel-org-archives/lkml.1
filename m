Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZEUJKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZEUJKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZEUJKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:10:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZEUJKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:10:35 -0400
Date: Thu, 21 May 2009 11:10:33 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads #4
Message-ID: <20090521091033.GA6987@duck.suse.cz>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <1242713463.2560.5.camel@ymzhang> <20090519062049.GP4140@kernel.dk> <1242805911.2560.28.camel@ymzhang> <20090520080938.GM11363@kernel.dk> <20090520085446.GN11363@kernel.dk> <1242811142.2560.33.camel@ymzhang> <20090520092528.GP11363@kernel.dk> <20090520111910.GS11363@kernel.dk> <1242887627.2560.45.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242887627.2560.45.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-05-09 14:33:47, Zhang, Yanmin wrote:
> On Wed, 2009-05-20 at 13:19 +0200, Jens Axboe wrote:
> > On Wed, May 20 2009, Jens Axboe wrote:
> > > On Wed, May 20 2009, Zhang, Yanmin wrote:
> > > > On Wed, 2009-05-20 at 10:54 +0200, Jens Axboe wrote:
> > > > > On Wed, May 20 2009, Jens Axboe wrote:
> > > > > > On Wed, May 20 2009, Zhang, Yanmin wrote:
> > > > > > > On Tue, 2009-05-19 at 08:20 +0200, Jens Axboe wrote:
> > > > > > > > On Tue, May 19 2009, Zhang, Yanmin wrote:
> > > > > > > > > On Mon, 2009-05-18 at 14:19 +0200, Jens Axboe wrote:
> > > > > > > > > > Hi,
> > > > > > > > > >
> > > > > > > > > > This is the fourth version of this patchset. Chances since v3:
> > > > > > > > > >
> > > > > > > > > > - Dropped a prep patch, it has been included in mainline since.
> > > > > > > > > >
> > > > > > > > > > - Add a work-to-do list to the bdi. This is struct bdi_work. Each
> > > > > > > > > >   wb thread will notice and execute work on bdi->work_list. The arguments
> > > > > > > > > >   are which sb (or NULL for all) to flush and how many pages to flush.
> > > > > > > > > >
> > > > > > > > > > - Fix a bug where not all bdi's would end up on the bdi_list, so potentially
> > > > > > > > > >   some data would not be flushed.
> > > > > > > > > >
> > > > > > > > > > - Make wb_kupdated() pass on wbc->older_than_this so we maintain the same
> > > > > > > > > >   behaviour for kupdated flushes.
> > > > > > > > > >
> > > > > > > > > > - Have the wb thread flush first before sleeping, to avoid losing the
> > > > > > > > > >   first flush on lazy register.
> > > > > > > > > >
> > > > > > > > > > - Rebase to newer kernels.
> > > > > > > 
> > > > > > > > I'm attaching two patches - apply #1 to -rc6, and then #2 is a roll-up
> > > > > > > > of the patch series that you can apply next.
> > > > > > > Jens,
> > > > > > > 
> > > > > > > I run into 2 issues with kernel 2.6.30-rc6+BDI_Flusher_V4. Below is one.
> > > > > > > 
> > > > > > > Tue May 19 00:00:00 CST 2009
> > > > > > > BUG: unable to handle kernel NULL pointer dereference at 00000000000001d8
> > > > > > > IP: [<ffffffff803f3c4c>] generic_make_request+0x10a/0x384
> > > > > > > PGD 0
> > > > > > > Oops: 0000 [#1] SMP
> > > > > > > last sysfs file: /sys/block/sdb/stat
> > > > > > > CPU 0
> > > > > > > Modules linked in: igb
> > > > > > > Pid: 1445, comm: bdi-8:16 Not tainted 2.6.30-rc6-bdiflusherv4 #1 X8DTN
> > > > > > > RIP: 0010:[<ffffffff803f3c4c>]  [<ffffffff803f3c4c>] generic_make_request+0x10a/0x384
> > > > > > > RSP: 0018:ffff8800bd04da60  EFLAGS: 00010206
> > > > > > > RAX: 0000000000000000 RBX: ffff8801be45d500 RCX: 00000000038a0df8
> > > > > > > RDX: 0000000000000008 RSI: 0000000000000576 RDI: ffff8801bf408680
> > > > > > > RBP: ffff8801be45d500 R08: ffffe20001ee8140 R09: ffff8800bd04da98
> > > > > > > R10: 0000000000000000 R11: ffff8800bd72eb40 R12: ffff8801be45d500
> > > > > > > R13: ffff88005f51f310 R14: 0000000000000008 R15: ffff8800b15a5458
> > > > > > > FS:  0000000000000000(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
> > > > > > > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > > > > > > CR2: 00000000000001d8 CR3: 0000000000201000 CR4: 00000000000006e0
> > > > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > > > > > Process bdi-8:16 (pid: 1445, threadinfo ffff8800bd04c000, task ffff8800bd1b75f0)
> > > > > > > Stack:
> > > > > > >  0000000000000008 ffffffff8027a613 00000000848dc000 ffffffffffffffff
> > > > > > >  ffff8800a8190f50 ffffffff00000012 ffff8800a81938e0 ffffc2000000001b
> > > > > > >  0000000000000000 0000000000000000 ffffe200026f9c30 0000000000000000
> > > > > > > Call Trace:
> > > > > > >  [<ffffffff8027a613>] ? mempool_alloc+0x59/0x10f
> > > > > > >  [<ffffffff803f3f70>] ? submit_bio+0xaa/0xb1
> > > > > > >  [<ffffffff802c6a3f>] ? submit_bh+0xe3/0x103
> > > > > > >  [<ffffffff802c92ea>] ? __block_write_full_page+0x1fb/0x2f2
> > > > > > >  [<ffffffff802c7d6a>] ? end_buffer_async_write+0x0/0xfb
> > > > > > >  [<ffffffff8027e8d2>] ? __writepage+0xa/0x25
> > > > > > >  [<ffffffff8027f036>] ? write_cache_pages+0x21c/0x338
> > > > > > >  [<ffffffff8027e8c8>] ? __writepage+0x0/0x25
> > > > > > >  [<ffffffff8027f195>] ? do_writepages+0x27/0x2d
> > > > > > >  [<ffffffff802c22c1>] ? __writeback_single_inode+0x159/0x2b3
> > > > > > >  [<ffffffff8071e52a>] ? thread_return+0x3e/0xaa
> > > > > > >  [<ffffffff8027f267>] ? determine_dirtyable_memory+0xd/0x1d
> > > > > > >  [<ffffffff8027f2dd>] ? get_dirty_limits+0x1d/0x255
> > > > > > >  [<ffffffff802c27bc>] ? generic_sync_wb_inodes+0x1b4/0x220
> > > > > > >  [<ffffffff802c3130>] ? wb_do_writeback+0x16c/0x215
> > > > > > >  [<ffffffff802c323e>] ? bdi_writeback_task+0x65/0x10d
> > > > > > >  [<ffffffff8024cc06>] ? autoremove_wake_function+0x0/0x2e
> > > > > > >  [<ffffffff8024cb27>] ? bit_waitqueue+0x10/0xa0
> > > > > > >  [<ffffffff80289257>] ? bdi_start_fn+0x0/0xba
> > > > > > >  [<ffffffff802892c6>] ? bdi_start_fn+0x6f/0xba
> > > > > > >  [<ffffffff8024c860>] ? kthread+0x54/0x80
> > > > > > >  [<ffffffff8020c97a>] ? child_rip+0xa/0x20
> > > > > > >  [<ffffffff8024c80c>] ? kthread+0x0/0x80
> > > > > > >  [<ffffffff8020c970>] ? child_rip+0x0/0x20
> > > > > > > 
> > > > 
> > > > 
> > > > > 
> > > > > I found one issue yesterday and one today that could cause issues, not
> > > > > sure it would explain this one. But at least it's worth a try, if it's
> > > > > reproducible.
> > > > I just reproduced it a moment ago manually.
> > > > 
> > > > [global]
> > > > direct=0
> > > > ioengine=mmap
> > > > iodepth=256
> > > > iodepth_batch=32
> > > > size=4G
> > > > bs=4k
> > > > pre_read=1
> > > > overwrite=1
> > > > numjobs=1
> > > > loops=5
> > > > runtime=600
> > > > group_reporting
> > > > directory=/mnt/stp/fiodata
> > > > [job_group0_sub0]
> > > > startdelay=0
> > > > rw=randwrite
> > > > filename=data0/f1:data0/f2
> > > > 
> > > > 
> > > > The fio includes my preread patch to flush files to memory.
> > > > 
> > > > Before starting the second testing, I did a cache dropping by:
> > > > #echo "3">/proc/sys/vm/drop_caches.
> > > > 
> > > > I suspect the drop_caches trigger it.
> > > 
> > > Thanks, will try this. What filesystem and mount options did you use?
> > 
> > No luck reproducing so far.
> All my testing are started with automation scripts. I found below step could
> trigger it.
> 1) Use an exclusive partition to test it; for example I use /dev/sdb1 on this
> machine;
> 2) After running the fio test case, immediately umount and mount the disk back:
> #sudo umount /dev/sdb1
> #sudo mount /dev/sdb1 /mnt/stp
> 
> 
> >  In other news, I have finally merged your
> > fio pre_read patch :-)
> Thanks.
> 
> > 
> > I've run it here many times, works fine with the current writeback
> > branch. Since I did the runs anyway, I did comparisons between mainline
> > and writeback for this test. Each test was run 10 times, averages below.
> > The throughput deviated less than 1MB/sec, so results are very stable.
> > CPU usage percentages were always within 0.5%.
> > 
> > Kernel          Throughput       usr         sys        disk util
> > -----------------------------------------------------------------
> > writeback       175MB/sec        17.55%      43.04%     97.80%
> > vanilla         147MB/sec        13.44%      47.33%     85.98%
> > 
> > The results for this test is particularly interesting, since it's very
> > heavy on the writeback side. pdflush/bdi threads were pretty busy. User
> > time is up (even if corrected for higher throughput), but system time is
> > down a lot. Vanilla isn't close to keeping the disk busy, with the
> > writeback patches we are basically there (100% would be pretty much
> > impossible to reach).
> > 
> > Please try with the patches I sent. If you still see problems, we need
> > to look more closely into that.
> I tried the new patches. It seems it improves fio mmap randwrite 4k for about
> 50% on the machine (single disk). The old panic disappears, but there is a new panic.
> 
> [ROOT@LKP-NE01 ~]# BUG: unable to handle kernel NULL pointer dereference at 0000000000000190
> IP: [<ffffffff803270b6>] ext3_invalidatepage+0x18/0x38
> PGD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/block/sdb/stat
> CPU 0
> Modules linked in: igb
> Pid: 7681, comm: umount Not tainted 2.6.30-rc6-bdiflusherv4fix #1 X8DTN
> RIP: 0010:[<ffffffff803270b6>]  [<ffffffff803270b6>] ext3_invalidatepage+0x18/0x38
> RSP: 0018:ffff8801bdc47d20  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffe200058514a0 RCX: 0000000000000002
> RDX: 000000000000000e RSI: 0000000000000000 RDI: ffffe200058514a0
> RBP: 0000000000000000 R08: 0000000000000003 R09: 000000000000000e
> R10: 000000000000000d R11: ffffffff8032709e R12: 0000000000000000
> R13: 0000000000000000 R14: ffff8801bdc47d78 R15: ffff8800bc0dd888
> FS:  00007f48d77237d0(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000190 CR3: 00000000bc867000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process umount (pid: 7681, threadinfo ffff8801bdc46000, task ffff8801bde194d0)
> Stack:
>  ffffffff80280ef7 ffffe200058514a0 ffffffff80280ffd ffff8801bdc47d78
>  0000000e0290c538 000000000049d801 0000000000000000 0000000000000000
>  ffffffffffffffff 000000000000000e 0000000000000000 ffffe200058514a0
> Call Trace:
>  [<ffffffff80280ef7>] ? truncate_complete_page+0x1d/0x59
>  [<ffffffff80280ffd>] ? truncate_inode_pages_range+0xca/0x32e
>  [<ffffffff802ba8bc>] ? dispose_list+0x39/0xe4
>  [<ffffffff802bac68>] ? invalidate_inodes+0xf1/0x10f
>  [<ffffffff802ab77b>] ? generic_shutdown_super+0x78/0xde
>  [<ffffffff802ab803>] ? kill_block_super+0x22/0x3a
>  [<ffffffff802abe49>] ? deactivate_super+0x5f/0x76
>  [<ffffffff802bdf2f>] ? sys_umount+0x2cd/0x2fc
>  [<ffffffff8020ba2b>] ? system_call_fastpath+0x16/0x1b
> 
> 
> 
> ext3_invalidatepage =>  EXT3_JOURNAL(page->mapping->host) while
> EXT3_SB((inode)->i_sb) is equal to NULL.
> 
> It seems umount triggers the new panic.
  Hmm, unlike previous oops in ext3, this does not seem to be ext3 problem
(at least at the first sight). Somehow invalidate_inodes() is able to find
invalidated inodes on i_sb_list...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
