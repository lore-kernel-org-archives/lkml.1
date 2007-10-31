Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXJaPWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXJaPWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbXJaPWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:22:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:64350 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409AbXJaPWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:22:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mJXgRyJ+uO87FfvwOvKEiaGNGY6zhtJksnbm4HfgdXb1eW6dPZRfcp3tjUKH4IihtTiQ8STcpD8Gb9htYdRRArAkDayBrYKoNVupeDRnaNyZ6qVi1notSqWN5c3QRYS3qf+F5/I05ZX6QDTr1Z98/pwqq/XDVAKEV/L3BR+8Eo8=
Message-ID: <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
Date: Wed, 31 Oct 2007 16:22:10 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: 100% iowait on one of cpus in current -git
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <393060478.03650@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710220822.52370.maximlevitsky@gmail.com>
	 <200710221421.21439.maximlevitsky@gmail.com>
	 <393056632.00561@ustc.edu.cn>
	 <200710221505.35397.maximlevitsky@gmail.com>
	 <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> On Mon, Oct 22, 2007 at 09:10:45PM +0800, Fengguang Wu wrote:
> > Hmm, Maybe it's an reiserfs related issue.  Do you have the full log file?
>
> Bingo! It can be reproduced in -mm on reiserfs:
>
> # mkfs.reiserfs /dev/sdb1
> # mount /dev/sdb1 /test
> # cp bin /test
> <wait for a while>
> # dmesg
> [...]
> [  418.346113] requeue_io 308: inode 6 size 302 at 08:11(sdb1)
> [  418.346119] requeue_io 308: inode 7 size 196 at 08:11(sdb1)
> [  418.346125] requeue_io 308: inode 8 size 85 at 08:11(sdb1)

Since 2.6.23-mm1 I also experience strange hangs during heavy writeouts.
Each time I noticed this I was using emerge (package util from the
gentoo distribution) to install/upgrade a package. The last step,
where this hang occurred, is moving the prepared files from a tmpfs
partion to the main xfs filesystem.
The hangs where not fatal, after a few second everything resumed
normal, so I was not able to capture a good image of what was
happening.

Today it happend again, but a little more obvious. During the moving
process the writeout stalled completly for several minutes until I hit
SysRq+W.

/proc/meminfo:
MemTotal:      4061808 kB
MemFree:        881332 kB
Buffers:             0 kB
Cached:        2566628 kB
SwapCached:         64 kB
Active:         926612 kB
Inactive:      1959136 kB
SwapTotal:     9775416 kB
SwapFree:      9775296 kB
Dirty:           44948 kB
Writeback:           0 kB
AnonPages:      319068 kB
Mapped:          52844 kB
Slab:           235572 kB
SReclaimable:   164408 kB
SUnreclaim:      71164 kB
PageTables:       9576 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:  11806320 kB
Committed_AS:   544520 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     35004 kB
VmallocChunk: 34359702447 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     2048 kB

The 'Dirty' count did not decrease during this time and 'Writeback' stayed at 0.
I also have /proc/pagetypeinfo ,but I see nothing interessing in
there. (But will send it, if needed)

The output from SysRq+W:
SysRq : Show Blocked State
  task                        PC stack   pid father
pdflush       D ffff81001fcc2a88     0   285      2
 ffff810005d55580 0000000000000046 0000000000000800 0000007000000001
 0000000000000400 ffffffff8022d61c ffffffff80817b00 ffffffff80817b00
 ffffffff80813f40 ffffffff80817b00 ffff810100893b18 0000000000000000
Call Trace:
 [<ffffffff8022d61c>] task_rq_lock+0x4c/0x90
 [<ffffffff8022c8ea>] __wake_up_common+0x5a/0x90
 [<ffffffff805b14c7>] __down+0xa7/0x11e
 [<ffffffff8022da70>] default_wake_function+0x0/0x10
 [<ffffffff805b1145>] __down_failed+0x35/0x3a
 [<ffffffff803750be>] xfs_buf_lock+0x3e/0x40
 [<ffffffff803771fe>] _xfs_buf_find+0x13e/0x240
 [<ffffffff8037736f>] xfs_buf_get_flags+0x6f/0x190
 [<ffffffff803774a2>] xfs_buf_read_flags+0x12/0xa0
 [<ffffffff80368614>] xfs_trans_read_buf+0x64/0x340
 [<ffffffff80352151>] xfs_itobp+0x81/0x1e0
 [<ffffffff803759de>] xfs_buf_rele+0x2e/0xd0
 [<ffffffff80354afe>] xfs_iflush+0xfe/0x520
 [<ffffffff803ae3b2>] __down_read_trylock+0x42/0x60
 [<ffffffff80355a72>] xfs_inode_item_push+0x12/0x20
 [<ffffffff80368037>] xfs_trans_push_ail+0x267/0x2b0
 [<ffffffff8035a33b>] xlog_ticket_get+0xfb/0x140
 [<ffffffff8035c5ae>] xfs_log_reserve+0xee/0x120
 [<ffffffff803669e8>] xfs_trans_reserve+0xa8/0x210
 [<ffffffff8035703a>] xfs_iomap_write_allocate+0xfa/0x410
 [<ffffffff804ce67a>] __split_bio+0x38a/0x3c0
 [<ffffffff80373657>] xfs_start_page_writeback+0x27/0x60
 [<ffffffff8035660c>] xfs_iomap+0x26c/0x310
 [<ffffffff803735d8>] xfs_map_blocks+0x38/0x90
 [<ffffffff80374a88>] xfs_page_state_convert+0x2b8/0x630
 [<ffffffff80374f5f>] xfs_vm_writepage+0x6f/0x120
 [<ffffffff8026acda>] __writepage+0xa/0x30
 [<ffffffff8026b2ce>] write_cache_pages+0x23e/0x330
 [<ffffffff8026acd0>] __writepage+0x0/0x30
 [<ffffffff80354db7>] xfs_iflush+0x3b7/0x520
 [<ffffffff80375782>] _xfs_buf_ioapply+0x222/0x320
 [<ffffffff803ae451>] __up_read+0x21/0xb0
 [<ffffffff8034f22c>] xfs_iunlock+0x5c/0xc0
 [<ffffffff8026b410>] do_writepages+0x20/0x40
 [<ffffffff802b36a0>] __writeback_single_inode+0xb0/0x380
 [<ffffffff804d052e>] dm_table_any_congested+0x2e/0x80
 [<ffffffff802b3d8d>] generic_sync_sb_inodes+0x20d/0x330
 [<ffffffff802b4322>] writeback_inodes+0xa2/0xe0
 [<ffffffff8026bde6>] wb_kupdate+0xa6/0x120
 [<ffffffff8026c2a0>] pdflush+0x0/0x1e0
 [<ffffffff8026c3b0>] pdflush+0x110/0x1e0
 [<ffffffff8026bd40>] wb_kupdate+0x0/0x120
 [<ffffffff8024a32b>] kthread+0x4b/0x80
 [<ffffffff8020c9d8>] child_rip+0xa/0x12
 [<ffffffff8024a2e0>] kthread+0x0/0x80
 [<ffffffff8020c9ce>] child_rip+0x0/0x12

emerge        D ffff81001fcc2a88     0  3221   8163
 ffff81008c0679f8 0000000000000086 ffff81008c067988 ffffffff8024a719
 ffff8100060fb008 ffffffff8022c8ea ffffffff80817b00 ffffffff80817b00
 ffffffff80813f40 ffffffff80817b00 ffff810100893b18 0000000000000000
Call Trace:
 [<ffffffff8024a719>] autoremove_wake_function+0x9/0x30
 [<ffffffff8022c8ea>] __wake_up_common+0x5a/0x90
 [<ffffffff8022c8ea>] __wake_up_common+0x5a/0x90
 [<ffffffff805b14c7>] __down+0xa7/0x11e
 [<ffffffff8022da70>] default_wake_function+0x0/0x10
 [<ffffffff805b1145>] __down_failed+0x35/0x3a
 [<ffffffff803750be>] xfs_buf_lock+0x3e/0x40
 [<ffffffff803771fe>] _xfs_buf_find+0x13e/0x240
 [<ffffffff8037736f>] xfs_buf_get_flags+0x6f/0x190
 [<ffffffff803774a2>] xfs_buf_read_flags+0x12/0xa0
 [<ffffffff80368614>] xfs_trans_read_buf+0x64/0x340
 [<ffffffff80352151>] xfs_itobp+0x81/0x1e0
 [<ffffffff803759de>] xfs_buf_rele+0x2e/0xd0
 [<ffffffff80354afe>] xfs_iflush+0xfe/0x520
 [<ffffffff803ae3b2>] __down_read_trylock+0x42/0x60
 [<ffffffff80355a72>] xfs_inode_item_push+0x12/0x20
 [<ffffffff80368037>] xfs_trans_push_ail+0x267/0x2b0
 [<ffffffff8035c532>] xfs_log_reserve+0x72/0x120
 [<ffffffff803669e8>] xfs_trans_reserve+0xa8/0x210
 [<ffffffff80372fe2>] kmem_zone_zalloc+0x32/0x50
 [<ffffffff8035242b>] xfs_itruncate_finish+0xfb/0x310
 [<ffffffff8036d8db>] xfs_free_eofblocks+0x23b/0x280
 [<ffffffff80371d83>] xfs_release+0x153/0x200
 [<ffffffff80377e00>] xfs_file_release+0x10/0x20
 [<ffffffff80294041>] __fput+0xb1/0x220
 [<ffffffff80290e94>] filp_close+0x54/0x90
 [<ffffffff802927af>] sys_close+0x9f/0x100
 [<ffffffff8020bbbe>] system_call+0x7e/0x83


After this SysRq+W writeback resumed again. Possible that writing
above into the syslog triggered that.
The source tmpfs is mounted with any special parameters, but the
target xfs filesystem resides on a dm-crypt device that is on top a 3
disk RAID5 md.
During the hang all CPUs where idle.
The system is x86_64 with CONFIG_NO_HZ=y, but was still receiving ~330
interrupts per second because of the bttv driver. (But I was not using
that device at this time.)

I'm willing to test patches or more provide more information, but lack
a good testcase to trigger this on demand.

Torsten
