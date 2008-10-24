Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYJXM0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYJXM0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYJXM0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:26:30 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44364 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751275AbYJXM03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:26:29 -0400
Message-ID: <4901BF30.3090708@sgi.com>
Date: Fri, 24 Oct 2008 05:27:28 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pavel Machek <pavel@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz> <20081024120544.GA9812@elte.hu>
In-Reply-To: <20081024120544.GA9812@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Pavel Machek <pavel@suse.cz> wrote:
> 
>> On Fri 2008-10-24 04:19:04, Mike Travis wrote:
>>> [Ingo - could you let me know what's holding up this driver?
>>> Thanks!, Mike]
>> I thought that...
>>
>>  > +static __init void uv_scir_register_cpu_notifier(void)
>>> +{
>>> +	hotcpu_notifier(uv_scir_cpu_notify, 0);
>>> +	idle_notifier_register(&uv_idle_notifier);
>>> +}
>> ...Ingo said that idle_notifier_register is deprecated and going away?
> 
> yes, but i suspect Mike noticed that i acked Len's use of idle notifiers 
> in the ACPI tree, and now he wants to refresh this discussion?
> 
> i cannot really believe why anyone would want to slow down the from-idle 
> hotpath in such a lame way:
> 
> +       } else if (action == IDLE_END) {
> +
> +               uv_hub_info->scir.state |= SCIR_CPU_ACTIVITY;
> +               uv_hub_info->scir.idle_off += elapsed;
> +               uv_hub_info->scir.last = jiffies;
> +       }
> 
> with such a lame and low-res timestamp:
> 
> +       unsigned long elapsed = jiffies - uv_hub_info->scir.last;
> 
> it's an absolutely pointless act of adding overhead. Just use a regular 
> timer mechanism to update uv_hub_info->scir.idle_off.

I do use the timer mechanism (once per second) to update the scir state.
Unfortunately, the state is *always* not idle during the timer callback
(since we are actively executing), so I needed some way of knowing the
idle state prior to the timer callback.  The idle callback is only used
to record the amount of time this cpu's been idle during the last second
so on the once per second interrupt, I can determine if this cpu was more,
or less idle during that same time period.

The hardware saves the last 64 seconds for diagnostic purposes so this is
not meant to be a high-res indication but a longer term cpu history (along
with the other error records recorded, like memory/cpu/bus faults, etc.)
The System Controller copies these records into the system logs.

Also, this is only on a UV system, I'm not introducing any overhead for
any other x86_64 systems.

Thanks,
Mike
