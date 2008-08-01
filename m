Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbYHAVMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbYHAVMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbYHAVJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:09:44 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57570 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760796AbYHAVJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:09:40 -0400
Date: Fri, 1 Aug 2008 14:09:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
Message-ID: <20080801210934.GG14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik> <200807101725.36175.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807101725.36175.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 05:25:35PM +1000, Nick Piggin wrote:
> On Wednesday 09 July 2008 07:37, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10629
> > Subject		: 2.6.26-rc1-$sha1: RIP __d_lookup+0x8c/0x160
> > Submitter	: Alexey Dobriyan <adobriyan@gmail.com>
> > Date		: 2008-05-05 09:59 (65 days old)
> > References	: http://lkml.org/lkml/2008/5/5/28
> > Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Attached is my fix for this problem. I don't think it is a regression
> as such, but it can't hurt to go into 2.6.26 IMO.
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

I officially feel extremely stupid.  Thank you -very- much for tracking
this down, Nick!!!  And especially for the fix!

I will give this a good testing.  In the meantime:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

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

