Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbXJARGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbXJARGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbXJARGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:06:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54254 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbXJARGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:06:31 -0400
Date: Sun, 30 Sep 2007 18:37:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20071001013739.GB12494@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070923173807.GA292@tv-sign.ru> <20070924001509.GG11123@linux.vnet.ibm.com> <20070926151351.GA328@tv-sign.ru> <20070927154652.GE16652@linux.vnet.ibm.com> <20070928144714.GA397@tv-sign.ru> <20070928185759.GC9153@linux.vnet.ibm.com> <20070930163102.GA374@tv-sign.ru> <Pine.LNX.4.64.0709301549160.19355@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709301549160.19355@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 04:02:09PM -0700, Davide Libenzi wrote:
> On Sun, 30 Sep 2007, Oleg Nesterov wrote:
> 
> > Ah, but I asked the different question. We must see CPU 1's stores by
> > definition, but what about CPU 0's stores (which could be seen by CPU 1)?
> > 
> > Let's take a "real life" example,
> > 
> >                 A = B = X = 0;
> >                 P = Q = &A;
> > 
> > CPU_0           CPU_1           CPU_2
> > 
> > P = &B;         *P = 1;         if (X) {
> >                 wmb();                  rmb();
> >                 X = 1;                  BUG_ON(*P != 1 && *Q != 1);
> >                                 }
> > 
> > So, is it possible that CPU_1 sees P == &B, but CPU_2 sees P == &A ?
> 
> That can't be. CPU_2 sees X=1, that happened after (or same time at most - 
> from a cache inv. POV) to *P=1, that must have happened after P=&B (in 
> order for *P to assign B). So P=&B happened, from a pure time POV, before 
> the rmb(), and the rmb() should guarantee that CPU_2 sees P=&B too.

Actually, CPU designers have to go quite a ways out of their way to
prevent this BUG_ON from happening.  One way that it would happen
naturally would be if the cache line containing P were owned by CPU 2,
and if CPUs 0 and 1 shared a store buffer that they both snooped.  So,
here is what could happen given careless or sadistic CPU designers:

o	CPU 0 stores &B to P, but misses the cache, so puts the
	result in the store buffer.  This means that only CPUs 0 and 1
	can see it.

o	CPU 1 fetches P, and sees &B, so stores a 1 to B.  Again,
	this value for P is visible only to CPUs 0 and 1.

o	CPU 1 executes a wmb(), which forces CPU 1's stores to happen
	in order.  But it does nothing about CPU 0's stores, nor about CPU
	1's loads, for that matter (and the only reason that POWER ends
	up working the way you would like is because wmb() turns into
	"sync" rather than the "eieio" instruction that would have been
	used for smp_wmb() -- which is maybe what Oleg was thinking of,
	but happened to abbreviate.  If my analysis is buggy, Anton and
	Paulus will no doubt correct me...)

o	CPU 1 stores to X.

o	CPU 2 loads X, and sees that the value is 1.

o	CPU 2 does an rmb(), which orders its loads, but does nothing
	about anyone else's loads or stores.

o	CPU 2 fetches P from its cached copy, which still points to A,
	which is still zero.  So the BUG_ON fires.

o	Some time later, CPU 0 gets the cache line containing P from
	CPU 2, and updates it from the value in the store buffer, but
	too late...

Unfortunately, cache-coherence protocols don't care much about pure
time...  It is possible to make a 16-CPU machine believe that a single
variable has more than ten different values -at- -the- -same- -time-.
This is easy to do -- have all the CPUs store different values to the
same variable at the same time, then reload, collecting timestamps
between each pair of operations.  On a large SMP, the values will sit
in the store buffers for many hundreds of nanoseconds, perhaps even
several microseconds, while the cache line containing the variable
being stored to shuttles around among the CPUs.  ;-)

						Thanx, Paul
