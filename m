Return-Path: <linux-kernel-owner+w=401wt.eu-S932761AbYB2Uwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbYB2Uwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYB2UwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:52:23 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22712 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYB2UwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:52:22 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5242"; a="1038528"
Message-ID: <47C87084.3090208@qualcomm.com>
Date: Fri, 29 Feb 2008 12:52:20 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
References: <20080227222103.673194000@chello.nl> <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>
In-Reply-To: <20080229190223.GA17820@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>> @@ -174,11 +174,20 @@ struct irq_desc {
>>  #ifdef CONFIG_PROC_FS
>>  	struct proc_dir_entry	*dir;
>>  #endif
>> +#ifdef CONFIG_CPUSETS
>> +	struct cpuset		*cs;
>> +#endif
> 
> i like this approach - it makes irqs more resource-alike and attaches 
> them to a specific resource control group.
> 
> So if /cgroup/boot is changed to have less CPUs then the "default" irqs 
> move along with it.
> 
> but if an isolated RT domain has specific irqs attached to it (say the 
> IRQ of some high-speed data capture device), then the irqs would move 
> together with that domain.
> 
> irqs are no longer a bolted-upon concept, but more explicitly managed.
> 
> [ If you boot-test it and if Paul agrees with the general approach then
>   i could even apply it to sched-devel.git ;-) ]

Believe it or not but I like it too :).
Now we're talking different approach compared to the cpu_isolated_map since 
with this patch cpu_system_map is no longer needed.
I've been playing with latest sched-devel tree and while I think we'll endup 
adding a lot more code, doing it with the cpuset is definitely more flexible.
This way we can provide more fine grain control of what part of the "system" 
services are allowed to run on a cpuset. Rather that "catch all" system flag.

Current sched-devel tree does not provide complete isolation at this point. 
There are still many things here and there that need to be added/fixed.
Having finer control here helps.

One concern I have is that this API conflicts with /proc/irq/X/smp_affinity.
ie Setting smp_affinity manually will override affinity set by the cpuset.
In other words I think
	int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
now needs to make sure that cpumask does not have cpus that do not belong to 
the cpuset this irq belongs to. Just like sched_setaffinity() does for the tasks.

Max
