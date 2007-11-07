Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbXKGN44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbXKGN44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbXKGN4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:56:48 -0500
Received: from frankvm.xs4all.nl ([80.126.170.174]:39823 "EHLO
	janus.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755871AbXKGN4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:56:47 -0500
Date: Wed, 7 Nov 2007 14:56:45 +0100
From: Frank van Maarseveen <frankvm@frankvm.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Frank van Maarseveen <frankvm@frankvm.com>, linux-kernel@vger.kernel.org
Subject: Re: VM/networking crash cause #1: page allocation failure (order:1, GFP_ATOMIC)
Message-ID: <20071107135645.GB14000@janus>
References: <fa.lT2PJ6g8pT/00cmv4KeoEpWD3rU@ifi.uio.no> <4730F52E.2070807@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4730F52E.2070807@shaw.ca>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 05:13:50PM -0600, Robert Hancock wrote:
> Frank van Maarseveen wrote:
> >For quite some time I'm seeing occasional lockups spread over 50 different
> >machines I'm maintaining. Symptom: a page allocation failure with order:1,
> >GFP_ATOMIC, while there is plenty of memory, as it seems (lots of free
> >pages, almost no swap used) followed by a lockup (everything dead). I've
> >collected all (12) crash cases which occurred the last 10 weeks on 50
> >machines total (i.e. 1 crash every 41 weeks on average). The kernel
> >messages are summarized to show the interesting part (IMO) they have
> >in common. Over the years this has become the crash cause #1 for stable
> >kernels for me (fglrx doesn't count ;).
> >
> >One note: I suspect that reporting a GFP_ATOMIC allocation failure in an
> >network driver via that same driver (netconsole) may not be the smartest
> >thing to do and this could be responsible for the lockup itself. However,
> >the initial page allocation failure remains and I'm not sure how to
> >address that problem.
> >
> >I still think the issue is memory fragmentation but if so, it looks
> >a bit extreme to me: One system with 2GB of ram crashed after a day,
> >merely running a couple of TCP server programs. All systems have either
> >1 or 2GB ram and at least 1G of (merely unused) swap.
> 
> These are all order-1 allocations for received network packets that need 
> to be allocated out of low memory (assuming you're using a 32-bit 
> kernel), so it's quite possible for them to fail on occasion. (Are you 
> using jumbo frames?)

I don't use jumbo frames.


> 
> That should not be causing a lockup though.. the received packet should 
> just get dropped.

Ok, packet loss is recoverable to some extend. When a system crashes
I often see a couple of page allocation failures in the same second,
all reported via netconsole. Here's the full log of such a case:

Oct 26 11:27:01 naantali kswapd0: page allocation failure. order:1, mode:0x4020 
Oct 26 11:27:01 naantali  [<c01054aa>] 
Oct 26 11:27:01 naantali show_trace_log_lvl+0x1a/0x30 
Oct 26 11:27:01 naantali  [<c01054d2>] 
Oct 26 11:27:01 naantali show_trace+0x12/0x20 
Oct 26 11:27:01 naantali  [<c01055f6>] 
Oct 26 11:27:01 naantali dump_stack+0x16/0x20 
Oct 26 11:27:01 naantali  [<c0156ace>] 
Oct 26 11:27:01 naantali __alloc_pages+0x27e/0x300 
Oct 26 11:27:01 naantali  [<c016e916>] 
Oct 26 11:27:01 naantali allocate_slab+0x46/0x90 
Oct 26 11:27:01 naantali  [<c016e9d1>] 
Oct 26 11:27:01 naantali new_slab+0x31/0x140 
Oct 26 11:27:01 naantali  [<c016efdc>] 
Oct 26 11:27:01 naantali __slab_alloc+0xbc/0x180 
Oct 26 11:27:01 naantali  [<c0170354>] 
Oct 26 11:27:01 naantali __kmalloc_track_caller+0x74/0x80 
Oct 26 11:27:01 naantali  [<c04b193d>] 
Oct 26 11:27:01 naantali __alloc_skb+0x4d/0x110 
Oct 26 11:27:01 naantali  [<c050088e>] 
Oct 26 11:27:01 naantali tcp_collapse+0x17e/0x3b0 
Oct 26 11:27:01 naantali  [<c0500bff>] 
Oct 26 11:27:01 naantali tcp_prune_queue+0x7f/0x1c0 
Oct 26 11:27:01 naantali  [<c0500477>] 
Oct 26 11:27:01 naantali tcp_data_queue+0x487/0x720 
Oct 26 11:27:01 naantali  [<c05015e0>] 
Oct 26 11:27:01 naantali tcp_rcv_established+0x3a0/0x6e0 
Oct 26 11:27:01 naantali  [<c0509419>] 
Oct 26 11:27:01 naantali tcp_v4_do_rcv+0xe9/0x100 
Oct 26 11:27:01 naantali  [<c0509c21>] 
Oct 26 11:27:01 naantali tcp_v4_rcv+0x7f1/0x8d0 
Oct 26 11:27:01 naantali  [<c04ece8f>] 
Oct 26 11:27:01 naantali ip_local_deliver+0xef/0x250 
Oct 26 11:27:01 naantali  [<c04ed444>] 
Oct 26 11:27:01 naantali ip_rcv+0x264/0x560 
Oct 26 11:27:01 naantali  [<c04b8c2d>] 
Oct 26 11:27:01 naantali netif_receive_skb+0x2ad/0x320 
Oct 26 11:27:01 naantali  [<c04b8d31>] 
Oct 26 11:27:01 naantali process_backlog+0x91/0x120 
Oct 26 11:27:01 naantali  [<c04b8e4d>] 
Oct 26 11:27:01 naantali net_rx_action+0x8d/0x170 
Oct 26 11:27:01 naantali  [<c0128de8>] 
Oct 26 11:27:01 naantali __do_softirq+0x78/0x100 
Oct 26 11:27:01 naantali  [<c0128eac>] 
Oct 26 11:27:01 naantali do_softirq+0x3c/0x40 
Oct 26 11:27:01 naantali  [<c0128f15>] 
Oct 26 11:27:01 naantali irq_exit+0x45/0x50 
Oct 26 11:27:01 naantali  [<c0106d2f>] 
Oct 26 11:27:01 naantali do_IRQ+0x4f/0xa0 
Oct 26 11:27:01 naantali  [<c01050b3>] 
Oct 26 11:27:01 naantali common_interrupt+0x23/0x30 
Oct 26 11:27:01 naantali  [<c0575736>] 
Oct 26 11:27:01 naantali _spin_unlock+0x16/0x20 
Oct 26 11:27:01 naantali  [<c0185052>] 
Oct 26 11:27:01 naantali prune_dcache+0x142/0x1a0 
Oct 26 11:27:01 naantali  [<c01855ee>] 
Oct 26 11:27:01 naantali shrink_dcache_memory+0x1e/0x50 
Oct 26 11:27:01 naantali  [<c015a4d9>] 
Oct 26 11:27:01 naantali shrink_slab+0x139/0x1d0 
Oct 26 11:27:01 naantali  [<c015b980>] 
Oct 26 11:27:01 naantali balance_pgdat+0x220/0x380 
Oct 26 11:27:01 naantali  [<c015bbb8>] 
Oct 26 11:27:01 naantali kswapd+0xd8/0x140 
Oct 26 11:27:01 naantali  [<c0136eac>] 
Oct 26 11:27:01 naantali kthread+0x5c/0xa0 
Oct 26 11:27:01 naantali  [<c0105337>] 
Oct 26 11:27:01 naantali kernel_thread_helper+0x7/0x10 
Oct 26 11:27:01 naantali  ======================= 
Oct 26 11:27:01 naantali Mem-info: 
Oct 26 11:27:01 naantali DMA per-cpu: 
Oct 26 11:27:01 naantali CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0 
Oct 26 11:27:01 naantali Normal per-cpu: 
Oct 26 11:27:01 naantali CPU    0: Hot: hi:  186, btch:  31 usd: 149   Cold: hi:   62, btch:  15 usd:  59 
Oct 26 11:27:01 naantali HighMem per-cpu: 
Oct 26 11:27:01 naantali CPU    0: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  12 
Oct 26 11:27:01 naantali Active:115770 inactive:257188 dirty:10243 writeback:1920 unstable:0 
Oct 26 11:27:01 naantali  free:41073 slab:97335 mapped:2540 pagetables:149 bounce:0 
Oct 26 11:27:01 naantali DMA free:3488kB min:64kB low:80kB high:96kB active:0kB inactive:0kB present:16176kB pages_scanned:0 all_unreclaimable? no 
Oct 26 11:27:01 naantali lowmem_reserve[]:
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali  868
Oct 26 11:27:01 naantali  2005
Oct 26 11:27:01 naantali  
Oct 26 11:27:01 naantali Normal free:3976kB min:3736kB low:4668kB high:5604kB active:318568kB inactive:152928kB present:889680kB pages_scanned:0 all_unreclaimable? no 
Oct 26 11:27:01 naantali lowmem_reserve[]:
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali  9094
Oct 26 11:27:01 naantali  
Oct 26 11:27:01 naantali HighMem free:156828kB min:512kB low:1732kB high:2956kB active:144512kB inactive:875824kB present:1164104kB pages_scanned:0 all_unreclaimable? no 
Oct 26 11:27:01 naantali lowmem_reserve[]:
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali last message repeated 2 times
Oct 26 11:27:01 naantali  
Oct 26 11:27:01 naantali DMA: 
Oct 26 11:27:01 naantali 12*4kB 
Oct 26 11:27:01 naantali 0*8kB 
Oct 26 11:27:01 naantali 1*16kB 
Oct 26 11:27:01 naantali 1*32kB 
Oct 26 11:27:01 naantali 1*64kB 
Oct 26 11:27:01 naantali 0*128kB 
Oct 26 11:27:01 naantali 1*256kB 
Oct 26 11:27:01 naantali 0*512kB 
Oct 26 11:27:01 naantali 1*1024kB 
Oct 26 11:27:01 naantali 1*2048kB 
Oct 26 11:27:01 naantali 0*4096kB 
Oct 26 11:27:01 naantali = 3488kB 
Oct 26 11:27:01 naantali Normal: 
Oct 26 11:27:01 naantali 824*4kB 
Oct 26 11:27:01 naantali 5*8kB 
Oct 26 11:27:01 naantali 0*16kB 
Oct 26 11:27:01 naantali 1*32kB 
Oct 26 11:27:01 naantali 0*64kB 
Oct 26 11:27:01 naantali 1*128kB 
Oct 26 11:27:01 naantali 0*256kB 
Oct 26 11:27:01 naantali 1*512kB 
Oct 26 11:27:01 naantali 0*1024kB 
Oct 26 11:27:01 naantali 0*2048kB 
Oct 26 11:27:01 naantali 0*4096kB 
Oct 26 11:27:01 naantali = 4008kB 
Oct 26 11:27:01 naantali HighMem: 
Oct 26 11:27:01 naantali 1*4kB 
Oct 26 11:27:01 naantali 0*8kB 
Oct 26 11:27:01 naantali 1*16kB 
Oct 26 11:27:01 naantali 0*32kB 
Oct 26 11:27:01 naantali 0*64kB 
Oct 26 11:27:01 naantali 1*128kB 
Oct 26 11:27:01 naantali 0*256kB 
Oct 26 11:27:01 naantali 0*512kB 
Oct 26 11:27:01 naantali 113*1024kB 
Oct 26 11:27:01 naantali 20*2048kB 
Oct 26 11:27:01 naantali 0*4096kB 
Oct 26 11:27:01 naantali = 156820kB 
Oct 26 11:27:01 naantali Swap cache: add 90, delete 88, find 18/28, race 0+0 
Oct 26 11:27:01 naantali Free swap  = 2008048kB 
Oct 26 11:27:01 naantali Total swap = 2008084kB 
Oct 26 11:27:01 naantali Free swap:       2008048kB 
Oct 26 11:27:01 naantali 524144 pages of RAM 
Oct 26 11:27:01 naantali 294768 pages of HIGHMEM 
Oct 26 11:27:01 naantali 9378 reserved pages 
Oct 26 11:27:01 naantali 357325 pages shared 
Oct 26 11:27:01 naantali 2 pages swap cached 
Oct 26 11:27:01 naantali 10243 pages dirty 
Oct 26 11:27:01 naantali 1920 pages writeback 
Oct 26 11:27:01 naantali 2540 pages mapped 
Oct 26 11:27:01 naantali 97344 pages slab 
Oct 26 11:27:01 naantali 149 pages pagetables 
Oct 26 11:27:01 naantali kswapd0: page allocation failure. order:1, mode:0x4020 
Oct 26 11:27:01 naantali  [<c01054aa>] 
Oct 26 11:27:01 naantali show_trace_log_lvl+0x1a/0x30 
Oct 26 11:27:01 naantali  [<c01054d2>] 
Oct 26 11:27:01 naantali show_trace+0x12/0x20 
Oct 26 11:27:01 naantali  [<c01055f6>] 
Oct 26 11:27:01 naantali dump_stack+0x16/0x20 
Oct 26 11:27:01 naantali  [<c0156ace>] 
Oct 26 11:27:01 naantali __alloc_pages+0x27e/0x300 
Oct 26 11:27:01 naantali  [<c016e916>] 
Oct 26 11:27:01 naantali allocate_slab+0x46/0x90 
Oct 26 11:27:01 naantali  [<c016e9d1>] 
Oct 26 11:27:01 naantali new_slab+0x31/0x140 
Oct 26 11:27:01 naantali  [<c016efdc>] 
Oct 26 11:27:01 naantali __slab_alloc+0xbc/0x180 
Oct 26 11:27:01 naantali  [<c0170354>] 
Oct 26 11:27:01 naantali __kmalloc_track_caller+0x74/0x80 
Oct 26 11:27:01 naantali  [<c04b193d>] 
Oct 26 11:27:01 naantali __alloc_skb+0x4d/0x110 
Oct 26 11:27:01 naantali  [<c04b1a23>] 
Oct 26 11:27:01 naantali __netdev_alloc_skb+0x23/0x50 
Oct 26 11:27:01 naantali  [<c0328f37>] 
Oct 26 11:27:01 naantali e1000_alloc_rx_buffers+0x127/0x320 
Oct 26 11:27:01 naantali  [<c03285b9>] 
Oct 26 11:27:01 naantali e1000_clean_rx_irq+0x299/0x510 
Oct 26 11:27:01 naantali  [<c0327f30>] 
Oct 26 11:27:01 naantali e1000_intr+0x80/0x140 
Oct 26 11:27:01 naantali  [<c014e3a8>] 
Oct 26 11:27:01 naantali handle_IRQ_event+0x28/0x60 
Oct 26 11:27:01 naantali  [<c014f67e>] 
Oct 26 11:27:01 naantali handle_fasteoi_irq+0x6e/0xd0 
Oct 26 11:27:01 naantali  [<c0106d2a>] 
Oct 26 11:27:01 naantali do_IRQ+0x4a/0xa0 
Oct 26 11:27:01 naantali  [<c01050b3>] 
Oct 26 11:27:01 naantali common_interrupt+0x23/0x30 
Oct 26 11:27:01 naantali  [<c057573d>] 
Oct 26 11:27:01 naantali _spin_unlock+0x1d/0x20 
Oct 26 11:27:01 naantali  [<c0187154>] 
Oct 26 11:27:01 naantali dispose_list+0x64/0xe0 
Oct 26 11:27:01 naantali  [<c01873f4>] 
Oct 26 11:27:01 naantali prune_icache+0xd4/0x1e0 
Oct 26 11:27:01 naantali  [<c0187517>] 
Oct 26 11:27:01 naantali shrink_icache_memory+0x17/0x40 
Oct 26 11:27:01 naantali  [<c015a4d9>] 
Oct 26 11:27:01 naantali shrink_slab+0x139/0x1d0 
Oct 26 11:27:01 naantali  [<c015b980>] 
Oct 26 11:27:01 naantali balance_pgdat+0x220/0x380 
Oct 26 11:27:01 naantali  [<c015bbb8>] 
Oct 26 11:27:01 naantali kswapd+0xd8/0x140 
Oct 26 11:27:01 naantali  [<c0136eac>] 
Oct 26 11:27:01 naantali kthread+0x5c/0xa0 
Oct 26 11:27:01 naantali  [<c0105337>] 
Oct 26 11:27:01 naantali kernel_thread_helper+0x7/0x10 
Oct 26 11:27:01 naantali  ======================= 
Oct 26 11:27:01 naantali Mem-info: 
Oct 26 11:27:01 naantali DMA per-cpu: 
Oct 26 11:27:01 naantali CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0 
Oct 26 11:27:01 naantali Normal per-cpu: 
Oct 26 11:27:01 naantali CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  50 
Oct 26 11:27:01 naantali HighMem per-cpu: 
Oct 26 11:27:01 naantali CPU    0: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  12 
Oct 26 11:27:01 naantali Active:115692 inactive:257170 dirty:10243 writeback:1888 unstable:0 
Oct 26 11:27:01 naantali  free:41181 slab:97335 mapped:2540 pagetables:149 bounce:0 
Oct 26 11:27:01 naantali DMA free:3488kB min:64kB low:80kB high:96kB active:0kB inactive:0kB present:16176kB pages_scanned:0 all_unreclaimable? yes 
Oct 26 11:27:01 naantali lowmem_reserve[]:
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali  868
Oct 26 11:27:01 naantali  2005
Oct 26 11:27:01 naantali  
Oct 26 11:27:01 naantali Normal free:4408kB min:3736kB low:4668kB high:5604kB active:318256kB inactive:152856kB present:889680kB pages_scanned:0 all_unreclaimable? no 
Oct 26 11:27:01 naantali lowmem_reserve[]:
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali  9094
Oct 26 11:27:01 naantali  
Oct 26 11:27:01 naantali HighMem free:156828kB min:512kB low:1732kB high:2956kB active:144512kB inactive:875824kB present:1164104kB pages_scanned:0 all_unreclaimable? no 
Oct 26 11:27:01 naantali lowmem_reserve[]:
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali last message repeated 2 times
Oct 26 11:27:01 naantali  
Oct 26 11:27:01 naantali DMA: 
Oct 26 11:27:01 naantali 12*4kB 
Oct 26 11:27:01 naantali 0*8kB 
Oct 26 11:27:01 naantali 1*16kB 
Oct 26 11:27:01 naantali 1*32kB 
Oct 26 11:27:01 naantali 1*64kB 
Oct 26 11:27:01 naantali 0*128kB 
Oct 26 11:27:01 naantali 1*256kB 
Oct 26 11:27:01 naantali 0*512kB 
Oct 26 11:27:01 naantali 1*1024kB 
Oct 26 11:27:01 naantali 1*2048kB 
Oct 26 11:27:01 naantali 0*4096kB 
Oct 26 11:27:01 naantali = 3488kB 
Oct 26 11:27:01 naantali Normal: 
Oct 26 11:27:01 naantali 927*4kB 
Oct 26 11:27:01 naantali 6*8kB 
Oct 26 11:27:01 naantali 0*16kB 
Oct 26 11:27:01 naantali 1*32kB 
Oct 26 11:27:01 naantali 0*64kB 
Oct 26 11:27:01 naantali 1*128kB 
Oct 26 11:27:01 naantali 0*256kB 
Oct 26 11:27:01 naantali 1*512kB 
Oct 26 11:27:01 naantali 0*1024kB 
Oct 26 11:27:01 naantali 0*2048kB 
Oct 26 11:27:01 naantali 0*4096kB 
Oct 26 11:27:01 naantali = 4428kB 
Oct 26 11:27:01 naantali HighMem: 
Oct 26 11:27:01 naantali 1*4kB 
Oct 26 11:27:01 naantali 0*8kB 
Oct 26 11:27:01 naantali 1*16kB 
Oct 26 11:27:01 naantali 0*32kB 
Oct 26 11:27:01 naantali 0*64kB 
Oct 26 11:27:01 naantali 1*128kB 
Oct 26 11:27:01 naantali 0*256kB 
Oct 26 11:27:01 naantali 0*512kB 
Oct 26 11:27:01 naantali 113*1024kB 
Oct 26 11:27:01 naantali 20*2048kB 
Oct 26 11:27:01 naantali 0*4096kB 
Oct 26 11:27:01 naantali = 156820kB 
Oct 26 11:27:01 naantali Swap cache: add 90, delete 88, find 18/28, race 0+0 
Oct 26 11:27:01 naantali Free swap  = 2008048kB 
Oct 26 11:27:01 naantali Total swap = 2008084kB 
Oct 26 11:27:01 naantali Free swap:       2008048kB 
Oct 26 11:27:01 naantali 524144 pages of RAM 
Oct 26 11:27:01 naantali 294768 pages of HIGHMEM 
Oct 26 11:27:01 naantali 9378 reserved pages 
Oct 26 11:27:01 naantali 357229 pages shared 
Oct 26 11:27:01 naantali 2 pages swap cached 
Oct 26 11:27:01 naantali 10243 pages dirty 
Oct 26 11:27:01 naantali 1888 pages writeback 
Oct 26 11:27:01 naantali 2540 pages mapped 
Oct 26 11:27:01 naantali 97344 pages slab 
Oct 26 11:27:01 naantali 149 pages pagetables 
Oct 26 11:27:01 naantali kswapd0: page allocation failure. order:1, mode:0x4020 
Oct 26 11:27:01 naantali  [<c01054aa>] 
Oct 26 11:27:01 naantali show_trace_log_lvl+0x1a/0x30 
Oct 26 11:27:01 naantali  [<c01054d2>] 
Oct 26 11:27:01 naantali show_trace+0x12/0x20 
Oct 26 11:27:01 naantali  [<c01055f6>] 
Oct 26 11:27:01 naantali dump_stack+0x16/0x20 
Oct 26 11:27:01 naantali  [<c0156ace>] 
Oct 26 11:27:01 naantali __alloc_pages+0x27e/0x300 
Oct 26 11:27:01 naantali  [<c016e916>] 
Oct 26 11:27:01 naantali allocate_slab+0x46/0x90 
Oct 26 11:27:01 naantali  [<c016e9d1>] 
Oct 26 11:27:01 naantali new_slab+0x31/0x140 
Oct 26 11:27:01 naantali  [<c016efdc>] 
Oct 26 11:27:01 naantali __slab_alloc+0xbc/0x180 
Oct 26 11:27:01 naantali  [<c0170354>] 
Oct 26 11:27:01 naantali __kmalloc_track_caller+0x74/0x80 
Oct 26 11:27:01 naantali  [<c04b193d>] 
Oct 26 11:27:01 naantali __alloc_skb+0x4d/0x110 
Oct 26 11:27:01 naantali  [<c04b1a23>] 
Oct 26 11:27:01 naantali __netdev_alloc_skb+0x23/0x50 
Oct 26 11:27:01 naantali  [<c0328f37>] 
Oct 26 11:27:01 naantali e1000_alloc_rx_buffers+0x127/0x320 
Oct 26 11:27:01 naantali  [<c0328698>] 
Oct 26 11:27:01 naantali e1000_clean_rx_irq+0x378/0x510 
Oct 26 11:27:01 naantali  [<c0327f30>] 
Oct 26 11:27:01 naantali e1000_intr+0x80/0x140 
Oct 26 11:27:01 naantali  [<c014e3a8>] 
Oct 26 11:27:01 naantali handle_IRQ_event+0x28/0x60 
Oct 26 11:27:01 naantali  [<c014f67e>] 
Oct 26 11:27:01 naantali handle_fasteoi_irq+0x6e/0xd0 
Oct 26 11:27:01 naantali  [<c0106d2a>] 
Oct 26 11:27:01 naantali do_IRQ+0x4a/0xa0 
Oct 26 11:27:01 naantali  [<c01050b3>] 
Oct 26 11:27:01 naantali common_interrupt+0x23/0x30 
Oct 26 11:27:01 naantali  [<c057573d>] 
Oct 26 11:27:01 naantali _spin_unlock+0x1d/0x20 
Oct 26 11:27:01 naantali  [<c0187154>] 
Oct 26 11:27:01 naantali dispose_list+0x64/0xe0 
Oct 26 11:27:01 naantali  [<c01873f4>] 
Oct 26 11:27:01 naantali prune_icache+0xd4/0x1e0 
Oct 26 11:27:01 naantali  [<c0187517>] 
Oct 26 11:27:01 naantali shrink_icache_memory+0x17/0x40 
Oct 26 11:27:01 naantali  [<c015a4d9>] 
Oct 26 11:27:01 naantali shrink_slab+0x139/0x1d0 
Oct 26 11:27:01 naantali  [<c015b980>] 
Oct 26 11:27:01 naantali balance_pgdat+0x220/0x380 
Oct 26 11:27:01 naantali  [<c015bbb8>] 
Oct 26 11:27:01 naantali kswapd+0xd8/0x140 
Oct 26 11:27:01 naantali  [<c0136eac>] 
Oct 26 11:27:01 naantali kthread+0x5c/0xa0 
Oct 26 11:27:01 naantali  [<c0105337>] 
Oct 26 11:27:01 naantali kernel_thread_helper+0x7/0x10 
Oct 26 11:27:01 naantali  ======================= 
Oct 26 11:27:01 naantali Mem-info: 
Oct 26 11:27:01 naantali DMA per-cpu: 
Oct 26 11:27:01 naantali CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0 
Oct 26 11:27:01 naantali Normal per-cpu: 
Oct 26 11:27:01 naantali CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  50 
Oct 26 11:27:01 naantali HighMem per-cpu: 
Oct 26 11:27:01 naantali CPU    0: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  12 
Oct 26 11:27:01 naantali Active:115692 inactive:257170 dirty:10243 writeback:1888 unstable:0 
Oct 26 11:27:01 naantali  free:41181 slab:97335 mapped:2540 pagetables:149 bounce:0 
Oct 26 11:27:01 naantali DMA free:3488kB min:64kB low:80kB high:96kB active:0kB inactive:0kB present:16176kB pages_scanned:0 all_unreclaimable? yes 
Oct 26 11:27:01 naantali lowmem_reserve[]:
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali  868
Oct 26 11:27:01 naantali  2005
Oct 26 11:27:01 naantali  
Oct 26 11:27:01 naantali Normal free:4408kB min:3736kB low:4668kB high:5604kB active:318256kB inactive:152856kB present:889680kB pages_scanned:0 all_unreclaimable? no 
Oct 26 11:27:01 naantali lowmem_reserve[]:
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali  9094
Oct 26 11:27:01 naantali  
Oct 26 11:27:01 naantali HighMem free:156828kB min:512kB low:1732kB high:2956kB active:144512kB inactive:875824kB present:1164104kB pages_scanned:0 all_unreclaimable? no 
Oct 26 11:27:01 naantali lowmem_reserve[]:
Oct 26 11:27:01 naantali  0
Oct 26 11:27:01 naantali last message repeated 2 times
Oct 26 11:27:01 naantali  
Oct 26 11:27:01 naantali DMA: 
Oct 26 11:27:01 naantali 12*4kB 
Oct 26 11:27:01 naantali 0*8kB 
Oct 26 11:27:01 naantali 1*16kB 
Oct 26 11:27:01 naantali 1*32kB 
Oct 26 11:27:01 naantali 1*64kB 
Oct 26 11:27:01 naantali 0*128kB 
Oct 26 11:27:01 naantali 1*256kB 
Oct 26 11:27:01 naantali 0*512kB 
Oct 26 11:27:01 naantali 1*1024kB 
Oct 26 11:27:01 naantali 1*2048kB 
Oct 26 11:27:01 naantali 0*4096kB 
Oct 26 11:27:01 naantali = 3488kB 
Oct 26 11:27:01 naantali Normal: 
Oct 26 11:27:01 naantali 927*4kB 
Oct 26 11:27:01 naantali 6*8kB 
Oct 26 11:27:01 naantali 0*16kB 
Oct 26 11:27:01 naantali 1*32kB 
Oct 26 11:27:01 naantali 0*64kB 
Oct 26 11:27:01 naantali 1*128kB 
Oct 26 11:27:01 naantali 0*256kB 
Oct 26 11:27:01 naantali 1*512kB 
Oct 26 11:27:01 naantali 0*1024kB 
Oct 26 11:27:01 naantali 0*2048kB 
Oct 26 11:27:01 naantali 0*4096kB 
Oct 26 11:27:01 naantali 524144 pages of RAM 
Oct 26 11:27:01 naantali 294768 pages of HIGHMEM 
Oct 26 11:27:01 naantali 9378 reserved pages 
Oct 26 11:27:01 naantali 357229 pages shared 
Oct 26 11:27:01 naantali 2 pages swap cached 
Oct 26 11:27:01 naantali 10243 pages dirty 
Oct 26 11:27:01 naantali 1888 pages writeback 
Oct 26 11:27:01 naantali 2540 pages mapped 
Oct 26 11:27:01 naantali 97344 pages slab 
Oct 26 11:27:01 naantali 149 pages pagetables 
Oct 26 11:27:01 naantali __alloc_pages+0x27e/0x300 
Oct 26 11:27:01 naantali kthread+0x5c/0xa0 
Oct 26 11:27:01 naantali 1*2048kB 
<dead>

-- 
Frank
