Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbYA1S4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbYA1S4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYA1Sz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:55:59 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:59866 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYA1Sz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:55:58 -0500
Message-ID: <479E24FC.9060606@qualcomm.com>
Date: Mon, 28 Jan 2008 10:54:52 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <rostedt@goodmis.org>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, srostedt@redhat.com,
       ghaskins@novell.com
Subject: Re: [CPUISOL] CPU isolation extensions
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>	 <1201511305.6149.30.camel@lappy> <20080128085910.7d38e9f5.pj@sgi.com>	 <20080128163450.GC12598@goodmis.org> <1201538690.28547.23.camel@lappy>
In-Reply-To: <1201538690.28547.23.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-01-28 at 11:34 -0500, Steven Rostedt wrote:
>> On Mon, Jan 28, 2008 at 08:59:10AM -0600, Paul Jackson wrote:
>>> Thanks for the CC, Peter.
>> Thanks from me too.
>>
>>> Max wrote:
>>>> We've had scheduler support for CPU isolation ever since O(1) scheduler went it. 
>>>> I'd like to extend it further to avoid kernel activity on those CPUs as much as possible.
>>> I recently added the per-cpuset flag 'sched_load_balance' for some
>>> other realtime folks, so that they can disable the kernel scheduler
>>> load balancing on isolated CPUs.  It essentially allows for dynamic
>>> control of which CPUs are isolated by the scheduler, using the cpuset
>>> hierarchy, rather than enhancing the 'isolated_cpus' mask.   That
>>> 'isolated_cpus' mask remained a minimal kernel boottime parameter.
>>> I believe this went to Linus's tree about Oct 2007.
>>>
>>> It looks like you have three additional tweaks for realtime in this
>>> patch set, with your patches:
>>>
>>>   [PATCH] [CPUISOL] Do not route IRQs to the CPUs isolated at boot
>> I didn't know we still routed IRQs to isolated CPUs. I guess I need to
>> look deeper into the code on this one. But I agree that isolated CPUs
>> should not have IRQs routed to them.
> 
> While I agree with this in principle, I'm not sure flat out denying all
> IRQs to these cpus is a good option. What about the case where we want
> to service just this one specific IRQ on this CPU and no others?
> 
> Can't this be done by userspace irq routing as used by irqbalanced?
Peter, I think you missed the point of this patch. It's just a convenience feature.
It simply excludes isolated CPUs from IRQ smp affinity masks. That's all. What did you
mean by "flat out denying all IRQs to these cpus" ? IRQs can still be routed to them 
by writing to /proc/irq/N/smp_affinity.

Also, this happens naturally when we bring a CPU off-line and then bring it back online.
ie When CPU comes back online it's excluded from the IRQ smp_affinity masks even without
my patch.
 
>>>   [PATCH] [CPUISOL] Support for workqueue isolation
>> The thing about workqueues is that they should only be woken on a CPU if
>> something on that CPU accessed them. IOW, the workqueue on a CPU handles
>> work that was called by something on that CPU. Which means that
>> something that high prio task did triggered a workqueue to do some work.
>> But this can also be triggered by interrupts, so by keeping interrupts
>> off the CPU no workqueue should be activated.
> 
> Quite so, if nobody uses it, there is no harm in having them around. If
> they are used, its by someone already allowed on the cpu.

No no no. I just replied to Steven about that. The problem is that things like NFS and 
friends expect _all_ their workqueue threads to report back when they do certain things 
like flushing buffers and stuff. The reason I added this is because my machines were 
getting stuck because CPU0 was waiting for CPU1 to run NFS work queue threads even though 
no IRQs, softirqs or other things are running on it.
 
>>>   [PATCH] [CPUISOL] Isolated CPUs should be ignored by the "stop machine"
>> This I find very dangerous. We are making an assumption that tasks on an
>> isolated CPU wont be doing things that stopmachine requires. What stops
>> a task on an isolated CPU from calling something into the kernel that
>> stop_machine requires to halt?
> 
> Very dangerous indeed!
Please see my reply to Steven. I agree it's somewhat dangerous. What we could do is make it
configurable with a big fat warning. In other words I'd rather have an option than just says
"do not use dynamic module loading" on those systems.

Max
