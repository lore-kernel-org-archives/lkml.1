Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0BAXJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 18:09:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57815 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0BAXJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 18:09:45 -0500
X-Authority-Analysis: v=1.0 c=1 a=db5xdBbprZYA:10 a=7U3hwN5JcxgA:10 a=jAjEZ0_adaHcdns-HWcA:9 a=CileCrmvy2dl6aTV7rQA:7 a=mAmJlhfuRIQrM92axfGX-D3l7UsA:4
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
In-Reply-To: <1265063973.29013.336.camel@gandalf.stny.rr.com>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca>
	 <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
	 <20100201160929.GA3032@Krystal>
	 <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain>
	 <20100201164856.GA3486@Krystal>
	 <alpine.LFD.2.00.1002010854110.4206@localhost.localdomain>
	 <20100201174500.GA13744@Krystal>
	 <alpine.LFD.2.00.1002011028190.4206@localhost.localdomain>
	 <1265056389.29013.126.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1002011244020.4206@localhost.localdomain>
	 <1265063973.29013.336.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Feb 2010 18:09:43 -0500
Message-ID: <1265065783.29013.368.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 17:39 -0500, Steven Rostedt wrote:

> 
> 	   CPU 0		   CPU 1
> 	-----------		-----------
> 				< same thread >
> 				clear_bit(mm_cpumask)
> 
> 	sys_membarrier();
> 	<miss sending CPU 1 mb()>
> 	return back to user-space
> 
> 	modify data
> 
> 				< CPU 0 data is read > <<- corruption
> 
> 				schedule()
> 
> 

> (posted in a previous email)
> 
> sys_membarrier(void) {
> 
> 	again:
> 		tmp_mask = mm_cpumask(current->mm);
> 		smp_mb();
> 		rcu_read_lock(); /* ensures validity of cpu_curr(cpu) tasks */
> 		for_each_cpu(cpu, tmp_mask) {
> 			spin_lock_irq(&cpu_rq(cpu)->lock);
> 			ret = current->mm == cpu_curr(cpu)->mm;
> 			spin_unlock_irq(&cpu_rq(cpu)->lock);
> 			if (ret)
> 			smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
> 		}
> 		rcu_read_unlock();
> 		smp_mb();
> 		if (tmp_mask != mm_cpumask(current->mm)) {
> 			/* do check for signals here */
> 			goto again;
> 		}

Doh, this misses the above case if a mb() is not before the caller.
Nevermind, it looks like the only other case is to iterate over all
CPUs.

-- Steve


