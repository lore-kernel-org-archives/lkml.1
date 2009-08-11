Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbZHKMq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbZHKMq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZHKMqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:46:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38403 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754488AbZHKMqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:46:48 -0400
Date: Tue, 11 Aug 2009 10:40:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mike Rapoport <mike@compulab.co.il>,
       linux-kernel@vger.kernel.org
Subject: Re: Question about userspace-consumer
Message-ID: <20090811094020.GA6762@rakim.wolfsonmicro.main>
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
 <20090811054438.GA7176@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811054438.GA7176@gandalf>
X-Cookie: For office use only.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 08:44:42AM +0300, Felipe Balbi wrote:
> On Mon, Aug 10, 2009 at 10:58:01PM +0100, Mark Brown wrote:

> > Looking at that I'm not sure why you wish to push this into user space?

> we need some daemon monitoring battery statuses and taking actions on
> that. Imagine, for example, usb charging where we can:

> a. charge up to 100mA when unconfigured
> b. charge up to 500mA when configured
> c. charge up to 2.5A when with dedicated charger
> d. charge up to 2.5mA when bus is suspended

It's more complex than that - those are the limits at the USB port that
define the power that can be drawn by the system.  The actual power
available to the battery subsytem will be less since the rest of the
system needs to be powered.  In many cases even with 500mA available
the battery will need to be used to provide additional power in order to
keep the system operational rather than being charged.

For USB powered operation at least some of the management here would
usually be implemented in hardware to provide the responsiveness
required.  Waiting for software to get involved would often allow the
main system supply to collapse.

> handling all of those cases on kernel space seems a little bit odd,
> especially because we still need to take care of state-of-charge,
> pack temperature, time-to-charge, etc etc etc.

> a big looping polling for that stuff in kernel space didn't seem ok to
> me.

No matter what you're still going to need at least some of the code
in-kernel in order to handle the monitoring daemon exiting.  For
example, if the battery is in fast charge then something will need to
back the charger off at least as the charge completes (if not
immediately user space exits) otherwise the battery or entire system is
likely to be damaged.

Like I say some user space control does seem reasonable but I'd not
expect an entirely user space implementation.

> > The existing drivers for this sort of functionality are all regular
> > kernel drivers (in drivers/power and to a lesser extent drivers/hwmon)
> > and it looks like it'd be at least as much work to rearrange the power
> > supply stuff to support userspace drivers.  My initial expectation would

> power supply already does what it needs, no ? It exports battery
> figures (state-of-charge, time-to-charge, temperature, etc etc) via
> sysfs to userland, where our "charging daemon" could read those values
> from.

I'd have expected to see both the charger and the battery appear as part
of the power supply map, or to see the charger and battery merged into
one device.

> > I'd like to preserve the bulk switch if possible - part of the thinking
> > was that things with more complex needs may well find it easier and/or
> > more robust to have custom kernel stubs which mapped one or more
> > regulators into the interfaces they needed.  That was more for things
> > like working out which of multiple supplies is which, though.

> gotcha. The only problem is that it becomes a litle difficult to access
> struct regulator * for doing regulator_set_voltage() and its sibblings.

Not really, the regulator is right there in the bulk data.  It's not
intended to be an opaque struct.

> > Like I say, from a quick read through of the specs I'm not sure that I'd
> > push this into user space but I've not thought about this deeply and may
> > be missing something.

> I think kernel should, as long as possible, only provide functionalities
> for userland to take decisions and actions, no ?

Policy should be punted to user space but that doesn't mean that the
entire implementation needs to be there.  For something like this where
you're likely to be burning a very large part of the entire system power
consumption and lasting hardware damage is likely if something goes
wrong the idea of removing everything from the kernel seems very risky.

> Handling policy in kernel space I find it a little odd, specially
> because different manufacturers might have different charging algorithms
> they want to implement.

Looking at the specs (like I say I didn't look *that* closely) it
appeared that the main goal was to encapsulate the charging algorithm in
the battery so that the charger only needed to do whatever it was told
by the battery.  I'd expect the policy for user space here to be more
along the lines of setting how much power the charge is allowed to
consume than the entire algorithm.

I'd also expect that if this gets widely deployed in smaller devices (as
opposed to laptops) you'd start to see chargers that are able to do some
of the management of the charge cycle autonomously.
