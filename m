Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbZBMMtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbZBMMtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbZBMMtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:49:07 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:55178 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371AbZBMMtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:49:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FAML3lElMQWt2/2dsb2JhbACBbtEEhBgG
Date: Fri, 13 Feb 2009 07:49:00 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090213124900.GA29483@Krystal>
References: <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal> <20090212164621.GC6759@linux.vnet.ibm.com> <20090212193826.GD2047@Krystal> <20090212201758.GH6759@linux.vnet.ibm.com> <20090212215340.GA8394@Krystal> <20090212230415.GO6759@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090212230415.GO6759@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:43:56 up 43 days, 12:42,  3 users,  load average: 0.90, 1.02,
	0.64
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Thu, Feb 12, 2009 at 04:53:41PM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Thu, Feb 12, 2009 at 02:38:26PM -0500, Mathieu Desnoyers wrote:
> > > > Replying to a separate portion of the mail with less CC :
> > > > 
> > > > 
> > > > > On Thu, Feb 12, 2009 at 02:05:39AM -0500, Mathieu Desnoyers wrote:
> > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > On Wed, Feb 11, 2009 at 11:08:24PM -0500, Mathieu Desnoyers wrote:
> > > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > > > On Wed, Feb 11, 2009 at 04:35:49PM -0800, Paul E. McKenney wrote:
> > > > > > > > > > On Wed, Feb 11, 2009 at 04:42:58PM -0500, Mathieu Desnoyers wrote:
> > > > > > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > > 
> > > > > > > [ . . . ]
> > > > > > > 
> > > > > > > > > And I had bugs in my model that allowed the rcu_read_lock() model
> > > > > > > > > to nest indefinitely, which overflowed into the top bit, messing
> > > > > > > > > things up.  :-/
> > > > > > > > > 
> > > > > > > > > Attached is a fixed model.  This model validates correctly (woo-hoo!).
> > > > > > > > > Even better, gives the expected error if you comment out line 180 and
> > > > > > > > > uncomment line 213, this latter corresponding to the error case I called
> > > > > > > > > out a few days ago.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Great ! :) I added this version to the git repository, hopefully it's ok
> > > > > > > > with you ?
> > > > > > > 
> > > > > > > Works for me!
> > > > > > > 
> > > > > > > > > I will play with removing models of mb...
> > > > > > > > 
> > > > > > > > OK, I see you already did..
> > > > > > > 
> > > > > > > I continued this, and surprisingly few are actually required, though
> > > > > > > I don't fully trust the modeling of removed memory barriers.
> > > > > > 
> > > > > > On my side I cleaned up the code a lot, and actually added some barriers
> > > > > > ;) Especially in the busy loops, where we expect the other thread's
> > > > > > value to change eventually between iterations. A smp_rmb() seems more
> > > > > > appropriate that barrier(). I also added a lot of comments about
> > > > > > barriers in the code, and made the reader side much easier to review.
> > > > > > 
> > > > > > Please feel free to comment on my added code comments.
> > > > > 
> > > > > The torture test now looks much more familiar.  ;-)
> > > > > 
> > > > > I fixed some compiler warnings (in my original, sad to say), added an
> > > > > ACCESS_ONCE() to rcu_read_lock() (also in my original),
> > > > 
> > > > Yes, I thought about this ACCESS_ONCE during my sleep.. just did not
> > > > have to to update the source yet. :)
> > > > 
> > > > Merged. Thanks !
> > > > 
> > > > [...]
> > > > 
> > > > > --- a/urcu.c
> > > > > +++ b/urcu.c
> > > > > @@ -99,7 +99,8 @@ static void force_mb_single_thread(pthread_t tid)
> > > > >  	 * BUSY-LOOP.
> > > > >  	 */
> > > > >  	while (sig_done < 1)
> > > > > -		smp_rmb();	/* ensure we re-read sig-done */
> > > > > +		barrier();	/* ensure compiler re-reads sig-done */
> > > > > +				/* cache coherence guarantees CPU re-read. */
> > > > 
> > > > That could be a smp_rmc() ? (see other mail)
> > > 
> > > I prefer making ACCESS_ONCE() actually having the full semantics implied
> > > by its name.  ;-)
> > > 
> > > See patch at end of this email.
> > > 
> > 
> > See my email about LOAD_REMOTE/STORE_REMOTE :)
> > 
> > > > >  	smp_mb();	/* read sig_done before ending the barrier */
> > > > >  }
> > > > >  
> > > > > @@ -113,7 +114,8 @@ static void force_mb_all_threads(void)
> > > > >  	if (!reader_data)
> > > > >  		return;
> > > > >  	sig_done = 0;
> > > > > -	smp_mb();	/* write sig_done before sending the signals */
> > > > > +	/* smp_mb();	write sig_done before sending the signals */
> > > > > +			/* redundant with barriers in pthread_kill(). */
> > > > 
> > > > Absolutely not. pthread_kill does not send a signal to self in every
> > > > case because the writer thread has not requirement to register itself.
> > > > It *could* be registered as a reader too, but does not have to.
> > > 
> > > No, not the barrier in the signal handler, but rather the barriers in
> > > the system call invoked by pthread_kill().
> > > 
> > 
> > The barrier implied by going through a system call does not imply cache
> > flushing AFAIK. So we would have to at least leave a big comment here
> > saying that the kernel has to provide such guarantee. So under that
> > comment I would leave a smp_mc();.
> > 
> > > > >  	for (index = reader_data; index < reader_data + num_readers; index++)
> > > > >  		pthread_kill(index->tid, SIGURCU);
> > > > >  	/*
> > > > > @@ -121,7 +123,8 @@ static void force_mb_all_threads(void)
> > > > >  	 * BUSY-LOOP.
> > > > >  	 */
> > > > >  	while (sig_done < num_readers)
> > > > > -		smp_rmb();	/* ensure we re-read sig-done */
> > > > > +		barrier();	/* ensure compiler re-reads sig-done */
> > > > > +				/* cache coherence guarantees CPU re-read. */
> > > > 
> > > > That could be a smp_rmc() ?
> > > 
> > > Again, prefer:
> > > 
> > > 	while (ACCESS_ONCE() < num_readers)
> > > 
> > > after upgrading ACCESS_ONCE() to provide the full semantics.
> > > 
> > > I will send a patch.
> > 
> > I'll use a variation :
> > 
> >         while (LOAD_REMOTE(sig_done) < num_readers)
> >                 cpu_relax();
> 
> I suspect that LOAD_SHARED() and STORE_SHARED() would be more intuitive.
> But shouldn't we align with the Linux-kernel usage where reasonable?
> (Yes, this can be a moving target, but there isn't much else that
> currently supports this level of SMP function on quite the variety of
> CPU architectures.)
> 

Agreed. This is partly why I decided to CC Linus and the Blackfin
maintainers on this. I think it would be a shame to add such support in
a low-level userland RCU library and not to push it at the kernel level.
I really like the LOAD_SHARED and STORE_SHARED and the smp_*mc() macros,
because I think they help modeling very well what is done to local vs
shared data.

> > > > >  	smp_mb();	/* read sig_done before ending the barrier */
> > > > >  }
> > > > >  #endif
> > > > > @@ -181,7 +184,8 @@ void synchronize_rcu(void)
> > > > >  	 * the writer waiting forever while new readers are always accessing
> > > > >  	 * data (no progress).
> > > > >  	 */
> > > > > -	smp_mb();
> > > > > +	/* smp_mb(); Don't need this one for CPU, only compiler. */
> > > > > +	barrier();
> > > > 
> > > > smp_mc() ?
> > > 
> > > ACCESS_ONCE().
> > > 
> > 
> > Ah, this is what I dislike about using :
> > 
> >   STORE_REMOTE(x, v);
> > ...
> >   if (LOAD_REMOTE(y) ...)
> > rather than
> >   x = v;
> >   smp_mc();
> >   if (y ...)
> > 
> > We will end up in a situation where we do 2 cache flushes rather than a
> > single one. So wherever possible, I would be tempted to leave the
> > smp_mc().
> 
> Ummm...  There is a very real reason why I moved from bare
> smp_read_barrier_depends() calls to rcu_dereference().  Code with an
> rcu_dereference() style is -much- easier to read.
> 
> So I would flip that -- use the per-variable API unless you see
> measureable system-level pain.  Because the variable-free API will
> inflict very real readability pain!
> 
> The problem is that the relationship of the variable-free API to the
> variables it is supposed to constrain gets lost.  With the per-variable
> APIs, the relationship is obvious and explicit.
> 

That's why comments on memory barriers are strictly mandatory. :-) But
yes, I agree that we should use STORE_REMOTE/LOAD_REMOTE when where we
cannot possibly flush more than one read/write at once.

I updated the git tree to use STORE_REMOTE/LOAD_REMOTE.

Thanks,

Mathieu

> > > > >  
> > > > >  	switch_next_urcu_qparity();	/* 1 -> 0 */
> > > > >  
> > > > 
> > > > Side-note :
> > > > on archs without cache coherency, all smp_[rw ]mb would turn into a
> > > > cache flush.
> > > 
> > > So I might need more in my ACCESS_ONCE() below.
> > > 
> > > Add .gitignore files, and redefine accesses in terms of a new
> > > ACCESS_ONCE().
> > 
> > I'll merge the .gitignore file, thanks,
> 
> Sounds good!
> 
> > Please see my updated git tree.
> 
> Will do!
> 
> 							Thanx, Paul
> 
> > Mathieu
> > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > ---
> > > 
> > >  .gitignore              |    9 +++++++++
> > >  formal-model/.gitignore |    3 +++
> > >  urcu.c                  |   10 ++++------
> > >  urcu.h                  |   12 ++++++++++++
> > >  4 files changed, 28 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/.gitignore b/.gitignore
> > > new file mode 100644
> > > index 0000000..29aa7e5
> > > --- /dev/null
> > > +++ b/.gitignore
> > > @@ -0,0 +1,9 @@
> > > +test_rwlock_timing
> > > +test_urcu
> > > +test_urcu_timing
> > > +test_urcu_yield
> > > +urcu-asm.o
> > > +urcu.o
> > > +urcutorture
> > > +urcutorture-yield
> > > +urcu-yield.o
> > > diff --git a/formal-model/.gitignore b/formal-model/.gitignore
> > > new file mode 100644
> > > index 0000000..49fdd8a
> > > --- /dev/null
> > > +++ b/formal-model/.gitignore
> > > @@ -0,0 +1,3 @@
> > > +pan
> > > +pan.*
> > > +urcu.spin.trail
> > > diff --git a/urcu.c b/urcu.c
> > > index a696439..f61d4c3 100644
> > > --- a/urcu.c
> > > +++ b/urcu.c
> > > @@ -98,9 +98,8 @@ static void force_mb_single_thread(pthread_t tid)
> > >  	 * Wait for sighandler (and thus mb()) to execute on every thread.
> > >  	 * BUSY-LOOP.
> > >  	 */
> > > -	while (sig_done < 1)
> > > -		barrier();	/* ensure compiler re-reads sig-done */
> > > -				/* cache coherence guarantees CPU re-read. */
> > > +	while (ACCESS_ONCE(sig_done) < 1)
> > > +		continue;
> > >  	smp_mb();	/* read sig_done before ending the barrier */
> > >  }
> > >  
> > > @@ -122,9 +121,8 @@ static void force_mb_all_threads(void)
> > >  	 * Wait for sighandler (and thus mb()) to execute on every thread.
> > >  	 * BUSY-LOOP.
> > >  	 */
> > > -	while (sig_done < num_readers)
> > > -		barrier();	/* ensure compiler re-reads sig-done */
> > > -				/* cache coherence guarantees CPU re-read. */
> > > +	while (ACCESS_ONCE(sig_done) < num_readers)
> > > +		continue;
> > >  	smp_mb();	/* read sig_done before ending the barrier */
> > >  }
> > >  #endif
> > > diff --git a/urcu.h b/urcu.h
> > > index 79d9464..dd040a5 100644
> > > --- a/urcu.h
> > > +++ b/urcu.h
> > > @@ -98,6 +98,9 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
> > >  /* Nop everywhere except on alpha. */
> > >  #define smp_read_barrier_depends()
> > >  
> > > +#define CONFIG_ARCH_CACHE_COHERENT
> > > +#define cpu_relax barrier
> > > +
> > >  /*
> > >   * Prevent the compiler from merging or refetching accesses.  The compiler
> > >   * is also forbidden from reordering successive instances of ACCESS_ONCE(),
> > > @@ -110,7 +113,16 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
> > >   * use is to mediate communication between process-level code and irq/NMI
> > >   * handlers, all running on the same CPU.
> > >   */
> > > +#ifdef CONFIG_ARCH_CACHE_COHERENT
> > >  #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
> > > +#else /* #ifdef CONFIG_ARCH_CACHE_COHERENT */
> > > +#define ACCESS_ONCE(x)     ({ \
> > > +				typeof(x) _________x1; \
> > > +				_________x1 = (*(volatile typeof(x) *)&(x)); \
> > > +				cpu_relax(); \
> > > +				(_________x1); \
> > > +				})
> > > +#endif /* #else #ifdef CONFIG_ARCH_CACHE_COHERENT */
> > >  
> > >  /**
> > >   * rcu_dereference - fetch an RCU-protected pointer in an
> > > 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
