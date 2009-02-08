Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZBHWgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZBHWgT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZBHWgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:36:06 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33941 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZBHWgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:36:03 -0500
Date: Sun, 8 Feb 2009 14:36:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Message-ID: <20090208223606.GM7120@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal> <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090207151028.GA11150@linux.vnet.ibm.com> <20090207233827.GA3557@Krystal> <20090208004416.GH7120@linux.vnet.ibm.com> <20090208214610.GB17569@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090208214610.GB17569@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 04:46:10PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Sat, Feb 07, 2009 at 06:38:27PM -0500, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Fri, Feb 06, 2009 at 08:34:32AM -0800, Paul E. McKenney wrote:
> > > > > On Fri, Feb 06, 2009 at 05:06:40AM -0800, Paul E. McKenney wrote:
> > > > > > On Thu, Feb 05, 2009 at 11:58:41PM -0500, Mathieu Desnoyers wrote:
> > > > > > > (sorry for repost, I got the ltt-dev email wrong in the previous one)
> > > > > > > 
> > > > > > > Hi Paul,
> > > > > > > 
> > > > > > > I figured out I needed some userspace RCU for the userspace tracing part
> > > > > > > of LTTng (for quick read access to the control variables) to trace
> > > > > > > userspace pthread applications. So I've done a quick-and-dirty userspace
> > > > > > > RCU implementation.
> > > > > > > 
> > > > > > > It works so far, but I have not gone through any formal verification
> > > > > > > phase. It seems to work on paper, and the tests are also OK (so far),
> > > > > > > but I offer no guarantee for this 300-lines-ish 1-day hack. :-) If you
> > > > > > > want to comment on it, it would be welcome. It's a userland-only
> > > > > > > library. It's also currently x86-only, but only a few basic definitions
> > > > > > > must be adapted in urcu.h to port it.
> > > > > > > 
> > > > > > > Here is the link to my git tree :
> > > > > > > 
> > > > > > > git://lttng.org/userspace-rcu.git
> > > > > > > 
> > > > > > > http://lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git;a=summary
> > > > > > 
> > > > > > Very cool!!!  I will take a look!
> > > > > > 
> > > > > > I will also point you at a few that I have put together:
> > > > > > 
> > > > > > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/perfbook.git
> > > > > > 
> > > > > > (In the CodeSamples/defer directory.)
> > > > > 
> > > > > Interesting approach, using the signal to force memory-barrier execution!
> > > > > 
> > > > > o	One possible optimization would be to avoid sending a signal to
> > > > > 	a blocked thread, as the context switch leading to blocking
> > > > > 	will have implied a memory barrier -- otherwise it would not
> > > > > 	be safe to resume the thread on some other CPU.  That said,
> > > > > 	not sure whether checking to see whether a thread is blocked is
> > > > > 	any faster than sending it a signal and forcing it to wake up.
> > > > > 
> > > > > 	Of course, this approach does require that the enclosing
> > > > > 	application be willing to give up a signal.  I suspect that most
> > > > > 	applications would be OK with this, though some might not.
> > > > > 
> > > > > 	Of course, I cannot resist pointing to an old LKML thread:
> > > > > 
> > > > > 		http://lkml.org/lkml/2001/10/8/189
> > > > > 
> > > > > 	But I think that the time is now right.  ;-)
> > > > > 
> > > > > o	I don't understand the purpose of rcu_write_lock() and
> > > > > 	rcu_write_unlock().  I am concerned that it will lead people
> > > > > 	to decide that a single global lock must protect RCU updates,
> > > > > 	which is of course absolutely not the case.  I strongly
> > > > > 	suggest making these internal to the urcu.c file.  Yes,
> > > > > 	uses of urcu_publish_content() would then hit two locks (the
> > > > > 	internal-to-urcu.c one and whatever they are using to protect
> > > > > 	their data structure), but let's face it, if you are sending a
> > > > > 	signal to each and every thread, the additional overhead of the
> > > > > 	extra lock is the least of your worries.
> > > > > 
> > > > > 	If you really want to heavily optimize this, I would suggest
> > > > > 	setting up a state machine that permits multiple concurrent
> > > > > 	calls to urcu_publish_content() to share the same set of signal
> > > > > 	invocations.  That way, if the caller has partitioned the
> > > > > 	data structure, global locking might be avoided completely
> > > > > 	(or at least greatly restricted in scope).
> > > > > 
> > > > > 	Of course, if updates are rare, the optimization would not
> > > > > 	help, but in that case, acquiring two locks would be even less
> > > > > 	of a problem.
> > > > > 
> > > > > o	Is urcu_qparity relying on initialization to zero?  Or on the
> > > > > 	fact that, for all x, 1-x!=x mod 2^32?  Ah, given that this is
> > > > > 	used to index urcu_active_readers[], you must be relying on
> > > > > 	initialization to zero.
> > > > > 
> > > > > o	In rcu_read_lock(), why is a non-atomic increment of the
> > > > > 	urcu_active_readers[urcu_parity] element safe?  Are you
> > > > > 	relying on the compiler generating an x86 add-to-memory
> > > > > 	instruction?
> > > > > 
> > > > > 	Ditto for rcu_read_unlock().
> > > > > 
> > > > > 	Ah, never mind!!!  I now see the __thread specification,
> > > > > 	and the keeping of references to it in the reader_data list.
> > > > > 
> > > > > o	Combining the equivalent of rcu_assign_pointer() and
> > > > > 	synchronize_rcu() into urcu_publish_content() is an interesting
> > > > > 	approach.  Not yet sure whether or not it is a good idea.  I
> > > > > 	guess trying it out on several applications would be the way
> > > > > 	to find out.  ;-)
> > > > > 
> > > > > 	That said, I suspect that it would be very convenient in a
> > > > > 	number of situations.
> > > > > 
> > > > > o	It would be good to avoid having to pass the return value
> > > > > 	of rcu_read_lock() into rcu_read_unlock().  It should be
> > > > > 	possible to avoid this via counter value tricks, though this
> > > > > 	would add a bit more code in rcu_read_lock() on 32-bit machines.
> > > > > 	(64-bit machines don't have to worry about counter overflow.)
> > > > > 
> > > > > 	See the recently updated version of CodeSamples/defer/rcu_nest.[ch]
> > > > > 	in the aforementioned git archive for a way to do this.
> > > > > 	(And perhaps I should apply this change to SRCU...)
> > > > > 
> > > > > o	Your test looks a bit strange, not sure why you test all the
> > > > > 	different variables.  It would be nice to take a test duration
> > > > > 	as an argument and run the test for that time.
> > > > > 
> > > > > 	I killed the test after better part of an hour on my laptop,
> > > > > 	will retry on a larger machine (after noting the 18 threads
> > > > > 	created!).  (And yes, I first tried Power, which objected
> > > > > 	strenously to the "mfence" and "lock; incl" instructions,
> > > > > 	so getting an x86 machine to try on.)
> > > > > 
> > > > > Again, looks interesting!  Looks plausible, although I have not 100%
> > > > > convinced myself that it is perfectly bug-free.  But I do maintain
> > > > > a healthy skepticism of purported RCU algorithms, especially ones that
> > > > > I have written.  ;-)
> > > > 
> > > > OK, here is one sequence of concern...
> > > > 
> > > 
> > > Let's see..
> > > 
> > > > o	Thread 0 starts rcu_read_lock(), picking up the current
> > > > 	get_urcu_qparity() into the local variable urcu_parity().
> > > > 	Assume that the value returned is zero.
> > > > 
> > > > o	Thread 0 is now preempted.
> > > > 
> > > > o	Thread 1 invokes urcu_publish_content():
> > > > 
> > > > 	o	It substitutes the pointer.
> > > > 
> > > > 	o	It forces all threads to execute a memory barrier
> > > > 		(thread 0 runs just long enough to process its signal
> > > > 		and then is immediately preempted again).
> > > > 
> > > > 	o	It switches the parity, which is now one.
> > > > 
> > > > 	o	It waits for all readers on parity zero, and there are
> > > > 		none, because thread 0 has not yet registered itself.
> > > > 
> > > > 	o	It therefore returns the old pointer.  So far, so good.
> > > > 
> > > > o	Thread 0 now resumes:
> > > > 
> > > > 	o	It increments its urcu_active_readers[0].
> > > > 
> > > > 	o	It forces a compiler barrier.
> > > > 
> > > > 	o	It returns zero (why not store this in thread-local
> > > > 		storage rather than returning?).
> > > > 
> > > 
> > > To support nested rcu_read_locks. (that's the only reason)
> > 
> > A patch below to allow nested rcu_read_lock() while keeping to the Linux
> > kernel API, just FYI.  One can argue that the overhead of accessing the
> > extra per-thread variables is offset by the fact that there no longer
> > needs to be a return value from rcu_read_lock() nor an argument to
> > rcu_read_unlock(), but hard to say.
> > 
> 
> I ran your modified version within my benchmarks :
> 
> with return value : 14.164 cycles per read
> without return value : 16.4017 cycles per read
> 
> So we have a 14% performance decrease due to this. We also pollute the
> branch prediction buffer and we add a cache access due to the added
> variables in the TLS. Returning the value has the clear advantage of
> letting the compiler keep it around in registers or on the stack, which
> clearly costs less.
> 
> So I think the speed factor outweights the visual considerations. Maybe
> we could switch to something like :
> 
> unsigned int qparity;
> 
> urcu_read_lock(&qparity);
> ...
> urcu_read_unlock(&qparity);
> 
> That would be a bit like local_irq_save() in the kernel, except that we
> could do it in a static inline because we pass the address. I
> personnally dislike the local_irq_save() way of hiding the fact that it
> writes to the variable in a "clever" macro. I'd really prefer to leave
> the " & ".
> 
> What is your opinion ?

My current opinion is that I can avoid the overflow problem and the
need to recheck, which might get rid of the need for both arguments
and return values while still maintaining good performance.  The trick
is to use only the topmost bit for the grace-period counter, and all
the rest of the bits for nesting.  That way, no matter what value of
global counter one picks up, it will be waited for (since there are but
two values that the global counter takes on).

But just now coding it, so will see if it actually works.

> > > > 	o	It enters its critical section, obtaining a reference
> > > > 		to the new pointer that thread 1 just published.
> > > > 
> > > > o	Thread 1 now again invokes urcu_publish_content():
> > > >  
> > > > 	o	It substitutes the pointer.
> > > > 
> > > > 	o	It forces all threads to execute a memory barrier,
> > > > 		including thread 0.
> > > > 
> > > > 	o	It switches the parity, which is now zero.
> > > > 
> > > > 	o	It waits for all readers on parity one, and there are
> > > > 		none, because thread 0 has registered itself on parity
> > > > 		zero!!!
> > > > 
> > > > 	o	Thread 1 therefore returns the old pointer.
> > > > 
> > > > 	o	Thread 1 frees the old pointer, which thread 0 is still
> > > > 		using!!!
> > > > 
> > > 
> > > Ah, yes, you are right.
> > > 
> > > > So, how to fix?  Here are some approaches:
> > > > 
> > > > o	Make urcu_publish_content() do two parity flips rather than one.
> > > > 	I use this approach in my rcu_rcpg, rcu_rcpl, and rcu_rcpls
> > > > 	algorithms in CodeSamples/defer.
> > > 
> > > This approach seems very interesting.
> > 
> > Patch in earlier email.  ;-)
> > 
> > > > o	Use a single free-running counter, in a manner similar to rcu_nest,
> > > > 	as suggested earlier.  This one is interesting, as I rely on a
> > > > 	read-side memory barrier to handle the long-preemption case.
> > > > 	However, if you believe that any thread that waits several minutes
> > > > 	between executing adjacent instructions must have been preempted
> > > > 	(which the memory barriers that are required to do a context
> > > > 	switch), then a compiler barrier suffices.  ;-)
> > > 
> > > Hrm, I'm trying to figure out what kind of memory backend you need to
> > > put your counters for each quiescent state period. Is this free-running
> > > counter indexing a very large array ? I doubt it does. Then how does it
> > > make sure we don't roll back to the old array entries ?
> > 
> > There is no array, just a global counter that is incremented by a modest
> > power of two for each grace period.  Then the outermost rcu_read_lock()
> > records the one greater than current value of the global counter in its
> > per-thread variable.
> > 
> > Now, rcu_read_lock() can tell that it is outermost by examining the
> > low-order bits of its per-thread variable -- if these bits are zero,
> > then this is the outermost rcu_read_lock().  So if rcu_read_lock() sees
> > that it is nested, it simply increments its per-thread counter.
> > 
> > Then rcu_read_unlock() simply decrements its per-thread variable.
> > 
> > If the counter is only 32 bits, it is subject to overflow.  In that case,
> > it is necessary to check for the counter having been incremented a huge
> > number of times between the time the outermost rcu_read_lock() fetched
> > the counter value and the time that it stored into its per-thread
> > variable.
> > 
> > An admittedly crude implementation of this approach may be found in
> > CodeSamples/defer/rcu_nest.[hc] in:
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/perfbook.git
> > 
> > Of course, if the counter is 64 bits, overflow can safely be ignored.
> > If you have a grace period every microsecond and allow RCU read-side
> > critical sections to be nested 255 deep, it would take more than 2,000
> > years to overflow.  ;-)
> > 
> 
> Looking at the code, my first thought is : if we find out that the
> array-based solution and the counter-based solution have the same
> performance, I would definitely prefer the array-based version because
> there are far less overflow considerations. It's therefore more solid
> algorithmically and can be proven formally.
> 
> Also, I'm not sure I fully understand where your overflow test is going.
> So let's pretend we are a reader, nested inside other rcu read locks,
> and we arrive much later after the outermost reader has read the
> rcu_gp_ctr. After 255 increments actually :
> 
> static void rcu_read_lock(void)
> {
>         long tmp;
>         long *rrgp;
> 
>         /*
>          * If this is the outermost RCU read-side critical section,
>          * copy the global grace-period counter.  In either case,
>          * increment the nesting count held in the low-order bits.
>          */
> 
>         rrgp = &__get_thread_var(rcu_reader_gp);
> retry:
>         tmp = *rrgp;
> # we read the local rrgp
>         if ((tmp & RCU_GP_CTR_NEST_MASK) == 0)
>                 tmp = rcu_gp_ctr;
> # not executed, innermost and nested.
>         tmp++;
>         *rrgp = tmp;
> # increment the local count and write it to the local rrgp
>         smp_mb();
>         if (((tmp & RCU_GP_CTR_NEST_MASK) == 1) &&
>             ((rcu_gp_ctr - tmp) > (RCU_GP_CTR_NEST_MASK << 8)) != 0) {
>                 (*rrgp)--;
>                 goto retry;
> # If we are more than 255 increments away from rcu_gp_ctr, decrement
> # rrgp and loop
>         }
> }
> 
> The problem is : rcu_gp_ctr is advancing. So if we have tmp stucked at a
> given value, and we are nested over the outermost read lock (therefore
> we are making it impossible to go end its execution), then when the
> rcu_gp_crt will advance (which is the only way things can eventually go
> forward, because the local rrgp is set back to its original value), we
> are just going to be _farther_ away from it (not closer). So we'll have
> to wait for a complete type overflow (will take a while on 32-bits, and
> a very long while on 64-bits) to have the test returning false and then
> going forward.
> 
> Or there might be something I misunderstood ?

The first clause of the "if" statement should prevent this -- if we are
not the outermost rcu_read_lock(), then we never retry.  (If I understand
your scenario.)

> > > This latter solution could break jump-based probing of programs
> > > soon-to-be available in gcc. The probes are meant to be of short
> > > duration, but the fact is that this design lets the debugger inject code
> > > without resorting to a breakpoint, which might therefore break your
> > > "short time between instructions" assumption. It's very unlikely, but
> > > possible.
> > 
> > But would the debugger's code injection take more than a minute without
> > doing a context switch?  Ah -- you are thinking of a probe that spins
> > for several minutes.  Yes, this would be strange, but not impossible.
> > 
> > OK, so for this usage, solution 1 it is!
> 
> Yes, it's unlikely, but possible.. and I like to design things assuming
> the worse case scenario, even if it's almost impossible.

That is indeed the only way to get even semi-reliable software!

							Thanx, Paul

> Mathieu
> 
> > > > Of course, the probability of seeing this failure during test is quite
> > > > low, since it is unlikely that thread 0 would run just long enough to
> > > > execute its signal handler.  However, it could happen.  And if you were
> > > > to adapt this algorithm for use in a real-time application, then priority
> > > > boosting could cause this to happen naturally.
> > > 
> > > Yes. It's not because we are not able to create the faulty condition
> > > that it will _never_ happen. It must therefore be taken care of.
> > 
> > No argument here!!!  ;-)  See the earlier patch for one way to fix.
> > 
> > The following patch makes rcu_read_lock() back into a void function
> > while still permitting nesting, for whatever it is worth.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> >  test_urcu.c |    6 +++---
> >  urcu.c      |    2 ++
> >  urcu.h      |   40 ++++++++++++++++++++++++----------------
> >  3 files changed, 29 insertions(+), 19 deletions(-)
> > 
> > diff --git a/test_urcu.c b/test_urcu.c
> > index db0b68c..16b212b 100644
> > --- a/test_urcu.c
> > +++ b/test_urcu.c
> > @@ -33,7 +33,7 @@ static struct test_array *test_rcu_pointer;
> >  
> >  void *thr_reader(void *arg)
> >  {
> > -	int qparity, i, j;
> > +	int i, j;
> >  	struct test_array *local_ptr;
> >  
> >  	printf("thread %s, thread id : %lu, pid %lu\n",
> > @@ -44,14 +44,14 @@ void *thr_reader(void *arg)
> >  
> >  	for (i = 0; i < 100000; i++) {
> >  		for (j = 0; j < 100000000; j++) {
> > -			qparity = rcu_read_lock();
> > +			rcu_read_lock();
> >  			local_ptr = rcu_dereference(test_rcu_pointer);
> >  			if (local_ptr) {
> >  				assert(local_ptr->a == 8);
> >  				assert(local_ptr->b == 12);
> >  				assert(local_ptr->c[55] == 2);
> >  			}
> > -			rcu_read_unlock(qparity);
> > +			rcu_read_unlock();
> >  		}
> >  	}
> >  
> > diff --git a/urcu.c b/urcu.c
> > index 1a276ce..95eea4e 100644
> > --- a/urcu.c
> > +++ b/urcu.c
> > @@ -23,6 +23,8 @@ pthread_mutex_t urcu_mutex = PTHREAD_MUTEX_INITIALIZER;
> >  int urcu_qparity;
> >  
> >  int __thread urcu_active_readers[2];
> > +int __thread urcu_reader_nesting;
> > +int __thread urcu_reader_parity;
> >  
> >  /* Thread IDs of registered readers */
> >  #define INIT_NUM_THREADS 4
> > diff --git a/urcu.h b/urcu.h
> > index 9431da5..6d28ea2 100644
> > --- a/urcu.h
> > +++ b/urcu.h
> > @@ -70,6 +70,8 @@ static inline void atomic_inc(int *v)
> >  extern int urcu_qparity;
> >  
> >  extern int __thread urcu_active_readers[2];
> > +extern int __thread urcu_reader_nesting;
> > +extern int __thread urcu_reader_parity;
> >  
> >  static inline int get_urcu_qparity(void)
> >  {
> > @@ -79,26 +81,32 @@ static inline int get_urcu_qparity(void)
> >  /*
> >   * returns urcu_parity.
> >   */
> > -static inline int rcu_read_lock(void)
> > +static inline void rcu_read_lock(void)
> >  {
> > -	int urcu_parity = get_urcu_qparity();
> > -	urcu_active_readers[urcu_parity]++;
> > -	/*
> > -	 * Increment active readers count before accessing the pointer.
> > -	 * See force_mb_all_threads().
> > -	 */
> > -	barrier();
> > -	return urcu_parity;
> > +	int urcu_parity;
> > +
> > +	if (urcu_reader_nesting++ == 0) {
> > +		urcu_parity = get_urcu_qparity();
> > +		urcu_active_readers[urcu_parity]++;
> > +		urcu_reader_parity = urcu_parity;
> > +		/*
> > +		 * Increment active readers count before accessing the pointer.
> > +		 * See force_mb_all_threads().
> > +		 */
> > +		barrier();
> > +	}
> >  }
> >  
> > -static inline void rcu_read_unlock(int urcu_parity)
> > +static inline void rcu_read_unlock(void)
> >  {
> > -	barrier();
> > -	/*
> > -	 * Finish using rcu before decrementing the pointer.
> > -	 * See force_mb_all_threads().
> > -	 */
> > -	urcu_active_readers[urcu_parity]--;
> > +	if (--urcu_reader_nesting == 0) {
> > +		barrier();
> > +		/*
> > +		 * Finish using rcu before decrementing the pointer.
> > +		 * See force_mb_all_threads().
> > +		 */
> > +		urcu_active_readers[urcu_reader_parity]--;
> > +	}
> >  }
> >  
> >  extern void rcu_write_lock(void);
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
