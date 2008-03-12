Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbYCLVxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbYCLVxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYCLVww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:52:52 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:38768 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752231AbYCLVwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:52:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Ko0KN7SHbOw7vMEImFDqirboEuLY5xrl+uOqT5C1Uf7tLlqeAC/tOEyyOi7pWyc4yBZ/a5lbHPmobyYPyM8DZ60uxP5UgKAHtqt9lGbT1NsAKJqSBHLv7dXYoFyoJ/ZzEKyVpNA3hDeZIZAqk2yadfb+8cERdyYIfWrV16HDN4I=  ;
X-YMail-OSG: cNzpGEIVM1k2RRB4Tw9cQwVeiGBGMB8hm1d9V92pUP9h6Y0QVuHYMMwXTNOq4Zf7ZnW6_xdvCrW8SuguBwbMr2WjToSgqc37iWlviATk8CeJ0K1uDg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Date: Wed, 12 Mar 2008 13:52:46 -0800
User-Agent: KMail/1.9.6
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803120031.59742.david-b@pacbell.net> <20080312130216.GA26583@rakim.wolfsonmicro.main>
In-Reply-To: <20080312130216.GA26583@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803121452.47600.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, Mark Brown wrote:
> On Tue, Mar 11, 2008 at 11:31:59PM -0800, David Brownell wrote:

> > > This is pretty much the model that is currently implemented.
> 
> > Then the tree should be a bit more of a first class citizen,
> > IMO, like it is in the clock framework.  Both clock and power
> > distribution have similar hardware infrastructure; the software
> > interfaces can be more similar than it is.
> 
> What do you see as being missing in the externally presented interface?

It's not *presented* as a tree of power domains, and it's not clear
that's the intended model.  Plus, what Liam said about the names
being global, not local/logical.


> As far as I can see the main difference between the two APIs on this
> front is that the regulator API explicitly separates the interface used
> to set up the tree from the interface used by consumers.

I'd say that differently.  The clock framework *has* no such
implementor/setup support ... which has caused problems for
many new implementations.  I'm unclear on the status of some
recent patches [1] from Dmitry Baryshkov to help address that.


> > > A given 
> > > power management IC can have several regulators (that is, things which
> > > have regulator IDs registered and can supply power). 
> 
> > Those are the outputs.  Are the inputs visible?  Like batteries
> > or loosely regulated DC voltages ... drivers/power/* stuff.
> 
> Not as part of this API at present unless the input is another
> regulator, though obviously drivers could set up associations in the
> device tree.

That may not be an issue; it's something which can be provided
by a PMIC driver, in any case.  If they both catch on, maybe
some integration will become useful.


> > > Each regulator can 
> > > have multiple clients bound to it (that is, things that have called
> > > regulator_get() and can consume power). 
> 
> > In the clock framework, clk_get_parent() exposes one part of this
> > relationship.  But there's also the association of logical clock
> > names to devices ... 
> 
> Right, though that does tend to break down when clocks go off chip - the
> association of devices with symbolic names is generally only done for
> things that are hard wired as part of the same chip since the devices
> are registered along with the clock.   Other clocks generally just get
> the name that the chip documents for them.  Indeed, looking around the
> tree almost all current use of clock API appears to be for on-SoC devices.

That's because there's essentially no way to plug in other clocks
in an arch-neutral way ... so the only implementations of clocks
are arch-specific!!  This is at least partly addressed by [1], but
platforms would also need to adopt that implementation framework.
So far the only patches showing that are on PXA and SA-1100, which
hardly present challenges in that area ... compared to e.g. OMAP.

Specifically, it's awkard even to do simple things like binding
one of a SOC's programmable clocks onto an off-chip audio codec
or video controller; that's got to go through platform_data or
something similar.  And plugging in external clock generators ...
not portably, no way!

You seem to be aiming to not recreate those problems, which is good.


> What might be nicer would be an API that platform code could use to map
> regulators to device/name tuples.  The core could then search these when
> a client calls regulator_get() (either by maintaining a separate table
> or by setting up virtual regulators).

Right.


> > > While the leaf enable/disable operations do happen at the client level
> > > the core reference counts the enabled clients to control enabling of the
> > > actual supply.
> 
> > Right.  But what I was getting at was that there can be
> > domains hooked up like:
> 
> >     Power --> Regulator -+-> Switch-1 -+-> Switch-2 --> [Dev-A]
> >                          |             |
> >                          |             +-> [Dev-B], [Dev-C]
> >                          |
> >                          +-> [Dev-D], [Dev-E]
> 
> > Those switches can be as simple as a MOSFET under GPIO control.
> 
> > And I'd expect power domains under Linux to be able to represent
> > all of those ... including software controls wherevever they're
> > practical, which in this case might include everything except the
> > battery input.
> 
> I don't see a particular problem fitting this into the structure of
> the current API - to me the switches inflexible regulators with no
> configurable voltage control of their own.

To me, they aren't regulators at all.  :)

I see power domains as having various capabilities.  Most of them
support on/off switching ... else there's no reason to list them
(except for the root nodes of the tree).  Some are programmable,
and suppport configuring the voltage or current drive.

That maps exactly to the clock tree model.  Not all clocks can
support clk_set_rate() or clk_set_parent().  Not all power domains
can support a set_voltage() call, etc.

This just suggests a bit of refocusing of your current code,
so it'll be more widely applicable.

- Dave

[1] http://marc.info/?l=linux-kernel&m=120237673527430&w=2
    http://marc.info/?l=linux-kernel&m=120237674327434&w=2


