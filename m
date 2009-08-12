Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbZHLGsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbZHLGsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 02:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZHLGsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 02:48:10 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:43812 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZHLGsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 02:48:09 -0400
Date: Wed, 12 Aug 2009 09:47:50 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: Smart Battery System Design (was: Re: Question about
 userspace-consumer)
Message-ID: <20090812064745.GA17285@gandalf>
Reply-To: me@felipebalbi.com
References: <20090810200553.GB4652@gandalf>
 <20090810215800.GB4528@sirena.org.uk>
 <20090811054438.GA7176@gandalf>
 <20090811094020.GA6762@rakim.wolfsonmicro.main>
 <1249986616.5807.28.camel@odin>
 <20090811204914.GB13969@gandalf>
 <20090811223645.GA4691@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811223645.GA4691@sirena.org.uk>
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

On Tue, Aug 11, 2009 at 11:36:46PM +0100, Mark Brown wrote:
> This is already handled in kernel by the drivers/power code.  Whenever a
> power supply updates its status it notifies the subsystem which will
> then notify user space and also notify any other power supplies which
> have been configured as being supplied by the changing supply.  This is
> used by existing drivers for non-autonomous battery chargers to initiate
> charging (usually via a GPIO connected to the charger).

but that'll depend very much on the chip being used. Check bq24150, for
example. We cannot rely on a gpio since we have to tell the charger if
it can charger with up to 100mA, up to 500mA or more (in case of a
dedicated usb charger we can draw up to 2.5A if I'm not wrong, but most
chargers I've seen source up to 1.5A). A gpio would only be able to tell
the charger is present or not.

> > That's when I thought a call to regulator_enable() would seem plausible.
> 
> Yes, that's a good time to kick off a charge (other constraints
> permitting) however that's done.
> 
> This is all a bit of a sidetrack, though - the issue is if there is an
> in-kernel part to the SBS charger support.  With the userspace consumer
> there's nothing at all, even an extremely basic stub which does nothing
> more than shut the charger off when userspace exits would deal with the
> issue I have here.  For dumb chargers we need to make sure that
> something is taking responsibility for making sure that the battery is
> not mistreated.

sure, but where do we draw the line between kernel and userspace in this
case ?

do we just be sure that information goes to userland and in case there's
no application monitoring battery we stop charging ? Or do we monitor
the battery in-kernel ?

I'd go for monitoring in userland since we might have way too many
points to be tracking. One might be:

1. doing ADC conversions for fetching battery voltage (not so used since most
   battery chips can report that)
2. checking whether we're connect to a usb host or a usb dedicated
   charger (have to kick usb charger detection as per USB Battery Charger
   Spec 1.1
3. Priotizing one or other charger (imagine a system with both usb and
   AC charger support)
4. enabling the charger after figuring out how much current we can draw
   from that supply

And a lot more, I just put these here to show that each case will fall
in one different subsystem as a different driver.

ADC would most likely go to HWMON

charger presence would go to power supply

enabling the charger could be regulator_enable() call.

prioritization of the chargers available could be even based on user
preferences (very unlikely though).

> > > Generally, I'd expect the kernel side to provide a guaranteed *safe*
> > > environment for charging wrt system stability and battery status. A
> > > simple state machine would probably suffice.
> 
> > and wrt SBS, that would mean basically writing a driver for that Smart
> > Batery Charger and the Smart Battery devices creating means for some
> > entity to tell _start_charging_ based on the presence of a power source.
> 
> For me the critical thing is that we ensure that the charger won't be
> left charging at anything more than a trickle charge when there's
> nothing monitoring the battery status.  If the charger can do the SBS
> charger stuff autononmously it can look after itself (but the use of the
> regulator API becomes more questionable for those devices since the
> charger will be doing all the management of the regulators).  If the SBS
> is done entirely in software the kernel at least needs to be able to
> notice the management software exiting and clean up after it, even if
> that's all it is able to do for itself.

ok, now I got your point. Your concerned with the case where a userland
application, say, crashes and the battery is left for overcharging and
overheating.

-- 
balbi
