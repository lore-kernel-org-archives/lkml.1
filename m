Return-Path: <linux-kernel-owner+w=401wt.eu-S1764657AbXHQQsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764657AbXHQQsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXHQQr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:47:58 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:56431 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbXHQQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:47:57 -0400
Date: Fri, 17 Aug 2007 12:42:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Simple Performance Counters: Core Piece
Message-ID: <20070817164251.GA1004@Krystal>
References: <11859243123373-git-send-email-clameter@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <11859243123373-git-send-email-clameter@sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:40:27 up 18 days, 16:59,  4 users,  load average: 1.49, 1.45, 1.72
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Actually, get_cycles() at least on some AMD cpus, do not synchronize the
core, which can skew the results. You might want to use
get_cycles_sync() there.

Mathieu

* Christoph Lameter (clameter@sgi.com) wrote:
> Simple performance counters are a way to measure the performance on code
> paths in the Linux kernel. Code must be instrumented with calls that signal
> the start and the stop of a measurement.
> 
> The beginning of a code path must have the following. Either:
> 
> 	INIT_PC(var)
> 
> or
> 	struct pc var;
> 
> 	...
> 
> 	pc_start(&var);
> 
> 
> 
> and at the end of the segment of code to be measured either:
> 
> 	pc_stop(&var, PC_xxx);
> 
> to just measure time intervals. Or
> 
> 	pc_bytes(&var, bytes, PC_xxx)
> 
> to measure the amount of data that a code path can handle.
> 
> 
> The data can then be viewed as the kernel runs via
> 
> cat /proc/perf/all
> 
> Which will show some timing and performance statistics. The numbers in ()
> show 3 values: (mininum/average/maximum)
> 
> update_process_times                21370 14.8ms(194ns/693ns/9us)
> alloc_pages                        297542 189.4ms(96ns/637ns/68.7us) 1.2gb(4.1kb/4.2kb/16.4kb)
> kmem_cache_alloc                   637116 71.7ms(10ns/113ns/60.8us)
> kmem_cache_free                    566426 39.2ms(19ns/69ns/7.1us)
> kfree                               48622 4.1ms(19ns/84ns/3.7us)
> 
> 
> update_process_times needed between 194ns and 9us. On average is needsd 693 nanoseconds.
> 21370 measurements werer performed.
> 
> 
> Data can be zeroed by writing to /proc/perf/reset.
> 
> Typically one would zero the counters and then perform a kernel activity that
> exercises the instrumented code path.
> 
> 
> 
> Data can be viewed in
> /proc/perf
> 
> Special files:
> 
> /proc/perf/all		Shows a summary
> /proc/perf/reset	Writing to this file resets counters
> /proc/perf/0		Counters on processor  0
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> ---
>  include/linux/perf.h |   55 ++++++++
>  init/Kconfig         |   10 ++
>  kernel/Makefile      |    1 +
>  kernel/perf.c        |  368 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/timer.c       |    3 +
>  5 files changed, 437 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/perf.h
>  create mode 100644 kernel/perf.c
> 
> diff --git a/include/linux/perf.h b/include/linux/perf.h
> new file mode 100644
> index 0000000..2958c81
> --- /dev/null
> +++ b/include/linux/perf.h
> @@ -0,0 +1,55 @@
> +#ifndef __LINUX_PERF_H
> +#define __LINUX_PERF_H
> +
> +#include <linux/timex.h>
> +/*
> + * Time Stamp Performance Counters
> + *
> + * (C) 2007 Silicon Graphics, Inc.
> + *	Christoph Lameter <clameter@sgi.com>, April 2007
> + *
> + * Counters are calculated using the cycle counter. If a process
> + * is migrated to another cpu during the measurement then the measurement
> + * is invalid.
> + */
> +
> +enum pc_item {
> +	PC_UPDATE_PROCESS_TIMES,
> +	NR_PC_ITEMS
> +};
> +
> +/*
> + * Information about the start of the measurement
> + */
> +struct pc {
> +	unsigned long time;
> +	int processor;
> +};
> +
> +#define pc_stop(__pc, __nr) pc_bytes(__pc, 0, __nr)
> +
> +#ifdef CONFIG_PERFCOUNT
> +
> +#define INIT_PC(__var) struct pc __var = \
> +		{ get_cycles(), raw_smp_processor_id() }
> +
> +static inline void pc_start(struct pc *pc)
> +{
> +	pc->processor = raw_smp_processor_id();
> +	pc->time = get_cycles();
> +}
> +
> +void pc_bytes(struct pc *pc, unsigned long bytes, enum pc_item nr);
> +
> +void pc_stop_printk(struct pc *pc);
> +
> +#else
> +
> +#define INIT_PC(__var) char __var[0]
> +#define pc_start(__var) do { } while (!__var)
> +#define pc_bytes(__var, __b, __i) do { } while (!__var)
> +#define pc_stop_printk(__var) do { } while (!__var)
> +#endif
> +
> +#endif
> +
> diff --git a/init/Kconfig b/init/Kconfig
> index 96b5459..affb532 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -206,6 +206,16 @@ config TASK_IO_ACCOUNTING
>  
>  	  Say N if unsure.
>  
> +config PERFCOUNT
> +	bool "Time Stamp Counter based performance measurements"
> +	help
> +	  Enables performance counters based on the time stamp counters.
> +	  These can be used to measure code paths in the kernel and also
> +	  gauge their effectiveness in transferring bytes. The performance
> +	  counters must be added by modifying code. The counters will then
> +	  be visible via files in /proc/perf/*.
> +
> +
>  config USER_NS
>  	bool "User Namespaces (EXPERIMENTAL)"
>  	default n
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 2a99983..0f3eaa9 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_RELAY) += relay.o
>  obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
>  obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
>  obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
> +obj-$(CONFIG_PERFCOUNT) += perf.o
>  
>  ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
>  # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
> diff --git a/kernel/perf.c b/kernel/perf.c
> new file mode 100644
> index 0000000..14cba9c
> --- /dev/null
> +++ b/kernel/perf.c
> @@ -0,0 +1,368 @@
> +/*
> + * Simple Performance Counter subsystem
> + *
> + * (C) 2007 Silicong Graphics, Inc.
> + *
> + * 	Christoph Lameter <clameter@sgi.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/percpu.h>
> +#include <linux/seq_file.h>
> +#include <linux/fs.h>
> +#include <linux/proc_fs.h>
> +#include <linux/cpumask.h>
> +#include <linux/perf.h>
> +
> +#ifdef CONFIG_NUMA
> +static int unsynced_get_cycles = 1;
> +#else
> +#define unsynced_get_cycles 0
> +#endif
> +
> +const char *var_id[NR_PC_ITEMS] = {
> +	"update_process_times",
> +};
> +
> +struct perf_counter {
> +	u32 events;
> +	u32 mintime;
> +	u32 maxtime;
> +	u32 minbytes;
> +	u32 maxbytes;
> +	u32 skipped;
> +	u64 time;
> +	u64 bytes;
> +};
> +
> +static DEFINE_PER_CPU(struct perf_counter, perf_counters)[NR_PC_ITEMS];
> +
> +void pc_bytes(struct pc *pc, unsigned long bytes, enum pc_item nr)
> +{
> +	unsigned long time = get_cycles();
> +	unsigned long ns;
> +	struct perf_counter *p = &get_cpu_var(perf_counters)[nr];
> +
> +	if (unlikely(nr >= NR_PC_ITEMS)) {
> +		printk(KERN_CRIT "pc_bytes: item number "
> +			"(%d) out of range\n", nr);
> +		dump_stack();
> +		goto out;
> +	}
> +
> +	if (unlikely(unsynced_get_cycles &&
> +			pc->processor != smp_processor_id())) {
> +		/* On different processor. TSC measurement not possible. */
> +		p->skipped++;
> +		goto out;
> +	}
> +
> +	ns = cycles_to_ns((unsigned long long)(time - pc->time));
> +	p->time += ns;
> +	p->events++;
> +
> +	if (ns > p->maxtime)
> +		p->maxtime = ns;
> +
> +	if (p->mintime == 0 || ns < p->mintime)
> +		p->mintime = ns;
> +
> +	if (bytes) {
> +		p->bytes += bytes;
> +		if (bytes > p->maxbytes)
> +			p->maxbytes = bytes;
> +		if (p->minbytes == 0 || bytes < p->minbytes)
> +			p->minbytes = bytes;
> +	}
> +out:
> +	put_cpu_var();
> +	return;
> +}
> +EXPORT_SYMBOL(pc_bytes);
> +
> +static void reset_perfcount_item(struct perf_counter *c)
> +{
> +	memset(c, 0, sizeof(struct perf_counter));
> +}
> +
> +static void perfcount_reset(void) {
> +	int cpu;
> +	enum pc_item i;
> +
> +	for_each_online_cpu(cpu)
> +		for (i = 0; i < NR_PC_ITEMS; i++)
> +			reset_perfcount_item(
> +				&per_cpu(perf_counters, cpu)[i]);
> +}
> +
> +struct unit {
> +	unsigned int n;
> +	const char * s;
> +};
> +
> +static const struct unit event_units[] = {
> +	{ 1000, "" },
> +	{ 1000, "K" },
> +	{ 1000, "M" },
> +	{ 1000, "G" },
> +	{ 1000, "T" },
> +	{ 1000, "P" },
> +	{ 1000, "Q" },
> +};
> +
> +
> +static const struct unit time_units[] = {
> +	{ 1000, "ns" },
> +	{ 1000, "us" },
> +	{ 1000, "ms" },
> +	{ 60, "s" },
> +	{ 60, "m" },
> +	{ 24, "h" },
> +	{ 365, "d" },
> +	{ 1000, "y" },
> +};
> +
> +static const struct unit byte_units[] = {
> +	{ 1000, "b" },
> +	{ 1000, "kb" },
> +	{ 1000, "mb" },
> +	{ 1000, "gb" },
> +	{ 1000, "tb" },
> +	{ 1000, "pb" },
> +	{ 1000, "qb" }
> +};
> +
> +/* Print a value using the given array of units and scale it properly */
> +static void pval(struct seq_file *s, unsigned long x, const struct unit *u)
> +{
> +	unsigned n = 0;
> +	unsigned rem = 0;
> +	unsigned last_divisor = 0;
> +
> +	while (x >= u[n].n) {
> +		last_divisor = u[n].n;
> +		rem = x % last_divisor;
> +		x = x / last_divisor;
> +		n++;
> +	}
> +
> +	if (last_divisor)
> +		rem = (rem * 10 + last_divisor / 2) / last_divisor;
> +	else
> +		rem = 0;
> +
> +	/*
> +	 * Rounding may have resulted in the need to go
> +	 * to the next number
> +	 */
> +	if (rem == 10) {
> +		x++;
> +		rem = 0;
> +	};
> +
> +	seq_printf(s, "%lu", x);
> +	if (rem) {
> +		seq_putc(s, '.');
> +		seq_putc(s, '0' + rem);
> +	}
> +	seq_puts(s, u[n].s);
> +}
> +
> +/* Print a value using the given array of units and scale it properly */
> +void pc_stop_printk(struct pc *pc)
> +{
> +	unsigned n = 0;
> +	unsigned rem = 0;
> +	unsigned last_divisor = 0;
> +	const struct unit *u = time_units;
> +	unsigned long x = cycles_to_ns(get_cycles() - pc->time);
> +
> +	while (x >= u[n].n) {
> +		last_divisor = u[n].n;
> +		rem = x % last_divisor;
> +		x = x / last_divisor;
> +		n++;
> +	}
> +
> +	if (last_divisor)
> +		rem = (rem * 10 + last_divisor / 2) / last_divisor;
> +	else
> +		rem = 0;
> +
> +	/*
> +	 * Rounding may have resulted in the need to go
> +	 * to the next number
> +	 */
> +	if (rem == 10) {
> +		x++;
> +		rem = 0;
> +	};
> +
> +	printk("%lu", x);
> +	if (rem) {
> +		char x[3] = ".0";
> +
> +		x[1] += rem;
> +		printk(x);
> +	}
> +	printk(u[n].s);
> +}
> +
> +/* Print a set of statistical values in the form sum(max/avg/min) */
> +static void pc_print(struct seq_file *s, const struct unit *u,
> +	unsigned long count, unsigned long sum,
> +	unsigned long min, unsigned long max)
> +{
> +	pval(s, sum, u);
> +	seq_putc(s,'(');
> +	pval(s, min, u);
> +	seq_putc(s,'/');
> +	if (count)
> +		pval(s, (sum + count / 2 ) / count, u);
> +	else
> +		pval(s, 0, u);
> +	seq_putc(s,'/');
> +	pval(s, max, u);
> +	seq_putc(s,')');
> +}
> +
> +
> +static int perf_show(struct seq_file *s, void *v)
> +{
> +	int cpu = (unsigned long)s->private;
> +	enum pc_item counter = (unsigned long)v - 1;
> +	struct perf_counter summary, *x;
> +
> +	if (cpu >= 0)
> +		x = &per_cpu(perf_counters, cpu)[counter];
> +	else {
> +		memcpy(&summary, &per_cpu(perf_counters, 0)[counter],
> +			sizeof(summary));
> +		for_each_online_cpu(cpu) {
> +			struct perf_counter *c =
> +				&per_cpu(perf_counters, 0)[counter];
> +
> +			summary.events += c->events;
> +			summary.skipped += c->skipped;
> +			summary.time += c->time;
> +			summary.bytes += c->bytes;
> +
> +			if (summary.maxtime < c->maxtime)
> +				summary.maxtime = c->maxtime;
> +
> +			if (summary.mintime == 0 ||
> +				(c->mintime != 0 &&
> +				summary.mintime > c->mintime))
> +					summary.mintime = c->mintime;
> +
> +			if (summary.maxbytes < c->maxbytes)
> +				summary.maxbytes = c->maxbytes;
> +
> +			if (summary.minbytes == 0 ||
> +				(c->minbytes != 0 &&
> +				summary.minbytes > c->minbytes))
> +					summary.minbytes = c->minbytes;
> +
> +		}
> +		x = &summary;
> +	}
> +
> +	seq_printf(s, "%-30s %10u ", var_id[counter], x->events);
> +	if (x->skipped)
> +		seq_printf(s, "(+%3u) ", x->skipped);
> +	pc_print(s, time_units, x->events, x->time, x->mintime, x->maxtime);
> +	if (x->bytes) {
> +		seq_putc(s,' ');
> +		pc_print(s, byte_units, x->events, x->bytes,
> +			x->minbytes, x->maxbytes);
> +	}
> +	seq_putc(s, '\n');
> +	return 0;
> +}
> +
> +static void *perf_start(struct seq_file *m, loff_t *pos)
> +{
> +	return (*pos < NR_PC_ITEMS) ? (void *)(*pos +1) : NULL;
> +}
> +
> +static void *perf_next(struct seq_file *m, void *v, loff_t *pos)
> +{
> +	++*pos;
> +	return perf_start(m, pos);
> +}
> +
> +static void perf_stop(struct seq_file *m, void *v)
> +{
> +}
> +
> +struct seq_operations perf_data_ops = {
> +	.start  = perf_start,
> +	.next   = perf_next,
> +	.stop   = perf_stop,
> +	.show   = perf_show,
> +};
> +
> +static int perf_data_open(struct inode *inode, struct file *file)
> +{
> +	int res;
> +
> +	res = seq_open(file, &perf_data_ops);
> +	if (!res)
> +		((struct seq_file *)file->private_data)->private =
> +							PDE(inode)->data;
> +
> +	return res;
> +}
> +
> +static struct file_operations perf_data_fops = {
> +	.open		= perf_data_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release,
> +};
> +
> +static int perf_reset_write(struct file *file, const char __user *buffer,
> +	unsigned long count, void *data)
> +{
> +	perfcount_reset();
> +	return count;
> +}
> +
> +static __init int init_perfcounter(void) {
> +	int cpu;
> +
> +	struct proc_dir_entry *proc_perf, *perf_reset, *perf_all;
> +
> +	proc_perf = proc_mkdir("perf", NULL);
> +	if (!proc_perf)
> +		return -ENOMEM;
> +
> +	perf_reset = create_proc_entry("reset", S_IWUGO, proc_perf);
> +	perf_reset->write_proc = perf_reset_write;
> +
> +	perf_all = create_proc_entry("all", S_IRUGO, proc_perf);
> +	perf_all->proc_fops = &perf_data_fops;
> +	perf_all->data = (void *)-1;
> +
> +	for_each_possible_cpu(cpu) {
> +		char name[20];
> +		struct proc_dir_entry *p;
> +
> +		sprintf(name, "%d", cpu);
> +		p = create_proc_entry(name, S_IRUGO, proc_perf);
> +
> +		p->proc_fops = &perf_data_fops;
> +		p->data = (void *)(unsigned long)cpu;
> +	}
> +
> +	perfcount_reset();
> +
> +#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
> +	if (!unsynchronized_tsc())
> +		unsynced_get_cycles = 0;
> +#endif
> +	return 0;
> +}
> +
> +__initcall(init_perfcounter);
> +
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 6ce1952..55d4619 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -36,6 +36,7 @@
>  #include <linux/delay.h>
>  #include <linux/tick.h>
>  #include <linux/kallsyms.h>
> +#include <linux/perf.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -824,6 +825,7 @@ void update_process_times(int user_tick)
>  {
>  	struct task_struct *p = current;
>  	int cpu = smp_processor_id();
> +	INIT_PC(pc);
>  
>  	/* Note: this timer irq context must be accounted for as well. */
>  	if (user_tick)
> @@ -835,6 +837,7 @@ void update_process_times(int user_tick)
>  		rcu_check_callbacks(cpu, user_tick);
>  	scheduler_tick();
>  	run_posix_cpu_timers(p);
> +	pc_stop(&pc, PC_UPDATE_PROCESS_TIMES);
>  }
>  
>  /*
> -- 
> 1.5.2.4
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
