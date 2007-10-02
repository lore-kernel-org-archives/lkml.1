Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbXJBR6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbXJBR6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXJBR55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:57:57 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:56356 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbXJBR54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:57:56 -0400
Date: Tue, 2 Oct 2007 22:02:00 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       tglx@linutronix.de, a.p.zijlstra@chello.nl, bunk@kernel.org,
       ego@in.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20071002180200.GB268@tv-sign.ru>
References: <20070910183412.GC3819@linux.vnet.ibm.com> <20070923173807.GA292@tv-sign.ru> <20070924001509.GG11123@linux.vnet.ibm.com> <20070926151351.GA328@tv-sign.ru> <20070927154652.GE16652@linux.vnet.ibm.com> <20070928144714.GA397@tv-sign.ru> <20070928185759.GC9153@linux.vnet.ibm.com> <20070930163102.GA374@tv-sign.ru> <Pine.LNX.4.64.0709301549160.19355@alien.or.mcafeemobile.com> <20071001013739.GB12494@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001013739.GB12494@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Paul E. McKenney wrote:
>
> On Sun, Sep 30, 2007 at 04:02:09PM -0700, Davide Libenzi wrote:
> > On Sun, 30 Sep 2007, Oleg Nesterov wrote:
> > 
> > > Ah, but I asked the different question. We must see CPU 1's stores by
> > > definition, but what about CPU 0's stores (which could be seen by CPU 1)?
> > > 
> > > Let's take a "real life" example,
> > > 
> > >                 A = B = X = 0;
> > >                 P = Q = &A;
> > > 
> > > CPU_0           CPU_1           CPU_2
> > > 
> > > P = &B;         *P = 1;         if (X) {
> > >                 wmb();                  rmb();
> > >                 X = 1;                  BUG_ON(*P != 1 && *Q != 1);
> > >                                 }
> > > 
> > > So, is it possible that CPU_1 sees P == &B, but CPU_2 sees P == &A ?
> > 
> > That can't be. CPU_2 sees X=1, that happened after (or same time at most - 
> > from a cache inv. POV) to *P=1, that must have happened after P=&B (in 
> > order for *P to assign B). So P=&B happened, from a pure time POV, before 
> > the rmb(), and the rmb() should guarantee that CPU_2 sees P=&B too.
> 
> Actually, CPU designers have to go quite a ways out of their way to
> prevent this BUG_ON from happening.  One way that it would happen
> naturally would be if the cache line containing P were owned by CPU 2,
> and if CPUs 0 and 1 shared a store buffer that they both snooped.  So,
> here is what could happen given careless or sadistic CPU designers:
> 
> o	CPU 0 stores &B to P, but misses the cache, so puts the
> 	result in the store buffer.  This means that only CPUs 0 and 1
> 	can see it.
> 
> o	CPU 1 fetches P, and sees &B, so stores a 1 to B.  Again,
> 	this value for P is visible only to CPUs 0 and 1.
> 
> o	CPU 1 executes a wmb(), which forces CPU 1's stores to happen
> 	in order.  But it does nothing about CPU 0's stores, nor about CPU
> 	1's loads, for that matter (and the only reason that POWER ends
> 	up working the way you would like is because wmb() turns into
> 	"sync" rather than the "eieio" instruction that would have been
> 	used for smp_wmb() -- which is maybe what Oleg was thinking of,
> 	but happened to abbreviate.  If my analysis is buggy, Anton and
> 	Paulus will no doubt correct me...)
> 
> o	CPU 1 stores to X.
> 
> o	CPU 2 loads X, and sees that the value is 1.
> 
> o	CPU 2 does an rmb(), which orders its loads, but does nothing
> 	about anyone else's loads or stores.
> 
> o	CPU 2 fetches P from its cached copy, which still points to A,
> 	which is still zero.  So the BUG_ON fires.
> 
> o	Some time later, CPU 0 gets the cache line containing P from
> 	CPU 2, and updates it from the value in the store buffer, but
> 	too late...
> 
> Unfortunately, cache-coherence protocols don't care much about pure
> time...  It is possible to make a 16-CPU machine believe that a single
> variable has more than ten different values -at- -the- -same- -time-.

Davide, Paul, thank you very much! I've been wondering about this for the
long time, now I know the answer. Great.

Oleg.

