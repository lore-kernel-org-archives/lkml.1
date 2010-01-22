Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104Ab0AVW1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0AVW1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 17:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977Ab0AVW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 17:27:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767Ab0AVW1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 17:27:12 -0500
Date: Fri, 22 Jan 2010 14:24:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Chan <mike@android.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] cpufreq: stats: Do not account for idle time when
 tracking time_in_state
Message-Id: <20100122142454.2767a4e7.akpm@linux-foundation.org>
In-Reply-To: <1263345350-25975-1-git-send-email-mike@android.com>
References: <1263345350-25975-1-git-send-email-mike@android.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 17:15:50 -0800
Mike Chan <mike@android.com> wrote:

> Setting ignore_idle to 1 ignores idle time from time_in_state accounting.
> 
> Currently cpufreq stats accounts for idle time time_in_state for each
> cpu speed. For cpu's that have a low power idle state this improperly
> accounts for time spent at each speed.
> 
> The most relevant case is when the system is idle yet cpu time is still
> accounted for at the lowest speed. This results in heavily skewed statistics
> (towards the lowest speed) which makes these statistics useless when tuning
> cpufreq scaling with cpuidle.
> 

Is there somewhere where this new userspace interface should have been
documented?

> +static ssize_t store_ignore_idle(struct cpufreq_policy *policy, char *buf)
> +{
> +	int input;
> +	if (sscanf(buf, "%d", &input) != 1)
> +		return -EINVAL;
> +
> +	ignore_idle = input;
> +	return 1;
> +}

No bounds checking is needed?

This function will accept input of the form "42foo", which is sloppy. 
Use of strict_strtoul() will fix that.

> +static ssize_t show_ignore_idle(struct cpufreq_policy *policy, char *buf)
> +{
> +	return sprintf(buf, "%d\n", ignore_idle);
> +}
> +
> +CPUFREQ_STATDEVICE_ATTR(total_trans, 0444, show_total_trans, NULL);
> +CPUFREQ_STATDEVICE_ATTR(time_in_state, 0444, show_time_in_state, NULL);
> +CPUFREQ_STATDEVICE_ATTR(ignore_idle, 0664, show_ignore_idle, store_ignore_idle);
>  
>  static struct attribute *default_attrs[] = {
>  	&_attr_total_trans.attr,
> @@ -304,6 +323,21 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
>  	return 0;
>  }
>  
> +void cpufreq_exit_idle(int cpu, unsigned long ticks)
> +{
> +	struct cpufreq_stats *stat;
> +	stat = per_cpu(cpufreq_stats_table, cpu);
> +
> +	/* Wait until cpu stats is initalized */
> +	if (!ignore_idle || !stat || !stat->time_in_state)
> +		return;
> +
> +	spin_lock(&cpufreq_stats_lock);
> +	stat->time_in_state[stat->last_index] =
> +		cputime_sub(stat->time_in_state[stat->last_index], ticks);
> +	spin_unlock(&cpufreq_stats_lock);
> +}

cpufreq_stats_lock is not an irq-safe lock, so if cpufreq_exit_idle()
gets called from an interrupt then this function is deadlockable.  It
doesn't _look_ like cpufreq_exit_idle() is presently called from a
clock interrupt, but I didn't look too closely.

>  static int __cpuinit cpufreq_stat_cpu_callback(struct notifier_block *nfb,
>  					       unsigned long action,
>  					       void *hcpu)
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 4de02b1..e3f1363 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -256,6 +256,11 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
>  
>  void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state);
>  
> +#ifdef CONFIG_CPU_FREQ_STAT
> +extern void cpufreq_exit_idle(int cpu, unsigned long ticks);
> +#else
> +#define cpufreq_exit_idle(int cpu, unsigned long ticks) do {} while (0)

This didn't need to be a macro, I think.  A static inline provides
typechecking and is hence preferred.

> +#endif
>  
>  static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy, unsigned int min, unsigned int max) 
>  {
> diff --git a/kernel/sched.c b/kernel/sched.c
> index c535cc4..feef94c 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -54,6 +54,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/cpu.h>
>  #include <linux/cpuset.h>
> +#include <linux/cpufreq.h>
>  #include <linux/percpu.h>
>  #include <linux/kthread.h>
>  #include <linux/proc_fs.h>
> @@ -5187,6 +5188,7 @@ void account_steal_ticks(unsigned long ticks)
>   */
>  void account_idle_ticks(unsigned long ticks)
>  {
> +	cpufreq_exit_idle(smp_processor_id(), ticks);
>  	account_idle_time(jiffies_to_cputime(ticks));
>  }

This only gets called if CONFIG_VIRT_CPU_ACCOUNTING=y, which is mostly
a Xen thing.  But your changelog didn't describe this being a
xen-specific fix so I wonder whether that was intended.

Please cc the sched developers on patches of this nature.  And the Xen
developers if appropriate.

