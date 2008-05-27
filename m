Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbYE0Pkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbYE0Pkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758818AbYE0Pkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:40:36 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:59581 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805AbYE0Pkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:40:35 -0400
Date: Tue, 27 May 2008 08:40:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080527154001.GB14296@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527052318.GA28301@martell.zuzino.mipt.ru> <20080527090605.GA146@tv-sign.ru> <alpine.LFD.1.10.0805270746090.2958@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805270746090.2958@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 08:03:03AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 27 May 2008, Oleg Nesterov wrote:
> 
> > On 05/27, Alexey Dobriyan wrote:
> > >
> > > PREEMPT_RCU is in use, again.
> 
> I do wonder if PREEMPT_RCU is broken.

I never stop wondering that...

> > > 0xffffffff802447cb is in find_pid_ns (kernel/pid.c:297).
> > > 292             struct hlist_node *elem;
> > > 293             struct upid *pnr;
> > > 294
> > > 295             hlist_for_each_entry_rcu(pnr, elem,
> > > 296                             &pid_hash[pid_hashfn(nr, ns)], pid_chain)
> > > 297                     if (pnr->nr == nr && pnr->ns == ns)
> 
> > > general protection fault: 0000 [2] PREEMPT SMP DEBUG_PAGEALLOC
> > > RDX: 6b6b6b6b6b6b6b6b RSI: ffffffff80566760 RDI: 0000000000003cef
> 
> That repeated 0x6b is POISON_FREE, and the code is
> 
> 	cmp    -0x10(%rdx),%edi
> 
> which is the load of "pnr->nr". So 'pnr' has been free'd.
> 
> On Tue, 27 May 2008, Oleg Nesterov wrote:
> > 
> > Is this reproducible?
> > 
> > In theory find_pid() is not safe without rcu_read_lock() if CONFIG_PREEMPT_RCU.
> > But we have a lot of "read_lock(tasklist_lock) + find_pid()", this was legal
> > and documented. It was actually broken, but happened to work because read_lock()
> > implied rcu_read_lock().
> > 
> > Could you look at
> > 
> > 	[PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
> > 	http://marc.info/?t=120162615300012
> > 
> > ?
> > 
> > I am not sure this is the actual reason though, the race is very unlikely.
> 
> That is a *very* unlikely race, especially as that bad_fork_free_pid case 
> would only happen if pid_ns_prepare_proc() fails. And if it fails, it's 
> still very unlikely to hit, I think.
> 
> That said, it does smell like a bug. But I *really* would be much much 
> happier if even SRCU at least waited for a grace period, so that it would 
> always be safe to just disable preemption for a "rcu_read_lock()". That 
> way, things that take spinlocks are safe even with SRCU.

SRCU does wait for all CPUs to schedule, and thus already waits for all
pre-existing non-preemptable code sequences to finish on all CPUs.

> Paul? How hard would it be to make preemptable RCU just honor that classic 
> RCU behavior?

Hmmm...  Might not be too hard, I will look into this.  Should just be
another stage in the rcu_try_flip state machine, along with a few of
the changes already in the queue for call_rcu_sched().

But this will only help until preemptible spinlocks arrive, right?

							Thanx, Paul
