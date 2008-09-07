Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYIGR0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYIGR0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 13:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYIGR0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 13:26:24 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49019 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbYIGR0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 13:26:23 -0400
Date: Sun, 7 Sep 2008 10:25:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org
Subject: Re: [PATCH, RFC] v4 scalable classic RCU implementation
Message-ID: <20080907172536.GA6941@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <48C2B1D2.5070801@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C2B1D2.5070801@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 06:37:38PM +0200, Manfred Spraul wrote:
> Hi Paul,
>
> Paul E. McKenney wrote:
>> o	The rcu_pending() and rcu_needs_cpu() primitives are now
>> 	much more aggressive about permitting CPUs to enter dynticks
>> 	idle mode.  Only CPUs that have RCU callbacks are kept out
>> 	of dynticks idle mode.
>>   
>
> I've noticed that right now rcu_enter_nohz() can be nested within 
> rcu_irq_enter():
> irq_exit() first calls tick_nohz_stop_sched_tick(), then rcu_irq_exit().
> And tick_nohz_stop_sched_tick() can switch into nohz mode.
>
> Is that intentional? Does rcupreempt support that? It broke my rcustate 
> code on x86-64.
>
> I would prefer if something like the attached patch is applied. What do you 
> think?
> Do you need the patch as well?

Good question -- when I tried splitting irqs from NMIs, things broke
badly, and this might well explain it.  Thank you very much for the
hint!!!

							Thanx, Paul

> --
>    Manfred

> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index ba20a90..cca5a83 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -284,10 +284,10 @@ void irq_exit(void)
>  		invoke_softirq();
> 
>  #ifdef CONFIG_NO_HZ
> +	rcu_irq_exit(0);
>  	/* Make sure that timer wheel updates are propagated */
>  	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
>  		tick_nohz_stop_sched_tick(0);
> -	rcu_irq_exit(0);
>  #endif
>  	preempt_enable_no_resched();
>  }

