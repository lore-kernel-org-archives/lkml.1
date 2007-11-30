Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbXK3JOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbXK3JOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXK3JOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:14:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37722 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbXK3JOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:14:38 -0500
Date: Fri, 30 Nov 2007 10:14:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Allan Stephens <allan.stephens@windriver.com>,
       Jon Paul Maloy <jon.maloy@ericsson.com>
Subject: Re: [bug] SLOB, tipc_init(), WARNING: at
	arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
Message-ID: <20071130091418.GA2201@elte.hu>
References: <20071129142546.GA27719@elte.hu> <20071129143920.GA32146@elte.hu> <20071129213217.GW19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129213217.GW19691@waste.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> On Thu, Nov 29, 2007 at 03:39:20PM +0100, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > i'm getting this on 32-bit (with the kmap-atomic debugging patch 
> > > applied):
> > > 
> > >  ---------------->
> > >  Calling initcall 0x78b67c00: tipc_init+0x0/0xc0()
> > >  TIPC: Activated (version 1.6.2 compiled Nov 29 2007 15:04:36)
> > >  WARNING: at arch/x86/mm/highmem_32.c:52 kmap_atomic_prot()
> > >  Pid: 1, comm: swapper Not tainted 2.6.24-rc3-cfs-v24 #45
> > >   [<78107272>] show_trace_log_lvl+0x12/0x40
> > >   [<781072ad>] show_trace+0xd/0x20
> > >   [<781086f8>] dump_stack+0x58/0x60
> > >   [<7811541f>] kmap_atomic_prot+0x1bf/0x240
> > >   [<781154ae>] kmap_atomic+0xe/0x20
> > >   [<78157be5>] get_page_from_freelist+0x225/0x420
> > >   [<78157e4d>] __alloc_pages+0x6d/0x3a0
> > >   [<78169a7b>] slob_new_page+0x1b/0x60
> > >   [<78169be4>] slob_alloc+0x124/0x1e0
> > >   [<78169e0f>] __kmalloc_node+0x6f/0xa0
> > >   [<7884f7c2>] reg_init+0x42/0x80
> > >   [<7884f80a>] tipc_reg_start+0xa/0x40
> > >   [<7883e6c6>] tipc_core_start+0x66/0xc0
> > >   [<78b67c81>] tipc_init+0x81/0xc0
> > 
> > this is due to the kzalloc() here:
> > 
> > 0x7884f1d0 is in reg_init (net/tipc/user_reg.c:88).
> > 83              spin_lock_bh(&reg_lock);
> > 84              if (!users) {
> > 85                      users = kzalloc(USER_LIST_SIZE, GFP_ATOMIC);
> > 86                      if (users) {
> > 87                              for (i = 1; i <= MAX_USERID; i++) {
> > 88                                      users[i].next = i - 1;
> > 
> > which does a:
> > 
> > 120     static inline void clear_highpage(struct page *page)
> > 121     {
> > 122             void *kaddr = kmap_atomic(page, KM_USER0);
> > 123             clear_page(kaddr);
> > 124             kunmap_atomic(kaddr, KM_USER0);
> > 125     }
> > 
> > but ... why does the debug code think it's in softirq context?
> > 
> > plus, and this is a slob question i guess, how come we drop into 
> > clear_highpage() for a kzalloc()??
> 
> Good question. Looks like kzalloc switched from doing a memset to
> passing a GFP_ZERO flag down to kmalloc. Slob didn't get completely
> updated to reflect this, so it blindly propagates the flag onto
> __alloc_pages and does a harmless double-clear.
> 
> Someone should remind us what the point of moving the kzalloc memset
> down into the allocators was. We now have all three allocators doing:
> 
>         if (unlikely((flags & __GFP_ZERO) && ptr))
>                 memset(ptr, 0, obj_size(cachep));
> 
> and needing to mask flags before passing them to page allocators,
> which hardly seems better than kzalloc unconditionally doing the
> memset. Wouldn't it be better/faster/smaller to make kzalloc a
> non-inline?
> 
> Slob also has a nice second path for large kmallocs where it just 
> calls the page allocator directly which also needs this treatment. 
> Which does the right thing with non-highmem systems, but can hit this 
> bug otherwise.
> 
> Below is a totally untested patch. Alternately, we could simply tweak 
> clear_highpage to remove the limitation, but that would leave slob 
> doing an extra clear.

ok, this fixes the debug warning.

	Ingo
