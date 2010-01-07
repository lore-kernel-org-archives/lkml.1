Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912Ab0AGTks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0AGTks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867Ab0AGTkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:40:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54972 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab0AGTkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:40:46 -0500
X-Authority-Analysis: v=1.0 c=1 a=r_nf4N-T2GkA:10 a=7U3hwN5JcxgA:10 a=WW5xbkGmMtLu6RTCxPgA:9 a=cAxErtegKLI0grpAk5n0otR61P4A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: paulmck@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100107191657.GN6764@linux.vnet.ibm.com>
References: <20100107044007.GA22863@Krystal>
	 <1262852862.4049.78.camel@laptop> <20100107183010.GA14980@redhat.com>
	 <20100107183946.GL6764@linux.vnet.ibm.com>
	 <1262890782.28171.3738.camel@gandalf.stny.rr.com>
	 <20100107191657.GN6764@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 07 Jan 2010 14:40:43 -0500
Message-ID: <1262893243.28171.3753.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 11:16 -0800, Paul E. McKenney wrote:

> > Note, we are not suggesting optimizations. It has nothing to do with
> > performance of the syscall. We just can't allow one process to be DoSing
> > another process on another cpu by it sending out millions of IPIs.
> > Mathieu already showed that you could cause a 2x slowdown to the
> > unrelated tasks.
> 
> I would have said that we are trying to optimize our way out of a DoS
> situation, but point taken.  Whatever we choose to call it, the discussion
> is on the suggested modifications, not strictly on the original patch.  ;-)

OK, I just want to get a better understanding of what can go wrong. A
sys_membarrier() is used as follows, correct? (using a list example)

	<user space>

	list_del(obj);

	synchronize_rcu();  -> calls sys_membarrier();

	free(obj);


And we need to protect against:

	<user space>

	read_rcu_lock();

	obj = list->next;

	use_object(obj);

	read_rcu_unlock();

where we want to make sure that the synchronize_rcu() makes sure that we
have passed the grace period of all takers of read_rcu_lock(). Now I
have not looked at the code that implements userspace rcu, so I'm making
a lot of assumptions here. But the problem that we need to avoid is:


	CPU 1				CPU 2
     -----------                    -------------

	<user space>			<user space>

					rcu_read_lock();

					obj = list->next

	list_del(obj)

					< Interrupt >
					< kernel space>
					<schedule>

					<kernel_thread>

					<schedule>

					< back to original task >

	sys_membarrier();
	< kernel space >

	if (task_rq(task)->curr != task)
	< but still sees kernel thread >

	< user space >

	< misses that we are still in rcu section >

	free(obj);

					< user space >

					use_object(obj); <=== crash!



I guess what I'm trying to do here is to understand what can go wrong,
and then when we understand the issues, we can find a solution.

-- Steve



