Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZBWJIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZBWJIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZBWJHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:07:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44210 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZBWJHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:07:50 -0500
Date: Mon, 23 Feb 2009 10:07:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223090735.GH9582@elte.hu>
References: <19f34abd0902200651k7e86aebay5398ef5ac0578561@mail.gmail.com> <20090220154619.GC6960@linux.vnet.ibm.com> <19f34abd0902201551o65a3650egf29d81e8b6823d67@mail.gmail.com> <20090221014056.GU6960@linux.vnet.ibm.com> <19f34abd0902210130p62fba6d0n906b321949409578@mail.gmail.com> <20090221174703.GA6860@linux.vnet.ibm.com> <19f34abd0902211008k39afd449k604aaf34f693c9a6@mail.gmail.com> <19f34abd0902211037w2293af16t561444d11cc834b8@mail.gmail.com> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223051709.GA5990@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Sat, Feb 21, 2009 at 07:00:30PM -0800, Paul E. McKenney wrote:
> > On Sat, Feb 21, 2009 at 07:37:20PM +0100, Vegard Nossum wrote:
> > > 2009/2/21 Vegard Nossum <vegard.nossum@gmail.com>:
> 
> [ . . . ]
> 
> > > Okay, I don't really think it's an error. The if (user) test happens
> > > at the very beginning and gcc decides to reuse %edx. GDB doesn't know
> > > this, so it thinks the parameter changed, but at this point the
> > > parameter simply won't be used anymore.
> > > 
> > > So you're right: The value can't be trusted (after entry, anyway).
> > 
> > OK.  So at least the compiler is sane.  ;-)
> > 
> > And the fact that RCU Classic behaves the same as hierarchical RCU
> > pretty clearly points at some issue with the quiescent-state check code:
> > 
> > void rcu_check_callbacks(int cpu, int user)
> > {
> > 	if (user ||
> > 	    (idle_cpu(cpu) && !in_softirq() &&
> > 				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> > 		rcu_qsctr_inc(cpu);
> > 		rcu_bh_qsctr_inc(cpu);
> > 	} else if (!in_softirq()) {
> > 		rcu_bh_qsctr_inc(cpu);
> > 	}
> > 	raise_softirq(RCU_SOFTIRQ);
> > }
> > 
> > In the case you traced earlier, we interrupted out of kernel code, yet
> > somehow arrived at rcu_qsctr_inc().  We know that "user" really was 0,
> > thanks to your careful analysis, so the issue must be in the other
> > clause.  Since we interrupted out of mainline kernel code, in_softirq()
> > should have returned 0, and hardirq_count() should also have met the
> > above condition.
> > 
> > You mentioned some concern about idle_cpu() separately, and if idle_cpu()
> > was returning 1, then RCU would most certainly decide that it was in a
> > quiescent state and that it could end the current grace period.
> 
> Hello, Vegard,
> 
> Could you please try out the following patch?  I am not 100% 
> confident of it on non-x86 architectures, nor during the time 
> that non-boot CPUs start up (though this patch should not 
> break non-boot CPUs any more than they might already be 
> broken).
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> The boot CPU runs in the context of its idle thread during 
> boot-up. During this time, idle_cpu(0) will always return 
> nonzero, which will fool Classic and Hierarchical RCU into 
> deciding that a large chunk of the boot-up sequence is a big 
> long quiescent state.  This in turn causes RCU to prematurely 
> end grace periods during this time.

ah, that makes a lot of sense and explains it all! What a nasty 
little bug we had all along ...

> This patch creates a new global variable that is set to 1 just 
> before the boot CPU first enters the scheduler, after which 
> the idle task really is idle.
> 
> Located-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Please also add kmemcheck to the changelog while at it ;-)

> ---
> 
>  init/main.c         |    3 +++
>  kernel/rcuclassic.c |    4 +++-
>  kernel/rcutree.c    |    4 +++-
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index 8442094..51f4b71 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -121,6 +121,8 @@ static char *static_command_line;
>  static char *execute_command;
>  static char *ramdisk_execute_command;
>  
> +int idle_task_is_really_idle;	/* set to 1 late in boot. */
> +
>  #ifdef CONFIG_SMP
>  /* Setup configured maximum number of CPUs to activate */
>  unsigned int __initdata setup_max_cpus = NR_CPUS;
> @@ -463,6 +465,7 @@ static noinline void __init_refok rest_init(void)
>  	 * at least once to get things moving:
>  	 */
>  	init_idle_bootup_task(current);
> +	idle_task_is_really_idle = 1;
>  	preempt_enable_no_resched();
>  	schedule();
>  	preempt_disable();

Could you please use system_state instead? We could insert a new 
stage - or just use SYSTEM_RUNNING as the trigger.

	Ingo
