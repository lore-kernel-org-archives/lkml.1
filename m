Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbYBFRxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbYBFRxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbYBFRxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:53:40 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:34506 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYBFRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:53:39 -0500
Message-ID: <47A9F3E4.6040707@qualcomm.com>
Date: Wed, 06 Feb 2008 09:52:36 -0800
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: RT scheduler config, suggestions and questions
References: <47A8F328.5070107@qualcomm.com> <1202279815.19243.34.camel@lappy>
In-Reply-To: <1202279815.19243.34.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-02-05 at 15:37 -0800, Max Krasnyanskiy wrote:
>> Folks,
>>
>> I just realized that in latest Linus' tree following sysctls are under SCHED_DEBUG:
>> 	sched_rt_period
>> 	sched_rt_ratio
>>
>> I do not believe that is correct. I know that we do not want to expose scheduler knobs
>> in general but theses are not the heuristic kind of knobs. There is no way the scheduler 
>> can magically figure out what the correct setting should be here.
> 
> Yeah, since fixed.
Super. I guess it's not in mainline yet. Or it wasn't yesterday.
 
>> Also shouldn't those new RT features that recently went be configurable and _disabled_ 
>> by default ? For example "RT watchdog" and "RT throttling" actually seem very questionable. 
>> SCHED_FIFO is clearly defined as
>> "
>>   A SCHED_FIFO process runs until either it is blocked by an I/O request, it is preempted 
>>   by a higher priority process, or it calls sched_yield(2).
>> "
> 
> The watchdog is disabled by default, the bandwidth is .95s every 1s,
> which is mainly a safe-guard against run-away real-time tasks. As long
> as real-time usage stays within those limits nothing happens. If you
> don't like it set sched_rt_runtime [*] to -1.
Oh. From looking at the code I assumed I need to set sched_rt_ratio to 65536.
I guess you changed things around a bit. I'll look at the latest changes.

>> Both the watchdog and the throttling are clearly braking that rule. I think it's good to have 
>> those features but not enabled by default and certainly not with sysctls that disable them 
>> hidden under debugging.
>> How about this:
>> - We introduce Kconfig options for them ?
> 
> I don't see why this would be needed.
Reduces code size and RT scheduler complexity for the cases when these features are not required.
For example my preference would for RT scheduler to be as lean as possible to avoid any kind of 
overhead and cache pollution. I know both watchdog and throttling end up being a single if() when
disabled via sysctl, but it all adds up.
 
>> - Expose all rt sysctls outside of #ifdef DEBUG
> 
> Already did this somewhere along the line.
> 
>> btw I can see "watchdog" being very useful to catch hard-RT tasks that exceed the deadline.
>> But's it gotta be per thread.
> 
> It is.
> 
>> Single setting per user is not enough. Unless a use has a single RT task.
> 
> ?
Currently it's per process. Most RT apps will most likely have several RT threads.

Max
