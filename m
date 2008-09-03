Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYICRPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYICRPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYICRP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:15:27 -0400
Received: from www.tglx.de ([62.245.132.106]:49031 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbYICRP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:15:26 -0400
Date: Wed, 3 Sep 2008 19:15:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@lisas.de>
cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, shaohua.li@intel.com
Subject: Re: [PATCH] Prevent clockevent event_handler ending up
 handler_noop
In-Reply-To: <20080903164356.GA31969@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LFD.1.10.0809031908270.3243@apollo.tec.linutronix.de>
References: <20080903164356.GA31969@rhlx01.hs-esslingen.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Andreas Mohr wrote:
> Hi,
> 
> > This does not have any issue in normal case as most likely all the clockevent
> > devices are setup before the highres switch. But, can potentially be affecting
> > some corner case where HPET force detect happens after the highres switch.
> 
> So... does that apply to a nice sound card with an even nicer
> 1 MHz "DirectX timer" as well
> which I would soon force into registering a clock_event_device? ;)
> (I might add that this sound driver is _modular_, BTW it's azt3328.c)

Yup, the switchover to any new device can cause this. Right now we
only have HPET replacing PIT, but ..
 
> Or did I completely slide off the usual tracks of what is "politically
> correct" to do with kernel source code here? ;)

-ENOPARSE

> Oh, and how would this integrate (or rather, "conflict"?)
> with globally managed PIT / HPET event device handling?

Pretty much not. We have this global management as HPET replaces the
PIT and occupies the PIT irq as well, so we need to know which one is
active.

> See what such highres-deprived people as myself (PIT, acpi_pm,
> _no_ HPET and thus no IRQed highres timer) are doing now,

Err. PIT + acpi_pm works with highres. acpi_pm is a stable clocksource
and PIT is not a good, but a usable oneshot timer.
 
> And any hints on how to possibly (reliably!) provide both clock_event_device
> (oneshot) _and_ clocksource for a _single_ IRQed countdown timer?

No. For a reliable clocksource you need an ever increasing /
decreasing counter, which just wraps around when the max. count is
reached.

If you use a single shot timer, which is reprogrammed after every
interrupt, then you will deviate from the time line as you have no
idea how long it took from the counter reaching zero to the point
where you reload the timer. Simply wont work.

Thanks,

	tglx
