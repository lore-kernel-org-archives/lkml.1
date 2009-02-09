Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbZBIDrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbZBIDrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 22:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZBIDrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 22:47:45 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33323 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbZBIDro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 22:47:44 -0500
Date: Sun, 8 Feb 2009 19:47:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090209034748.GP7120@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090207151028.GA11150@linux.vnet.ibm.com> <20090207233827.GA3557@Krystal> <20090208004416.GH7120@linux.vnet.ibm.com> <20090208214610.GB17569@Krystal> <20090208223606.GM7120@linux.vnet.ibm.com> <20090209002426.GA20025@linux.vnet.ibm.com> <20090209005450.GB22089@Krystal> <20090209010825.GA23462@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209010825.GA23462@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 08:08:25PM -0500, Mathieu Desnoyers wrote:
> * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Sun, Feb 08, 2009 at 02:36:06PM -0800, Paul E. McKenney wrote:
> > > > On Sun, Feb 08, 2009 at 04:46:10PM -0500, Mathieu Desnoyers wrote:
> > > 
> > > [ . . . ]
> > > 
> > > > > I ran your modified version within my benchmarks :
> > > > > 
> > > > > with return value : 14.164 cycles per read
> > > > > without return value : 16.4017 cycles per read
> > > > > 
> > > > > So we have a 14% performance decrease due to this. We also pollute the
> > > > > branch prediction buffer and we add a cache access due to the added
> > > > > variables in the TLS. Returning the value has the clear advantage of
> > > > > letting the compiler keep it around in registers or on the stack, which
> > > > > clearly costs less.
> > > > > 
> > > > > So I think the speed factor outweights the visual considerations. Maybe
> > > > > we could switch to something like :
> > > > > 
> > > > > unsigned int qparity;
> > > > > 
> > > > > urcu_read_lock(&qparity);
> > > > > ...
> > > > > urcu_read_unlock(&qparity);
> > > > > 
> > > > > That would be a bit like local_irq_save() in the kernel, except that we
> > > > > could do it in a static inline because we pass the address. I
> > > > > personnally dislike the local_irq_save() way of hiding the fact that it
> > > > > writes to the variable in a "clever" macro. I'd really prefer to leave
> > > > > the " & ".
> > > > > 
> > > > > What is your opinion ?
> > > > 
> > > > My current opinion is that I can avoid the overflow problem and the
> > > > need to recheck, which might get rid of the need for both arguments
> > > > and return values while still maintaining good performance.  The trick
> > > > is to use only the topmost bit for the grace-period counter, and all
> > > > the rest of the bits for nesting.  That way, no matter what value of
> > > > global counter one picks up, it will be waited for (since there are but
> > > > two values that the global counter takes on).
> > > > 
> > > > But just now coding it, so will see if it actually works.
> > > 
> > > Seems to work, and seems to be pretty fast on my machine, anyway.
> > > This one adapts itself to 32- and 64-bit machines, though almost
> > > all of the code is common.  It does do a check, but avoids array
> > > indexing, arguments, and return values.
> > > 
> > > How does it do on your hardware?
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Wow...
> > 
> > Patch updated against HEAD.
> > 
> > Time per read : 7.53622 cycles
> > 
> > Half of what we had previously.. I'll have to look at the assembly. :)
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > ---
> > 
> >  test_urcu.c        |    6 +++---
> >  test_urcu_timing.c |    6 +++---
> >  urcu.c             |   23 ++++++++++-------------
> >  urcu.h             |   42 +++++++++++++++++++++++++++++-------------
> >  4 files changed, 45 insertions(+), 32 deletions(-)
> > 
> > diff --git a/test_urcu.c b/test_urcu.c
> > index f6be45b..f115a4a 100644
> > --- a/test_urcu.c
> > +++ b/test_urcu.c
> > @@ -72,7 +72,7 @@ void rcu_copy_mutex_unlock(void)
> >  
> >  void *thr_reader(void *arg)
> >  {
> > -	int qparity, i, j;
> > +	int i, j;
> >  	struct test_array *local_ptr;
> >  
> >  	printf("thread %s, thread id : %lx, tid %lu\n",
> > @@ -83,14 +83,14 @@ void *thr_reader(void *arg)
> >  
> >  	for (i = 0; i < 100000; i++) {
> >  		for (j = 0; j < 100000000; j++) {
> > -			rcu_read_lock(&qparity);
> > +			rcu_read_lock();
> >  			local_ptr = rcu_dereference(test_rcu_pointer);
> >  			if (local_ptr) {
> >  				assert(local_ptr->a == 8);
> >  				assert(local_ptr->b == 12);
> >  				assert(local_ptr->c[55] == 2);
> >  			}
> > -			rcu_read_unlock(&qparity);
> > +			rcu_read_unlock();
> >  		}
> >  	}
> >  
> > diff --git a/test_urcu_timing.c b/test_urcu_timing.c
> > index 57fda4f..9903705 100644
> > --- a/test_urcu_timing.c
> > +++ b/test_urcu_timing.c
> > @@ -94,7 +94,7 @@ static cycles_t reader_time[NR_READ] __attribute__((aligned(128)));
> >  
> >  void *thr_reader(void *arg)
> >  {
> > -	int qparity, i, j;
> > +	int i, j;
> >  	struct test_array *local_ptr;
> >  	cycles_t time1, time2;
> >  
> > @@ -107,12 +107,12 @@ void *thr_reader(void *arg)
> >  	time1 = get_cycles();
> >  	for (i = 0; i < OUTER_READ_LOOP; i++) {
> >  		for (j = 0; j < INNER_READ_LOOP; j++) {
> > -			rcu_read_lock(&qparity);
> > +			rcu_read_lock();
> >  			local_ptr = rcu_dereference(test_rcu_pointer);
> >  			if (local_ptr) {
> >  				assert(local_ptr->a == 8);
> >  			}
> > -			rcu_read_unlock(&qparity);
> > +			rcu_read_unlock();
> >  		}
> >  	}
> >  	time2 = get_cycles();
> > diff --git a/urcu.c b/urcu.c
> > index 08fb75d..2914b66 100644
> > --- a/urcu.c
> > +++ b/urcu.c
> > @@ -19,17 +19,17 @@
> >  
> >  pthread_mutex_t urcu_mutex = PTHREAD_MUTEX_INITIALIZER;
> >  
> > -/* Global quiescent period parity */
> > -int urcu_qparity;
> > +/* Global grace period counter */
> > +long urcu_gp_ctr;
> >  
> > -int __thread urcu_active_readers[2];
> > +long __thread urcu_active_readers;
> >  
> >  /* Thread IDs of registered readers */
> >  #define INIT_NUM_THREADS 4
> >  
> >  struct reader_data {
> >  	pthread_t tid;
> > -	int *urcu_active_readers;
> > +	long *urcu_active_readers;
> >  };
> >  
> >  static struct reader_data *reader_data;
> > @@ -60,11 +60,9 @@ void internal_urcu_unlock(void)
> >  /*
> >   * called with urcu_mutex held.
> >   */
> > -static int switch_next_urcu_qparity(void)
> > +static void switch_next_urcu_qparity(void)
> >  {
> > -	int old_parity = urcu_qparity;
> > -	urcu_qparity = 1 - old_parity;
> > -	return old_parity;
> > +	urcu_gp_ctr += RCU_GP_CTR_BOTTOM_BIT;
> >  }
> >  
> >  static void force_mb_all_threads(void)
> > @@ -89,7 +87,7 @@ static void force_mb_all_threads(void)
> >  	mb();	/* read sig_done before ending the barrier */
> >  }
> >  
> > -void wait_for_quiescent_state(int parity)
> > +void wait_for_quiescent_state(void)
> >  {
> >  	struct reader_data *index;
> >  
> > @@ -101,7 +99,7 @@ void wait_for_quiescent_state(int parity)
> >  		/*
> >  		 * BUSY-LOOP.
> >  		 */
> > -		while (index->urcu_active_readers[parity] != 0)
> > +		while (rcu_old_gp_ongoing(index->urcu_active_readers))
> >  			barrier();
> >  	}
> >  	/*
> > @@ -115,17 +113,16 @@ void wait_for_quiescent_state(int parity)
> >  
> >  static void switch_qparity(void)
> >  {
> > -	int prev_parity;
> >  
> >  	/* All threads should read qparity before accessing data structure. */
> >  	/* Write ptr before changing the qparity */
> >  	force_mb_all_threads();
> > -	prev_parity = switch_next_urcu_qparity();
> > +	switch_next_urcu_qparity();
> >  
> >  	/*
> >  	 * Wait for previous parity to be empty of readers.
> >  	 */
> > -	wait_for_quiescent_state(prev_parity);
> > +	wait_for_quiescent_state();
> >  }
> >  
> >  void synchronize_rcu(void)
> > diff --git a/urcu.h b/urcu.h
> > index b6b5c7b..e83c69f 100644
> > --- a/urcu.h
> > +++ b/urcu.h
> > @@ -66,23 +66,39 @@ static inline void atomic_inc(int *v)
> >  
> >  #define SIGURCU SIGUSR1
> >  
> > -/* Global quiescent period parity */
> > -extern int urcu_qparity;
> > +#define RCU_GP_CTR_BOTTOM_BIT (sizeof(long) == 4 ? 0x80000000 : 0x100L)
> 
> Shouldn't it be the opposite ?
> 
> e.g.
> 
> #define RCU_GP_CTR_BOTTOM_BIT (sizeof(long) == 4 ? 0x100L : 0x80000000L)

Absolutely not!!!  For 32-bit systems, the GP count is only the upper
bit.  That is exactly what allows the overflow check to be omitted.
For 64-bit systems, I rely on the upper 56 bits taking a couple of
millenia to overflow.

For 64-bit systems, one could also use only the upper bit
(0x8000000000000000), and that might actually make for better code.

> > +#define RCU_GP_CTR_NEST_MASK (RCU_GP_CTR_BOTTOM_BIT - 1)
> >  
> > -extern int __thread urcu_active_readers[2];
> > +/* Global quiescent period counter with low-order bits unused. */
> > +extern long urcu_gp_ctr;
> >  
> > -static inline int get_urcu_qparity(void)
> > +extern long __thread urcu_active_readers;
> > +
> > +static inline int rcu_old_gp_ongoing(long *value)
> >  {
> > -	return urcu_qparity;
> > +	long v;
> > +
> > +	if (value == NULL)
> > +		return 0;
> > +	v = ACCESS_ONCE(*value);
> > +	if (sizeof(long) == 4) {
> > +		return (v & RCU_GP_CTR_NEST_MASK) &&
> > +		       ((v ^ ACCESS_ONCE(urcu_gp_ctr)) & ~RCU_GP_CTR_NEST_MASK);
> 
> There must be something about the ^ I am missing ? Compared to it, the
> 64-bits test is a - , with < 0...

Yep.  For 32 bits, if the top bit is the same as that of the current value
of the counter, we must wait.  I could have written:

	       (v & ~RCU_GP_CTR_NEST_MASK) !=
	       (ACCESS_ONCE(urcu_gp_ctr) & ~RCU_GP_CTR_NEST_MASK)

but doing so would require two "&" operations.  Though perhaps the
compiler would have figured it out...

							Thanx, Paul

> Mathieu
> 
> > +	} else {
> > +		return (v & RCU_GP_CTR_NEST_MASK) &&
> > +		       (v - ACCESS_ONCE(urcu_gp_ctr) < 0);
> > +	}
> >  }
> >  
> > -/*
> > - * urcu_parity should be declared on the caller's stack.
> > - */
> > -static inline void rcu_read_lock(int *urcu_parity)
> > +static inline void rcu_read_lock(void)
> >  {
> > -	*urcu_parity = get_urcu_qparity();
> > -	urcu_active_readers[*urcu_parity]++;
> > +	long tmp;
> > +
> > +	tmp = urcu_active_readers;
> > +	if ((tmp & RCU_GP_CTR_NEST_MASK) == 0)
> > +		urcu_active_readers = urcu_gp_ctr + 1;
> > +	else
> > +		urcu_active_readers = tmp + 1;
> >  	/*
> >  	 * Increment active readers count before accessing the pointer.
> >  	 * See force_mb_all_threads().
> > @@ -90,14 +106,14 @@ static inline void rcu_read_lock(int *urcu_parity)
> >  	barrier();
> >  }
> >  
> > -static inline void rcu_read_unlock(int *urcu_parity)
> > +static inline void rcu_read_unlock(void)
> >  {
> >  	barrier();
> >  	/*
> >  	 * Finish using rcu before decrementing the pointer.
> >  	 * See force_mb_all_threads().
> >  	 */
> > -	urcu_active_readers[*urcu_parity]--;
> > +	urcu_active_readers--;
> >  }
> >  
> >  extern void *urcu_publish_content(void **ptr, void *new);
> > 
> > 
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
