Return-Path: <linux-kernel-owner+w=401wt.eu-S934822AbZLPIZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934822AbZLPIZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934791AbZLPIZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:25:08 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:51388 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934777AbZLPIZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:25:01 -0500
Message-ID: <4B289955.2010705@in.ibm.com>
Date: Wed, 16 Dec 2009 13:54:53 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Next] CPU Hotplug test failures on powerpc
References: <4B2224C7.1020908@in.ibm.com> <7b6bb4a50912152225p4f5dde13re83c439407c16eaf@mail.gmail.com> <4B288131.2050306@in.ibm.com> <7b6bb4a50912152245v61a7f1ebgb41f4857134f3476@mail.gmail.com> <4B288413.2070704@in.ibm.com> <1260947890.8023.1281.camel@laptop> <7b6bb4a50912152357m75aea5dfl6fe063d716517baf@mail.gmail.com>
In-Reply-To: <7b6bb4a50912152357m75aea5dfl6fe063d716517baf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng wrote:
> Could follow be possible?  We know there's cpu 0 and cpu 1,
>
> offline cpu1 > done
> offline cpu0 > false
>
> consider this in cpu_down code,
>
>
> int __ref cpu_down(unsigned int cpu)
> {
> <snip>
>         set_cpu_active(cpu, false); // here, we set cpu 0 to inactive
>
>         synchronize_sched();
>
>         err = _cpu_down(cpu, 0);
> out:
> <snip>
> }
>
> Then in _cpu_down code:
>
> static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
> {
> <snip>
>         if (num_online_cpus() == 1)        // if we're trying to
> offline cpu0, num_online_cpus will be 1
>                 return -EBUSY;                    // after return back
> to cpu_down, we didn't change cpu 0 back to active
>
>         if (!cpu_online(cpu))
>                 return -EINVAL;
>
>         if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
>                 return -ENOMEM;
> <snip>
> }
>
> Then cpu 0 is not active, but online, then we try to offline cpu1, .......
> This can not be exposed because x86 does not have
> /sys/devices/system/cpu0/online.
> I guess following patch fixes this bug.
>   
Just tested this one on the POWER box and the test passed.
I did not observe the hang.

Thanks
-Sachin

> ---
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 291ac58..21ddace 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -199,14 +199,18 @@ static int __ref _cpu_down(unsigned int cpu, int
> tasks_frozen)
>                 .hcpu = hcpu,
>         };
>
> -       if (num_online_cpus() == 1)
> +       if (num_online_cpus() == 1) {
> +               set_cpu_active(cpu, true);
>                 return -EBUSY;
> +       }
>
>         if (!cpu_online(cpu))
>                 return -EINVAL;
>
> -       if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
> +       if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL)) {
> +               set_cpu_active(cpu, true);
>                 return -ENOMEM;
> +       }
>
>         cpu_hotplug_begin();
>         err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
>
>
>   
>> Unless of course, I messed up, which appears to be rather likely given
>> these problems ;-)
>>
>>
>>     
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

