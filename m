Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYADUz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYADUz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 15:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYADUzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 15:55:51 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:42048 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089AbYADUzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 15:55:50 -0500
Message-ID: <477E9D56.9090603@vmware.com>
Date: Fri, 04 Jan 2008 12:55:50 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PIT clocksource makes invalid assumptions
References: <477D7548.9070400@vmware.com> <1199477938.6327.18.camel@localhost.localdomain>
In-Reply-To: <1199477938.6327.18.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2008 12:18 PM, john stultz wrote:
> On Thu, 2008-01-03 at 15:52 -0800, Dan Hecht wrote:
>> Looking at pit_read() in arch/x86/kernel/i8253.c, it seems that the PIT 
>> clocksource code assumes that the PIT CH0 is in periodic mode.  With 
>> clockevents, this assumption is no longer valid.  There are at least two 
>> places that make this assumption:
>>
>> 1) The calculation at the end of pit_read() assumes that the PIT is in 
>> periodic mode.  This isn't true unless the PIT is the current clockevent 
>> and nohz is inactive.  (Though #2 can end up forcing the PIT to be 
>> reprogrammed).
>>
>> 2) The PIT clockevent is shutdown by using PIT mode 0 (interrupt on 
>> terminal count) -- doesn't the PIT counter continue to count (even 
>> though it won't be raising an interrupt)?  If so, the test in pit_read() 
>> under the VIA686a comment can succeed after the PIT clockevent has been 
>> shutdown, and the PIT hardware may be reprogrammed to start firing 
>> interrupts again.  This doesn't seem intentional, and can defeat nohz 
>> since now the PIT is firing periodically.
>>
>> Seems these problems can happen when the PIT is used as the clocksource 
>> or even just the clocksource watchdog.  It looks like there is some code 
>> in clocksource.c that checks for CLOCK_SOURCE_IS_CONTINUOUS, which is 
>> not set for the PIT clocksource, but it doesn't seem to be strong enough 
>> to prevent these problematic scenarios (and it's not clear if that is 
>> the intent of IS_CONTINUOUS anyway).
> 
> The clocksource in use must have IS_CONTINUOUS set before we go into
> HRT/no_hz mode, so I think the situations above should not be possible
> (although I've not had a chance to check the current code).
> 

Yes, I think that is correct.  But, I don't think the code (always) 
prevents nohz mode when the clocksource *watchdog* is !IS_CONTINUOUS.

Anyway, the bug doesn't require that nohz mode is enabled, it just 
requires that the PIT clockevent is shutdown (or otherwise not 
programmed in periodic mode).

>> To verify this really can happen, when I boot a kernel, I can see this 
>> sequence:
>>
>>    init_pit_timer (with mode==CLOCK_EVT_MODE_PERIODIC)
>>    init_pit_timer (with mode==CLOCK_EVT_MODE_UNUSED)
>>    init_pit_timer (with mode==CLOCK_EVT_MODE_SHUTDOWN)
>>    pit_read() and count > LATCH (I believe the PIT is the watchdog at 
>> this point), which causes the PIT to raise periodic interrupts.
>>
>> (Shortly after, the acpi pm clocksource is registered and replaces the 
>> PIT as the watchdog.  Later, the PIT clockevent is used as the broadcast 
>> clockevent and reprogrammed into one-shot mode, stopping the PIT 
>> interrupts.)
>>
>> Also, the user could force the PIT clocksource to be current_clocksource 
>> even though the PIT is in one-shot mode (and therefore the calculation 
>> in pit_read is bogus).
> 
> Does this actually happen and cause problems? I thought there was some
> code to make sure we disable HRT/no_hz if we install a clocksource that
> does not have IS_CONTINUOUS set.
> 

I didn't check if nohz was disabled when the PIT clocksource is switched 
to, but I did check that the PIT was not the active clockevent, which is 
enough for this bug.

I also didn't do a whole lot of digging to see what the problems this 
bug can cause in practice, but after the PIT clocksource was installed, 
I tried 'sleep 1' and this did not wake up.

Thanks,
Dan
