Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYDBKZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYDBKZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbYDBKY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:24:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59546 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbYDBKY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:24:57 -0400
Date: Wed, 2 Apr 2008 03:24:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Jens Axboe <axboe@kernel.dk>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402102454.GB2813@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> <1207085788.29991.6.camel@lappy> <20080401225116.GF8558@linux.vnet.ibm.com> <1207116956.8514.750.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207116956.8514.750.camel@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 08:15:56AM +0200, Peter Zijlstra wrote:
> On Tue, 2008-04-01 at 15:51 -0700, Paul E. McKenney wrote:
> > On Tue, Apr 01, 2008 at 11:36:28PM +0200, Peter Zijlstra wrote:
> > > On Tue, 2008-04-01 at 23:08 +0200, Vegard Nossum wrote:
> > > > Hi,
> > > > 
> > > > This appeared in my logs:
> > > > 
> > > >  kmemcheck: Caught 32-bit read from freed memory (f7042348)
> > > > 
> > > >  Pid: 1374, comm: bash Not tainted (2.6.25-rc7 #92)
> > > >  EIP: 0060:[<c0502f0d>] EFLAGS: 00210202 CPU: 0
> > > >  EIP is at call_for_each_cic+0x2d/0x44
> > > >  EAX: 00200286 EBX: 00000001 ECX: c200e908 EDX: f7042348
> > > >  ESI: f6c26c60 EDI: c0503310 EBP: f70fff38 ESP: c082ec88
> > > >   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > > >  CR0: 8005003b CR2: f7826904 CR3: 36cd7000 CR4: 000006c0
> > > >  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > > >  DR6: ffff4ff0 DR7: 00000400
> > > >   [<c041cff8>] kmemcheck_read+0xa8/0xe0
> > > >   [<c041d1d5>] kmemcheck_access+0x1a5/0x244
> > > >   [<c0668252>] do_page_fault+0x622/0x6fc
> > > >   [<c06666aa>] error_code+0x72/0x78
> > > >   [<c050323f>] cfq_free_io_context+0xf/0x70
> > > >   [<c04fc4d7>] put_io_context+0x4f/0x58
> > > >   [<c04fc568>] exit_io_context+0x60/0x6c
> > > >   [<c042f871>] do_exit+0x4d9/0x6f0
> > > >   [<c042fab1>] do_group_exit+0x29/0x88
> > > >   [<c042fb1f>] sys_exit_group+0xf/0x14
> > > >   [<c0406105>] sysenter_past_esp+0x6d/0xa4
> > > >   [<ffffffff>] 0xffffffff
> > > > 
> > > > The error occurs in cfq_free_io_context()'s call to
> > > > call_for_each_cic() which looks like this:
> > > > 
> > > >         rcu_read_lock();
> > > >         hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list) {
> > > >                 func(ioc, cic);
> > > >                 called++;
> > > >         }
> > > >         rcu_read_unlock();
> > > > 
> > > > The function that is called is cic_free_func(). It is postulated that
> > > > hlist_for_each_entry_rcu() will dereference the previously freed list
> > > > element to get the ->next pointer.
> > > > 
> > > > After a short discussion with Pekka Enberg and Peter Zijlstra, it
> > > > seemed evident that this list traversal should use
> > > > hlist_for_each_entry_safe_rcu() instead, which would buffer the next
> > > > pointer before the object is freed.
> > > > 
> > > > Does this report seem to be valid?
> > > > 
> > > > The kernel is 2.6.25-rc7.
> > > 
> > > The missing hlist for loop would look something like so:
> > > 
> > > #define hlist_for_each_entry_safe_rcu(tpos, pos, n, head, member)        \
> > >         for (pos = (head)->first;                                        \
> > >              rcu_dereference(pos) && ({ n = pos->next; 1; }) &&          \
> > >                 ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
> > >              pos = n)
> > 
> > Why the heck is cic_free_func() immediately doing a kmem_cache_free()
> > on the cfq_io_context structure???  Shouldn't we have a call_rcu() or a
> > synchronize_rcu() in there somewhere???  Given the way this is written,
> > wouldn't readers on other code paths get dumped onto the freelist?
> > This would not be a good thing...
> 
> I was told, but didn't check for myself it is using SLAB_RCU. Of course
> that requires an object validation pass, and I didn't check it does that
> either.

But doesn't SLAB_RCU only wait for a grace period when returning a
slab to the system, rather than on each kmem_cache_free()?

							Thanx, Paul
