Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074Ab0BZKm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:42:28 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58220 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933944Ab0BZKmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:42:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=dtXajRO12y46fe3lXZoli+KyyPf7xmZ22M+chCby09sMROOLwMr1iurvRACIv3JoQB
         EMp9Ar9q4/aZqDhzOZHvIfwoxC6MqAOyyx07DxhhJtSwWFWjnPY+/vZHm9Q/4yH4mJbD
         2SqTYPT/0qKHjloT/btJU0l39XvP2IX5RItGs=
MIME-Version: 1.0
Date: Fri, 26 Feb 2010 11:42:22 +0100
Message-ID: <2d460de71002260242o50952e51sa9aee59d2b7bbe2e@mail.gmail.com>
Subject: New thread: page allocation failure with E1000 (seems to be 
	reproducible)
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: e1000-devel@lists.sf.net, linux-kernel@vger.kernel.org
Cc: Andrew Pochinsky <avp@MIT.EDU>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this is a re-send of my original email to e1000-devel@lists.sf.net. It
includes all information at once and is sent to LKML as well. I am
CC'ing Andrew Pochinsky because http://lkml.org/lkml/2008/6/10/3 is
related.



I deployed Bacula storage director (i.e. a backup target) on a machine
which has been running in test mode for some time, now. This past night
is the first one in which it received significant traffic from several
other machines, 62 in total.
My host has four Intel E1000 which are bonded into one virtual
interface. The other side is a Cisco 6500.

At 00:00, at a peak rate of 1.2 Gbit/s, I had ten(!) page allocation
failures within seconds:

# dmesg | grep __alloc_pages_nodemask
[290645.350781]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
[290645.351129]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
[290645.493159]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
[290645.508153]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
[290645.660543]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
[290645.661091]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
[290645.801266]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
[290645.818294]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
[290646.197948]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
[290646.206736]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
#

I am confident that I will be able to reproduce this issue, but did not
get around to trying, yet. As this is a critical system, the amount of
time I will have available to debug this may be limited.



Other relevant information:

The machine is a 64 bit Debian Lenny with almost current kernel:
Linux host 2.6.32.6 #3 SMP Tue Jan 26 12:39:17 CET 2010 x86_64 GNU/Linux

# lspci
00:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 13)
00:01.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
00:02.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 13)
00:02.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
00:06.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8111 PCI (rev 07)
00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-8111 LPC (rev 05)
00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03)
00:07.2 SMBus: Advanced Micro Devices [AMD] AMD-8111 SMBus 2.0 (rev 02)
00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-8111 ACPI (rev 05)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
01:01.0 Ethernet controller: Intel Corporation 82546EB Gigabit
Ethernet Controller (Copper) (rev 03)
01:01.1 Ethernet controller: Intel Corporation 82546EB Gigabit
Ethernet Controller (Copper) (rev 03)
01:02.0 Ethernet controller: Intel Corporation 82546EB Gigabit
Ethernet Controller (Copper) (rev 03)
01:02.1 Ethernet controller: Intel Corporation 82546EB Gigabit
Ethernet Controller (Copper) (rev 03)
02:03.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064
PCI-X Fusion-MPT SAS (rev 02)
03:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
03:00.1 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
03:03.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
04:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 13)
04:01.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
04:02.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 13)
04:02.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
05:01.0 Fibre Channel: QLogic Corp. ISP2312-based 2Gb Fibre Channel to
PCI-X HBA (rev 02)
06:01.0 Fibre Channel: QLogic Corp. ISP2312-based 2Gb Fibre Channel to
PCI-X HBA (rev 02)
# free
            total       used       free     shared    buffers     cached
Mem:      16343764   16285772      57992          0       8064   14963856
-/+ buffers/cache:    1313852   15029912
Swap:      2947888          0    2947888
# cat /proc/sys/vm/min_free_kbytes
16174
#




One full trace:

[290646.206726] swapper: page allocation failure. order:0, mode:0x20
[290646.206731] Pid: 0, comm: swapper Not tainted 2.6.32.6 #3
[290646.206734] Call Trace:
[290646.206736]  <IRQ>  [<ffffffff810afce1>] ?
__alloc_pages_nodemask+0x569/0x5e4
[290646.206750]  [<ffffffff810d88c7>] ? kmem_getpages+0x53/0x115
[290646.206753]  [<ffffffff810d8acb>] ? fallback_alloc+0x142/0x1bc
[290646.206756]  [<ffffffff810d8c53>] ? ____cache_alloc_node+0x10e/0x12d
[290646.206759]  [<ffffffff810d8d28>] ? kmem_cache_alloc_node+0xb6/0x12b
[290646.206762]  [<ffffffff810d8df9>] ? __kmalloc_node+0x5c/0xa7
[290646.206767]  [<ffffffff812a8333>] ? __alloc_skb+0x64/0x155
[290646.206771]  [<ffffffff812a8f1e>] ? __netdev_alloc_skb+0x29/0x43
[290646.206776]  [<ffffffff81258ec7>] ? e1000_alloc_rx_buffers+0x91/0x37f
[290646.206780]  [<ffffffff81258df4>] ? e1000_clean_rx_irq+0x3f1/0x433
[290646.206783]  [<ffffffff8125b7d9>] ? e1000_clean+0x2fa/0x49c
[290646.206786]  [<ffffffff812a3787>] ? sk_reset_timer+0xf/0x1d
[290646.206792]  [<ffffffff810316bb>] ? enqueue_task+0x5c/0x65
[290646.206796]  [<ffffffff81041057>] ? try_to_wake_up+0x249/0x259
[290646.206800]  [<ffffffff812aeb90>] ? net_rx_action+0xae/0x1c8
[290646.206804]  [<ffffffff8104a70d>] ? __do_softirq+0xdd/0x1a0
[290646.206808]  [<ffffffff8100cbac>] ? call_softirq+0x1c/0x28
[290646.206811]  [<ffffffff8100e6af>] ? do_softirq+0x3f/0x7c
[290646.206814]  [<ffffffff8104a4f7>] ? irq_exit+0x36/0x76
[290646.206817]  [<ffffffff8100dda6>] ? do_IRQ+0xa0/0xb6
[290646.206820]  [<ffffffff8100c3d3>] ? ret_from_intr+0x0/0x11
[290646.206821]  <EOI>  [<ffffffff810264e8>] ? native_safe_halt+0x2/0x3
[290646.206828]  [<ffffffff810128bc>] ? default_idle+0x4d/0x6a
[290646.206831]  [<ffffffff8100adf3>] ? cpu_idle+0x59/0x91
[290646.206833] Mem-Info:
[290646.206835] Node 0 DMA per-cpu:
[290646.206837] CPU    0: hi:    0, btch:   1 usd:   0
[290646.206839] CPU    1: hi:    0, btch:   1 usd:   0
[290646.206841] CPU    2: hi:    0, btch:   1 usd:   0
[290646.206843] CPU    3: hi:    0, btch:   1 usd:   0
[290646.206844] Node 0 DMA32 per-cpu:
[290646.206846] CPU    0: hi:  186, btch:  31 usd:  76
[290646.206848] CPU    1: hi:  186, btch:  31 usd: 176
[290646.206850] CPU    2: hi:  186, btch:  31 usd: 174
[290646.206852] CPU    3: hi:  186, btch:  31 usd:  30
[290646.206853] Node 0 Normal per-cpu:
[290646.206855] CPU    0: hi:  186, btch:  31 usd: 177
[290646.206857] CPU    1: hi:  186, btch:  31 usd: 191
[290646.206859] CPU    2: hi:  186, btch:  31 usd: 207
[290646.206861] CPU    3: hi:  186, btch:  31 usd: 190
[290646.206863] Node 1 Normal per-cpu:
[290646.206865] CPU    0: hi:  186, btch:  31 usd: 169
[290646.206867] CPU    1: hi:  186, btch:  31 usd: 177
[290646.206869] CPU    2: hi:  186, btch:  31 usd: 172
[290646.206871] CPU    3: hi:  186, btch:  31 usd: 183
[290646.206875] active_anon:22698 inactive_anon:4541 isolated_anon:0
[290646.206877]  active_file:1872862 inactive_file:2010018 isolated_file:1536
[290646.206878]  unevictable:802 dirty:419828 writeback:75264 unstable:0
[290646.206879]  free:9401 slab_reclaimable:120355 slab_unreclaimable:25492
[290646.206880]  mapped:3310 shmem:462 pagetables:931 bounce:0
[290646.206882] Node 0 DMA free:15828kB min:12kB low:12kB high:16kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15236kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclai
mable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? yes
[290646.206892] lowmem_reserve[]: 0 3832 7872 7872
[290646.206894] Node 0 DMA32 free:17608kB min:3880kB low:4848kB
high:5820kB active_anon:3584kB inactive_anon:1796kB
active_file:1755840kB inactive_file:1954080kB unevictable:0kB
isolated(anon):0kB isolated(file):256kB present:3924128kB mlocked:0kB
dirty:544516kB writeback:1
16544kB mapped:956kB shmem:0kB slab_reclaimable:108756kB
slab_unreclaimable:14424kB kernel_stack:1016kB pagetables:148kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:128
all_unreclaimable? no
[290646.206905] lowmem_reserve[]: 0 0 4040 4040
[290646.206907] Node 0 Normal free:1304kB min:4088kB low:5108kB
high:6132kB active_anon:57912kB inactive_anon:12316kB
active_file:1925272kB inactive_file:2011464kB unevictable:864kB
isolated(anon):0kB isolated(file):0kB present:4136960kB mlocked:864kB
dirty:336728kB writeba
ck:29384kB mapped:2264kB shmem:292kB slab_reclaimable:81880kB
slab_unreclaimable:69348kB kernel_stack:1552kB pagetables:2352kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0
all_unreclaimable? no
[290646.206917] lowmem_reserve[]: 0 0 0 0
[290646.206919] Node 1 Normal free:2864kB min:8180kB low:10224kB
high:12268kB active_anon:29296kB inactive_anon:4052kB
active_file:3810336kB inactive_file:4074528kB unevictable:2344kB
isolated(anon):0kB isolated(file):5888kB present:8273920kB
mlocked:2344kB dirty:798068kB w
riteback:155128kB mapped:10020kB shmem:1556kB
slab_reclaimable:290784kB slab_unreclaimable:18196kB
kernel_stack:912kB pagetables:1224kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:2656 all_unreclaimable? no
[290646.206929] lowmem_reserve[]: 0 0 0 0
[290646.206932] Node 0 DMA: 3*4kB 3*8kB 3*16kB 2*32kB 3*64kB 1*128kB
0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15828kB
[290646.206939] Node 0 DMA32: 2117*4kB 408*8kB 33*16kB 41*32kB 1*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 17732kB
[290646.206952] Node 0 Normal: 326*4kB 0*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1304kB
[290646.206959] Node 1 Normal: 107*4kB 0*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 2988kB
[290646.206967] 3885527 total pagecache pages
[290646.206970] 0 pages in swap cache
[290646.206971] Swap cache stats: add 0, delete 0, find 0/0
[290646.206973] Free swap  = 2947888kB
[290646.206974] Total swap = 2947888kB
[290646.201745] CPU    3: hi:  186, btch:  31 usd: 183
[290646.201745] active_anon:22698 inactive_anon:4541 isolated_anon:0
[290646.201745]  active_file:1872862 inactive_file:2010018 isolated_file:1536
[290646.201745]  unevictable:802 dirty:419828 writeback:75264 unstable:0
[290646.201745]  free:9401 slab_reclaimable:120355 slab_unreclaimable:25492
[290646.201745]  mapped:3310 shmem:462 pagetables:931 bounce:0
[290646.201745] Node 0 DMA free:15828kB min:12kB low:12kB high:16kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15236kB
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[290646.201745] lowmem_reserve[]: 0 3832 7872 7872
[290646.201745] Node 0 DMA32 free:17608kB min:3880kB low:4848kB
high:5820kB active_anon:3584kB inactive_anon:1796kB
active_file:1755840kB inactive_file:1954080kB unevictable:0kB
isolated(anon):0kB isolated(file):256kB present:3924128kB mlocked:0kB
dirty:544516kB writeback:116544kB mapped:956kB shmem:0kB
slab_reclaimable:108756kB slab_unreclaimable:14424kB
kernel_stack:1016kB pagetables:148kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:128 all_unreclaimable? no
[290646.201745] lowmem_reserve[]: 0 0 4040 4040
[290646.201745] Node 0 Normal free:1304kB min:4088kB low:5108kB
high:6132kB active_anon:57912kB inactive_anon:12316kB
active_file:1925272kB inactive_file:2011464kB unevictable:864kB
isolated(anon):0kB isolated(file):0kB present:4136960kB mlocked:864kB
dirty:336728kB writeback:29384kB mapped:2264kB shmem:292kB
slab_reclaimable:81880kB slab_unreclaimable:69348kB
kernel_stack:1552kB pagetables:2352kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[290646.201745] lowmem_reserve[]: 0 0 0 0
[290646.201745] Node 1 Normal free:2864kB min:8180kB low:10224kB
high:12268kB active_anon:29296kB inactive_anon:4052kB
active_file:3810336kB inactive_file:4074528kB unevictable:2344kB
isolated(anon):0kB isolated(file):5888kB present:8273920kB
mlocked:2344kB dirty:798068kB writeback:155128kB mapped:10020kB
shmem:1556kB slab_reclaimable:290784kB slab_unreclaimable:18196kB
kernel_stack:912kB pagetables:1224kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:2656 all_unreclaimable? no
[290646.201745] lowmem_reserve[]: 0 0 0 0
[290646.201745] Node 0 DMA: 3*4kB 3*8kB 3*16kB 2*32kB 3*64kB 1*128kB
0*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15828kB
[290646.201745] Node 0 DMA32: 2117*4kB 408*8kB 33*16kB 41*32kB 1*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 17732kB
[290646.201745] Node 0 Normal: 326*4kB 0*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1304kB
[290646.201745] Node 1 Normal: 107*4kB 0*8kB 0*16kB 0*32kB 0*64kB
0*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 2988kB
[290646.201745] 3885527 total pagecache pages
[290646.201745] 0 pages in swap cache
[290646.201745] Swap cache stats: add 0, delete 0, find 0/0
[290646.201745] Free swap  = 2947888kB
[290646.201745] Total swap = 2947888kB
[290646.210680] 4161520 pages RAM
[290646.210680] 75579 pages reserved
[290646.210680] 2540612 pages shared
[290646.210680] 1541353 pages non-shared
[290646.201745] 4161520 pages RAM
[290646.201745] 75579 pages reserved
[290646.201745] 2540611 pages shared
[290646.201745] 1541353 pages non-shared



I appreciate any and all input on this,
thanks,
Richard
