Return-Path: <linux-kernel-owner+w=401wt.eu-S1030792AbXD2RrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030792AbXD2RrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030876AbXD2RrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:47:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38160 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030342AbXD2RrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:47:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [PATCH -mm] Allow selective freezing of the system for different events
Date: Sun, 29 Apr 2007 19:51:04 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
References: <200704271737.31192.rjw@sisk.pl> <200704271740.17972.rjw@sisk.pl> <20070428013446.GA20242@in.ibm.com>
In-Reply-To: <20070428013446.GA20242@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704291951.05425.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the delay.

On Saturday, 28 April 2007 03:34, Gautham R Shenoy wrote:
> This patch
> * Provides an interface to selectively freeze the system for different events.
> * Allows tasks to exempt themselves or other tasks from specific freeze
>   events.
> * Allow nesting of freezer calls. For eg:
> 
> 	freeze_processes(EVENT_A);
> 	/* Do something with respect to event A */
> 	.
> 	.
> 	.
> 	freeze_processes(EVENT_B);
> 	/* Do something with respect to event B */
> 	.
> 	.
> 	.
> 	thaw_processes(EVENT_B);
> 	.
> 	.
> 	.
> 	thaw_processes(EVENT_B);
> 
> This type of behaviour would be required when cpu hotplug would start
> using the process freezer, where EVENT_A would be SUSPEND and EVENT_B
> would be HOTPLUG_CPU.
> 
> This patch applies on the top of 2.6.21-rc7-mm2 + Rafael's freezer
> changes from http://lkml.org/lkml/2007/4/27/302.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
>  arch/i386/kernel/apm.c              |    2 -
>  drivers/block/loop.c                |    2 -
>  drivers/char/apm-emulation.c        |    6 +--
>  drivers/ieee1394/ieee1394_core.c    |    2 -
>  drivers/md/md.c                     |    2 -
>  drivers/mmc/card/queue.c            |    2 -
>  drivers/mtd/mtd_blkdevs.c           |    2 -
>  drivers/scsi/libsas/sas_scsi_host.c |    2 -
>  drivers/scsi/scsi_error.c           |    2 -
>  drivers/usb/storage/usb.c           |    2 -
>  include/linux/freezer.h             |   44 +++++++++++++++++++-----
>  kernel/freezer.c                    |   64 ++++++++++++++++++++++++++++++------
>  kernel/kprobes.c                    |    4 +-
>  kernel/kthread.c                    |    2 -
>  kernel/power/disk.c                 |    4 +-
>  kernel/power/main.c                 |    8 ++--
>  kernel/power/user.c                 |    6 +--
>  kernel/rcutorture.c                 |    4 +-
>  kernel/sched.c                      |    2 -
>  kernel/softirq.c                    |    2 -
>  kernel/softlockup.c                 |    2 -
>  kernel/workqueue.c                  |    2 -
>  22 files changed, 119 insertions(+), 49 deletions(-)
> 
> Index: linux-2.6.21-rc7/include/linux/freezer.h
> ===================================================================
> --- linux-2.6.21-rc7.orig/include/linux/freezer.h
> +++ linux-2.6.21-rc7/include/linux/freezer.h
> @@ -4,17 +4,27 @@
>  
>  #ifdef CONFIG_FREEZER
>  
> +
>  /*
>   *	Per task flags used by the freezer
>   *
>   *	They should not be referred to directly outside of this file.
>   */
> -#define TFF_NOFREEZE	0	/* task should not be frozen */
> +#define TFF_FE_SUSPEND	0	/* Do not freeze task for software suspend */
> +#define TFF_FE_KPROBES	1	/* Do not freeze task for kprobes */
>  #define TFF_FREEZE	8	/* task should go to the refrigerator ASAP */
>  #define TFF_SKIP	9	/* do not count this task as freezable */
>  #define TFF_FROZEN	10	/* task is frozen */
>  
>  /*
> + * Codes of different events which use the freezer
> + * These are the only flags that can be referred outside this file
> + */
> +#define FE_SUSPEND	(1 << TFF_FE_SUSPEND) /* Software Suspend */
> +#define FE_KPROBES	(1 << TFF_FE_KPROBES)	/* Kprobes */
> +#define FE_ALL		(FE_SUSPEND | FE_KPROBES) /* All events using freezer */
> +
> +/*
>   * Check if a process has been frozen
>   */
>  static inline int frozen(struct task_struct *p)
> @@ -57,19 +67,29 @@ static inline void clear_freeze_flag(str
>  }
>  
>  /*
> - * Check if the task wants to be exempted from freezing
> + * Check if the task wants to be exempted from freezing for
> + * freeze_event.
>   */
> -static inline int freezer_should_exempt(struct task_struct *p)
> +static inline int freezer_should_exempt(struct task_struct *p,
> +					unsigned long freeze_event)
>  {
> -	return test_bit(TFF_NOFREEZE, &p->freezer_flags);
> +	return p->freezer_flags & freeze_event;
>  }
>  
>  /*
>   * Tell the freezer to exempt this task from freezing
> + * for events in freeze_event_mask.
>   */
> -static inline void freezer_exempt(struct task_struct *p)

I, personally, would introduce

static inline void freezer_exempt_event(struct task_struct *p,
				  unsigned long freeze_event_mask)
{
	atomic_set_mask(freeze_event_mask, &p->freezer_flags);
}

and then

static inline void freezer_exempt(struct task_struct *p)
{
	freezer_exempt_event(p, FE_ALL);
}

The patch would be shorter. ;-)

[In that case I'd probably rename freezer_should_exempt() to
freezer_should_exempt_event(), for symmetry.]

> +static inline void freezer_exempt(struct task_struct *p,
> +				  unsigned long freeze_event_mask)
> +{
> +	atomic_set_mask(freeze_event_mask, &p->freezer_flags);
> +}
> +
> +/* Returns the mask of the events for which this process is freezeable */
> +static inline unsigned long freezeable_event_mask(struct task_struct *p)
>  {
> -	set_bit(TFF_NOFREEZE, &p->freezer_flags);
> +	return ~p->freezer_flags & FE_ALL;
>  }
>  
>  /*
> @@ -96,8 +116,8 @@ static inline int thaw_process(struct ta
>  }
>  
>  extern void refrigerator(void);
> -extern int freeze_processes(void);
> -extern void thaw_processes(void);
> +extern int freeze_processes(unsigned long freeze_event);
> +extern void thaw_processes(unsigned long freeze_event);
>  
>  static inline int try_to_freeze(void)
>  {
> @@ -160,11 +180,15 @@ static inline int freezing(struct task_s
>  static inline void freeze(struct task_struct *p) { BUG(); }
>  static inline int freezer_should_exempt(struct task_struct *p) { return 0; }
>  static inline void freezer_exempt(struct task_struct *p) {}
> +static inline unsigned long freezeable_event_mask(struct task_struct *p)
> +{
> +	return 0;
> +}
>  static inline int thaw_process(struct task_struct *p) { return 1; }
>  
>  static inline void refrigerator(void) {}
> -static inline int freeze_processes(void) { BUG(); return 0; }
> -static inline void thaw_processes(void) {}
> +static inline int freeze_processes(unsigned long) { BUG(); return 0; }
> +static inline void thaw_processes(unsigned long) {}
>  
>  static inline int try_to_freeze(void) { return 0; }
>  
> Index: linux-2.6.21-rc7/kernel/freezer.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/freezer.c
> +++ linux-2.6.21-rc7/kernel/freezer.c
> @@ -23,21 +23,44 @@
>  #define FREEZER_KERNEL_THREADS 0
>  #define FREEZER_USER_SPACE 1
>  
> +static DEFINE_MUTEX(freezer_mutex);
> +/* Mask of the events for which the system is currently frozen */
> +unsigned long system_frozen_event_mask;
> +/* The event for which the freeze request has been raised */
> +unsigned long current_freezer_event;
> +
>  static inline int freezeable(struct task_struct * p)
>  {
>  	if ((p == current) ||
> -	    freezer_should_exempt(p) ||
> +	    freezer_should_exempt(p, current_freezer_event) ||
>  	    (p->exit_state != 0))
>  		return 0;
>  	return 1;
>  }
>  
> +/* Returns the mask of events for which p is currently frozen */
> +static inline unsigned long process_frozen_event_mask(struct task_struct *p)
> +{
> +	return (freezeable_event_mask(p) & system_frozen_event_mask);
> +}
> +
> +static inline int thawable(struct task_struct *p)
> +{
> +	if (!freezeable(p))
> +		return 0;
> +
> +	/* Thaw p iff it is frozen for current_freezer_event alone */
> +	 if (process_frozen_event_mask(p) & ~current_freezer_event)
> +	 	return 0;
> +
> +	return 1;

I would do

	return !(process_frozen_event_mask(p) & ~current_freezer_event);

> +}
>  /*
>   * freezing is complete, mark current process as frozen
>   */
>  static inline void frozen_process(void)
>  {
> -	if (!unlikely(freezer_should_exempt(current))) {
> +	if (!unlikely(freezer_should_exempt(current, current_freezer_event))) {
>  		set_frozen_flag(current);
>  		wmb();
>  	}
> @@ -185,26 +208,39 @@ static unsigned int try_to_freeze_tasks(
>  /**
>   *	freeze_processes - tell processes to enter the refrigerator
>   *
> + *	@freeze_event : Event that's requesting the services
> + *		        of the process freezer to freeze the system
> + *
>   *	Returns 0 on success, or the number of processes that didn't freeze,
>   *	although they were told to.
>   */
> -int freeze_processes(void)
> +int freeze_processes(unsigned long freeze_event)
>  {
> -	unsigned int nr_unfrozen;
> +	unsigned int nr_unfrozen = 0;
> +
> +	mutex_lock(&freezer_mutex);
> +	if (system_frozen_event_mask & freeze_event)
> +		goto out;
> +
> +	current_freezer_event = freeze_event;
>  
>  	printk("Stopping tasks ... ");
>  	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
>  	if (nr_unfrozen)
> -		return nr_unfrozen;
> +		goto out;
>  
>  	sys_sync();
>  	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
>  	if (nr_unfrozen)
> -		return nr_unfrozen;
> +		goto out;
>  
> +	system_frozen_event_mask |= current_freezer_event;
>  	printk("done.\n");
>  	BUG_ON(in_atomic());

The BUG_ON() is still valid if tasks are already frozen for this event.

> -	return 0;
> +out:
> +	current_freezer_event = 0;
> +	mutex_unlock(&freezer_mutex);
> +	return nr_unfrozen;
>  }
>  
>  static void thaw_tasks(int thaw_user_space)
> @@ -213,7 +249,7 @@ static void thaw_tasks(int thaw_user_spa
>  
>  	read_lock(&tasklist_lock);
>  	do_each_thread(g, p) {
> -		if (!freezeable(p))
> +		if (!thawable(p))
>  			continue;
>  
>  		if (is_user_space(p) == !thaw_user_space)
> @@ -224,13 +260,23 @@ static void thaw_tasks(int thaw_user_spa
>  	read_unlock(&tasklist_lock);
>  }
>  
> -void thaw_processes(void)
> +void thaw_processes(unsigned long thaw_event)
>  {
> +	mutex_lock(&freezer_mutex);
> +	if (!(system_frozen_event_mask & thaw_event)) {
> +		WARN_ON(1);

Hmm, I wouldn't use the WARN_ON() here.  There's nothing wrong in calling
this twice in a row as long as we do the sanity checking.  There's even one
case in which that may be convenient, actually.

> +		goto out;
> +	}
> +	current_freezer_event = thaw_event;
>  	printk("Restarting tasks ... ");
>  	thaw_tasks(FREEZER_KERNEL_THREADS);
>  	thaw_tasks(FREEZER_USER_SPACE);
> +	system_frozen_event_mask &= ~current_freezer_event;
>  	schedule();
>  	printk("done.\n");
> +out:
> +	current_freezer_event = 0;
> +	mutex_unlock(&freezer_mutex);
>  }
>  
>  EXPORT_SYMBOL(refrigerator);
> Index: linux-2.6.21-rc7/arch/i386/kernel/apm.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/arch/i386/kernel/apm.c
> +++ linux-2.6.21-rc7/arch/i386/kernel/apm.c
> @@ -2313,7 +2313,7 @@ static int __init apm_init(void)
>  		remove_proc_entry("apm", NULL);
>  		return err;
>  	}
> -	freezer_exempt(kapmd_task);
> +	freezer_exempt(kapmd_task, FE_ALL);
>  	wake_up_process(kapmd_task);
>  
>  	if (num_online_cpus() > 1 && !smp ) {
> Index: linux-2.6.21-rc7/drivers/block/loop.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/drivers/block/loop.c
> +++ linux-2.6.21-rc7/drivers/block/loop.c
> @@ -582,7 +582,7 @@ static int loop_thread(void *data)
>  	 * hence, it mustn't be stopped at all
>  	 * because it could be indirectly used during suspension
>  	 */
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	set_user_nice(current, -20);
>  
> Index: linux-2.6.21-rc7/drivers/char/apm-emulation.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/drivers/char/apm-emulation.c
> +++ linux-2.6.21-rc7/drivers/char/apm-emulation.c
> @@ -336,7 +336,7 @@ apm_ioctl(struct inode * inode, struct f
>  			 * threads.
>  			 */
>  			flags = current->flags;
> -			freezer_exempt(current);
> +			freezer_exempt(current, FE_ALL);
>  
>  			wait_event(apm_suspend_waitqueue,
>  				   as->suspend_state == SUSPEND_DONE);
> @@ -372,7 +372,7 @@ apm_ioctl(struct inode * inode, struct f
>  			 * threads.
>  			 */
>  			flags = current->flags;
> -			freezer_exempt(current);
> +			freezer_exempt(current, FE_ALL);
>  
>  			wait_event_interruptible(apm_suspend_waitqueue,
>  					 as->suspend_state == SUSPEND_DONE);
> @@ -601,7 +601,7 @@ static int __init apm_init(void)
>  		kapmd_tsk = NULL;
>  		return ret;
>  	}
> -	freezer_exempt(kapmd_tsk);
> +	freezer_exempt(kapmd_tsk, FE_ALL);
>  	wake_up_process(kapmd_tsk);
>  
>  #ifdef CONFIG_PROC_FS
> Index: linux-2.6.21-rc7/drivers/ieee1394/ieee1394_core.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/drivers/ieee1394/ieee1394_core.c
> +++ linux-2.6.21-rc7/drivers/ieee1394/ieee1394_core.c
> @@ -1134,7 +1134,7 @@ static int hpsbpkt_thread(void *__hi)
>  	struct list_head tmp;
>  	int may_schedule;
>  
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	while (!kthread_should_stop()) {
>  
> Index: linux-2.6.21-rc7/drivers/md/md.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/drivers/md/md.c
> +++ linux-2.6.21-rc7/drivers/md/md.c
> @@ -4541,7 +4541,7 @@ static int md_thread(void * arg)
>  	 * many dirty RAID5 blocks.
>  	 */
>  
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  	while (!kthread_should_stop()) {
>  
>  		/* We need to wait INTERRUPTIBLE so that
> Index: linux-2.6.21-rc7/drivers/mmc/card/queue.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/drivers/mmc/card/queue.c
> +++ linux-2.6.21-rc7/drivers/mmc/card/queue.c
> @@ -67,7 +67,7 @@ static int mmc_queue_thread(void *d)
>  	 * the process freezing.  We handle suspension ourselves.
>  	 */
>  	current->flags |= PF_MEMALLOC;
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	down(&mq->thread_sem);
>  	do {
> Index: linux-2.6.21-rc7/drivers/mtd/mtd_blkdevs.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/drivers/mtd/mtd_blkdevs.c
> +++ linux-2.6.21-rc7/drivers/mtd/mtd_blkdevs.c
> @@ -82,7 +82,7 @@ static int mtd_blktrans_thread(void *arg
>  
>  	/* we might get involved when memory gets low, so use PF_MEMALLOC */
>  	current->flags |= PF_MEMALLOC;
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	spin_lock_irq(rq->queue_lock);
>  	while (!kthread_should_stop()) {
> Index: linux-2.6.21-rc7/drivers/scsi/libsas/sas_scsi_host.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/drivers/scsi/libsas/sas_scsi_host.c
> +++ linux-2.6.21-rc7/drivers/scsi/libsas/sas_scsi_host.c
> @@ -871,7 +871,7 @@ static int sas_queue_thread(void *_sas_h
>  	struct sas_ha_struct *sas_ha = _sas_ha;
>  	struct scsi_core *core = &sas_ha->core;
>  
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	complete(&queue_th_comp);
>  
> Index: linux-2.6.21-rc7/drivers/scsi/scsi_error.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/drivers/scsi/scsi_error.c
> +++ linux-2.6.21-rc7/drivers/scsi/scsi_error.c
> @@ -1536,7 +1536,7 @@ int scsi_error_handler(void *data)
>  {
>  	struct Scsi_Host *shost = data;
>  
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	/*
>  	 * We use TASK_INTERRUPTIBLE so that the thread is not
> Index: linux-2.6.21-rc7/drivers/usb/storage/usb.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/drivers/usb/storage/usb.c
> +++ linux-2.6.21-rc7/drivers/usb/storage/usb.c
> @@ -301,7 +301,7 @@ static int usb_stor_control_thread(void 
>  	struct us_data *us = (struct us_data *)__us;
>  	struct Scsi_Host *host = us_to_host(us);
>  
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	for(;;) {
>  		try_to_freeze();
> Index: linux-2.6.21-rc7/kernel/kthread.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/kthread.c
> +++ linux-2.6.21-rc7/kernel/kthread.c
> @@ -233,7 +233,7 @@ int kthreadd(void *unused)
>  	/* Setup a clean context for our children to inherit. */
>  	kthreadd_setup();
>  
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	for (;;) {
>  		set_current_state(TASK_INTERRUPTIBLE);
> Index: linux-2.6.21-rc7/kernel/rcutorture.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/rcutorture.c
> +++ linux-2.6.21-rc7/kernel/rcutorture.c
> @@ -559,7 +559,7 @@ rcu_torture_fakewriter(void *arg)
>  
>  	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
>  	set_user_nice(current, 19);
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	do {
>  		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
> @@ -590,7 +590,7 @@ rcu_torture_reader(void *arg)
>  
>  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
>  	set_user_nice(current, 19);
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	do {
>  		idx = cur_ops->readlock();
> Index: linux-2.6.21-rc7/kernel/sched.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/sched.c
> +++ linux-2.6.21-rc7/kernel/sched.c
> @@ -5478,7 +5478,7 @@ migration_call(struct notifier_block *nf
>  		p = kthread_create(migration_thread, hcpu, "migration/%d",cpu);
>  		if (IS_ERR(p))
>  			return NOTIFY_BAD;
> -		freezer_exempt(p);
> +		freezer_exempt(p, FE_ALL);
>  		kthread_bind(p, cpu);
>  		/* Must be high prio: stop_machine expects to yield to it. */
>  		rq = task_rq_lock(p, &flags);
> Index: linux-2.6.21-rc7/kernel/softirq.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/softirq.c
> +++ linux-2.6.21-rc7/kernel/softirq.c
> @@ -490,7 +490,7 @@ void __init softirq_init(void)
>  static int ksoftirqd(void * __bind_cpu)
>  {
>  	set_user_nice(current, 15);
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	set_current_state(TASK_INTERRUPTIBLE);
>  
> Index: linux-2.6.21-rc7/kernel/softlockup.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/softlockup.c
> +++ linux-2.6.21-rc7/kernel/softlockup.c
> @@ -117,7 +117,7 @@ static int watchdog(void * __bind_cpu)
>  	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
>  
>  	sched_setscheduler(current, SCHED_FIFO, &param);
> -	freezer_exempt(current);
> +	freezer_exempt(current, FE_ALL);
>  
>  	/* initialize timestamp */
>  	touch_softlockup_watchdog();
> Index: linux-2.6.21-rc7/kernel/workqueue.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/workqueue.c
> +++ linux-2.6.21-rc7/kernel/workqueue.c
> @@ -291,7 +291,7 @@ static int worker_thread(void *__cwq)
>  	DEFINE_WAIT(wait);
>  
>  	if (!cwq->wq->freezeable)
> -		freezer_exempt(current);
> +		freezer_exempt(current, FE_ALL);
>  
>  	for (;;) {
>  		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
> Index: linux-2.6.21-rc7/kernel/kprobes.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/kprobes.c
> +++ linux-2.6.21-rc7/kernel/kprobes.c
> @@ -109,7 +109,7 @@ static int __kprobes check_safety(void)
>  {
>  	int ret = 0;
>  #ifdef CONFIG_PREEMPT
> -	ret = freeze_processes();
> +	ret = freeze_processes(FE_KPROBES);
>  	if (ret == 0) {
>  		struct task_struct *p, *q;
>  		do_each_thread(p, q) {
> @@ -122,7 +122,7 @@ static int __kprobes check_safety(void)
>  		} while_each_thread(p, q);
>  	}
>  loop_end:
> -	thaw_processes();
> +	thaw_processes(FE_KPROBES);
>  #else
>  	synchronize_sched();
>  #endif
> Index: linux-2.6.21-rc7/kernel/power/disk.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/power/disk.c
> +++ linux-2.6.21-rc7/kernel/power/disk.c
> @@ -103,7 +103,7 @@ static inline void platform_finish(void)
>  
>  static void unprepare_processes(void)
>  {
> -	thaw_processes();
> +	thaw_processes(FE_SUSPEND);
>  	pm_restore_console();
>  }
>  
> @@ -112,7 +112,7 @@ static int prepare_processes(void)
>  	int error = 0;
>  
>  	pm_prepare_console();
> -	if (freeze_processes()) {
> +	if (freeze_processes(FE_SUSPEND)) {
>  		error = -EBUSY;
>  		unprepare_processes();
>  	}
> Index: linux-2.6.21-rc7/kernel/power/main.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/power/main.c
> +++ linux-2.6.21-rc7/kernel/power/main.c
> @@ -90,9 +90,9 @@ static int suspend_prepare(suspend_state
>  	if (error)
>  		goto Finish;
>  
> -	if (freeze_processes()) {
> +	if (freeze_processes(FE_SUSPEND)) {
>  		error = -EAGAIN;
> -		thaw_processes();
> +		thaw_processes(FE_SUSPEND);
>  		goto Finish;
>  	}
>  
> @@ -133,7 +133,7 @@ static int suspend_prepare(suspend_state
>  	resume_console();
>   Thaw:
>  	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
> -	thaw_processes();
> +	thaw_processes(FE_SUSPEND);
>   Finish:
>  	pm_restore_console();
>  	suspend_notifier_call_chain(SUSPEND_FINISHED);
> @@ -185,7 +185,7 @@ static void suspend_finish(suspend_state
>  	device_resume();
>  	resume_console();
>  	suspend_notifier_call_chain(SUSPEND_THAW_PREPARE);
> -	thaw_processes();
> +	thaw_processes(FE_SUSPEND);
>  	pm_restore_console();
>  	suspend_notifier_call_chain(SUSPEND_FINISHED);
>  }
> Index: linux-2.6.21-rc7/kernel/power/user.c
> ===================================================================
> --- linux-2.6.21-rc7.orig/kernel/power/user.c
> +++ linux-2.6.21-rc7/kernel/power/user.c
> @@ -81,7 +81,7 @@ static void snapshot_unfreeze(struct sna
>  		return;
>  
>  	mutex_lock(&pm_mutex);
> -	thaw_processes();
> +	thaw_processes(FE_SUSPEND);
>  	suspend_notifier_call_chain(SUSPEND_FINISHED);
>  	mutex_unlock(&pm_mutex);
>  	data->frozen = 0;
> @@ -257,8 +257,8 @@ static int snapshot_ioctl(struct inode *
>  		if (error)
>  			break;
>  
> -		if (freeze_processes()) {
> -			thaw_processes();
> +		if (freeze_processes(FE_SUSPEND)) {
> +			thaw_processes(FE_SUSPEND);
>  			suspend_notifier_call_chain(SUSPEND_FINISHED);
>  			error = -EBUSY;
>  		}
