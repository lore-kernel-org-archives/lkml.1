Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbXC1Bln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbXC1Bln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 21:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXC1Blm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 21:41:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:41103 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbXC1Blk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 21:41:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,336,1170662400"; 
   d="scan'208"; a="217617840:sNHT22442959"
In-Reply-To: <1175022275.5599.0.camel@linux-n33p.site>
References: <1174722427.32554.84.camel@localhost.localdomain> 1174887388.5523.7.camel@sli10-conroe.sh.intel.com <1175022275.5599.0.camel@linux-n33p.site>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <D89216DC-AAB7-4341-BB55-D3E7A921583F@intel.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, linux-acpi@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [RFC][PATCH 3/3] add the 'menu' cpuidle governor
Date: Tue, 27 Mar 2007 18:43:20 -0700
To: Adam Belay <abelay@novell.com>
X-Mailer: Apple Mail (2.752.3)
X-OriginalArrivalTime: 28 Mar 2007 01:41:38.0884 (UTC) FILETIME=[3A6E5840:01C770DA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 27, 2007, at 12:04 PM, Adam Belay wrote:

> On Mon, 2007-03-26 at 13:36 +0800, Shaohua Li wrote:
>> Hi,
>> On Sat, 2007-03-24 at 03:47 -0400, Adam Belay wrote:
>>> This patch adds the 'menu' governor, as was described in my first  
>>> email.
>>>
>>
>>> +/**
>>> + * menu_select - selects the next idle state to enter
>>> + * @dev: the CPU
>>> + */
>>> +static int menu_select(struct cpuidle_device *dev)
>>> +{
>>> +	struct menu_device *data = &__get_cpu_var(menu_devices);
>>> +	int i, expected_us, max_state = dev->state_count;
>>> +
>>> +	/* discard BM history because it is sticky */
>>> +	cpuidle_get_bm_activity();
>> Why discard BM history here? This way the next bm check almost always
>> return 0.
>
> Yes, although in testing it detects BM activity more often then one
> might think, I agree, this is probably too aggressive.  At the time, I
> was trying to avoid situations where BM_STS goes high early during a
> long busy period and as a result becomes stale.

How do you see lot of bm_activity. The monitoring window seems to be  
very small here. Just around the calculation of expected_us.


>> BTW, bm activity is global (Not cpu specific), we'd better account it
>> system wide.
>
> Yes, but do we need to support BM_STS in the SMP case?
>
>>
>>> +	/* determine the expected residency time */
>>> +	expected_us = (s32) ktime_to_ns(tick_nohz_get_sleep_length()) /  
>>> 1000;
>>> +	expected_us = min(expected_us, data->break_last_us);
>>> +
>>> +	/* determine the maximum state compatible with current BM  
>>> status */
>>> +	if (cpuidle_get_bm_activity())
>>> +		data->bm_elapsed_us = 0;
>>> +	if (data->bm_elapsed_us <= data->bm_holdoff_us)
>>> +		max_state = data->deepest_bm_state + 1;
>>> +
>>> +	/* find the deepest idle state that satisfies our constraints */
>>> +	for (i = 1; i < max_state; i++) {
>>> +		struct cpuidle_state *s = &dev->states[i];
>>> +		if (s->target_residency > expected_us)
>>> +			break;
>>> +		if (s->exit_latency > system_latency_constraint())
>>> +			break;
>>> +	}
>>> +
>>> +	data->last_state_idx = i - 1;
>>> +	data->idle_jiffies = tick_nohz_get_idle_jiffies();
>>> +	return i - 1;
>>> +}
>>> +
>>> +/**
>>> + * menu_reflect - attempts to guess what happened after entry
>>> + * @dev: the CPU
>>> + *
>>> + * NOTE: it's important to be fast here because this operation  
>>> will add to
>>> + *       the overall exit latency.
>>> + */
>>> +static void menu_reflect(struct cpuidle_device *dev)
>>> +{
>>> +	struct menu_device *data = &__get_cpu_var(menu_devices);
>>> +	int last_idx = data->last_state_idx;
>>> +	int measured_us = cpuidle_get_last_residency(dev);
>>> +	struct cpuidle_state *target = &dev->states[last_idx];
>>> +
>>> +	/*
>>> +	 * Ugh, this idle state doesn't support residency measurements,  
>>> so we
>>> +	 * are basically lost in the dark.  As a compromise, assume we  
>>> slept
>>> +	 * for one full standard timer tick.  However, be aware that this
>>> +	 * could potentially result in a suboptimal state transition.
>>> +	 */
>>> +	if (!(target->flags & CPUIDLE_FLAG_TIME_VALID))
>>> +		measured_us = USEC_PER_SEC / HZ;
>>> +
>>> +	data->bm_elapsed_us += measured_us;
>>> +	data->break_elapsed_us += measured_us;
>> See the system state: idle->running->idle
>> Looks the bm_elapsed_us and break_elapsed_us account ingored the  
>> running
>> state between the two idles. Eg, the 'running' might generate a  
>> lot of
>> bm activity, then maybe we should reset bm_elapsed_us in the next
>> 'idle'.
>
> I ignore the time between idle states because I'm only interested in
> accounting the idle sleep behavior.  A more sophisticated strategy  
> might
> also account the running time between idles in some way.  However,  
> it is
> worth noting that a busy system has the indirect effect of shortening
> the idle residency times.
>
> I think removing the BM_STS clear attempt at the beginning should help
> to reset bm_elapsed_us after sufficiently long busy periods.
>

I am also thinking about break_elapsed_us.
>>> +	data->break_elapsed_us += measured_us;

It seems to assume that we are in back to back idle. But it can be
idle -> busy -> idle -> busy -> idle -> busy that is going to cause  
some interrupt in near future -> idle -> busy
In this case break_elapsed _us would be a huge number which would be  
wrong.
Better way may be to make break_elapsed_us to zero once we notice  
some busy-ness.

Also, instead of one break_elapsed_us and bm, we may have to  
experiment with maintaining previous X values as history and using  
the min of those X values than just one last value. What do you think?

Thanks,
Venki
