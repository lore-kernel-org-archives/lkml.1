Return-Path: <linux-kernel-owner+w=401wt.eu-S932275AbXCWT10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbXCWT10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933589AbXCWT1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:27:25 -0400
Received: from server99.tchmachines.com ([72.9.230.178]:33511 "EHLO
	server99.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbXCWT1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:27:24 -0400
Date: Fri, 23 Mar 2007 12:27:10 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-ID: <20070323192710.GB4241@localhost.localdomain>
References: <20070323085910.GA11577@wotan.suse.de> <20070323104017.cc1ea4fe.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323104017.cc1ea4fe.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server99.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 10:40:17AM +0100, Eric Dumazet wrote:
> On Fri, 23 Mar 2007 09:59:11 +0100
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > 
> > Implement queued spinlocks for i386. This shouldn't increase the size of
> > the spinlock structure, while still able to handle 2^16 CPUs.
> > 
> > Not completely implemented with assembly yet, to make the algorithm a bit
> > clearer.
> > 
> > The queued spinlock has 2 fields, a head and a tail, which are indexes
> > into a FIFO of waiting CPUs. To take a spinlock, a CPU performs an
> > "atomic_inc_return" on the head index, and keeps the returned value as
> > a ticket. The CPU then spins until the tail index is equal to that
> > ticket.
> > 
> > To unlock a spinlock, the tail index is incremented (this can be non
> > atomic, because only the lock owner will modify tail).
> > 
> > Implementation inefficiencies aside, this change should have little
> > effect on performance for uncontended locks, but will have quite a
> > large cost for highly contended locks [O(N) cacheline transfers vs
> > O(1) per lock aquisition, where N is the number of CPUs contending].
> > The benefit is is that contended locks will not cause any starvation.
> > 
> > Just an idea. Big NUMA hardware seems to have fairness logic that
> > prevents starvation for the regular spinlock logic. But it might be
> > interesting for -rt kernel or systems with starvation issues. 
> 
> It's a very nice idea Nick.

Amen to that.

> 
> You also have for free the number or cpus that are before you.
> 
> On big SMP/NUMA, we could use this information to call a special lock_cpu_relax() function to avoid cacheline transferts.
> 
> 	asm volatile(LOCK_PREFIX "xaddw %0, %1\n\t"
> 		     : "+r" (pos), "+m" (lock->qhead) : : "memory");
> 	for (;;) {
> 		unsigned short nwait = pos - lock->qtail;
> 		if (likely(nwait == 0))
> 			break;
> 		lock_cpu_relax(lock, nwait);
> 	}
> 
> lock_cpu_relax(raw_spinlock_t *lock, unsigned int nwait)
> {
> unsigned int cycles = nwait * lock->min_cycles_per_round;
> busy_loop(cycles);
> }

Good Idea.  Hopefully, this should reduce the number of cacheline transfers
in the contended case.
