Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbXJARHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbXJARHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXJARGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:06:39 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58609 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbXJARGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:06:37 -0400
Date: Sun, 30 Sep 2007 18:20:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       mingo@elte.hu, akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20071001012013.GA12494@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070923173807.GA292@tv-sign.ru> <20070924001509.GG11123@linux.vnet.ibm.com> <20070926151351.GA328@tv-sign.ru> <20070927154652.GE16652@linux.vnet.ibm.com> <20070928144714.GA397@tv-sign.ru> <20070928185759.GC9153@linux.vnet.ibm.com> <20070930163102.GA374@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070930163102.GA374@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 08:31:02PM +0400, Oleg Nesterov wrote:
> On 09/28, Paul E. McKenney wrote:
> >
> > On Fri, Sep 28, 2007 at 06:47:14PM +0400, Oleg Nesterov wrote:
> > > Ah, I was confused by the comment,
> > > 
> > > 	smp_mb();  /* Don't call for memory barriers before we see zero. */
> > > 	                                             ^^^^^^^^^^^^^^^^^^
> > > So, in fact, we need this barrier to make sure that _other_ CPUs see these
> > > changes in order, thanks. Of course, _we_ already saw zero.
> > 
> > Fair point!
> > 
> > Perhaps: "Ensure that all CPUs see their rcu_mb_flag -after- the
> > rcu_flipctrs sum to zero" or some such?
> > 
> > > But in that particular case this doesn't matter, rcu_try_flip_waitzero()
> > > is the only function which reads the "non-local" per_cpu(rcu_flipctr), so
> > > it doesn't really need the barrier? (besides, it is always called under
> > > fliplock).
> > 
> > The final rcu_read_unlock() that zeroed the sum was -not- under fliplock,
> > so we cannot necessarily rely on locking to trivialize all of this.
> 
> Yes, but still I think this mb() is not necessary. Becasue we don't need
> the "if we saw rcu_mb_flag we must see sum(lastidx)==0" property. When another
> CPU calls rcu_try_flip_waitzero(), it will use another lastidx. OK, minor issue,
> please forget.

Will do!  ;-)

> > > OK, the last (I promise :) off-topic question. When CPU 0 and 1 share a
> > > store buffer, the situation is simple, we can replace "CPU 0 stores" with
> > > "CPU 1 stores". But what if CPU 0 is equally "far" from CPUs 1 and 2?
> > > 
> > > Suppose that CPU 1 does
> > > 
> > > 	wmb();
> > > 	B = 0
> > > 
> > > Can we assume that CPU 2 doing
> > > 
> > > 	if (B == 0) {
> > > 		rmb();
> > > 
> > > must see all invalidations from CPU 0 which were seen by CPU 1 before wmb() ?
> > 
> > Yes.  CPU 2 saw something following CPU 1's wmb(), so any of CPU 2's
> > reads following its rmb() must therefore see all of CPU 1's stores
> > preceding the wmb().
> 
> Ah, but I asked the different question. We must see CPU 1's stores by
> definition, but what about CPU 0's stores (which could be seen by CPU 1)?
> 
> Let's take a "real life" example,
> 
>                 A = B = X = 0;
>                 P = Q = &A;
> 
> CPU_0           CPU_1           CPU_2
> 
> P = &B;         *P = 1;         if (X) {
>                 wmb();                  rmb();
>                 X = 1;                  BUG_ON(*P != 1 && *Q != 1);
>                                 }
> 
> So, is it possible that CPU_1 sees P == &B, but CPU_2 sees P == &A ?

It depends.  ;-)

o	Itanium: because both wmb() and rmb() map to the "mf"
	instruction, and because "mf" instructions map to a
	single global order, the BUG_ON cannot happen.  (But
	I could easily be mistaken -- I cannot call myself an
	Itanium memory-ordering expert.)  See:

	ftp://download.intel.com/design/Itanium/Downloads/25142901.pdf
	
	for the official story.

o	POWER: because wmb() maps to the "sync" instruction,
	cumulativity applies, so that any instruction provably
	following "X = 1" will see "P = &B" if the "*P = 1"
	statement saw it.  So the BUG_ON cannot happen.

o	i386: memory ordering respects transitive visibility,
	which seems to be similar to POWER's cumulativity
	(http://developer.intel.com/products/processor/manuals/318147.pdf),
	so the BUG_ON cannot happen.

o	x86_64: same as i386.

o	s390: the basic memory-ordering model is tight enough that the
	BUG_ON cannot happen.  (If I am confused about this, the s390
	guys will not be shy about correcting me!)

o	ARM: beats the heck out of me.

> > The other approach would be to simply have a separate thread for this
> > purpose.  Batching would amortize the overhead (a single trip around the
> > CPUs could satisfy an arbitrarily large number of synchronize_sched()
> > requests).
> 
> Yes, this way we don't need to uglify migration_thread(). OTOH, we need
> another kthread ;)

True enough!!!

							Thanx, Paul
