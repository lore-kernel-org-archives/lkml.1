Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0BAUdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:33:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42948 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab0BAUdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:33:13 -0500
X-Authority-Analysis: v=1.0 c=1 a=db5xdBbprZYA:10 a=7U3hwN5JcxgA:10 a=RWoal9h3urqkP0ng7psA:9 a=I-pCQrZniYsnKJHkkmEA:7 a=A-qBgstqg48vRofa3jnBsXyiHhEA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <alpine.LFD.2.00.1002011028190.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca>
	 <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
	 <20100201160929.GA3032@Krystal>
	 <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain>
	 <20100201164856.GA3486@Krystal>
	 <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain>
	 <20100201174500.GA13744@Krystal>
	 <alpine.LFD.2.00.1002011028190.4206@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Feb 2010 15:33:09 -0500
Message-ID: <1265056389.29013.126.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 10:36 -0800, Linus Torvalds wrote:
> 

> I'm not interested in the user-space code. Don't even quote it. It's 
> irrelevant apart from the actual semantics you want to guarantee for
> the 
> new membarrier() system call. So don't quote the code, just explain
> what 
> the actual barriers are.


OK, but first we must establish that the sys_membarrier() system call
guarantees that all running threads of this process have an mb()
performed on them before this syscall returns.

The simplest implementation would be to just do an IPI on all CPUs and
have that IPI perform the mb(). But that would interfere with other
tasks, so we want to limit it to only sending the mb()'s to the threads
of the process that are currently running. We use the mm_cpumask to find
out what threads are associated with this task, and only send the IPI to
the CPUs running threads of the current process.

With the kernel point of view, the goal is to make sure a mb() happens
on all running threads of the calling process.

The code does the following:

	for_each_cpu(cpu, mm_cpumask(current->mm)) {
		if (current->mm == cpu_curr(cpu)->mm)
			send_ipi();
	}

But a race exists between the reading of the mm_cpumask and sending the
IPI. There is in fact two different problems with this race. One is that
a thread scheduled away, but never issued an mb(), the other is that a
running task just came in and we never saw it.

Here:

	   CPU 0		   CPU 1
	-----------		-----------
				< same thread >
				schedule()
				clear_bit();

	current->mm == cpu_curr(1)->mm <<< failed
	return sys_membarrier();

				context_switch();


The above fails the situation, because we missed our thread before it
actually switched to another task. This fails the guarantee that the
syscall sys_membarrier() implies.


Second scenario, for non-x86 archs that do not imply a mb() on
switch_mm():

	   CPU 0		   CPU 1
	-----------		-----------
				< different thread >
				schedule();
				clear_bit();
				set_bit();
				schedule();
				< same thread >

	sys_membarrier();
	current->mm == cpu_curr(1)->mm <<<<< failed


This scenario happens if the switch_mm() does not imply a mb(). That is,
the syscall sys_membarrier() was called after CPU 1 scheduled a thread
of the same process, but the switch_mm() did not force the mb() causing
CPU 0 to see the old value of the mm_cpumask.



The above does not take any user-space into account. It only tries to
fulfill the kernel's obligation of sys_membarrier to ensure that all
threads of the calling process has an mb() performed on them.

Mathieu, from this point of view, you can explain the necessary mb()s
that are within the kernel proper.

-- Steve


