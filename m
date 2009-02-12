Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbZBLUDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbZBLUDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbZBLUCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:02:51 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40293 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZBLUCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:02:51 -0500
Date: Thu, 12 Feb 2009 12:02:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212200249.GG6759@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090211185203.GA29852@Krystal> <20090211200903.GG6694@linux.vnet.ibm.com> <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal> <20090212164621.GC6759@linux.vnet.ibm.com> <20090212192941.GC2047@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212192941.GC2047@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 02:29:41PM -0500, Mathieu Desnoyers wrote:
> 
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> [...]
> > diff --git a/urcu.c b/urcu.c
> > index f2aae34..a696439 100644
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
> OK, this is where I think our points of view differ. Please refer to
> http://lkml.org/lkml/2007/6/18/299.
> 
> Basically, cpu_relax() used in the Linux kernel has an
> architecture-specific implementation which *could* include a smp_rmb()
> if the architecture doesn't notice writes done by other CPUs. I think
> Blackfin is the only architecture currently supported by the Linux
> kernel which defines cpu_relax() as a smp_mb(), because it does not have
> cache coherency.
> 
> Therefore, I propose that we create a memory barrier macro which is
> defined as a 
>   barrier()   when the cpu has cache coherency
>   cache flush when the cpu does not have cache coherency and is
>               compiled with smp support.
> 
> We could call that
> 
>   smp_wmc() (for memory-coherency or memory commit)
>   smp_rmc()
>   smp_mc()
> 
> It would be a good way to identify the location where data exchange
> between memory and the local cache are is required in the algorithm.
> What do you think ?

Actually the best way to do this would be:

	while (ACCESS_ONCE(sig_done) < 1)
		continue;

If ACCESS_ONCE() needs to be made architecture-specific to make this
really work on Blackfin, we should make that change.  And, now that
you mention it, I have heard rumors that other CPU families can violate
cache coherence in some circumstances.

So perhaps ACCESS_ONCE() becomes:

#ifdef CONFIG_ARCH_CACHE_COHERENT
#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
#else /* #ifdef CONFIG_ARCH_CACHE_COHERENT */
#define ACCESS_ONCE(x)     ({ \
				typeof(x) _________x1; \
				_________x1 = (*(volatile typeof(x) *)&(x)); \
				cpu_relax(); \
				(_________x1); \
				})
#endif /* #else #ifdef CONFIG_ARCH_CACHE_COHERENT */

Seem reasonable?

							Thanx, Paul
