Return-Path: <linux-kernel-owner+w=401wt.eu-S1757876AbYGVTdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876AbYGVTdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbYGVTcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:32:22 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45492 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519AbYGVTcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:32:20 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5344"; a="4789290"
Message-ID: <488635B3.2050606@qualcomm.com>
Date: Tue, 22 Jul 2008 12:32:03 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
       dmitry.adamushko@gmail.com, torvalds@linux-foundation.org, pj@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpu hotplug,	sched:Introduce	cpu_active_map	and	redoscheddomainmanagment
 (take 2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com> <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com> <487E7B6C.BA47.005A.0@novell.com> <487EF1E9.2040101@qualcomm.com> <487EFB71.BA47.005A.0@novell.com> <487F9509.9050802@qualcomm.com> <487F6972.BA47.005A.0@novell.com> <1216382024.28405.26.camel@twins> <488052D5.BA47.005A.0@novell.com> <48856BA9.6050609@qualcomm.com> <4885E952.8020708@novell.com>
In-Reply-To: <4885E952.8020708@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Max Krasnyansky wrote:
>> Greg, correct me if I'm wrong but we seem to have exact same issue 
>> with the rq->rq->online map. Lets take "cpu going down" for
>> example. We're clearing rq->rd->online bit on DYING event, but
>> nothing AFAICS prevents another cpu calling
>> rebuild_sched_domains()->partition_sched_domains() in the middle of
>> the hotplug sequence. partition_sched_domains() will happily reset
>> rd->rq->online mask and things will fail. I'm talking about this
>> path
>>
>> __build_sched_domains() -> cpu_attach_domain() -> rq_attach_root()
>>     ...
>>     cpu_set(rq->cpu, rd->span);
>>     if (cpu_isset(rq->cpu, cpu_online_map))
>>         set_rq_online(rq);
>>     ...
>>
>>   
> 
> I think you are right, but wouldn't s/online/active above fix that as 
> well?  The active_map didnt exist at the time that code went in 
> initially ;)

Actually after a bit more thinking :) I realized that the scenario I 
explained above cannot happen because partition_sched_domains() must be 
called under get_online_cpus() and the set_rq_online() happens in the 
hotplug writer's path (ie under cpu_hotplug.lock). Since I unified all 
the other domain rebuild paths (arch_reinit_sched_domains, etc) we 
should be safe. But it again means we'd rely on those intricate 
dependencies that we wanted to avoid with the cpu_active_map. Also 
cpusets might still need to rebuild the domains in the hotplug writer's 
path.
So it's better to fix it once and for all :)

>> -- 
>>
>> btw Why didn't we convert sched*.c to use rq->rd->online when it was
>> introduced ? ie Instead of using cpu_online_map directly.
>>   
> I think things were converted where they made sense to convert.  But we 
> also had a different goal at that time, so perhaps something was 
> missed.  If you think something else should be converted, please point 
> it out.
Ok. I'll keep an eye on it.

> In the meantime, I would suggest we consider this patch on top of yours 
> (applies to tip/sched/devel):
> 
> ----------------------
> 
> sched: Fully integrate cpus_active_map and root-domain code
>   Signed-off-by: Gregory Haskins <ghaskins@novell.com>

Ack.
The only thing I'm a bit unsure of is the error scenarios in the cpu 
hotplug event sequence. online_map is not cleared when something in the 
notifier chain fails, but active_map is.

Max
