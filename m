Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbYIVOm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbYIVOm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYIVOmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:42:50 -0400
Received: from relay2.sgi.com ([192.48.171.30]:49262 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752269AbYIVOmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:42:49 -0400
Message-ID: <48D7AEE6.7080804@sgi.com>
Date: Mon, 22 Sep 2008 07:42:46 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
References: <20080919143744.009764000@polaris-admin.engr.sgi.com> <20080919143744.190005000@polaris-admin.engr.sgi.com> <20080922114820.GA13990@elte.hu>
In-Reply-To: <20080922114820.GA13990@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>  arch/x86/kernel/genx2apic_uv_x.c |  138 +++++++++++++++++++++++++++++++++++++++
>>  include/asm-x86/uv/uv_hub.h      |   62 +++++++++++++++++
> 
> hm, why is this in genx2apic_uv_x.c, not a separate file?
> 
>> +	idle_notifier_register(&uv_idle_notifier);
> 
> no, we really dont want such overhead in an idle notifier. (those 
> interfaces will go away)

Hi Ingo,

The overhead is very low and I've not been able to figure out how to 
"estimate" per cpu usage without tons more code (duplicating "top" in
the kernel.)  The actual I/O (well O ;-) is once per second.  The other
important point is this is only on an SGI UV system, so no other systems
are affected.  Because of this, I'm a bit confused by your objection.

I tried a couple of other approaches, but because the timer wakeup
causes the idle state to be exited, it's difficult to determine if
the cpu was idle before the timer interrupt.  (I even tried putting a
"wasidle" in the pda to check the idle state prior to the last exit
from idle, but this did not appear to be reliable.)  The idle callback
solves this rather nicely.

Here's the same code that's been in ia64 for quite a while:

arch/ia64/sn/kernel/setup.c:
	void __init sn_setup(char **cmdline_p)
	{
		...
		ia64_mark_idle = &snidle;

arch/ia64/kernel/process.c:
	cpu_idle (void)
	{
        	void (*mark_idle)(int) = ia64_mark_idle;
		...

                if (mark_idle)
                        (*mark_idle)(1);

(The x86 callback approach is much cleaner.)

Another relevant point is that I will be adding a bit more functionality
to disable the timer interrupt on truly "idle" cpus (like have been idle
for some amount of seconds).  We would then use the "exit from idle"
callback to reestablish the timer interrupt.  [This would allow them to
enter power down states if appropriate.]

> 
> As i suggested in my previous mail about this topic, a low-frequency 
> sampling method should be used instead, to indicate system status. I 
> thought the leds drivers have all that in place already.

It is low frequency (once per second), this is just setting what's to
be sampled.

As I mentioned, this is not for LED displays (human readable), it's for the
system controller to monitor how all parts of the system are running, and
this one is just the cpu parts.  The LED driver approach would have me
registering 4096 led devices, with all their callbacks, 4096 strings saying
"LED0001", etc., and I still cannot associate a specific register bit
(AKA LED if that's what it was), with a specific cpu using the LED driver.

The LED driver is fine for a couple of blinking lights indicating overall
system activity, disk activity, etc.  (Btw, I did not see a network trigger,
or a paging trigger, or an out of memory trigger, or some other things that
might be useful for real time monitoring of the system.)

But the LED driver has way more overhead than needed for this simple application.

Thanks,
Mike
