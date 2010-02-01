Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0BAQJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:09:34 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:56987 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371Ab0BAQJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:09:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAPiKZktGHnlj/2dsb2JhbACBM9kShEUE
Date: Mon, 1 Feb 2010 11:09:30 -0500
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
Message-ID: <20100201160929.GA3032@Krystal>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.446503342@polymtl.ca> <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:45:17 up 47 days, 3 min,  6 users,  load average: 0.45, 0.22,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Sun, 31 Jan 2010, Mathieu Desnoyers wrote:
> > 
> > Adds no overhead on x86, because LOCK-prefixed atomic operations of the spin
> > lock/unlock already imply a full memory barrier.
> 
> .. and as Nick pointed out, you're fundamentally incorrect on this. 
> unlock on x86 is no memory barrier at all, since the x86 memory ordering 
> rules are such that a regular store always has release consistency.
> 
> But more importantly, you don't even explain why the addded smp_mb() 
> helps.
> 
> Why does a smp_mb() at the lock/unlock even matter? Reading accesses by 
> the same CPU sure as hell do _not_ matter, so the whole concept seems 
> totally broken. There is no way in _hell_ that whatever unlocked thing 
> can ever write the variables protected by the lock, only read them. So a 
> full memory barrier makes zero sense to begin with.
> 
> So what are these magical memory barriers all about?
> 
> 		Linus

To show the ordering required by sys_membarrier, let's first express
sys_membarrier() succinctly:

  smp_mb();
  rcu_read_lock(); /* ensures validity of cpu_curr(cpu) tasks */
  for_each_cpu(cpu, mm_cpumask(current->mm))
    if (current->mm == cpu_curr(cpu)->mm)
      smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
  rcu_read_unlock();
  smp_mb();

We need to guarantee that between the two memory barriers issued by
sys_membarrier(), we run a membarrier_ipi on every other running thread
belonging to the same process.

Where we have to be careful here is that the context switch does not
imply memory barriers both before and after:

- mm_cpumask update
- rq->cur update

Not having memory barriers between user-space instruction execution and
these updates performed by the scheduler leaves room for a race between
sys_membarrier() and the scheduler, where we would not deliver a
membarrier_ipi to a thread which either starts running or is about to be
context switched.

One option is to surround the context switch by memory barriers. If we
choose not to do that, we are left with these solutions:

We can deal with the rq->cur update by holding the rq lock in each
iteration of the for_each_cpu(cpu, mm_cpumask(current->mm)) loop. This
ensures that if rq->cur is updated, we have an associated memory barrier
issued (e.g. on x86, implied by writing to cr3 while the rq lock is held).

However, this does not deal with mm_cpumask update, and we cannot use
the per-cpu rq lock, as it's a process-wide data structure updated with
clear_bit/set_bit in switch_mm(). So at the very least, we would have to
add memory barriers in switch_mm() on some architectures to deal with
this.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
