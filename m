Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbXKSRQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbXKSRQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 12:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbXKSRQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 12:16:17 -0500
Received: from gw.goop.org ([64.81.55.164]:57239 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbXKSRQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 12:16:16 -0500
Message-ID: <4741C4BA.8010905@goop.org>
Date: Mon, 19 Nov 2007 09:15:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: regression from softlockup fix
References: <20071119.012119.118043374.davem@davemloft.net> <20071119094338.GA19271@elte.hu>
In-Reply-To: <20071119094338.GA19271@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David Miller <davem@davemloft.net> wrote:
>
>   
>> I suspect that what is happening is that the NOHZ period is longer 
>> than the softlockup timeout (10 seconds) and we get an interrupt 
>> before the watchdog thread gets onto the cpu.
>>     
>
> indeed! Does the patch below do the trick?
>
> 	Ingo
>
> --------------->
> Subject: softlockup: do the wakeup from a hrtimer
> From: Ingo Molnar <mingo@elte.hu>
>
> David Miller reported soft lockup false-positives that trigger
> on NOHZ due to CPUs idling for more than 10 seconds.
>
> The solution is to drive the wakeup of the watchdog threads
> not from the timer tick (which has no guaranteed frequency),
> but from the watchdog tasks themselves.
>   

I thought the timer code kicked the watchdog after waking up after a
long sleep anyway?  At one point I was looking into a mechanism to
temporarily disable the watchdog during a wait for a timer event, but it
got complex - and I thought - unnecessary.

Specifically this in kernel/time/timekeeping.c:

		/*
		 * When we are idle and the tick is stopped, we have to touch
		 * the watchdog as we might not schedule for a really long
		 * time. This happens on complete idle SMP systems while
		 * waiting on the login prompt. We also increment the "start of
		 * idle" jiffy stamp so the idle accounting adjustment we do
		 * when we go busy again does not account too much ticks.
		 */
		if (ts->tick_stopped) {
			touch_softlockup_watchdog();
			ts->idle_jiffies++;
		}

Or does this happen on the sleep path?  If so, wouldn't the right fix to
be this on the wakeup path?

    J
