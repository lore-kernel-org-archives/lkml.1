Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0BAUoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 15:44:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089Ab0BAUof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 15:44:35 -0500
Date: Mon, 1 Feb 2010 12:42:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task switch
 at runqueue lock/unlock
In-Reply-To: <20100201195629.GA27665@Krystal>
Message-ID: <alpine.LFD.2.00.1002011227360.4206@localhost.localdomain>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.446503342@polymtl.ca> <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain> <20100201160929.GA3032@Krystal> <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain> <20100201164856.GA3486@Krystal>
 <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain> <20100201174500.GA13744@Krystal> <alpine.LFD.2.00.1002011028190.4206@localhost.localdomain> <20100201195629.GA27665@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 1 Feb 2010, Mathieu Desnoyers wrote:
> 
> The two event pairs we are looking at are:
> 
> Pair 1)
> 
> * memory accesses (load/stores) performed by user-space thread before
>   context switch.
> * cpumask_clear_cpu(cpu, mm_cpumask(prev));
> 
> Pair 2)
>
> * cpumask_set_cpu(cpu, mm_cpumask(next));
> * memory accessses (load/stores) performed by user-space thread after
>   context switch.

So explain why does that smp_mb() in between the two _help_?

The user of this will do a

	for_each_cpu(mm_cpumask)
		send_IPI(cpu, smp_mb);

but that's not an atomic op _anyway_. So you're reading mm_cpumask 
somewhere earlier, and doing the send_IPI later. So look at the whole 
scenario 2:

	cpumask_set_cpu(cpu, mm_cpumask(next));
	memory accessses performed by user-space

and think about it from the perspective of another CPU. What does an 
smp_mb() in between the two do?

I'll tell you - it does NOTHING. Because it doesn't matter. I see no 
possible way another CPU can care, because let's assume that the other CPU 
is doing that

	for_each_cpu(mm_cpumask)
		send_ipi(smp_mb);

and you have to realize that the other CPU needs to read that mm_cpumask 
early in order to do that.

So you have this situation:

	CPU1			CPU2
	----			----

	cpumask_set_cpu
				read mm_cpumask
	smp_mb
				smp_mb
	user memory accessses
				send_ipi

and exactly _what_ is that "smp_mb" on CPU1 protecting against?

Realize that CPU2 is not ordered (because you wanted to avoid the 
locking), so the "read mm_cpumask" can happen before or after that 
cpumask_set_cpu. And it can happen before or after REGARDLESS of that 
smp_mb. The smp_mb doesn't make any difference to CPU2 that I can see. 

So the question becomes one of "How can CPU2 care about whether CPU1 is in 
the mask"? Considering that CPU2 doesn't do any locking, I don't see any 
way you can get a "consistent" CPU mask _regardless_ of any smp_mb's in 
there. When it does the "read mm_cpumask()" it might get the value 
_before_ the cpumask_set_cpu, and it might get the value _after_, and 
that's true regardless of whether there is a smp_mb there or not. 

See what I'm asking for? I'm asking for why it matters that we have a 
memory barrier, and why that mm_cpumask is so magical that _that_ access 
matters so much. 

Maybe I'm dense. But If somebody puts memory barriers in the code, I want 
to know exactly what the reason for the barrier is. Memory ordering is too 
subtle and non-intuitive to go by gut feel.

				Linus
