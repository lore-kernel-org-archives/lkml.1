Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbYA1SsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbYA1SsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYA1SsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:48:09 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:59180 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYA1SsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:48:08 -0500
Message-ID: <479E2305.3040408@qualcomm.com>
Date: Mon, 28 Jan 2008 10:46:29 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, srostedt@redhat.com,
       ghaskins@novell.com
Subject: Re: [CPUISOL] CPU isolation extensions
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com> <1201511305.6149.30.camel@lappy> <20080128085910.7d38e9f5.pj@sgi.com> <20080128163450.GC12598@goodmis.org>
In-Reply-To: <20080128163450.GC12598@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, Jan 28, 2008 at 08:59:10AM -0600, Paul Jackson wrote:
>> Thanks for the CC, Peter.
> 
> Thanks from me too.
> 
>> Max wrote:
>>> We've had scheduler support for CPU isolation ever since O(1) scheduler went it. 
>>> I'd like to extend it further to avoid kernel activity on those CPUs as much as possible.
>> I recently added the per-cpuset flag 'sched_load_balance' for some
>> other realtime folks, so that they can disable the kernel scheduler
>> load balancing on isolated CPUs.  It essentially allows for dynamic
>> control of which CPUs are isolated by the scheduler, using the cpuset
>> hierarchy, rather than enhancing the 'isolated_cpus' mask.   That
>> 'isolated_cpus' mask remained a minimal kernel boottime parameter.
>> I believe this went to Linus's tree about Oct 2007.
>>
>> It looks like you have three additional tweaks for realtime in this
>> patch set, with your patches:
>>
>>   [PATCH] [CPUISOL] Do not route IRQs to the CPUs isolated at boot
> 
> I didn't know we still routed IRQs to isolated CPUs. I guess I need to
> look deeper into the code on this one. But I agree that isolated CPUs
> should not have IRQs routed to them.
Also note that it's just a convenience feature. In other words it's not that with this patch
we'll never route IRQs to those CPUs. They can still be explicitly routed by writing to 
irq/N/smp_affitnity.

>>   [PATCH] [CPUISOL] Support for workqueue isolation
> 
> The thing about workqueues is that they should only be woken on a CPU if
> something on that CPU accessed them. IOW, the workqueue on a CPU handles
> work that was called by something on that CPU. Which means that
> something that high prio task did triggered a workqueue to do some work.
> But this can also be triggered by interrupts, so by keeping interrupts
> off the CPU no workqueue should be activated.
No no no. That's what I though too ;-). The problem is that things like NFS and friends
expect _all_ their workqueue threads to report back when they do certain things like
flushing buffers and stuff. The reason I added this is because my machines were getting
stuck because CPU0 was waiting for CPU1 to run NFS work queue threads even though no IRQs
or other things are running on it.
 
>>   [PATCH] [CPUISOL] Isolated CPUs should be ignored by the "stop machine"
> 
> This I find very dangerous. We are making an assumption that tasks on an
> isolated CPU wont be doing things that stopmachine requires. What stops
> a task on an isolated CPU from calling something into the kernel that
> stop_machine requires to halt?
I agree in general. The thing is though that stop machine just kills any kind of latency 
guaranties. Without the patch the machine just hangs waiting for the stop-machine to run
when module is inserted/removed. And running without dynamic module loading is not very 
practical on general purpose machines. So I'd rather have an option with a big red warning 
than no option at all :).

Thanx
Max
