Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504Ab0ANCQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0ANCQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476Ab0ANCQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:16:50 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:41147 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab0ANCQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:16:50 -0500
Date: Wed, 13 Jan 2010 21:16:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100114021645.GA28784@Krystal>
References: <20100113130716.B3DC.A69D9226@jp.fujitsu.com> <20100113150324.GE30875@Krystal> <20100114085019.D716.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100114085019.D716.A69D9226@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 21:02:05 up 28 days, 10:20,  5 users,  load average: 0.10, 0.13,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > * KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
[...]
> > > It depend on what mean "constant overhead". kmalloc might cause
> > > page reclaim and undeterministic delay. I'm not sure (1) How much
> > > membarrier_retry() slower than smp_call_function_many and (2) Which do
> > > you think important average or worst performance. Only I note I don't
> > > think GFP_KERNEL is constant overhead.
> > 
> > 10,000,000 sys_membarrier calls (varying the number of threads to which
> > we send IPIs), IPI-to-many, 8-core system:
> > 
> > T=1: 0m20.173s
> > T=2: 0m20.506s
> > T=3: 0m22.632s
> > T=4: 0m24.759s
> > T=5: 0m26.633s
> > T=6: 0m29.654s
> > T=7: 0m30.669s
> > 
> > Just doing local mb()+single IPI to T other threads:
> > 
> > T=1: 0m18.801s
> > T=2: 0m29.086s
> > T=3: 0m46.841s
> > T=4: 0m53.758s
> > T=5: 1m10.856s
> > T=6: 1m21.142s
> > T=7: 1m38.362s
> > 
> > So sending single IPIs adds about 1.5 microseconds per extra core. With
> > the IPI-to-many scheme, we add about 0.2 microseconds per extra core. So
> > we have a factor 10 gain in scalability. The initial cost of the cpumask
> > allocation (which seems to be allocated on the stack in my config) is
> > just about 1.4 microseconds. So here, we only have a small gain for the
> > 1 IPI case, which does not justify the added complexity of dealing with
> > it differently.
> 
> I'd like to discuss to separate CONFIG_CPUMASK_OFFSTACK=1 and CONFIG_CPUMASK_OFFSTACK=0.
> 
> CONFIG_CPUMASK_OFFSTACK=0 (your config)
> 	- cpumask is allocated on stask
> 	- alloc_cpumask_var() is nop (yes, nop is constant overhead ;)
> 	- alloc_cpumask_var() always return 1, then membarrier_retry() is never called.
> 	- alloc_cpumask_var() ignore GFP_KERNEL parameter
> 
> CONFIG_CPUMASK_OFFSTACK=1 and use GFP_KERNEL
> 	- cpumask is allocated on heap
> 	- alloc_cpumask_var() is the wrapper of kmalloc()
> 	- GFP_KERNEL parameter is passed kmalloc
> 	- GFP_KERNEL mean alloc_cpumask_var() always return 1, except
> 	  oom-killer case. IOW, membarrier_retry() is still never called
> 	  on typical use case.
> 	- kmalloc(GFP_KERNEL) might invoke page reclaim and it can spent few
> 	  seconds (not microseconds).
> 
> CONFIG_CPUMASK_OFFSTACK=1 and use GFP_ATOMIC
> 	- cpumask is allocated on heap
> 	- alloc_cpumask_var() is the wrapper of kmalloc()
> 	- GFP_ATOMIC mean kmalloc never invoke page reclaim. IOW, 
> 	  kmalloc() cost is nearly constant. (few or lots microseconds)
> 	- OTOH, alloc_cpumask_var() might fail, at that time membarrier_retry()
> 	  is called.
> 
> So, My last mail talked about CONFIG_CPUMASK_OFFSTACK=1, but you mesured CONFIG_CPUMASK_OFFSTACK=0.
> That's the reason why our conclusion is different.

I would have to put my system in OOM condition anyway to measure the
page reclaim overhead. Given that sys_membarrier is not exactly a fast
path, I don't think it matters _that much_.

Hrm. Well, given the "expedited" nature of the system call, it might
come as a surprise to have to wait for page reclaim, and surprises are
not good. OTOH, I don't want to allow users to easily consume all the
GFP_ATOMIC pool. But I think it's unlikely, as we are bounded by the
number of processors which can concurrently run sys_membarrier().

> 
> > 
> > Also... it's pretty much a slow path anyway compared to the RCU
> > read-side. I just don't want this slow path to scale badly.
> > 
> > > 
> > > hmm...
> > > Do you intend to GFP_ATOMIC?
> > 
> > Would it help to lower the allocation overhead ?
> 
> No. If the system have lots free memory, GFP_ATOMIC and GFP_KERNEL
> don't have any difference. but if the system have no free memory,
> GFP_KERNEL might cause big latency.

Having a somewhat bounded latency is good for a synchronization
primitive, even for the slow path.

> 
> 
> Perhaps, It is no big issue. If the system have no free memory, another
> syscall will invoke page reclaim soon although sys_membarrier avoid it.
> I'm not sure. It depend on librcu latency policy.

I'd like to stay on the safe side. If you tell me that there is no risk
to let users exhaust GFP_ATOMIC pools prematurely, then I'll use it.

> 
> Another alternative plan is,
> 
> 	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
> 		err = -ENOMEM;
> 		goto unlock;
> 	}
> 
> and kill membarrier_retry(). because CONFIG_CPUMASK_OFFSTACK=1 is
> only used for SGI big hpc machine, it mean nobody can test membarrier_retry().
> Never called function doesn't have lots worth.
> 
> Thought?

I don't want to rely on a system call which can fail at arbitrary points
in the program to create a synchronization primitive. Currently (with
the forthcoming v6 patch), I can test if the system call exists and if
the flags are supported at library init time (by checking -ENOSYS and
-EINVAL return values). From that point on, I don't want to check error
values anymore. This means that a system call that fails on a given
kernel will _always_ fail. The same is true for the opposite. This is
why not returning -ENOMEM is important here.

So I rather prefer to have one single simple failure handler in the
kernel, even if it is not often used, than to have multiple subtly
different error-handling of -ENOMEM at the user-space caller sites,
resulting in an expectable mess. These error handlers won't be tested
any more than the one located in the kernel.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
