Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZKFFZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZKFFZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 00:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZKFFZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 00:25:04 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:43802 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZKFFZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 00:25:02 -0500
Date: Fri, 6 Nov 2009 06:25:05 +0100
From: Tobias Diedrich <ranma@tdiedrich.de>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: netconsole: tulip: possible remote DoS? due to kernel freeze
	on heavy RX traffic after Order-1 allocation failure
Message-ID: <20091106052505.GA3912@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
References: <20091105113106.GA4373@yumi.tdiedrich.de> <1257450578.2873.609.camel@calx> <20091106032754.GA15429@yumi.tdiedrich.de> <1257484384.2873.618.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257484384.2873.618.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Fri, 2009-11-06 at 04:27 +0100, Tobias Diedrich wrote:
> > Matt Mackall wrote:
> > > > Example from netconsole log:
> > > > |perl: page allocation failure. order:1, mode:0x20
> > > > |Pid: 3541, comm: perl Tainted: G        W  2.6.30.9-tomodachi #16
> > > > |Call Trace:
> > > > | [<c013e56d>] ? __alloc_pages_internal+0x353/0x36f
> > > > | [<c0154f2c>] ? cache_alloc_refill+0x2ab/0x544
> > > > | [<c0355479>] ? dev_alloc_skb+0x11/0x25
> > > > | [<c015526f>] ? __kmalloc_track_caller+0xaa/0xf9
> > > > | [<c0354ae5>] ? __alloc_skb+0x48/0xff
> > > > | [<c0355479>] ? dev_alloc_skb+0x11/0x25
> > > > | [<c02d4ba9>] ? tulip_refill_rx+0x3c/0x115
> > > > | [<c02d4fff>] ? tulip_poll+0x37d/0x416
> > > > | [<c0359763>] ? net_rx_action+0x6b/0x12f
> > > > | [<c0121ad7>] ? __do_softirq+0x4e/0xbf
> > > > | [<c0121a89>] ? __do_softirq+0x0/0xbf
> > > > | <IRQ>  [<c0107700>] ? do_IRQ+0x53/0x63
> > > > | [<c0106610>] ? common_interrupt+0x30/0x38
> > > 
> > > I don't see anything in this trace to implicate netconsole? This is the
> > > normal network receive path running out of input buffers then running
> > > into memory fragmentation.
> > 
> > I'm just thinking the hang might be related to using netconsole.
> > I guess I should try reproducing it without it.
> 
> You should, though I'd be surprised if it matters.

Apparently it does matter:
For one, the system no longer hangs after the allocation failure,
and also instead of Order-1 it is now Order-0:

[  375.398423] swapper: page allocation failure. order:0, mode:0x20
[  375.398483] Pid: 0, comm: swapper Not tainted 2.6.31.5-nokmem-tomodachi #3
[  375.398519] Call Trace:
[  375.398566]  [<c10395a8>] ? __alloc_pages_nodemask+0x40f/0x453
[  375.398613]  [<c104e988>] ? cache_alloc_refill+0x1f3/0x382
[  375.398648]  [<c104eb76>] ? __kmalloc+0x5f/0x97
[  375.398690]  [<c1228003>] ? __alloc_skb+0x44/0x101
[  375.398723]  [<c12289b5>] ? dev_alloc_skb+0x11/0x25
[  375.398760]  [<c11a53a1>] ? tulip_refill_rx+0x3c/0x115
[  375.398793]  [<c11a57f7>] ? tulip_poll+0x37d/0x416
[  375.398832]  [<c122cf56>] ? net_rx_action+0x3a/0xdb
[  375.398874]  [<c101d8b0>] ? __do_softirq+0x5b/0xcb
[  375.398908]  [<c101d855>] ? __do_softirq+0x0/0xcb
[  375.398937]  <IRQ>  [<c1003e0b>] ? do_IRQ+0x66/0x76
[  375.398989]  [<c1002d70>] ? common_interrupt+0x30/0x38
[  375.399026]  [<c100725c>] ? default_idle+0x25/0x38
[  375.399058]  [<c1001a1e>] ? cpu_idle+0x64/0x7a
[  375.399102]  [<c14105ff>] ? start_kernel+0x251/0x258
[  375.399133] Mem-Info:
[  375.399159] DMA per-cpu:
[  375.399184] CPU    0: hi:    0, btch:   1 usd:   0
[  375.399214] Normal per-cpu:
[  375.399241] CPU    0: hi:   90, btch:  15 usd:  28
[  375.399276] Active_anon:6709 active_file:1851 inactive_anon:6729
[  375.399278]  inactive_file:2051 unevictable:40962 dirty:998 writeback:914 unstable:0
[  375.399281]  free:232 slab:1843 mapped:1404 pagetables:613 bounce:0
[  375.399391] DMA free:924kB min:4kB low:4kB high:4kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:15028kB present:15872kB pages_scanned:0 all_unreclaimable? yes
[  375.399465] lowmem_reserve[]: 0 230 230
[  375.399537] Normal free:4kB min:92kB low:112kB high:136kB active_anon:26836kB inactive_anon:26916kB active_file:7404kB inactive_file:8204kB unevictable:148820kB present:235648kB pages_scanned:32 all_unreclaimable? no
[  375.399615] lowmem_reserve[]: 0 0 0
[  375.399681] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 924kB
[  375.399850] Normal: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
[  375.400016] 4412 total pagecache pages
[  375.400041] 494 pages in swap cache
[  375.400041] Swap cache stats: add 8110, delete 7616, find 139/205
[  375.400041] Free swap  = 494212kB
[  375.400041] Total swap = 524280kB
[  375.400041] 63472 pages RAM
[  375.400041] 1742 pages reserved
[  375.400041] 14429 pages shared
[  375.400041] 56917 pages non-shared
[  378.306631] swapper: page allocation failure. order:0, mode:0x20
[  378.306686] Pid: 0, comm: swapper Not tainted 2.6.31.5-nokmem-tomodachi #3
[  378.306722] Call Trace:
[  378.306769]  [<c10395a8>] ? __alloc_pages_nodemask+0x40f/0x453
[  378.306817]  [<c104e988>] ? cache_alloc_refill+0x1f3/0x382
[  378.306853]  [<c104eb76>] ? __kmalloc+0x5f/0x97
[  378.306894]  [<c1228003>] ? __alloc_skb+0x44/0x101
[  378.306927]  [<c12289b5>] ? dev_alloc_skb+0x11/0x25
[  378.306964]  [<c11a53a1>] ? tulip_refill_rx+0x3c/0x115
[  378.306996]  [<c11a57f7>] ? tulip_poll+0x37d/0x416
[  378.307035]  [<c122cf56>] ? net_rx_action+0x3a/0xdb
[  378.307079]  [<c101d8b0>] ? __do_softirq+0x5b/0xcb
[  378.307112]  [<c101d855>] ? __do_softirq+0x0/0xcb
[  378.307142]  <IRQ>  [<c1003e0b>] ? do_IRQ+0x66/0x76
[  378.307193]  [<c1002d70>] ? common_interrupt+0x30/0x38
[  378.307232]  [<c100725c>] ? default_idle+0x25/0x38
[  378.307263]  [<c1001a1e>] ? cpu_idle+0x64/0x7a
[  378.307306]  [<c14105ff>] ? start_kernel+0x251/0x258
[  378.307338] Mem-Info:
[  378.307364] DMA per-cpu:
[  378.307389] CPU    0: hi:    0, btch:   1 usd:   0
[  378.307420] Normal per-cpu:
[  378.307446] CPU    0: hi:   90, btch:  15 usd:  70
[  378.307480] Active_anon:6231 active_file:2340 inactive_anon:6283
[  378.307483]  inactive_file:2445 unevictable:40962 dirty:989 writeback:1024 unstable:0
[  378.307485]  free:232 slab:1872 mapped:1408 pagetables:613 bounce:0
[  378.307595] DMA free:924kB min:4kB low:4kB high:4kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:15028kB present:15872kB pages_scanned:0 all_unreclaimable? yes
[  378.307668] lowmem_reserve[]: 0 230 230
[  378.307739] Normal free:4kB min:92kB low:112kB high:136kB active_anon:24924kB inactive_anon:25132kB active_file:9360kB inactive_file:9780kB unevictable:148820kB present:235648kB pages_scanned:32 all_unreclaimable? no
[  378.307816] lowmem_reserve[]: 0 0 0
[  378.307882] DMA: 1*4kB 1*8kB 1*16kB 0*32kB 0*64kB 1*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 924kB
[  378.308052] Normal: 1*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4kB
[  378.308219] 5866 total pagecache pages
[  378.308247] 1065 pages in swap cache
[  378.308277] Swap cache stats: add 9651, delete 8586, find 152/220
[  378.308308] Free swap  = 488152kB
[  378.308334] Total swap = 524280kB
[  378.310030] 63472 pages RAM
[  378.310030] 1742 pages reserved
[  378.310030] 15289 pages shared
[  378.310030] 56019 pages non-shared

> > Or is it normal that a box will hang if the network receive path runs out of
> > input buffers?
> 
> No, it's not normal.
> 
> > Why does it allocate Order-1 buffers anyway?
> 
> Your skbs are allocated via the SLAB allocator, which packs 5 skbs into
> an order-1 buffer rather than 4 into 2 order-0 buffers.
> 
> Running out of order-1 buffers hasn't been a problem for most people
> lately though - is there anything interesting about your workload? Lots
> of threads? NFS? Long network processing latencies?

Not really. Basically this is just my mailserver and webserver, no
big traffic.
Just about 125 Processes running.
To increase the memory pressure for reproduction of the allocation
failurs I'm starting a memory hog that allocats 160MB and mlocks it
(Out of 256MB in total) and I've also been setting
vm/min_free_kbytes to 100 (Though with 2.6.31 I also see allocation
failures with the default of about 1MB).
No nfs.
For testing I wget a file from a server that is 6 hops away and get
the almost the full 100Mbit/s of my network interface.

The first time I've seen this problem was just a simple 'aptitude
safe-upgrade' downloading packages from the debian server though (on
2.6.31.4).

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
