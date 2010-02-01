Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0BAQYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:24:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39881 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab0BAQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:24:40 -0500
X-Authority-Analysis: v=1.0 c=1 a=db5xdBbprZYA:10 a=7U3hwN5JcxgA:10 a=WKWFHe5zPDEcxP_-X7wA:9 a=Hz80dqORFa0MsHNzk7UA:7 a=Ft4kAaCSEuGr8dk7M-6zq1xB2fYA:4
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
In-Reply-To: <20100201160929.GA3032@Krystal>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca>
	 <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
	 <20100201160929.GA3032@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Feb 2010 11:24:37 -0500
Message-ID: <1265041477.29013.54.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 11:09 -0500, Mathieu Desnoyers wrote:

> We can deal with the rq->cur update by holding the rq lock in each
> iteration of the for_each_cpu(cpu, mm_cpumask(current->mm)) loop. This
> ensures that if rq->cur is updated, we have an associated memory barrier
> issued (e.g. on x86, implied by writing to cr3 while the rq lock is held).
> 
> However, this does not deal with mm_cpumask update, and we cannot use
> the per-cpu rq lock, as it's a process-wide data structure updated with
> clear_bit/set_bit in switch_mm(). So at the very least, we would have to
> add memory barriers in switch_mm() on some architectures to deal with
> this.
> 


Doesn't set_bit imply a wmb()? If so couldn't we do:

What about:

again:
  tmp_mask = mm_cpumask(current->mm);
  smp_mb();
   rcu_read_lock(); /* ensures validity of cpu_curr(cpu) tasks */
   for_each_cpu(cpu, tmp_mask) {
     spin_lock_irq(&cpu_rq(cpu)->lock);
     ret = current->mm == cpu_curr(cpu)->mm;
     spin_unlock_irq(&cpu_rq(cpu)->lock);
     if (ret)
       smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
   }
   rcu_read_unlock();
   smp_mb();
   if (tmp_mask != mm_cpumask(current->mm)) {
      /* do check for signals here */
      goto again;
   }

Would the above work?

-- Steve


