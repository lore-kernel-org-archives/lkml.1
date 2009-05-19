Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZESMps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZESMps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZESMpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:45:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbZESMpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:45:42 -0400
Date: Tue, 19 May 2009 14:44:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, davem@davemloft.net, dada1@cosmosbay.com,
       zbr@ioremap.net, jeff.chua.linux@gmail.com, paulus@samba.org,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH RFC] v5 expedited "big hammer" RCU grace periods
Message-ID: <20090519124436.GA6238@elte.hu>
References: <20090517191141.GA25915@linux.vnet.ibm.com> <20090518075630.GA10687@elte.hu> <20090518151421.GB6768@linux.vnet.ibm.com> <20090518154241.GA27047@elte.hu> <20090518160254.GD6768@linux.vnet.ibm.com> <20090519085825.GA9388@elte.hu> <20090519123316.GA7159@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519123316.GA7159@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, May 19, 2009 at 10:58:25AM +0200, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > On Mon, May 18, 2009 at 05:42:41PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > > i might be missing something fundamental here, but why not just 
> > > > > > have per CPU helper threads, all on the same waitqueue, and wake 
> > > > > > them up via a single wake_up() call? That would remove the SMP 
> > > > > > cross call (wakeups do immediate cross-calls already).
> > > > > 
> > > > > My concern with this is that the cache misses accessing all the 
> > > > > processes on this single waitqueue would be serialized, slowing 
> > > > > things down. In contrast, the bitmask that smp_call_function() 
> > > > > traverses delivers on the order of a thousand CPUs' worth of bits 
> > > > > per cache miss.  I will give it a try, though.
> > > > 
> > > > At least if you go via the migration threads, you can queue up 
> > > > requests to them locally. But there's going to be cachemisses 
> > > > _anyway_, since you have to access them all from a single CPU, 
> > > > and then they have to fetch details about what to do, and then 
> > > > have to notify the originator about completion.
> > > 
> > > Ah, so you are suggesting that I use smp_call_function() to run 
> > > code on each CPU that wakes up that CPU's migration thread?  I 
> > > will take a look at this.
> > 
> > My suggestion was to queue up a dummy 'struct migration_req' up with 
> > it (change migration_req::task == NULL to mean 'nothing') and simply 
> > wake it up using wake_up_process().
> 
> OK.  I was thinking of just using wake_up_process() without the
> migration_req structure, and unconditionally setting a per-CPU
> variable from within migration_thread() just before the list_empty()
> check.  In your approach we would need a NULL-pointer check just
> before the call to __migrate_task().
> 
> > That will force a quiescent state, without the need for any extra 
> > information, right?
> 
> Yep!
> 
> > This is what the scheduler code does, roughly:
> > 
> >                 wake_up_process(rq->migration_thread);
> >                 wait_for_completion(&req.done);
> > 
> > and this will always have to perform well. The 'req' could be put 
> > into PER_CPU, and a loop could be done like this:
> > 
> > 	for_each_online_cpu(cpu)
> >                 wake_up_process(cpu_rq(cpu)->migration_thread);
> > 
> > 	for_each_online_cpu(cpu)
> >                 wait_for_completion(&per_cpu(req, cpu).done);
> > 
> > hm?
> 
> My concern is the linear slowdown for large systems, but this 
> should be OK for modest systems (a few 10s of CPUs).  However, I 
> will try it out -- it does not need to be a long-term solution, 
> after all.

I think there is going to be a linear slowdown no matter what - 
because sending that many IPIs is going to be linear. (there are no 
'broadcast to all' IPIs anymore - on x86 we only have them if all 
physical APIC IDs are 7 or smaller.)

Also, no matter what scheme we use, the target CPU does have to be 
processed somehow and it does have to signal completion back somehow 
- which generates cachemisses.

I think what probaby matters most is to go simple, and to use 
established kernel primitives - and the above is really typical 
pattern for things like TLB flushes to a process having a presence 
on every physical CPU. Those aspects will be kept reasonably fast 
and balanced on all hardware that matters. (and if not, people will 
notice any TLB flush/shootdown linear slowdowns and will address it)

I could be wrong though ... maybe someone can get some numbers from 
a really large system?

	Ingo
