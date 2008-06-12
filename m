Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYFLIAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYFLIAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYFLIAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:00:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:51489 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754084AbYFLIAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:00:33 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+m6+cd/xumb95hqVIP/BRZ+82D4zDBSNsYQpYUYC
	YGFgHa/ekwJvGw
Date: Thu, 12 Jun 2008 10:00:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] gpio: gpio driver for max7301 SPI GPIO expander
In-Reply-To: <200806120015.50953.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0806120958450.18017@axis700.grange>
References: <Pine.LNX.4.64.0806061625260.3338@axis700.grange>
 <200806120015.50953.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, David Brownell wrote:

> Some comments about one routine; presumably more to follow:

Thanks, David, I'll pass your comments on to the author and try to get 
them acted upon.

Thanks
Guennadi

> 
> 
> On Friday 06 June 2008, Guennadi Liakhovetski wrote:
> > +/**
> > + * max7301_read - Read back register content
> > + * @spi: The SPI device
> > + * @reg: Register offset
> > + *
> > + * A read from the MAX7301 means one message with two transfers
> 
> That's not what you implement though ... what it needs is:
> 
> 	- transfer #1:
> 		* select
> 		* write 16 bit command, discard rx data
> 		* deselect
> 	- transfer #2
> 		* select
> 		* write 16 bit command, saving rx data
> 		* deselect
> 
> That's from the data sheet.  Now, that *could* be implemented
> with a single message ... or, as you do, with two messages.
> 
> You should at least correct the comment, if you don't want to
> switch to a slightly faster single-message implementation.  :)
> 
> 
> > + *
> > + * Returns positive 8 bit value from device if successfull or a
> > + * negative value on error
> 
> Actually it returns a 16 bit value... also, "successful" has one "l".
> You seem to have forgotten to mask off the high byte ...
> 
> 
> > + */
> > +static int max7301_read(struct spi_device *spi, unsigned int reg)
> > +{
> > +       int ret;
> > +       u16 word;
> > +
> > +       word = 0x8000 | (reg << 8);
> > +       if ((ret = spi_write(spi, (const u8*)&word, siz
> 
> > eof(word))) != 0) 
> > +               return ret;
> > +       /*
> > +        * FIXME: This read should write 0x0000 (=NOOP at MAX7301 side)
> 
> Take out this FIXME, and just replace it with a note that this relies
> on the fact that TX always shifts out zeroes if there's no data specified.
> 
> > +        */
> > +       if ((ret = spi_read(spi, (u8*)&word, sizeof(word))))
> > +               return ret;
> > +       return word;
> > +}
> > +
> 
> 
> Oh, and in the probe():
> 
> > +       spi->master->setup(spi);
> 
> should be
> 
> 	ret = spi_setup(spi);
> 	if (ret < 0)
> 		return ret;
> 
> It's quite possible that something get misconfigured, so you end up trying
> to talk through a spi_master controller that doesn't support 16-bit words.
> 
> - Dave
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
