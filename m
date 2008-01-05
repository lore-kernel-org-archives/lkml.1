Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbYAEKKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbYAEKKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 05:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYAEKKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 05:10:34 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:54961 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbYAEKKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 05:10:32 -0500
Date: Sat, 05 Jan 2008 11:10:29 +0100
Message-Id: <87242428@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: dhecht@vmware.com
Subject: Re: PIT clocksource makes invalid assumptions
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX198JJr018bxi3+kdpm06iLMK8sKq/RgPycpSJbs4wviWWp/n
 G8yxfm4wZzg87bi26mau/f/s4VGSOQxGDeONUlNyHQkTCr4mls=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I also didn't do a whole lot of digging to see what the problems this 
>bug can cause in practice, but after the PIT clocksource was installed, 
>I tried 'sleep 1' and this did not wake up.

i`m using clock=pit on many of our virtual servers for accurate time syncronization. (as recommended by vmware and even by microsoft  - see: http://support.microsoft.com/?scid=kb%3Ben-us%3B918461&x=11&y=18 )

so this means i need "clock=pit nohz=off" now on those systems, if this won`t get fixed? 



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
_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

