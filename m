Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYBDXUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYBDXUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbYBDXUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:20:33 -0500
Received: from numenor.qualcomm.com ([129.46.51.58]:43912 "EHLO
	numenor.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbYBDXUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:20:32 -0500
Message-ID: <47A79D73.7080402@qualcomm.com>
Date: Mon, 04 Feb 2008 15:19:15 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Re: Integrating cpusets and cpu isolation [was Re: [CPUISOL] CPU
 isolation extensions]
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>	<1201511305.6149.30.camel@lappy>	<20080128085910.7d38e9f5.pj@sgi.com>	<479E20DA.2080403@qualcomm.com>	<20080128130637.60db148e.pj@sgi.com>	<47A21C53.2010502@qualcomm.com>	<20080202001612.98354ff2.pj@sgi.com>	<47A557E3.4080206@qualcomm.com>	<20080203015315.6053d3dd.pj@sgi.com>	<47A6AABD.7080006@qualcomm.com> <20080204045429.7738c25c.pj@sgi.com>
In-Reply-To: <20080204045429.7738c25c.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> Looks like I failed to explain what I'm trying to achieve. So let me try again.
> 
> Well done.  I read through that, expecting to disagree or at least
> to not understand at some point, and got all the way through nodding
> my head in agreement.  Good.
> 
> Whether the earlier confusions were lack of clarity in the presentation,
> or lack of competence in my brain ... well guess I don't want to ask that
> question ;).
:)

> Well ... just one minor point:
> 
> Max wrote in reply to pj:
>>> The cpu_isolated_map is a file static variable known only within
>>> the kernel/sched.c file; this should not change.
>> I completely disagree. In fact I think all the cpu_xxx_map (online, present, isolated)
>> variables do not belong in the scheduler code. I'm thinking of submitting a patch that
>> factors them out into kernel/cpumask.c We already have cpumask.h.
> 
> Huh?  Why would you want to do that?
> 
>     For one thing, the map being discussed here, cpu_isolated_map,
>     is only used in sched.c, so why publish it wider?
> 
>     And for another thing, we already declare externs in cpumask.h for
>     the other, more widely used, cpu_*_map variables cpu_possible_map,
>     cpu_online_map, and cpu_present_map.
Well, to address #2 and #3 isolated map will need to be exported as well.
Those other maps do not really have much to do with the scheduler code.
That's why I think either kernel/cpumask.c or kernel/cpu.c is a better place for them.

> Other than that detail, we seem to be communicating and in agreement on
> your first item, isolating CPU scheduler load balancing.  Good.
> 
> On your other two items, irq and workqueue isolation, which I had
> suggested doing via cpuset sched_load_balance, I now agree that that
> wasn't a good idea.
> 
> I am still a little surprised at using isolation extensions to
> disable irqs on select CPUs; but others have thought far more about
> irqs than I have, so I'll be quiet.
Please note that we're not talking about completely disabling IRQs. We're talking about
not routing them to the isolated CPUs by default. It's still possible to explicitly reroute an IRQ
to the isolated CPU.
Why is this needed  ? It is actually very easy to explain. IRQs are the major source of latency 
and overhead. IRQ handlers themselves are mostly ok but they typically schedule soft irqs, work 
queues and timers on the same CPU where an IRQ is handled. In other words if an isolated CPU is 
receiving IRQs it's not really isolated, because it's running a whole bunch of different kernel 
code (ie we're talking latencies, cache usage, etc). 
If course some folks may want to explicitly route certain  IRQs to the isolated CPUs. For example 
if an app depends on the network stack it may make sense to route an IRQ from the NIC to the same 
CPU the app is running on.

Max
