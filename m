Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbXCYPUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbXCYPUL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 11:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbXCYPUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 11:20:11 -0400
Received: from comtv.ru ([217.10.32.17]:56124 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbXCYPUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 11:20:09 -0400
X-UCL: actv
Date: Sun, 25 Mar 2007 19:19:21 +0400 (MSD)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Con Kolivas <kernel@kolivas.org>
cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       zwane@infradead.org, ck list <ck@vds.kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] sched: accurate user accounting
In-Reply-To: <200703260108.22239.kernel@kolivas.org>
Message-ID: <Pine.LNX.4.64.0703251914110.9659@linmac.oyster.ru>
References: <200703251159.03616.kernel@kolivas.org> <200703260015.37535.kernel@kolivas.org>
 <Pine.LNX.4.64.0703251854430.8043@linmac.oyster.ru> <200703260108.22239.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, Con Kolivas wrote:

> On Monday 26 March 2007 00:57, malc wrote:
>> On Mon, 26 Mar 2007, Con Kolivas wrote:
>>> On Sunday 25 March 2007 23:06, malc wrote:
>>>> On Sun, 25 Mar 2007, Con Kolivas wrote:
>>>>> On Sunday 25 March 2007 21:46, Con Kolivas wrote:
>>>>>> On Sunday 25 March 2007 21:34, malc wrote:
>>>>>>> On Sun, 25 Mar 2007, Ingo Molnar wrote:
>>>>>>>> * Con Kolivas <kernel@kolivas.org> wrote:
>>>>>>>>> For an rsdl 0.33 patched kernel. Comments? Overhead worth it?
>>>>
>>>> [..snip..]
>>>>
>>>>> ---
>>>>> Currently we only do cpu accounting to userspace based on what is
>>>>> actually happening precisely on each tick. The accuracy of that
>>>>> accounting gets progressively worse the lower HZ is. As we already keep
>>>>> accounting of nanosecond resolution we can accurately track user cpu,
>>>>> nice cpu and idle cpu if we move the accounting to update_cpu_clock
>>>>> with a nanosecond cpu_usage_stat entry. This increases overhead
>>>>> slightly but avoids the problem of tick aliasing errors making
>>>>> accounting unreliable.
>>>>>
>>>>> Signed-off-by: Con Kolivas <kernel@kolivas.org>
>>>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>>>
>>>> [..snip..]
>>>>
>>>> Forgot to mention. Given that this goes into the kernel, shouldn't
>>>> Documentation/cpu-load.txt be amended/removed?
>>>
>>> Yes that's a good idea. Also there should be a sanity check because
>>> sometimes for some reason noone's been able to explain to me sched_clock
>>> gives a value which doesn't make sense (time appears to have gone
>>> backwards) and that will completely ruin the accounting from then on.
>>
>> After running this new kernel for a while i guess i have hit this issue:
>> http://www.boblycat.org/~malc/apc/bad-load.png
>>
>> Top and icewm's monitor do show incredibly huge load while in reality
>> nothing like that is really happening. Both ad-hoc and `/proc/stat' (idle)
>> show normal CPU utilization (7% since i'm doing some A/V stuff in the
>> background)
>
> Yes I'd say you hit the problem I described earlier. When playing with
> sched_clock() I found it gave some "interesting" results fairly infrequently.
> They could lead to ridiculous accounting mistakes.
>
> So before we go any further with this patch, can you try the following one and
> see if this simple sanity check is enough?

Sure (compiling the kernel now), too bad old axiom that testing can not
confirm absence of bugs holds.

I have one nit and one request from clarification. Question first (i
admit i haven't looked at the surroundings of the patch maybe things
would have been are self evident if i did):

What this patch amounts to is that the accounting logic is moved from
timer interrupt to the place where scheduler switches task (or something
to that effect)?

[..snip..]

>  * These are the 'tuning knobs' of the scheduler:
> @@ -3017,8 +3018,53 @@ EXPORT_PER_CPU_SYMBOL(kstat);
> static inline void
> update_cpu_clock(struct task_struct *p, struct rq *rq, unsigned long long now)
> {
> -	p->sched_time += now - p->last_ran;
> +	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> +	cputime64_t time_diff;
> +
> 	p->last_ran = rq->most_recent_timestamp = now;
> +	/* Sanity check. It should never go backwards or ruin accounting */
> +	if (unlikely(now < p->last_ran))
> +		return;
> +	time_diff = now - p->last_ran;

A nit. Anything wrong with:

time_diff = now - p->last_ran;
if (unlikeley (LESS_THAN_ZERO (time_diff))
         return;

[..snip..]

-- 
vale
