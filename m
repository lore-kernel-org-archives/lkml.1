Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbYKCUfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbYKCUfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYKCUe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:34:58 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46702 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbYKCUe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:34:57 -0500
Date: Mon, 3 Nov 2008 12:33:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
Message-ID: <20081103203336.GG6792@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <490E094F.7090007@colorfullife.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <490E094F.7090007@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 02, 2008 at 09:10:55PM +0100, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>> --- /dev/null
>> +++ b/Documentation/RCU/trace.txt
>> @@ -0,0 +1,398 @@
>> +CONFIG_RCU_TRACE debugfs Files and Formats
>> +
>> +
>> +The rcupreempt and rcutree implementations of RCU provide debugfs trace
>> +output that summarizes counters and state.  This information is useful 
>> for
>> +debugging RCU itself, and can sometimes also help to debug abuses of RCU.
>> +Note that the rcuclassic implementation of RCU does not provide debugfs
>> +trace output.
>> +
>>   
>
> What about some generic files, with the same content for all rcu backends?
> The implementation could be in rcupdate.c. At least counting the rcu 
> callbacks could be done from generic code, the grace periods could be 
> queried [Do all backends implement rcu_batches_completed?]

For the grace-period latencies, I use the attached kernel
module.  This module simply times synchronize_rcu() to obtain
the grace-period performance.  I have similar modules for other
performance measures.

(Please note that this code was written for my own use only, others
may find the kernel-module parameter names to be quite obnoxious.
But yes, nreaders=1 will give you one synchronize_rcu() -update-
task.  What can I say? I used this module to collect data for
http://www.research.ibm.com/journal/sj/472/guniguntala.pdf, and was not
considering use by others.)

I would rather avoid decorating the RCU code with grace-period-latency
measurement code, since this can be done independently with a kernel
module, and I suspect that more people read the RCU code than measure
the grace-period latency.

All backends do implement rcu_batches_completed(), but its return
value has different units on different RCU implementations.  :-(

> Attached is a hack that I use right now for myself.
> Btw - on my 4-cpu system, the average latency from call_rcu() to the rcu 
> callback is 4-5 milliseconds, (CONFIG_HZ_1000).

Hmmm...  I would expect that if you have some CPUs in dyntick idle mode.
But if I run treercu on an CONFIG_HZ_250 8-CPU Power box, I see 2.5
jiffies per grace period if CPUs are kept out of dyntick idle mode, and
4 jiffies per grace period if CPUs are allowed to enter dyntick idle mode.

Alternatively, if you were testing with multiple concurrent
synchronize_rcu() invocations, you can also see longer grace-period
latencies due to the fact that a new synchronize_rcu() must wait for an
earlier grace period to complete before starting a new one.

The 2.5 jiffies is expected when RCU is idle: the synchronize_rcu()
starts a new grace period immediately, it takes up to a jiffy for the
other CPUs do their scheduling-clock interrupt (which notices that the
grace period started), another jiffy for all the CPUs to do their
next scheduling-clock interrupt (which notices the quiescent state),
and on average a half jiffy for the initiating CPU to notice that the
grace period has completed.

I considered trying to trim an additional jiffy off of this grace-period
latency by having CPUs keep track of whether they were in a quiescent
state at the time that they noticed the start of a new grace period.
My attempts to do this ran afoul of races due to interrupt handlers
containing call_rcu(), but it might be possible for rcu_check_callbacks()
to record both the quiescent-state information and the grace-period
number.  But this needs more thought, as the race conditions are quite
subtle.

							Thanx, Paul

> --
>    Manfred

> rom bf385caf2484d41157a9bef1550cdbefecdefa1b Mon Sep 17 00:00:00 2001
> rom: Manfred Spraul <manfred@colorfullife.com>
> Date: Sun, 2 Nov 2008 20:38:11 +0100
> Subject: [PATCH] kernel/rcupdate.c: add generic rcu statistics
> 
> The patch adds a generic file to debugfs that contains a statistic about
> the performance of the rcu subsystem.
> The code adds a noticeable overhead, thus do not enable it unless you
> are interested in measuring the rcu performance.
> 
> The patch is a hack, for example it doesn't differentiate between
> call_rcu() and call_rcu_bh()
> 
> Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
> 
> ---
>  include/linux/rcupdate.h |   24 ++++++++
>  init/Kconfig             |    9 +++
>  kernel/rcuclassic.c      |    6 +-
>  kernel/rcupdate.c        |  133 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/rcupreempt.c      |    6 +-
>  5 files changed, 172 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 69c81e2..fa23572 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -49,6 +49,9 @@
>   */
>  struct rcu_head {
>  	struct rcu_head *next;
> +#ifdef CONFIG_RCU_BENCHMARK
> +	unsigned long long time;
> +#endif
>  	void (*func)(struct rcu_head *head);
>  };
> 
> @@ -66,6 +69,27 @@ struct rcu_head {
>         (ptr)->next = NULL; (ptr)->func = NULL; \
>  } while (0)
> 
> +#ifdef CONFIG_RCU_BENCHMARK
> +extern void rcu_mark_start(struct rcu_head *head);
> +extern void rcu_mark_completed(struct rcu_head *head);
> +#endif
> +
> +static inline void rcu_inithead(struct rcu_head *head, void (*func)(struct rcu_head *head))
> +{
> +	head->func = func;
> +#ifdef CONFIG_RCU_BENCHMARK
> +	rcu_mark_start(head);
> +#endif
> +}
> +
> +static inline void rcu_callback(struct rcu_head *head)
> +{
> +#ifdef CONFIG_RCU_BENCHMARK
> +	rcu_mark_completed(head);
> +#endif
> +	head->func(head);
> +}
> +
>  /**
>   * rcu_read_lock - mark the beginning of an RCU read-side critical section.
>   *
> diff --git a/init/Kconfig b/init/Kconfig
> index 2227bad..ceeec8c 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -924,6 +924,15 @@ source "block/Kconfig"
>  config PREEMPT_NOTIFIERS
>  	bool
> 
> +config RCU_BENCHMARK
> +	bool
> +	default y
> +	depends on STOP_MACHINE
> +	help
> +	  This option adds per-rcu head statistics about the latency
> +	  of the rcu callbacks.
> +	  If unsure, say N.
> +
>  config STATE_RCU
>  	bool
>  	default y
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index e14e6b2..6774fcf 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -261,7 +261,7 @@ void call_rcu(struct rcu_head *head,
>  {
>  	unsigned long flags;
> 
> -	head->func = func;
> +	rcu_inithead(head, func);
>  	local_irq_save(flags);
>  	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
>  	local_irq_restore(flags);
> @@ -289,7 +289,7 @@ void call_rcu_bh(struct rcu_head *head,
>  {
>  	unsigned long flags;
> 
> -	head->func = func;
> +	rcu_inithead(head, func);
>  	local_irq_save(flags);
>  	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
>  	local_irq_restore(flags);
> @@ -343,7 +343,7 @@ static void rcu_do_batch(struct rcu_data *rdp)
>  	while (list) {
>  		next = list->next;
>  		prefetch(next);
> -		list->func(list);
> +		rcu_callback(list);
>  		list = next;
>  		if (++count >= rdp->blimit)
>  			break;
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index ad63af8..1b4eca5 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -44,6 +44,9 @@
>  #include <linux/cpu.h>
>  #include <linux/mutex.h>
>  #include <linux/module.h>
> +#include <linux/fs.h>
> +#include <linux/debugfs.h>
> +#include <linux/stop_machine.h>
> 
>  enum rcu_barrier {
>  	RCU_BARRIER_STD,
> @@ -163,6 +166,136 @@ void rcu_barrier_sched(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
> 
> +#ifdef CONFIG_RCU_BENCHMARK
> +
> +DEFINE_PER_CPU(unsigned long long, rcu_time_entries);
> +DEFINE_PER_CPU(unsigned long long, rcu_time_val);
> +DEFINE_PER_CPU(unsigned long long, rcu_time_square);
> +
> +#define RCU_TIME_SCALING	1000
> +
> +void rcu_mark_start(struct rcu_head *head)
> +{
> +	struct timespec tv;
> +
> +	getnstimeofday(&tv);
> +
> +	head->time = tv.tv_sec;
> +	head->time *= NSEC_PER_SEC;
> +	head->time += tv.tv_nsec;
> +}
> +static DEFINE_RATELIMIT_STATE(rcumark_rs, DEFAULT_RATELIMIT_INTERVAL,
> +				DEFAULT_RATELIMIT_BURST);
> +void rcu_mark_completed(struct rcu_head *head)
> +{
> +	unsigned long flags;
> +	struct timespec tv;
> +	unsigned long long now;
> +
> +	getnstimeofday(&tv);
> +	now = tv.tv_sec;
> +	now *= NSEC_PER_SEC;
> +	now += tv.tv_nsec;
> +	now -= head->time;
> +	/* safety check, against uninitialized rcu heads */
> +	WARN_ON_RATELIMIT(now > 600*NSEC_PER_SEC, &rcumark_rs);
> +
> +	now /= RCU_TIME_SCALING;
> +	local_irq_save(flags);
> +	__get_cpu_var(rcu_time_entries)++;
> +	__get_cpu_var(rcu_time_val) += now;
> +	now = now*now;
> +	__get_cpu_var(rcu_time_square) += now;
> +	local_irq_restore(flags);
> +}
> +
> +#define RCUMARK_BUFSIZE (256*NR_CPUS)
> +
> +static char rcumark_buf[RCUMARK_BUFSIZE];
> +static DEFINE_MUTEX(rcumark_mutex);
> +
> +static ssize_t rcumark_read(struct file *filp, char __user *buffer,
> +				size_t count, loff_t *ppos)
> +{
> +	int i;
> +	ssize_t bcount;
> +	char *buf = rcumark_buf;
> +	char *ebuf = &rcumark_buf[RCUMARK_BUFSIZE];
> +	unsigned long long entries, val, square;
> +
> +	mutex_lock(&rcumark_mutex);
> +
> +	entries = val = square = 0;
> +	for_each_possible_cpu(i) {
> +		buf += snprintf(buf, ebuf - buf,
> +			"rcu: cpu %d completed=%Ld  val=%Ld square %Ld\n",
> +			i, per_cpu(rcu_time_entries, i),
> +			per_cpu(rcu_time_val, i), per_cpu(rcu_time_square, i));
> +		entries += per_cpu(rcu_time_entries, i);
> +		val += per_cpu(rcu_time_val, i);
> +		square += per_cpu(rcu_time_square, i);
> +	}
> +	buf += snprintf(buf, ebuf - buf, "total: completed=%Ld  val=%Ld square %Ld (scale %d)\n",
> +			entries, val, square, RCU_TIME_SCALING);
> +
> +	/* avg */
> +	val = val/entries;
> +	square = int_sqrt(square/entries - val*val);
> +	buf += snprintf(buf, ebuf - buf, "total: avg=%Ld stddev=%Ld steps/sec %ld\n",
> +			val, square, NSEC_PER_SEC/RCU_TIME_SCALING);
> +
> +	bcount = simple_read_from_buffer(buffer, count, ppos,
> +			rcumark_buf, strlen(rcumark_buf));
> +	mutex_unlock(&rcumark_mutex);
> +	return bcount;
> +}
> +
> +static int __rcumark_reset(void *unused)
> +{
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		per_cpu(rcu_time_entries, i) = 0;
> +		per_cpu(rcu_time_val, i) = 0;
> +		per_cpu(rcu_time_square, i) = 0;
> +	}
> +	return 0;
> +}
> +
> +static ssize_t rcumark_write(struct file *filp, const char __user *buffer,
> +				size_t count, loff_t *ppos)
> +{
> +	mutex_lock(&rcumark_mutex);
> +	stop_machine(__rcumark_reset, NULL, NULL);
> +	mutex_unlock(&rcumark_mutex);
> +
> +	return count;
> +}
> +
> +static struct file_operations rcumark_fops = {
> +	.owner = THIS_MODULE,
> +	.read = rcumark_read,
> +	.write = rcumark_write
> +};
> +
> +static struct dentry *rcudir, *mdata;
> +
> +static int __init rcu_mark_init(void)
> +{
> +	rcudir = debugfs_create_dir("rcumark", NULL);
> +	if (!rcudir)
> +		goto out;
> +	mdata = debugfs_create_file("markdata", 0444, rcudir,
> +						NULL, &rcumark_fops);
> +
> +out:
> +	return 0;
> +}
> +
> +module_init(rcu_mark_init);
> +
> +#endif /* CONFIG_RCU_BENCHMARK */
> +
>  void __init rcu_init(void)
>  {
>  	__rcu_init();
> diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
> index 7a8849b..54326c0 100644
> --- a/kernel/rcupreempt.c
> +++ b/kernel/rcupreempt.c
> @@ -1100,7 +1100,7 @@ static void rcu_process_callbacks(struct softirq_action *unused)
>  	spin_unlock_irqrestore(&rdp->lock, flags);
>  	while (list) {
>  		next = list->next;
> -		list->func(list);
> +		rcu_callback(list);
>  		list = next;
>  		RCU_TRACE_ME(rcupreempt_trace_invoke);
>  	}
> @@ -1111,7 +1111,7 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
>  	unsigned long flags;
>  	struct rcu_data *rdp;
> 
> -	head->func = func;
> +	rcu_inithead(head, func);
>  	head->next = NULL;
>  	local_irq_save(flags);
>  	rdp = RCU_DATA_ME();
> @@ -1130,7 +1130,7 @@ void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
>  	struct rcu_data *rdp;
>  	int wake_gp = 0;
> 
> -	head->func = func;
> +	rcu_inithead(head, func);
>  	head->next = NULL;
>  	local_irq_save(flags);
>  	rdp = RCU_DATA_ME();
> -- 
> 1.5.6.5
> 


--xHFwDpU9dbj6ez1V
Content-Type: text/x-csrc; charset=us-ascii
Content-Description: rcureadperf.c
Content-Disposition: attachment; filename="rcureadperf.c"

/*
 * Read-Copy Update read-side-primitive performance test module.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * Copyright (C) IBM Corporation, 2006
 *
 * Authors: Paul E. McKenney <paulmck@us.ibm.com>
 */
#include <linux/types.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kthread.h>
#include <linux/err.h>
#include <linux/spinlock.h>
#include <linux/smp.h>
#include <linux/rcupdate.h>
#include <linux/interrupt.h>
#include <linux/sched.h>
#include <asm/atomic.h>
#include <linux/bitops.h>
#include <linux/module.h>
#include <linux/completion.h>
#include <linux/moduleparam.h>
#include <linux/percpu.h>
#include <linux/notifier.h>
#include <linux/cpu.h>
#include <linux/random.h>
#include <linux/delay.h>
#include <linux/byteorder/swabb.h>
#include <linux/stat.h>

MODULE_LICENSE("GPL");

static int nreaders = -1;	/* # reader threads, defaults to ncpus-1 */
static int test_duration = 0;	/* Test duration, in seconds. */
static int verbose = 0;		/* Print more debug info. */

module_param(nreaders, int, 0);
MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
module_param(test_duration, int, 0);
MODULE_PARM_DESC(test_duration, "Test duration, in seconds.");
module_param(verbose, int, 0);
MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
#define READPERF_FLAG "rcureadperf: "
#define PRINTK_STRING(s) \
	do { printk(KERN_ALERT READPERF_FLAG s "\n"); } while (0)
#define VERBOSE_PRINTK_STRING(s) \
	do { if (verbose) printk(KERN_ALERT READPERF_FLAG s "\n"); } while (0)
#define VERBOSE_PRINTK_ERRSTRING(s) \
	do { if (verbose) printk(KERN_ALERT READPERF_FLAG "!!! " s "\n"); } while (0)

static char printk_buf[4096];

static int nrealreaders;
static struct task_struct **reader_tasks;
static struct task_struct *stats_task;

enum reader_ctl {
	reader_ctl_init,	/* Initial state. */
	reader_ctl_ready,	/* Reader ready to go. */
	reader_ctl_go,		/* Command readers to go. */
	reader_ctl_pause,	/* Command readers to stop. */
};
static __cacheline_aligned enum reader_ctl reader_ctl = reader_ctl_init;

struct reader_area {
	unsigned long cscount;	/* Count of RCU read-side critical sections */
	enum reader_ctl *ctl;	/* Global reader control variable. */
	enum reader_ctl ack;	/* Per-reader acknowledgement of global ctl. */
	char pad[256];		/* There should be a better way... */
};

#define CSCOUNT_SCALE (100 * 1024) /* scaling factor for cscount. */

static __cacheline_aligned struct reader_area *reader_areas;

static __cacheline_aligned int fullstop = 0;

/*
 * RCU reader kthread.  Repeatedly enters and exits an RCU read-side
 * critical section, counting the number of such entries.
 */
static int
rcu_perf_reader(void *arg)
{
	int i;
	struct reader_area *rap = (struct reader_area *)arg;

	VERBOSE_PRINTK_STRING("rcu_perf_reader task started");
	set_user_nice(current, 19);

	do {
		barrier();
		switch (*rap->ctl) {
		case reader_ctl_init:
			if (rap->ack != reader_ctl_ready) {
				rap->ack = reader_ctl_ready;
			}
			break;
		case reader_ctl_go:
			for (i = 0; i < CSCOUNT_SCALE; i++) {
				rcu_read_lock();
				rcu_read_unlock();
			}
			rap->cscount++;
			break;
		case reader_ctl_pause:
			if (rap->ack != reader_ctl_ready) {
				rap->ack = reader_ctl_ready;
			}
			break;
		case reader_ctl_ready:
			printk(KERN_ALERT "Invalid rcureadperf state");
		}
		cond_resched();
	} while (!kthread_should_stop() && !fullstop);
	VERBOSE_PRINTK_STRING("rcu_perf_reader task stopping");
	while (!kthread_should_stop())
		schedule_timeout_uninterruptible(1);
	return 0;
}

/*
 * Create an RCU-perf statistics message in the specified buffer.
 * Also clear the counts in preparation for another collection
 * interval.
 */
static int
rcu_perf_printk_clear(char *page)
{
	int cnt = 0;
	int i;

	cnt += sprintf(&page[cnt], "rcureadperf: duration: %d scale: %d /",
		       test_duration, CSCOUNT_SCALE);
	for (i = 0; i < nrealreaders; i++) {
		cnt += sprintf(&page[cnt], " %ld",
			       reader_areas[i].cscount);
		reader_areas[i].cscount = 0;
	}
	cnt += sprintf(&page[cnt], "\n");
	return cnt;
}

/*
 * Print torture statistics.  Caller must ensure that there is only
 * one call to this function at a given time!!!  This is normally
 * accomplished by relying on the module system to only have one copy
 * of the module loaded, and then by giving the rcu_perf_stats
 * kthread full control (or the init/cleanup functions when rcu_perf_stats
 * thread is not running).
 */
static void
rcu_perf_stats_print_clear(void)
{
	int cnt;

	cnt = rcu_perf_printk_clear(printk_buf);
	printk(KERN_ALERT "%s", printk_buf);
}

/*
 * Wait until all readers are ready to go.
 */
static int
rcu_wait_readers_ready(void)
{
	int i;

	for (i = 0; i < nrealreaders; i++) {
		while (reader_areas[i].ack != reader_ctl_ready) {
			schedule_timeout_interruptible(1 + HZ / 10);
			if (kthread_should_stop())
				return 1;
		}
	}
	return 0;
}

/*
 * Run repeated tests and print stats for RCU read-side-primitive
 * performance.
 */
static int
rcu_perf_stats(void *arg)
{
	VERBOSE_PRINTK_STRING("rcu_perf_stats task started");
	(void)rcu_wait_readers_ready();
	do {
		reader_ctl = reader_ctl_go;
		schedule_timeout_interruptible(test_duration * HZ);
		reader_ctl = reader_ctl_pause;
		if (rcu_wait_readers_ready())
			break;
		rcu_perf_stats_print_clear();
	} while (!kthread_should_stop());
	VERBOSE_PRINTK_STRING("rcu_perf_stats task stopping");
	return 0;
}

static void
rcu_perf_cleanup(void)
{
	int i;

	fullstop = 1;
	if (reader_tasks != NULL) {
		for (i = 0; i < nrealreaders; i++) {
			if (reader_tasks[i] != NULL) {
				VERBOSE_PRINTK_STRING(
					"Stopping rcu_perf_reader task");
				kthread_stop(reader_tasks[i]);
			}
			reader_tasks[i] = NULL;
		}
		kfree(reader_tasks);
		reader_tasks = NULL;
	}

	if (stats_task != NULL) {
		VERBOSE_PRINTK_STRING("Stopping rcu_perf_stats task");
		kthread_stop(stats_task);
	}
	stats_task = NULL;
	kfree(reader_areas);

	/* Wait for all RCU callbacks to fire.  */
	rcu_barrier();

	printk(KERN_ALERT READPERF_FLAG "--- End of test\n");
}

static int
rcu_perf_init(void)
{
	int i;
	int firsterr = 0;

	/* Process args and tell the world that the torturer is on the job. */

	if (nreaders >= 0)
		nrealreaders = nreaders;
	else
		nrealreaders = num_online_cpus() - 1;
	printk(KERN_ALERT READPERF_FLAG
	       "--- Start of test: nreaders=%d test_duration=%d verbose=%d\n",
	       nrealreaders, test_duration, verbose);
	fullstop = 0;

	/* Initialize the statistics so that each run gets its own numbers. */

	reader_areas = kmalloc(nrealreaders * sizeof(reader_areas[0]),
			       GFP_KERNEL);
	if (reader_areas == NULL) {
		VERBOSE_PRINTK_ERRSTRING("out of memory");
		firsterr = -ENOMEM;
		goto unwind;
	}
	for (i = 0; i < nrealreaders; i++) {
		reader_areas[i].cscount = 0;
		reader_areas[i].ctl = &reader_ctl;
		reader_areas[i].ack = reader_ctl_init;
	}

	/* Start up the kthreads. */
	reader_tasks = kmalloc(nrealreaders * sizeof(reader_tasks[0]),
			       GFP_KERNEL);
	if (reader_tasks == NULL) {
		VERBOSE_PRINTK_ERRSTRING("out of memory");
		firsterr = -ENOMEM;
		goto unwind;
	}
	for (i = 0; i < nrealreaders; i++) {
		VERBOSE_PRINTK_STRING("Creating rcu_perf_reader task");
		reader_tasks[i] = kthread_run(rcu_perf_reader, &reader_areas[i],
					      "rcureadperf");
		if (IS_ERR(reader_tasks[i])) {
			firsterr = PTR_ERR(reader_tasks[i]);
			VERBOSE_PRINTK_ERRSTRING("Failed to create reader");
			reader_tasks[i] = NULL;
			goto unwind;
		}
	}
	if (test_duration > 0) {
		VERBOSE_PRINTK_STRING("Creating rcu_perf_stats task");
		stats_task = kthread_run(rcu_perf_stats, NULL,
					 "rcu_perf_stats");
		if (IS_ERR(stats_task)) {
			firsterr = PTR_ERR(stats_task);
			VERBOSE_PRINTK_ERRSTRING("Failed to create stats");
			stats_task = NULL;
			goto unwind;
		}
	}
	return 0;

unwind:
	rcu_perf_cleanup();
	return firsterr;
}

module_init(rcu_perf_init);
module_exit(rcu_perf_cleanup);

--xHFwDpU9dbj6ez1V--
