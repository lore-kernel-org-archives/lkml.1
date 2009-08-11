Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZHKNCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZHKNCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZHKNCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:02:38 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:43454 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbZHKNCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:02:37 -0400
Date: Tue, 11 Aug 2009 08:44:42 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: Question about userspace-consumer
Message-ID: <20090811054438.GA7176@gandalf>
Reply-To: me@felipebalbi.com
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810215800.GB4528@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 10:58:01PM +0100, Mark Brown wrote:
> On Mon, Aug 10, 2009 at 11:05:54PM +0300, Felipe Balbi wrote:
> 
> > I was reading userspace-consumer file ad was wondering whether would be
> > possible to use that in order to implement what SBS-IF [1] proposes
> > using sbs-enabled devices.
> 
> Looking at that I'm not sure why you wish to push this into user space?

we need some daemon monitoring battery statuses and taking actions on
that. Imagine, for example, usb charging where we can:

a. charge up to 100mA when unconfigured
b. charge up to 500mA when configured
c. charge up to 2.5A when with dedicated charger
d. charge up to 2.5mA when bus is suspended

handling all of those cases on kernel space seems a little bit odd,
especially because we still need to take care of state-of-charge,
pack temperature, time-to-charge, etc etc etc.

a big looping polling for that stuff in kernel space didn't seem ok to
me.

> The existing drivers for this sort of functionality are all regular
> kernel drivers (in drivers/power and to a lesser extent drivers/hwmon)
> and it looks like it'd be at least as much work to rearrange the power
> supply stuff to support userspace drivers.  My initial expectation would

power supply already does what it needs, no ? It exports battery
figures (state-of-charge, time-to-charge, temperature, etc etc) via
sysfs to userland, where our "charging daemon" could read those values
from.

> be for a generic driver with some policy exposed to user space and some
> configuration exposed for architecture code (especially for setting up
> multi-battery board layouts and things).  That's not a terribly informed
> opinion, though.
> 
> > For doing that, probably userspace-consumer would have to be able to
> > set_voltage/get_voltage, set/get_current_limit and so on. So I was
> > thinking on changing userspace-consumer to use regulator_get() instead
> > of regulator_bulk_get() and make each instance of userspace-consumer to
> > talk to only and only one regulator.
> 
> I'd like to preserve the bulk switch if possible - part of the thinking
> was that things with more complex needs may well find it easier and/or
> more robust to have custom kernel stubs which mapped one or more
> regulators into the interfaces they needed.  That was more for things
> like working out which of multiple supplies is which, though.

gotcha. The only problem is that it becomes a litle difficult to access
struct regulator * for doing regulator_set_voltage() and its sibblings.

> The existing virtual consumer, while intended as a test harness
> originally and rather clunky as-is, is much closer to your needs.  It is
> the way it is partly as a sign that you really shouldn't be using it in
> production (which seems to be working!).
> 
> > Anyways, how do you guys feel about it ?
> 
> Like I say, from a quick read through of the specs I'm not sure that I'd
> push this into user space but I've not thought about this deeply and may
> be missing something.

I think kernel should, as long as possible, only provide functionalities
for userland to take decisions and actions, no ?

Handling policy in kernel space I find it a little odd, specially
because different manufacturers might have different charging algorithms
they want to implement.

that said, power supply framework and regulator framework seem to be
well enough for implementing the basic support for SBS-enabled charging
scheme.

-- 
balbi
