Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZDVHgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZDVHgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 03:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZDVHgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 03:36:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51298 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZDVHgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 03:36:05 -0400
Date: Wed, 22 Apr 2009 09:35:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, paulmck@linux.vnet.ibm.com,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       kaber@trash.net, jeff.chua.linux@gmail.com, laijs@cn.fujitsu.com,
       jengelh@medozas.de, r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH] netfilter: use per-cpu recursive lock (v11)
Message-ID: <20090422073524.GA31835@elte.hu>
References: <20090420103414.1b4c490f@nehalam> <49ECBE0A.7010303@cosmosbay.com> <18924.59347.375292.102385@cargo.ozlabs.ibm.com> <20090420215827.GK6822@linux.vnet.ibm.com> <18924.64032.103954.171918@cargo.ozlabs.ibm.com> <20090420160121.268a8226@nehalam> <alpine.LFD.2.00.0904210831560.2199@localhost.localdomain> <20090421111541.228e977a@nehalam> <20090421191007.GA15485@elte.hu> <49EE2293.4090201@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49EE2293.4090201@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Ingo Molnar a écrit :
> > 
> > Why not use the obvious solution: a _single_ wrlock for global 
> > access and read_can_lock() plus per cpu locks in the fastpath?
> 
> Obvious is not the qualifier I would use :)
> 
> Brilliant yes :)

thanks :)

> > That way there's no global cacheline bouncing (just the 
> > _reading_ of a global cacheline - which will be nicely localized 
> > - on NUMA too) - and we will hold at most 1-2 locks at once!
> > 
> > Something like:
> > 
> > 	__cacheline_aligned DEFINE_RWLOCK(global_wrlock);
> > 
> > 	DEFINE_PER_CPU(rwlock_t local_lock);
> > 
> > 
> > 	void local_read_lock(void)
> > 	{
> > 	again:
> > 		read_lock(&per_cpu(local_lock, this_cpu));
> 
> Hmm... here we can see global_wrlock locked by on writer, while 
> this cpu already called local_read_lock(), and calls again this 
> function -> Deadlock, because we hold our local_lock locked.

Yeah, indeed.

I wasnt really concentrating on the nested case, i was concentrating 
on the scalability and lock nesting angle. I think the code 
submitted here looks rather incestous in that regard.

Allowing nested locking _on the same CPU_ is asking for trouble. Use 
short critical sections and if there's any exclusion needed, use an 
irq-safe lock or a softirq-safe lock. Problem solved.

> Very interesting and could be changed to use spinlock + depth per 
> cpu.
> 
> -> we can detect recursion and avoid the deadlock, and we only use 
> one atomic operation per lock/unlock pair in fastpath (this was 
> the reason we tried hard to use a percpu spinlock during this 
> thread)
> 
> 
> __cacheline_aligned DEFINE_RWLOCK(global_wrlock);
> 
> struct ingo_local_lock {
> 	spinlock_t lock;
> 	int depth;
> };
> DEFINE_PER_CPU(struct ingo_local_lock local_lock);
> 
> 
> void local_read_lock(void)
> {
> 	struct ingo_local_lock *lck;
> 
> 	local_bh_and_preempt_disable();
> 	lck = &get_cpu_var(local_lock);
> 	if (++lck->depth > 0) /* already locked */
> 		return;
> again:
> 	spin_lock(&lck->lock);
> 
> 	if (unlikely(!read_can_lock(&global_wrlock))) {
> 		spin_unlock(&lck->lock);
> 		/*
> 		 * Just wait for any global write activity:
> 		 */
> 		read_unlock_wait(&global_wrlock);
> 		goto again;
> 	}
> }
> 
> void global_write_lock(void)
> {
> 	write_lock(&global_wrlock);
> 
> 	for_each_possible_cpu(i)
> 		spin_unlock_wait(&per_cpu(local_lock, i));
> }
> 
> Hmm ?

Yeah, this looks IRQ-nesting safe. But i really have to ask: why 
does this code try so hard to allow same-CPU nesting?

Nesting on the same CPU is _bad_ for several reasons:

1) Performance: it rips apart critical sections cache-wise. Instead 
   of a nice:

       C1 ... C2 ... C3 ... C4

   serial sequence of critical sections, we get:
 
       C1A ... ( C2 ) ... C1B ... C3 ... C4

   Note that C1 got "ripped apart" into C1A and C1B with C2 injected 
   - reducing cache locality between C1A and C1B. We have to execute
   C1B no matter what, so we didnt actually win anything in terms of 
   total work to do, by processing C2 out of order.

   [ Preemption of work (which this kind of nesting is really about)
     is _the anti-thesis of performance_, and we try to delay it as
     much as possible and we try to batch up as much as possible. 
     For example the CPU scheduler will try _real_ hard to not 
     preempt a typical workload, as long as external latency 
     boundaries allow that. ]

2) Locking complexity and robustness. Nested locking is rank #1 in
   terms of introducing regressions into the kernel.

3) Instrumentation/checking complexity. Checking locking 
   dependencies is good and catches a boatload of bugs before they 
   hit upstream, and nested locks are supported but cause an 
   exponential explosion in terms of dependencies to check.

   Also, whenever instrumentation explodes is typically the sign of 
   some true, physical complexity that has been introduced into the 
   code. So it often is a canary for a misdesign at a fundamental 
   level, not a failure in the instrumentation framework.

In the past i saw lock nesting often used as a wrong solution when 
the critical sections were too long (causing too long latencies for 
critical work - e.g. delaying hardirq completion processing 
unreasonably), or just plain out of confusion about the items above.

I dont know whether that's the case here - it could be one of the 
rare exceptions calling for a new locking primitive (which should 
then be introduced at the core kernel level IMHO) - i dont know the 
code that well.

	Ingo
