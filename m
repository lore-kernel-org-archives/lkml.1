Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbYADLJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbYADLJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYADLJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:09:40 -0500
Received: from www.tglx.de ([62.245.132.106]:53228 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbYADLJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:09:39 -0500
Date: Fri, 4 Jan 2008 12:09:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Hecht <dhecht@vmware.com>
cc: Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: PIT clocksource makes invalid assumptions
In-Reply-To: <477D7548.9070400@vmware.com>
Message-ID: <alpine.LFD.0.99999.0801041127570.4042@localhost.localdomain>
References: <477D7548.9070400@vmware.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008, Dan Hecht wrote:
> Seems these problems can happen when the PIT is used as the clocksource or
> even just the clocksource watchdog.  It looks like there is some code in
> clocksource.c that checks for CLOCK_SOURCE_IS_CONTINUOUS, which is not set for
> the PIT clocksource, but it doesn't seem to be strong enough to prevent these
> problematic scenarios (and it's not clear if that is the intent of
> IS_CONTINUOUS anyway).
>
> To verify this really can happen, when I boot a kernel, I can see this
> sequence:
> 
>   init_pit_timer (with mode==CLOCK_EVT_MODE_PERIODIC)
>   init_pit_timer (with mode==CLOCK_EVT_MODE_UNUSED)
>   init_pit_timer (with mode==CLOCK_EVT_MODE_SHUTDOWN)
>   pit_read() and count > LATCH (I believe the PIT is the watchdog at this
> point), which causes the PIT to raise periodic interrupts.

Darn, yes. This might happen on UP when we have local apic timer
available.

There is another caveat, when we have HPET and enable it.

> (Shortly after, the acpi pm clocksource is registered and replaces the PIT as
> the watchdog.  Later, the PIT clockevent is used as the broadcast clockevent
> and reprogrammed into one-shot mode, stopping the PIT interrupts.)
> 
> Also, the user could force the PIT clocksource to be current_clocksource even
> though the PIT is in one-shot mode (and therefore the calculation in pit_read
> is bogus).

Yup, we need to prevent that.

> Of course, all this can only happen for 32-bit UP.  I'm not sure what the
> preferred fix for this is...

I guess disabling PIT clocksource there is the way to go. Not sure
yet, need to look into all the odds and ends.

Thanks for pointing this out,

	tglx
