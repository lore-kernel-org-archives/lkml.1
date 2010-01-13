Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734Ab0AMPD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab0AMPD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709Ab0AMPD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:03:26 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:61182 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755652Ab0AMPD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:03:26 -0500
Date: Wed, 13 Jan 2010 10:03:24 -0500
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
Message-ID: <20100113150324.GE30875@Krystal>
References: <20100113110455.B3D3.A69D9226@jp.fujitsu.com> <20100113035809.GA7260@Krystal> <20100113130716.B3DC.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100113130716.B3DC.A69D9226@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:49:38 up 27 days, 23:08,  4 users,  load average: 0.41, 0.23,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > * KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
[...]
> > > Why do we need both expedited and non-expedited mode? at least, this documentation
> > > is bad. it suggest "you have to use non-expedited mode always!".
> > 
> > Right. Maybe I should rather write:
> > 
> >  + * @expedited: (0) Low overhead, but slow execution (few milliseconds)
> >  + *             (1) Slightly higher overhead, fast execution (few microseconds)
> > 
> > And I could probably go as far as adding a few paragraphs:
> > 
> > Using the non-expedited mode is recommended for applications which can
> > afford leaving the caller thread waiting for a few milliseconds. A good
> > example would be a thread dedicated to execute RCU callbacks, which
> > waits for callbacks to enqueue most of the time anyway.
> > 
> > The expedited mode is recommended whenever the application needs to have
> > control returning to the caller thread as quickly as possible. An
> > example of such application would be one which uses the same thread to
> > perform data structure updates and issue the RCU synchronization.
> > 
> > It is perfectly safe to call both expedited and non-expedited
> > sys_membarriers in a process.
> > 
> > 
> > Does that help ?
> 
> Do librcu need both? I bet average programmer don't understand this
> explanation. please recall, syscall interface are used by non kernel
> developers too. If librcu only use either (0) or (1), I hope remove
> another one.
> 
> But if librcu really need both, the above explanation is enough good.
> I think.

As Paul said, we need both in liburcu. These usage scenarios are
explained in the system call documentation.

> 
> 
> > > > +	 * Memory barrier on the caller thread _before_ sending first
> > > > +	 * IPI. Matches memory barriers around mm_cpumask modification in
> > > > +	 * switch_mm().
> > > > +	 */
> > > > +	smp_mb();
> > > > +	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL)) {
> > > > +		membarrier_retry();
> > > > +		goto unlock;
> > > > +	}
> > > 
> > > if CONFIG_CPUMASK_OFFSTACK=1, alloc_cpumask_var call kmalloc. FWIW,
> > > kmalloc calling seems destory the worth of this patch.
> > 
> > Why ? I'm not sure I understand your point. Even if we call kmalloc to
> > allocate the cpumask, this is a constant overhead. The benefit of
> > smp_call_function_many() over smp_call_function_single() is that it
> > scales better by allowing to broadcast IPIs when the architecture
> > supports it. Or maybe I'm missing something ?
> 
> It depend on what mean "constant overhead". kmalloc might cause
> page reclaim and undeterministic delay. I'm not sure (1) How much
> membarrier_retry() slower than smp_call_function_many and (2) Which do
> you think important average or worst performance. Only I note I don't
> think GFP_KERNEL is constant overhead.

10,000,000 sys_membarrier calls (varying the number of threads to which
we send IPIs), IPI-to-many, 8-core system:

T=1: 0m20.173s
T=2: 0m20.506s
T=3: 0m22.632s
T=4: 0m24.759s
T=5: 0m26.633s
T=6: 0m29.654s
T=7: 0m30.669s

Just doing local mb()+single IPI to T other threads:

T=1: 0m18.801s
T=2: 0m29.086s
T=3: 0m46.841s
T=4: 0m53.758s
T=5: 1m10.856s
T=6: 1m21.142s
T=7: 1m38.362s

So sending single IPIs adds about 1.5 microseconds per extra core. With
the IPI-to-many scheme, we add about 0.2 microseconds per extra core. So
we have a factor 10 gain in scalability. The initial cost of the cpumask
allocation (which seems to be allocated on the stack in my config) is
just about 1.4 microseconds. So here, we only have a small gain for the
1 IPI case, which does not justify the added complexity of dealing with
it differently.

Also... it's pretty much a slow path anyway compared to the RCU
read-side. I just don't want this slow path to scale badly.

> 
> hmm...
> Do you intend to GFP_ATOMIC?

Would it help to lower the allocation overhead ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
