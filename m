Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbYDBKkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbYDBKkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYDBKk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:40:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55707 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbYDBKk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:40:28 -0400
Date: Wed, 2 Apr 2008 03:40:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402104025.GC2813@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402071709.GC12774@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 09:17:10AM +0200, Jens Axboe wrote:
> On Tue, Apr 01 2008, Peter Zijlstra wrote:
> > On Tue, 2008-04-01 at 23:08 +0200, Vegard Nossum wrote:
> > > Hi,
> > > 
> > > This appeared in my logs:
> > > 
> > >  kmemcheck: Caught 32-bit read from freed memory (f7042348)
> > > 
> > >  Pid: 1374, comm: bash Not tainted (2.6.25-rc7 #92)
> > >  EIP: 0060:[<c0502f0d>] EFLAGS: 00210202 CPU: 0
> > >  EIP is at call_for_each_cic+0x2d/0x44
> > >  EAX: 00200286 EBX: 00000001 ECX: c200e908 EDX: f7042348
> > >  ESI: f6c26c60 EDI: c0503310 EBP: f70fff38 ESP: c082ec88
> > >   DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > >  CR0: 8005003b CR2: f7826904 CR3: 36cd7000 CR4: 000006c0
> > >  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> > >  DR6: ffff4ff0 DR7: 00000400
> > >   [<c041cff8>] kmemcheck_read+0xa8/0xe0
> > >   [<c041d1d5>] kmemcheck_access+0x1a5/0x244
> > >   [<c0668252>] do_page_fault+0x622/0x6fc
> > >   [<c06666aa>] error_code+0x72/0x78
> > >   [<c050323f>] cfq_free_io_context+0xf/0x70
> > >   [<c04fc4d7>] put_io_context+0x4f/0x58
> > >   [<c04fc568>] exit_io_context+0x60/0x6c
> > >   [<c042f871>] do_exit+0x4d9/0x6f0
> > >   [<c042fab1>] do_group_exit+0x29/0x88
> > >   [<c042fb1f>] sys_exit_group+0xf/0x14
> > >   [<c0406105>] sysenter_past_esp+0x6d/0xa4
> > >   [<ffffffff>] 0xffffffff
> > > 
> > > The error occurs in cfq_free_io_context()'s call to
> > > call_for_each_cic() which looks like this:
> > > 
> > >         rcu_read_lock();
> > >         hlist_for_each_entry_rcu(cic, n, &ioc->cic_list, cic_list) {
> > >                 func(ioc, cic);
> > >                 called++;
> > >         }
> > >         rcu_read_unlock();
> > > 
> > > The function that is called is cic_free_func(). It is postulated that
> > > hlist_for_each_entry_rcu() will dereference the previously freed list
> > > element to get the ->next pointer.
> > > 
> > > After a short discussion with Pekka Enberg and Peter Zijlstra, it
> > > seemed evident that this list traversal should use
> > > hlist_for_each_entry_safe_rcu() instead, which would buffer the next
> > > pointer before the object is freed.
> > > 
> > > Does this report seem to be valid?
> > > 
> > > The kernel is 2.6.25-rc7.
> > 
> > The missing hlist for loop would look something like so:
> > 
> > #define hlist_for_each_entry_safe_rcu(tpos, pos, n, head, member)        \
> >         for (pos = (head)->first;                                        \
> >              rcu_dereference(pos) && ({ n = pos->next; 1; }) &&          \
> >                 ({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
> >              pos = n)
> 
> Good catch, I wonder why it didn't complain in my testing. I've added a
> patch to fix that, please see it here:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=51998b2da4e5db65cb24317329059044083ea151

I am still confused.

o	The hlist_for_each_entry_safe_rcu() is under rcu_read_lock().

o	The kmem_cache has SLAB_DESTROY_BY_RCU.

o	This means that a given slab should not be returned to the
	system until a grace period elapses.

o	So the bugginess (or not) of this code should not be affected
	by adding hlist_for_each_entry_safe_rcu() here.

	(I am not seeing the checks that would be needed to avoid
	something being kmem_cache_free()ed while being accessed,
	but might be missing something.)

							Thanx, Paul
