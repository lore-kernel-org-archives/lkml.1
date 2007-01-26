Return-Path: <linux-kernel-owner+w=401wt.eu-S1030731AbXAZPqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030731AbXAZPqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030758AbXAZPqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:46:53 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:56464 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030731AbXAZPqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:46:52 -0500
Date: Fri, 26 Jan 2007 16:45:54 +0100
Message-Id: <200701261545.l0QFjsjj004194@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: david-b@pacbell.net
CC: hans-peter.nilsson@axis.com, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
In-reply-to: <200701250502.12738.david-b@pacbell.net> (message from David
	Brownell on Thu, 25 Jan 2007 05:02:12 -0800)
Subject: Re: [PATCH] 4/5: Updates to SPI and mmc_spi: mmc_spi updated, kernel 2.6.19
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Brownell <david-b@pacbell.net>
> Date: Thu, 25 Jan 2007 05:02:12 -0800

> > The MMC_SEND_CID command apparently never had showed before and
> > I don't know how card status changes were noticed.
> 
> It's been some time since I looked at that, but ISTR that there
> was special casing to handle that.  Isn't that one of the commands
> that doesn't make sense over SPI, but which the MMC core insists
> on issuing anyway?

Nope, regular command, regular "register".  It contains other
stuff than the assigned card number, like manufacturer ID,
product name and product revision, see 5.2 in the simplified
standard.  There are variants that match what you say, maybe you
mean ALL_SEND_CID.

> > Some improvements: I made use of the tx_default function (when
> > support is present in the controller/driver) instead of using a
> > buffer of ones.  As mentioned in 3/5 (tx_default), it gave a 3%
> > improvement for reads with an implementation using DMA.
> 
> I'm quite surprised by that ... why would it make any kind of
> difference at all?

Time to set up tx DMA versus not doing anything, I guess 1-byte
buffers (DMA all the time or bust) matter the most.

> > There's no need for the extra readbytes at the end of each
> > mmc_spi_request.  The mmc_spi_command.dummy serves just fine as
> > a delay between commands.  The comment was off regarding
> > chip-select; it's deactivated between each transfer anyway.
> 
> Which can be a real problem...

Perhaps define it as active whenever it's "claimed", and don't
deactivate it for each command.

> > Possibly setting clock to 0 in mmc_spi_set_ios seems like an
> > oversight.  It's less than f_min, so I'll say it must be an
> > error.
> 
> No, the MMC layer was explicitly setting the speed to zero.
> That is an idiom used in various frameworks for clock gating.

Dunno if that idiom maps well.  The clock is off between
transfers anyway.

> > Graceful exit if mmc_spi_probe failed.  It would have helped me
> > debugging if it had been there before.  Now less ungraceful.
> 
> I don't recall having particular problems there, FWIW.

If everything works, error handling is unnecessary. :)

> > Better API.  The card-detect API should *at least optionally* be
> > like the get_ro function. 
> 
> I basically looked around at the "card socket" abstractions I
> found, and used the one from PXA.  Note that "get_ro" is not
> interrupt driven ... and normally I'd want card detect to work
> by irq.

IMHO it's so rare that cards are de/inserted that it'd be a
waste of interrupt lines.

> > I have a GPIO pin connected to the 
> > card-detect pin, so I can see whether there's (presumably) a
> > card in the single socket on my board.  At present, I have to
> > implement a self-arming delayed-work-function, where I keep
> > track of the state of that pin, and when changed, call that
> > interrupt function passed at the init call. 
> 
> Can't your GPIO pin trigger IRQs too though?

Not this line.  Only the expensive ones, saved for more
important work. ;)

> > A more
> > standard choice would have been 400 KHz; the initially highest
> > possible.  There must be a good story behind that, perhaps
> > something to abbreviate in a comment. ;)
> 
> ISTR having some document specifying 125 KHz as the max possible
> until later.

Name chapter and verse?  I see "4.4 Clock Control" says 100-400
KHz and SanDisk's OEM MMC v1.3 document referred to before, says
in "Table 3-7 Bus Timing" max 400 KHz.

brgds, H-P
