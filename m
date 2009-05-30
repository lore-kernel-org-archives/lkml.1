Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZE3Bxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZE3Bxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 21:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZE3Bxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 21:53:41 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54853 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbZE3Bxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 21:53:40 -0400
Date: Fri, 29 May 2009 18:53:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, ego@in.ibm.com
Subject: Re: [PATCH 1/2] cpuhotplug: use rw_semaphore for cpu_hotplug
Message-ID: <20090530015342.GA21502@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A1F9CEA.1070705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1F9CEA.1070705@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 04:29:30PM +0800, Lai Jiangshan wrote:
> 
> Current get_online_cpus()/put_online_cpus() re-implement
> a rw_semaphore, so it is converted to a real rw_semaphore in this fix.
> It simplifies codes, and is good for read.
> 
> And misc fix:
> 1) Add comments for cpu_hotplug.active_writer.
> 2) The theoretical disadvantage described in cpu_hotplug_begin()'s
>    comments is no longer existed when we use rw_semaphore,
>    so this part of comments was removed.
> 
> [Impact: improve get_online_cpus()/put_online_cpus() ]

Actually, it turns out that for my purposes it is only necessary to check:

	cpu_hotplug.active_writer != NULL

The only time that it is unsafe to invoke get_online_cpus() is when
in a notifier, and in that case the value of cpu_hotplug.active_writer
is stable.  There could be false positives, but these are harmless, as
the fallback is simply synchronize_sched().

Even this is only needed should the deadlock scenario you pointed out
arise in practice.

As Oleg noted, there are some "interesting" constraints on
get_online_cpus().  Adding Gautham Shenoy to CC for his views.

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 395b697..62198ec 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -14,6 +14,7 @@
>  #include <linux/kthread.h>
>  #include <linux/stop_machine.h>
>  #include <linux/mutex.h>
> +#include <linux/rwsem.h>
> 
>  #ifdef CONFIG_SMP
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
> @@ -27,20 +28,21 @@ static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
>  static int cpu_hotplug_disabled;
> 
>  static struct {
> -	struct task_struct *active_writer;
> -	struct mutex lock; /* Synchronizes accesses to refcount, */
>  	/*
> -	 * Also blocks the new readers during
> -	 * an ongoing cpu hotplug operation.
> +	 * active_writer makes get_online_cpus()/put_online_cpus() are allowd
> +	 * to be nested in cpu_hotplug_begin()/cpu_hotplug_done().
> +	 *
> +	 * Thus, get_online_cpus()/put_online_cpus() can be called in
> +	 * CPU notifiers.
>  	 */
> -	int refcount;
> +	struct task_struct *active_writer;
> +	struct rw_semaphore rwlock;
>  } cpu_hotplug;
> 
>  void __init cpu_hotplug_init(void)
>  {
>  	cpu_hotplug.active_writer = NULL;
> -	mutex_init(&cpu_hotplug.lock);
> -	cpu_hotplug.refcount = 0;
> +	init_rwsem(&cpu_hotplug.rwlock);
>  }
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> @@ -50,9 +52,7 @@ void get_online_cpus(void)
>  	might_sleep();
>  	if (cpu_hotplug.active_writer == current)
>  		return;
> -	mutex_lock(&cpu_hotplug.lock);
> -	cpu_hotplug.refcount++;
> -	mutex_unlock(&cpu_hotplug.lock);
> +	down_read(&cpu_hotplug.rwlock);
> 
>  }
>  EXPORT_SYMBOL_GPL(get_online_cpus);
> @@ -61,10 +61,7 @@ void put_online_cpus(void)
>  {
>  	if (cpu_hotplug.active_writer == current)
>  		return;
> -	mutex_lock(&cpu_hotplug.lock);
> -	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
> -		wake_up_process(cpu_hotplug.active_writer);
> -	mutex_unlock(&cpu_hotplug.lock);
> +	up_read(&cpu_hotplug.rwlock);
> 
>  }
>  EXPORT_SYMBOL_GPL(put_online_cpus);
> @@ -86,45 +83,25 @@ void cpu_maps_update_done(void)
>  }
> 
>  /*
> - * This ensures that the hotplug operation can begin only when the
> - * refcount goes to zero.
> + * This ensures that the hotplug operation can begin only when
> + * there is no reader.
>   *
>   * Note that during a cpu-hotplug operation, the new readers, if any,
> - * will be blocked by the cpu_hotplug.lock
> + * will be blocked by the cpu_hotplug.rwlock
>   *
>   * Since cpu_hotplug_begin() is always called after invoking
>   * cpu_maps_update_begin(), we can be sure that only one writer is active.
> - *
> - * Note that theoretically, there is a possibility of a livelock:
> - * - Refcount goes to zero, last reader wakes up the sleeping
> - *   writer.
> - * - Last reader unlocks the cpu_hotplug.lock.
> - * - A new reader arrives at this moment, bumps up the refcount.
> - * - The writer acquires the cpu_hotplug.lock finds the refcount
> - *   non zero and goes to sleep again.
> - *
> - * However, this is very difficult to achieve in practice since
> - * get_online_cpus() not an api which is called all that often.
> - *
>   */
>  static void cpu_hotplug_begin(void)
>  {
> +	down_write(&cpu_hotplug.rwlock);
>  	cpu_hotplug.active_writer = current;
> -
> -	for (;;) {
> -		mutex_lock(&cpu_hotplug.lock);
> -		if (likely(!cpu_hotplug.refcount))
> -			break;
> -		__set_current_state(TASK_UNINTERRUPTIBLE);
> -		mutex_unlock(&cpu_hotplug.lock);
> -		schedule();
> -	}
>  }
> 
>  static void cpu_hotplug_done(void)
>  {
>  	cpu_hotplug.active_writer = NULL;
> -	mutex_unlock(&cpu_hotplug.lock);
> +	up_write(&cpu_hotplug.rwlock);
>  }
>  /* Need to know about CPUs going up/down? */
>  int __ref register_cpu_notifier(struct notifier_block *nb)
> 
> 
