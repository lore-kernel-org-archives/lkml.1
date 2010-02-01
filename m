Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0BAKgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:36:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:55306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0BAKgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:36:40 -0500
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
In-Reply-To: <20100201101142.GE12759@laptop>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca> <20100201073341.GH9085@laptop>
	 <1265017350.24455.122.camel@laptop>  <20100201101142.GE12759@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 11:36:01 +0100
Message-ID: <1265020561.24455.142.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 21:11 +1100, Nick Piggin wrote:
> On Mon, Feb 01, 2010 at 10:42:30AM +0100, Peter Zijlstra wrote:
> > On Mon, 2010-02-01 at 18:33 +1100, Nick Piggin wrote:
> > > > Adds no overhead on x86, because LOCK-prefixed atomic operations of the spin
> > > > lock/unlock already imply a full memory barrier. Combines the spin lock
> > > > acquire/release barriers with the full memory barrier to diminish the
> > > > performance impact on other architectures. (per-architecture spinlock-mb.h
> > > > should be gradually implemented to replace the generic version)
> > > 
> > > It does add overhead on x86, as well as most other architectures.
> > > 
> > > This really seems like the wrong optimisation to make, especially
> > > given that there's not likely to be much using librcu yet, right?
> > > 
> > > I'd go with the simpler and safer version of sys_membarrier that does
> > > not do tricky synchronisation or add overhead to the ctxsw fastpath.
> > > Then if you see some actual improvement in a real program using librcu
> > > one day we can discuss making it faster.
> > > 
> > > As it is right now, the change will definitely slow down everybody
> > > not using librcu (ie. nearly everything). 
> > 
> > Right, so the problem with the 'slow'/'safe' version is that it takes
> > rq->lock for all relevant rqs. This renders while (1) sys_membarrier()
> > in a quite effective DoS.
> 
> All, but one at a time, no? How much of a DoS really is taking these
> locks for a handful of cycles each, per syscall?

I was more worrying about the cacheline trashing than lock hold times
there.

> I mean, we have LOTS of syscalls that take locks, and for a lot longer,
> (look at dcache_lock).

Yeah, and dcache is a massive pain, isn't it ;-)

> I think we basically just have to say that locking primitives should be
> somewhat fair, and not be held for too long, it should more or less
> work.

Sure, it'll more of less work, but he's basically making rq->lock a
global lock instead of a per-cpu lock.

> If the locks are getting contended, then the threads calling
> sys_membarrier are going to be spinning longer too, using more CPU time,
> and will get scheduled away...

Sure, and increased spinning reduces the total throughput.

> If there is some particular problem on -rt because of the rq locks,
> then I guess you could consider whether to add more overhead to your
> ctxsw path to reduce the problem, or simply not support sys_membarrier
> for unprived users in the first place.

Right, for -rt we might need to do that, but its just that rq->lock is a
very hot lock, and adding basically unlimited trashing to it didn't seem
like a good idea.

Also, I'm thinking making it a priv syscall basically renders it useless
for Mathieu.

Anyway, it might be I'm just paranoid... but archs with large core count
and lazy tlb flush seem particularly vulnerable.

