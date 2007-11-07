Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbXKGNsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbXKGNsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:48:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbXKGNsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:48:47 -0500
Received: from frankvm.xs4all.nl ([80.126.170.174]:34540 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754123AbXKGNsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:48:45 -0500
Date: Wed, 7 Nov 2007 14:48:43 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Frank van Maarseveen <frankvm@frankvm.com>, linux-kernel@vger.kernel.org
Subject: Re: VM/networking crash cause #1: page allocation failure (order:1, GFP_ATOMIC)
Message-ID: <20071107134843.GA14000@janus>
References: <20071105174214.GA10729@janus> <200711070901.17839.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711070901.17839.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 09:01:17AM +1100, Nick Piggin wrote:
> On Tuesday 06 November 2007 04:42, Frank van Maarseveen wrote:
> > For quite some time I'm seeing occasional lockups spread over 50 different
> > machines I'm maintaining. Symptom: a page allocation failure with order:1,
> > GFP_ATOMIC, while there is plenty of memory, as it seems (lots of free
> > pages, almost no swap used) followed by a lockup (everything dead). I've
> > collected all (12) crash cases which occurred the last 10 weeks on 50
> > machines total (i.e. 1 crash every 41 weeks on average). The kernel
> > messages are summarized to show the interesting part (IMO) they have
> > in common. Over the years this has become the crash cause #1 for stable
> > kernels for me (fglrx doesn't count ;).
> >
> > One note: I suspect that reporting a GFP_ATOMIC allocation failure in an
> > network driver via that same driver (netconsole) may not be the smartest
> > thing to do and this could be responsible for the lockup itself. However,
> > the initial page allocation failure remains and I'm not sure how to
> > address that problem.
> 
> It isn't unexpected. If an atomic allocation doesn't have enough memory,
> it kicks off kswapd to start freeing memory for it. However, it cannot
> wait for memory to become free (it's GFP_ATOMIC), so it has to return
> failure. GFP_ATOMIC allocation paths are designed so that the kernel can
> recover from this situation, and a subsequent allocation will have free
> memory.
> 
> Probably in production kernels we should default to only reporting this
> when page reclaim is not making any progress.
> 
> 
> > I still think the issue is memory fragmentation but if so, it looks
> > a bit extreme to me: One system with 2GB of ram crashed after a day,
> > merely running a couple of TCP server programs. All systems have either
> > 1 or 2GB ram and at least 1G of (merely unused) swap.
> 
> You can reduce the chances of it happening by increasing
> /proc/sys/vm/min_free_kbytes.

It's 3807 everywhere by default here which means roughly 950 pages if I
understand correctly. However, the problem occurs with much more free
pages as it seems. "grep '  free:' messages*" on the netconsole logging
machine shows:

messages:Nov  5 12:58:27 lokka  free:89531 slab:122946 mapped:4421 pagetables:295 bounce:0
messages.0:Oct 29 11:48:07 somero  free:113487 slab:109249 mapped:177942 pagetables:645 bounce:0
messages.1:Oct 26 11:27:01 naantali  free:41073 slab:97335 mapped:2540 pagetables:149 bounce:0
messages.3:Oct 12 14:56:44 koli  free:25694 slab:111842 mapped:16299 pagetables:794 bounce:0
messages.4:Oct  1 08:51:58 salla  free:2964 slab:97675 mapped:279622 pagetables:650 bounce:0
messages.6:Sep 17 10:34:49 lokka  free:170034 slab:95601 mapped:5548 pagetables:304 bounce:0
messages.6:Sep 17 10:48:48 karvio  free:33597 slab:94909 mapped:247838 pagetables:695 bounce:0
messages.6:Sep 20 10:32:50 nivala  free:80943 slab:93154 mapped:200040 pagetables:698 bounce:0
messages.8:Sep  3 09:46:11 lahti  free:8195 slab:125438 mapped:2911 pagetables:192 bounce:0
messages.9:Aug 30 10:40:46 ropi  free:61633 slab:90119 mapped:272634 pagetables:487 bounce:0
messages.9:Aug 30 10:46:58 ivalo  free:41600 slab:88279 mapped:272705 pagetables:487 bounce:0
messages.9:Aug 31 16:30:02 lokka  free:40661 slab:115006 mapped:21208 pagetables:493 bounce:0

So it is happening even with 170034 free pages (Sep 17 10:34:49),
i.e. 640M free. In this particular case the machine didn't crash but in
the majority of cases it does. Here's the full log of the 170034 free
pages case:

Sep 17 10:34:49 lokka kernel: ftxpd: page allocation failure. order:1, mode:0x4020
Sep 17 10:34:49 lokka kernel:  [<c01054aa>] show_trace_log_lvl+0x1a/0x30
Sep 17 10:34:49 lokka kernel:  [<c01054d2>] show_trace+0x12/0x20
Sep 17 10:34:49 lokka kernel:  [<c01055f6>] dump_stack+0x16/0x20
Sep 17 10:34:49 lokka kernel:  [<c0156ade>] __alloc_pages+0x27e/0x300
Sep 17 10:34:49 lokka kernel:  [<c016e926>] allocate_slab+0x46/0x90
Sep 17 10:34:49 lokka kernel:  [<c016e9e1>] new_slab+0x31/0x140
Sep 17 10:34:49 lokka kernel:  [<c016efec>] __slab_alloc+0xbc/0x180
Sep 17 10:34:49 lokka kernel:  [<c0170364>] __kmalloc_track_caller+0x74/0x80
Sep 17 10:34:49 lokka kernel:  [<c04b1d8d>] __alloc_skb+0x4d/0x110
Sep 17 10:34:49 lokka kernel:  [<c0500cce>] tcp_collapse+0x17e/0x3b0
Sep 17 10:34:49 lokka kernel:  [<c050103f>] tcp_prune_queue+0x7f/0x1c0
Sep 17 10:34:49 lokka kernel:  [<c05008b7>] tcp_data_queue+0x487/0x720
Sep 17 10:34:49 lokka kernel:  [<c0501a20>] tcp_rcv_established+0x3a0/0x6e0
Sep 17 10:34:49 lokka kernel:  [<c0509859>] tcp_v4_do_rcv+0xe9/0x100
Sep 17 10:34:49 lokka kernel:  [<c050a061>] tcp_v4_rcv+0x7f1/0x8d0
Sep 17 10:34:49 lokka kernel:  [<c04ed2bf>] ip_local_deliver+0xef/0x250
Sep 17 10:34:49 lokka kernel:  [<c04ed874>] ip_rcv+0x264/0x560
Sep 17 10:34:49 lokka kernel:  [<c04b905d>] netif_receive_skb+0x2ad/0x320
Sep 17 10:34:49 lokka kernel:  [<c04b9161>] process_backlog+0x91/0x120
Sep 17 10:34:49 lokka kernel:  [<c04b927d>] net_rx_action+0x8d/0x170
Sep 17 10:34:49 lokka kernel:  [<c0128de8>] __do_softirq+0x78/0x100
Sep 17 10:34:49 lokka kernel:  [<c0128eac>] do_softirq+0x3c/0x40
Sep 17 10:34:49 lokka kernel:  [<c0128f15>] irq_exit+0x45/0x50
Sep 17 10:34:49 lokka kernel:  [<c0106d2f>] do_IRQ+0x4f/0xa0
Sep 17 10:34:49 lokka kernel:  [<c01050b3>] common_interrupt+0x23/0x30
Sep 17 10:34:49 lokka kernel:  [<c01c87e3>] journal_get_write_access+0x23/0x40
Sep 17 10:34:49 lokka kernel:  [<c01c749f>] __ext3_journal_get_write_access+0x1f/0x60
Sep 17 10:34:49 lokka kernel:  [<c01be5ee>] ext3_reserve_inode_write+0x5e/0x80
Sep 17 10:34:49 lokka kernel:  [<c01be645>] ext3_mark_inode_dirty+0x35/0x60
Sep 17 10:34:49 lokka kernel:  [<c01bb421>] ext3_splice_branch+0x81/0x1f0
Sep 17 10:34:49 lokka kernel:  [<c01bb76c>] ext3_get_blocks_handle+0x1dc/0x360
Sep 17 10:34:49 lokka kernel:  [<c01bb966>] ext3_get_block+0x76/0xf0
Sep 17 10:34:49 lokka kernel:  [<c01960ec>] __block_prepare_write+0x20c/0x430
Sep 17 10:34:49 lokka kernel:  [<c0196bb8>] block_prepare_write+0x28/0x40
Sep 17 10:34:49 lokka kernel:  [<c01bbe82>] ext3_prepare_write+0xe2/0x170
Sep 17 10:34:49 lokka kernel:  [<c0153e2f>] generic_file_buffered_write+0x1cf/0x620
Sep 17 10:34:49 lokka kernel:  [<c01544c7>] __generic_file_aio_write_nolock+0x247/0x560
Sep 17 10:34:49 lokka kernel:  [<c015491a>] generic_file_aio_write+0x5a/0xd0
Sep 17 10:34:49 lokka kernel:  [<c01b98ad>] ext3_file_write+0x2d/0xd0
Sep 17 10:34:49 lokka kernel:  [<c0173b57>] do_sync_write+0xc7/0x120
Sep 17 10:34:49 lokka kernel:  [<c0173c37>] vfs_write+0x87/0x130
Sep 17 10:34:49 lokka kernel:  [<c0173d8d>] sys_write+0x3d/0x70
Sep 17 10:34:49 lokka kernel:  [<c0104132>] syscall_call+0x7/0xb
Sep 17 10:34:49 lokka kernel:  =======================
Sep 17 10:34:49 lokka kernel: Mem-info:
Sep 17 10:34:49 lokka kernel: DMA per-cpu:
Sep 17 10:34:49 lokka kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 17 10:34:49 lokka kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Sep 17 10:34:49 lokka kernel: Normal per-cpu:
Sep 17 10:34:49 lokka kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 177   Cold: hi:   62, btch:  15 usd:  54
Sep 17 10:34:49 lokka kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  46   Cold: hi:   62, btch:  15 usd:  58
Sep 17 10:34:49 lokka kernel: HighMem per-cpu:
Sep 17 10:34:49 lokka kernel: CPU    0: Hot: hi:  186, btch:  31 usd:   2   Cold: hi:   62, btch:  15 usd:  11
Sep 17 10:34:49 lokka kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  19   Cold: hi:   62, btch:  15 usd:   1
Sep 17 10:34:49 lokka kernel: Active:85625 inactive:152024 dirty:5701 writeback:2516 unstable:0
Sep 17 10:34:49 lokka kernel:  free:170034 slab:95601 mapped:5548 pagetables:304 bounce:0
Sep 17 10:34:49 lokka kernel: DMA free:3496kB min:64kB low:80kB high:96kB active:0kB inactive:0kB present:16176kB pages_scanned:0 all_unreclaimable? no
Sep 17 10:34:49 lokka kernel: lowmem_reserve[]: 0 868 2004
Sep 17 10:34:49 lokka kernel: Normal free:39756kB min:3736kB low:4668kB high:5604kB active:236916kB inactive:175624kB present:889680kB pages_scanned:0 all_unreclaimable? no
Sep 17 10:34:49 lokka kernel: lowmem_reserve[]: 0 0 9087
Sep 17 10:34:49 lokka kernel: HighMem free:636884kB min:512kB low:1732kB high:2952kB active:105584kB inactive:432472kB present:1163188kB pages_scanned:0 all_unreclaimable? no
Sep 17 10:34:49 lokka kernel: lowmem_reserve[]: 0 0 0
Sep 17 10:34:49 lokka kernel: DMA: 58*4kB 1*8kB 0*16kB 0*32kB 1*64kB 1*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3504kB
Sep 17 10:34:49 lokka kernel: Normal: 9770*4kB 6*8kB 0*16kB 0*32kB 1*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 39832kB
Sep 17 10:34:49 lokka kernel: HighMem: 0*4kB 0*8kB 1*16kB 1*32kB 1*64kB 0*128kB 717*256kB 407*512kB 139*1024kB 36*2048kB 7*4096kB = 636784kB
Sep 17 10:34:49 lokka kernel: Swap cache: add 13, delete 12, find 0/0, race 0+0
Sep 17 10:34:49 lokka kernel: Free swap  = 1004000kB
Sep 17 10:34:49 lokka kernel: Total swap = 1004052kB
Sep 17 10:34:49 lokka kernel: Free swap:       1004000kB
Sep 17 10:34:49 lokka kernel: 523912 pages of RAM
Sep 17 10:34:49 lokka kernel: 294536 pages of HIGHMEM
Sep 17 10:34:49 lokka kernel: 9361 reserved pages
Sep 17 10:34:49 lokka kernel: 232017 pages shared
Sep 17 10:34:49 lokka kernel: 1 pages swap cached
Sep 17 10:34:49 lokka kernel: 5701 pages dirty
Sep 17 10:34:49 lokka kernel: 2392 pages writeback
Sep 17 10:34:49 lokka kernel: 5548 pages mapped
Sep 17 10:34:49 lokka kernel: 95392 pages slab
Sep 17 10:34:49 lokka kernel: 304 pages pagetables

-- 
Frank
