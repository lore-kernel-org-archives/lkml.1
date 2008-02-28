Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYB1RdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYB1RdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYB1RdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:33:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33626 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYB1RdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:33:12 -0500
X-IronPort-AV: E=McAfee;i="5200,2160,5240"; a="978317"
Message-ID: <47C6F056.10503@qualcomm.com>
Date: Thu, 28 Feb 2008 09:33:10 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
References: <20080227222103.673194000@chello.nl>	 <47C5F470.7000802@qualcomm.com> <1204193987.6243.29.camel@lappy>
In-Reply-To: <1204193987.6243.29.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2008-02-27 at 15:38 -0800, Max Krasnyanskiy wrote:
>> Peter Zijlstra wrote:
>>> My vision on the direction we should take wrt cpu isolation.
>> General impressions:
>> - "cpu_system_map" is %100 identical to the "~cpu_isolated_map" as in my 
>> patches. It's updated from different place but functionally wise it's very 
>> much the same. I guess you did not like the 'isolated' name ;-). As I 
>> mentioned before I'm not hung up on the name so it's cool :).
> 
> Ah, but you miss that cpu_system_map doesn't do the one thing the
> cpu_isolated_map ever did, prevent sched_domains from forming on those
> cpus.
> 
> Which is a major point.
Did you see my reply on how to support "RT balancer" with cpu_isolated_map ?
Anyway, my point was that you could've just told me something like:
    "lets rename cpu_isolated_map and invert it"
That's is it. The gist of the idea is exactly the same. There is a bitmap that 
tells various subsystems what cpus can be used for the kernel activities.

>> - Updating cpu_system_map from cpusets
>> There are a couple of things that I do not like about this approach:
>> 1. We lost the ability to isolate CPUs at boot. Which means slower boot times 
>> for me (ie before I can start my apps I need to create cpuset, etc). Not a big 
>> deal, I can live with it.
> 
> I'm sure those few lines in rc.local won't grow your boot time by a
> significant amount of time.
> 
> That said, we should look into a replacement for the boot time parameter
> (if only to decide not to do it) because of backward compatibility.
As I said I can live with it.

>> 2. We now need another notification mechanism to propagate the updates to the 
>> cpu_system_map. That by itself is not a big deal. The big deal is that now we 
>> need to basically audit the kernel and make sure that everything affected must
>> have proper notifier and react to the mask changes.
>> For example your current patch does not move the timers and I do not think it 
>> makes sense to go and add notifier for the timers. I think the better approach 
>> is to use CPU hotplug here. ie Enforce the rule that cpu_system_map is updated 
>>   only when CPU is off-line.
>> By bringing CPU down first we get a lot of features for free. All the kernel 
>> threads, timers, softirqs, HW irqs, workqueues, etc are properly 
>> terminated/moved/canceled/etc. This gives us a very clean state when we bring 
>> the CPU back online with "system" bit cleared (or "isolated" bit set like in 
>> my patches). I do not see a good reason for reimplementing that functionality 
>> via system_map notifiers.
> 
> I'm not convinced cpu hotplug notifiers are the right thing here. Sure
> we could easily iterate the old and new system map and call the matching
> cpu hotplug notifiers, but they seem overly complex to me.
> 
> The audit would be a good idea anyway. If we do indeed end up with a 1:1
> mapping of whatever cpu hotplug does, then well, perhaps you're right.
I was not talking about calling notifiers directly. We can literally bring the 
CPU down. Just like echo 0 > /sys/devices/system/cpu/cpuN/online does.

>> I'll comment more on the individual patches.
>>
>>> Next on the list would be figuring out a nice solution to the workqueue
>>> flush issue.
>> Do not forget the "stop machine", or more specifically module loading/unloading.
> 
> No, the full stop machine thing, there are more interesting users than
> module loading. But I'm not too interested in solving this particular
> problem atm, I have too much on my plate as it is.
I was not suggesting that it's up to you to solve it. You made it sounds like 
your patches provide complete solution, just need to fix the workqueues. I was 
merely pointing out that there is also stop machine that needs fixing.

btw You did not comment about the fact that your patch does not move timers.
I was trying it out last night. It's definitely not ready yet.

Max
