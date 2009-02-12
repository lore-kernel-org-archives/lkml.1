Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbZBLVPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbZBLVPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZBLVPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:15:42 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:55131 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbZBLVPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:15:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAAsblElMQWt2/2dsb2JhbACBbtIlhBgG
Date: Thu, 12 Feb 2009 16:15:38 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212211538.GA6135@Krystal>
References: <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal> <20090212164621.GC6759@linux.vnet.ibm.com> <20090212192941.GC2047@Krystal> <20090212200249.GG6759@linux.vnet.ibm.com> <20090212200937.GE2047@Krystal> <20090212203504.GJ6759@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090212203504.GJ6759@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:35:51 up 42 days, 20:34,  5 users,  load average: 1.25, 0.72,
	0.49
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Thu, Feb 12, 2009 at 03:09:37PM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Thu, Feb 12, 2009 at 02:29:41PM -0500, Mathieu Desnoyers wrote:
> > > > 
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > [...]
> > > > > diff --git a/urcu.c b/urcu.c
> > > > > index f2aae34..a696439 100644
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
> > > > OK, this is where I think our points of view differ. Please refer to
> > > > http://lkml.org/lkml/2007/6/18/299.
> > > > 
> > > > Basically, cpu_relax() used in the Linux kernel has an
> > > > architecture-specific implementation which *could* include a smp_rmb()
> > > > if the architecture doesn't notice writes done by other CPUs. I think
> > > > Blackfin is the only architecture currently supported by the Linux
> > > > kernel which defines cpu_relax() as a smp_mb(), because it does not have
> > > > cache coherency.
> > > > 
> > > > Therefore, I propose that we create a memory barrier macro which is
> > > > defined as a 
> > > >   barrier()   when the cpu has cache coherency
> > > >   cache flush when the cpu does not have cache coherency and is
> > > >               compiled with smp support.
> > > > 
> > > > We could call that
> > > > 
> > > >   smp_wmc() (for memory-coherency or memory commit)
> > > >   smp_rmc()
> > > >   smp_mc()
> > > > 
> > > > It would be a good way to identify the location where data exchange
> > > > between memory and the local cache are is required in the algorithm.
> > > > What do you think ?
> > > 
> > > Actually the best way to do this would be:
> > > 
> > > 	while (ACCESS_ONCE(sig_done) < 1)
> > > 		continue;
> > > 
> > 
> > Interesting idea. Maybe we should define an accessor for the data write
> > too ?
> 
> I like having just ACCESS_ONCE(), but I suppose I could live with
> separate LOAD_ONCE() and STORE_ONCE() primitives.
> 
> But I am not yet convinced that this is needed, as I am not aware of any
> architecture that would buffer writes forever.  (Doesn't mean that there
> isn't one, but it does not make sense to complicate the API just on
> speculation.)
> 

Blackfin has a non-coherent cache, which is the equivalent of buffering
writes forever and never reader data from memory unless it's required
to. Given the increasing amount of cores we currently see and the always
lower power consumption, I foresee that we might have to deal with such
model in a future closer than what we expect.

> > But I suspect that in a lot of situations, what we will really want is
> > to do a bunch of read/writes, and only at a particular point do the
> > cache flush.
> 
> That could happen, and in fact is why the separate
> smp_read_barrier_depends() primitive exists.  But I -strongly-
> discourage its use -- code using rcu_dereference() is -much- easier to
> read and understand.  So if the series of reads/writes was short, I
> would say to just bite the bullet and take the multiple primitives.
> 

Hrm, how about :

LOAD_REMOTE(), STORE_REMOTE()

So this leaves ACCESS_ONCE() as a simple compiler optimization
restriction, which is the meaning it always had.



#ifdef CONFIG_HAVE_MEM_COHERENCY
/*
 * Caches are coherent, no need to flush them.
 */
#define mc()	barrier()
#define rmc()	barrier()
#define wmc()	barrier()
#else
#error "The architecture must create its own cache flush primitives"
#define mc()	arch_cache_flush()
#define rmc()	arch_cache_flush_read()
#define wmc()	arch_cache_flush_write()
#endif


#ifdef CONFIG_HAVE_MEM_COHERENCY

/* x86 32/64 specific */
#ifdef CONFIG_HAVE_FENCE
#define mb()    asm volatile("mfence":::"memory")
#define rmb()   asm volatile("lfence":::"memory")
#define wmb()   asm volatile("sfence"::: "memory")
#else
/*
 * Some non-Intel clones support out of order store. wmb() ceases to be a
 * nop for these.
 */
#define mb()    asm volatile("lock; addl $0,0(%%esp)":::"memory")
#define rmb()   asm volatile("lock; addl $0,0(%%esp)":::"memory")
#define wmb()   asm volatile("lock; addl $0,0(%%esp)"::: "memory")
#endif

#else /* !CONFIG_HAVE_MEM_COHERENCY */

/*
 * Without cache coherency, the memory barriers become cache flushes.
 */
#define mb()    mc()
#define rmb()   rmc()
#define wmb()   wmc()

#endif /* !CONFIG_HAVE_MEM_COHERENCY */


#ifdef CONFIG_SMP
#define smp_mb()	mb()
#define smp_rmb()	rmb()
#define smp_wmb()	wmb()
#define smp_mc()	mc()
#define smp_rmc()	rmc()
#define smp_wmc()	wmc()
#else
#define smp_mb()	barrier()
#define smp_rmb()	barrier()
#define smp_wmb()	barrier()
#define smp_mc()	barrier()
#define smp_rmc()	barrier()
#define smp_wmc()	barrier()
#endif


#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))

/*
 * Load a data from remote memory, doing a cache flush if required.
 */
#define LOAD_REMOTE(p)	       ({ \
				smp_rmc(); \
				typeof(p) _________p1 = ACCESS_ONCE(p); \
				(_________p1); \
				})

/*
 * Store v into x, where x is located in remote memory. Performs the required
 * cache flush after writing.
 */
#define STORE_REMOTE(x, v) \
	do { \
		(x) = (v); \
		smp_wmc; \
	} while (0)

/**
 * rcu_dereference - fetch an RCU-protected pointer in an
 * RCU read-side critical section.  This pointer may later
 * be safely dereferenced.
 *
 * Inserts memory barriers on architectures that require them
 * (currently only the Alpha), and, more importantly, documents
 * exactly which pointers are protected by RCU.
 */

#define rcu_dereference(p)     ({ \
				typeof(p) _________p1 = LOAD_REMOTE(p); \
				smp_read_barrier_depends(); \
				(_________p1); \
				})


So we would use "LOAD_REMOTE" instead of ACCESS_ONCE when we want to
read the remote pointer atomically. STORE_REMOTE would be used to write
to it.

Reading can be done in batch with :

smp_rmc();
... read many values ...


Writing :
... write many values ...
smp_wmc();


> If nothing else, this might encourage hardware manufacturers to do the
> right thing.  ;-)
> 

The "right thing" has a cost and, sadly, the tradeoff is different in
multi-cpu low-power architectures.

> > > If ACCESS_ONCE() needs to be made architecture-specific to make this
> > > really work on Blackfin, we should make that change.  And, now that
> > > you mention it, I have heard rumors that other CPU families can violate
> > > cache coherence in some circumstances.
> > > 
> > > So perhaps ACCESS_ONCE() becomes:
> > > 
> > > #ifdef CONFIG_ARCH_CACHE_COHERENT
> > > #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
> > > #else /* #ifdef CONFIG_ARCH_CACHE_COHERENT */
> > > #define ACCESS_ONCE(x)     ({ \
> > > 				typeof(x) _________x1; \
> > > 				_________x1 = (*(volatile typeof(x) *)&(x)); \
> > > 				cpu_relax(); \
> > 

Hrm, and also we would need a smp_rmc() *before* reading x here... so
the ACCESS_ONCE implementation above only works in loops, which is bad.

> > I don't think cpu_relax would be the correct primitive to use here. We
> > definitely don't want a "rep; nop;" or anything like this which _slows
> > down_ the access. It's just a different goal we are pursuing. So using
> > something like smp_rmc within the ACCESS_ONCE() macro in this case as I
> > proposed in the other mail still seems to make sense.
> 
> Well, x86 would have CONFIG_ARCH_CACHE_COHERENT, so it would instead
> use the old definition -- so no "rep; nop;" in any case.

Which has a performance impact, and is very wrong. We are not only using
ACCESS_ONCE in busy-loops....

Mathieu

> 
> Probably whatever takes the place of cpu_relax() is arch-dependent
> anyway.
> 
> 							Thanx, Paul
> 
> > Mathieu
> > 
> > > 				(_________x1); \
> > > 				})
> > > #endif /* #else #ifdef CONFIG_ARCH_CACHE_COHERENT */
> > > 
> > > Seem reasonable?
> > > 
> > > 							Thanx, Paul
> > > 
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
