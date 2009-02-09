Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZBIHDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZBIHDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 02:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZBIHDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 02:03:22 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:47797 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZBIHDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 02:03:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoFALdjj0lMQWt2/2dsb2JhbACBbcs9hBoG
Date: Mon, 9 Feb 2009 02:03:17 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090209070317.GA31583@Krystal>
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal> <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090208224419.GA19512@Krystal> <20090209041153.GR7120@linux.vnet.ibm.com> <20090209045352.GA28653@Krystal> <20090209051737.GA29254@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090209051737.GA29254@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:48:51 up 39 days,  6:47,  3 users,  load average: 0.28, 0.30,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Sun, Feb 08, 2009 at 05:44:19PM -0500, Mathieu Desnoyers wrote:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
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
> > > > 
> > > > I'm not sure it will be any faster, and it could be racy too. How would
> > > > you envision querying the execution state of another thread ?
> > > 
> > > For my 64-bit implementation (or the old slow 32-bit version), the trick
> > > would be to observe that the thread didn't do an RCU read-side critical
> > > section during the past grace period.  This observation would be by
> > > comparing counters.
> > > 
> > > For the new 32-bit implementation, the only way I know of is to grovel
> > > through /proc, which would probably be slower than just sending the
> > > signal.
> > > 
> > 
> > Yes, I guess the signal is not so bad.
> > 
> > > > > 	Of course, this approach does require that the enclosing
> > > > > 	application be willing to give up a signal.  I suspect that most
> > > > > 	applications would be OK with this, though some might not.
> > > > 
> > > > If we want to make this transparent to the application, we'll have to
> > > > investigate further in sigaction() and signal() library override I
> > > > guess.
> > > 
> > > Certainly seems like it is worth a try!
> > > 
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
> > > > 
> > > > Ok, just changed it.
> > > 
> > > Thank you!!!
> > > 
> > > > > 	If you really want to heavily optimize this, I would suggest
> > > > > 	setting up a state machine that permits multiple concurrent
> > > > > 	calls to urcu_publish_content() to share the same set of signal
> > > > > 	invocations.  That way, if the caller has partitioned the
> > > > > 	data structure, global locking might be avoided completely
> > > > > 	(or at least greatly restricted in scope).
> > > > > 
> > > > 
> > > > That brings an interesting question about urcu_publish_content :
> > > > 
> > > > void *urcu_publish_content(void **ptr, void *new)
> > > > {
> > > >         void *oldptr;
> > > > 
> > > >         internal_urcu_lock();
> > > >         oldptr = *ptr;
> > > >         *ptr = new;
> > > > 
> > > >         switch_qparity();
> > > >         switch_qparity();
> > > >         internal_urcu_unlock();
> > > > 
> > > >         return oldptr;
> > > > }
> > > > 
> > > > Given that we take a global lock around the pointer assignment, we can
> > > > safely assume, from the caller's perspective, that the update will
> > > > happen as an "xchg" operation. So if the caller does not have to copy
> > > > the old data, it can simply publish the new data without taking any
> > > > lock itself.
> > > > 
> > > > So the question that arises if we want to remove global locking is :
> > > > should we change this 
> > > > 
> > > >         oldptr = *ptr;
> > > >         *ptr = new;
> > > > 
> > > > for an atomic xchg ?
> > > 
> > > Makes sense to me!
> > > 
> > > > > 	Of course, if updates are rare, the optimization would not
> > > > > 	help, but in that case, acquiring two locks would be even less
> > > > > 	of a problem.
> > > > 
> > > > I plan updates to be quite rare, but it's always good to foresee how
> > > > that kind of infrastructure could be misused. :-)
> > > 
> > > ;-)  ;-)  ;-)
> > > 
> > > > > o	Is urcu_qparity relying on initialization to zero?  Or on the
> > > > > 	fact that, for all x, 1-x!=x mod 2^32?  Ah, given that this is
> > > > > 	used to index urcu_active_readers[], you must be relying on
> > > > > 	initialization to zero.
> > > > 
> > > > Yes, starts at 0.
> > > 
> > > Whew!  ;-)
> > > 
> > > > > o	In rcu_read_lock(), why is a non-atomic increment of the
> > > > > 	urcu_active_readers[urcu_parity] element safe?  Are you
> > > > > 	relying on the compiler generating an x86 add-to-memory
> > > > > 	instruction?
> > > > > 
> > > > > 	Ditto for rcu_read_unlock().
> > > > > 
> > > > > 	Ah, never mind!!!  I now see the __thread specification,
> > > > > 	and the keeping of references to it in the reader_data list.
> > > > 
> > > > Exactly :)
> > > 
> > > Getting old and blind, what can I say?
> > > 
> > > > > o	Combining the equivalent of rcu_assign_pointer() and
> > > > > 	synchronize_rcu() into urcu_publish_content() is an interesting
> > > > > 	approach.  Not yet sure whether or not it is a good idea.  I
> > > > > 	guess trying it out on several applications would be the way
> > > > > 	to find out.  ;-)
> > > > > 
> > > > > 	That said, I suspect that it would be very convenient in a
> > > > > 	number of situations.
> > > > 
> > > > I thought so. It seemed to be a natural way to express it to me. Usage
> > > > will tell.
> > > 
> > > ;-)
> > > 
> > > > > o	It would be good to avoid having to pass the return value
> > > > > 	of rcu_read_lock() into rcu_read_unlock().  It should be
> > > > > 	possible to avoid this via counter value tricks, though this
> > > > > 	would add a bit more code in rcu_read_lock() on 32-bit machines.
> > > > > 	(64-bit machines don't have to worry about counter overflow.)
> > > > > 
> > > > > 	See the recently updated version of CodeSamples/defer/rcu_nest.[ch]
> > > > > 	in the aforementioned git archive for a way to do this.
> > > > > 	(And perhaps I should apply this change to SRCU...)
> > > > 
> > > > See my other mail about this.
> > > 
> > > And likewise!
> > > 
> > > > > o	Your test looks a bit strange, not sure why you test all the
> > > > > 	different variables.  It would be nice to take a test duration
> > > > > 	as an argument and run the test for that time.
> > > > 
> > > > I made a smaller version which only reads a single variable. I agree
> > > > that the initial test was a bit strange on that aspect.
> > > > 
> > > > I'll do a version which takes a duration as parameter.
> > > 
> > > I strongly recommend taking a look at my CodeSamples/defer/rcutorture.h
> > > file in my git archive:
> > > 
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/perfbook.git
> > > 
> > > This torture test detects the missing second flip 15 times during a
> > > 10-second test on a two-processor machine.
> > > 
> > > The first part of the rcutorture.h file is performance tests -- search
> > > for the string "Stress test" to find the torture test.
> > > 
> > 
> > I will.
> > 
> > > > > 	I killed the test after better part of an hour on my laptop,
> > > > > 	will retry on a larger machine (after noting the 18 threads
> > > > > 	created!).  (And yes, I first tried Power, which objected
> > > > > 	strenously to the "mfence" and "lock; incl" instructions,
> > > > > 	so getting an x86 machine to try on.)
> > > > 
> > > > That should be easy enough to fix. A bit of primitive cut'n'paste would
> > > > do.
> > > 
> > > Yep.  Actually, I was considering porting your code into my environment,
> > > which already has the Power primitives.  Any objections?  (This would
> > > have the side effect of making a version available via perfbook.git.
> > > I would of course add comments referencing your git archive as the
> > > official version.)
> > > 
> > 
> > Yes, no objection. I am currently looking at your last patch, cleaning
> > it up and making the 32 and 64-bit code the same. Also trying to save a
> > few instructions. I'll keep you posted when it's ready and committed.
> > 
> 
> The new version is pushed into the repository. I changed you patch a
> bit. Flaming is welcome. :)
> 

I just added modified rcutorture.h and api.h from your git tree
specifically for an urcutorture program to the repository. Some results :

8-way x86_64
E5405 @2 GHZ

./urcutorture 8 perf
n_reads: 1937650000  n_updates: 3  nreaders: 8  nupdaters: 1 duration: 1
ns/read: 4.12871  ns/update: 3.33333e+08

./urcutorture 8 uperf
n_reads: 0  n_updates: 4413892  nreaders: 0  nupdaters: 8 duration: 1
ns/read: nan  ns/update: 1812.46

n_reads: 98844204  n_updates: 10  n_mberror: 0
rcu_stress_count: 98844171 33 0 0 0 0 0 0 0 0 0

However, I've tried removing the second switch_qparity() call, and the
rcutorture test did not detect anything wrong. I also did a variation
which calls the "sched_yield" version of the urcu, "urcutorture-yield".

Mathieu

> Mathieu
> 
> > Mathieu
> > 
> > > > > Again, looks interesting!  Looks plausible, although I have not 100%
> > > > > convinced myself that it is perfectly bug-free.  But I do maintain
> > > > > a healthy skepticism of purported RCU algorithms, especially ones that
> > > > > I have written.  ;-)
> > > > > 
> > > > 
> > > > That's always good. I also tend to always be very skeptical about what I
> > > > write and review.
> > > > 
> > > > Thanks for the thorough review.
> > > 
> > > No problem -- it has been quite fun!  ;-)
> > > 
> > > 							Thanx, Paul
> > > 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > _______________________________________________
> > ltt-dev mailing list
> > ltt-dev@lists.casi.polymtl.ca
> > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
