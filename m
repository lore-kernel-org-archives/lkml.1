Return-Path: <linux-kernel-owner+w=401wt.eu-S1761755AbYBWChY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761755AbYBWChY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 21:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbYBWChG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 21:37:06 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:27714 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754023AbYBWChE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 21:37:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GehUURNrciDg3t2nGnTWCP52AvX9Z9QCl3b/aUMIHDUqsPH0HMPhnmB8vut18eRLBi7YJ5ePdga71YGjklqC91U3JyOEGWYpksxBlv91v0UhQo56c9sZAIi2zSGeCmC/l1WcIiLhFsBApXTkF1k4yCBjKyEnM65F4E4jkAWJsP0=  ;
X-YMail-OSG: E8g94U0VM1m.0ZzUWZeiI_7Hpv9KexvwmkE7gWVnb8m1U0_aitmPx_UKx5wnNmCc75dG5oHaLA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ned Forrester <nforrester@whoi.edu>
Subject: Re: [spi-devel-general] [PATCH] atmel_spi: support zero =?iso-8859-1?q?length=09?= transfer
Date: Fri, 22 Feb 2008 18:37:01 -0800
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net, marc.pignat@hevs.ch,
       linux-kernel@vger.kernel.org, anemo@mba.ocn.ne.jp
References: <20080221.005432.07645461.anemo@mba.ocn.ne.jp> <20080222190228.2B0CB28E363@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <47BF2455.8030904@whoi.edu>
In-Reply-To: <47BF2455.8030904@whoi.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802221837.02012.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008, Ned Forrester wrote:
> 
> So, what I think you said is that it would be better for pxa2xx_spi to
> silently ignore a zero-length message, passing it back with the rest of
> the message when all is complete, than to reject the message.

Yes.  Remember that the reason to _use_ such a message is to get the
inline delay ... and that if you've got code to handle that case
(transfer.len == 0 && transfer.delay_usecs != 0) it's almost trivial
to support the degenerate "delay_usecs == 0" case too.


> I see no 
> reason why that could not be done, though it may be tricky to set other
> things like SSP modes and chip select and *not* start the DMA.  It would
> have to be tested, so I'm not sure when I could try that.

Normally I'd expect it's little more than a "goto", but the pxa2xx_spi
structure is relatively complex.

 
> >> I agree with Marc: any such delay will be undefined, in the general
> >> case.  It might work for a specific driver implementation.
> > 
> > Is that what Marc said?  I couldn't tell.  In any case, I disagree;
> > the semantics of that delay are clearly define.
> 
> Maybe I am missing something.  Aren't we talking about a transfer in a
> message, with or without other transfers, who's only unique
> characteristic is that that its length is zero?

There were two cases ... delay_usecs being zero, or not.  In either
case, the semantics are the same:  after the transfer (len == 0),
delay that many microseconds (zero or more).


> Or are you and Atsushi talking about using spi_transfer.delay_usecs
> *with* a zero length transfer to effectively put a delay between the
> assertion of CS and the start of the first clock?  If so, then I guess I
> missed the original point.  Sorry.

As I noted, there are two cases.  The reason to use a zero length
transfer is to get a delay ... in his case, specifically before
the first clock, but in general *anywhere* in the transfer.  But
the degenerate case is "delay for zero microseconds".


> --
> 
> By the way, reading spi.h again, it looks like spi_transfer.delay_usecs
> is supposed to be implemented between the last bit movement of a
> transfer and any change of CS at the end of a transfer.  Is that right?

Yes.


>  I think that pxa2xx_spi is dropping CS, if requested, immediately at
> the end of transfer, and then putting spi_transfer.delay_usecs between
> that transfer and the next.

That's a bug then; it will matter with some drivers.



> >>      If it were necessary to scan a
> >> whole message for zero-length transfers and refuse to queue an offending
> >> message, then that adds burden to all messages.
> >
> > Sanity checking messages as they're submitted is easy; and it's
> > also the natural point for setting up DMA mappings (and making
> > those cachelines available for better use).
>
> Hmmm.... Obviously I have much to learn about modern computers.  It had
> not occurred to me, even after reading "Linux Device Drivers", Corbet,
> et.al, that by DMA mapping, one frees the cache for other uses.  It
> makes sense. 

That's certainly what happens on systems where the buffer is from
"normal" memory and the cache is DMA-incoherent ... like most ARMs,
and probably the majority of non-x86 hardware.  Think of that as
being a level or two deeper than what LDD covers.


> In my application I pass many large buffers to the master 
> driver, and I map them in the protocol driver.  I did that without good
> reason, but now I see it was the proper choice.
>
> Unfortunately, pxa2xx_spi does any DMA mapping not done by the protocol
> driver in pump_transfers, as each transfer is submitted to the hardware.

That's not wrong ... but it's sub-optimal:  those cache lines could
have been doing better things all that time, and cleaning them out
in the middle of a transfer will slow it down by some amount.


>  There is not currently any message checking done in transfer(), the
> only error return from that is if the master driver is shutdown (queue
> stopped).  The current scheme is to return the message with non-zero
> spi_message.status if it has failed *after* execution has been
> attempted. 

Again ... not wrong, but sub-optimal:  when it happens (which won't be
common, fortunately!) the SPI slave will be left in a rude state.  And
the protocol driver may not know how to recover.


> I don't look forward to making major changes, if we really 
> want all DMA mapping and error checking to be in transfer(), though I
> see no reason why it could not be done.

There's no rush on cleanups like that.  They'd be reasonable tasks for
someone with some time to spare, who wanted to get their feet wet in
some driver updates and who could set up some kind of test rig.  (Like
one with a programmable slave that could be made to do all sorts of stuff
that might otherwise be a bit uncommon.  A microcontroller slave would be
easy ... programming a CPLD or FPGA would be much trickier!)

- Dave


