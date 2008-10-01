Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYJATk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYJATk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 15:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYJATks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 15:40:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58511 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753634AbYJATks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 15:40:48 -0400
Message-ID: <48E3D24E.6040307@sgi.com>
Date: Wed, 01 Oct 2008 12:41:02 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       rpurdie@rpsys.net, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
References: <20080919143744.009764000@polaris-admin.engr.sgi.com> <20080919143744.190005000@polaris-admin.engr.sgi.com> <20080922114820.GA13990@elte.hu> <48D7AEE6.7080804@sgi.com> <20080928194201.GA1310@ucw.cz> <48E3BE2D.4020606@sgi.com>
In-Reply-To: <48E3BE2D.4020606@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Pavel Machek wrote:
>>> Another relevant point is that I will be adding a bit more functionality
>>> to disable the timer interrupt on truly "idle" cpus (like have been idle
>>> for some amount of seconds).  We would then use the "exit from idle"
>>> callback to reestablish the timer interrupt.  [This would allow them to
>>> enter power down states if appropriate.]
>> Should you look at nohz instead of reinventing it? 
> 
> Thanks, I did look at it.  Quite complex.  Maybe I'm missing something
> but I don't see how it fits in?  Are you saying I should be using data
> in the percpu tick_sched to gather the idle information for the once
> per second per cpu status update interrupt?  I see the @idle_active
> entry but wouldn't this always be false during the timer interrupt?
> Using any other entries would appear to be more complex than a simple
> store byte and subtracting two longs.
> 
> Or perhaps I should somehow hook into the sched_timer interrupt instead
> of having a separate once per second per cpu interrupt?  (Does this
> sched_timer interrupt each cpu once per second?)
> 
>>>> As i suggested in my previous mail about this topic, a low-frequency 
>>>> sampling method should be used instead, to indicate system status. I 
>>>> thought the leds drivers have all that in place already.
>>> It is low frequency (once per second), this is just setting what's to
>>> be sampled.
>>>
>>> As I mentioned, this is not for LED displays (human readable), it's for the
>>> system controller to monitor how all parts of the system are running, and
>>> this one is just the cpu parts.  The LED driver approach would have me
>>> registering 4096 led devices, with all their callbacks, 4096 strings saying
>>> "LED0001", etc., and I still cannot associate a specific register bit
>>> (AKA LED if that's what it was), with a specific cpu using the LED driver.
>>>
>>> The LED driver is fine for a couple of blinking lights indicating overall
>>> system activity, disk activity, etc.  (Btw, I did not see a network trigger,
>>> or a paging trigger, or an out of memory trigger, or some other things that
>>> might be useful for real time monitoring of the system.)
>> ...so add them...
>>
>>> But the LED driver has way more overhead than needed for this simple application.
>>>
>> So overhead from led driver is not okay, while overhead from messing
>> with idle loop is okay? Interesting...
>> 								Pavel
> 
> The overhead is mainly the registration of descriptor blocks for the
> 4096 registers representing the 4096 cpus all at separate addresses.
> The overhead in this patch for maintaining the "idle" state (prior to the
> timer interrupt causing "exit_idle") is storing a byte and subtracting the
> current jiffies from the jiffies at the last one second timer interrupt.
> (Even this subtraction can be removed, the only *important* item is
> whether the cpu is currently idle or not.)

Actually, this comparing idle time vs. not idle time during the last
second is what gets around the problem that the system goes to not
idle servicing the timer interrupt, which hides the real idle state.
If anyone has a suggestion on how to get a once per second per cpu
timer callback which does not call exit_idle, (or any other means of
indicating whether the cpu is idle), I'd be more than happy to remove
the idle callback function.

In discussions with SGI's RAS engineering it's felt that this status
is very important for their current RAS analysis programs, making the
system overhead for UV more than worthwhile.

Thanks,
Mike

> 
> This data is written to node local memory that's highly likely to be in
> the cache, as the same memory block is used for all UV hub operations.
> 
> Unfortunately, I am experiencing a simulator problem at the moment or
> I'd be able to quantify the exact amount of time added to the exit_idle()
> function, but it's basically noise in the overall resumption of a thread.
> 
> One other factor, this overhead is *only* for UV systems, no other x86_64
> systems or architectures are affected, so again I'm not understanding the
> objection.  This request was made from our hardware and RAS engineers,
> and is identical to what's been in the ia64 kernel for a few years now.
> 
> Perhaps the confusion is it's near relationship to real "LED" lights?
> The original name "LED" is historical.  The bits are read by a system
> controller that has the job of monitoring the entire system, including
> both soft and hard errors and determining faulty [or near faulty]
> system components.  For example, if a node suddenly hangs, this is a
> one of the diagnostic aids used in determining the state of that node.
> (Btw, the SCIR register that is written to once per second is a FIFO so
> it contains the last 64 updates of this register giving a temporal view
> of each cpu as well.)
> 
> Thanks,
> Mike

