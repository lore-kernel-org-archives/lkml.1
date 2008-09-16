Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYIPMHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYIPMHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbYIPMHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:07:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56246 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbYIPMG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:06:59 -0400
Subject: Re: [RFC PATCH 1/1]: timers: Enabling timer migration to cpu0
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu, andi@firstfloor.org,
       venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com
In-Reply-To: <20080916091320.GA945@linux.vnet.ibm.com>
References: <20080916091320.GA945@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 14:05:31 +0200
Message-Id: <1221566731.6943.17.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-16 at 14:43 +0530, Arun R Bharadwaj wrote:
> The implentation details of this as follows:

80 char lines please

> A sysfs entry is created
> at /sys/devices/system/cpu/cpuX/timer_migration. By setting this to 1,
> timer migration is enabled for that cpu.
> An important thing to note here is cpu-pinned timers. Timers can be
> pinned to a particular cpu using the function add_timer_on(). So, such
> timers should not be migrated.

You utterly fail to mention hrtimers even though you do touch those as
well, what's more - there are hrtimers that need to be run on the cpu
that queues them - you don't seem to provide anything like that.

> Since the last 3 bits of the tvec_base is guaranteed to be 0, and
> since the last bit is being used to indicate deferrable timers, I'm
> using the second last bit to indicate cpu-pinned timers.
> The implementation of functions to manage the TBASE_PINNED_FLAG is
> similar to those which manage the TBASE_DEFERRABLE_FLAG.
> 
> Signed-off-by: Arun Bharadwaj <arun@linux.vnet.ibm.com>
> ---

please add --show-c-function to your diff

> Index: linux-2.6.26/drivers/base/cpu.c
> ===================================================================
> --- linux-2.6.26.orig/drivers/base/cpu.c	2008-09-15 08:14:40.000000000 +0000
> +++ linux-2.6.26/drivers/base/cpu.c	2008-09-15 09:34:52.000000000 +0000
> @@ -13,6 +13,7 @@
>  
>  #include "base.h"
>  
> +DEFINE_PER_CPU(int, enable_timer_migration);
>  struct sysdev_class cpu_sysdev_class = {
>  	.name = "cpu",
>  };
> @@ -20,6 +21,21 @@
>  
>  static DEFINE_PER_CPU(struct sys_device *, cpu_sys_devices);
>  
> +#ifdef CONFIG_TIMER_MIGRATION
> +static ssize_t timer_migration_show(struct sys_device *dev, char *buf)
> +{
> +	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
> +	return sprintf(buf, "%u\n", per_cpu(enable_timer_migration, cpu->sysdev.id));
> +}
> +static ssize_t timer_migration_store(struct sys_device *dev, const char *buf, size_t count)
> +{
> +	struct cpu *cpu = container_of(dev, struct cpu, sysdev);
> +	per_cpu(enable_timer_migration, cpu->sysdev.id) = buf[0] - 48;
> +	return count;
> +}
> +static SYSDEV_ATTR(timer_migration, 0666, timer_migration_show, timer_migration_store);
> +#endif

Why bother with the CONFIG_ variable - its so little code and it adds to
the Kconfig space.

>  #ifdef CONFIG_HOTPLUG_CPU
>  static ssize_t show_online(struct sys_device *dev, char *buf)
>  {
> @@ -175,6 +191,11 @@
>  	if (!error)
>  		error = sysdev_create_file(&cpu->sysdev, &attr_crash_notes);
>  #endif
> +
> +#ifdef CONFIG_TIMER_MIGRATION
> +	if (!error)
> +		error = sysdev_create_file(&cpu->sysdev, &attr_timer_migration);
> +#endif
>  	return error;
>  }
>  
> Index: linux-2.6.26/init/Kconfig
> ===================================================================
> --- linux-2.6.26.orig/init/Kconfig	2008-09-15 08:14:40.000000000 +0000
> +++ linux-2.6.26/init/Kconfig	2008-09-15 08:14:48.000000000 +0000
> @@ -923,3 +923,9 @@
>  	  designed for best read-side performance on non-realtime
>  	  systems.  Classic RCU is the default.  Note that the
>  	  PREEMPT_RCU symbol is used to select/deselect this option.
> +
> +config TIMER_MIGRATION
> +	bool
> +	default y
> +	help
> +	  This option enables migration of non cpu-affine timers to cpu0.

this will earn you a place in the hall of kconfig-help-text of shame.

> Index: linux-2.6.26/include/linux/timer.h
> ===================================================================
> --- linux-2.6.26.orig/include/linux/timer.h	2008-09-15 08:14:40.000000000 +0000
> +++ linux-2.6.26/include/linux/timer.h	2008-09-15 08:31:27.000000000 +0000
> @@ -5,6 +5,7 @@
>  #include <linux/ktime.h>
>  #include <linux/stddef.h>
>  #include <linux/debugobjects.h>
> +#include <linux/percpu.h>
>  
>  struct tvec_base;
>  
> @@ -187,3 +188,7 @@
>  unsigned long round_jiffies_relative(unsigned long j);
>  
>  #endif
> +
> +#ifdef CONFIG_TIMER_MIGRATION
> +DECLARE_PER_CPU(int, enable_timer_migration);
> +#endif
> Index: linux-2.6.26/kernel/timer.c
> ===================================================================
> --- linux-2.6.26.orig/kernel/timer.c	2008-09-15 08:14:40.000000000 +0000
> +++ linux-2.6.26/kernel/timer.c	2008-09-15 11:22:06.000000000 +0000
> @@ -37,6 +37,7 @@
>  #include <linux/delay.h>
>  #include <linux/tick.h>
>  #include <linux/kallsyms.h>
> +#include <linux/timer.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -87,8 +88,9 @@
>   * the new flag to indicate whether the timer is deferrable
>   */
>  #define TBASE_DEFERRABLE_FLAG		(0x1)
> +#define TBASE_PINNED_FLAG               (0x2)
>  
> -/* Functions below help us manage 'deferrable' flag */
> +/* Functions below help us manage 'deferrable' flag and 'cpu-pinned-timer' flag */
>  static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
>  {
>  	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
> @@ -96,7 +98,7 @@
>  
>  static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
>  {
> -	return ((struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
> +	return (struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG & ~TBASE_PINNED_FLAG);
>  }

I'm pretty sure this line is too long.

>  static inline void timer_set_deferrable(struct timer_list *timer)
> @@ -105,11 +107,21 @@
>  				       TBASE_DEFERRABLE_FLAG));
>  }
>  
> +static inline unsigned int tbase_get_pinned(struct tvec_base *base)
> +{
> +	return ((unsigned int)(unsigned long)base & TBASE_PINNED_FLAG);
> +}

Why explicitly cast to unsigned int?

>  static inline void
>  timer_set_base(struct timer_list *timer, struct tvec_base *new_base)
>  {
>  	timer->base = (struct tvec_base *)((unsigned long)(new_base) |
> -				      tbase_get_deferrable(timer->base));
> +		   tbase_get_deferrable(timer->base) | tbase_get_pinned(timer->base));
> +}
> +
> +static inline void timer_set_pinned(struct timer_list *timer)
> +{
> +	timer->base = ((struct tvec_base *)((unsigned long)(timer->base) | TBASE_PINNED_FLAG));
>  }

<80 ?

>  /**
> @@ -540,6 +552,12 @@
>  
>  	new_base = __get_cpu_var(tvec_bases);
>  
> +	#ifdef CONFIG_TIMER_MIGRATION
> +	if (__get_cpu_var(enable_timer_migration) && !tbase_get_pinned(timer->base)) {
> +		new_base = per_cpu(tvec_bases, 0);
> +	}
> +	#endif

We don't indent preprocessor directives like that, also we don't use
braces on single statement blocks.

>  	if (base != new_base) {
>  		/*
>  		 * We are trying to schedule the timer on the local CPU.
> @@ -579,6 +597,7 @@
>  	struct tvec_base *base = per_cpu(tvec_bases, cpu);
>  	unsigned long flags;
>  
> +	timer_set_pinned(timer);
>  	timer_stats_timer_set_start_info(timer);
>  	BUG_ON(timer_pending(timer) || !timer->function);
>  	spin_lock_irqsave(&base->lock, flags);
> Index: linux-2.6.26/kernel/hrtimer.c
> ===================================================================
> --- linux-2.6.26.orig/kernel/hrtimer.c	2008-09-15 08:14:40.000000000 +0000
> +++ linux-2.6.26/kernel/hrtimer.c	2008-09-15 11:17:19.000000000 +0000
> @@ -200,6 +200,12 @@
>  	struct hrtimer_cpu_base *new_cpu_base;
>  
>  	new_cpu_base = &__get_cpu_var(hrtimer_bases);
> +
> +	#ifdef CONFIG_TIMER_MIGRATION
> +	if (__get_cpu_var(enable_timer_migration))
> +		new_cpu_base = &per_cpu(hrtimer_bases, 0);
> +	#endif

idem

and NAK - this will actually break stuff.

>  	new_base = &new_cpu_base->clock_base[base->index];
>  
>  	if (base != new_base) {

