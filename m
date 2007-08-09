Return-Path: <linux-kernel-owner+w=401wt.eu-S965299AbXHIMy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965299AbXHIMy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940264AbXHIMxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:53:49 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3674 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940115AbXHIMxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:53:45 -0400
Date: Thu, 9 Aug 2007 13:53:06 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, drfickle@us.ibm.com, mel@csn.ul.ie,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-rc2-mm1 -- spinlock bad magic
Message-ID: <20070809125306.GA3091@shadowen.org>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing spinlock bad magic BUG's from x86 and x86_64 test boxes,
fsx-linux seems to be tickling it.  Adding Peter as prop_norm_single
seems to be his:

x86 (oai5-hs20):

BUG: spinlock bad magic on CPU#1, fsx-linux/25600
 lock: c3c15a18, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
 [<c01e28bc>] _raw_spin_lock+0x16/0x67
 [<c0342428>] _spin_lock_irqsave+0x9/0xd
 [<c01dde46>] prop_norm_single+0x27/0x70
 [<c0155052>] task_dirty_inc+0x1f/0x48
 [<c0155ef0>] set_page_dirty+0x17/0x1b
 [<c015560e>] set_page_dirty_balance+0x8/0x35
 [<c015dcfd>] __do_fault+0x34c/0x363
 [<c01dd79e>] prio_tree_insert+0x55/0x154
 [<c015dd57>] do_linear_fault+0x43/0x49
 [<c015e095>] handle_mm_fault+0x17d/0x2f2
 [<c011c5ab>] do_page_fault+0x214/0x60f
 [<c0108985>] sys_mmap2+0x71/0x78
 [<c011c397>] do_page_fault+0x0/0x60f
 [<c034266a>] error_code+0x72/0x78
 [<c0340000>] ioctl_standard_call+0x215/0x29e

x86_64 (bl6-13):

BUG: spinlock bad magic on CPU#1, fsx-linux/19721
 lock: ffff8100028cef48, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0

Call Trace:
 [<ffffffff803359a6>] _raw_spin_lock+0x22/0xf6
 [<ffffffff804e4c13>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff803303fe>] prop_norm_single+0x40/0x9a
 [<ffffffff8026ac1f>] set_page_dirty+0x8d/0xc9
 [<ffffffff8026bc09>] set_page_dirty_balance+0x9/0x39
 [<ffffffff80271f14>] __do_fault+0x37a/0x395
 [<ffffffff802738d7>] handle_mm_fault+0x342/0x6c3
 [<ffffffff804e6ac6>] do_page_fault+0x3e5/0x7ab
 [<ffffffff802117d3>] arch_get_unmapped_area+0x184/0x1f9
 [<ffffffff804e4c13>] _spin_lock_irqsave+0x9/0xe
 [<ffffffff803318cc>] __up_write+0x21/0x10d
 [<ffffffff804e500d>] error_exit+0x0/0x84

We also have a third machine which dies when running fs-linux but that
trips a soft-lockup trying to flush the tlb, subsequent stacks also
show prop_norm_single.

x86_64 (elm3b6):

First bug:

BUG: soft lockup - CPU#3 stuck for 11s! [pdflush:272]
CPU 3:
Modules linked in:
Pid: 272, comm: pdflush Not tainted 2.6.23-rc2-mm1-autokern1 #1
RIP: 0010:[<ffffffff8021a9c3>]  [<ffffffff8021a9c3>] flush_tlb_others+0x69/0x95
RSP: 0000:ffff810001f15a90  EFLAGS: 00000202
RAX: 0000000000000003 RBX: ffff810001f15ac0 RCX: 0000000000000008
RDX: 00000000000008f3 RSI: 00000000000000f3 RDI: 0000000000000002
RBP: 0000000000000000 R08: ffff810082f05210 R09: ffffffff802e60c1
R10: ffff8100815e6e70 R11: 0000000000000000 R12: ffff8101ffc38080
R13: ffffffff80358b47 R14: ffff810001f15a40 R15: ffff810081d73208
FS:  0000000000000000(0000) GS:ffff810180724280(0000) knlGS:00000000f7f75b80
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000f7e20494 CR3: 00000000029f0000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8021abd0>] flush_tlb_page+0x8f/0x97
 [<ffffffff8026daee>] page_mkclean+0x120/0x171
 [<ffffffff802e6227>] ext3_ordered_writepage+0x13f/0x16c
 [<ffffffff8025ed09>] clear_page_dirty_for_io+0x52/0xba
 [<ffffffff8025f002>] write_cache_pages+0x1b2/0x33a
 [<ffffffff8022a149>] update_curr+0xd9/0xf8
 [<ffffffff8025e9ca>] __writepage+0x0/0x2a
 [<ffffffff8025f1a9>] generic_writepages+0x1f/0x25
 [<ffffffff8025f1db>] do_writepages+0x2c/0x35
 [<ffffffff8029b453>] __writeback_single_inode+0x1c9/0x346
 [<ffffffff8023b809>] try_to_del_timer_sync+0x55/0x60
 [<ffffffff8023b826>] del_timer_sync+0x12/0x1f
 [<ffffffff8022a149>] update_curr+0xd9/0xf8
 [<ffffffff8022a446>] dequeue_entity+0x7d/0x92
 [<ffffffff8029ba20>] generic_sync_sb_inodes+0x216/0x372
 [<ffffffff8029bb99>] sync_sb_inodes+0x1d/0x1f
 [<ffffffff8029bdd9>] writeback_inodes+0x83/0xd6
 [<ffffffff8025e82b>] wb_kupdate+0xa0/0x113
 [<ffffffff8025f658>] pdflush+0x156/0x206
 [<ffffffff8025e78b>] wb_kupdate+0x0/0x113
 [<ffffffff8025f502>] pdflush+0x0/0x206
 [<ffffffff80245660>] kthread+0x44/0x6d
 [<ffffffff8020c5e8>] child_rip+0xa/0x12
 [<ffffffff8024561c>] kthread+0x0/0x6d
 [<ffffffff8020c5de>] child_rip+0x0/0x12

Later:

BUG: soft lockup - CPU#0 stuck for 11s! [syslogd:2167]
CPU 0:
Modules linked in:
Pid: 2167, comm: syslogd Not tainted 2.6.23-rc2-mm1-autokern1 #1
RIP: 0010:[<ffffffff804a7d4f>]  [<ffffffff804a7d4f>] _spin_lock_irqsave+0x19/0x29
RSP: 0000:ffff8101819358b8  EFLAGS: 00000286
RAX: 0000000000000287 RBX: ffff8101819358b8 RCX: 0000000000000012
RDX: ffff810181935980 RSI: ffff81018073eba8 RDI: ffff81018073ebc0
RBP: 0000000046badbf6 R08: 000000000001761f R09: 0000000000000064
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff802f56ac R15: ffff8101819358e8
FS:  0000000000000000(0000) GS:ffffffff805c8000(0063) knlGS:00000000f7e39460
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 00000000f7e2b960 CR3: 000000018197a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8036497f>] prop_norm_single+0x3e/0x9a
 [<ffffffff80364b3e>] prop_fraction_single+0x2d/0x53
 [<ffffffff8025e05b>] task_dirties_fraction+0x38/0x50
 [<ffffffff8025e093>] task_dirty_limit+0x20/0x63
 [<ffffffff8025e00a>] bdi_writeout_fraction+0x4e/0x67
 [<ffffffff8025e350>] get_dirty_limits+0x19e/0x1ad
 [<ffffffff8022d876>] __wake_up+0x40/0x4c
 [<ffffffff8025e429>] balance_dirty_pages_ratelimited_nr+0xca/0x2ac
 [<ffffffff80259536>] generic_file_buffered_write+0x1e9/0x619
 [<ffffffff8043badc>] skb_dequeue+0x50/0x5b
 [<ffffffff80259fad>] __generic_file_aio_write_nolock+0x41e/0x451
 [<ffffffff8043d223>] skb_free_datagram+0xc/0xe
 [<ffffffff80435784>] sock_recvmsg+0xee/0x107
 [<ffffffff8025a044>] generic_file_aio_write+0x64/0xc0
 [<ffffffff802e469a>] ext3_file_write+0x1c/0xa2
 [<ffffffff802e467e>] ext3_file_write+0x0/0xa2
 [<ffffffff80280251>] do_sync_readv_writev+0xe0/0x128
 [<ffffffff80245c15>] autoremove_wake_function+0x0/0x37
 [<ffffffff80436921>] sys_recvfrom+0xbb/0x11f
 [<ffffffff802ac935>] compat_do_readv_writev+0x18a/0x271
 [<ffffffff802492dd>] do_gettimeofday+0x3e/0xc8
 [<ffffffff802acaee>] compat_sys_writev+0x5f/0x76
 [<ffffffff80222d12>] ia32_sysret+0x0/0xa

-apw
