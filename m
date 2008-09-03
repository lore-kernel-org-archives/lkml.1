Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbYICRhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbYICRhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYICRga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:36:30 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50860 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbYICRg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:36:29 -0400
Date: Wed, 3 Sep 2008 19:36:27 +0200
From: Andreas Mohr <andi@lisas.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Mohr <andi@lisas.de>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, shaohua.li@intel.com
Subject: Re: [PATCH] Prevent clockevent event_handler ending up handler_noop
Message-ID: <20080903173627.GA7767@rhlx01.hs-esslingen.de>
References: <20080903164356.GA31969@rhlx01.hs-esslingen.de> <alpine.LFD.1.10.0809031908270.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809031908270.3243@apollo.tec.linutronix.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 03, 2008 at 07:15:16PM +0200, Thomas Gleixner wrote:
> On Wed, 3 Sep 2008, Andreas Mohr wrote:
> > See what such highres-deprived people as myself (PIT, acpi_pm,
> > _no_ HPET and thus no IRQed highres timer) are doing now,
> 
> Err. PIT + acpi_pm works with highres. acpi_pm is a stable clocksource
> and PIT is not a good, but a usable oneshot timer.

Hmm. What I'm interested in is longer wakeup timeouts (ACPI C2/C3
stuff), which would be a problem with PIT (~20 forced wakeups per second)
but with my new timer that would work.
Oh, side question: it _is_ easily possible to then disable PIT IRQs
once my event device is registered, right? Otherwise I could forget
about power management benefits...

And of course I'm interested in very short delays as well ("highres"),
which my timer could provide.

> > And any hints on how to possibly (reliably!) provide both clock_event_device
> > (oneshot) _and_ clocksource for a _single_ IRQed countdown timer?
> 
> No. For a reliable clocksource you need an ever increasing /
> decreasing counter, which just wraps around when the max. count is
> reached.
> 
> If you use a single shot timer, which is reprogrammed after every
> interrupt, then you will deviate from the time line as you have no
> idea how long it took from the counter reaching zero to the point
> where you reload the timer. Simply wont work.

Yup, that's exactly what I thought, slowly deviating from the timing
that it actually should have been, due to reprogramming...


So as I see it, the most beneficial thing I can do is to provide
a clock_event_device only.

Reasoning being that acpi_pm already is an easily accessible (fast)
reliable clocksource,
yet PIT is a _very_ slow (ISA timing) relatively coarse and
force-wakeupping event device.

Then additionally upgrade my driver to do mmapped access to this
PCI-MEM-capable sound card, and there we go with a fast and fine-grained
event device.

Out of interest: how big would you believe the benefit to be?
(overall system performance gains and ACPI PM benefits)

Thanks,

Andreas Mohr
