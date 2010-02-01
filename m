Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0BASAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:00:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47045 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab0BASAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:00:07 -0500
X-Authority-Analysis: v=1.0 c=1 a=db5xdBbprZYA:10 a=7U3hwN5JcxgA:10 a=Z4Rwk6OoAAAA:8 a=2CF2Mh1K7W2Eqr-AToIA:9 a=BNi0CBxHH5swKpBsjNYA:7 a=tjb4GmzwwiBMrvggugVSg4rVMaYA:4 a=jbrJJM5MRmoA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <20100201174500.GA13744@Krystal>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca>
	 <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
	 <20100201160929.GA3032@Krystal>
	 <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain>
	 <20100201164856.GA3486@Krystal>
	 <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain>
	 <20100201174500.GA13744@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Feb 2010 13:00:03 -0500
Message-ID: <1265047203.29013.69.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 12:45 -0500, Mathieu Desnoyers wrote:
> * Linus Torvalds (torvalds@linux-foundation.org) wrote:

> It's probably worthwhile to summarize here the mb-related discussions we
> had in the previous RFC rounds.

Actually it is probably worthwhile to include this explanation in the
change log. Can't expect everyone to have read a kernel thread that
contains hundreds of replies.

> 
> Here is the detailed execution scenario showing the race. The race with
> unlock showing that we need to order user-space loads before mm_cpumask
> store. This is showing an execution sequence involving the userspace RCU
> library and the Linux kernel with sys_membarrier(). As we see below, the
> lack of ordering between "cpumask_clear" and user-space execution
> creates a race with the scheduler where sys_membarrier() incorrectly
> considers CPU 1 as not needing a membarrier_ipi.
> 
> 
>         CPU 0                   CPU 1
>         --------------          --------------
>         <user space>            <user space> (already in read-side C.S.)
>                                 obj = rcu_dereference(list->next);
>                                   -> load list->next
>                                 copy = obj->foo;
>                                 rcu_read_unlock();
>                                   -> store to urcu_reader.ctr
>                                 <urcu_reader.ctr store is globally visible>
>         list_del(obj);
>                                 <preempt>
>                                 <kernel space>
> 
>                                 schedule();
>                                 cpumask_clear(mm_cpumask, cpu);
> 
>         sys_membarrier();
>           <kernel space>
>           smp_mb()
>           iterates on mm_cpumask
>           smp_mb()
>         <user space>
>         set global g.p. (urcu_gp_ctr) phase to 1
>         wait for all urcu_reader.ctr in phase 0
>         set global g.p. (urcu_gp_ctr) phase to 0
>         wait for all urcu_reader.ctr in phase 1
>         sys_membarrier();
>           <kernel space>
>           smp_mb()
>           iterates on mm_cpumask
>           smp_mb()
>         <user space>
>         free(obj);
>                                 <list->next load hits memory>
>                                 <obj->foo load hits memory> <- corruption
> 
> 
> There is a similar race scenario (symmetric to the one above) between
> cpumask_set and a following user-space rcu_read_lock(), which I could
> provide upon request.

If it would help others to understand, it would be worthwhile in
explaining that too. So, I'm requesting it ;-)

> 
> This results in the following comments around smp_mb() in
> sys_membarrier:
> 
> First sys_membarrier smp_mb():
> 
>         /*
>          * Memory barrier on the caller thread before sending first
>          * IPI. Orders all memory accesses prior to sys_membarrier() before
>          * mm_cpumask read and membarrier_ipi executions.
>          * Matches memory barriers before and after mm_cpumask updates.
>          */

The above comment does not really explain what it is protecting. It just
states that it serializes memory access. Well, duh, that's what smp_mb()
does ;-)  It's the equivalent to i++; /* increment i */

Basically, the comment should explain "why" the memory barrier is
needed.

> 
> Second sys_membarrier smp_mb():
> 
>         /*
>          * Memory barrier on the caller thread after we finished
>          * waiting for the last IPI. Orders mm_cpumask read and membarrier_ipi
>          * executions before memory accesses following sys_membarrier()
>          * execution.
>          * Matches memory barriers before and after mm_cpumask updates.
>          */

Ditto.

-- Steve


