Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbYGJJEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbYGJJEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYGJJEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:04:20 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:37171 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751913AbYGJJES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:04:18 -0400
Message-ID: <4875D077.8050109@linux.vnet.ibm.com>
Date: Thu, 10 Jul 2008 14:33:51 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik> <200807101725.36175.nickpiggin@yahoo.com.au>
In-Reply-To: <200807101725.36175.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Wednesday 09 July 2008 07:37, Rafael J. Wysocki wrote:
> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11023
>> Subject		: 2.6.26-rc8-git2 - kernel BUG at mm/page_alloc.c:585
>> Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>> Date		: 2008-07-02 11:55 (7 days old)
>> References	: http://lkml.org/lkml/2008/7/2/32
>> Handled-By	: Andrew Morton <akpm@linux-foundation.org>
> 
> I expect Andrew probably doesn't have time to delve into this. 
> Usual questions apply: is it reproduceable, is it bisectable?
> Someone at IBM is probably best to handle it. Maybe try Mel or
> powerpc list?
> 

This is reproducible, I have marked the powerpc list in the bug report,
send to the list. I will try and bisect the bug. 
> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10906
>> Subject		: repeatable slab corruption with LTP msgctl08
>> Submitter	: Andrew Morton <akpm@linux-foundation.org>
>> Date		: 2008-06-12 5:13 (27 days old)
>> References	: http://marc.info/?l=linux-kernel&m=121324775927704&w=4
>> Handled-By	: Pekka J Enberg <penberg@cs.helsinki.fi>
>> 		  Christoph Lameter <clameter@sgi.com>
>> 		  Manfred Spraul <manfred@colorfullife.com>
>> 		  Andi Kleen <andi@firstfloor.org>
> 
> I couldn't reproduce this one either. Maybe hardware failure?
> 
> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
>> Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
>> Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
>> Date		: 2008-05-05 09:59 (65 days old)
>> References	: http://lkml.org/lkml/2008/5/5/28
>> Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Attached is my fix for this problem. I don't think it is a regression
> as such, but it can't hurt to go into 2.6.26 IMO.
> 
> 
> 
> ------------------------------------------------------------------------
> 
> PREEMPT_RCU without HOTPLUG_CPU is broken. The rcu_online_cpu is called to
> initially populate rcu_cpu_online_map with all online CPUs when the hotplug
> event handler is installed, and also to populate the map with CPUs as they
> come online. The former case is meant to happen with and without HOTPLUG_CPU,
> but without HOTPLUG_CPU, the rcu_offline_cpu function is no-oped -- while it
> still gets called, it does not set the rcu CPU map.
> 
> With a blank RCU CPU map, grace periods get to tick by completely oblivious
> to active RCU read side critical sections. This results in free-before-grace
> bugs.
> 
> Fix is obvious once the problem is known. (Also, change __devinit to
> __cpuinit so the function gets thrown away on !HOTPLUG_CPU kernels).
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
> 
> Annoyed this wasn't a crazy obscure error in the algorithm I could fix :)
> I spent all day debugging it and had to make a special test case (rcutorture
> didn't seem to trigger it), and a big RCU state logging infrastructure to log
> millions of RCU state transitions and events. Oh well.
> 
> Index: linux-2.6/kernel/rcupreempt.c
> ===================================================================
> --- linux-2.6.orig/kernel/rcupreempt.c	2008-07-10 17:08:56.000000000 +1000
> +++ linux-2.6/kernel/rcupreempt.c	2008-07-10 17:09:10.000000000 +1000
> @@ -925,26 +925,22 @@ void rcu_offline_cpu(int cpu)
>  	spin_unlock_irqrestore(&rdp->lock, flags);
>  }
> 
> -void __devinit rcu_online_cpu(int cpu)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
> -	cpu_set(cpu, rcu_cpu_online_map);
> -	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
> -}
> -
>  #else /* #ifdef CONFIG_HOTPLUG_CPU */
> 
>  void rcu_offline_cpu(int cpu)
>  {
>  }
> 
> -void __devinit rcu_online_cpu(int cpu)
> +#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
> +
> +void __cpuinit rcu_online_cpu(int cpu)
>  {
> -}
> +	unsigned long flags;
> 
> -#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
> +	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
> +	cpu_set(cpu, rcu_cpu_online_map);
> +	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
> +}
> 
>  static void rcu_process_callbacks(struct softirq_action *unused)
>  {


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
