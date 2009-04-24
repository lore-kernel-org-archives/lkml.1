Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZDXFRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZDXFRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 01:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZDXFRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 01:17:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59038 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZDXFRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 01:17:43 -0400
Date: Fri, 24 Apr 2009 07:17:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: CFQ Oops
Message-ID: <20090424051741.GU4593@kernel.dk>
References: <20090424044701.GG3709@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424044701.GG3709@josefsipek.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24 2009, Josef 'Jeff' Sipek wrote:
> I got an oops with CFQ (see below) while running the XFS QA test 133. I managed
> to bisect it down to commit a36e71f996e25d6213f57951f7ae1874086ec57e.
> 
> From a quick glance at the code, I'd guess that prio_trees[..] happens to be
> NULL, and so the rb_erase_init call on line 660 results in a NULL ptr deref.
> 
> 657             if (!RB_EMPTY_NODE(&cfqq->rb_node))
> 658                     cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
> 659             if (!RB_EMPTY_NODE(&cfqq->p_node))
> 660                     rb_erase_init(&cfqq->p_node, &cfqd->prio_trees[cfqq->ioprio]);
> 661
> 662             BUG_ON(!cfqd->busy_queues);
> 663             cfqd->busy_queues--;
> 
> Josef 'Jeff' Sipek.

Yeah, it's a fixed issue, if only Linus would pull the patches. I guess
he's away for a few days. If you pull:

git://git.kernel.dk/linux-2.6-block.git for-linus

into 2.6.30-rc3, then that should fix it.

> 
> 
> a36e71f996e25d6213f57951f7ae1874086ec57e is first bad commit
> commit a36e71f996e25d6213f57951f7ae1874086ec57e
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Wed Apr 15 12:15:11 2009 +0200
> 
>     cfq-iosched: add close cooperator code
> 
>     If we have processes that are working in close proximity to each
>     other on disk, we don't want to idle wait. Instead allow the close
>     process to issue a request, getting better aggregate bandwidth.
>     The anticipatory scheduler has similar checks, noop and deadline do
>     not need it since they don't care about process <-> io mappings.
> 
>     The code for CFQ is a little more involved though, since we split
>     request queues into per-process contexts.
> 
>     This fixes a performance problem with eg dump(8), since it uses
>     several processes in some silly attempt to speed IO up. Even if
>     dump(8) isn't really a valid case (it should be fixed by using
>     CLONE_IO), there are other cases where we see close processes
>     and where idling ends up hurting performance.
> 
>     Credit goes to Jeff Moyer <jmoyer@redhat.com> for writing the
>     initial implementation.
> 
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> :040000 040000 2e905502bf3c466baae407bcd654fc36d015c83f b4aafd7edc811aed69fa44ddf00a29ece4f32a33 M      block
> 
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffff8119a594>] rb_erase+0x174/0x340
> PGD f8843067 PUD f8842067 PMD 0
> Oops: 0000 [#1] SMP
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:0b.0/0000:01:03.0/local_cpus
> CPU 0
> Modules linked in: xfs exportfs sco bridge stp llc bnep l2cap bluetooth
> ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 dm_multipath
> uinput amd_rng ata_generic tg3 s2io libphy serio_raw i2c_amd8111 pcspkr
> i2c_amd756 pata_amd shpchp
> Pid: 2926, comm: xfs_io Not tainted 2.6.30-rc3 #8 To be filled by O.E.M.
> RIP: 0010:[<ffffffff8119a594>]  [<ffffffff8119a594>] rb_erase+0x174/0x340
> RSP: 0018:ffff8800788e9788  EFLAGS: 00010046
> RAX: ffff8800f9dd12b1 RBX: ffff8800f9dd12b0 RCX: 0000000000000001
> RDX: ffff8800f9dd12b0 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff8800788e9798 R08: ffff8800f9dd1320 R09: 0000000000000000
> R10: ffff8800f9dd12b0 R11: 0000000000000000 R12: ffff8800fa958a38
> R13: ffff880074cc8e60 R14: ffff8800fa958a00 R15: ffff8800f9dd1320
> FS:  00007f6262cc46f0(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 00000000f5848000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process xfs_io (pid: 2926, threadinfo ffff8800788e8000, task
> ffff880074d0c4d0)
> Stack:
>  ffff8800f9dd1320 ffff8800f9dd1350 ffff8800788e97d8 ffffffff81190a40
>  ffff8800fa958a00 ffff8800f9dd1320 ffff880074cc8e60 ffff8800fa958a00
>  ffff8800fa9208e0 ffff880074cc8e60 ffff8800788e9808 ffffffff81190b28
> Call Trace:
>  [<ffffffff81190a40>] cfq_remove_request+0x1e0/0x280
>  [<ffffffff81190b28>] cfq_dispatch_insert+0x48/0x90
>  [<ffffffff811917a5>] cfq_dispatch_requests+0x1a5/0x4d0
>  [<ffffffff81180842>] elv_next_request+0x162/0x200
>  [<ffffffff81196dba>] ? kobject_get+0x1a/0x30
>  [<ffffffff812156d2>] scsi_request_fn+0x62/0x560
>  [<ffffffff8138a5ff>] ? _spin_unlock_irqrestore+0x2f/0x40
>  [<ffffffff8118251a>] blk_start_queueing+0x1a/0x40
>  [<ffffffff81191f15>] cfq_insert_request+0x2d5/0x430
>  [<ffffffff81180a00>] elv_insert+0x120/0x2a0
>  [<ffffffff81180bfb>] __elv_add_request+0x7b/0xd0
>  [<ffffffff81183cf1>] __make_request+0x111/0x460
>  [<ffffffff81182bf5>] generic_make_request+0x3b5/0x490
>  [<ffffffff81182d40>] submit_bio+0x70/0xf0
>  [<ffffffff8110d86e>] dio_bio_submit+0x5e/0x90
>  [<ffffffff8110e215>] __blockdev_direct_IO+0x5c5/0xd60
>  [<ffffffffa019916e>] xfs_vm_direct_IO+0x10e/0x130 [xfs]
>  [<ffffffffa01995a0>] ? xfs_get_blocks_direct+0x0/0x20 [xfs]
>  [<ffffffffa01992f0>] ? xfs_end_io_direct+0x0/0x80 [xfs]
>  [<ffffffff810a59ef>] generic_file_direct_write+0xbf/0x220
>  [<ffffffffa01a19bb>] xfs_write+0x3fb/0x9a0 [xfs]
>  [<ffffffff810a4f6c>] ? filemap_fault+0x13c/0x440
>  [<ffffffffa019dafd>] xfs_file_aio_write+0x5d/0x70 [xfs]
>  [<ffffffff810e16f1>] do_sync_write+0xf1/0x140
>  [<ffffffff8105b1d0>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff8103cc7b>] ? finish_task_switch+0x5b/0xe0
>  [<ffffffffa0199190>] ? xfs_end_bio_written+0x0/0x30 [xfs]
>  [<ffffffff81387ba0>] ? thread_return+0x3e/0x6ae
>  [<ffffffff810e1ddb>] vfs_write+0xcb/0x190
>  [<ffffffff810e1f32>] sys_pwrite64+0x92/0xa0
>  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
> Code: 7a ff ff ff 0f 1f 00 48 3b 78 10 0f 1f 40 00 0f 84 7a 01 00 00 48 89
> 48 08 66 0f 1f 44 00 00 e9 28 ff ff ff 0f 1f 00 48 8b 7b 08 <48> 8b 07 a8 01
> 0f 84 d1 00 00 00 48 8b 47 10 48 85 c0 74 09 f6
> RIP  [<ffffffff8119a594>] rb_erase+0x174/0x340
>  RSP <ffff8800788e9788>
> CR2: 0000000000000000
> ---[ end trace 79edd488f3f3e8df ]---
> 
> -- 
> A computer without Microsoft is like chocolate cake without mustard.

-- 
Jens Axboe

