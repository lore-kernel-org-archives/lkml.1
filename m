Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbYE2SWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbYE2SWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbYE2SWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:22:23 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:52458 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806AbYE2SWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:22:21 -0400
Date: Thu, 29 May 2008 23:53:39 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Michael Neuling <mikey@neuling.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 2/3] Make calls to account_scaled_stats
Message-ID: <20080529182339.GS5181@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Michael Neuling <mikey@neuling.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526143146.24680.36724.stgit@drishya.in.ibm.com> <19576.1212074336@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <19576.1212074336@neuling.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Neuling <mikey@neuling.org> [2008-05-29 10:18:56]:

> In message <20080526143146.24680.36724.stgit@drishya.in.ibm.com> you wrote:
> > Hook various accounting functions to call scaled stats
> > 
> > * Hook porcess contect switch: __switch_to()
> > * Hook IRQ handling account_system_vtime() in hardirq.hA
> > * Update __delayacct_add_tsk() to take care of scaling by 1000
> > * Update bacct_add_tsk() to take care of scaling by 1000
> > 
> > Signed-off-by: Amit K. Arora <aarora@linux.vnet.ibm.com>
> > Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > ---
> > 
> >  arch/x86/kernel/process_32.c |    8 ++++++++
> >  include/linux/hardirq.h      |    4 ++++
> >  kernel/delayacct.c           |    7 ++++++-
> >  kernel/timer.c               |    2 --
> >  kernel/tsacct.c              |   10 ++++++++--
> >  5 files changed, 26 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> > index f8476df..c81a783 100644
> > --- a/arch/x86/kernel/process_32.c
> > +++ b/arch/x86/kernel/process_32.c
> > @@ -56,6 +56,9 @@
> >  #include <asm/cpu.h>
> >  #include <asm/kdebug.h>
> >  
> > +extern void account_scaled_stats(struct task_struct *tsk);
> > +extern void reset_for_scaled_stats(struct task_struct *tsk);
> > +
> >  asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
> >  
> >  static int hlt_counter;
> > @@ -660,6 +663,11 @@ struct task_struct * __switch_to(struct task_struct *pre
> v_p, struct task_struct
> >  		loadsegment(gs, next->gs);
> >  
> >  	x86_write_percpu(current_task, next_p);
> > +	/* Account scaled statistics for the task leaving CPU */
> > +	account_scaled_stats(prev_p);
> > +	barrier();
> > +	/* Initialise stats counter for new task */
> > +	reset_for_scaled_stats(next_p);
> >  
> >  	return prev_p;
> >  }
> > diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> > index 181006c..4458736 100644
> > --- a/include/linux/hardirq.h
> > +++ b/include/linux/hardirq.h
> > @@ -7,6 +7,9 @@
> >  #include <asm/hardirq.h>
> >  #include <asm/system.h>
> >  
> > +/* TBD: Add config option */
> > +extern void account_scaled_stats(struct task_struct *tsk);
> > +
> >  /*
> >   * We put the hardirq and softirq counter into the preemption
> >   * counter. The bitmask has the following meaning:
> > @@ -115,6 +118,7 @@ struct task_struct;
> >  #ifndef CONFIG_VIRT_CPU_ACCOUNTING
> >  static inline void account_system_vtime(struct task_struct *tsk)
> >  {
> > +	account_scaled_stats(tsk);
> >  }
> >  #endif
> >  
> > diff --git a/kernel/delayacct.c b/kernel/delayacct.c
> > index 10e43fd..3e2938f 100644
> > --- a/kernel/delayacct.c
> > +++ b/kernel/delayacct.c
> > @@ -117,7 +117,12 @@ int __delayacct_add_tsk(struct taskstats *d, struct task
> _struct *tsk)
> >  
> >  	tmp = (s64)d->cpu_scaled_run_real_total;
> >  	cputime_to_timespec(tsk->utimescaled + tsk->stimescaled, &ts);
> > -	tmp += timespec_to_ns(&ts);
> > +	/* HACK: Remember, we multipled the cputime_t by 1000 to include
> > +	 * fraction.  Now it is time to scale it back to correct 'ns' value.
> > +	 * Perhaps, we should use nano second unit (u64 type) for utimescaled 
> > +	 * and stimescaled?
> > +	 */
> > +	tmp += div_s64(timespec_to_ns(&ts),1000);
> 
> This is going to break other archs (specifically powerpc) which doesn't
> do this magical scale by 1000.
> 
> How often is this function called as the divide is going to slow things
> down? 

Hi Mikey,

Thanks for the review comments.  This scaling is a hack to store
fractions in cputime_t data type as mentioned in the intro and other
replies.  This should certainly go away once I find a clean method to
store fractional jiffies values for x86.  

> 
> >  	d->cpu_scaled_run_real_total =
> >  		(tmp < (s64)d->cpu_scaled_run_real_total) ? 0 : tmp;
> >  
> > diff --git a/kernel/timer.c b/kernel/timer.c
> > index ceacc66..de8a615 100644
> > --- a/kernel/timer.c
> > +++ b/kernel/timer.c
> > @@ -964,10 +964,8 @@ void account_process_tick(struct task_struct *p, int use
> r_tick)
> >  
> >  	if (user_tick) {
> >  		account_user_time(p, one_jiffy);
> > -		account_user_time_scaled(p, cputime_to_scaled(one_jiffy));
> >  	} else {
> >  		account_system_time(p, HARDIRQ_OFFSET, one_jiffy);
> > -		account_system_time_scaled(p, cputime_to_scaled(one_jiffy));
> >  	}
> >  }
> 
> Why did you remove this?

In this preliminary RFC implementation to demonstrate the idea, I have
not hooked into these routines since I do not know the scaling factor
at this time.  I am trying to maintain the scaling ratio from cpufreq
driver in the next version and just use it in the accounting
subsystem.  Once I have cpufreq subsystem to maintain the scaling
ratio, I can use these functions.

> >  #endif
> > diff --git a/kernel/tsacct.c b/kernel/tsacct.c
> > index 4ab1b58..ee0d93b 100644
> > --- a/kernel/tsacct.c
> > +++ b/kernel/tsacct.c
> > @@ -62,10 +62,16 @@ void bacct_add_tsk(struct taskstats *stats, struct task_s
> truct *tsk)
> >  	rcu_read_unlock();
> >  	stats->ac_utime	 = cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
> >  	stats->ac_stime	 = cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
> > +	/* HACK: cputime unit is jiffies on x86 and not good for fractional 
> > +	 * additional.  cputime_t type {u,s}timescaled is multiplied by 
> > +	 * 1000 for scaled accounting.  Hence, cputime_to_msecs will actually 
> > +	 * give the required micro second value.  The multiplier 
> > +	 * USEC_PER_MSEC has been dropped.
> > +	 */
> >  	stats->ac_utimescaled =
> > -		cputime_to_msecs(tsk->utimescaled) * USEC_PER_MSEC;
> > +		cputime_to_msecs(tsk->utimescaled);
> >  	stats->ac_stimescaled =
> > -		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
> > +		cputime_to_msecs(tsk->stimescaled);
> 
> Again, isn't this going to effect other archs?  

Yes, this is part of the scaling factor hack.  I will get rid of this
once we can store fractional cputime_t.

--Vaidy

