Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbZBLUfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbZBLUfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbZBLUfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:35:08 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34047 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZBLUfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:35:06 -0500
Date: Thu, 12 Feb 2009 12:35:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212203504.GJ6759@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal> <20090212164621.GC6759@linux.vnet.ibm.com> <20090212192941.GC2047@Krystal> <20090212200249.GG6759@linux.vnet.ibm.com> <20090212200937.GE2047@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212200937.GE2047@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 03:09:37PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Thu, Feb 12, 2009 at 02:29:41PM -0500, Mathieu Desnoyers wrote:
> > > 
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > [...]
> > > > diff --git a/urcu.c b/urcu.c
> > > > index f2aae34..a696439 100644
> > > > --- a/urcu.c
> > > > +++ b/urcu.c
> > > > @@ -99,7 +99,8 @@ static void force_mb_single_thread(pthread_t tid)
> > > >  	 * BUSY-LOOP.
> > > >  	 */
> > > >  	while (sig_done < 1)
> > > > -		smp_rmb();	/* ensure we re-read sig-done */
> > > > +		barrier();	/* ensure compiler re-reads sig-done */
> > > > +				/* cache coherence guarantees CPU re-read. */
> > > 
> > > OK, this is where I think our points of view differ. Please refer to
> > > http://lkml.org/lkml/2007/6/18/299.
> > > 
> > > Basically, cpu_relax() used in the Linux kernel has an
> > > architecture-specific implementation which *could* include a smp_rmb()
> > > if the architecture doesn't notice writes done by other CPUs. I think
> > > Blackfin is the only architecture currently supported by the Linux
> > > kernel which defines cpu_relax() as a smp_mb(), because it does not have
> > > cache coherency.
> > > 
> > > Therefore, I propose that we create a memory barrier macro which is
> > > defined as a 
> > >   barrier()   when the cpu has cache coherency
> > >   cache flush when the cpu does not have cache coherency and is
> > >               compiled with smp support.
> > > 
> > > We could call that
> > > 
> > >   smp_wmc() (for memory-coherency or memory commit)
> > >   smp_rmc()
> > >   smp_mc()
> > > 
> > > It would be a good way to identify the location where data exchange
> > > between memory and the local cache are is required in the algorithm.
> > > What do you think ?
> > 
> > Actually the best way to do this would be:
> > 
> > 	while (ACCESS_ONCE(sig_done) < 1)
> > 		continue;
> > 
> 
> Interesting idea. Maybe we should define an accessor for the data write
> too ?

I like having just ACCESS_ONCE(), but I suppose I could live with
separate LOAD_ONCE() and STORE_ONCE() primitives.

But I am not yet convinced that this is needed, as I am not aware of any
architecture that would buffer writes forever.  (Doesn't mean that there
isn't one, but it does not make sense to complicate the API just on
speculation.)

> But I suspect that in a lot of situations, what we will really want is
> to do a bunch of read/writes, and only at a particular point do the
> cache flush.

That could happen, and in fact is why the separate
smp_read_barrier_depends() primitive exists.  But I -strongly-
discourage its use -- code using rcu_dereference() is -much- easier to
read and understand.  So if the series of reads/writes was short, I
would say to just bite the bullet and take the multiple primitives.

If nothing else, this might encourage hardware manufacturers to do the
right thing.  ;-)

> > If ACCESS_ONCE() needs to be made architecture-specific to make this
> > really work on Blackfin, we should make that change.  And, now that
> > you mention it, I have heard rumors that other CPU families can violate
> > cache coherence in some circumstances.
> > 
> > So perhaps ACCESS_ONCE() becomes:
> > 
> > #ifdef CONFIG_ARCH_CACHE_COHERENT
> > #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
> > #else /* #ifdef CONFIG_ARCH_CACHE_COHERENT */
> > #define ACCESS_ONCE(x)     ({ \
> > 				typeof(x) _________x1; \
> > 				_________x1 = (*(volatile typeof(x) *)&(x)); \
> > 				cpu_relax(); \
> 
> I don't think cpu_relax would be the correct primitive to use here. We
> definitely don't want a "rep; nop;" or anything like this which _slows
> down_ the access. It's just a different goal we are pursuing. So using
> something like smp_rmc within the ACCESS_ONCE() macro in this case as I
> proposed in the other mail still seems to make sense.

Well, x86 would have CONFIG_ARCH_CACHE_COHERENT, so it would instead
use the old definition -- so no "rep; nop;" in any case.

Probably whatever takes the place of cpu_relax() is arch-dependent
anyway.

							Thanx, Paul

> Mathieu
> 
> > 				(_________x1); \
> > 				})
> > #endif /* #else #ifdef CONFIG_ARCH_CACHE_COHERENT */
> > 
> > Seem reasonable?
> > 
> > 							Thanx, Paul
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
