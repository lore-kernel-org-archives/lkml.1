Return-Path: <linux-kernel-owner+w=401wt.eu-S1763280AbXLQFoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763280AbXLQFoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 00:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbXLQFoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 00:44:04 -0500
Received: from capone.Concordia.CA ([132.205.7.82]:39101 "EHLO
	capone.concordia.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbXLQFn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 00:43:59 -0500
X-Greylist: delayed 1426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2007 00:43:58 EST
To: linux-kernel@vger.kernel.org
Cc: Sheila Ettinger <sheilae@alcor.concordia.ca>,
       Tan Bui <tan@alcor.concordia.ca>, Tao Wang <taow@alcor.concordia.ca>,
       Gillian Roper <groper@alcor.concordia.ca>,
       Sylvain Robitaille <syl@alcor.concordia.ca>
Subject: Re: 2.6.23.8: OOM killer kills wrong jobs 
From: Steven Winikoff <smw@alcor.concordia.ca>
References: <9xMQB-5XC-25@gated-at.bofh.it>, <9xHQH-6oR-5@gated-at.bofh.it>
In-reply-to: Your message of Fri, 07 Dec 2007 16:00:21 +0100
Reply-to: Steven Winikoff <smw@alcor.concordia.ca>
Date: Mon, 17 Dec 2007 00:20:09 -0500
Message-ID: <304323.1197868809@alcor.concordia.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In <9xMQB-5XC-25@gated-at.bofh.it>, Alan Cox wrote:

>You can either set no overcommit in which case you'll get failed malloc
>and similar rather than allow overcommit, or you can set the OOM priority
>of tasks yourself so that your specific app of choice always dies first.

This makes sense.

...but I've run into a situation in which a system on which I *have* set
no overcommit is being blasted by the OOM killer anyway.

First of all, here's why I believe I'm running in no overcommit mode:

   # sysctl vm.overcommit_memory vm.overcommit_ratio
   vm.overcommit_memory = 2
   vm.overcommit_ratio = 0

   # grep overcommit /etc/sysctl.conf
   vm.overcommit_memory = 2
   vm.overcommit_ratio  = 0

The machine in question is a Sun 4100 with two dual-core Opterons,
running Slackware 12 with kernel 2.6.23.1:

   # uname -a
   Linux babyalcor 2.6.23.1 #1 SMP Fri Oct 26 15:35:18 EDT 2007 \
    i686 Dual Core AMD Opteron(tm) Processor 280 AuthenticAMD GNU/Linux

...and has 16 Gb of memory, with 20 Gb of swap space in one partition:

   # free -m
                total    used    free  shared    buffers     cached
   Mem:         16119     219   15899       0         29        110
   -/+ buffers/cache:      79   16039
   Swap:        19532       0   19532

   # swapon -s
   Filename                Type            Size    Used    Priority
   /dev/sda2               partition       20000916        0       -1

This machine happens to have a root cron job which takes a vmstat sample
every ten minutes, of which this is a recent sample (all taken today, ie
2007/12/16, with apologies for the long lines):

   22:22:01:  0  0      0 15620400  27184  28340    0    0     0     5    3   32  0  0 100  0
   22:32:01:  0  0      0 15624760  26768  24168    0    0     0     5    3   28  0  0 100  0
   22:42:01:  0  0      0 14316272   9364 1330324    0    0     0  4507 2760 5386  6  1 89  3
   23:02:01:  0  0      0 16285128  27604 112600    0    0     0    14    4   38  0  0 100  0

The punch line is the appended sequence of log messages, which begins as
follows:

   Dec 16 22:45:06 babyalcor kernel: swapper: page allocation failure. \
                                     order:0, mode:0x20
   [...]
   Dec 16 22:45:11 babyalcor kernel: sendmail invoked oom-killer: \
                                     gfp_mask=0xd0, order=0, oomkilladj=0
   [...]
   Dec 16 22:45:14 babyalcor kernel: Out of memory: kill process 3489 \
                                     (named) score 4658 or a child
   Dec 16 22:45:14 babyalcor kernel: Killed process 3489 (named)
   [...]

The machine is currently almost 100% idle (it's a new server being
prepared to enter production use next weekend), and at the time the
problem occurred there was only one process actually doing anything.

Specifically, I was in the middle of copying a 4711 Mb tar archive from
another machine to this one via scp, so there would have been an sshd
process handling the scp initiated from the remote end.

This isn't the first time I've seen this behaviour; the same thing
happened on this machine while running a shell script that tried to
create 100,000 empty subdirectories of a single xfs directory, and on
a different but similarly configured machine I had a similar problem
running a find command at the root of a file system.

The common factor always seems to be significant disk activity, but
that's just a guess.

I'm not sure how I can be out of memory at all under these conditions,
but even assuming there's a good reason (running out of low memory?),
why isn't the system just killing the one process which triggered the
problem?

The real question is, am I misunderstanding what it means to configure
the kernel to prevent overcommitment, have I been running into a kernel
bug, or is there a third possibility I'm overlooking?

I'll be grateful for any advice I can get.  This system will be going
live in six days, and I need for it to be as stable as possible by then.

  Thanks,

     - Steven


The full sequence of log messags follows, and is in turn followed by
the current kernel configuration file for 2.6.23.1:

8<----------------------------   cut here   -------------------------->8
Dec 16 22:44:54 babyalcor kernel: printk: 60 messages suppressed.
Dec 16 22:45:06 babyalcor kernel: swapper: page allocation failure. order:0, mode:0x20
Dec 16 22:45:06 babyalcor kernel:  [<c014d629>] __alloc_pages+0x2d9/0x2f0
Dec 16 22:45:06 babyalcor kernel:  [<c0165633>] cache_alloc_refill+0x2d3/0x500
Dec 16 22:45:06 babyalcor kernel:  [<c0165930>] __kmalloc+0xd0/0xe0
Dec 16 22:45:06 babyalcor kernel:  [<c05922f3>] __alloc_skb+0x53/0x110
Dec 16 22:45:06 babyalcor kernel:  [<c0592f22>] __netdev_alloc_skb+0x22/0x50
Dec 16 22:45:06 babyalcor kernel:  [<c04369c8>] e1000_alloc_rx_buffers+0x178/0x380
Dec 16 22:45:06 babyalcor kernel:  [<c0436e8a>] e1000_clean_rx_irq+0x2ba/0x500
Dec 16 22:45:06 babyalcor kernel:  [<c0436bd0>] e1000_clean_rx_irq+0x0/0x500
Dec 16 22:45:06 babyalcor kernel:  [<c0435a9c>] e1000_clean+0x27c/0x5f0
Dec 16 22:45:06 babyalcor kernel:  [<c0136f42>] ktime_get_ts+0x22/0x60
Dec 16 22:45:06 babyalcor kernel:  [<c013ac82>] clockevents_program_event+0x92/0x110
Dec 16 22:45:06 babyalcor kernel:  [<c013bdf4>] tick_program_event+0x44/0x70
Dec 16 22:45:06 babyalcor kernel:  [<c05992be>] net_rx_action+0x6e/0x160
Dec 16 22:45:06 babyalcor kernel:  [<c0125842>] __do_softirq+0x82/0x100
Dec 16 22:45:06 babyalcor kernel:  [<c01258f7>] do_softirq+0x37/0x40
Dec 16 22:45:06 babyalcor kernel:  [<c0125b35>] irq_exit+0x75/0x80
Dec 16 22:45:06 babyalcor kernel:  [<c0105510>] do_IRQ+0x40/0x80
Dec 16 22:45:06 babyalcor kernel:  [<c010f607>] smp_apic_timer_interrupt+0x57/0x90
Dec 16 22:45:06 babyalcor kernel:  [<c010351f>] common_interrupt+0x23/0x28
Dec 16 22:45:06 babyalcor kernel:  [<c0101790>] default_idle+0x0/0x40
Dec 16 22:45:06 babyalcor kernel:  [<c01017bf>] default_idle+0x2f/0x40
Dec 16 22:45:06 babyalcor kernel:  [<c0100d71>] cpu_idle+0x61/0x80
Dec 16 22:45:06 babyalcor kernel:  =======================
Dec 16 22:45:06 babyalcor kernel: Mem-info:
Dec 16 22:45:06 babyalcor kernel: DMA per-cpu:
Dec 16 22:45:07 babyalcor kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:07 babyalcor kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:07 babyalcor kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:07 babyalcor kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:07 babyalcor kernel: Normal per-cpu:
Dec 16 22:45:07 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Dec 16 22:45:07 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  57
Dec 16 22:45:07 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  50
Dec 16 22:45:07 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Dec 16 22:45:07 babyalcor kernel: HighMem per-cpu:
Dec 16 22:45:07 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  18   Cold: hi:   62, btch:  15 usd:   2
Dec 16 22:45:07 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  12
Dec 16 22:45:07 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:   4
Dec 16 22:45:07 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   5
Dec 16 22:45:07 babyalcor kernel: Active:133550 inactive:410980 dirty:809 writeback:0 unstable:0
Dec 16 22:45:07 babyalcor kernel:  free:3385692 slab:12070 mapped:2129 pagetables:386 bounce:0
Dec 16 22:45:07 babyalcor kernel: DMA free:3520kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:17 all_unreclaimable? yes
Dec 16 22:45:07 babyalcor kernel: lowmem_reserve[]: 0 873 16240 16240
Dec 16 22:45:07 babyalcor kernel: Normal free:1296kB min:3744kB low:4680kB high:5616kB active:184kB inactive:356kB present:894080kB pages_scanned:1964 all_unreclaimable? yes
Dec 16 22:45:07 babyalcor kernel: lowmem_reserve[]: 0 0 122936 122936
Dec 16 22:45:07 babyalcor kernel: HighMem free:13537952kB min:512kB low:17000kB high:33492kB active:534012kB inactive:1643564kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Dec 16 22:45:07 babyalcor kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 22:45:07 babyalcor kernel: DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Dec 16 22:45:07 babyalcor kernel: Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1296kB
Dec 16 22:45:07 babyalcor kernel: HighMem: 0*4kB 0*8kB 0*16kB 1*32kB 0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 3305*4096kB = 13537952kB
Dec 16 22:45:08 babyalcor kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Dec 16 22:45:08 babyalcor kernel: Free swap  = 20000916kB
Dec 16 22:45:08 babyalcor kernel: Total swap = 20000916kB
Dec 16 22:45:08 babyalcor kernel: Free swap:       20000916kB
Dec 16 22:45:08 babyalcor kernel: 4194304 pages of RAM
Dec 16 22:45:08 babyalcor kernel: 3964928 pages of HIGHMEM
Dec 16 22:45:08 babyalcor kernel: 67779 reserved pages
Dec 16 22:45:08 babyalcor kernel: 543155 pages shared
Dec 16 22:45:08 babyalcor kernel: 0 pages swap cached
Dec 16 22:45:08 babyalcor kernel: 809 pages dirty
Dec 16 22:45:08 babyalcor kernel: 0 pages writeback
Dec 16 22:45:08 babyalcor kernel: 2129 pages mapped
Dec 16 22:45:08 babyalcor kernel: 12070 pages slab
Dec 16 22:45:08 babyalcor kernel: 386 pages pagetables
Dec 16 22:45:08 babyalcor kernel: swapper: page allocation failure. order:0, mode:0x20
Dec 16 22:45:08 babyalcor kernel:  [<c014d629>] __alloc_pages+0x2d9/0x2f0
Dec 16 22:45:08 babyalcor kernel:  [<c0165633>] cache_alloc_refill+0x2d3/0x500
Dec 16 22:45:08 babyalcor kernel:  [<c0165930>] __kmalloc+0xd0/0xe0
Dec 16 22:45:08 babyalcor kernel:  [<c05922f3>] __alloc_skb+0x53/0x110
Dec 16 22:45:08 babyalcor kernel:  [<c0592f22>] __netdev_alloc_skb+0x22/0x50
Dec 16 22:45:08 babyalcor kernel:  [<c04369c8>] e1000_alloc_rx_buffers+0x178/0x380
Dec 16 22:45:08 babyalcor kernel:  [<c0436ebd>] e1000_clean_rx_irq+0x2ed/0x500
Dec 16 22:45:08 babyalcor kernel:  [<c0436bd0>] e1000_clean_rx_irq+0x0/0x500
Dec 16 22:45:08 babyalcor kernel:  [<c0435a9c>] e1000_clean+0x27c/0x5f0
Dec 16 22:45:08 babyalcor kernel:  [<c05c64d4>] tcp_transmit_skb+0x3c4/0x750
Dec 16 22:45:08 babyalcor kernel:  [<c0136f42>] ktime_get_ts+0x22/0x60
Dec 16 22:45:08 babyalcor kernel:  [<c013ac82>] clockevents_program_event+0x92/0x110
Dec 16 22:45:08 babyalcor kernel:  [<c05c996f>] tcp_delack_timer+0x13f/0x1c0
Dec 16 22:45:08 babyalcor kernel:  [<c05992be>] net_rx_action+0x6e/0x160
Dec 16 22:45:08 babyalcor kernel:  [<c0125842>] __do_softirq+0x82/0x100
Dec 16 22:45:08 babyalcor kernel:  [<c01258f7>] do_softirq+0x37/0x40
Dec 16 22:45:08 babyalcor kernel:  [<c0125b35>] irq_exit+0x75/0x80
Dec 16 22:45:08 babyalcor kernel:  [<c0105510>] do_IRQ+0x40/0x80
Dec 16 22:45:08 babyalcor kernel:  [<c010f607>] smp_apic_timer_interrupt+0x57/0x90
Dec 16 22:45:08 babyalcor kernel:  [<c010351f>] common_interrupt+0x23/0x28
Dec 16 22:45:08 babyalcor kernel:  [<c0101790>] default_idle+0x0/0x40
Dec 16 22:45:08 babyalcor kernel:  [<c01017bf>] default_idle+0x2f/0x40
Dec 16 22:45:08 babyalcor kernel:  [<c0100d71>] cpu_idle+0x61/0x80
Dec 16 22:45:08 babyalcor kernel:  =======================
Dec 16 22:45:08 babyalcor kernel: Mem-info:
Dec 16 22:45:08 babyalcor kernel: DMA per-cpu:
Dec 16 22:45:08 babyalcor kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:09 babyalcor kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:09 babyalcor kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:09 babyalcor kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:09 babyalcor kernel: Normal per-cpu:
Dec 16 22:45:09 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Dec 16 22:45:09 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  57
Dec 16 22:45:09 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  50
Dec 16 22:45:09 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Dec 16 22:45:09 babyalcor kernel: HighMem per-cpu:
Dec 16 22:45:09 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  18   Cold: hi:   62, btch:  15 usd:   2
Dec 16 22:45:09 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  12
Dec 16 22:45:09 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:   4
Dec 16 22:45:09 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   5
Dec 16 22:45:09 babyalcor kernel: Active:133543 inactive:410982 dirty:809 writeback:0 unstable:0
Dec 16 22:45:09 babyalcor kernel:  free:3385692 slab:12070 mapped:2129 pagetables:386 bounce:0
Dec 16 22:45:09 babyalcor kernel: DMA free:3520kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:17 all_unreclaimable? yes
Dec 16 22:45:09 babyalcor kernel: lowmem_reserve[]: 0 873 16240 16240
Dec 16 22:45:09 babyalcor kernel: Normal free:1296kB min:3744kB low:4680kB high:5616kB active:156kB inactive:364kB present:894080kB pages_scanned:1964 all_unreclaimable? yes
Dec 16 22:45:09 babyalcor kernel: lowmem_reserve[]: 0 0 122936 122936
Dec 16 22:45:09 babyalcor kernel: HighMem free:13537952kB min:512kB low:17000kB high:33492kB active:534012kB inactive:1643564kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Dec 16 22:45:09 babyalcor kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 22:45:09 babyalcor kernel: DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Dec 16 22:45:09 babyalcor kernel: Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1296kB
Dec 16 22:45:09 babyalcor kernel: HighMem: 0*4kB 0*8kB 0*16kB 1*32kB 0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 3305*4096kB = 13537952kB
Dec 16 22:45:09 babyalcor kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Dec 16 22:45:09 babyalcor kernel: Free swap  = 20000916kB
Dec 16 22:45:09 babyalcor kernel: Total swap = 20000916kB
Dec 16 22:45:09 babyalcor kernel: Free swap:       20000916kB
Dec 16 22:45:09 babyalcor kernel: 4194304 pages of RAM
Dec 16 22:45:09 babyalcor kernel: 3964928 pages of HIGHMEM
Dec 16 22:45:09 babyalcor kernel: 67779 reserved pages
Dec 16 22:45:09 babyalcor kernel: 543155 pages shared
Dec 16 22:45:09 babyalcor kernel: 0 pages swap cached
Dec 16 22:45:09 babyalcor kernel: 809 pages dirty
Dec 16 22:45:09 babyalcor kernel: 0 pages writeback
Dec 16 22:45:09 babyalcor kernel: 2129 pages mapped
Dec 16 22:45:09 babyalcor kernel: 12070 pages slab
Dec 16 22:45:09 babyalcor kernel: 386 pages pagetables
Dec 16 22:45:09 babyalcor kernel: swapper: page allocation failure. order:0, mode:0x20
Dec 16 22:45:09 babyalcor kernel:  [<c014d629>] __alloc_pages+0x2d9/0x2f0
Dec 16 22:45:09 babyalcor kernel:  [<c0165633>] cache_alloc_refill+0x2d3/0x500
Dec 16 22:45:09 babyalcor kernel:  [<c0165930>] __kmalloc+0xd0/0xe0
Dec 16 22:45:10 babyalcor kernel:  [<c05922f3>] __alloc_skb+0x53/0x110
Dec 16 22:45:10 babyalcor kernel:  [<c0592f22>] __netdev_alloc_skb+0x22/0x50
Dec 16 22:45:10 babyalcor kernel:  [<c04369c8>] e1000_alloc_rx_buffers+0x178/0x380
Dec 16 22:45:10 babyalcor kernel:  [<c0436ebd>] e1000_clean_rx_irq+0x2ed/0x500
Dec 16 22:45:10 babyalcor kernel:  [<c0436bd0>] e1000_clean_rx_irq+0x0/0x500
Dec 16 22:45:10 babyalcor kernel:  [<c0435a9c>] e1000_clean+0x27c/0x5f0
Dec 16 22:45:10 babyalcor kernel:  [<c05c64d4>] tcp_transmit_skb+0x3c4/0x750
Dec 16 22:45:10 babyalcor kernel:  [<c0136f42>] ktime_get_ts+0x22/0x60
Dec 16 22:45:10 babyalcor kernel:  [<c013ac82>] clockevents_program_event+0x92/0x110
Dec 16 22:45:10 babyalcor kernel:  [<c05c996f>] tcp_delack_timer+0x13f/0x1c0
Dec 16 22:45:10 babyalcor kernel:  [<c05992be>] net_rx_action+0x6e/0x160
Dec 16 22:45:10 babyalcor kernel:  [<c0125842>] __do_softirq+0x82/0x100
Dec 16 22:45:10 babyalcor kernel:  [<c01258f7>] do_softirq+0x37/0x40
Dec 16 22:45:10 babyalcor kernel:  [<c0125b35>] irq_exit+0x75/0x80
Dec 16 22:45:10 babyalcor kernel:  [<c0105510>] do_IRQ+0x40/0x80
Dec 16 22:45:10 babyalcor kernel:  [<c010f607>] smp_apic_timer_interrupt+0x57/0x90
Dec 16 22:45:10 babyalcor kernel:  [<c010351f>] common_interrupt+0x23/0x28
Dec 16 22:45:10 babyalcor kernel:  [<c0101790>] default_idle+0x0/0x40
Dec 16 22:45:10 babyalcor kernel:  [<c01017bf>] default_idle+0x2f/0x40
Dec 16 22:45:10 babyalcor kernel:  [<c0100d71>] cpu_idle+0x61/0x80
Dec 16 22:45:10 babyalcor kernel:  =======================
Dec 16 22:45:10 babyalcor kernel: Mem-info:
Dec 16 22:45:10 babyalcor kernel: DMA per-cpu:
Dec 16 22:45:10 babyalcor kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:10 babyalcor kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:10 babyalcor kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:10 babyalcor kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:10 babyalcor kernel: Normal per-cpu:
Dec 16 22:45:10 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Dec 16 22:45:10 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  57
Dec 16 22:45:10 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  50
Dec 16 22:45:10 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Dec 16 22:45:10 babyalcor kernel: HighMem per-cpu:
Dec 16 22:45:10 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  18   Cold: hi:   62, btch:  15 usd:   2
Dec 16 22:45:10 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  12
Dec 16 22:45:10 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:   4
Dec 16 22:45:10 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   5
Dec 16 22:45:10 babyalcor kernel: Active:133543 inactive:410982 dirty:809 writeback:0 unstable:0
Dec 16 22:45:10 babyalcor kernel:  free:3385692 slab:12070 mapped:2129 pagetables:386 bounce:0
Dec 16 22:45:10 babyalcor kernel: DMA free:3520kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:17 all_unreclaimable? yes
Dec 16 22:45:11 babyalcor kernel: lowmem_reserve[]: 0 873 16240 16240
Dec 16 22:45:11 babyalcor kernel: Normal free:1296kB min:3744kB low:4680kB high:5616kB active:156kB inactive:364kB present:894080kB pages_scanned:1964 all_unreclaimable? yes
Dec 16 22:45:11 babyalcor kernel: lowmem_reserve[]: 0 0 122936 122936
Dec 16 22:45:11 babyalcor kernel: HighMem free:13537952kB min:512kB low:17000kB high:33492kB active:534012kB inactive:1643564kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Dec 16 22:45:11 babyalcor kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 22:45:11 babyalcor kernel: DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Dec 16 22:45:11 babyalcor kernel: Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1296kB
Dec 16 22:45:11 babyalcor kernel: HighMem: 0*4kB 0*8kB 0*16kB 1*32kB 0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 3305*4096kB = 13537952kB
Dec 16 22:45:11 babyalcor kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Dec 16 22:45:11 babyalcor kernel: Free swap  = 20000916kB
Dec 16 22:45:11 babyalcor kernel: Total swap = 20000916kB
Dec 16 22:45:11 babyalcor kernel: Free swap:       20000916kB
Dec 16 22:45:11 babyalcor kernel: sendmail invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Dec 16 22:45:11 babyalcor kernel:  [<c014bc78>] out_of_memory+0x188/0x1c0
Dec 16 22:45:11 babyalcor kernel:  [<c014d5f1>] __alloc_pages+0x2a1/0x2f0
Dec 16 22:45:11 babyalcor kernel:  [<c016bb38>] cp_new_stat64+0xf8/0x110
Dec 16 22:45:11 babyalcor kernel:  [<c014d68a>] __get_free_pages+0x4a/0x60
Dec 16 22:45:11 babyalcor kernel:  [<c01a4198>] proc_file_read+0x98/0x290
Dec 16 22:45:11 babyalcor kernel:  [<c01a4100>] proc_file_read+0x0/0x290
Dec 16 22:45:11 babyalcor kernel:  [<c01a055e>] proc_reg_read+0x5e/0x90
Dec 16 22:45:11 babyalcor kernel:  [<c016918c>] vfs_read+0xbc/0x160
Dec 16 22:45:11 babyalcor kernel:  [<c01a0500>] proc_reg_read+0x0/0x90
Dec 16 22:45:11 babyalcor kernel:  [<c01696c1>] sys_read+0x41/0x70
Dec 16 22:45:11 babyalcor kernel:  [<c0102b76>] syscall_call+0x7/0xb
Dec 16 22:45:11 babyalcor kernel:  =======================
Dec 16 22:45:11 babyalcor kernel: Mem-info:
Dec 16 22:45:11 babyalcor kernel: DMA per-cpu:
Dec 16 22:45:11 babyalcor kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:11 babyalcor kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:11 babyalcor kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:11 babyalcor kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:11 babyalcor kernel: Normal per-cpu:
Dec 16 22:45:11 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Dec 16 22:45:11 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  57
Dec 16 22:45:11 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  50
Dec 16 22:45:11 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Dec 16 22:45:11 babyalcor kernel: HighMem per-cpu:
Dec 16 22:45:11 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  18   Cold: hi:   62, btch:  15 usd:   2
Dec 16 22:45:11 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  12
Dec 16 22:45:12 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:   4
Dec 16 22:45:12 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   5
Dec 16 22:45:12 babyalcor kernel: Active:133543 inactive:410982 dirty:809 writeback:0 unstable:0
Dec 16 22:45:12 babyalcor kernel:  free:3385692 slab:12070 mapped:2129 pagetables:386 bounce:0
Dec 16 22:45:12 babyalcor kernel: DMA free:3520kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:17 all_unreclaimable? yes
Dec 16 22:45:12 babyalcor kernel: lowmem_reserve[]: 0 873 16240 16240
Dec 16 22:45:12 babyalcor kernel: Normal free:1296kB min:3744kB low:4680kB high:5616kB active:156kB inactive:364kB present:894080kB pages_scanned:1964 all_unreclaimable? yes
Dec 16 22:45:12 babyalcor kernel: lowmem_reserve[]: 0 0 122936 122936
Dec 16 22:45:12 babyalcor kernel: HighMem free:13537952kB min:512kB low:17000kB high:33492kB active:534012kB inactive:1643564kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Dec 16 22:45:12 babyalcor kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 22:45:12 babyalcor kernel: DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Dec 16 22:45:12 babyalcor kernel: Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1296kB
Dec 16 22:45:12 babyalcor kernel: HighMem: 0*4kB 0*8kB 0*16kB 1*32kB 0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 3305*4096kB = 13537952kB
Dec 16 22:45:12 babyalcor kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Dec 16 22:45:12 babyalcor kernel: Free swap  = 20000916kB
Dec 16 22:45:12 babyalcor kernel: Total swap = 20000916kB
Dec 16 22:45:12 babyalcor kernel: Free swap:       20000916kB
Dec 16 22:45:12 babyalcor kernel: 4194304 pages of RAM
Dec 16 22:45:12 babyalcor kernel: 3964928 pages of HIGHMEM
Dec 16 22:45:12 babyalcor kernel: 67779 reserved pages
Dec 16 22:45:12 babyalcor kernel: 543155 pages shared
Dec 16 22:45:12 babyalcor kernel: 0 pages swap cached
Dec 16 22:45:12 babyalcor kernel: 809 pages dirty
Dec 16 22:45:12 babyalcor kernel: 0 pages writeback
Dec 16 22:45:12 babyalcor kernel: 2129 pages mapped
Dec 16 22:45:12 babyalcor kernel: 12070 pages slab
Dec 16 22:45:12 babyalcor kernel: 386 pages pagetables
Dec 16 22:45:12 babyalcor kernel: swapper: page allocation failure. order:0, mode:0x20
Dec 16 22:45:12 babyalcor kernel:  [<c014d629>] __alloc_pages+0x2d9/0x2f0
Dec 16 22:45:12 babyalcor kernel:  [<c0165633>] cache_alloc_refill+0x2d3/0x500
Dec 16 22:45:12 babyalcor kernel:  [<c0165930>] __kmalloc+0xd0/0xe0
Dec 16 22:45:12 babyalcor kernel:  [<c05922f3>] __alloc_skb+0x53/0x110
Dec 16 22:45:12 babyalcor kernel:  [<c0592f22>] __netdev_alloc_skb+0x22/0x50
Dec 16 22:45:12 babyalcor kernel:  [<c04369c8>] e1000_alloc_rx_buffers+0x178/0x380
Dec 16 22:45:12 babyalcor kernel:  [<c0436e8a>] e1000_clean_rx_irq+0x2ba/0x500
Dec 16 22:45:12 babyalcor kernel:  [<c0436bd0>] e1000_clean_rx_irq+0x0/0x500
Dec 16 22:45:12 babyalcor kernel:  [<c0435a9c>] e1000_clean+0x27c/0x5f0
Dec 16 22:45:12 babyalcor kernel:  [<c05c64d4>] tcp_transmit_skb+0x3c4/0x750
Dec 16 22:45:12 babyalcor kernel:  [<c0136f42>] ktime_get_ts+0x22/0x60
Dec 16 22:45:12 babyalcor kernel:  [<c013ac82>] clockevents_program_event+0x92/0x110
Dec 16 22:45:12 babyalcor kernel:  [<c05c996f>] tcp_delack_timer+0x13f/0x1c0
Dec 16 22:45:12 babyalcor kernel:  [<c05992be>] net_rx_action+0x6e/0x160
Dec 16 22:45:12 babyalcor kernel:  [<c0125842>] __do_softirq+0x82/0x100
Dec 16 22:45:13 babyalcor kernel:  [<c01258f7>] do_softirq+0x37/0x40
Dec 16 22:45:13 babyalcor kernel:  [<c0125b35>] irq_exit+0x75/0x80
Dec 16 22:45:13 babyalcor kernel:  [<c0105510>] do_IRQ+0x40/0x80
Dec 16 22:45:13 babyalcor kernel:  [<c010f607>] smp_apic_timer_interrupt+0x57/0x90
Dec 16 22:45:13 babyalcor kernel:  [<c010351f>] common_interrupt+0x23/0x28
Dec 16 22:45:13 babyalcor kernel:  [<c0101790>] default_idle+0x0/0x40
Dec 16 22:45:13 babyalcor kernel:  [<c01017bf>] default_idle+0x2f/0x40
Dec 16 22:45:13 babyalcor kernel:  [<c0100d71>] cpu_idle+0x61/0x80
Dec 16 22:45:13 babyalcor kernel:  =======================
Dec 16 22:45:13 babyalcor kernel: Mem-info:
Dec 16 22:45:13 babyalcor kernel: DMA per-cpu:
Dec 16 22:45:13 babyalcor kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:13 babyalcor kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:13 babyalcor kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:13 babyalcor kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:13 babyalcor kernel: Normal per-cpu:
Dec 16 22:45:13 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Dec 16 22:45:13 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  57
Dec 16 22:45:13 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  50
Dec 16 22:45:13 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Dec 16 22:45:13 babyalcor kernel: HighMem per-cpu:
Dec 16 22:45:13 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  18   Cold: hi:   62, btch:  15 usd:   2
Dec 16 22:45:13 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  12
Dec 16 22:45:13 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:   4
Dec 16 22:45:13 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   5
Dec 16 22:45:13 babyalcor kernel: Active:133543 inactive:410982 dirty:809 writeback:0 unstable:0
Dec 16 22:45:13 babyalcor kernel:  free:3385692 slab:12070 mapped:2129 pagetables:386 bounce:0
Dec 16 22:45:13 babyalcor kernel: DMA free:3520kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:17 all_unreclaimable? yes
Dec 16 22:45:13 babyalcor kernel: lowmem_reserve[]: 0 873 16240 16240
Dec 16 22:45:13 babyalcor kernel: Normal free:1296kB min:3744kB low:4680kB high:5616kB active:156kB inactive:364kB present:894080kB pages_scanned:1964 all_unreclaimable? yes
Dec 16 22:45:13 babyalcor kernel: lowmem_reserve[]: 0 0 122936 122936
Dec 16 22:45:13 babyalcor kernel: HighMem free:13537952kB min:512kB low:17000kB high:33492kB active:534012kB inactive:1643564kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Dec 16 22:45:13 babyalcor kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 22:45:13 babyalcor kernel: DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Dec 16 22:45:13 babyalcor kernel: Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1296kB
Dec 16 22:45:13 babyalcor kernel: HighMem: 0*4kB 0*8kB 0*16kB 1*32kB 0*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 3305*4096kB = 13537952kB
Dec 16 22:45:13 babyalcor kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Dec 16 22:45:13 babyalcor kernel: Free swap  = 20000916kB
Dec 16 22:45:13 babyalcor kernel: Total swap = 20000916kB
Dec 16 22:45:13 babyalcor kernel: Free swap:       20000916kB
Dec 16 22:45:13 babyalcor kernel: 4194304 pages of RAM
Dec 16 22:45:14 babyalcor kernel: 3964928 pages of HIGHMEM
Dec 16 22:45:14 babyalcor kernel: 67779 reserved pages
Dec 16 22:45:14 babyalcor kernel: 543155 pages shared
Dec 16 22:45:14 babyalcor kernel: 0 pages swap cached
Dec 16 22:45:14 babyalcor kernel: 809 pages dirty
Dec 16 22:45:14 babyalcor kernel: 0 pages writeback
Dec 16 22:45:14 babyalcor kernel: 2129 pages mapped
Dec 16 22:45:14 babyalcor kernel: 12070 pages slab
Dec 16 22:45:14 babyalcor kernel: 386 pages pagetables
Dec 16 22:45:14 babyalcor kernel: Out of memory: kill process 3489 (named) score 4658 or a child
Dec 16 22:45:14 babyalcor kernel: Killed process 3489 (named)
Dec 16 22:45:14 babyalcor kernel: sendmail invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Dec 16 22:45:14 babyalcor kernel:  [<c014bc78>] out_of_memory+0x188/0x1c0
Dec 16 22:45:14 babyalcor kernel:  [<c014d5f1>] __alloc_pages+0x2a1/0x2f0
Dec 16 22:45:14 babyalcor kernel:  [<c016bb38>] cp_new_stat64+0xf8/0x110
Dec 16 22:45:14 babyalcor kernel:  [<c014d68a>] __get_free_pages+0x4a/0x60
Dec 16 22:45:14 babyalcor kernel:  [<c01a4198>] proc_file_read+0x98/0x290
Dec 16 22:45:14 babyalcor kernel:  [<c01a4100>] proc_file_read+0x0/0x290
Dec 16 22:45:14 babyalcor kernel:  [<c01a055e>] proc_reg_read+0x5e/0x90
Dec 16 22:45:14 babyalcor kernel:  [<c016918c>] vfs_read+0xbc/0x160
Dec 16 22:45:14 babyalcor kernel:  [<c01a0500>] proc_reg_read+0x0/0x90
Dec 16 22:45:14 babyalcor kernel:  [<c01696c1>] sys_read+0x41/0x70
Dec 16 22:45:14 babyalcor kernel:  [<c0102b76>] syscall_call+0x7/0xb
Dec 16 22:45:14 babyalcor kernel:  =======================
Dec 16 22:45:14 babyalcor kernel: Mem-info:
Dec 16 22:45:14 babyalcor kernel: DMA per-cpu:
Dec 16 22:45:14 babyalcor kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:14 babyalcor kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:14 babyalcor kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:14 babyalcor kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:14 babyalcor kernel: Normal per-cpu:
Dec 16 22:45:14 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Dec 16 22:45:14 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  57
Dec 16 22:45:14 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  50
Dec 16 22:45:14 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Dec 16 22:45:14 babyalcor kernel: HighMem per-cpu:
Dec 16 22:45:15 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 186   Cold: hi:   62, btch:  15 usd:   2
Dec 16 22:45:15 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  12
Dec 16 22:45:15 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:   4
Dec 16 22:45:15 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   5
Dec 16 22:45:15 babyalcor kernel: Active:133146 inactive:411010 dirty:809 writeback:0 unstable:0
Dec 16 22:45:15 babyalcor kernel:  free:3385937 slab:12070 mapped:2056 pagetables:386 bounce:0
Dec 16 22:45:15 babyalcor kernel: DMA free:3520kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:19 all_unreclaimable? yes
Dec 16 22:45:15 babyalcor kernel: lowmem_reserve[]: 0 873 16240 16240
Dec 16 22:45:15 babyalcor kernel: Normal free:1296kB min:3744kB low:4680kB high:5616kB active:28kB inactive:476kB present:894080kB pages_scanned:1996 all_unreclaimable? yes
Dec 16 22:45:15 babyalcor kernel: lowmem_reserve[]: 0 0 122936 122936
Dec 16 22:45:15 babyalcor kernel: HighMem free:13538932kB min:512kB low:17000kB high:33492kB active:532260kB inactive:1643564kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Dec 16 22:45:15 babyalcor kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 22:45:15 babyalcor kernel: DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Dec 16 22:45:15 babyalcor kernel: Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1296kB
Dec 16 22:45:15 babyalcor kernel: HighMem: 49*4kB 27*8kB 20*16kB 7*32kB 3*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 3305*4096kB = 13539068kB
Dec 16 22:45:15 babyalcor kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Dec 16 22:45:15 babyalcor kernel: Free swap  = 20000916kB
Dec 16 22:45:15 babyalcor kernel: Total swap = 20000916kB
Dec 16 22:45:15 babyalcor kernel: Free swap:       20000916kB
Dec 16 22:45:15 babyalcor kernel: init invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Dec 16 22:45:15 babyalcor kernel:  [<c014bc78>] out_of_memory+0x188/0x1c0
Dec 16 22:45:15 babyalcor kernel:  [<c014d5f1>] __alloc_pages+0x2a1/0x2f0
Dec 16 22:45:15 babyalcor kernel:  [<c0107dbf>] convert_fxsr_to_user+0xdf/0x190
Dec 16 22:45:15 babyalcor kernel:  [<c0165633>] cache_alloc_refill+0x2d3/0x500
Dec 16 22:45:15 babyalcor kernel:  [<c0165338>] kmem_cache_alloc+0x68/0x90
Dec 16 22:45:15 babyalcor kernel:  [<c01715d8>] getname+0x28/0xe0
Dec 16 22:45:15 babyalcor kernel:  [<c017349e>] __user_walk_fd+0x1e/0x60
Dec 16 22:45:15 babyalcor kernel:  [<c016bf12>] vfs_stat_fd+0x22/0x60
Dec 16 22:45:15 babyalcor kernel:  [<c0107c16>] convert_fxsr_from_user+0x16/0xe0
Dec 16 22:45:15 babyalcor kernel:  [<c0108120>] restore_i387+0xf0/0x100
Dec 16 22:45:15 babyalcor kernel:  [<c016bfff>] sys_stat64+0xf/0x30
Dec 16 22:45:15 babyalcor kernel:  [<c01029d1>] sys_sigreturn+0xf1/0x174
Dec 16 22:45:15 babyalcor kernel:  [<c011b5b0>] default_wake_function+0x0/0x10
Dec 16 22:45:15 babyalcor kernel:  [<c01389f6>] getnstimeofday+0x36/0xd0
Dec 16 22:45:15 babyalcor kernel:  [<c012553f>] sys_time+0xf/0x30
Dec 16 22:45:15 babyalcor kernel:  [<c0102b76>] syscall_call+0x7/0xb
Dec 16 22:45:15 babyalcor kernel:  =======================
Dec 16 22:45:15 babyalcor kernel: Mem-info:
Dec 16 22:45:15 babyalcor kernel: DMA per-cpu:
Dec 16 22:45:15 babyalcor kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:15 babyalcor kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:15 babyalcor kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:16 babyalcor kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:16 babyalcor kernel: Normal per-cpu:
Dec 16 22:45:16 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Dec 16 22:45:16 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  57
Dec 16 22:45:16 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  50
Dec 16 22:45:16 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Dec 16 22:45:16 babyalcor kernel: HighMem per-cpu:
Dec 16 22:45:16 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:   2
Dec 16 22:45:16 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  12
Dec 16 22:45:16 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:   4
Dec 16 22:45:16 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   5
Dec 16 22:45:16 babyalcor kernel: Active:123948 inactive:411010 dirty:809 writeback:0 unstable:0
Dec 16 22:45:16 babyalcor kernel:  free:3395100 slab:12070 mapped:1764 pagetables:386 bounce:0
Dec 16 22:45:16 babyalcor kernel: DMA free:3520kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:19 all_unreclaimable? yes
Dec 16 22:45:16 babyalcor kernel: lowmem_reserve[]: 0 873 16240 16240
Dec 16 22:45:16 babyalcor kernel: Normal free:1296kB min:3744kB low:4680kB high:5616kB active:28kB inactive:476kB present:894080kB pages_scanned:1996 all_unreclaimable? yes
Dec 16 22:45:16 babyalcor kernel: lowmem_reserve[]: 0 0 122936 122936
Dec 16 22:45:16 babyalcor kernel: HighMem free:13575584kB min:512kB low:17000kB high:33492kB active:495760kB inactive:1643564kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Dec 16 22:45:16 babyalcor kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 22:45:16 babyalcor kernel: DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Dec 16 22:45:16 babyalcor kernel: Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1296kB
Dec 16 22:45:16 babyalcor kernel: HighMem: 2447*4kB 318*8kB 151*16kB 124*32kB 61*64kB 40*128kB 18*256kB 6*512kB 3*1024kB 0*2048kB 3305*4096kB = 13575772kB
Dec 16 22:45:16 babyalcor kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Dec 16 22:45:16 babyalcor kernel: Free swap  = 20000916kB
Dec 16 22:45:16 babyalcor kernel: Total swap = 20000916kB
Dec 16 22:45:16 babyalcor kernel: Free swap:       20000916kB
Dec 16 22:45:16 babyalcor kernel: 4194304 pages of RAM
Dec 16 22:45:16 babyalcor kernel: 3964928 pages of HIGHMEM
Dec 16 22:45:16 babyalcor kernel: 67779 reserved pages
Dec 16 22:45:16 babyalcor kernel: 542628 pages shared
Dec 16 22:45:16 babyalcor kernel: 0 pages swap cached
Dec 16 22:45:16 babyalcor kernel: 809 pages dirty
Dec 16 22:45:16 babyalcor kernel: 0 pages writeback
Dec 16 22:45:16 babyalcor kernel: 1764 pages mapped
Dec 16 22:45:16 babyalcor kernel: 12070 pages slab
Dec 16 22:45:16 babyalcor kernel: 386 pages pagetables
Dec 16 22:45:16 babyalcor kernel: swapper: page allocation failure. order:0, mode:0x20
Dec 16 22:45:16 babyalcor kernel:  [<c014d629>] __alloc_pages+0x2d9/0x2f0
Dec 16 22:45:16 babyalcor kernel:  [<c0165633>] cache_alloc_refill+0x2d3/0x500
Dec 16 22:45:16 babyalcor kernel:  [<c0165930>] __kmalloc+0xd0/0xe0
Dec 16 22:45:16 babyalcor kernel:  [<c05922f3>] __alloc_skb+0x53/0x110
Dec 16 22:45:16 babyalcor kernel:  [<c0592f22>] __netdev_alloc_skb+0x22/0x50
Dec 16 22:45:17 babyalcor kernel:  [<c04369c8>] e1000_alloc_rx_buffers+0x178/0x380
Dec 16 22:45:17 babyalcor kernel:  [<c0436ebd>] e1000_clean_rx_irq+0x2ed/0x500
Dec 16 22:45:17 babyalcor kernel:  [<c0436bd0>] e1000_clean_rx_irq+0x0/0x500
Dec 16 22:45:17 babyalcor kernel:  [<c0435a9c>] e1000_clean+0x27c/0x5f0
Dec 16 22:45:17 babyalcor kernel:  [<c05c64d4>] tcp_transmit_skb+0x3c4/0x750
Dec 16 22:45:17 babyalcor kernel:  [<c0136f42>] ktime_get_ts+0x22/0x60
Dec 16 22:45:17 babyalcor kernel:  [<c013ac82>] clockevents_program_event+0x92/0x110
Dec 16 22:45:17 babyalcor kernel:  [<c05c996f>] tcp_delack_timer+0x13f/0x1c0
Dec 16 22:45:17 babyalcor kernel:  [<c05992be>] net_rx_action+0x6e/0x160
Dec 16 22:45:17 babyalcor kernel:  [<c0125842>] __do_softirq+0x82/0x100
Dec 16 22:45:17 babyalcor kernel:  [<c01258f7>] do_softirq+0x37/0x40
Dec 16 22:45:17 babyalcor kernel:  [<c0125b35>] irq_exit+0x75/0x80
Dec 16 22:45:17 babyalcor kernel:  [<c0105510>] do_IRQ+0x40/0x80
Dec 16 22:45:17 babyalcor kernel:  [<c010f607>] smp_apic_timer_interrupt+0x57/0x90
Dec 16 22:45:17 babyalcor kernel:  [<c010351f>] common_interrupt+0x23/0x28
Dec 16 22:45:17 babyalcor kernel:  [<c0101790>] default_idle+0x0/0x40
Dec 16 22:45:17 babyalcor kernel:  [<c01017bf>] default_idle+0x2f/0x40
Dec 16 22:45:17 babyalcor kernel:  [<c0100d71>] cpu_idle+0x61/0x80
Dec 16 22:45:17 babyalcor kernel:  =======================
Dec 16 22:45:17 babyalcor kernel: Mem-info:
Dec 16 22:45:17 babyalcor kernel: DMA per-cpu:
Dec 16 22:45:17 babyalcor kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:17 babyalcor kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:17 babyalcor kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:17 babyalcor kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:17 babyalcor kernel: Normal per-cpu:
Dec 16 22:45:17 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Dec 16 22:45:17 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  57
Dec 16 22:45:17 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  50
Dec 16 22:45:17 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Dec 16 22:45:17 babyalcor kernel: HighMem per-cpu:
Dec 16 22:45:17 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 165   Cold: hi:   62, btch:  15 usd:   2
Dec 16 22:45:17 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  16   Cold: hi:   62, btch:  15 usd:  12
Dec 16 22:45:17 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:   4
Dec 16 22:45:17 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   5
Dec 16 22:45:17 babyalcor kernel: Active:123948 inactive:411010 dirty:809 writeback:0 unstable:0
Dec 16 22:45:17 babyalcor kernel:  free:3395100 slab:12070 mapped:1764 pagetables:386 bounce:0
Dec 16 22:45:17 babyalcor kernel: DMA free:3520kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:19 all_unreclaimable? yes
Dec 16 22:45:17 babyalcor kernel: lowmem_reserve[]: 0 873 16240 16240
Dec 16 22:45:17 babyalcor kernel: Normal free:1296kB min:3744kB low:4680kB high:5616kB active:28kB inactive:476kB present:894080kB pages_scanned:1996 all_unreclaimable? yes
Dec 16 22:45:18 babyalcor kernel: lowmem_reserve[]: 0 0 122936 122936
Dec 16 22:45:18 babyalcor kernel: HighMem free:13575584kB min:512kB low:17000kB high:33492kB active:495760kB inactive:1643564kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Dec 16 22:45:18 babyalcor kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 22:45:18 babyalcor kernel: DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Dec 16 22:45:18 babyalcor kernel: Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1296kB
Dec 16 22:45:18 babyalcor kernel: HighMem: 2447*4kB 318*8kB 151*16kB 124*32kB 61*64kB 40*128kB 18*256kB 6*512kB 3*1024kB 0*2048kB 3305*4096kB = 13575772kB
Dec 16 22:45:18 babyalcor kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Dec 16 22:45:18 babyalcor kernel: Free swap  = 20000916kB
Dec 16 22:45:18 babyalcor kernel: Total swap = 20000916kB
Dec 16 22:45:18 babyalcor kernel: Free swap:       20000916kB
Dec 16 22:45:18 babyalcor kernel: 4194304 pages of RAM
Dec 16 22:45:18 babyalcor kernel: 3964928 pages of HIGHMEM
Dec 16 22:45:18 babyalcor kernel: 67779 reserved pages
Dec 16 22:45:18 babyalcor kernel: 542582 pages shared
Dec 16 22:45:18 babyalcor kernel: 0 pages swap cached
Dec 16 22:45:18 babyalcor kernel: 809 pages dirty
Dec 16 22:45:18 babyalcor kernel: 0 pages writeback
Dec 16 22:45:18 babyalcor kernel: 1764 pages mapped
Dec 16 22:45:18 babyalcor kernel: 12070 pages slab
Dec 16 22:45:18 babyalcor kernel: 386 pages pagetables
Dec 16 22:45:18 babyalcor kernel: Out of memory: kill process 3592 (in.identd) score 4259 or a child
Dec 16 22:45:18 babyalcor kernel: Killed process 3592 (in.identd)
Dec 16 22:45:18 babyalcor kernel: inetd invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Dec 16 22:45:18 babyalcor kernel:  [<c014bc78>] out_of_memory+0x188/0x1c0
Dec 16 22:45:18 babyalcor kernel:  [<c014d5f1>] __alloc_pages+0x2a1/0x2f0
Dec 16 22:45:18 babyalcor kernel:  [<c0165633>] cache_alloc_refill+0x2d3/0x500
Dec 16 22:45:18 babyalcor kernel:  [<c0165338>] kmem_cache_alloc+0x68/0x90
Dec 16 22:45:18 babyalcor kernel:  [<c01715d8>] getname+0x28/0xe0
Dec 16 22:45:18 babyalcor kernel:  [<c01671ae>] do_sys_open+0x1e/0xe0
Dec 16 22:45:18 babyalcor kernel:  [<c01672ac>] sys_open+0x1c/0x20
Dec 16 22:45:18 babyalcor kernel:  [<c0102b76>] syscall_call+0x7/0xb
Dec 16 22:45:18 babyalcor kernel:  =======================
Dec 16 22:45:18 babyalcor kernel: Mem-info:
Dec 16 22:45:18 babyalcor kernel: DMA per-cpu:
Dec 16 22:45:18 babyalcor kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:18 babyalcor kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:18 babyalcor kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:18 babyalcor kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:18 babyalcor kernel: Normal per-cpu:
Dec 16 22:45:19 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Dec 16 22:45:19 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  57
Dec 16 22:45:19 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  50
Dec 16 22:45:19 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Dec 16 22:45:19 babyalcor kernel: HighMem per-cpu:
Dec 16 22:45:19 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15 usd:   2
Dec 16 22:45:19 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 110   Cold: hi:   62, btch:  15 usd:  12
Dec 16 22:45:19 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:   4
Dec 16 22:45:19 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   5
Dec 16 22:45:19 babyalcor kernel: Active:123912 inactive:410978 dirty:809 writeback:0 unstable:0
Dec 16 22:45:19 babyalcor kernel:  free:3395100 slab:12070 mapped:1764 pagetables:386 bounce:0
Dec 16 22:45:19 babyalcor kernel: DMA free:3520kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:19 all_unreclaimable? yes
Dec 16 22:45:19 babyalcor kernel: lowmem_reserve[]: 0 873 16240 16240
Dec 16 22:45:19 babyalcor kernel: Normal free:1296kB min:3744kB low:4680kB high:5616kB active:176kB inactive:348kB present:894080kB pages_scanned:2028 all_unreclaimable? yes
Dec 16 22:45:19 babyalcor kernel: lowmem_reserve[]: 0 0 122936 122936
Dec 16 22:45:19 babyalcor kernel: HighMem free:13575584kB min:512kB low:17000kB high:33492kB active:495468kB inactive:1643564kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Dec 16 22:45:19 babyalcor kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 22:45:19 babyalcor kernel: DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Dec 16 22:45:19 babyalcor kernel: Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1296kB
Dec 16 22:45:19 babyalcor kernel: HighMem: 2447*4kB 318*8kB 151*16kB 124*32kB 61*64kB 40*128kB 18*256kB 6*512kB 3*1024kB 0*2048kB 3305*4096kB = 13575772kB
Dec 16 22:45:19 babyalcor kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Dec 16 22:45:19 babyalcor kernel: Free swap  = 20000916kB
Dec 16 22:45:19 babyalcor kernel: Total swap = 20000916kB
Dec 16 22:45:19 babyalcor kernel: Free swap:       20000916kB
Dec 16 22:45:19 babyalcor kernel: 4194304 pages of RAM
Dec 16 22:45:19 babyalcor kernel: 3964928 pages of HIGHMEM
Dec 16 22:45:19 babyalcor kernel: 67779 reserved pages
Dec 16 22:45:19 babyalcor kernel: 542440 pages shared
Dec 16 22:45:19 babyalcor kernel: 0 pages swap cached
Dec 16 22:45:19 babyalcor kernel: 809 pages dirty
Dec 16 22:45:19 babyalcor kernel: 0 pages writeback
Dec 16 22:45:19 babyalcor kernel: 1764 pages mapped
Dec 16 22:45:19 babyalcor kernel: 12070 pages slab
Dec 16 22:45:19 babyalcor kernel: 386 pages pagetables
Dec 16 22:45:19 babyalcor kernel: Out of memory: kill process 8149 (tcsh) score 1121 or a child
Dec 16 22:45:19 babyalcor kernel: Killed process 8162 (scp)
Dec 16 22:45:19 babyalcor kernel: 4194304 pages of RAM
Dec 16 22:45:19 babyalcor kernel: 3964928 pages of HIGHMEM
Dec 16 22:45:19 babyalcor kernel: 67779 reserved pages
Dec 16 22:45:19 babyalcor kernel: 542440 pages shared
Dec 16 22:45:19 babyalcor kernel: 0 pages swap cached
Dec 16 22:45:20 babyalcor kernel: 809 pages dirty
Dec 16 22:45:20 babyalcor kernel: 0 pages writeback
Dec 16 22:45:20 babyalcor kernel: 1764 pages mapped
Dec 16 22:45:20 babyalcor kernel: 12070 pages slab
Dec 16 22:45:20 babyalcor kernel: 386 pages pagetables
Dec 16 22:45:20 babyalcor kernel: swapper: page allocation failure. order:0, mode:0x20
Dec 16 22:45:20 babyalcor kernel:  [<c014d629>] __alloc_pages+0x2d9/0x2f0
Dec 16 22:45:20 babyalcor kernel:  [<c0165633>] cache_alloc_refill+0x2d3/0x500
Dec 16 22:45:20 babyalcor kernel:  [<c0165930>] __kmalloc+0xd0/0xe0
Dec 16 22:45:20 babyalcor kernel:  [<c05922f3>] __alloc_skb+0x53/0x110
Dec 16 22:45:20 babyalcor kernel:  [<c0592f22>] __netdev_alloc_skb+0x22/0x50
Dec 16 22:45:20 babyalcor kernel:  [<c04369c8>] e1000_alloc_rx_buffers+0x178/0x380
Dec 16 22:45:20 babyalcor kernel:  [<c0436ebd>] e1000_clean_rx_irq+0x2ed/0x500
Dec 16 22:45:20 babyalcor kernel:  [<c0436bd0>] e1000_clean_rx_irq+0x0/0x500
Dec 16 22:45:20 babyalcor kernel:  [<c0435a9c>] e1000_clean+0x27c/0x5f0
Dec 16 22:45:20 babyalcor kernel:  [<c05c64d4>] tcp_transmit_skb+0x3c4/0x750
Dec 16 22:45:20 babyalcor kernel:  [<c0136f42>] ktime_get_ts+0x22/0x60
Dec 16 22:45:20 babyalcor kernel:  [<c013ac82>] clockevents_program_event+0x92/0x110
Dec 16 22:45:20 babyalcor kernel:  [<c05c996f>] tcp_delack_timer+0x13f/0x1c0
Dec 16 22:45:20 babyalcor kernel:  [<c05992be>] net_rx_action+0x6e/0x160
Dec 16 22:45:20 babyalcor kernel:  [<c0125842>] __do_softirq+0x82/0x100
Dec 16 22:45:20 babyalcor kernel:  [<c01258f7>] do_softirq+0x37/0x40
Dec 16 22:45:20 babyalcor kernel:  [<c0125b35>] irq_exit+0x75/0x80
Dec 16 22:45:20 babyalcor kernel:  [<c0105510>] do_IRQ+0x40/0x80
Dec 16 22:45:20 babyalcor kernel:  [<c010f607>] smp_apic_timer_interrupt+0x57/0x90
Dec 16 22:45:20 babyalcor kernel:  [<c010351f>] common_interrupt+0x23/0x28
Dec 16 22:45:20 babyalcor kernel:  [<c0101790>] default_idle+0x0/0x40
Dec 16 22:45:20 babyalcor kernel:  [<c01017bf>] default_idle+0x2f/0x40
Dec 16 22:45:20 babyalcor kernel:  [<c0100d71>] cpu_idle+0x61/0x80
Dec 16 22:45:20 babyalcor kernel:  =======================
Dec 16 22:45:20 babyalcor kernel: Mem-info:
Dec 16 22:45:20 babyalcor kernel: DMA per-cpu:
Dec 16 22:45:20 babyalcor kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:20 babyalcor kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:20 babyalcor kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:20 babyalcor kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Dec 16 22:45:20 babyalcor kernel: Normal per-cpu:
Dec 16 22:45:20 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  59
Dec 16 22:45:20 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  26   Cold: hi:   62, btch:  15 usd:  57
Dec 16 22:45:20 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 143   Cold: hi:   62, btch:  15 usd:  50
Dec 16 22:45:20 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  61
Dec 16 22:45:21 babyalcor kernel: HighMem per-cpu:
Dec 16 22:45:21 babyalcor kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 163   Cold: hi:   62, btch:  15 usd:   2
Dec 16 22:45:21 babyalcor kernel: CPU    1: Hot: hi:  186, btch:  31 usd: 110   Cold: hi:   62, btch:  15 usd:  12
Dec 16 22:45:21 babyalcor kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  20   Cold: hi:   62, btch:  15 usd:   4
Dec 16 22:45:21 babyalcor kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  23   Cold: hi:   62, btch:  15 usd:   5
Dec 16 22:45:21 babyalcor kernel: Active:123912 inactive:410978 dirty:809 writeback:0 unstable:0
Dec 16 22:45:21 babyalcor kernel:  free:3395100 slab:12070 mapped:1764 pagetables:386 bounce:0
Dec 16 22:45:21 babyalcor kernel: DMA free:3520kB min:68kB low:84kB high:100kB active:4kB inactive:0kB present:16256kB pages_scanned:19 all_unreclaimable? yes
Dec 16 22:45:21 babyalcor kernel: lowmem_reserve[]: 0 873 16240 16240
Dec 16 22:45:21 babyalcor kernel: Normal free:1296kB min:3744kB low:4680kB high:5616kB active:176kB inactive:348kB present:894080kB pages_scanned:2028 all_unreclaimable? yes
Dec 16 22:45:21 babyalcor kernel: lowmem_reserve[]: 0 0 122936 122936
Dec 16 22:45:21 babyalcor kernel: HighMem free:13575584kB min:512kB low:17000kB high:33492kB active:495468kB inactive:1643564kB present:15735808kB pages_scanned:0 all_unreclaimable? no
Dec 16 22:45:21 babyalcor kernel: lowmem_reserve[]: 0 0 0 0
Dec 16 22:45:21 babyalcor kernel: DMA: 0*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Dec 16 22:45:21 babyalcor kernel: Normal: 0*4kB 0*8kB 1*16kB 0*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1296kB
Dec 16 22:45:21 babyalcor kernel: HighMem: 2447*4kB 318*8kB 151*16kB 124*32kB 61*64kB 40*128kB 18*256kB 6*512kB 3*1024kB 0*2048kB 3305*4096kB = 13575772kB
Dec 16 22:45:21 babyalcor kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
Dec 16 22:45:21 babyalcor kernel: Free swap  = 20000916kB
Dec 16 22:45:21 babyalcor kernel: Total swap = 20000916kB
Dec 16 22:45:21 babyalcor kernel: Free swap:       20000916kB
Dec 16 22:45:21 babyalcor kernel: 4194304 pages of RAM
Dec 16 22:45:21 babyalcor kernel: 3964928 pages of HIGHMEM
Dec 16 22:45:21 babyalcor kernel: 67779 reserved pages
Dec 16 22:45:21 babyalcor kernel: 542349 pages shared
Dec 16 22:45:21 babyalcor kernel: 0 pages swap cached
Dec 16 22:45:21 babyalcor kernel: 809 pages dirty
Dec 16 22:45:21 babyalcor kernel: 0 pages writeback
Dec 16 22:45:21 babyalcor kernel: 1764 pages mapped
Dec 16 22:45:21 babyalcor kernel: 12070 pages slab
Dec 16 22:45:21 babyalcor kernel: 386 pages pagetables
Dec 16 22:45:21 babyalcor kernel: 4194304 pages of RAM
Dec 16 22:45:21 babyalcor kernel: 3964928 pages of HIGHMEM
Dec 16 22:45:21 babyalcor kernel: 67779 reserved pages
Dec 16 22:45:21 babyalcor kernel: 542349 pages shared
Dec 16 22:45:21 babyalcor kernel: 0 pages swap cached
Dec 16 22:45:21 babyalcor kernel: 809 pages dirty
Dec 16 22:45:21 babyalcor kernel: 0 pages writeback
Dec 16 22:45:21 babyalcor kernel: 1764 pages mapped
Dec 16 22:45:21 babyalcor kernel: 12070 pages slab
Dec 16 22:45:21 babyalcor kernel: 386 pages pagetables
Dec 16 22:45:21 babyalcor kernel: Out of memory: kill process 9681 (sshd) score 1003 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 9726 (tcsh)
Dec 16 22:45:22 babyalcor kernel: Out of memory: kill process 9844 (httpd) score 950 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 9844 (httpd)
Dec 16 22:45:22 babyalcor kernel: Out of memory: kill process 9846 (httpd) score 950 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 9846 (httpd)
Dec 16 22:45:22 babyalcor kernel: Out of memory: kill process 9847 (httpd) score 950 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 9847 (httpd)
Dec 16 22:45:22 babyalcor kernel: Out of memory: kill process 9848 (httpd) score 950 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 9848 (httpd)
Dec 16 22:45:22 babyalcor kernel: Out of memory: kill process 9849 (httpd) score 950 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 9849 (httpd)
Dec 16 22:45:22 babyalcor kernel: Out of memory: kill process 10840 (httpd) score 950 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 10840 (httpd)
Dec 16 22:45:22 babyalcor kernel: Out of memory: kill process 9607 (sshd) score 801 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 9607 (sshd)
Dec 16 22:45:22 babyalcor kernel: Out of memory: kill process 9681 (sshd) score 801 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 9681 (sshd)
Dec 16 22:45:22 babyalcor kernel: Out of memory: kill process 15784 (sshd) score 694 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 15873 (tcsh)
Dec 16 22:45:22 babyalcor kernel: Out of memory: kill process 15785 (sshd) score 680 or a child
Dec 16 22:45:22 babyalcor kernel: Killed process 15870 (tcsh)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 15783 (sshd) score 669 or a child
Dec 16 22:45:23 babyalcor kernel: Killed process 15872 (tcsh)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 1852 (sshd) score 669 or a child
Dec 16 22:45:23 babyalcor kernel: Killed process 1881 (tcsh)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 6423 (sshd) score 669 or a child
Dec 16 22:45:23 babyalcor kernel: Killed process 6456 (tcsh)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 8148 (sshd) score 606 or a child
Dec 16 22:45:23 babyalcor kernel: Killed process 8148 (sshd)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 15784 (sshd) score 559 or a child
Dec 16 22:45:23 babyalcor kernel: Killed process 15784 (sshd)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 15785 (sshd) score 545 or a child
Dec 16 22:45:23 babyalcor kernel: Killed process 15785 (sshd)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 15783 (sshd) score 534 or a child
Dec 16 22:45:23 babyalcor kernel: Killed process 15783 (sshd)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 1852 (sshd) score 534 or a child
Dec 16 22:45:23 babyalcor kernel: Killed process 1852 (sshd)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 6423 (sshd) score 534 or a child
Dec 16 22:45:23 babyalcor kernel: Killed process 6423 (sshd)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 28479 (sshd) score 489 or a child
Dec 16 22:45:23 babyalcor kernel: Killed process 28480 (tcsh)
Dec 16 22:45:23 babyalcor kernel: Out of memory: kill process 3726 (sshd) score 408 or a child
Dec 16 22:45:24 babyalcor kernel: Killed process 3737 (tcsh)
Dec 16 22:45:24 babyalcor kernel: Out of memory: kill process 3736 (sshd) score 408 or a child
Dec 16 22:45:24 babyalcor kernel: Killed process 3749 (tcsh)
Dec 16 22:45:24 babyalcor kernel: Out of memory: kill process 3739 (sshd) score 407 or a child
Dec 16 22:45:24 babyalcor kernel: Killed process 3769 (tcsh)
Dec 16 22:45:24 babyalcor kernel: Out of memory: kill process 3740 (sshd) score 407 or a child
Dec 16 22:45:24 babyalcor kernel: Killed process 3819 (tcsh)
Dec 16 22:45:24 babyalcor kernel: Out of memory: kill process 13530 (sshd) score 401 or a child
Dec 16 22:45:24 babyalcor kernel: Killed process 13571 (tcsh)
Dec 16 22:45:24 babyalcor kernel: Out of memory: kill process 28479 (sshd) score 400 or a child
Dec 16 22:45:24 babyalcor kernel: Killed process 28479 (sshd)
Dec 16 22:45:24 babyalcor kernel: Out of memory: kill process 28479 (sshd) score 400 or a child
Dec 16 22:45:24 babyalcor kernel: Killed process 28479 (sshd)
Dec 16 22:45:24 babyalcor kernel: Out of memory: kill process 3726 (sshd) score 327 or a child
Dec 16 22:45:24 babyalcor kernel: Killed process 3726 (sshd)
Dec 16 22:45:24 babyalcor kernel: Out of memory: kill process 3736 (sshd) score 327 or a child
Dec 16 22:45:24 babyalcor kernel: Killed process 3736 (sshd)
Dec 16 22:45:24 babyalcor kernel: Out of memory: kill process 3739 (sshd) score 326 or a child
Dec 16 22:45:24 babyalcor kernel: Killed process 3739 (sshd)
Dec 16 22:45:24 babyalcor kernel: Out of memory: kill process 3740 (sshd) score 325 or a child
Dec 16 22:45:25 babyalcor kernel: Out of memory: kill process 3740 (sshd) score 325 or a child
Dec 16 22:45:25 babyalcor kernel: Killed process 3740 (sshd)
Dec 16 22:45:25 babyalcor kernel: Killed process 3740 (sshd)
Dec 16 22:45:25 babyalcor kernel: Out of memory: kill process 13530 (sshd) score 320 or a child
Dec 16 22:45:25 babyalcor kernel: Out of memory: kill process 13530 (sshd) score 320 or a child
Dec 16 22:45:25 babyalcor kernel: Killed process 13530 (sshd)
Dec 16 22:45:25 babyalcor kernel: Killed process 13530 (sshd)
Dec 16 22:45:25 babyalcor kernel: Out of memory: kill process 3554 (sendmail) score 226 or a child
Dec 16 22:45:25 babyalcor kernel: Killed process 3554 (sendmail)
Dec 16 22:45:25 babyalcor kernel: Out of memory: kill process 3625 (tcsh) score 161 or a child
Dec 16 22:45:25 babyalcor kernel: Killed process 3625 (tcsh)
Dec 16 22:45:25 babyalcor kernel: Out of memory: kill process 3485 (sshd) score 132 or a child
Dec 16 22:45:25 babyalcor kernel: Killed process 3723 (sshd)
Dec 16 22:45:25 babyalcor kernel: Out of memory: kill process 3485 (sshd) score 132 or a child
Dec 16 22:45:25 babyalcor kernel: Killed process 3723 (sshd)
Dec 16 22:45:25 babyalcor kernel: Out of memory: kill process 3485 (sshd) score 122 or a child
Dec 16 22:45:25 babyalcor kernel: Killed process 3725 (sshd)
Dec 16 22:45:25 babyalcor kernel: Out of memory: kill process 3485 (sshd) score 122 or a child
Dec 16 22:45:25 babyalcor kernel: Killed process 3725 (sshd)
8<----------------------------   cut here   -------------------------->8


8<----------------------------   cut here   -------------------------->8
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.23.1
# Mon Oct 15 18:39:23 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CPUSETS is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_LSF=y
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_PARAVIRT is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
CONFIG_MK8=y
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_NR_CPUS=16
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
# CONFIG_IRQBALANCE is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
# CONFIG_PM_DEBUG is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATION_SMP_POSSIBLE=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=m
CONFIG_ACPI_BAY=m
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_ASUS=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K6=m
CONFIG_X86_POWERNOW_K7=m
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_POWERNOW_K8_ACPI=y
CONFIG_X86_GX_SUSPMOD=m
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=m
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=m
CONFIG_X86_CPUFREQ_NFORCE2=m
CONFIG_X86_LONGRUN=m
CONFIG_X86_LONGHAUL=m
CONFIG_X86_E_POWERSAVER=m

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
CONFIG_K8_NB=y

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK_ENABLED=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
# CONFIG_NF_CT_PROTO_UDPLITE is not set
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_IPRANGE=m
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_SAME=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_SHARE_IRQ=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
# CONFIG_IDEDMA_ONLYDISK is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
# CONFIG_IDE_ARM is not set
# CONFIG_IDE_CHIPSETS is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_IVB is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_DPT_I2O=y
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_SCSI_QLA_ISCSI is not set
CONFIG_SCSI_LPFC=y
# CONFIG_SCSI_SEAGATE is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_ISAPNP is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_WINBOND_VLB is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=y
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set

#
# Fusion MPT device support
#
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_OHCI1394=y

#
# Protocols
#
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_RAWIO is not set
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=y
CONFIG_BONDING=y
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=m
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET_MII=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=m
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_NET_FC=y
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
# CONFIG_SERIAL_8250_ACCENT is not set
# CONFIG_SERIAL_8250_BOCA is not set
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
# CONFIG_SERIAL_8250_HUB6 is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_SC520_WDT=m
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_SC1200_WDT=m
CONFIG_PC87413_WDT=m
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC37B787_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=m
CONFIG_MIXCOMWD=m
CONFIG_WDT=m
# CONFIG_WDT_501 is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_NVRAM=y
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_I810=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_PROSAVAGE=m
CONFIG_I2C_SAVAGE4=m
# CONFIG_I2C_SIMTEC is not set
CONFIG_SCx200_ACB=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
CONFIG_I2C_VOODOO3=m
CONFIG_I2C_PCA_ISA=m

#
# Miscellaneous I2C Chip support
#
CONFIG_SENSORS_DS1337=m
CONFIG_SENSORS_DS1374=m
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8574=m
CONFIG_SENSORS_PCA9539=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_MAX6875=m
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_PROGEAR=m

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
CONFIG_VGASTATE=m
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
CONFIG_FB_VESA=y
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
CONFIG_MDA_CONSOLE=m
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
# CONFIG_LOGO is not set

#
# Sound
#
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
CONFIG_USB_HIDDEV=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_SPLIT_ISO is not set
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
# CONFIG_MMC_BLOCK is not set

#
# MMC/SD Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_M48T86=m
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#

#
# DMA Engine support
#
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4DEV_FS=y
CONFIG_EXT4DEV_FS_XATTR=y
CONFIG_EXT4DEV_FS_POSIX_ACL=y
CONFIG_EXT4DEV_FS_SECURITY=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_SECURITY=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_NOLOCK=y
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_MINIX_FS=y
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=y

#
# Distributed Lock Manager
#
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set
# CONFIG_INSTRUMENTATION is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_EARLY_PRINTK=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_TEST is not set
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
8<----------------------------   cut here   -------------------------->8
________________________________________________________________________
Steven Winikoff                | "For a successful technology, reality  
Concordia University           |  must take precedence over public
Montreal, QC, Canada           |  relations, for Nature cannot be
smw@alcor.concordia.ca         |  fooled."  - Richard Feynman, 
http://alcor.concordia.ca/~smw |     Appendix F, _The_Challenger_Report_
