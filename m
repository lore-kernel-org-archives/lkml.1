Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZFTHE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZFTHE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 03:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZFTHEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 03:04:47 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60768 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZFTHEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 03:04:46 -0400
To: paulmck@linux.vnet.ibm.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v3)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20090617163122.GC6767@linux.vnet.ibm.com>
	<200906180534.n5I5YgMY080614@www262.sakura.ne.jp>
	<20090618152854.GB6794@linux.vnet.ibm.com>
	<200906190457.n5J4vkkT010851@www262.sakura.ne.jp>
	<20090620012831.GT6724@linux.vnet.ibm.com>
In-Reply-To: <20090620012831.GT6724@linux.vnet.ibm.com>
Message-Id: <200906201604.EGF73485.SFFQFOOLMtOVHJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 20 Jun 2009 16:04:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul E. McKenney wrote:
> On Fri, Jun 19, 2009 at 01:57:46PM +0900, Tetsuo Handa wrote:
> > Hello.
> > 
> > The GC thread is a loop of
> > 
> > (1) Take gc_mutex
> > (2) Remove an element from the list using RCU
> > (3) Wait for readers without releasing gc_mutex
> > (4) Free up that element
> > (5) Release gc_mutex
> > 
> > A new round will not see element which was removed by previous round.
> 
> Understood.
> 
> > Paul E. McKenney wrote:
> > > > > Consider the following sequence of events:
> > > > > 
> > > > > o	CPU 0 picks up users_counter_idx int local variable idx.
> > > > > 	Let's assume that the value is zero.
> > > > > 
> > > > > o	CPU 0 is now preempted, interrupted, or otherwise delayed.
> > > > > 
> >       o	CPU 1 takes gc_mutex.
> 
> Your (1).
> 
> > 
> > > > > o	CPU 1 starts garbage collection, finding some elements to
> > > > > 	delete, thus setting "element_deleted" to true.
> 
> Your (2).
> 
> > > > > o	CPU 1 continues garbage collection, inverting the value of
> > > > > 	users_counter_idx, so that the value is now one, waiting
> > > > > 	for the value-zero readers, and freeing up the old elements.
> 
> Your (3) and (4).
> 
> >       o	CPU 1 releases gc_mutex.
> > > [1]
> 
> Your (5).
> 
> > > > > o	CPU 0 continues execution, first atomically incrementing
> > > > > 	users_counter[0], then traversing the list, possibly sleeping.
> 
> Now the trick here is that CPU 0 has the old value of users_counter_idx.
> So the reader and the garbage collector now disagree on which interval
> they are operating in.
> 
> And CPU 0 might now be holding an element that will be deleted by the
> next round of GC.
> 
> >       o	CPU 2 takes gc_mutex.
> 
> Your (1) again.  Presumably your single kernel thread migrated from
> CPU 1 to CPU 2, which could really happen.
> 
> > > > > o	CPU 2 starts a new round of garbage collection, again finding
> > > > > 	some elements to delete, and thus again setting
> > > > > 	"elements_deleted" to true.  One of the elements deleted
> > > > > 	is the one that CPU 0 is currently referencing while asleep.
> 
> Your (2) again.
> 
> > > > No. CPU 2 can't start a new round of GC because GC function is exclusively
> > > > executed because of gc_mutex mutex.
> > > 
> > > But CPU 1 would have released gc_mutex back at time [1], right?
> > > 
> > Yes, CPU 1 will release gc_mutex after freeing up elements (which were removed
> > from the list after gc_mutex was taken).
> > 
> > If CPU 0 sleeps between "idx = atomic_read(&users_counter_idx)" and
> > "atomic_inc(&users_counter[idx])", CPU 0 will not see the element
> > removed by CPU 1 because CPU 0 has not started list traversal.
> > Same result for CPU 0 sleeping between "atomic_inc(&users_counter[idx])"
> > and "list_for_each_rcu() {".
> 
> No, CPU 0 really did start list traversal three bullets ago.  The
> problem is that the reader and gc disagree on what interval they are in.
> 
> > > > > o	CPU 2 continues garbage collection, inverting the value of
> > > > > 	users_counter_idx, so that the value is now zero, waiting
> > > > > 	for the value-one readers, and freeing up the old elements.
> > > > > 	Note that CPU 0 is a value-zero reader, so that CPU 2 will
> > > > > 	not wait on it.
> > > > > 
> > > > > 	CPU 2 therefore kfree()s the element that CPU 0 is currently
> > > > > 	referencing.
> 
> Your (3) and (4) again.  Note that the reader has incremented
> users_counter[0], while the GC is waiting only for users_counter[1].
> So the GC is not going to wait for the reader.
> 
> > > > CPU 2 won't continue GC, for CPU 2 can't start a new round of GC.
> > > 
> > > I still don't see why CPU 0 would not have released gc_mutex back
> > > at point [1].
> > > 
> > CPU 1 has released gc_mutex at point [1].
> > In that case, CPU 2 can take gc_mutex and start a new round.
> > Nobody can start a new round before previous round finishes.
> > 
> > CPU 2 can start a new round, but by that time, CPU 0 finished list traversal
> > and atomically decremented users_counter[0] . CPU 1 won't finish a GC round
> > before CPU 0 decrements users_counter[0], and thus CPU 2 won't start
> > a new GC round before CPU 0 finishes list traversal.
> 
> No, because CPU 2 is waiting on users_counter[1] to reach zero, but
> the reader has incremented users_counter[0].  GC will thus -not- wait
> on the reader.
> 
Ah, I understood. You are right.
CPU 2 has to wait for not only users_counter[1] but also users_counter[0].



> Modern CPUs are quite complex.  There is a multi-cycle penalty for the
> instruction being atomic in the first place, and there can be many tens
> or even hundreds of cycles penalty if the variable to be manipulated
> resides in some other CPU's cache.
> 
I thought atomic_t is a handy and lightweight counter. But atomic_t may
cause big penalty. I see.

> These penalties were larger in older SMP hardware.  Also, in general,
> the larger the system, the worse the penalties.  Getting data on and off
> a chip is quite expensive.  See slide 11 of:
> 
> http://www.rdrop.com/users/paulmck/scalability/paper/TMevalSlides.2008.10.19a.pdf
> 
> for measurements on a few-years-old system.  Newer multi-core systems
> are about a factor of six faster, but only if you keep everything on a
> single die.  If you go to multiple sockets, there is still improvement,
> but only a factor of two or so in terms of clock period.
> 
Wow, what a large difference.

> > Another keyword which is worrisome for me is NUMA.
> > My understanding is that NUMA splits RAM into nodes and tries to use RAM
> > in current node.
> > In NUMA environment, (for example) "mov eax, [ebx]" takes three CPU cycles
> > if ebx refers current node and hundred CPU cycles if ebx refers other node?
> > Then, is it preferable to place copy of ACL information to every node
> > rather than sharing one ACL information?
> 
> Even without NUMA, a load that misses all caches and comes from DRAM
> costs many tens or even a few hundred cycles.  NUMA increases the pain,
> normally by a small multiple.  The exact numbers will depend on the
> hardware, of course.
> 
I see. NUMA's pain is smaller than I thought.
I don't need to worry about NUMA for the foreseeable future.



> > Subject: [PATCH] SRCU: Allow longer timeout for non-urgent reclaimer.
> > 
> > Currently synchronize_srcu() checks for readers for every jiffies.
> > But if reader sleeps for long, we don't need to check so frequently.
> > 
> > This patch allows non-urgent SRCU reclaimers (e.g. checking for every second
> > is sufficient) to use longer timeout.
> 
> Looks good to me!  Of course, if it turns out that you don't actually
> need it, then not much benefit in including it, but:
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I see. Regarding my environment (VMware on Core2Duo PC), it seems no problem
because the GC thread does not appear on /usr/bin/top .
But if somebody noticed (maybe embedded/realtime/huge systems),
let's apply this.



Thank you for everything.
