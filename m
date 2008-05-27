Return-Path: <linux-kernel-owner+w=401wt.eu-S1758504AbYE0PDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504AbYE0PDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 11:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbYE0PD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 11:03:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757204AbYE0PD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 11:03:28 -0400
Date: Tue, 27 May 2008 08:03:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
In-Reply-To: <20080527090605.GA146@tv-sign.ru>
Message-ID: <alpine.LFD.1.10.0805270746090.2958@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527052318.GA28301@martell.zuzino.mipt.ru> <20080527090605.GA146@tv-sign.ru>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 May 2008, Oleg Nesterov wrote:

> On 05/27, Alexey Dobriyan wrote:
> >
> > PREEMPT_RCU is in use, again.

I do wonder if PREEMPT_RCU is broken.

> > 0xffffffff802447cb is in find_pid_ns (kernel/pid.c:297).
> > 292             struct hlist_node *elem;
> > 293             struct upid *pnr;
> > 294
> > 295             hlist_for_each_entry_rcu(pnr, elem,
> > 296                             &pid_hash[pid_hashfn(nr, ns)], pid_chain)
> > 297                     if (pnr->nr == nr && pnr->ns == ns)

> > general protection fault: 0000 [2] PREEMPT SMP DEBUG_PAGEALLOC
> > RDX: 6b6b6b6b6b6b6b6b RSI: ffffffff80566760 RDI: 0000000000003cef

That repeated 0x6b is POISON_FREE, and the code is

	cmp    -0x10(%rdx),%edi

which is the load of "pnr->nr". So 'pnr' has been free'd.

On Tue, 27 May 2008, Oleg Nesterov wrote:
> 
> Is this reproducible?
> 
> In theory find_pid() is not safe without rcu_read_lock() if CONFIG_PREEMPT_RCU.
> But we have a lot of "read_lock(tasklist_lock) + find_pid()", this was legal
> and documented. It was actually broken, but happened to work because read_lock()
> implied rcu_read_lock().
> 
> Could you look at
> 
> 	[PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
> 	http://marc.info/?t=120162615300012
> 
> ?
> 
> I am not sure this is the actual reason though, the race is very unlikely.

That is a *very* unlikely race, especially as that bad_fork_free_pid case 
would only happen if pid_ns_prepare_proc() fails. And if it fails, it's 
still very unlikely to hit, I think.

That said, it does smell like a bug. But I *really* would be much much 
happier if even SRCU at least waited for a grace period, so that it would 
always be safe to just disable preemption for a "rcu_read_lock()". That 
way, things that take spinlocks are safe even with SRCU.

Paul? How hard would it be to make preemptable RCU just honor that classic 
RCU behavior?

			Linus
