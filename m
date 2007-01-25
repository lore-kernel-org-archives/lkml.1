Return-Path: <linux-kernel-owner+w=401wt.eu-S965716AbXAYJF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965716AbXAYJF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 04:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965719AbXAYJF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 04:05:26 -0500
Received: from oola.is.scarlet.be ([193.74.71.23]:46879 "EHLO
	oola.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965716AbXAYJFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 04:05:24 -0500
Message-ID: <45B872BB.1010703@joow.be>
Date: Thu, 25 Jan 2007 06:04:59 -0300
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lee Revell <rlrevell@joe-job.com>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: status of: tasklet_unlock_wait() causes soft lockup with -rt
 and ieee1394	audio
References: <1152371924.4736.169.camel@mindpipe> <45B3F7A5.2050708@joow.be> <20070122091035.GA11821@elte.hu>
In-Reply-To: <20070122091035.GA11821@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-scarlet.be-Metrics: oola 20001; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Pieter Palmers <pieterp@joow.be> wrote:
> 
>> Dear all,
>>
>> What is the status with respect to this problem? I see that in the 
>> current -rt patch the problematic code piece is different. I 
>> personally haven't tried to reproduce this myself on a more recent 
>> kernel, but I just got a report from one of our users who experienced 
>> the same problem with 2.6.19-rt15 and RT preemption (desktop 
>> preemption works fine).
>>
>> Should the latest -rt patches be fixed with respect to this issue? If 
>> so I'll try and test them, otherwise I omit the effort.
> 
> it's not fixed yet. Could you try the patch below?

Ingo,

I couldn't get my laptop booting on 2.6.20-rc3 or 2.6.19, but I passed 
the patch on to one of our users and he reports that it is working (on 
2.6.19-rt15).

Thanks,

Pieter

> 
> 	Ingo
> 
> ---
>  include/linux/interrupt.h |    6 ++----
>  kernel/softirq.c          |   20 ++++++++++++++++++++
>  2 files changed, 22 insertions(+), 4 deletions(-)
> 
> Index: linux/include/linux/interrupt.h
> ===================================================================
> --- linux.orig/include/linux/interrupt.h
> +++ linux/include/linux/interrupt.h
> @@ -328,10 +328,8 @@ static inline void tasklet_unlock(struct
>  	clear_bit(TASKLET_STATE_RUN, &(t)->state);
>  }
>  
> -static inline void tasklet_unlock_wait(struct tasklet_struct *t)
> -{
> -	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
> -}
> +extern void tasklet_unlock_wait(struct tasklet_struct *t);
> +
>  #else
>  # define tasklet_trylock(t)		1
>  # define tasklet_tryunlock(t)		1
> Index: linux/kernel/softirq.c
> ===================================================================
> --- linux.orig/kernel/softirq.c
> +++ linux/kernel/softirq.c
> @@ -20,6 +20,7 @@
>  #include <linux/mm.h>
>  #include <linux/notifier.h>
>  #include <linux/percpu.h>
> +#include <linux/delay.h>
>  #include <linux/cpu.h>
>  #include <linux/kthread.h>
>  #include <linux/rcupdate.h>
> @@ -656,6 +657,25 @@ void __init softirq_init(void)
>  	open_softirq(HI_SOFTIRQ, tasklet_hi_action, NULL);
>  }
>  
> +#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
> +
> +void tasklet_unlock_wait(struct tasklet_struct *t)
> +{
> +	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) {
> +		/*
> +		 * Hack for now to avoid this busy-loop:
> +		 */
> +#ifdef CONFIG_PREEMPT_RT
> +		msleep(1);
> +#else
> +		barrier();
> +#endif
> +	}
> +}
> +EXPORT_SYMBOL(tasklet_unlock_wait);
> +
> +#endif
> +
>  static int ksoftirqd(void * __data)
>  {
>  	struct sched_param param = { .sched_priority = MAX_USER_RT_PRIO/2 };
> 

