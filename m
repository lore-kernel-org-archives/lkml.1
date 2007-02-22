Return-Path: <linux-kernel-owner+w=401wt.eu-S1751363AbXBVR0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbXBVR0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXBVR0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:26:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41209
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbXBVR0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:26:53 -0500
Date: Thu, 22 Feb 2007 09:26:52 -0800 (PST)
Message-Id: <20070222.092652.55507017.davem@davemloft.net>
To: tglx@linutronix.de
Cc: jengelh@linux01.gwdg.de, kronos.it@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172159501.25076.182.camel@localhost.localdomain>
References: <1172099859.25076.132.camel@localhost.localdomain>
	<Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
	<1172159501.25076.182.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 22 Feb 2007 16:51:41 +0100

> PIT and local APIC timer are used to provide either periodic or one shot
> programmable timer events.
> 
> Up to now the kernel started PIT and local APIC timer in parallel with
> the same period where PIT incremented jiffies and local APIC timer
> called update_process_times() and profile_tick. We changed this to let
> the boot cpu increment jiffies inside the local apic timer interrupt
> after PIT has been stopped. A whole interrupt for jiffies64++ is waste.

BTW, I'm adding support for sparc64, and before I get much further
will the code handle a oneshot-only device?  That's basically what I
have (sparc64 basically has a TSC and a "comparison" register, you
write the "comparison" register with the TSC value at which you'd like
the timer interrupt to occur, so it's one-shot and you have to write
it again to get the next timer).

I see logic in the generic code to do periodic events when the
timer only provides one-shot ticks.  But as far as I can tell
both the HPET and the local APIC support periodic timers so
I can't tell how much testing that code has gotten :-)

I, in fact, don't see any clockevent device in the current tree that
does not set CLOCK_EVT_FEAT_PERIODIC.

I guess you could clear that bit just to test those generic code
paths. :-)

BTW, sparc64 always did the trick where the do_timer() work was done
by one of the per-cpu local timer interrupts, I'm glad the idea gained
traction generically. :-)))
