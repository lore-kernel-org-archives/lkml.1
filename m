Return-Path: <linux-kernel-owner+w=401wt.eu-S1422755AbXCWJkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422755AbXCWJkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 05:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422757AbXCWJkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 05:40:16 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:37014 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422755AbXCWJkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 05:40:15 -0400
Date: Fri, 23 Mar 2007 10:40:17 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-Id: <20070323104017.cc1ea4fe.dada1@cosmosbay.com>
In-Reply-To: <20070323085910.GA11577@wotan.suse.de>
References: <20070323085910.GA11577@wotan.suse.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 09:59:11 +0100
Nick Piggin <npiggin@suse.de> wrote:

> 
> Implement queued spinlocks for i386. This shouldn't increase the size of
> the spinlock structure, while still able to handle 2^16 CPUs.
> 
> Not completely implemented with assembly yet, to make the algorithm a bit
> clearer.
> 
> The queued spinlock has 2 fields, a head and a tail, which are indexes
> into a FIFO of waiting CPUs. To take a spinlock, a CPU performs an
> "atomic_inc_return" on the head index, and keeps the returned value as
> a ticket. The CPU then spins until the tail index is equal to that
> ticket.
> 
> To unlock a spinlock, the tail index is incremented (this can be non
> atomic, because only the lock owner will modify tail).
> 
> Implementation inefficiencies aside, this change should have little
> effect on performance for uncontended locks, but will have quite a
> large cost for highly contended locks [O(N) cacheline transfers vs
> O(1) per lock aquisition, where N is the number of CPUs contending].
> The benefit is is that contended locks will not cause any starvation.
> 
> Just an idea. Big NUMA hardware seems to have fairness logic that
> prevents starvation for the regular spinlock logic. But it might be
> interesting for -rt kernel or systems with starvation issues. 

It's a very nice idea Nick.

You also have for free the number or cpus that are before you.

On big SMP/NUMA, we could use this information to call a special lock_cpu_relax() function to avoid cacheline transferts.

	asm volatile(LOCK_PREFIX "xaddw %0, %1\n\t"
		     : "+r" (pos), "+m" (lock->qhead) : : "memory");
	for (;;) {
		unsigned short nwait = pos - lock->qtail;
		if (likely(nwait == 0))
			break;
		lock_cpu_relax(lock, nwait);
	}

lock_cpu_relax(raw_spinlock_t *lock, unsigned int nwait)
{
unsigned int cycles = nwait * lock->min_cycles_per_round;
busy_loop(cycles);
}
