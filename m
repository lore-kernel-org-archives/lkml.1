Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbZDEKMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbZDEKMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 06:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbZDEKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 06:12:40 -0400
Received: from newton.gmurray.org.uk ([81.2.114.237]:50519 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZDEKMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 06:12:39 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 newton.gmurray.org.uk n35ACZD7012938
From: Graham Murray <graham@gmurray.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: Regression caused by commit "netfilter: iptables: lock free counters"
References: <20090329234702.4988017f@desktop.r000n.info>
	<8763hja8cy.fsf@newton.gmurray.org.uk>
	<20090405.012237.198610462.davem@davemloft.net>
	<49D88162.5040809@cosmosbay.com>
X-Hashcash: 1:22:090405:linux-kernel@vger.kernel.org::y+4ubKEA7fjXVhm8:0000000000000000000000000000000004FD1
Date: Sun, 05 Apr 2009 11:12:35 +0100
In-Reply-To: <49D88162.5040809@cosmosbay.com> (Eric Dumazet's message of "Sun,
	05 Apr 2009 12:01:06 +0200")
Message-ID: <87ws9z8l4c.fsf@newton.gmurray.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> writes:

>>>> 784544739a25c30637397ace5489eeb6e15d7d49 is first bad commit
>>>> commit 784544739a25c30637397ace5489eeb6e15d7d49             
>>> I am seeing a different problem which also bisects to this commit. There are
>>> no kernel messages but ip6tables fails to run.
>>>
>>> newton ~ # ip6tables -L -v
>>> FATAL: Module ip6_tables not found.
>>> ip6tables v1.4.3.1: can't initialize ip6tables table `filter': Memory allocation problem
>>> Perhaps ip6tables or your kernel needs to be upgraded.
>>>
>>> I get this error no matter which ip6tables sub-command I run. Ip6tables
>>> is built into the kernel, not as modules.
>>>
>>> An strace shows the failure to be 
>>> socket(PF_INET6, SOCK_RAW, IPPROTO_RAW) = 3
>>> getsockopt(3, SOL_IPV6, 0x40 /* IPV6_??? */, "filter\0\305\0w~\300\0wb\305P\24\312\t\0009b\305\216\23\0\0\310\341/g\16"..., [84]) = 0
>>> brk(0)                                  = 0x8273000
>>> brk(0x8294000)                          = 0x8294000
>
> so ip6tables allocates about 128 Kbytes of ram in order to get rules from kernel.
>
>>> getsockopt(3, SOL_IPV6, 0x41 /* IPV6_??? */, 0x8273090, 0xbfd23628) = -1 ENOMEM (Cannot allocate memory)
>>> close(3)                                = 0
>>>
>
>
> This is a big problem yes, since "iptables|ip6tables" -L needs to allocate kernel memory
> to perform the momentary swap.
>
> On x86, this is potentially a problem if vmalloc space is exhausted or fragmented,
> (or lowmem exhausted) and/or many cpus are online/possible.

iptables gives me no problems at all, it is just ip6tables that
fails. The first indication of this is during the init scripts when
ip6tables-restore fails.

> Graham, could you please give us :
>
> # cat /proc/vmallocinfo
> # cat /proc/meminfo

newton ~ # cat /proc/vmallocinfo     
0xf81fe000-0xf8200000    8192 hpet_enable+0x2f/0x272 phys=fed00000 ioremap
0xf8202000-0xf8204000    8192 acpi_os_map_memory+0x24/0x3e phys=bff8e000 ioremap
0xf8206000-0xf8208000    8192 acpi_os_map_memory+0x24/0x3e phys=bff8e000 ioremap
0xf820a000-0xf820c000    8192 acpi_os_map_memory+0x24/0x3e phys=bff8e000 ioremap
0xf820e000-0xf8210000    8192 acpi_os_map_memory+0x24/0x3e phys=bff89000 ioremap
0xf8210000-0xf821b000   45056 acpi_os_map_memory+0x24/0x3e phys=bff80000 ioremap
0xf821c000-0xf821e000    8192 acpi_os_map_memory+0x24/0x3e phys=bff80000 ioremap
0xf8220000-0xf8222000    8192 acpi_os_map_memory+0x24/0x3e phys=fed1f000 ioremap
0xf8224000-0xf8227000   12288 acpi_os_map_memory+0x24/0x3e phys=bfff0000 ioremap
0xf8228000-0xf822a000    8192 acpi_os_map_memory+0x24/0x3e phys=bff8e000 ioremap
0xf822c000-0xf822e000    8192 acpi_os_map_memory+0x24/0x3e phys=bff80000 ioremap
0xf8230000-0xf8232000    8192 acpi_os_map_memory+0x24/0x3e phys=bff80000 ioremap
0xf8234000-0xf8236000    8192 acpi_os_map_memory+0x24/0x3e phys=bff8e000 ioremap
0xf8238000-0xf823a000    8192 acpi_os_map_memory+0x24/0x3e phys=bff89000 ioremap
0xf823b000-0xf8247000   49152 zisofs_init+0x1b/0x46 pages=11 vmalloc
0xf8248000-0xf824d000   20480 radeonfb_pci_register+0x193/0x174c phys=ff9f0000 ioremap
0xf824e000-0xf8250000    8192 pci_iomap+0xdd/0xf0 phys=ffafb000 ioremap
0xf8252000-0xf8254000    8192 usb_hcd_pci_probe+0x1a1/0x410 phys=ffafb000 ioremap
0xf8254000-0xf8257000   12288 pci_iomap+0xdd/0xf0 phys=ff6fe000 ioremap
0xf8258000-0xf825a000    8192 iTCO_wdt_probe+0x2f1/0x360 phys=fed1f000 ioremap
0xf825e000-0xf8260000    8192 module_alloc+0x1e/0x40 pages=1 vmalloc
0xf8260000-0xf8265000   20480 pci_ioremap_bar+0x4e/0xa0 phys=ffafc000 ioremap
0xf8266000-0xf8277000   69632 snd_malloc_sgbuf_pages+0x1f4/0x230 vmap
0xf827b000-0xf8280000   20480 module_alloc+0x1e/0x40 pages=4 vmalloc
0xf8280000-0xf9281000 16781312 radeonfb_pci_register+0x3a0/0x174c phys=d0000000 ioremap
0xf9282000-0xf9293000   69632 snd_malloc_sgbuf_pages+0x1f4/0x230 vmap
0xf9294000-0xf92a5000   69632 snd_malloc_sgbuf_pages+0x1f4/0x230 vmap
0xf92a6000-0xf92b7000   69632 snd_malloc_sgbuf_pages+0x1f4/0x230 vmap
0xf92b8000-0xf92c9000   69632 snd_malloc_sgbuf_pages+0x1f4/0x230 vmap
0xf92ca000-0xf92db000   69632 snd_malloc_sgbuf_pages+0x1f4/0x230 vmap
0xf92dc000-0xf931d000  266240 pcpu_alloc+0x16d/0x440 vpages
0xf9320000-0xf9325000   20480 sky2_probe+0x12d/0xa79 [sky2] phys=ff7fc000 ioremap
0xf9326000-0xf932f000   36864 module_alloc+0x1e/0x40 pages=8 vmalloc
0xf932f000-0xf933c000   53248 module_alloc+0x1e/0x40 pages=12 vmalloc
0xf933d000-0xf9340000   12288 drm_addmap_core+0x6f8/0x8a0 [drm] pages=2 vmalloc user
0xf9340000-0xf9345000   20480 sky2_probe+0x12d/0xa79 [sky2] phys=ff8fc000 ioremap
0xf9346000-0xf934f000   36864 drm_sg_alloc+0x13f/0x2a0 [drm] pages=8 vmalloc
0xf9352000-0xf9357000   20480 drm_ht_create+0xaf/0xe0 [drm] pages=4 vmalloc
0xf935d000-0xf9361000   16384 module_alloc+0x1e/0x40 pages=3 vmalloc
0xf9368000-0xf936c000   16384 module_alloc+0x1e/0x40 pages=3 vmalloc
0xf9373000-0xf9377000   16384 module_alloc+0x1e/0x40 pages=3 vmalloc
0xf9380000-0xf9391000   69632 drm_addmap_core+0x6cb/0x8a0 [drm] phys=ff9f0000 ioremap
0xf9394000-0xf9399000   20480 module_alloc+0x1e/0x40 pages=4 vmalloc
0xf93a8000-0xf93b3000   45056 module_alloc+0x1e/0x40 pages=10 vmalloc
0xf93c0000-0xf93c7000   28672 module_alloc+0x1e/0x40 pages=6 vmalloc
0xf93d3000-0xf93d9000   24576 module_alloc+0x1e/0x40 pages=5 vmalloc
0xf93e0000-0xf93e9000   36864 drm_core_ioremap_wc+0x43/0x80 [drm] phys=dfff8000 ioremap
0xf93ef000-0xf93ff000   65536 module_alloc+0x1e/0x40 pages=15 vmalloc
0xf9400000-0xf9411000   69632 drm_addmap_core+0x6cb/0x8a0 [drm] phys=ff9f0000 ioremap
0xf9421000-0xf9437000   90112 module_alloc+0x1e/0x40 pages=21 vmalloc
0xf9445000-0xf944d000   32768 module_alloc+0x1e/0x40 pages=7 vmalloc
0xf9457000-0xf945a000   12288 module_alloc+0x1e/0x40 pages=2 vmalloc
0xf9471000-0xf9480000   61440 module_alloc+0x1e/0x40 pages=14 vmalloc
0xf948b000-0xf9490000   20480 module_alloc+0x1e/0x40 pages=4 vmalloc
0xf94ac000-0xf94ae000    8192 dm_vcalloc+0x5a/0x90 [dm_mod] pages=1 vmalloc
0xf94af000-0xf94d6000  159744 module_alloc+0x1e/0x40 pages=38 vmalloc
0xf94d9000-0xf94db000    8192 dm_vcalloc+0x5a/0x90 [dm_mod] pages=1 vmalloc
0xf9569000-0xf95c3000  368640 module_alloc+0x1e/0x40 pages=89 vmalloc
0xf989d000-0xf9a94000 2060288 sys_swapon+0x56d/0xa60 pages=502 vmalloc
0xf9a95000-0xf9c18000 1585152 sys_swapon+0x56d/0xa60 pages=386 vmalloc
0xf9c46000-0xf9c49000   12288 xt_alloc_table_info+0xc0/0xe0 pages=2 vmalloc
0xf9c4a000-0xf9c4d000   12288 xt_alloc_table_info+0xc0/0xe0 pages=2 vmalloc
0xf9c4e000-0xf9c51000   12288 xt_alloc_table_info+0xc0/0xe0 pages=2 vmalloc
0xf9c52000-0xf9c55000   12288 xt_alloc_table_info+0xc0/0xe0 pages=2 vmalloc
0xf9c60000-0xf9c62000    8192 module_alloc+0x1e/0x40 pages=1 vmalloc
0xf9c6d000-0xf9c74000   28672 module_alloc+0x1e/0x40 pages=6 vmalloc
0xf9c7d000-0xf9c80000   12288 module_alloc+0x1e/0x40 pages=2 vmalloc
0xf9c98000-0xf9ca7000   61440 module_alloc+0x1e/0x40 pages=14 vmalloc
0xf9ccc000-0xf9cd1000   20480 module_alloc+0x1e/0x40 pages=4 vmalloc
0xf9cf6000-0xfbcf7000 33558528 drm_sg_alloc+0x13f/0x2a0 [drm] pages=8192 vmalloc vpages

newton ~ # cat /proc/meminfo
MemTotal:        6210480 kB
MemFree:         2935668 kB
Buffers:          648416 kB
Cached:          1188316 kB
SwapCached:            0 kB
Active:          1606488 kB
Inactive:        1483096 kB
Active(anon):    1151104 kB
Inactive(anon):   129184 kB
Active(file):     455384 kB
Inactive(file):  1353912 kB
Unevictable:           0 kB
Mlocked:               0 kB
HighTotal:       5379592 kB
HighFree:        2925400 kB
LowTotal:         830888 kB
LowFree:           10268 kB
SwapTotal:       7261360 kB
SwapFree:        7261360 kB
Dirty:                84 kB
Writeback:             0 kB
AnonPages:       1253024 kB
Mapped:           130664 kB
Slab:             114644 kB
SReclaimable:     102084 kB
SUnreclaim:        12560 kB
PageTables:         8132 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    10366600 kB
Committed_AS:    1969496 kB
VmallocTotal:     122880 kB
VmallocUsed:       55208 kB
VmallocChunk:      62492 kB
DirectMap4k:        8184 kB
DirectMap2M:      903168 kB
