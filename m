Return-Path: <linux-kernel-owner+w=401wt.eu-S1759143AbZFWWol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143AbZFWWol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbZFWWoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:44:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40713 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754356AbZFWWod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:44:33 -0400
Date: Tue, 23 Jun 2009 23:44:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Richard A. Smith" <richard@laptop.org>
Cc: Andres Salomon <dilinger@collabora.co.uk>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 3/5] power_supply: add a TRICKLE_CHARGING status, and
	add it to the olpc driver
Message-ID: <20090623224434.GB16188@opensource.wolfsonmicro.com>
References: <20090622234607.11f61bec@mycelium.queued.net> <20090623103717.GH5422@sirena.org.uk> <4A412CC0.6050500@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A412CC0.6050500@laptop.org>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 03:28:00PM -0400, Richard A. Smith wrote:
> Mark Brown wrote:

>> I'd also be tempted to do this the other way around and add a fast
>> charge status; certainly in embedded cases trickle charging is more of a
>> default state since it requires less incoming power (important if you're
>> using USB) and there's less risk of damage to the battery.

> On the OLPC the trickle charging really is a trickle rather than just a
> slower charge rate.  To fully charge a XO battery at trickle would take
> about 150 hours.

That's exactly the same in the more embedded case, the only difference
is that the batteries being charged are bigger in your case.  It still
has a major impact on overall charge times that makes people unhappy,
it's just easier to get a situation where you need to stay in trickle
charge due to other demands on the system.

> Trickle is enabled when the battery voltage has dropped outside of the
> normal charging envelope.  In that zone the battery voltage curve is
> very non-linear so even small currents will make the voltage rise
> quickly.  Once the voltage hits the safe zone regular the normal
> charging rate is enabled.

Indeed; the other thing is that when the battery is very drained the
trickle charge does less damage than a fast charge would.

> I don't have any strong feelings about what nomenclature we use to
> describe it.  I just want it to be a separate identifiable state (or
> status).  In (OLPCs) normal charging/discharging cycle the trickle zone  
> should not be reached so its an indication that you are outside the  
> envelope.  If it shows up repeatedly then its an indication that  
> something is amiss.

As far as the naming goes I really would rather see "Trickle charging"
and "Fast charging" as extra states.  Charging could still be used for
when the driver doesn't know or for whatever would be classed as normal.

I looked at this when I submitted the WM8350 PMU driver but decided that
the ABI issues were more trouble than I wanted to deal with at the time
and I'd try to revist it for the next chip.

> I would prefer that the stuff returned from sysfs is unique, short yet  
> descriptive.  It helps if I don't have to grovel around in multiple  
> locations and do boolean logic to come up with what state of the  
> charging profile is active.

The problem here is that anything which is already looking at these
statuses is going to have to be able to cope with the information too.
In the OLPC case it probably doesn't matter so much if they get
confused since this is an unusual case but in the embedded case it's
much more normal (and more likely to happen while a user interacts with
the device since that tends to burn power which is a problem if you're
charging off USB).

A separate file with the detailed information would sidestep this since
it's a new interface.  I'm not strongly opposed to adding the new states
but I do think it's worth considering other ways of doing this.
