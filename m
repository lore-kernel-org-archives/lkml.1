Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbZKEASj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbZKEASj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZKEASi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:18:38 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:42096 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZKEASh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:18:37 -0500
To: "TuxOnIce users' list" <tuxonice-users@lists.tuxonice.net>,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Cc: dominik.stadler@gmx.at
Subject: strange OOM receiving a wireless network packet on a SLUB system
References: <87ocnim1bj.fsf@spindle.srvr.nix> <4AF1F611.6050206@crca.org.au>
	<c7a347a10911041421u35b102behe0ed2d94506680c1@mail.gmail.com>
From: Nix <nix@esperi.org.uk>
Emacs: the definitive fritterware.
Date: Thu, 05 Nov 2009 00:18:38 +0000
In-Reply-To: <c7a347a10911041421u35b102behe0ed2d94506680c1@mail.gmail.com> (Dominik Stadler's message of "Wed, 4 Nov 2009 23:21:45 +0100")
Message-ID: <87zl71lt7l.fsf_-_@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Nov 2009, Dominik Stadler stated:
> I just saw a very similar thing happening to me here, ThinkPad T500, Ubuntu
> 9.10, latest 3.0.1+TOI-Kernel from Karmic-PPA, I  have some other weirdness
> as well which I am not sure if TOI-related or Karmic, will do some
> Divide-And-Conquer analysis next to find out the root cause of these and
> report back.
>
> $ uname -a
> Linux XXXXXX 2.6.31-15-generic #49+tuxonice2-Ubuntu SMP Sat Oct 31 01:46:15
> UTC 2009 x86_64 GNU/Linux
>
> This is what I got just now:
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] swapper: page allocation
> failure. order:2, mode:0x4020

That doesn't really look similar to me (not a decompressor -22 error).
To me it looks more like you ran out of memory, or at least ran very close
to out: an order-2 allocation is not enormous (16Kb on x86) and should
definitely work after everything's been chucked out. (mode 0x4020 implies
a compound-page GFP_ATOMIC allocation, so it couldn't swap, but it
could certainly discard clean pages.)

Did this happen at suspension time, resumption time,or what? It looks
like the kernel hadn't been up for long, so I guess we can rule out
really really bad arena fragmentation... but it was long enough that I
guess this was at suspension time?

> Nov  4 22:40:22 dstathink kernel: [39835.951178] Pid: 0, comm: swapper
> Tainted: G         C 2.6.31-15-generic #49+tuxonice2-Ubuntu
> Nov  4 22:40:22 dstathink kernel: [39835.951178] Call
> Trace:
> Nov  4 22:40:22 dstathink kernel: [39835.951178]  <IRQ>
> [<ffffffff810f1abc>]
> __alloc_pages_slowpath+0x4cc/0x4e0
> 
> Nov  4 22:40:22 dstathink kernel: [39835.951178]  [<ffffffff810f1c1e>]
> __alloc_pages_nodemask+0x14e/0x150
> 
> Nov  4 22:40:22 dstathink kernel: [39835.951178]  [<ffffffff811230ca>]
> kmalloc_large_node+0x5a/0xb0
> 
> Nov  4 22:40:22 dstathink kernel: [39835.951178]  [<ffffffff81127275>]
> __kmalloc_node_track_caller+0x135/0x180

This is SLUB stuff. Is SLUB production-ready yet? (I haven't been
following it.)

(Networking, wireless, SLUB, no idea where to Cc this. I'll just Cc LKML
and see if anyone notices :) )

> Nov  4 22:40:22 dstathink kernel: [39835.951178]  [<ffffffffa0245899>] ?
> iwl_rx_allocate+0x1a9/0x230
> [iwlcore]
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178]  [<ffffffff8144088b>]
> __alloc_skb+0x7b/0x180
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178]  [<ffffffffa0245899>]
> iwl_rx_allocate+0x1a9/0x230
> [iwlcore]

Wireless network packet reception leading to OOM. Not TuxOnIce, I'd say.
Certainly not the same problem as me: I don't even *have* any wireless
hardware (with my RSI, laptops might as well have razor blades on their
keys).

(Why does it need a 16Kb contiguous region anyway?

> Nov  4 22:40:22 dstathink kernel: [39835.951178]  [<ffffffff81010e12>] ?
> cpu_idle+0xb2/0x100

Idle, not suspending...

> Nov  4 22:40:22 dstathink kernel: [39835.951178] Active_anon:365111
> active_file:88612 inactive_anon:162361

Lots of inactive pages. Why were none chucked out?

> Nov  4 22:40:22 dstathink kernel: [39835.951178]  inactive_file:243222
> unevictable:4 dirty:214598 writeback:320 unstable:0

214000+ dirty pages seems awfully high.

> Nov  4 22:40:22 dstathink kernel: [39835.951178]  free:6876 slab:51582
> mapped:40147 pagetables:8440 bounce:0

6876 free pages, a reasonable-enough figure, yet it couldn't find four
in a row to receive a network packet? Seems unlikely.

> Nov  4 22:40:22 dstathink kernel: [39835.951178] Node 0 DMA free:15644kB
> min:28kB low:32kB high:40kB active_anon:12kB inactive_anon:32kB
> active_file:4kB inactive_file:208kB unevictable:0kB present:15336kB
> pages_scanned:0 all_unreclaimable? no
> 
> Nov  4 22:40:22 dstathink kernel: [39835.951178] lowmem_reserve[]: 0 2958
> 3905 3905
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] Node 0 DMA32 free:10124kB
> min:6044kB low:7552kB high:9064kB active_anon:1223088kB
> inactive_anon:367500kB active_file:218036kB inactive_file:833596kB
> unevictable:16kB present:3029636kB pages_scanned:0 all_unreclaimable?
> no
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] lowmem_reserve[]: 0 0 946
> 946
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] Node 0 Normal free:1736kB
> min:1932kB low:2412kB high:2896kB active_anon:237344kB
> inactive_anon:281912kB active_file:136408kB inactive_file:139084kB
> unevictable:0kB present:969600kB pages_scanned:0 all_unreclaimable?
> no

Again, heaps of inactive.

> Nov  4 22:40:22 dstathink kernel: [39835.951178] lowmem_reserve[]: 0 0 0
> 0
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] Node 0 DMA: 7*4kB 4*8kB
> 2*16kB 2*32kB 2*64kB 2*128kB 3*256kB 2*512kB 3*1024kB 3*2048kB 1*4096kB 15644kB
> Nov  4 22:40:22 dstathink kernel: [39835.951178] Node 0 DMA32: 2249*4kB
> 35*8kB 1*16kB 0*32kB 1*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB
> 0*4096kB = 10124kB
> Nov  4 22:40:22 dstathink kernel: [39835.951178] Node 0 Normal: 132*4kB
> 127*8kB 2*16kB 1*32kB 0*64kB 1*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB
> 0*4096kB = 1736kB
> Nov  4 22:40:22 dstathink kernel: [39835.951178] 390803 total pagecache
> pages
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] 12039 pages in swap
> cache
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] Swap cache stats: add
> 41296, delete 29257, find
> 4825/7516
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] Free swap  8330844kB
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] Total swap 8393952kB
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] 1032192 pages
> RAM
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] 76928 pages
> reserved
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] 488347 pages
> shared
>
> Nov  4 22:40:22 dstathink kernel: [39835.951178] 596692 pages non-shared

OK, I don't know why this failed, but I'm an mm neophyte running on pure
grep. Any ideas from anyone with an actual clue in this area? (I know OOM
is all the rage right now, so maybe this will garner some attention :) )
