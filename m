Return-Path: <linux-kernel-owner+w=401wt.eu-S965653AbXA0And@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965653AbXA0And (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965582AbXA0AnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:43:04 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:23629 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752165AbXA0AnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:43:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qLsueolZu63HIkmOH+ynSTtr7p5DtODoqB4xK7KAD8J1G+P1trlV7XOpDtcZVbcTyItr4BDeapYVk7eZ4L83h5zdtPH7xJ+hdEwWhCjr5AxsE2f7ahvt2HhPBpgh4dn2FC7dUXIwgbR0u69LDineFr5iHpGSImuqNXpezirFBZs=  ;
X-YMail-OSG: l3.PNf4VM1nXja.TZpXFeKdm8gqWcbOJqYx7rsKCYOsLRzWqJ7BpJXsN9.cag.YQQf90aJQ0tHo2hHU6aBMJ7rR03Ze14UlsbUFjFGT1luZrmUQacrTeETjqDjCW3xMCrPmZhjYuakhy8BB.PGx4PmanJZMCrqmY
From: David Brownell <david-b@pacbell.net>
To: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Subject: Re: 2/5: Updates to SPI and mmc_spi: clock with cs inactive, kernel 2.6.19
Date: Fri, 26 Jan 2007 15:31:10 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
References: <200701261521.l0QFLjlv003816@ignucius.se.axis.com>
In-Reply-To: <200701261521.l0QFLjlv003816@ignucius.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701261531.11141.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 7:21 am, Hans-Peter Nilsson wrote:
> > From: David Brownell <david-b@pacbell.net>

> > Just so we don't lose count here:  this is the *third* example of
> > an SPI protocol tweaking option that seems to be needed just to
> > support an MMC-over-SPI stack:
> > 
> >  - Claiming the SPI bus so that chipselect can stay high even
> >    between spi_message interactions (although you seemed not to
> >    run into that one);
> 
> You mentioned this is the reason for the spi_get_exclusive-patch
> you sent privately (thanks).  I hadn't seen that, and from my
> reading of the standard I read "bus transaction" (their wording
> for what's between cs deactivation) as a single byte or at least
> send and reply part of a command as separate "bus transactions".
> Yeah, there's only one SPI device on my bus.  To simulate other
> devices on the bus, chatting along when the SD/MMC SPI device
> has chip-select inactive, I experimented with sending "random"
> stuff while in the chip-select function like so:
> 
> ...
> 
> ... and *now* I see it. ;-) No card works.  Hm.  Modulo bugs in
> the above, I agree you need that claim-stuff if there's more
> than one device.  Still, I guess that's actually a rare
> configuration.

The issue is generic.  It shows up with JTAG (which you can
view as an application of SPI) as well as various other tools
I've seen.  As for rare ... hard to say.  I don't design boards,
and the ones where I look at SPI support have real MMC hardware
so they don't need mmc-over-spi.


> >  - Efficiency in the routine "poll for status" operation, where
> >    data must be read over MISO (CS high) until 0xff bytes stop;
> 
> That's for read.  For write, it's until the 0x0 bytes stop.  But
> this is a performance feature, not critical for basic function.

Right.

 
> >  - This issue, where a deselected device must be clocked.
> 
> I retract this patch and suggestion, given your later
> suggestion.  (Not worthwhile as a feature.)

OK, fine.  Temporary toggling of chipselect polarity ... that
doesn't _quite_ feel like a hack!

 
> > There's no "chip select" feature in the API.  It's only part of
> > the protocol described by messages delivered to the controller
> > driver.  Don't confuse the "bitbang" framework (which works with
> > more than just bitbanged hardware, of course) with the API; it's
> > just an implementation aid, and not one that all implementors
> > would choose to use.
> 
> Let me rephrase: some controllers (yes, they are using the
> bitbang framework but that's beside the point) do not deactivate
> chip-select; they may not have that signal programmable.

I think those controllers are best viewed as not talking SPI.

Or alternatively, as being so bare-bones that they expect to
have chipselects managed outside the controller.  (Which is not
a bad approach after all.)

- Dave

