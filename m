Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZIQVCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZIQVCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZIQVCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:02:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZIQVCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:02:07 -0400
Subject: Re: kernel panic - not syncing: out of memory and no killable
 processes
From: Eric Paris <eparis@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl
In-Reply-To: <1253219756.5213.348.camel@dhcp231-106.rdu.redhat.com>
References: <1253158603.5213.204.camel@dhcp231-106.rdu.redhat.com>
	 <1253191435.5213.209.camel@dhcp231-106.rdu.redhat.com>
	 <alpine.DEB.1.00.0909171326340.31112@chino.kir.corp.google.com>
	 <1253219756.5213.348.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Sep 2009 17:01:49 -0400
Message-Id: <1253221309.5213.350.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 16:35 -0400, Eric Paris wrote:
> On Thu, 2009-09-17 at 13:29 -0700, David Rientjes wrote:
> > On Thu, 17 Sep 2009, Eric Paris wrote:
> > 
> > > the next-20090916 tree still panic's the same way.  As does Linus'
> > > latest git tree ab86e5765
> > > 
> > > I'll try bisecting between v2.6.31 and master if it would give better
> > > data than trying to bisect between two -next trees, but I'm sorta stuck
> > > with a machine that won't boot and doesn't tell me much about why.
> > > 
> > 
> 
> > Try merging the following patch to get more information such as the 
> > allocation order and gfp_mask.  It will also show the VM size of all 
> > kthreads and the state of your system memory to deterine whether there's a 
> > page allocator issue, lowmem_reserve_ratio is too high, etc.
> 
> I'll throw it in.
> 
> I did another bisect (mainly because the last one gave a commit that
> obviously seemed bogus and Ingo ask me to)
> 
> 3f2aa307c4d26b4ed6509d0a79e8254c9e07e921 is first bad commit
> commit 3f2aa307c4d26b4ed6509d0a79e8254c9e07e921
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu Sep 10 20:34:48 2009 +0200
> 
>     sched: Disable NEW_FAIR_SLEEPERS for now
> 
> I'm about to try a linus latest kernel with just this one patch
> reverted.

Odd, I tried to revert this patch but it still went boom....

[   12.000281] restorecon used greatest stack depth: 3568 bytes left
[   14.388728] udevd invoked oom-killer: gfp_mask=0x200da, order=0, oomkilladj=-17
[   14.393200] udevd cpuset=/ mems_allowed=0
[   14.394340] Pid: 894, comm: udevd Tainted: G        W  2.6.31 #144
[   14.396633] Call Trace:
[   14.397875]  [<ffffffff81112ed5>] __out_of_memory+0x1d5/0x1f0
[   14.400036]  [<ffffffff81113184>] ? out_of_memory+0x1e4/0x220
[   14.401910]  [<ffffffff81113132>] out_of_memory+0x192/0x220
[   14.403313]  [<ffffffff81117764>] __alloc_pages_nodemask+0x694/0x6b0
[   14.406238]  [<ffffffff81149a42>] alloc_page_vma+0x82/0x140
[   14.408671]  [<ffffffff811304fa>] do_wp_page+0x10a/0x960
[   14.410578]  [<ffffffff810ae666>] ? __lock_acquire+0x3c6/0x6d0
[   14.412073]  [<ffffffff81130fd1>] ? handle_mm_fault+0x281/0x8d0
[   14.417878]  [<ffffffff811313af>] handle_mm_fault+0x65f/0x8d0
[   14.419853]  [<ffffffff81536095>] ? do_page_fault+0x1f5/0x470
[   14.421778]  [<ffffffff81532aac>] ? _spin_unlock_irqrestore+0x5c/0xb0
[   14.424084]  [<ffffffff81096166>] ? down_read_trylock+0x76/0x80
[   14.425358]  [<ffffffff81536102>] do_page_fault+0x262/0x470
[   14.427677]  [<ffffffff8153199e>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   14.429933]  [<ffffffff81533215>] page_fault+0x25/0x30
[   14.432015] Mem-Info:
[   14.433872] Node 0 DMA per-cpu:
[   14.436211] CPU    0: hi:    0, btch:   1 usd:   0
[   14.438967] CPU    1: hi:    0, btch:   1 usd:   0
[   14.440258] CPU    2: hi:    0, btch:   1 usd:   0
[   14.440259] CPU    3: hi:    0, btch:   1 usd:   0
[   14.440260] CPU    4: hi:    0, btch:   1 usd:   0
[   14.440262] CPU    5: hi:    0, btch:   1 usd:   0
[   14.440263] Node 0 DMA32 per-cpu:
[   14.440265] CPU    0: hi:  186, btch:  31 usd:  60
[   14.440266] CPU    1: hi:  186, btch:  31 usd:  25
[   14.440268] CPU    2: hi:  186, btch:  31 usd:  70
[   14.440269] CPU    3: hi:  186, btch:  31 usd:   0
[   14.440270] CPU    4: hi:  186, btch:  31 usd:  45
[   14.440271] CPU    5: hi:  186, btch:  31 usd:   9
[   14.440274] Active_anon:29401 active_file:53 inactive_anon:242
[   14.440275]  inactive_file:366 unevictable:0 dirty:0 writeback:0 unstable:0
[   14.440275]  free:1173 slab:77594 mapped:66 pagetables:1206 bounce:0
[   14.440276] Node 0 DMA free:1996kB min:76kB low:92kB high:112kB active_anon:10524kB inactive_anon:0kB active_file:0kB inactive_file:8kB unevictable:0kB present:14140kB pages_scanned:0 all_unreclaimable? no
[   14.440280] lowmem_reserve[]: 0 483 483 483
[   14.440283] Node 0 DMA32 free:2696kB min:2772kB low:3464kB high:4156kB active_anon:107080kB inactive_anon:968kB active_file:212kB inactive_file:1456kB unevictable:0kB present:494944kB pages_scanned:192 all_unreclaimable? no
[   14.440287] lowmem_reserve[]: 0 0 0 0
[   14.440289] Node 0 DMA: 22*4kB 0*8kB 0*16kB 1*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 2040kB
[   14.440296] Node 0 DMA32: 146*4kB 4*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 2696kB
[   14.440302] 517 total pagecache pages
[   14.440304] 0 pages in swap cache
[   14.440305] Swap cache stats: add 0, delete 0, find 0/0
[   14.440306] Free swap  = 0kB
[   14.440307] Total swap = 0kB

