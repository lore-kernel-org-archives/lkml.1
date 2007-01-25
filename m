Return-Path: <linux-kernel-owner+w=401wt.eu-S965312AbXAYNOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312AbXAYNOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965299AbXAYNNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:13:49 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:32594 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965152AbXAYNNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:13:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=4HxLAZsG/AyqKYG1rE4F5cugp2SqylY7lGbZqgBBMsrf94lqgbW/m6d4BsKJ9/ON0ba326nJkKGU8KebGVDQLwWUk0aVw0g6Z15iXmiCZzb/bvUoTA+o7KvHT7sXUba5sV3obgS5YYKdOZyn2H47V/sovCcDBEj6pq8UgtLkCJo=  ;
X-YMail-OSG: ebgIM7UVM1kWCcTC1LSg2uyttC4MNocabts3ovGucYWiaFXTa7WgGn.b9sL7TwnWtP2kZ.xw.HR3n_qr002rADy9SziGVrtKdvurC1odscAybwvVlHe0n0L8CpXz3qM-
From: David Brownell <david-b@pacbell.net>
To: "Hans-Peter Nilsson" <hans-peter.nilsson@axis.com>
Subject: Re: 2/5: Updates to SPI and mmc_spi: clock with cs inactive, kernel 2.6.19
Date: Thu, 25 Jan 2007 05:05:42 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
References: <200701250450.l0P4oe3I017089@ignucius.se.axis.com>
In-Reply-To: <200701250450.l0P4oe3I017089@ignucius.se.axis.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200701250505.42798.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 January 2007 8:50 pm, Hans-Peter Nilsson wrote:
> +                * some cards seemed happier if they were initialized first
> +                * by the native MMC stack, not SPI ... and in other cases
> +                * rmmod/modprobe of mmc_spi helped the card work better,
> +                * even without power cycling
> +                *
> +                * FIXME find out what that important state is, which is
> +                * not reset here... and makes robustness problems
> 
> I think I've spotted the problem, or at least a problem with a
> solution that fits the description.

Good, that was nasty ...

> 	What's missing is "at least 
> 74 SD clocks to the SD card with keeping CMD line to high. In
> case of SPI mode, CS shall be held to high during 74 clock
> cycles" (from Section 6.4.1, in "Simplified Physical Layer
> Specification 2.0").  This is to happen before sending CMD0.  I
> have only one card (of 7) where this fails, a Viking Interworks
> 256 MB card.  It matches the description in the comment; it
> never initializes, gives invalid replies (with bit 7 set)
> without this, but works fine with it.

That rings a bell.


> The gotcha is that the SPI framework didn't have a way to
> express transfers with chip-select inactive.  Sure, you can set
> chip-select to inactive for a period of *time*, but never while
> also toggling the clock.  So here's an implementation for that.

Just so we don't lose count here:  this is the *third* example of
an SPI protocol tweaking option that seems to be needed just to
support an MMC-over-SPI stack:

 - Claiming the SPI bus so that chipselect can stay high even
   between spi_message interactions (although you seemed not to
   run into that one);

 - Efficiency in the routine "poll for status" operation, where
   data must be read over MISO (CS high) until 0xff bytes stop;

 - This issue, where a deselected device must be clocked.

I knew that not every SPI controller driver would be able to
support that particular stack...

 
> I made this functionality optional, with the updated mmc_spi
> driver trying anyway if the spi host doesn't provide the
> function.  So, no SPI drivers require updating, unless they
> really want to work with mmc_spi flawlessly with all cards.

At a first glance, this seems like a reasonable approach.
Let me think about it a bit.  The ability for a controller
driver to advertise a capability is reasonable, but so far
it hasn't been used with SPI.  (It ought to suffice just to
reject unsupported requests, modulo the issue of trying to
sort out exactly what was unsupported.)


> I initially thought the function important enough to warrant
> mandatory implementation for all SPI drivers, but it hasn't been
> needed before, so I reconsidered.

Right.  Unfortunately there's not a lot of protocol tweaking
support we can currently expect to be "mandatory".  Testing
such requirements would be problematic too.


> Also, some SPI drivers seem 
> to implement the chip-select function as optional, a clear hint
> to this being optional IMHO.

There's no "chip select" feature in the API.  It's only part of
the protocol described by messages delivered to the controller
driver.  Don't confuse the "bitbang" framework (which works with
more than just bitbanged hardware, of course) with the API; it's
just an implementation aid, and not one that all implementors
would choose to use.


> I looked at the existing drivers 
> and went as far as writing proof-of-concept patches for them,
> but as I can't test them, I'll just stop there and call that a
> feasibility study.  The spi_bitbang looked like it could have
> always can_cs_inactive = 1, but then I noticed what
> spi_mpc83xx.c does in its mpc83xx_spi_chipselect() (register
> writes only on BITBANG_CS_ACTIVE supposedly controlling the
> clock) and so I think setting the capability is better be left
> to the respective caller (typically just before its call to
> spi_bitbang_start), and just adjust the various chipselect calls
> i spi_bitbang.

Sounds fair. 

- Dave
