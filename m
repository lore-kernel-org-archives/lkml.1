Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbYACXww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbYACXww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYACXwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:52:42 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52082 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756622AbYACXwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:52:41 -0500
Message-ID: <477D7548.9070400@vmware.com>
Date: Thu, 03 Jan 2008 15:52:40 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dan Hecht <dhecht@vmware.com>
Subject: PIT clocksource makes invalid assumptions
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at pit_read() in arch/x86/kernel/i8253.c, it seems that the PIT 
clocksource code assumes that the PIT CH0 is in periodic mode.  With 
clockevents, this assumption is no longer valid.  There are at least two 
places that make this assumption:

1) The calculation at the end of pit_read() assumes that the PIT is in 
periodic mode.  This isn't true unless the PIT is the current clockevent 
and nohz is inactive.  (Though #2 can end up forcing the PIT to be 
reprogrammed).

2) The PIT clockevent is shutdown by using PIT mode 0 (interrupt on 
terminal count) -- doesn't the PIT counter continue to count (even 
though it won't be raising an interrupt)?  If so, the test in pit_read() 
under the VIA686a comment can succeed after the PIT clockevent has been 
shutdown, and the PIT hardware may be reprogrammed to start firing 
interrupts again.  This doesn't seem intentional, and can defeat nohz 
since now the PIT is firing periodically.

Seems these problems can happen when the PIT is used as the clocksource 
or even just the clocksource watchdog.  It looks like there is some code 
in clocksource.c that checks for CLOCK_SOURCE_IS_CONTINUOUS, which is 
not set for the PIT clocksource, but it doesn't seem to be strong enough 
to prevent these problematic scenarios (and it's not clear if that is 
the intent of IS_CONTINUOUS anyway).

To verify this really can happen, when I boot a kernel, I can see this 
sequence:

   init_pit_timer (with mode==CLOCK_EVT_MODE_PERIODIC)
   init_pit_timer (with mode==CLOCK_EVT_MODE_UNUSED)
   init_pit_timer (with mode==CLOCK_EVT_MODE_SHUTDOWN)
   pit_read() and count > LATCH (I believe the PIT is the watchdog at 
this point), which causes the PIT to raise periodic interrupts.

(Shortly after, the acpi pm clocksource is registered and replaces the 
PIT as the watchdog.  Later, the PIT clockevent is used as the broadcast 
clockevent and reprogrammed into one-shot mode, stopping the PIT 
interrupts.)

Also, the user could force the PIT clocksource to be current_clocksource 
even though the PIT is in one-shot mode (and therefore the calculation 
in pit_read is bogus).

Of course, all this can only happen for 32-bit UP.  I'm not sure what 
the preferred fix for this is...

Dan

