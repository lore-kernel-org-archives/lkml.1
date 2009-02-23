Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZBWQti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZBWQti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZBWQta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:49:30 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37492 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbZBWQt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:49:29 -0500
Date: Mon, 23 Feb 2009 08:17:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223161726.GD6751@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220140157.GA12799@elte.hu> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com> <200902240029.37815.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902240029.37815.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 12:29:36AM +1100, Nick Piggin wrote:
> On Monday 23 February 2009 16:17:09 Paul E. McKenney wrote:
> 
> > The boot CPU runs in the context of its idle thread during boot-up.
> > During this time, idle_cpu(0) will always return nonzero, which will
> > fool Classic and Hierarchical RCU into deciding that a large chunk of
> > the boot-up sequence is a big long quiescent state.  This in turn causes
> > RCU to prematurely end grace periods during this time.
> >
> > This patch creates a new global variable that is set to 1 just before
> > the boot CPU first enters the scheduler, after which the idle task
> > really is idle.
> 
> Nice work all (btw. if this patch goes in rather than using system_state,
> then please make the variable __read_mostly).

Hmmm...  I misread this and made system_state be __read_mostly.  Let
me know if this is bad, easy to fix if needed.

							Thanx, Paul

> Vegard, I would like to still use your patch in vmalloc.c as well. It
> solves a possible use-after-free with preemptible RCU, and also helps with
> a patch I have to conditionally disable lazy vmap unmapping (for Xen).
> 
> We _could_ disable RCU there instead to solve the preemptible RCU bug, but
> your patch I think is less overhead.
> 
> So with appropriate changelog update, please also resend your patch
> (with Acked-by: Nick Piggin <npiggin@suse.de>)
> 
> Thanks,
> Nick
> 
> > Located-by: Vegard Nossum <vegard.nossum@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >
> >  init/main.c         |    3 +++
> >  kernel/rcuclassic.c |    4 +++-
> >  kernel/rcutree.c    |    4 +++-
> >  3 files changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/init/main.c b/init/main.c
> > index 8442094..51f4b71 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -121,6 +121,8 @@ static char *static_command_line;
> >  static char *execute_command;
> >  static char *ramdisk_execute_command;
> >
> > +int idle_task_is_really_idle;	/* set to 1 late in boot. */
> > +
> >  #ifdef CONFIG_SMP
> >  /* Setup configured maximum number of CPUs to activate */
> >  unsigned int __initdata setup_max_cpus = NR_CPUS;
> > @@ -463,6 +465,7 @@ static noinline void __init_refok rest_init(void)
> >  	 * at least once to get things moving:
> >  	 */
> >  	init_idle_bootup_task(current);
> > +	idle_task_is_really_idle = 1;
> >  	preempt_enable_no_resched();
> >  	schedule();
> >  	preempt_disable();
> > diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> > index bd5a900..a758fa6 100644
> > --- a/kernel/rcuclassic.c
> > +++ b/kernel/rcuclassic.c
> > @@ -678,8 +678,10 @@ int rcu_needs_cpu(int cpu)
> >   */
> >  void rcu_check_callbacks(int cpu, int user)
> >  {
> > +	extern int idle_task_is_really_idle;
> > +
> >  	if (user ||
> > -	    (idle_cpu(cpu) && !in_softirq() &&
> > +	    (idle_cpu(cpu) && idle_task_is_really_idle && !in_softirq() &&
> >  				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> >
> >  		/*
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index b2fd602..e996d85 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -947,8 +947,10 @@ static void rcu_do_batch(struct rcu_data *rdp)
> >   */
> >  void rcu_check_callbacks(int cpu, int user)
> >  {
> > +	extern int idle_task_is_really_idle;
> > +
> >  	if (user ||
> > -	    (idle_cpu(cpu) && !in_softirq() &&
> > +	    (idle_cpu(cpu) && idle_task_is_really_idle && !in_softirq() &&
> >  				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> >
> >  		/*
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
