Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbZBLUSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbZBLUSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZBLUSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:18:01 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43075 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZBLUSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:18:00 -0500
Date: Thu, 12 Feb 2009 12:17:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212201758.GH6759@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090211185203.GA29852@Krystal> <20090211200903.GG6694@linux.vnet.ibm.com> <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal> <20090212164621.GC6759@linux.vnet.ibm.com> <20090212193826.GD2047@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212193826.GD2047@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 02:38:26PM -0500, Mathieu Desnoyers wrote:
> Replying to a separate portion of the mail with less CC :
> 
> 
> > On Thu, Feb 12, 2009 at 02:05:39AM -0500, Mathieu Desnoyers wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Wed, Feb 11, 2009 at 11:08:24PM -0500, Mathieu Desnoyers wrote:
> > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > On Wed, Feb 11, 2009 at 04:35:49PM -0800, Paul E. McKenney wrote:
> > > > > > > On Wed, Feb 11, 2009 at 04:42:58PM -0500, Mathieu Desnoyers wrote:
> > > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > 
> > > > [ . . . ]
> > > > 
> > > > > > And I had bugs in my model that allowed the rcu_read_lock() model
> > > > > > to nest indefinitely, which overflowed into the top bit, messing
> > > > > > things up.  :-/
> > > > > > 
> > > > > > Attached is a fixed model.  This model validates correctly (woo-hoo!).
> > > > > > Even better, gives the expected error if you comment out line 180 and
> > > > > > uncomment line 213, this latter corresponding to the error case I called
> > > > > > out a few days ago.
> > > > > > 
> > > > > 
> > > > > Great ! :) I added this version to the git repository, hopefully it's ok
> > > > > with you ?
> > > > 
> > > > Works for me!
> > > > 
> > > > > > I will play with removing models of mb...
> > > > > 
> > > > > OK, I see you already did..
> > > > 
> > > > I continued this, and surprisingly few are actually required, though
> > > > I don't fully trust the modeling of removed memory barriers.
> > > 
> > > On my side I cleaned up the code a lot, and actually added some barriers
> > > ;) Especially in the busy loops, where we expect the other thread's
> > > value to change eventually between iterations. A smp_rmb() seems more
> > > appropriate that barrier(). I also added a lot of comments about
> > > barriers in the code, and made the reader side much easier to review.
> > > 
> > > Please feel free to comment on my added code comments.
> > 
> > The torture test now looks much more familiar.  ;-)
> > 
> > I fixed some compiler warnings (in my original, sad to say), added an
> > ACCESS_ONCE() to rcu_read_lock() (also in my original),
> 
> Yes, I thought about this ACCESS_ONCE during my sleep.. just did not
> have to to update the source yet. :)
> 
> Merged. Thanks !
> 
> [...]
> 
> > --- a/urcu.c
> > +++ b/urcu.c
> > @@ -99,7 +99,8 @@ static void force_mb_single_thread(pthread_t tid)
> >  	 * BUSY-LOOP.
> >  	 */
> >  	while (sig_done < 1)
> > -		smp_rmb();	/* ensure we re-read sig-done */
> > +		barrier();	/* ensure compiler re-reads sig-done */
> > +				/* cache coherence guarantees CPU re-read. */
> 
> That could be a smp_rmc() ? (see other mail)

I prefer making ACCESS_ONCE() actually having the full semantics implied
by its name.  ;-)

See patch at end of this email.

> >  	smp_mb();	/* read sig_done before ending the barrier */
> >  }
> >  
> > @@ -113,7 +114,8 @@ static void force_mb_all_threads(void)
> >  	if (!reader_data)
> >  		return;
> >  	sig_done = 0;
> > -	smp_mb();	/* write sig_done before sending the signals */
> > +	/* smp_mb();	write sig_done before sending the signals */
> > +			/* redundant with barriers in pthread_kill(). */
> 
> Absolutely not. pthread_kill does not send a signal to self in every
> case because the writer thread has not requirement to register itself.
> It *could* be registered as a reader too, but does not have to.

No, not the barrier in the signal handler, but rather the barriers in
the system call invoked by pthread_kill().

> >  	for (index = reader_data; index < reader_data + num_readers; index++)
> >  		pthread_kill(index->tid, SIGURCU);
> >  	/*
> > @@ -121,7 +123,8 @@ static void force_mb_all_threads(void)
> >  	 * BUSY-LOOP.
> >  	 */
> >  	while (sig_done < num_readers)
> > -		smp_rmb();	/* ensure we re-read sig-done */
> > +		barrier();	/* ensure compiler re-reads sig-done */
> > +				/* cache coherence guarantees CPU re-read. */
> 
> That could be a smp_rmc() ?

Again, prefer:

	while (ACCESS_ONCE() < num_readers)

after upgrading ACCESS_ONCE() to provide the full semantics.

I will send a patch.

> >  	smp_mb();	/* read sig_done before ending the barrier */
> >  }
> >  #endif
> > @@ -181,7 +184,8 @@ void synchronize_rcu(void)
> >  	 * the writer waiting forever while new readers are always accessing
> >  	 * data (no progress).
> >  	 */
> > -	smp_mb();
> > +	/* smp_mb(); Don't need this one for CPU, only compiler. */
> > +	barrier();
> 
> smp_mc() ?

ACCESS_ONCE().

> >  
> >  	switch_next_urcu_qparity();	/* 1 -> 0 */
> >  
> 
> Side-note :
> on archs without cache coherency, all smp_[rw ]mb would turn into a
> cache flush.

So I might need more in my ACCESS_ONCE() below.

Add .gitignore files, and redefine accesses in terms of a new
ACCESS_ONCE().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 .gitignore              |    9 +++++++++
 formal-model/.gitignore |    3 +++
 urcu.c                  |   10 ++++------
 urcu.h                  |   12 ++++++++++++
 4 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..29aa7e5
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,9 @@
+test_rwlock_timing
+test_urcu
+test_urcu_timing
+test_urcu_yield
+urcu-asm.o
+urcu.o
+urcutorture
+urcutorture-yield
+urcu-yield.o
diff --git a/formal-model/.gitignore b/formal-model/.gitignore
new file mode 100644
index 0000000..49fdd8a
--- /dev/null
+++ b/formal-model/.gitignore
@@ -0,0 +1,3 @@
+pan
+pan.*
+urcu.spin.trail
diff --git a/urcu.c b/urcu.c
index a696439..f61d4c3 100644
--- a/urcu.c
+++ b/urcu.c
@@ -98,9 +98,8 @@ static void force_mb_single_thread(pthread_t tid)
 	 * Wait for sighandler (and thus mb()) to execute on every thread.
 	 * BUSY-LOOP.
 	 */
-	while (sig_done < 1)
-		barrier();	/* ensure compiler re-reads sig-done */
-				/* cache coherence guarantees CPU re-read. */
+	while (ACCESS_ONCE(sig_done) < 1)
+		continue;
 	smp_mb();	/* read sig_done before ending the barrier */
 }
 
@@ -122,9 +121,8 @@ static void force_mb_all_threads(void)
 	 * Wait for sighandler (and thus mb()) to execute on every thread.
 	 * BUSY-LOOP.
 	 */
-	while (sig_done < num_readers)
-		barrier();	/* ensure compiler re-reads sig-done */
-				/* cache coherence guarantees CPU re-read. */
+	while (ACCESS_ONCE(sig_done) < num_readers)
+		continue;
 	smp_mb();	/* read sig_done before ending the barrier */
 }
 #endif
diff --git a/urcu.h b/urcu.h
index 79d9464..dd040a5 100644
--- a/urcu.h
+++ b/urcu.h
@@ -98,6 +98,9 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 /* Nop everywhere except on alpha. */
 #define smp_read_barrier_depends()
 
+#define CONFIG_ARCH_CACHE_COHERENT
+#define cpu_relax barrier
+
 /*
  * Prevent the compiler from merging or refetching accesses.  The compiler
  * is also forbidden from reordering successive instances of ACCESS_ONCE(),
@@ -110,7 +113,16 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
  * use is to mediate communication between process-level code and irq/NMI
  * handlers, all running on the same CPU.
  */
+#ifdef CONFIG_ARCH_CACHE_COHERENT
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+#else /* #ifdef CONFIG_ARCH_CACHE_COHERENT */
+#define ACCESS_ONCE(x)     ({ \
+				typeof(x) _________x1; \
+				_________x1 = (*(volatile typeof(x) *)&(x)); \
+				cpu_relax(); \
+				(_________x1); \
+				})
+#endif /* #else #ifdef CONFIG_ARCH_CACHE_COHERENT */
 
 /**
  * rcu_dereference - fetch an RCU-protected pointer in an
