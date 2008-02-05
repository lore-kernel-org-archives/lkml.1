Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbYBEGcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbYBEGcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYBEGco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:32:44 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:48303 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYBEGcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:32:43 -0500
Message-ID: <47A802FF.3090807@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2008 12:02:31 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] 2.6.24-git6 soft lockup detected while running libhugetlbfs
References: <47A01C30.7020309@linux.vnet.ibm.com> <20080130165947.GA6336@elte.hu> <47A0AE4E.5090400@linux.vnet.ibm.com> <20080201143302.GC26232@elte.hu>
In-Reply-To: <20080201143302.GC26232@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> The CONFIG_NO_HZ is not set and the system seems not be truly locked 
>> up ,btw wc -l of the softlockup messages is around 108 times, while 
>> running the libhugetlbfs only and this is reproducible with the 
>> 2.6.24-git7 also.
> 
> Peter just fixed a handful of bugs in this area - does the patch below 
> help?
> 
> 	Ingo
> 
> ------------------>
> Subject: debug: softlockup looping fix
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Rafael J. Wysocki reported weird, multi-seconds delays during
> suspend/resume and bisected it back to:
> 
>   commit 82a1fcb90287052aabfa235e7ffc693ea003fe69
>   Author: Ingo Molnar <mingo@elte.hu>
>   Date:   Fri Jan 25 21:08:02 2008 +0100
> 
>       softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks
> 
> fix it:
> 
>  - restore the old wakeup mechanism
>  - fix break usage in do_each_thread() { } while_each_thread().
>  - fix the hotplug switch stmt, a fall-through case was broken.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/softlockup.c |   30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> Index: linux/kernel/softlockup.c
> ===================================================================
> --- linux.orig/kernel/softlockup.c
> +++ linux/kernel/softlockup.c
> @@ -101,6 +101,10 @@ void softlockup_tick(void)
> 
>  	now = get_timestamp(this_cpu);
> 
> +	/* Wake up the high-prio watchdog task every second: */
> +	if (now > (touch_timestamp + 1))
> +		wake_up_process(per_cpu(watchdog_task, this_cpu));
> +
>  	/* Warn about unreasonable delays: */
>  	if (now <= (touch_timestamp + softlockup_thresh))
>  		return;
> @@ -191,11 +195,11 @@ static void check_hung_uninterruptible_t
>  	read_lock(&tasklist_lock);
>  	do_each_thread(g, t) {
>  		if (!--max_count)
> -			break;
> +			goto unlock;
>  		if (t->state & TASK_UNINTERRUPTIBLE)
>  			check_hung_task(t, now);
>  	} while_each_thread(g, t);
> -
> + unlock:
>  	read_unlock(&tasklist_lock);
>  }
> 
> @@ -218,14 +222,19 @@ static int watchdog(void *__bind_cpu)
>  	 * debug-printout triggers in softlockup_tick().
>  	 */
>  	while (!kthread_should_stop()) {
> +		set_current_state(TASK_INTERRUPTIBLE);
>  		touch_softlockup_watchdog();
> -		msleep_interruptible(10000);
> +		schedule();
> +
> +		if (kthread_should_stop())
> +			break;
> 
>  		if (this_cpu != check_cpu)
>  			continue;
> 
>  		if (sysctl_hung_task_timeout_secs)
>  			check_hung_uninterruptible_tasks(this_cpu);
> +
>  	}
> 
>  	return 0;
> @@ -259,13 +268,6 @@ cpu_callback(struct notifier_block *nfb,
>  		wake_up_process(per_cpu(watchdog_task, hotcpu));
>  		break;
>  #ifdef CONFIG_HOTPLUG_CPU
> -	case CPU_UP_CANCELED:
> -	case CPU_UP_CANCELED_FROZEN:
> -		if (!per_cpu(watchdog_task, hotcpu))
> -			break;
> -		/* Unbind so it can run.  Fall thru. */
> -		kthread_bind(per_cpu(watchdog_task, hotcpu),
> -			     any_online_cpu(cpu_online_map));
>  	case CPU_DOWN_PREPARE:
>  	case CPU_DOWN_PREPARE_FROZEN:
>  		if (hotcpu == check_cpu) {
> @@ -275,6 +277,14 @@ cpu_callback(struct notifier_block *nfb,
>  			check_cpu = any_online_cpu(temp_cpu_online_map);
>  		}
>  		break;
> +
> +	case CPU_UP_CANCELED:
> +	case CPU_UP_CANCELED_FROZEN:
> +		if (!per_cpu(watchdog_task, hotcpu))
> +			break;
> +		/* Unbind so it can run.  Fall thru. */
> +		kthread_bind(per_cpu(watchdog_task, hotcpu),
> +			     any_online_cpu(cpu_online_map));
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
>  		p = per_cpu(watchdog_task, hotcpu);
Hi Ingo,

Thanks for the patch. The softlockup is not always reproducible, I tried six rounds without the patch to reproduce
the softlockup but was not able to. This is not seen after the 2.6.24-git8 and above, hope because of peters patch 
is already there in in the git(s).

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
