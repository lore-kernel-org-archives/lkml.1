Return-Path: <linux-kernel-owner+w=401wt.eu-S1763650AbXHQAXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763650AbXHQAXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 20:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbXHQAXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 20:23:33 -0400
Received: from ozlabs.org ([203.10.76.45]:59158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124AbXHQAXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 20:23:32 -0400
From: Michael Neuling <mikey@neuling.org>
To: balbir@linux.vnet.ibm.com
cc: Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] Add scaled time to taskstats based process accounting 
In-reply-to: <46C3FC41.4000609@linux.vnet.ibm.com> 
References: <20070816070922.37B5370074@localhost.localdomain> <46C3FC41.4000609@linux.vnet.ibm.com>
Comments: In-reply-to Balbir Singh <balbir@linux.vnet.ibm.com>
   message dated "Thu, 16 Aug 2007 12:56:57 +0530."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Fri, 17 Aug 2007 10:23:28 +1000
Message-ID: <13529.1187310208@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



In message <46C3FC41.4000609@linux.vnet.ibm.com> you wrote:
> Hi, Michael,
> 
> Thanks for doing this, this is really useful.
> 
> Michael Neuling wrote:
> > This adds two items to the taststats struct to account for user and
> > system time based on scaling the CPU frequency and instruction issue
> > rates.
> > 
> > Adds account_(user|system)_time_scaled callbacks which architectures
> > can use to account for time using this mechanism.
> > 
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > 
> > ---
> > 
> >  include/linux/kernel_stat.h |    2 ++
> >  include/linux/sched.h       |    2 +-
> >  include/linux/taskstats.h   |    6 +++++-
> >  kernel/fork.c               |    2 ++
> >  kernel/sched.c              |   21 +++++++++++++++++++++
> >  kernel/timer.c              |    7 +++++--
> >  kernel/tsacct.c             |    4 ++++
> >  7 files changed, 40 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6-ozlabs/include/linux/kernel_stat.h
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/include/linux/kernel_stat.h
> > +++ linux-2.6-ozlabs/include/linux/kernel_stat.h
> > @@ -52,7 +52,9 @@ static inline int kstat_irqs(int irq)
> >  }
> > 
> >  extern void account_user_time(struct task_struct *, cputime_t);
> > +extern void account_user_time_scaled(struct task_struct *, cputime_t);
> >  extern void account_system_time(struct task_struct *, int, cputime_t);
> > +extern void account_system_time_scaled(struct task_struct *, cputime_t);
> >  extern void account_steal_time(struct task_struct *, cputime_t);
> > 
> >  #endif /* _LINUX_KERNEL_STAT_H */
> > Index: linux-2.6-ozlabs/include/linux/sched.h
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/include/linux/sched.h
> > +++ linux-2.6-ozlabs/include/linux/sched.h
> > @@ -1020,7 +1020,7 @@ struct task_struct {
> >  	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
> > 
> >  	unsigned int rt_priority;
> > -	cputime_t utime, stime;
> > +	cputime_t utime, stime, utimescaled, stimescaled;
> >  	unsigned long nvcsw, nivcsw; /* context switch counts */
> >  	struct timespec start_time; 		/* monotonic time */
> >  	struct timespec real_start_time;	/* boot based time */
> > Index: linux-2.6-ozlabs/include/linux/taskstats.h
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/include/linux/taskstats.h
> > +++ linux-2.6-ozlabs/include/linux/taskstats.h
> > @@ -31,7 +31,7 @@
> >   */
> > 
> > 
> > -#define TASKSTATS_VERSION	5
> > +#define TASKSTATS_VERSION	6
> >  #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
> >  					 * in linux/sched.h */
> > 
> > @@ -142,6 +142,10 @@ struct taskstats {
> >  	__u64	write_char;		/* bytes written */
> >  	__u64	read_syscalls;		/* read syscalls */
> >  	__u64	write_syscalls;		/* write syscalls */
> > +
> > +	/* time accounting for SMT machines */
> > +	__u64	ac_utimescaled;		/* utime scaled on frequency etc */
> > +	__u64	ac_stimescaled;		/* stime scaled on frequency etc */
> >  	/* Extended accounting fields end */
> > 
> 
> I'd also request for you to add a cpu_scaled_run_real_total for use
> by delay accounting. cpu_scaled_run_real_total should be similar in
> functionality to cpu_run_real_total.

Will do.  Should I add cpu_scaled_run_real_total to the end of the
struct taskstat, or next to cpu_run_real_total?

> 
> >  #define TASKSTATS_HAS_IO_ACCOUNTING
> > Index: linux-2.6-ozlabs/kernel/fork.c
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/kernel/fork.c
> > +++ linux-2.6-ozlabs/kernel/fork.c
> > @@ -1045,6 +1045,8 @@ static struct task_struct *copy_process(
> > 
> >  	p->utime = cputime_zero;
> >  	p->stime = cputime_zero;
> > +	p->utimescaled = cputime_zero;
> > +	p->stimescaled = cputime_zero;
> > 
> >  #ifdef CONFIG_TASK_XACCT
> >  	p->rchar = 0;		/* I/O counter: bytes read */
> > Index: linux-2.6-ozlabs/kernel/sched.c
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/kernel/sched.c
> > +++ linux-2.6-ozlabs/kernel/sched.c
> > @@ -3249,6 +3249,16 @@ void account_user_time(struct task_struc
> >  }
> > 
> >  /*
> > + * Account scaled user cpu time to a process.
> > + * @p: the process that the cpu time gets accounted to
> > + * @cputime: the cpu time spent in user space since the last update
> > + */
> > +void account_user_time_scaled(struct task_struct *p, cputime_t cputime)
> > +{
> > +	p->utimescaled = cputime_add(p->utimescaled, cputime);
> > +}
> > +
> > +/*
> >   * Account system cpu time to a process.
> >   * @p: the process that the cpu time gets accounted to
> >   * @hardirq_offset: the offset to subtract from hardirq_count()
> > @@ -3280,6 +3290,17 @@ void account_system_time(struct task_str
> >  }
> > 
> >  /*
> > + * Account scaled system cpu time to a process.
> > + * @p: the process that the cpu time gets accounted to
> > + * @hardirq_offset: the offset to subtract from hardirq_count()
> > + * @cputime: the cpu time spent in kernel space since the last update
> > + */
> > +void account_system_time_scaled(struct task_struct *p, cputime_t cputime)
> > +{
> > +	p->stimescaled = cputime_add(p->stimescaled, cputime);
> > +}
> > +
> > +/*
> >   * Account for involuntary wait time.
> >   * @p: the process from which the cpu time has been stolen
> >   * @steal: the cpu time spent in involuntary wait
> > Index: linux-2.6-ozlabs/kernel/timer.c
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/kernel/timer.c
> > +++ linux-2.6-ozlabs/kernel/timer.c
> > @@ -826,10 +826,13 @@ void update_process_times(int user_tick)
> >  	int cpu = smp_processor_id();
> > 
> >  	/* Note: this timer irq context must be accounted for as well. */
> > -	if (user_tick)
> > +	if (user_tick) {
> >  		account_user_time(p, jiffies_to_cputime(1));
> > -	else
> > +		account_user_time_scaled(p, jiffies_to_cputime(1));
> > +	} else {
> >  		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
> > +		account_system_time_scaled(p, jiffies_to_cputime(1));
> > +	}
> 
> I am a little confused here, scaled accounting and regular accounting
> go hand in hand?

We need to account for scaled and normal time in this generic code.
All other calls to account_(user|system)_time are in arch code.  

> 
> >  	run_local_timers();
> >  	if (rcu_pending(cpu))
> >  		rcu_check_callbacks(cpu, user_tick);
> > Index: linux-2.6-ozlabs/kernel/tsacct.c
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/kernel/tsacct.c
> > +++ linux-2.6-ozlabs/kernel/tsacct.c
> > @@ -62,6 +62,10 @@ void bacct_add_tsk(struct taskstats *sta
> >  	rcu_read_unlock();
> >  	stats->ac_utime	 = cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
> >  	stats->ac_stime	 = cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
> > +	stats->ac_utimescaled =
> > +		cputime_to_msecs(tsk->utimescaled) * USEC_PER_MSEC;
> > +	stats->ac_stimescaled =
> > +		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
> >  	stats->ac_minflt = tsk->min_flt;
> >  	stats->ac_majflt = tsk->maj_flt;
> > 
> 
> 
> -- 
> 	Warm Regards,
> 	Balbir Singh
> 	Linux Technology Center
> 	IBM, ISTL
> 
