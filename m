Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZHKUt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZHKUt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZHKUtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:49:25 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:45781 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbZHKUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:49:24 -0400
Date: Tue, 11 Aug 2009 23:49:18 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Felipe Balbi <me@felipebalbi.com>, Mike Rapoport <mike@compulab.co.il>,
       linux-kernel@vger.kernel.org
Subject: Smart Battery System Design (was: Re: Question about
 userspace-consumer)
Message-ID: <20090811204914.GB13969@gandalf>
Reply-To: me@felipebalbi.com
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
 <20090811054438.GA7176@gandalf>
 <20090811094020.GA6762@rakim.wolfsonmicro.main>
 <1249986616.5807.28.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249986616.5807.28.camel@odin>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 11, 2009 at 11:30:16AM +0100, Liam Girdwood wrote:
> On Tue, 2009-08-11 at 10:40 +0100, Mark Brown wrote:
> > On Tue, Aug 11, 2009 at 08:44:42AM +0300, Felipe Balbi wrote:
> > > On Mon, Aug 10, 2009 at 10:58:01PM +0100, Mark Brown wrote:
> > 
> > > > Looking at that I'm not sure why you wish to push this into user space?
> > 
> > > we need some daemon monitoring battery statuses and taking actions on
> > > that. Imagine, for example, usb charging where we can:
> > 
> > > a. charge up to 100mA when unconfigured
> > > b. charge up to 500mA when configured
> > > c. charge up to 2.5A when with dedicated charger
> > > d. charge up to 2.5mA when bus is suspended
> > 
> > It's more complex than that - those are the limits at the USB port that
> > define the power that can be drawn by the system.  The actual power

yeah, I understand quite well the usb standard.

> > available to the battery subsytem will be less since the rest of the
> > system needs to be powered.  In many cases even with 500mA available
> > the battery will need to be used to provide additional power in order to
> > keep the system operational rather than being charged.

and that's also rather obvious, specially since usb has overcurrent
protection (most of roothubs if not all), so drawing exactly 500mA
could cause current spikes that force the port to be shut off.

> > For USB powered operation at least some of the management here would
> > usually be implemented in hardware to provide the responsiveness
> > required.  Waiting for software to get involved would often allow the
> > main system supply to collapse.

and that's all ok.

> > > handling all of those cases on kernel space seems a little bit odd,
> > > especially because we still need to take care of state-of-charge,
> > > pack temperature, time-to-charge, etc etc etc.
> > 
> > > a big looping polling for that stuff in kernel space didn't seem ok to
> > > me.
> > 
> > No matter what you're still going to need at least some of the code
> > in-kernel in order to handle the monitoring daemon exiting.  For
> > example, if the battery is in fast charge then something will need to
> > back the charger off at least as the charge completes (if not
> > immediately user space exits) otherwise the battery or entire system is
> > likely to be damaged.

What I mean is that on SBS design, the "charger daemon" doesn't have to
handle the charging algorithm per se since the battery itself reports to
charger the best condition for it to be charged, but still we need means
for a userland application to see that a power source was attached (via
power supply interface, be it USB, AC or whatever we want) and tell the
charger to _start_charging_, no ?

That's when I thought a call to regulator_enable() would seem plausible.

> > Like I say some user space control does seem reasonable but I'd not
> > expect an entirely user space implementation.

of course not, specially since according to SBS, the hardware will
handle most of it autonomously.

> I agree, I think this probably deserves both user and kernel space
> components although the dividing line between them is a little uncertain
> atm. 

+1

> Generally, I'd expect the kernel side to provide a guaranteed *safe*
> environment for charging wrt system stability and battery status. A
> simple state machine would probably suffice.

and wrt SBS, that would mean basically writing a driver for that Smart
Batery Charger and the Smart Battery devices creating means for some
entity to tell _start_charging_ based on the presence of a power source.

> I think userspace is where we would manage policy. We would also store
> past battery history in order to better manage future charging and
> charge level estimation. 

Sure. Another point to be taken into account is how often to check
battery status; I mean, if the system is idle, we don't need to check
battery every second since battery temperature and juice won't change
that quickly anyways, but when doing some hardcore stuff on the CPU then
we need to check such variables more often.

-- 
balbi
