Return-Path: <linux-kernel-owner+w=401wt.eu-S1759609AbYGPVpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609AbYGPVpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYGPVpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:45:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2052 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbYGPVpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:45:05 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5340"; a="4606436"
Message-ID: <487E6BD7.3020006@qualcomm.com>
Date: Wed, 16 Jul 2008 14:44:55 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, dmitry.adamushko@gmail.com,
       torvalds@linux-foundation.org, pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and	redo
 sched domain managment (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com> <487DAD86.BA47.005A.0@novell.com>
In-Reply-To: <487DAD86.BA47.005A.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>>>> On Tue, Jul 15, 2008 at  7:43 AM, in message
> <1216122229-4865-1-git-send-email-maxk@qualcomm.com>, Max Krasnyansky
> <maxk@qualcomm.com> wrote: 
> 
>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>> index 47ceac9..5166080 100644
>> --- a/kernel/sched_rt.c
>> +++ b/kernel/sched_rt.c
>> @@ -922,6 +922,13 @@ static int find_lowest_rq(struct task_struct *task)
>>  		return -1; /* No targets found */
>>  
>>  	/*
>> +	 * Only consider CPUs that are usable for migration.
>> +	 * I guess we might want to change cpupri_find() to ignore those
>> +	 * in the first place.
>> +	 */ 
>> +	cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
>> +
>> +	/*
>>  	 * At this point we have built a mask of cpus representing the
>>  	 * lowest priority tasks in the system.  Now we want to elect
>>  	 * the best one based on our affinity and topology.
> 
> Hi Max,
>   Its still early in the morning, and I havent had my coffee yet, so what I am about to
> say may be totally bogus ;)
> 
> ..but, I am not sure we need to do this mask here.  If the hotcpu_notifiier is still
> running (and it appears that it is) the runqueue that is taken offline will be removed
> from cpupri as well.
> 
> Or perhaps I am misunderstanding the intention of "active" verses "online".  If I
> understand correctly, active and online mean more or less the same thing, but
> splitting it out like this allows us  to skip rebuilding the domains on every hotplug.
> Is that correct?
Basically with the cpu_active_map we're saying that sched domain masks may
contain cpus that are going down, and the scheduler is supposed to ignore
those (by checking cpu_active_map). ie The idea was to simplify cpu hotplug
handling. My impression was that cpupri updates are similar to the sched
domains in that respect.

> Assuming that the above is true, and assuming that the hotcpu_notifier is
> still invoked when the online status changes, cpupri will be properly updated
> to exclude the offline core.  That will save an extra cpus_and (which the big-iron
> guys will be happy about ;)
Ah, now I see what you mean by the hotplug handler is still running. You're
talking about set_rq_online()/set_rq_offline() calls from migration_call().
Yes did not know what they were for and did not touch that path.
btw I'm definitely with you on the cpus_and() thing. When I added it in both
balancers I thought that it quite an overhead on bigger boxes.

So I'm not sure what the best way to handle this. If we say we're relying on
hotplug event sequence to ensure that rt balancer state is consistent then we
kind of back to square one. ie Might as do the same for the sched domains.

I guess we could update cpupri state when we update cpu_active_map. That way
the two will be synced up and we do not have to "and" them in the fast path.
Any other thoughts ?

Max




