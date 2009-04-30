Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbZD3UvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbZD3UvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 16:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZD3UvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 16:51:05 -0400
Received: from ru.mvista.com ([213.79.90.228]:4849 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753104AbZD3UvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 16:51:04 -0400
Date: Fri, 1 May 2009 00:51:01 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/3] powerpc/86xx: Add MMC SPI support for MPC8610HPCD
	boards
Message-ID: <20090430205101.GA14902@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090404192826.GC12183@oksana.dev.rtsoft.ru> <49D7FD94.2040001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <49D7FD94.2040001@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late response,

On Sat, Apr 04, 2009 at 05:38:44PM -0700, H. Peter Anvin wrote:
> Anton Vorontsov wrote:
> > This patch adds spi and mmc-spi-slot nodes, plus a gpio-controller
> > for PIXIS' sdcsr bank that is used for managing SPI chip-select and
> > for reading card's states.
> > 
> > Note that spi-max-frequency is lowered since at high frequencies SD
> > cards don't work reliably (there is some problem with the chip select
> > line, it's probably quite slow because it's routed via PIXIS).
> > 
> > Previously there was a work around: we didn't use chip-select line
> > at all, but some cards don't like that, so we'd better use the low
> > frequency.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> 
> I have to admit being somewhat confused.  The CS# line is pulled low and
> stays low for the duration of a command, so it shouldn't affect the SPI
> frequency, only the delay between commands.

Yes. Regarding delay between commands, inserting a 50 ns delay after
asserting CS makes the things work, so proves that PIXIS GPIO lines
are a bit slow and that causes SD malfunctions.

> You're saying "some cards don't like not using the CS# line" ... in
> particular, I know there are hardware devices which toggle the clock at
> low frequency (< 400 kHz) for a while (I think the minimum is 88 clocks
> or so) and then permanently assert the CS# line

Yes, but before that, CS should be de-asserted, otherwise things
won't work, like this:

mmc_spi spi32766.0: mmc_spi: power up (21)
mmc0: clock 400000Hz busmode 2 powermode 2 cs 1 Vdd 21 width 0 timing 0
mmc_spi spi32766.0: mmc_spi: power on (21)
mmc0: starting CMD0 arg 00000000 flags 000000c0
mmc_spi spi32766.0:   mmc_spi: CMD0, resp R1
mmc0: req done (CMD0): 0: 00000001 00000000 00000000 00000000
mmc0: starting CMD8 arg 000001aa flags 000002f5
mmc_spi spi32766.0:   mmc_spi: CMD8, resp R3/R4/R7
mmc_spi spi32766.0:   ... CMD8 response SPI_R3/R4/R: resp 0017 ffffffff
mmc0: req done (CMD8): -22: 00000017 ffffffff 00000000 00000000
mmc0: starting CMD5 arg 00000000 flags 000002e1
mmc_spi spi32766.0:   mmc_spi: CMD5, resp R3/R4/R7
mmc_spi spi32766.0:   ... CMD5 response SPI_R3/R4/R: resp 0017 ffffffff
mmc0: req done (CMD5): -22: 00000017 ffffffff 00000000 00000000
mmc0: starting CMD55 arg 00000000 flags 000000f5
mmc_spi spi32766.0:   mmc_spi: CMD55, resp R1
mmc_spi spi32766.0:   ... CMD55 response SPI_R1: resp 0007 00000000

So we can't just assert the CS line, inserte SD card and expect
to work.

> before giving the
> starting CMD0.  Even so, the CMD0 is supposed to be sent at < 400 kHz
> since the card will still be in open drain mode at that point.

> Does that disagree with your observations?  If so, I'd be really
> interested to find out what you have seen in more detail, as it adds to
> the understanding of MMC/SD cards in the field.

With CS toggling enabled and without 50 ns delay after CS
assertion, everything is fine until we switch to high frequency:

mmc0: clock 25000000Hz busmode 2 powermode 2 cs 1 Vdd 20 width 0 timing 0
mmc_spi spi32766.0: mmc_spi:  clock to 25000000 Hz, 0
mmc0: new SD card on SPI
mmc0: starting CMD16 arg 00000200 flags 00000095
mmc_spi spi32766.0:   mmc_spi: CMD16, resp R1
mmc0: req done (CMD16): 0: 00000000 00000000 00000000 00000000
mmcblk0: mmc0:0000 SD01G 982 MiB
 mmcblk0:<7>mmc0: starting CMD18 arg 00000000 flags 000000b5
mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
mmc0:     CMD12 arg 00000000 flags 0000049d
mmc_spi spi32766.0:   mmc_spi: CMD18, resp R1
mmc_spi spi32766.0:     mmc_spi: read block, 512 bytes
mmc_spi spi32766.0:     mmc_spi: read block, 512 bytes
mmc_spi spi32766.0: read - crc error: crc_val=0x00ff, computed=0x0000 len=512
mmc_spi spi32766.0: read status -84
mmc_spi spi32766.0:   mmc_spi: CMD12, resp R1B


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
