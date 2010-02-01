Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0BAT4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:56:32 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:51832 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754876Ab0BAT4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:56:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADC8ZktGHnlj/2dsb2JhbACBM9lYhEUE
Date: Mon, 1 Feb 2010 14:56:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
	switch at runqueue lock/unlock
Message-ID: <20100201195629.GA27665@Krystal>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.446503342@polymtl.ca> <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain> <20100201160929.GA3032@Krystal> <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain> <20100201164856.GA3486@Krystal> <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain> <20100201174500.GA13744@Krystal> <alpine.LFD.2.00.1002011028190.4206@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002011028190.4206@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:35:26 up 47 days,  3:53,  5 users,  load average: 0.20, 0.17,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Mon, 1 Feb 2010, Mathieu Desnoyers wrote:
> > 
> > Here is the detailed execution scenario showing the race.
> 
> No. You've added random smp_mb() calls, but you don't actually show what 
> the f*ck they are protecting against.
> 
> For example
> 
> > First sys_membarrier smp_mb():
> 
> I'm not AT ALL interested in the sys_membarrier() parts. You can hav ea 
> million memory barriers there, and I won't care. I'm interested in what 
> you think the memory barriers elsewhere protect against. It's a barrier 
> between _which_ two operations? 
> 
> You can't say it's a barrier "around" the
> 
> 	cpumask_clear(mm_cpumask, cpu);
> 
> because a barrier is between two things. So if you want to add two 
> barriers around that mm_cpumask acces, you need to describe the _three_ 
> events you're barriers between in that call-path (with mm_cpumask being 
> just one of them)
> 
> And then, once you've described _those_ three events, you describe what 
> the sys_membarrier interaction is, and how mm_cpumask is involved there.
> 
> I'm not interested in the user-space code. Don't even quote it. It's 
> irrelevant apart from the actual semantics you want to guarantee for the 
> new membarrier() system call. So don't quote the code, just explain what 
> the actual barriers are.
> 

The two event pairs we are looking at are:

Pair 1)

* memory accesses (load/stores) performed by user-space thread before
  context switch.
* cpumask_clear_cpu(cpu, mm_cpumask(prev));

Pair 2)

* cpumask_set_cpu(cpu, mm_cpumask(next));
* memory accessses (load/stores) performed by user-space thread after
  context switch.

I can see two ways to add memory barriers in switch_mm that would
provide ordering for these two memory access pairs:

Either A)

switch_mm()
  smp_mb__before_clear_bit();
  cpumask_clear_cpu(cpu, mm_cpumask(prev));
  cpumask_set_cpu(cpu, mm_cpumask(next));
  smp_mb__after_set_bit();

or B)

switch_mm()
  cpumask_set_cpu(cpu, mm_cpumask(next));
  smp_mb__before_clear_bit();
  cpumask_clear_cpu(cpu, mm_cpumask(prev));

(B) seems like a clear win, as we get the ordering right for both pairs
with a single memory barrier, but I don't know if changing the set/clear
bit order could have nasty side-effects on other mm_cpumask users.

sys_membarrier uses the mm_cpumask to iterate on all CPUs on which the
current process's mm is in use, so it can issue a smp_mb() through an
IPI on all CPUs that need it. Without appropriate ordering of pairs 1-2
detailed above, we could miss a CPU that actually needs a memory
barrier.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
