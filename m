Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbYBIWCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbYBIWCm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 17:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbYBIWCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 17:02:31 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:50947 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbYBIWCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 17:02:30 -0500
Date: Sat, 9 Feb 2008 14:02:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: preempt rcu bug on s390
Message-ID: <20080209220226.GB16205@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080209113435.GA6915@osiris.boeblingen.de.ibm.com> <20080209140711.GA16205@linux.vnet.ibm.com> <20080209171451.GB8069@osiris.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209171451.GB8069@osiris.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 06:14:51PM +0100, Heiko Carstens wrote:
> On Sat, Feb 09, 2008 at 06:07:11AM -0800, Paul E. McKenney wrote:
> > On Sat, Feb 09, 2008 at 12:34:35PM +0100, Heiko Carstens wrote:
> > > Using CONFIG_PREEMPT_RCU and CONFIG_NO_IDLE_HZ on s390 my system always
> > > gets stuck when running with more than one cpu.
> > > When booting with four cpus I get all four cpus caught withing cpu_idle
> > > and not advancing anymore. However there is the init process which is
> > > waitung for synchronize_rcu() to complete (lcrash output):
> > > 
> > > STACK TRACE FOR TASK: 0xf84d968 (swapper)
> > > 
> > >  STACK:
> > >  0 schedule+842 [0x36c956]
> > >  1 schedule_timeout+172 [0x36d0e4]
> > >  2 wait_for_common+204 [0x36c398]
> > >  3 synchronize_rcu+76 [0x567bc]
> > >  4 netlink_change_ngroups+150 [0x2b4302]
> > >  5 genl_register_mc_group+256 [0x2b6174]
> > >  6 genl_init+188 [0x534e44]
> > >  7 kernel_init+444 [0x518334]
> > >  8 kernel_thread_starter+6 [0x192a6]
> > > 
> > > If I change the code so that timer ticks won't be disabled everything
> > > runs fine. So my guess is that rcu_needs_cpu() doesn't do the right
> > > thing for the rcu preemptible case.
> > > 
> > > Kernel version is git head of today.
> > > 
> > > Any ideas?
> > 
> > Does this tree have http://lkml.org/lkml/2008/1/29/208 applied?
> > 
> > If not, could you please check it out?
> 
> It's not applied, however it doesn't change anything. Also the patch
> is tied to the dynticks implementation which is differently from
> s390's nohz implementation.
> I had to add the patch below so it would make at least some sense.
> But it doesn't fix the problem.

OK, I was afraid of that.  ;-)

Does s390 start out in nohz mode?  The reason I ask is that it feels like
an off-by-one error for the dynticks_progress_counter.

							Thanx, Paul

> ---
>  arch/s390/kernel/time.c |    2 ++
>  include/linux/hardirq.h |    2 +-
>  kernel/rcupreempt.c     |    2 +-
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/kernel/rcupreempt.c
> ===================================================================
> --- linux-2.6.orig/kernel/rcupreempt.c
> +++ linux-2.6/kernel/rcupreempt.c
> @@ -413,7 +413,7 @@ static void __rcu_advance_callbacks(stru
>  	}
>  }
> 
> -#ifdef CONFIG_NO_HZ
> +#if defined(CONFIG_NO_HZ) || defined(CONFIG_NO_IDLE_HZ)
> 
>  DEFINE_PER_CPU(long, dynticks_progress_counter) = 1;
>  static DEFINE_PER_CPU(long, rcu_dyntick_snapshot);
> Index: linux-2.6/arch/s390/kernel/time.c
> ===================================================================
> --- linux-2.6.orig/arch/s390/kernel/time.c
> +++ linux-2.6/arch/s390/kernel/time.c
> @@ -200,6 +200,7 @@ static void stop_hz_timer(void)
>  		if (timer >= jiffies_timer_cc)
>  			todval = timer;
>  	}
> +	rcu_enter_nohz();
>  	set_clock_comparator(todval);
>  }
> 
> @@ -213,6 +214,7 @@ static void start_hz_timer(void)
> 
>  	if (!cpu_isset(smp_processor_id(), nohz_cpu_mask))
>  		return;
> +	rcu_exit_nohz();
>  	account_ticks(get_clock());
>  	set_clock_comparator(S390_lowcore.jiffy_timer + CPU_DEVIATION);
>  	cpu_clear(smp_processor_id(), nohz_cpu_mask);
> Index: linux-2.6/include/linux/hardirq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/hardirq.h
> +++ linux-2.6/include/linux/hardirq.h
> @@ -109,7 +109,7 @@ static inline void account_system_vtime(
>  }
>  #endif
> 
> -#if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
> +#if defined(CONFIG_PREEMPT_RCU) && (defined(CONFIG_NO_HZ) || defined(CONFIG_NO_IDLE_HZ))
>  extern void rcu_irq_enter(void);
>  extern void rcu_irq_exit(void);
>  #else
