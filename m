Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZKBB4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZKBB4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 20:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZKBB4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 20:56:10 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:42979 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbZKBB4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 20:56:09 -0500
Date: Mon, 2 Nov 2009 02:56:12 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31.5: Kernel freeze after http: page allocation failure.
	order:1, mode:0x20
Message-ID: <20091102015612.GA3549@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <20091101160008.GA16521@yumi.tdiedrich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091101160008.GA16521@yumi.tdiedrich.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Ok, for now I've only seen this once on one of three systems, but
> this coincides with updating the kernel from 2.6.30.3 yesterday,
> which had been running fine for 88 days.
> And since there seems to be some other reports of page allocaton
> failure related problems, I thought I should report this one.

Ok, now I've seen this freeze again with a simple
"wget http://ftp2.de.kernel.org/pub/linux/kernel/v2.6/linux-2.6.31.tar.bz2"

After that I rebooted into a kernel with the
"[PATCH 1/5 Against 2.6.31.4] page allocator: Always wake kswapd
when restarting an allocation attempt after direct reclaim failed"
and
"[PATCH 2/5] page allocator: Do not allow interrupts to use
ALLOC_HARDER"
patches applied.

But just now, using wget I again got a hanging system.

This is the netconsole output (unfortunately it seems that some bits
get lost and/or reordered on the way over the internets):

swapper: page allocation failure. order:1, mode:0x20
Pid: 0, comm: swapper Tainted: G        W  2.6.31.5-nokmem-tomodachi
#13
Call Trace:
 [<c104105c>] ? __alloc_pages_nodemask+0x40f/0x453
 [<c1057cfe>] ? cache_alloc_refill+0x2a2/0x53b
 [<c12672a5>] ? dev_alloc_skb+0x11/0x25
 [<c1058044>] ? __kmalloc_track_caller+0xad/0xfc
 [<c12668f3>] ? __alloc_skb+0x48/0x105
 [<c12672a5>] ? dev_alloc_skb+0x11/0x25
 [<c11e0bc9>] ? tulip_refill_rx+0x3c/0x115
 [<c11e101f>] ? tulip_poll+0x37d/0x416
 [<c126ba14>] ? net_rx_action+0x6c/0x12f
 [<c102391c>] ? __do_softirq+0x5d/0xd5
 [<c10238bf>] ? __do_softirq+0x0/0xd5
 <IRQ>  [<c100782b>] ? do_IRQ+0x66/0x76
 [<c1006630>] ? common_interrupt+0x30/0x38
 [<c1016ec0>] ? native_safe_halt+0x2/0x3
 [<c100ae52>] ? default_idle+0x28/0x46
 [<c1005231>] ? cpu_idle+0x69/0x80
 [<c1483630>] ? start_kernel+0x268/0x26f
Mem-Info:
DMA per-cpu:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:   90, btch:  15 usd:  85
Active_anon:9045 active_file:12002 inactive_anon:16755
 inactive_file:16449 unevictable:1 dirty:5453 writeback:0 unstable:0
 free:961 slab:4697 mapped:6249 pagetables:612 bounce:0
DMA free:968kB min:124kB low:152kB high:184kB active_anon:312kB
inactive_anon:2940kB active_file:4584kB inactive_file:6132kB
unevictable:0kB present:15872kB pages_scanned:0 all_unreclaimable?
no
lowmem_reserve[]:

And with the patched kernel:

Mem-Info:
arecord: page allocation failure. order:1, mode:0x20
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:   90, btch:  15 usd:  59
Active_anon:13849 active_file:13039 inactive_anon:14671
 inactive_file:13066 unevictable:1 dirty:5524 writeback:0 unstable:0
 free:671 slab:4737 mapped:3261 pagetables:544 bounce:0
DMA free:968kB min:124kB low:152kB high:184kB active_anon:1924kB
inactive_anon:2320kB active_file:4728kB inactive_file:4656kB
unevictable:0kB present:15872kB pages_scanned:0 all_unreclaimable?
no
lowmem_reserve[]: 0 230 230Pid: 3252, comm: arecord Tainted: G W  2.6.31.5-nokmem-tomodachi #14
Call Trace:
 [<c1041081>] ? __alloc_pages_nodemask+0x434/0x478
 [<c12a5b6d>] ? tcp_data_queue+0x4c9/0xb4d
 [<c1057d26>] ? cache_alloc_refill+0x2a2/0x53b
 [<c12672c5>] ? dev_alloc_skb+0x11/0x25
 [<c105806c>] ? __kmalloc_track_caller+0xad/0xfc
 [<c1266913>] ? __alloc_skb+0x48/0x105
 [<c12672c5>] ? dev_alloc_skb+0x11/0x25
 [<c11e0be9>] ? tulip_refill_rx+0x3c/0x115
 [<c11e103f>] ? tulip_poll+0x37d/0x416
 [<c126ba34>] ? net_rx_action+0x6c/0x12f
 [<c102391c>] ? __do_softirq+0x5d/0xd5
 [<c10238bf>] ? __do_softirq+0x0/0xd5
 <IRQ>  [<c100782b>] ? do_IRQ+0x66/0x76
 [<c1006630>] ? common_interrupt+0x30/0x38

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
