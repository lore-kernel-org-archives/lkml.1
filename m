Return-Path: <linux-kernel-owner+w=401wt.eu-S1161040AbXAZPWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161040AbXAZPWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161042AbXAZPWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:22:33 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:55600 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161040AbXAZPWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:22:32 -0500
Date: Fri, 26 Jan 2007 16:21:45 +0100
Message-Id: <200701261521.l0QFLjlv003816@ignucius.se.axis.com>
From: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
To: david-b@pacbell.net
CC: hans-peter.nilsson@axis.com, linux-kernel@vger.kernel.org,
       mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net
In-reply-to: <200701250505.42798.david-b@pacbell.net> (message from David
	Brownell on Thu, 25 Jan 2007 05:05:42 -0800)
Subject: Re: 2/5: Updates to SPI and mmc_spi: clock with cs inactive, kernel 2.6.19
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Brownell <david-b@pacbell.net>
> Date: Thu, 25 Jan 2007 05:05:42 -0800

> On Wednesday 24 January 2007 8:50 pm, Hans-Peter Nilsson wrote:
> > The gotcha is that the SPI framework didn't have a way to
> > express transfers with chip-select inactive.  Sure, you can set
> > chip-select to inactive for a period of *time*, but never while
> > also toggling the clock.  So here's an implementation for that.
> 
> Just so we don't lose count here:  this is the *third* example of
> an SPI protocol tweaking option that seems to be needed just to
> support an MMC-over-SPI stack:
> 
>  - Claiming the SPI bus so that chipselect can stay high even
>    between spi_message interactions (although you seemed not to
>    run into that one);

You mentioned this is the reason for the spi_get_exclusive-patch
you sent privately (thanks).  I hadn't seen that, and from my
reading of the standard I read "bus transaction" (their wording
for what's between cs deactivation) as a single byte or at least
send and reply part of a command as separate "bus transactions".
Yeah, there's only one SPI device on my bus.  To simulate other
devices on the bus, chatting along when the SD/MMC SPI device
has chip-select inactive, I experimented with sending "random"
stuff while in the chip-select function like so:

(in chip_select_function at the end, added)
...
        if (value != BITBANG_CS_ACTIVE)
                send_random(spi);
}

void send_random(struct spi_device *spi)
{
        u8 buf[256];
        int i;

        static int value = 0;
        static int n = 0;

        struct spi_transfer t;
        memset (&t, 0, sizeof t);
        t.tx_buf = buf;
        t.len = ++n;

        for (i = 0; i < n; i++)
                buf[i] = value++;

        if (crisv32_spi_sser_dma_txrx_bufs(spi, &t) != n)
                panic ("badness\n");

        if (n == sizeof buf)
                n = 1;
}

... and *now* I see it. ;-) No card works.  Hm.  Modulo bugs in
the above, I agree you need that claim-stuff if there's more
than one device.  Still, I guess that's actually a rare
configuration.

>  - Efficiency in the routine "poll for status" operation, where
>    data must be read over MISO (CS high) until 0xff bytes stop;

That's for read.  For write, it's until the 0x0 bytes stop.  But
this is a performance feature, not critical for basic function.

>  - This issue, where a deselected device must be clocked.

I retract this patch and suggestion, given your later
suggestion.  (Not worthwhile as a feature.)

> I knew that not every SPI controller driver would be able to
> support that particular stack...

Not all are important as long as mmc_spi provides fallback
solutions, or what works all the time with some cards.

> > Also, some SPI drivers seem 
> > to implement the chip-select function as optional, a clear hint
> > to this being optional IMHO.
> 
> There's no "chip select" feature in the API.  It's only part of
> the protocol described by messages delivered to the controller
> driver.  Don't confuse the "bitbang" framework (which works with
> more than just bitbanged hardware, of course) with the API; it's
> just an implementation aid, and not one that all implementors
> would choose to use.

Let me rephrase: some controllers (yes, they are using the
bitbang framework but that's beside the point) do not deactivate
chip-select; they may not have that signal programmable.
Therefore, some are using SPI as if chip-select is an optional
part of the function, so maybe it should be left as that.

brgds, H-P
