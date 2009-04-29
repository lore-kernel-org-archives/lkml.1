Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbZD2GWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbZD2GWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZD2GWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:22:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbZD2GWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:22:14 -0400
Date: Wed, 29 Apr 2009 08:22:08 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [spi-devel-general] [PATCH v2] spi: Add support for the
	OpenCores SPI controller.
Message-ID: <20090429062208.GA7784@avionic-design.de>
References: <200904041227.54687.david-b@pacbell.net> <200904280458.23018.david-b@pacbell.net> <20090428122011.GB6325@avionic-design.de> <200904281403.40757.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904281403.40757.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX1+Bws46GQ9fOsWJesp1BTHZdsFiPxw/tHdY/vf
 aTgTMzkQ7IAI+HCqNGqjcKBKIy83tHkw+896T1mWUGPzIFjCCm
 h6wQzzwrJAxL7zvBH/ajQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Brownell wrote:
> On Tuesday 28 April 2009, Thierry Reding wrote:
> > > > I couldn't really find a way to implement per-transfer overrides for the
> > > > word size because the controller simply has no concept of word sizes. Is it
> > > > in such cases still necessary to hardwire the word size to 8 bits?
> > > 
> > > Is this the http://www.opencores.org/?do=project&who=spi core?
> > 
> > Yes, it is.
> > 
> > > Its summary says "Variable length of transfer word up to 32 bits";
> > > does that mean "configurable when core is synthesized" instead of
> > > truly "variable"?
> > 
> > That summary seems out-dated. The variable length of transfer word is
> > actually the maximum length of a single transfer and is 128 bits in the
> > latest version.
> 
> So long as they don't couple "transfer" with chipselect activation
> and then de-activation, that's normal.
> 
> 128 bits is pretty big, but it should make no difference to the slave
> whether the host thinks of its data as one 128-bit word, sixteen 8-bit
> words, one 9-bit word followed by a 119-bit one, or whatever.
> 
> Unless the design is broken, so that you can't send words without
> flapping the chipselect.  That would surprise me.

So far, what I've been doing is just copy the transmission buffer in blocks
of 16 bytes byte-by-byte to the transmission registers (concatenating groups
of four bytes), then start the transfer. After the transfer I copy the bytes
back in the same manner to the receive buffer. I was assuming that the
buffers would be in the correct byte order at that point anyway.

This core actually allows manually setting the chipselect. It also has a mode
that automatically sets or clears the chipselect for each single "transfer"
(meaning up to those 128 bits). But as you say, that wouldn't be normal
behavior and breaks things.

> > I'm not sure whether this is supposed to be the same as the word size. If it
> > is it would mean that a single transfer can always only transfer one word.
> > Which is kind of inefficient, I would think.
> 
> A "struct spi_transfer" should include a arbitrary number of
> such words.  If the word size is over 8 bits, all the usual
> byte ordering concerns come into play.  You may optimize the
> register I/O however you like, so long as the bits on the
> wire come out in the right sequence.

What byte ordering are the transmit and receive buffers supposed to be in,
then? Native? Always big endian?

> Ignoring clock options, the canonical SPI transfer starts by
> activating a chip select, then clocking out an arbitrary number
> of bits (clocking *in* one bit for each one clocked out), and
> then de-activating chipselect.  Those bits are usually viewed
> as a sequence of various-size words ... not necesarily all
> the same size.  Example, some LCD controllers use 9-bit command
> words followed by pixel data encoded in bytes.
> 
> Now, how the bits get to/from the controller is an area where
> silicon can optimize.  For example, it's common to offload
> that work to a DMA controller that can do burst operations
> to keep the data bus efficiency high ... and to have a FIFO
> in there, so those bursts can be bigger than the word size.

I haven't experimented with using DMA transfers to this particular core
because there's currently no support for the generic DMA API on the CPU
we use.

> - Dave

Thierry

