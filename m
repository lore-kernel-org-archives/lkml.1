Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695Ab0ANAP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab0ANAP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767Ab0ANAP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:15:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36797 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab0ANAP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:15:26 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory barrier (v5)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100113150324.GE30875@Krystal>
References: <20100113130716.B3DC.A69D9226@jp.fujitsu.com> <20100113150324.GE30875@Krystal>
Message-Id: <20100114085019.D716.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 09:15:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > > * KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> [...]
> > > > Why do we need both expedited and non-expedited mode? at least, this documentation
> > > > is bad. it suggest "you have to use non-expedited mode always!".
> > > 
> > > Right. Maybe I should rather write:
> > > 
> > >  + * @expedited: (0) Low overhead, but slow execution (few milliseconds)
> > >  + *             (1) Slightly higher overhead, fast execution (few microseconds)
> > > 
> > > And I could probably go as far as adding a few paragraphs:
> > > 
> > > Using the non-expedited mode is recommended for applications which can
> > > afford leaving the caller thread waiting for a few milliseconds. A good
> > > example would be a thread dedicated to execute RCU callbacks, which
> > > waits for callbacks to enqueue most of the time anyway.
> > > 
> > > The expedited mode is recommended whenever the application needs to have
> > > control returning to the caller thread as quickly as possible. An
> > > example of such application would be one which uses the same thread to
> > > perform data structure updates and issue the RCU synchronization.
> > > 
> > > It is perfectly safe to call both expedited and non-expedited
> > > sys_membarriers in a process.
> > > 
> > > 
> > > Does that help ?
> > 
> > Do librcu need both? I bet average programmer don't understand this
> > explanation. please recall, syscall interface are used by non kernel
> > developers too. If librcu only use either (0) or (1), I hope remove
> > another one.
> > 
> > But if librcu really need both, the above explanation is enough good.
> > I think.
> 
> As Paul said, we need both in liburcu. These usage scenarios are
> explained in the system call documentation.

ok. thanks.


> > > > > +	 * Memory barrier on the caller thread _before_ sending first
> > > > > +	 * IPI. Matches memory barriers around mm_cpumask modification in
> > > > > +	 * switch_mm().
> > > > > +	 */
> > > > > +	smp_mb();
> > > > > +	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
> > > > > +		membarrier_retry();
> > > > > +		goto unlock;
> > > > > +	}
> > > > 
> > > > if CONFIG_CPUMASK_OFFSTACK=1, alloc_cpumask_var call kmalloc. FWIW,
> > > > kmalloc calling seems destory the worth of this patch.
> > > 
> > > Why ? I'm not sure I understand your point. Even if we call kmalloc to
> > > allocate the cpumask, this is a constant overhead. The benefit of
> > > smp_call_function_many() over smp_call_function_single() is that it
> > > scales better by allowing to broadcast IPIs when the architecture
> > > supports it. Or maybe I'm missing something ?
> > 
> > It depend on what mean "constant overhead". kmalloc might cause
> > page reclaim and undeterministic delay. I'm not sure (1) How much
> > membarrier_retry() slower than smp_call_function_many and (2) Which do
> > you think important average or worst performance. Only I note I don't
> > think GFP_KERNEL is constant overhead.
> 
> 10,000,000 sys_membarrier calls (varying the number of threads to which
> we send IPIs), IPI-to-many, 8-core system:
> 
> T=1: 0m20.173s
> T=2: 0m20.506s
> T=3: 0m22.632s
> T=4: 0m24.759s
> T=5: 0m26.633s
> T=6: 0m29.654s
> T=7: 0m30.669s
> 
> Just doing local mb()+single IPI to T other threads:
> 
> T=1: 0m18.801s
> T=2: 0m29.086s
> T=3: 0m46.841s
> T=4: 0m53.758s
> T=5: 1m10.856s
> T=6: 1m21.142s
> T=7: 1m38.362s
> 
> So sending single IPIs adds about 1.5 microseconds per extra core. With
> the IPI-to-many scheme, we add about 0.2 microseconds per extra core. So
> we have a factor 10 gain in scalability. The initial cost of the cpumask
> allocation (which seems to be allocated on the stack in my config) is
> just about 1.4 microseconds. So here, we only have a small gain for the
> 1 IPI case, which does not justify the added complexity of dealing with
> it differently.

I'd like to discuss to separate CONFIG_CPUMASK_OFFSTACK=1 and CONFIG_CPUMASK_OFFSTACK=0.

CONFIG_CPUMASK_OFFSTACK=0 (your config)
	- cpumask is allocated on stask
	- alloc_cpumask_var() is nop (yes, nop is constant overhead ;)
	- alloc_cpumask_var() always return 1, then membarrier_retry() is never called.
	- alloc_cpumask_var() ignore GFP_KERNEL parameter

CONFIG_CPUMASK_OFFSTACK=1 and use GFP_KERNEL
	- cpumask is allocated on heap
	- alloc_cpumask_var() is the wrapper of kmalloc()
	- GFP_KERNEL parameter is passed kmalloc
	- GFP_KERNEL mean alloc_cpumask_var() always return 1, except
	  oom-killer case. IOW, membarrier_retry() is still never called
	  on typical use case.
	- kmalloc(GFP_KERNEL) might invoke page reclaim and it can spent few
	  seconds (not microseconds).

CONFIG_CPUMASK_OFFSTACK=1 and use GFP_ATOMIC
	- cpumask is allocated on heap
	- alloc_cpumask_var() is the wrapper of kmalloc()
	- GFP_ATOMIC mean kmalloc never invoke page reclaim. IOW, 
	  kmalloc() cost is nearly constant. (few or lots microseconds)
	- OTOH, alloc_cpumask_var() might fail, at that time membarrier_retry()
	  is called.

So, My last mail talked about CONFIG_CPUMASK_OFFSTACK=1, but you mesured CONFIG_CPUMASK_OFFSTACK=0.
That's the reason why our conclusion is different.

> 
> Also... it's pretty much a slow path anyway compared to the RCU
> read-side. I just don't want this slow path to scale badly.
> 
> > 
> > hmm...
> > Do you intend to GFP_ATOMIC?
> 
> Would it help to lower the allocation overhead ?

No. If the system have lots free memory, GFP_ATOMIC and GFP_KERNEL
don't have any difference. but if the system have no free memory,
GFP_KERNEL might cause big latency.


Perhaps, It is no big issue. If the system have no free memory, another
syscall will invoke page reclaim soon although sys_membarrier avoid it.
I'm not sure. It depend on librcu latency policy.

Another alternative plan is,

	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
		err = -ENOMEM;
		goto unlock;
	}

and kill membarrier_retry(). because CONFIG_CPUMASK_OFFSTACK=1 is
only used for SGI big hpc machine, it mean nobody can test membarrier_retry().
Never called function doesn't have lots worth.

Thought?



