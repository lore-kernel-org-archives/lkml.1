Return-Path: <linux-kernel-owner+w=401wt.eu-S965304AbXAYNNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965304AbXAYNNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965308AbXAYNNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:13:46 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:32537 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965304AbXAYNNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:13:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=tyvlQ39fBz5azdYg62VZkVIuAKlprPOFAAJJzfQQeaq9R/zLszv0MY2KA534pUWdboj0RIT2vs8nFbY8vWW2+9YSQeGS0cYZ75/p4ZsmnubcIBKkmCFCH7Ym7HCFS9pC77ACCq84BGtWhr7+LD/ykHjMiUoFLDom230LeSu2jxY=  ;
X-YMail-OSG: 4QR2XGMVM1m4Rxafff_I.RRzxalIlhEAyAiclfX4w3N2_6PILOJonDt1ebeIez1K5JFtqmZ4S735kAiJo2XGbrpxi8g74UvovNrkW9w6fdaND3fAXSzVPRnN9sJ1YOQbj2RZE9QhZglsqNx9aq4JFu2kz3ksKup7
From: David Brownell <david-b@pacbell.net>
To: "Hans-Peter Nilsson" <hans-peter.nilsson@axis.com>
Subject: Re: [PATCH] 4/5: Updates to SPI and mmc_spi: mmc_spi updated, kernel 2.6.19
Date: Thu, 25 Jan 2007 05:02:12 -0800
User-Agent: KMail/1.7.1
Cc: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org,
       mikael.starvik@axis.com, spi-devel-general@lists.sourceforge.net
References: <200701250453.l0P4rjHN017189@ignucius.se.axis.com>
In-Reply-To: <200701250453.l0P4rjHN017189@ignucius.se.axis.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200701250502.12738.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Whew, you clearly put enough work into this to get it working!  Thanks.
I look forward to trying it at some point.  (I have some new hardware
in hand that should make that possible.)


On Wednesday 24 January 2007 8:53 pm, Hans-Peter Nilsson wrote:
> (Please CC me on replies, I'm not subscribed to LKML or the SPI list.  Thanks.)
> 
> I see no signed-off-by line on
> <URL:http://www.gossamer-threads.com/lists/linux/kernel/671939#671939>
> or the linked message.  I hope and believe that's just an
> oversight.  David Brownell and Mike Lavender, do you know if all
> is clear and you can sign-off on that patch retroactively?

My 'signed off' was omitted intentionally, because I wasn't
actually submitting the patch.  It needed work.  :)

Can't speak for Mike, but what he seeded me with was a
tarball that worked with a preliminary version of the SPI
stack on a ColdFire uClinux package.   Not a patch.


> Changes from the previously posted version, above:
> 
> Updated to fit 2.6.19.  Nothing big; a few includes, changing
> pr_debug to dev_dbg, adjusting the arguments to one
> supposedly-irq-function and using mrq->data->blksz instead of
> mrq->data->blksz_bits.

Yeah, I have such changes in my updated version too.


> I removed those spi_claim calls; they don't compile.  There's no
> such thing as spi_claim, and no "claim" seems to be needed;
> chip-select is asserted at the start of each spi-message and
> deasserted afterwards.  Maybe this was something that escaped
> from other work-in-progress or remnants of some older interface?

You should have asked for the implementation.  The idea was
that I'd find out who was working with that code!  ISTR posting
both patches a while back.

The claim is necessary, because otherwise there's no way to
ensure that the chipselect stays active in various parts of
the protocol that require it.  A given MMC transaction can
require multiple spi_message invocations, and without the
claim there is no way to _guarantee_ that the chipselect is
not dropped ... the bus could be given for example to some
other SPI device while the MMC-over-SPI driver was figuring
out the next transaction to issue.

 
> I noticed the hard way that mmc_spi_setup_message left most of
> the main message "t" transfer initialized due to a missing "*".
> This'd leave rx_buf and dma addresses with values from the
> previous message...

That could be a problem.  :)

 
> Basing critical timeouts in busy-loops on counting "jiffies" is
> bad, if you're prone to be scheduled out.  When putting a system
> using bitbanged GPIO or "shiftregister" SPI under load, I
> noticed the mmcqd thread being scheduled out (supposedly a
> penalty for being a CPU hog), and it didn't get back in until
> the timeout.  Presto, read and write errors.  Better base the
> timeout on the number of bytes that can theoretically be scanned
> in the time before the timeout.  The real timeout will then be
> much larger on a system under load, but I don't see how that can
> be worse than either playing tricks with the scheduler or
> suffering timeouts.  Alternatively, the timeout could stay
> jiffies-based, but having one more scan when the timeout is
> reached, but that'd be just a little more complicated code (two
> paths; one normal and one normal-after-timeout) for no apparent
> gain.  To somewhat help a system using bitbanged SPI, I tried
> putting schedule() calls right before the read-block and
> write-block mmc_spi_scanbyte calls, when delays are expected
> anyways.  There was no change in performance for a truly
> bitbanged SPI nor shiftregister SPI, but at least I tried that,
> as well as msleep in mmc_spi_busy (see the comment).

Yeah, that timeout mechanism was more of a "write one quick"
than something that handled all the necessary corner cases.

 
> The "stop"-part of an MMC-request wasn't handled.  My only guess
> how this could have worked is that the MMC stack for some reason
> didn't issue read-multiple commands to mmc_spi before.

ISTR not reliably getting to the point where STOP would be issued.
You must have fixed at least some of the issues in the way ... :)


> Sending the SPI_TOKEN_STOP_TRAN after a multi-block write wasn't
> implemented, just as a FIXME.  As for read commands, I guess
> mmc_spi just didn't see them before.

Likewise.  I translated Mike's code to the newer version of the
SPI framework, added a generalizable solution to that claim/release
problem (he had one specific to his ColdFire system), and made it
get part way through enumeration.  At that point, I expected it
would be best if some other folk helped, as you've done!

 
> The MMC_SEND_CID command apparently never had showed before and
> I don't know how card status changes were noticed.

It's been some time since I looked at that, but ISTR that there
was special casing to handle that.  Isn't that one of the commands
that doesn't make sense over SPI, but which the MMC core insists
on issuing anyway?


> The check for data response after (single and multi) block write
> was wrong: the busy-state comes *after* the data-response token,
> not before it.  The data-response token always comes immediately
> after the data write block, and there's no "mandatory delay".
> Maybe this worked because of the slowness of bitbanged SPI
> managed to cover the busy-state of the write with that
> mmc_spi_readbyte commented as "mandatory delay".  Or maybe it
> was the typo inverting the logic for the error check!

Or maybe it didn't get far enough to trip over that stuff ... :)

 
> There was incorrectly mapping of non-successful read_status
> returns to "invalid command".  I can't see how that could be
> right; the caller's supposed to parse the commands.  No, this
> hasn't trigged for me, at least not without other bugs.

The whole error mapping thing needed more attention.  ISTR that
Mike's original code didn't have much fault handling code at
all, and it wasn't clear to me how some of the fault should work.


> Some improvements: I made use of the tx_default function (when
> support is present in the controller/driver) instead of using a
> buffer of ones.  As mentioned in 3/5 (tx_default), it gave a 3%
> improvement for reads with an implementation using DMA.

I'm quite surprised by that ... why would it make any kind of
difference at all?


> I tacked on a status byte or two to the "main" data block
> message, avoiding a mmc_spi_scanbyte read as a short-cut for
> fast cards.  This improves performance on one card about 20% for
> reads and 5% for writes, at least for the DMA implementation.

That sounds good.  As I noted above, I was just trying to get
Mike's code to play in the updated SPI framework, and hadn't
gotten it to fully work yet, much less worried about speed.

 
> There's no need for the extra readbytes at the end of each
> mmc_spi_request.  The mmc_spi_command.dummy serves just fine as
> a delay between commands.  The comment was off regarding
> chip-select; it's deactivated between each transfer anyway.

Which can be a real problem...


> Possibly setting clock to 0 in mmc_spi_set_ios seems like an
> oversight.  It's less than f_min, so I'll say it must be an
> error.

No, the MMC layer was explicitly setting the speed to zero.
That is an idiom used in various frameworks for clock gating.

 
> Now MMC_CAP_MULTIWRITE.  As data.bytes_xfered is correctly
> updated for each successfully transferred block, mmc_spi
> supports it.  Less data for the commands, therefore faster.
> This only matters for MMC cards and writes; see mmc_block.c, but
> there, it's like 2.5-3.5 times faster, using my DMA-based SPI.

MULTIWRITE is generally agreed to be a win on hardware that
supports it.  Just like DMA.  :)

 
> Graceful exit if mmc_spi_probe failed.  It would have helped me
> debugging if it had been there before.  Now less ungraceful.

I don't recall having particular problems there, FWIW.

 
> I don't see a need to have a dev_warn when power management is
> absent.  It might be important for true SD/MMC but for SPI, you
> probably don't waste pins on something static.  I added a
> dev_info with the information instead, including lack of
> cs_inactive support.  It's nice to have one anyway, as a notice
> that mmc_spi is successfully initialized.

Fair enough.  The issue is more lack of a hard reset capability
than a power management thing; the reset being a side effect of
powering the card on/off.


> Future improvements:
> A rewrite.  Not only for the new MMC framework (I haven't looked
> at it so I don't know what's involved)

Me either.  I saw Pierre's note though.  When is that expected
to be ready for use, do you know?


> but also because this 
> code seems a little too, um, experimental to fit my taste.
> Functions go behind each other's back and look at and change
> data; they seem to "fix up" the result of each others work.
> It doesn't help maintenance.

I figured the first order of business was to have the driver
work.  I'm not sure what exactly you mean by "behind each other"
but ISTR noticing some oddities coming down from mmc_block.
Maybe the new framework will resolve those issues.

 
> Support SDIO and SDHC.  SDIO fails over already when mmc_spi
> sees CMD5 and reports that it's invalid.  This is mostly about
> mapping commands and reply-types, but also support for the SDIO
> interrupt line.  Ok, I guess this can't be properly defined
> before the SDIO and SDHC support at the MMC layer is clear. :)

I guess you're right about that.  Of course, supporting the
interrupt line should be easy enough; SPI devices have always
been used with IRQs, unlike for example I2C (where the devices
have, but the Linux drivers couldn't portably do so).

 
> Better API.  The card-detect API should *at least optionally* be
> like the get_ro function. 

I basically looked around at the "card socket" abstractions I
found, and used the one from PXA.  Note that "get_ro" is not
interrupt driven ... and normally I'd want card detect to work
by irq.  Admittedly it's common that input GPIOs can be used
in both modes, but some systems only deliver IRQs and don't
provide a driver-visible card detect signal.  (And you suggest
below that you may have the converse problem, an IRQ-incapable
GPIO signal that must be polled.)


> I have a GPIO pin connected to the 
> card-detect pin, so I can see whether there's (presumably) a
> card in the single socket on my board.  At present, I have to
> implement a self-arming delayed-work-function, where I keep
> track of the state of that pin, and when changed, call that
> interrupt function passed at the init call. 

Can't your GPIO pin trigger IRQs too though?  That's the normal
way to use that callback:  from the IRQ handler.  See how it's
done in arch/arm/mach-pxa/lubbock.c for one example.


> That call just 
> passes the information that *something* has changed.  Ok, I
> guess this is a gripe about the MMC driver API more than
> mmc_spi.

I think so.  The MMC framework notices "no card" when nothing
responds.


> The mmc_spi_scanbyte function should optionally be 
> able to be performed by the low-level glue: it's easy to imagine
> synchronous serial HW that can read and throw away data until a
> certain data is/is not seen.  Or perhaps an interrupt line
> connected to the miso pin, which while receiving data to a
> throw-away buffer (known to the mmc_spi layer so data can be
> scavenged) can signal that data no longer is zero-only (busy) or
> one-only (delay before a data block being read).  Something like
> that'd get rid of the really annoying part of the CPU-hogging!

Yes, that was a "look at this later, once it basically works"
kind of issue.  Once the upper layers behave, that was the other
lower level issue that needed attention.  (The first being the
chipselect claim/release model.)


> Finally a question: why set f_min to 150 KHz?  I didn't change

I wouldn't know; the code I'm looking at says 125 KHz.  :)


> it, because perhaps there's a good reason and I realize the
> board-code, calling mmc_spi, can set it as fits.  A more
> standard choice would have been 400 KHz; the initially highest
> possible.  There must be a good story behind that, perhaps
> something to abbreviate in a comment. ;)

ISTR having some document specifying 125 KHz as the max possible
until later.

- Dave


