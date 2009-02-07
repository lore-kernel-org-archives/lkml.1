Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZBGPKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZBGPKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 10:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZBGPKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 10:10:31 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34644 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZBGPKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 10:10:30 -0500
Date: Sat, 7 Feb 2009 07:10:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Message-ID: <20090207151028.GA11150@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal> <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206163432.GF10918@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 08:34:32AM -0800, Paul E. McKenney wrote:
> On Fri, Feb 06, 2009 at 05:06:40AM -0800, Paul E. McKenney wrote:
> > On Thu, Feb 05, 2009 at 11:58:41PM -0500, Mathieu Desnoyers wrote:
> > > (sorry for repost, I got the ltt-dev email wrong in the previous one)
> > > 
> > > Hi Paul,
> > > 
> > > I figured out I needed some userspace RCU for the userspace tracing part
> > > of LTTng (for quick read access to the control variables) to trace
> > > userspace pthread applications. So I've done a quick-and-dirty userspace
> > > RCU implementation.
> > > 
> > > It works so far, but I have not gone through any formal verification
> > > phase. It seems to work on paper, and the tests are also OK (so far),
> > > but I offer no guarantee for this 300-lines-ish 1-day hack. :-) If you
> > > want to comment on it, it would be welcome. It's a userland-only
> > > library. It's also currently x86-only, but only a few basic definitions
> > > must be adapted in urcu.h to port it.
> > > 
> > > Here is the link to my git tree :
> > > 
> > > git://lttng.org/userspace-rcu.git
> > > 
> > > http://lttng.org/cgi-bin/gitweb.cgi?p=userspace-rcu.git;a=summary
> > 
> > Very cool!!!  I will take a look!
> > 
> > I will also point you at a few that I have put together:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/perfbook.git
> > 
> > (In the CodeSamples/defer directory.)
> 
> Interesting approach, using the signal to force memory-barrier execution!
> 
> o	One possible optimization would be to avoid sending a signal to
> 	a blocked thread, as the context switch leading to blocking
> 	will have implied a memory barrier -- otherwise it would not
> 	be safe to resume the thread on some other CPU.  That said,
> 	not sure whether checking to see whether a thread is blocked is
> 	any faster than sending it a signal and forcing it to wake up.
> 
> 	Of course, this approach does require that the enclosing
> 	application be willing to give up a signal.  I suspect that most
> 	applications would be OK with this, though some might not.
> 
> 	Of course, I cannot resist pointing to an old LKML thread:
> 
> 		http://lkml.org/lkml/2001/10/8/189
> 
> 	But I think that the time is now right.  ;-)
> 
> o	I don't understand the purpose of rcu_write_lock() and
> 	rcu_write_unlock().  I am concerned that it will lead people
> 	to decide that a single global lock must protect RCU updates,
> 	which is of course absolutely not the case.  I strongly
> 	suggest making these internal to the urcu.c file.  Yes,
> 	uses of urcu_publish_content() would then hit two locks (the
> 	internal-to-urcu.c one and whatever they are using to protect
> 	their data structure), but let's face it, if you are sending a
> 	signal to each and every thread, the additional overhead of the
> 	extra lock is the least of your worries.
> 
> 	If you really want to heavily optimize this, I would suggest
> 	setting up a state machine that permits multiple concurrent
> 	calls to urcu_publish_content() to share the same set of signal
> 	invocations.  That way, if the caller has partitioned the
> 	data structure, global locking might be avoided completely
> 	(or at least greatly restricted in scope).
> 
> 	Of course, if updates are rare, the optimization would not
> 	help, but in that case, acquiring two locks would be even less
> 	of a problem.
> 
> o	Is urcu_qparity relying on initialization to zero?  Or on the
> 	fact that, for all x, 1-x!=x mod 2^32?  Ah, given that this is
> 	used to index urcu_active_readers[], you must be relying on
> 	initialization to zero.
> 
> o	In rcu_read_lock(), why is a non-atomic increment of the
> 	urcu_active_readers[urcu_parity] element safe?  Are you
> 	relying on the compiler generating an x86 add-to-memory
> 	instruction?
> 
> 	Ditto for rcu_read_unlock().
> 
> 	Ah, never mind!!!  I now see the __thread specification,
> 	and the keeping of references to it in the reader_data list.
> 
> o	Combining the equivalent of rcu_assign_pointer() and
> 	synchronize_rcu() into urcu_publish_content() is an interesting
> 	approach.  Not yet sure whether or not it is a good idea.  I
> 	guess trying it out on several applications would be the way
> 	to find out.  ;-)
> 
> 	That said, I suspect that it would be very convenient in a
> 	number of situations.
> 
> o	It would be good to avoid having to pass the return value
> 	of rcu_read_lock() into rcu_read_unlock().  It should be
> 	possible to avoid this via counter value tricks, though this
> 	would add a bit more code in rcu_read_lock() on 32-bit machines.
> 	(64-bit machines don't have to worry about counter overflow.)
> 
> 	See the recently updated version of CodeSamples/defer/rcu_nest.[ch]
> 	in the aforementioned git archive for a way to do this.
> 	(And perhaps I should apply this change to SRCU...)
> 
> o	Your test looks a bit strange, not sure why you test all the
> 	different variables.  It would be nice to take a test duration
> 	as an argument and run the test for that time.
> 
> 	I killed the test after better part of an hour on my laptop,
> 	will retry on a larger machine (after noting the 18 threads
> 	created!).  (And yes, I first tried Power, which objected
> 	strenously to the "mfence" and "lock; incl" instructions,
> 	so getting an x86 machine to try on.)
> 
> Again, looks interesting!  Looks plausible, although I have not 100%
> convinced myself that it is perfectly bug-free.  But I do maintain
> a healthy skepticism of purported RCU algorithms, especially ones that
> I have written.  ;-)

OK, here is one sequence of concern...

o	Thread 0 starts rcu_read_lock(), picking up the current
	get_urcu_qparity() into the local variable urcu_parity().
	Assume that the value returned is zero.

o	Thread 0 is now preempted.

o	Thread 1 invokes urcu_publish_content():

	o	It substitutes the pointer.

	o	It forces all threads to execute a memory barrier
		(thread 0 runs just long enough to process its signal
		and then is immediately preempted again).

	o	It switches the parity, which is now one.

	o	It waits for all readers on parity zero, and there are
		none, because thread 0 has not yet registered itself.

	o	It therefore returns the old pointer.  So far, so good.

o	Thread 0 now resumes:

	o	It increments its urcu_active_readers[0].

	o	It forces a compiler barrier.

	o	It returns zero (why not store this in thread-local
		storage rather than returning?).

	o	It enters its critical section, obtaining a reference
		to the new pointer that thread 1 just published.

o	Thread 1 now again invokes urcu_publish_content():
 
	o	It substitutes the pointer.

	o	It forces all threads to execute a memory barrier,
		including thread 0.

	o	It switches the parity, which is now zero.

	o	It waits for all readers on parity one, and there are
		none, because thread 0 has registered itself on parity
		zero!!!

	o	Thread 1 therefore returns the old pointer.

	o	Thread 1 frees the old pointer, which thread 0 is still
		using!!!

So, how to fix?  Here are some approaches:

o	Make urcu_publish_content() do two parity flips rather than one.
	I use this approach in my rcu_rcpg, rcu_rcpl, and rcu_rcpls
	algorithms in CodeSamples/defer.

o	Use a single free-running counter, in a manner similar to rcu_nest,
	as suggested earlier.  This one is interesting, as I rely on a
	read-side memory barrier to handle the long-preemption case.
	However, if you believe that any thread that waits several minutes
	between executing adjacent instructions must have been preempted
	(which the memory barriers that are required to do a context
	switch), then a compiler barrier suffices.  ;-)

Of course, the probability of seeing this failure during test is quite
low, since it is unlikely that thread 0 would run just long enough to
execute its signal handler.  However, it could happen.  And if you were
to adapt this algorithm for use in a real-time application, then priority
boosting could cause this to happen naturally.

							Thanx, Paul
