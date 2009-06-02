Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbZFBLxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbZFBLxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbZFBLxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:53:39 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49037 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438AbZFBLxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:53:38 -0400
Date: Tue, 2 Jun 2009 13:53:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090602115339.GG11363@kernel.dk>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com> <1243402035.2560.127.camel@ymzhang> <20090527061705.GQ11363@kernel.dk> <1243908453.2560.139.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243908453.2560.139.camel@ymzhang>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02 2009, Zhang, Yanmin wrote:
> On Wed, 2009-05-27 at 08:17 +0200, Jens Axboe wrote:
> > On Wed, May 27 2009, Zhang, Yanmin wrote:
> > > On Tue, 2009-05-26 at 11:33 +0200, Jens Axboe wrote:
> > > > Hi,
> > > > 
> > > > Here's the 7th version of the writeback patches. Changes since
> > > > v5/v6:
> > > > 
> > > > - Move the sync_supers() to the global bdi_forker_task() thread, so we
> > > >   don't writeback the supers from all the bdi kupdated() tasks.
> > > > - Make bdi_start_writeback() and bdi_writeback_all() be sync when called
> > > >   with WB_SYNC_ALL only.
> > > > - Shuffle some more things around to make a cleaner series. The sync vs
> > > >   async nature of bdi_writeback_all() and bdi_start_writeback() isn't
> > > >   consistent through the series, but otherwise things should be sane.
> > > > 
> > > > I'd appreciate if Richard and Yanmin could re-run testing with this,
> > > > just to make sure that things are sane. For ease of patching, I've
> > > > put the full diff here:
> > > > 
> > > >   http://kernel.dk/writeback-v7.patch
> > > I ported it to 2.6.30-rc6 with some change in file mm/page-write.c, so I 
> > > could compare with old data.
> > > 
> > > See the attachment.
> > > 
> > > The new testing hits the hang issue again. It seems there is still a race.
> > 
> > It's actually not a race, it's a deadlock on the bdi_lock. If you find
> > the bdi-default task, it should be stuck in the mutex slow path. I
> > posted this quickie [1] yesterday but didn't test it, I'll test it today and
> > post a v8.
> > 
> 
> 
> > [1] http://lkml.org/lkml/2009/5/26/401
> Jens,
> 
> I checked V9 and found it includes the fix. However, the issue appears again on another
> machine when doing 'umount -f /dev/sda3'.
> 
> INFO: task umount:17110 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> umount        D ffffc20000011300  6128 17110  16225
>  ffffffff8093e350 0000000000000086 0000000000000000 0000000000000000
>  ffffe200006482e8 0000000000004000 0000000000011300 000000000000c868
>  ffff8801be07dd48 0000000000000000 ffff8801be5f8000 ffff8801be5f8388
> Call Trace:
>  [<ffffffff802c316c>] ? bdi_sched_wait+0x0/0xd
>  [<ffffffff8071e53f>] ? schedule+0x9/0x1e
>  [<ffffffff802c3175>] ? bdi_sched_wait+0x9/0xd
>  [<ffffffff8071eb06>] ? __wait_on_bit+0x41/0x71
>  [<ffffffff802c316c>] ? bdi_sched_wait+0x0/0xd
>  [<ffffffff8071eba1>] ? out_of_line_wait_on_bit+0x6b/0x77
>  [<ffffffff8024cbf0>] ? wake_bit_function+0x0/0x23
>  [<ffffffff802c2e1f>] ? bdi_writeback_all+0x117/0x14e
>  [<ffffffff802c2f8f>] ? generic_sync_sb_inodes+0x31/0xdc
>  [<ffffffff802c30bd>] ? sync_inodes_sb+0x83/0x88
>  [<ffffffff802ab4f3>] ? fsync_super+0x9/0x16
>  [<ffffffff802ab7a8>] ? generic_shutdown_super+0x25/0xde
>  [<ffffffff802ab883>] ? kill_block_super+0x22/0x3a
>  [<ffffffff802abec9>] ? deactivate_super+0x5f/0x76
>  [<ffffffff802bdf5f>] ? sys_umount+0x2cd/0x2fc
>  [<ffffffff8020ba2b>] ? system_call_fastpath+0x16/0x1b
> 
> 
> 
> Then, I run command sync and hit a panic:
> 
> [root@lkp-ne02 ~]# BUG: unable to handle kernel paging request at 0000000561887e50
> IP: [<ffffffff8022d121>] task_rq_lock+0x28/0x6b
> PGD bc551067 PUD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/class/net/eth1/ifindex
> CPU 9
> Modules linked in:
> Pid: 27470, comm: sync Not tainted 2.6.30-rc7-bdiflusherv9 #1 X8DTN
> RIP: 0010:[<ffffffff8022d121>]  [<ffffffff8022d121>] task_rq_lock+0x28/0x6b
> RSP: 0018:ffff8800bccd9e48  EFLAGS: 00010096
> RAX: 00000000bc1d0420 RBX: 0000000000011300 RCX: 0000000000000000
> RDX: 00000000000110fd RSI: ffff8800bccd9e88 RDI: ffff8800bd703090
> RBP: 0000000000011300 R08: fefefefefefefeff R09: 0000000000000000
> R10: 00000034cbd6da70 R11: 00000034cbacab70 R12: ffff8800bccd9e88
> R13: ffff8800bd703090 R14: 000000000000000f R15: 0000000000000000
> FS:  00007f04696dd6f0(0000) GS:ffffc20001200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000561887e50 CR3: 00000000bc0d6000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process sync (pid: 27470, threadinfo ffff8800bccd8000, task ffff8800bc4ee810)
> Stack:
>  00000034cbaca000 000000000000000f ffff8800bd703090 ffff8800bccd9f18
>  ffff8800bd780138 ffffffff80233889 0000000000000000 ffffffff802c2be6
>  0000000000000296 ffff8800bcd6f900 ffff8800bd5a9d10 ffff8800bccd9f18
> Call Trace:
>  [<ffffffff80233889>] ? try_to_wake_up+0x8f/0x2d0
>  [<ffffffff802c2be6>] ? bdi_alloc_work+0x28/0xa6
>  [<ffffffff802c2e45>] ? bdi_writeback_all+0x13d/0x14e
>  [<ffffffff8027f151>] ? wakeup_flusher_threads+0x4c/0x51
>  [<ffffffff802c5c39>] ? do_sync+0xb/0x5a
>  [<ffffffff802c5caa>] ? sys_sync+0xe/0x14
>  [<ffffffff8020ba2b>] ? system_call_fastpath+0x16/0x1b
> Code: 41 59 c3 41 55 49 89 fd 41 54 49 89 f4 55 48 c7 c5 00 13 01 00 53 48 83 ec 08 9c 58 fa 49 89 04 24 49 8b 45 08 48 89 e
> RIP  [<ffffffff8022d121>] task_rq_lock+0x28/0x6b
>  RSP <ffff8800bccd9e48>
> CR2: 0000000561887e50
> 
> 
> 
> Another machine hangs twice with 2.6.30-rc7+bdiflusherV9
> after it's idle for hours without testing. Serial console
> didn't capture any useful info.

I'm looking into the issue that Jan Kara pointed out, we do appear still
to have a race with umount and super block referencing.

> As for perforamnce testing result, there is no big variation from
> previous vesions.

That's good, at least :-)


-- 
Jens Axboe

