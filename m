Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZBKSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZBKSwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZBKSwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:52:09 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:60470 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbZBKSwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:52:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwEAMeqkklMQWt2/2dsb2JhbACBbtNdhBsG
Date: Wed, 11 Feb 2009 13:52:03 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090211185203.GA29852@Krystal>
References: <20090209070317.GA31583@Krystal> <20090209153305.GA6802@linux.vnet.ibm.com> <20090210191731.GA20867@Krystal> <20090210211643.GL6742@linux.vnet.ibm.com> <20090210212833.GA27578@Krystal> <20090210222115.GN6742@linux.vnet.ibm.com> <20090211005701.GA550@Krystal> <20090211052828.GQ6742@linux.vnet.ibm.com> <20090211063520.GE8132@Krystal> <20090211153246.GA6694@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090211153246.GA6694@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:46:24 up 41 days, 18:44,  3 users,  load average: 0.17, 0.20,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Feb 11, 2009 at 01:35:20AM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Tue, Feb 10, 2009 at 07:57:01PM -0500, Mathieu Desnoyers wrote:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > On Tue, Feb 10, 2009 at 04:28:33PM -0500, Mathieu Desnoyers wrote:
> > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > On Tue, Feb 10, 2009 at 02:17:31PM -0500, Mathieu Desnoyers wrote:
> > > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > > > On Mon, Feb 09, 2009 at 02:03:17AM -0500, Mathieu Desnoyers wrote:
> > > > > > > > > 
> > > > > > > > > [ . . . ]
> > > > > > > > > 
> > > > > > > > > > I just added modified rcutorture.h and api.h from your git tree
> > > > > > > > > > specifically for an urcutorture program to the repository. Some results :
> > > > > > > > > > 
> > > > > > > > > > 8-way x86_64
> > > > > > > > > > E5405 @2 GHZ
> > > > > > > > > > 
> > > > > > > > > > ./urcutorture 8 perf
> > > > > > > > > > n_reads: 1937650000  n_updates: 3  nreaders: 8  nupdaters: 1 duration: 1
> > > > > > > > > > ns/read: 4.12871  ns/update: 3.33333e+08
> > > > > > > > > > 
> > > > > > > > > > ./urcutorture 8 uperf
> > > > > > > > > > n_reads: 0  n_updates: 4413892  nreaders: 0  nupdaters: 8 duration: 1
> > > > > > > > > > ns/read: nan  ns/update: 1812.46
> > > > > > > > > > 
> > > > > > > > > > n_reads: 98844204  n_updates: 10  n_mberror: 0
> > > > > > > > > > rcu_stress_count: 98844171 33 0 0 0 0 0 0 0 0 0
> > > > > > > > > > 
> > > > > > > > > > However, I've tried removing the second switch_qparity() call, and the
> > > > > > > > > > rcutorture test did not detect anything wrong. I also did a variation
> > > > > > > > > > which calls the "sched_yield" version of the urcu, "urcutorture-yield".
> > > > > > > > > 
> > > > > > > > > My confusion -- I was testing my old approach where the memory barriers
> > > > > > > > > are in rcu_read_lock() and rcu_read_unlock().  To force the failures in
> > > > > > > > > your signal-handler-memory-barrier approach, I suspect that you are
> > > > > > > > > going to need a bigger hammer.  In this case, one such bigger hammer
> > > > > > > > > would be:
> > > > > > > > > 
> > > > > > > > > o	Just before exit from the signal handler, do a
> > > > > > > > > 	pthread_cond_wait() under a pthread_mutex().
> > > > > > > > > 
> > > > > > > > > o	In force_mb_all_threads(), refrain from sending a signal to self.
> > > > > > > > > 
> > > > > > > > > 	Then it should be safe in force_mb_all_threads() to do a
> > > > > > > > > 	pthread_cond_broadcast() under the same pthread_mutex().
> > > > > > > > > 
> > > > > > > > > This should raise the probability of seeing the failure in the case
> > > > > > > > > where there is a single switch_qparity().
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > I just did a mb() version of the urcu :
> > > > > > > > 
> > > > > > > > (uncomment CFLAGS=+-DDEBUG_FULL_MB in the Makefile)
> > > > > > > > 
> > > > > > > > Time per read : 48.4086 cycles
> > > > > > > > (about 6-7 times slower, as expected)
> > > > > > > > 
> > > > > > > > This will be useful especially to increase the chance to trigger races.
> > > > > > > > 
> > > > > > > > I tried removing the second parity switch from the writer. The rcu
> > > > > > > > torture test did not find the problem yet (maybe I am not using the
> > > > > > > > correct parameters ? It does not run for more than 5 seconds).
> > > > > > > > 
> > > > > > > > So I added a "-n" option to test_urcu, so it can make the usleep(1)
> > > > > > > > between the writes optional. I also changed the yield for a usleep with
> > > > > > > > random delay. I also now use a circular buffer rather than malloc so we
> > > > > > > > are sure the memory is not quickly reused by the writer and stays longer
> > > > > > > > in an invalid state.
> > > > > > > > 
> > > > > > > > So what really make the problem appear quickly is to add a delay between
> > > > > > > > the rcu_dereference and the assertion on the data validity in thr_reader.
> > > > > > > > 
> > > > > > > > It now appears after just a few seconds when running
> > > > > > > > ./test_urcu_yield 20 -r -n
> > > > > > > > Compiled with CFLAGS=+-DDEBUG_FULL_MB
> > > > > > > > 
> > > > > > > > It seem to be much harder to trigger with the signal-based version. It's
> > > > > > > > expected, because the writer takes about 50 times longer to execute than
> > > > > > > > with the -DDEBUG_FULL_MB version.
> > > > > > > > 
> > > > > > > > So I'll let the ./test_urcu_yield NN -r -n run for a while on the
> > > > > > > > correct version (with DEBUG_FULL_MB) and see what it gives.
> > > > > > > 
> > > > > > > Hmmm...  I had worse luck this time, took three 10-second tries to
> > > > > > > see a failure:
> > > > > > > 
> > > > > > > paulmck@paulmck-laptop:~/paper/perfbook/CodeSamples/defer$ ./rcu_nest32 1 stress
> > > > > > > n_reads: 44682055  n_updates: 9609503  n_mberror: 0
> > > > > > > rcu_stress_count: 44679377 2678 0 0 0 0 0 0 0 0 0
> > > > > > > paulmck@paulmck-laptop:~/paper/perfbook/CodeSamples/defer$ !!
> > > > > > > ./rcu_nest32 1 stress
> > > > > > > n_reads: 42281884  n_updates: 9870129  n_mberror: 0
> > > > > > > rcu_stress_count: 42277756 4128 0 0 0 0 0 0 0 0 0
> > > > > > > paulmck@paulmck-laptop:~/paper/perfbook/CodeSamples/defer$ !!
> > > > > > > ./rcu_nest32 1 stress
> > > > > > > n_reads: 41384304  n_updates: 10040805  n_mberror: 0
> > > > > > > rcu_stress_count: 41380075 4228 1 0 0 0 0 0 0 0 0
> > > > > > > paulmck@paulmck-laptop:~/paper/perfbook/CodeSamples/defer$
> > > > > > > 
> > > > > > > This is my prototype version, with read-side memory barriers, no
> > > > > > > signals, and without your initialization-value speedup.
> > > > > > > 
> > > > > > 
> > > > > > It would be interesting to re-sync our trees, or if you can point me to
> > > > > > a current version of your prototype, I could review it.
> > > > > 
> > > > > Look at:
> > > > > 
> > > > > 	CodeSamples/defer/rcu_nest32.[hc]
> > > > > 
> > > > > In the git archive:
> > > > > 
> > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/perfbook.git
> > > > 
> > > > flip_counter_and_wait : yours do rcu_gp_ctr += RCU_GP_CTR_BOTTOM_BIT
> > > > mine : rcu_gp_ctr ^= RCU_GP_CTR_BOTTOM_BIT.
> > > 
> > > Yep, this is before your optimization.
> > > 
> > 
> > Hrm, and given the RCU_GP_CTR_BOTTOM_BIT is in the MSBs, there is no
> > possible effect on the LSBs. That should work even if it overflows. OK.
> > That should even work with my optimization. But I somehow prefer the xor
> > (if it's not slower), because we really only need 1 bit to flip on and
> > off.
> > 
> > > > Another major difference between our tree is the lack of smp_mb() at the
> > > > end of flip_counter_and_wait() (in your tree).
> > > > 
> > > > Your code does :
> > > > 
> > > >   smp_mb()
> > > >   switch parity
> > > >   smp_mb()
> > > >   wait for each thread ongoing old gp
> > > >     <<<<<<< ---- missing smp_mb.
> > > >   switch parity
> > > >   smp_mb()
> > > >   wait for each thread ongoing old gp
> > > >   smp_mb()
> > > 
> > > This should be OK -- or am I missing a failure scenario?
> > > Keep in mind that I get failures only when omitting a counter
> > > flip, not with the above code.
> > > 
> > 
> > OK, it's good that you point out that the failure only occurs when
> > omitting the counter flip.
> > 
> > So if we leave out the mb() we can end up in a situation where a reader
> > thread is still in an ongoing old gp and we switch the parity. The big
> > question is : should we be concerned about this ?
> > 
> > From the writer point of view :
> > 
> > Given there is no data dependency between the parity update and the
> > per_thread(rcu_reader_gp, t) read done in the while loop waiting for
> > threads, and given even the compiler barrier() has no effect wrt the
> > last test done after the last iteration of the loop, we could think of
> > compiler optimizations doing the following to our code (let's focus on a
> > single loop of for_each_thread) :
> > 
> > transforming
> > 
> >                 while (rcu_old_gp_ongoing(t))
> >                         barrier();
> >                 rcu_gp_ctr += RCU_GP_CTR_BOTTOM_BIT;
> > 
> > into
> > 
> >                 if (!rcu_old_gp_ongoing(t))
> >                   goto end;
> >                 while (rcu_old_gp_ongoing(t))
> >                         barrier();
> > end:
> >                 rcu_gp_ctr += RCU_GP_CTR_BOTTOM_BIT;
> > 
> > This leaves the choice to the compiler to perform the rcu_gp_ctr
> > increment before the per_thread(rcu_reader_gp, t) read, because there is
> > no barrier.
> > 
> > Not only does this apply to the compiler, but also to the memory
> > barriers. We can end up in a situation where the CPU decides to to the
> > rcu_gp_ctr increment before reading the last rcu_old_gp_ongoing value,
> > given there is no data dependency between those two.
> > 
> > You could argue that ACCESS_ONCE() around the per_thread(rcu_reader_gp,
> > t) read will order reads, but I don't think we should rely on this on
> > SMP. This is really supposed to be there just to make sure we don't end
> > up doing multiple variable reads on UP wrt to local interrupts.
> > 
> > You could also argue that rcu_gp_ctr is read within
> > rcu_old_gp_ongoing(), which should normally order the memory accesses.
> > It actually does only order memory access to the rcu_gp_ctr variable,
> > not the per_thread(rcu_reader_gp, t), because, here again, there if no
> > data dependency whatsoever between per_thread(rcu_reader_gp, t) and
> > rcu_gp_ctr. A possible scenario : rcu_gp_ctr could be read, then we have
> > the rcu_gp_ctr increment, and only then could the
> > per_thread(rcu_reader_gp, t) variable be read to perform the test.
> > 
> > But I see that even in rcu_read_lock, there is no strict ordering
> > between __get_thread_var(rcu_reader_gp) and rcu_gp_ctr read. Therefore,
> > I conclude that ordering between those two variables does not matter at
> > all. I also suspect that this is the core reason for doing 2 q.s. period
> > flip at each update.
> > 
> > Am I correct ?
> 
> I do not believe so -- please see my earlier email calling out the
> sequence of events leading to failure in the single-flip case:
> 
> 	http://lkml.org/lkml/2009/2/7/67
> 

Hrm, let me present it in a different, more straightfoward way :

In you Promela model (here : http://lkml.org/lkml/2009/2/10/419)

There is a memory barrier here in the updater :

	do
	:: 1 ->
		if
		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
			skip;
		:: else -> break;
		fi
	od;
	need_mb = 1;
	do
	:: need_mb == 1 -> skip;
	:: need_mb == 0 -> break;
	od;
	urcu_gp_ctr = urcu_gp_ctr + RCU_GP_CTR_BIT;
	do
	:: 1 ->
		if
		:: (urcu_active_readers & RCU_GP_CTR_NEST_MASK) != 0 &&
		   (urcu_active_readers & ~RCU_GP_CTR_NEST_MASK) !=
		   (urcu_gp_ctr & ~RCU_GP_CTR_NEST_MASK) ->
			skip;
		:: else -> break;
		fi;
	od;

However, in your C code of nest_32.c, there is none. So it is at the
very least an inconsistency between your code and your model.


> > > > I also wonder why you have a smp_mb() after spin_unlock() in your
> > > > synchronize_rcu() -> if you follow the Linux kernel semantics for
> > > > spinlocks, the smp_mb() should be implied. (but I have not looked at
> > > > your spin_lock/unlock primitives yet).
> > > 
> > > Perhaps things have changed, but last I knew, spin_lock() and
> > > spin_unlock() were only required to keep the critical section in, not
> > > to keep things out of the critical section.
> > > 
> > 
> > Hrm, reading Documentation/memory-barriers.txt again tells me things
> > might have changed (if I am reading correctly the section LOCKS VS
> > MEMORY ACCESSES).
> 
> In the 2.6.26 version of Documentation/memory-barriers.txt, there is
> the following near line 366:
> 
>  (5) LOCK operations.
> 
>      This acts as a one-way permeable barrier.  It guarantees that all memory
>      operations after the LOCK operation will appear to happen after the LOCK
>      operation with respect to the other components of the system.
> 
>      Memory operations that occur before a LOCK operation may appear to happen
>      after it completes.
> 
>      A LOCK operation should almost always be paired with an UNLOCK operation.
> 
> 
>  (6) UNLOCK operations.
> 
>      This also acts as a one-way permeable barrier.  It guarantees that all
>      memory operations before the UNLOCK operation will appear to happen before
>      the UNLOCK operation with respect to the other components of the system.
> 
>      Memory operations that occur after an UNLOCK operation may appear to
>      happen before it completes.
> 
>      LOCK and UNLOCK operations are guaranteed to appear with respect to each
>      other strictly in the order specified.
> 
>      The use of LOCK and UNLOCK operations generally precludes the need for
>      other sorts of memory barrier (but note the exceptions mentioned in the
>      subsection "MMIO write barrier").
> 
> > Correct me if I am wrong, but I don't think it makes sense to insure
> > memory barriers to keep accesses within the critical section and not
> > outside, because such memory access could well be another spinlock.
> 
> Almost, but not quite.  ;-)
> 
> > Therefore, we could end up in a situation where we have two locks, A and
> > B, taken in the following order in the source code :
> > 
> > LOCK A
> > 
> > UNLOCK A
> > 
> > LOCK B
> > 
> > UNLOCK B
> > 
> > Then, following your assumption, it would be possible for a CPU to do
> > the memory accesses associated to lock A and B in a random order one vs
> > the other. Given there would be no requirement to keep things out of
> > those respective critical sections, LOCK A could be taken within LOCK B,
> > and the opposite would also be valid.
> > 
> > Valid memory access orders :
> > 
> > 1)
> > LOCK A
> > LOCK B
> > UNLOCK B
> > UNLOCK A
> > 
> > 2)
> > LOCK B
> > LOCK A
> > UNLOCK A
> > UNLOCK B
> 
> #2 is wrong -- LOCK A is guaranteed to prohibit LOCK B from passing it,
> as that would be equivalent to letting LOCK A's critical section leak out.
> 
> > The only constraint that ensures we won't end up in this situation is
> > the fact that memory accesses done outside of the critical section stays
> > outside of the critical section.
> 
> Let's take it one transformation at a time:
> 
> 1.	LOCK A; UNLOCK A; LOCK B; UNLOCK B
> 
> 2.	LOCK A; LOCK B; UNLOCK A; UNLOCK B
> 
> 	This one is OK, because both the LOCK B and the UNLOCK A
> 	are permitted to allow more stuff to enter their respective
> 	critical sections.
> 
> 3.	LOCK B; LOCK A; UNLOCK A; UNLOCK B
> 
> 	This is -not- legal!  LOCK A is forbidden to allow LOCK B
> 	to escape its critical section.
> 
> Does this make sense?
> 

Ah, yes. Thanks for the explanation.

Mathieu

> 							Thanx, Paul
> 
> > Mathieu
> > 
> > 
> > 
> > > 							Thanx, Paul
> > > 
> > > > Mathieu
> > > > 
> > > > > 							Thanx, Paul
> > > > > 
> > > > > _______________________________________________
> > > > > ltt-dev mailing list
> > > > > ltt-dev@lists.casi.polymtl.ca
> > > > > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> > > > > 
> > > > 
> > > > -- 
> > > > Mathieu Desnoyers
> > > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > > 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
