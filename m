Return-Path: <linux-kernel-owner+w=401wt.eu-S1761484AbYBZCiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484AbYBZCiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 21:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbYBZChx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 21:37:53 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45588 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075AbYBZChv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 21:37:51 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5237"; a="811637"
Message-ID: <47C37B7B.6050405@qualcomm.com>
Date: Mon, 25 Feb 2008 18:37:47 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: kosaki.motohiro@jp.fujitsu.com, alan@lxorguk.ukuu.org.uk, adilger@sun.com,
       akpm@linux-foundation.org, daniel.spang@gmail.com, mingo@elte.hu,
       jonathan@jonmasters.org, marcelo@kvack.org, menage@google.com,
       pavel@ucw.cz, a.p.zijlstra@chello.nl, riel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Tiny cpusets -- cpusets for small systems?
References: <20080223060911.e1d13cc1.pj@sgi.com>	<47C0EA62.4000807@qualcomm.com> <20080225200538.e06beb38.pj@sgi.com>
In-Reply-To: <20080225200538.e06beb38.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
>> So. I see cpusets as a higher level API/mechanism and cpu_isolated_map as lower
>> level mechanism that actually makes kernel aware of what's isolated what's not.
>> Kind of like sched domain/cpuset relationship. ie cpusets affect sched domains
>> but scheduler does not use cpusets directly.
> 
> One could use cpusets to control the setting of cpu_isolated_map,
> separate from the code such as your select_irq_affinity() that
> uses it.
Yes. That's what I proposed too. In one of the CPU isolation threads with 
Peter. The only issue is that you need to simulate CPU_DOWN hotplug even in 
order to cleanup what's already running on those CPUs.

>> In a foreseeable future 2-8 cores will be most common configuration.
>> Do you think that cpusets are needed/useful for those machines ?
>> The reason I'm asking is because given the restrictions you mentioned
>> above it seems that you might as well just do
>> 	taskset -c 1,2,3 app1
>> 	taskset -c 3,4,5 app2 
> 
> People tend to manage the CPU and memory placement of the threads
> and processes within a single co-operating job using taskset
> (sched_setaffinity) and numactl (mbind, set_mempolicy.)
> 
> They tend to manage the placement of multiple unrelated jobs onto
> a single system, whether on separate or shared CPUs and nodes,
> using cpusets.
 >
> Something like cpu_isolated_map looks to me like a system-wide
> mechanism, which should, like sched_domains, be managed system-wide.
> Managing it with a mechanism that encourages each thread to update
> it directly, as if that thread owned the system, will break down,
> resulting in conflicting updates, as multiple, insufficiently
> co-operating threads issue conflicting settings.
I'm not sure how to interpret that. I think you might have mixed a couple of 
things I asked about in one reply ;-).
The question was that given the restrictions you talked about when you 
explained tiny-cpusets functionality I asked how much one gains from using 
them compared to the taskset/numactl. ie On the machines with 2-8 cores it's 
fairly easy to manage cpus with simple affinity masks.

The second part of your reply seems to imply that I somehow made you think 
that I suggested that cpu_isolated_map is managed per thread. That is of 
course not the case. It's definitely a system-wide mechanism and individual 
threads have nothing to do with it.
btw I just re-read my prev reply. I definitely did not say anything about 
threads managing cpu_isolated_map :).

>> Stuff that I'm working on this days (wireless basestations) is designed
>> with the  following model:
>> 	cpuN - runs soft-RT networking and management code
>> 	cpuN+1 to cpuN+x - are used as dedicated engines
>> ie Simplest example would be
>> 	cpu0 - runs IP, L2 and control plane
>> 	cpu1 - runs hard-RT MAC 
>>
>> So if CPU isolation is implemented on top of the cpusets what kind of API do 
>> you envision for such an app ?
> 
> That depends on what more API is needed.  Do we need to place
> irqs better ... cpusets might not be a natural for that use.
> Aren't irqs directed to specific CPUs, not to hierarchically
> nested subsets of CPUs.

You clipped the part where I elaborated. Which was:
>> So if CPU isolation is implemented on top of the cpusets what kind of API do 
>> you envision for such an app ? I mean currently cpusets seems to be mostly dealing
>> with entire processes, whereas in this case we're really dealing with the threads. 
>> ie Different threads of the same process require different policies, some must run
>> on isolated cpus some must not. I guess one could write a thread's pid into cpusets
>> fs but that's not very convenient. pthread_set_affinity() is exactly what's needed.
In other words how would an app place its individual threads into the 
different cpusets.
IRQ stuff is separate, like we said above cpusets could simply update 
cpu_isolated_map which would take care of IRQs. I was talking specifically 
about the thread management.

> Separate question:
>   Is it desired that the dedicated CPUs cpuN+1 ... cpuN+x even appear
>   as general purpose systems running a Linux kernel in your systems?
>   These dedicated engines seem more like intelligent devices to me,
>   such as disk controllers, which the kernel controls via device
>   drivers, not by loading itself on them too.
We still want to be able to run normal threads on them. Which means IPI, 
memory management, etc is still needed. So yes they better show up as normal 
CPUs :)
Also with dynamic isolation you can for example un-isolate a cpu when you're 
compiling stuff on the machine and then isolate it when you're running special 
app(s).

Max
