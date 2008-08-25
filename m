Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYHYRtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYHYRtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYHYRtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:49:24 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43460 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753655AbYHYRtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:49:23 -0400
Message-ID: <48B2F0A1.4070205@sgi.com>
Date: Mon, 25 Aug 2008 10:49:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/6] x86_64 UV: Use LED to indicate CPU is active
References: <20080808005639.505189000@polaris-admin.engr.sgi.com> <20080808005649.986660000@polaris-admin.engr.sgi.com> <20080811155318.GB4524@elte.hu>
In-Reply-To: <20080811155318.GB4524@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> +/*
>> + * Illuminate "activity" LED when CPU is going "active",
>> + * extinguish when going "idle".
>> + */
>> +static int uv_idle(struct notifier_block *nfb, unsigned long action, void *junk)
>> +{
>> +	if (action == IDLE_START)
>> +		uv_set_led_bits(0, LED_CPU_ACTIVITY);
>> +
>> +	else if (action == IDLE_END)
>> +		uv_set_led_bits(LED_CPU_ACTIVITY, LED_CPU_ACTIVITY);
>> +
>> +	return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block uv_idle_notifier = {
>> +	.notifier_call = uv_idle,
>> +};
>>  
>> +/*
>> + * Initialize idle led callback function
>> + */
>> +static __init void uv_init_led_idle_display(void)
>> +{
>> +	/* initialize timer for activity monitor */
>> +	idle_notifier_register(&uv_idle_notifier);
>> +}
> 
> hm, i think this is a bad idea. While putting it into the go-to-idle 
> codepath probably doesnt matter, putting anything into the idle wakeup 
> path increases latency of a rather critical codepath. The MMR write that 
> the LED driver is using will go out to the local bus, which, even if 
> it's POST-ed, if it's done frequently enough will be the cost of an IO 
> cycle.
> 
> No human needs to know the LED status at _that_ frequency anyway, so 
> it's quite pointless as well.
> 
> A much better (and faster) approach would be to sample the utilization 
> of the CPU and indicate that via the LED(s).
> 
> 	Ingo

Hi Ingo,

I'll take a closer look at this.  The actual usage is more in line with
an SNMP type system controller that has direct access to the BIOS registers
including the "LED" register and is used mostly for diagnosing system
problems.  The other research I need to do is how fast/slow is this path.
It may be a simple memory write in our UV NUMA hub chip that's not directed
to the general I/O bus and hence, negligible overhead.

Looking at the IA64 code, it has a similar interface which uses a function
pointer variable to set/reset "idle" state.  I just wish x86_64 had a similar
common interface for the clock handler that would occur per cpu and not per
group of cpus that clocksource_watchdog() currently uses.

The other architectural change I would like to make is to expose the necessary
data/address via the pda (or something similar) and allow the complete write
to be inlined to one or two instructions.

Thanks,
Mike
