Return-Path: <linux-kernel-owner+w=401wt.eu-S1030323AbXCOPfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323AbXCOPfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 11:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030344AbXCOPfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 11:35:11 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4302 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030323AbXCOPfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 11:35:09 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Mel Gorman <mel@skynet.ie>
Subject: Re: 2.6.21-rc3-mm1
Date: Thu, 15 Mar 2007 16:37:13 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <20070314170738.d5d35c06.akpm@linux-foundation.org> <20070315101625.GA16974@skynet.ie>
In-Reply-To: <20070315101625.GA16974@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703151637.14558.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mel, 

> > > 	Today after +- 24h of uptime I found some more page allocation
> > > failures ('eth1: Can't allocate skb for Rx'). You'll find more here:
> > > 
> > > http://tuxland.pl/misc/2.6.21-rc3-mm1-page-allocation-failure.txt
> > > 
> > > System wasn't doing anything unusual, as usual ;-) X, some p2p 
> > > software, firefox+flash playing music.
> > 
> > Do other kernels do this, or is 2.6.21-rc3-mm1 worse?
> > 
> > It is of course a non-fatal problem and will inevitably happen sometimes,
> > but we would like the VM to be able to minimise the occurrence of this
> > problem.
> 
> Mariusz, I would be interested in finding out if this problem still occurs when
> you set min_free_kbytes to 16384 via /proc/sys/vm/min_free_kbytes. I understand
> that the problem is not easily reproduced and requiring configuration changes
> is far from ideal but it'd allow me to find out if options 2 or 3 below make
> sense in advance.

After a few hours I can confirm that this happens with 

$ cat /proc/sys/vm/min_free_kbytes 
16384

as well. See the syslog output below. Feel free to mail me to do some more tests.

Regards,

	Mariusz Kozlowski


Mar 15 12:00:47: echo 16384 > /proc/sys/vm/min_free_kbytes
Mar 15 12:38:33: eth1: MAC controller error (WTERR). Ignoring.
Mar 15 13:29:31: eth1: MAC controller error (WTERR). Ignoring.
Mar 15 13:34:34: eth1: MAC controller error (WTERR). Ignoring.
Mar 15 13:52:58: swapper: page allocation failure. order:1, mode:0x80020
Mar 15 13:52:58:  [<c0104664>] show_trace_log_lvl+0x1a/0x30
Mar 15 13:52:58:  [<c0104e00>] show_trace+0x12/0x14
Mar 15 13:52:58:  [<c0104eb7>] dump_stack+0x16/0x18
Mar 15 13:52:58:  [<c0150e8e>] __alloc_pages+0x2e6/0x2fd
Mar 15 13:52:58:  [<c0167556>] cache_alloc_refill+0x350/0x65d
Mar 15 13:52:58:  [<c0167957>] __kmalloc_track_caller+0xf4/0xf9
Mar 15 13:52:58:  [<c0396213>] __alloc_skb+0x6e/0x122
Mar 15 13:52:58:  [<ded154a9>] orinoco_interrupt+0x986/0x10a4 [orinoco]
Mar 15 13:52:58:  [<c0144d43>] handle_IRQ_event+0x28/0x59
Mar 15 13:52:58:  [<c01462f7>] handle_level_irq+0x6e/0xe7
Mar 15 13:52:58:  [<c0105e7e>] do_IRQ+0x3d/0x7f
Mar 15 13:52:58:  [<c01041d6>] common_interrupt+0x2e/0x34
Mar 15 13:52:58:  [<c0102352>] cpu_idle+0x46/0x74
Mar 15 13:52:58:  [<c0101131>] rest_init+0x37/0x46
Mar 15 13:52:58:  [<c0546bc1>] start_kernel+0x33c/0x3cb
Mar 15 13:52:58:  [<00000000>] 0x0
Mar 15 13:52:58:  =======================
Mar 15 13:52:58: Mem-info:
Mar 15 13:52:58: DMA per-cpu:
Mar 15 13:52:58: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Mar 15 13:52:58: Normal per-cpu:
Mar 15 13:52:58: CPU    0: Hot: hi:  186, btch:  31 usd: 171   Cold: hi:   62, btch:  15 usd:  53
Mar 15 13:52:58: Active:44723 inactive:54877 dirty:1323 writeback:0 unstable:0
Mar 15 13:52:58:  free:5602 slab:11245 mapped:7463 pagetables:284 bounce:0
Mar 15 13:52:58: DMA free:2728kB min:544kB low:680kB high:816kB active:952kB inactive:3900kB present:16256kB pages_scanned:0 all_unreclaimable? no
Mar 15 13:52:58: lowmem_reserve[]: 0 459 459
Mar 15 13:52:58: Normal free:19680kB min:15836kB low:19792kB high:23752kB active:177940kB inactive:215608kB present:470856kB pages_scanned:0 all_unreclaimable? no
Mar 15 13:52:58: lowmem_reserve[]: 0 0 0
Mar 15 13:52:58: DMA: 682*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2728kB
Mar 15 13:52:58: Normal: 4920*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 19680kB
Mar 15 13:52:58: Swap cache: add 249823, delete 244938, find 35267/42320, race 3506+1
Mar 15 13:52:58: Free swap  = 462284kB
Mar 15 13:52:58: Total swap = 498004kB
Mar 15 13:52:58: Free swap:       462284kB
Mar 15 13:52:58: 122736 pages of RAM
Mar 15 13:52:58: 0 pages of HIGHMEM
Mar 15 13:52:58: 2870 reserved pages
Mar 15 13:52:58: 58717 pages shared
Mar 15 13:52:58: 4885 pages swap cached
Mar 15 13:52:58: 1323 pages dirty
Mar 15 13:52:58: 0 pages writeback
Mar 15 13:52:58: 7463 pages mapped
Mar 15 13:52:58: 11245 pages slab
Mar 15 13:52:58: 284 pages pagetables
Mar 15 13:52:58: eth1: Can't allocate skb for Rx
Mar 15 13:58:07: eth1: MAC controller error (WTERR). Ignoring.
Mar 15 15:22:37: swapper: page allocation failure. order:1, mode:0x80020
Mar 15 15:22:37:  [<c0104664>] show_trace_log_lvl+0x1a/0x30
Mar 15 15:22:37:  [<c0104e00>] show_trace+0x12/0x14
Mar 15 15:22:37:  [<c0104eb7>] dump_stack+0x16/0x18
Mar 15 15:22:37:  [<c0150e8e>] __alloc_pages+0x2e6/0x2fd
Mar 15 15:22:37:  [<c0167556>] cache_alloc_refill+0x350/0x65d
Mar 15 15:22:37:  [<c0167957>] __kmalloc_track_caller+0xf4/0xf9
Mar 15 15:22:37:  [<c0396213>] __alloc_skb+0x6e/0x122
Mar 15 15:22:37:  [<ded154a9>] orinoco_interrupt+0x986/0x10a4 [orinoco]
Mar 15 15:22:37:  [<c0144d43>] handle_IRQ_event+0x28/0x59
Mar 15 15:22:37:  [<c01462f7>] handle_level_irq+0x6e/0xe7
Mar 15 15:22:37:  [<c0105e7e>] do_IRQ+0x3d/0x7f
Mar 15 15:22:37:  [<c01041d6>] common_interrupt+0x2e/0x34
Mar 15 15:22:37:  [<c0102352>] cpu_idle+0x46/0x74
Mar 15 15:22:37:  [<c0101131>] rest_init+0x37/0x46
Mar 15 15:22:37:  [<c0546bc1>] start_kernel+0x33c/0x3cb
Mar 15 15:22:37:  [<00000000>] 0x0
Mar 15 15:22:37:  =======================
Mar 15 15:22:37: Mem-info:
Mar 15 15:22:37: DMA per-cpu:
Mar 15 15:22:37: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Mar 15 15:22:37: Normal per-cpu:
Mar 15 15:22:37: CPU    0: Hot: hi:  186, btch:  31 usd: 141   Cold: hi:   62, btch:  15 usd:  55
Mar 15 15:22:37: Active:53226 inactive:50830 dirty:338 writeback:0 unstable:0
Mar 15 15:22:37:  free:6554 slab:5865 mapped:7463 pagetables:284 bounce:0
Mar 15 15:22:37: DMA free:2676kB min:544kB low:680kB high:816kB active:940kB inactive:4728kB present:16256kB pages_scanned:0 all_unreclaimable? no
Mar 15 15:22:37: lowmem_reserve[]: 0 459 459
Mar 15 15:22:37: Normal free:23540kB min:15836kB low:19792kB high:23752kB active:211964kB inactive:198592kB present:470856kB pages_scanned:0 all_unreclaimable? no
Mar 15 15:22:37: lowmem_reserve[]: 0 0 0
Mar 15 15:22:37: DMA: 665*4kB 2*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2676kB
Mar 15 15:22:37: Normal: 5595*4kB 145*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 23540kB
Mar 15 15:22:37: Swap cache: add 249823, delete 244940, find 35267/42320, race 3506+1
Mar 15 15:22:37: Free swap  = 462284kB
Mar 15 15:22:37: Total swap = 498004kB
Mar 15 15:22:37: Free swap:       462284kB
Mar 15 15:22:37: 122736 pages of RAM
Mar 15 15:22:37: 0 pages of HIGHMEM
Mar 15 15:22:37: 2870 reserved pages
Mar 15 15:22:37: 63457 pages shared
Mar 15 15:22:37: 4883 pages swap cached
Mar 15 15:22:37: 338 pages dirty
Mar 15 15:22:37: 0 pages writeback
Mar 15 15:22:37: 7463 pages mapped
Mar 15 15:22:37: 5865 pages slab
Mar 15 15:22:37: 284 pages pagetables
Mar 15 15:22:37: eth1: Can't allocate skb for Rx
