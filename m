Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbXA0AnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbXA0AnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbXA0AnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:43:00 -0500
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:23604 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752157AbXA0Am7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:42:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xIWj1auRQ0hQ5+3bVrVia+BOmcvn2JPVOG9KU7xCpjX+gPsdWT0r+NkzYds9mYsB5g70W/7maMHNv/Lp9n3vrgJxo3SFsH+bEM9rOdAHyxjux/Ye8uOtGEGBqt6OHIXY/py2CrNVAeSZh43ItbZnV/ak3tsJvSomGyAL2sIFlQ4=  ;
X-YMail-OSG: Z26AE4wVM1mo7ORBtA7wH_mEeWR5w9qfpsSmV9UBcOxJ7DoYQGoeU_KX.o6NGmS7mcZ6E0ypzmyy66hEsarVvH7UVe5KdBuAw0K1Rb00vyoRo4pp83mVGAgpxntBibNnM_.bxwYHXZlwNBh1.m2HheZvut_zDAXmvXpwoyFQ_wtPtCAPVob2zuW8x33C
From: David Brownell <david-b@pacbell.net>
To: Hans-Peter Nilsson <hans-peter.nilsson@axis.com>
Subject: Re: [PATCH 1/2] take 2: (was-kind-of: 3/5 SPI tx_default) 2.6.20-rc6
Date: Fri, 26 Jan 2007 15:21:15 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org, mikael.starvik@axis.com,
       spi-devel-general@lists.sourceforge.net
References: <200701261046.l0QAkIdt032408@ignucius.se.axis.com>
In-Reply-To: <200701261046.l0QAkIdt032408@ignucius.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701261521.15844.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 January 2007 2:46 am, Hans-Peter Nilsson wrote:
> > From: David Brownell <david-b@pacbell.net>
> > Date: Thu, 25 Jan 2007 05:02:56 -0800
> 
> > On Wednesday 24 January 2007 8:52 pm, Hans-Peter Nilsson wrote:
> > > (Please CC me on replies, I'm not subscribed to LKML or the SPI list.  Thanks.)
> > > 
> > > The SD/MMC SPI-based protocol isn't really duplex.  In the
> > > normal case there's either information transmitted or received,
> > > not both simultaneously.  The unused data is always 0xff; ones.
> > > Unfortunately, the SPI framework leaves outgoing data for a
> > > left-out tx_buf just as "undefined"
> > 
> > In current kernels that's actually changed.  The value to be shifted
> > out is now specified ... as all-zeroes, which is what various chips
> > need to receive, and various (half-duplex/Microwire) controllers seem
> > to be doing in any case.
> > 
> > If that's an issue -- and MMC-over-SPI needs to specify some other
> > value --
> 
> Well, it *is* specified as ones (0xff). 

Fair enough; I don't recall that I actually saw a spec saying that.


> > I think a better way to package this would be to define a new
> > flag for spi->mode, since controller drivers are already supposed
> > to be checking that to make sure they handle all the options which
> > have been specified.
> 
> But it's unspecified what the controller drivers should do with
> flags don't recognize (should they refuse? warn? ignore? - I see
> they all ignore)

They should refuse.


>   if (spi->mode & ~(SPI_CPHA | SPI_CPOL | SPI_CS_HIGH | SPI_LSB_FIRST))
> 	return -EINVAL;
> 
> (I think I'll do exactly that with the drivers I wrote.)

Something like that, yes.  It might be nice to have a KERN_DEBUG message
saying which flags were troublesome; production systems will of course
never trigger those failures, so there's no point in having a message
that's not automagically compiled-out.

 
> >  That flag could work in conjunction with a byte
> 
> Or why not a 32-bit word!

If a driver wants a repeating 32-bit pattern, they should just
provide a properly initialized tx buffer.


> FWIW, I defined it as a single bit in that patch, because that's
> what my HW can do when the transmitter is disabled - and because
> MOSI *is* a single-valued signal. ;-) 

I wouldn't mind a single bit flag either, saying whether to shift
out all ones or all zeroes.  The controller driver would morph it
to something appropriate ... 0xff, 0xffffffff, etc.


> While I was looking, I noticed that the memory-layout of
> non-8-bit words for SPI is a bit unclear. 

The SPI_LSB_FIRST flag describes bit order on the wire.

In-memory bit ordering should be native/CPU bit order
(which may be slightly unclear).  So the confusion is
not for 8, 16, or 32 bit words ... but 9, 12, 20, and
other sample sizes.


> The endianness of 
> data shifted out doesn't really define endianness in memory or
> whether 24-bit words bytes are in order {hi, med, low, pad} or
> indeed {pad, low, med, hi or whatever combination.  For a LE
> architecture, storing data as LE in memory makes sense, and both
> with and without padding makes sense too.  Perhaps best to just
> document that it's undefined?

No, the point is to alow portable drivers.  So that must be
specified.  What I'm writing up is that it must be right
justified, so its the MSBs that are undefined (for RX) or
ignored (TX).


> > then please re-issue this patch against 2.6.20, including
> > the update to the bitbang driver ("reference implementation").
> 
> I used patch-2.6.20-rc6; I see not too many SPI things changed
> besides defining the previously undefined as 0.  I didn't find a
> reason to introduce a mode-flag; it should always be enough to
> look at the word.  A flag is redundant with default_tx_word != 0
> (in 2.6.20 semantics).  So, I just added that word and adjusted
> the bitbang-driver.  As a courtesy, I also added simple bail-out
> code for the other drivers (not compiled and submitted
> separately).

OK.

 
> Here's an updated patch for 2.6.20-rc6. 

Thanks, I'll eyeball it and merge some version.

- Dave
