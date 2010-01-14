Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441Ab0ANCZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0ANCZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652Ab0ANCZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:25:42 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43369 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab0ANCZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:25:41 -0500
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
In-Reply-To: <20100114021645.GA28784@Krystal>
References: <20100114085019.D716.A69D9226@jp.fujitsu.com> <20100114021645.GA28784@Krystal>
Message-Id: <20100114112027.D726.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 11:25:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > > * KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> [...]
> > > > It depend on what mean "constant overhead". kmalloc might cause
> > > > page reclaim and undeterministic delay. I'm not sure (1) How much
> > > > membarrier_retry() slower than smp_call_function_many and (2) Which do
> > > > you think important average or worst performance. Only I note I don't
> > > > think GFP_KERNEL is constant overhead.
> > > 
> > > 10,000,000 sys_membarrier calls (varying the number of threads to which
> > > we send IPIs), IPI-to-many, 8-core system:
> > > 
> > > T=1: 0m20.173s
> > > T=2: 0m20.506s
> > > T=3: 0m22.632s
> > > T=4: 0m24.759s
> > > T=5: 0m26.633s
> > > T=6: 0m29.654s
> > > T=7: 0m30.669s
> > > 
> > > Just doing local mb()+single IPI to T other threads:
> > > 
> > > T=1: 0m18.801s
> > > T=2: 0m29.086s
> > > T=3: 0m46.841s
> > > T=4: 0m53.758s
> > > T=5: 1m10.856s
> > > T=6: 1m21.142s
> > > T=7: 1m38.362s
> > > 
> > > So sending single IPIs adds about 1.5 microseconds per extra core. With
> > > the IPI-to-many scheme, we add about 0.2 microseconds per extra core. So
> > > we have a factor 10 gain in scalability. The initial cost of the cpumask
> > > allocation (which seems to be allocated on the stack in my config) is
> > > just about 1.4 microseconds. So here, we only have a small gain for the
> > > 1 IPI case, which does not justify the added complexity of dealing with
> > > it differently.
> > 
> > I'd like to discuss to separate CONFIG_CPUMASK_OFFSTACK=1 and CONFIG_CPUMASK_OFFSTACK=0.
> > 
> > CONFIG_CPUMASK_OFFSTACK=0 (your config)
> > 	- cpumask is allocated on stask
> > 	- alloc_cpumask_var() is nop (yes, nop is constant overhead ;)
> > 	- alloc_cpumask_var() always return 1, then membarrier_retry() is never called.
> > 	- alloc_cpumask_var() ignore GFP_KERNEL parameter
> > 
> > CONFIG_CPUMASK_OFFSTACK=1 and use GFP_KERNEL
> > 	- cpumask is allocated on heap
> > 	- alloc_cpumask_var() is the wrapper of kmalloc()
> > 	- GFP_KERNEL parameter is passed kmalloc
> > 	- GFP_KERNEL mean alloc_cpumask_var() always return 1, except
> > 	  oom-killer case. IOW, membarrier_retry() is still never called
> > 	  on typical use case.
> > 	- kmalloc(GFP_KERNEL) might invoke page reclaim and it can spent few
> > 	  seconds (not microseconds).
> > 
> > CONFIG_CPUMASK_OFFSTACK=1 and use GFP_ATOMIC
> > 	- cpumask is allocated on heap
> > 	- alloc_cpumask_var() is the wrapper of kmalloc()
> > 	- GFP_ATOMIC mean kmalloc never invoke page reclaim. IOW, 
> > 	  kmalloc() cost is nearly constant. (few or lots microseconds)
> > 	- OTOH, alloc_cpumask_var() might fail, at that time membarrier_retry()
> > 	  is called.
> > 
> > So, My last mail talked about CONFIG_CPUMASK_OFFSTACK=1, but you mesured CONFIG_CPUMASK_OFFSTACK=0.
> > That's the reason why our conclusion is different.
> 
> I would have to put my system in OOM condition anyway to measure the
> page reclaim overhead. Given that sys_membarrier is not exactly a fast
> path, I don't think it matters _that much_.
> 
> Hrm. Well, given the "expedited" nature of the system call, it might
> come as a surprise to have to wait for page reclaim, and surprises are
> not good. OTOH, I don't want to allow users to easily consume all the
> GFP_ATOMIC pool. But I think it's unlikely, as we are bounded by the
> number of processors which can concurrently run sys_membarrier().

GFP_NOWAIT prevent such consuming GFP_ATOMIC pool. but yes, you already
answered i wanted, "sys_membarrier is not exactly a fast path, I don't
think it matters _that much_.".
okay, i understand librcu latency policy. iow, i agree your patch.

Thanks lots explanation.


