Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbYCLHcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbYCLHcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYCLHcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:32:08 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:45702 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750972AbYCLHcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:32:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mnYz5q79qlHsezceqGkqPbt1wBvaA4EmSwt5P1EcTazbsBFzqWZNlY504jaKcgBacIojLCCLamYeTI2teqGVuFNA/eey4OAIY/TwmBP24Au4Krxt+4zDsLR7RgEgrBtrd0KwN+7TM6M9aLbC8642csypTb5HRRvDS50ESj3eLX0=  ;
X-YMail-OSG: 8y34KF0VM1kRwsQEbg39U82qLuzQO6cWsoMogU9O5NJ7Hp5L
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Date: Tue, 11 Mar 2008 23:31:59 -0800
User-Agent: KMail/1.9.6
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803111525.10717.david-b@pacbell.net> <20080312000044.GA30908@sirena.org.uk>
In-Reply-To: <20080312000044.GA30908@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803120031.59742.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008, Mark Brown wrote:
> On Tue, Mar 11, 2008 at 02:25:10PM -0800, David Brownell wrote:
> > On Tuesday 11 March 2008, David Brownell wrote:
> 
> > > How would you see your notion of a "regulator" (client?)
> > > relating to a "power domain"? ?My first thought is that
> > > there's a one-to-one correspondence but they may not be
> 
> > Actually, it's clearly not one-to-one.  Counter-example:
> > a 3V3 regulator powering one of a SOC's I/O power domains,
> > which is managed by a digital switch.  That same regulator
> > can power several I/O devices too.  It may even feed a 1V8
> > regulator.
> 
> It's also common for devices to have multiple power inputs which can be
> run separately if required but which are normally tied together unless
> there is a special reason to do so.

I've not happened across that idiom.  Is that common on
particular larger systems?


> > So the relationship is probably that regulators define a
> > domain ... but such domains can be subdivided.  There's
> > a tree; it's probably more shallow than the clock tree.
> 
> This is pretty much the model that is currently implemented.

Then the tree should be a bit more of a first class citizen,
IMO, like it is in the clock framework.  Both clock and power
distribution have similar hardware infrastructure; the software
interfaces can be more similar than it is.


> A given 
> power management IC can have several regulators (that is, things which
> have regulator IDs registered and can supply power). 

Those are the outputs.  Are the inputs visible?  Like batteries
or loosely regulated DC voltages ... drivers/power/* stuff.


> Each regulator can 
> have multiple clients bound to it (that is, things that have called
> regulator_get() and can consume power). 

In the clock framework, clk_get_parent() exposes one part of this
relationship.  But there's also the association of logical clock
names to devices ... 


> It is also possible to tell the 
> core that one regulator supplies another - if this is done then the core
> will take care of ensuring that parents are enabled when their children
> need them.

Right.  clk_enable()/clk_disable() uses a refcounting model for
that stuff; similar.

 
> > And enable/disable primitives probably map best to power
> > domains, not all of which are entire regulators.
> 
> While the leaf enable/disable operations do happen at the client level
> the core reference counts the enabled clients to control enabling of the
> actual supply.

Right.  But what I was getting at was that there can be
domains hooked up like:

    Power --> Regulator -+-> Switch-1 -+-> Switch-2 --> [Dev-A]
                         |             |
                         |             +-> [Dev-B], [Dev-C]
                         |
                         +-> [Dev-D], [Dev-E]

That is:  five power domains, one regulator:

  - Input power, e.g. a battery
  - Regulator output, maybe configurable
  - Devices D and E share a domain coupled to the regulator
  - Devices B and C share a switched domain
  - Device A has its own switched domain

Those switches can be as simple as a MOSFET under GPIO control.

And I'd expect power domains under Linux to be able to represent
all of those ... including software controls wherevever they're
practical, which in this case might include everything except the
battery input.

- Dave

