Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbZD1VDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbZD1VDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZD1VDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:03:43 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:40562 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751757AbZD1VDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:03:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lFeLPwlejOiau/O86N5LfdK3zTTCVOYg8bPtJoPdtG+TICutHSS4Thm4aUrygHOjf41A+/rWqx76ir9WAqHiTNQNRJewYDxXOKc3nOR2CgSumSoIR/B4iH8EeY+PKRA6dF79md0slFIb3VCC2zi/eBve8uBO0/IE4dW3nbrt6ZM=  ;
X-YMail-OSG: 6R8EP7YVM1mUZ7aRWLekpu9srmGlnKDJEOf2fBIu.ZO7CxG5xFSNV.H0BL8W225gw4esbt02450N0I5bA5rMdxHtqd_4ZEfiqZN_DYxwjuDs.llWhH5C.xo1Za1eJCf2CzTqSJIIKyLkuGnk7R1EFadMUfza9XD_P.4AIfAAwjOlj9DuxRiyDaUZd3EKOuZkRA0ky3P44uQ__9e2Wi.dUQnKB2bXWgAy5jOyLQXyLoJZaYmbbjdNQSrBrn9j0RbaWW4NTrq0fAiztmCHxuRjuVG2P9.QRqntx6leuBFG98JwUveb35xPhxaYPnxRqAAdpi_A3KMUfTsPc3unP7.PS_MtMBE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [spi-devel-general] [PATCH v2] spi: Add support for the OpenCores SPI controller.
Date: Tue, 28 Apr 2009 14:03:40 -0700
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200904041227.54687.david-b@pacbell.net> <200904280458.23018.david-b@pacbell.net> <20090428122011.GB6325@avionic-design.de>
In-Reply-To: <20090428122011.GB6325@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904281403.40757.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009, Thierry Reding wrote:
> > > I couldn't really find a way to implement per-transfer overrides for the
> > > word size because the controller simply has no concept of word sizes. Is it
> > > in such cases still necessary to hardwire the word size to 8 bits?
> > 
> > Is this the http://www.opencores.org/?do=project&who=spi core?
> 
> Yes, it is.
> 
> > Its summary says "Variable length of transfer word up to 32 bits";
> > does that mean "configurable when core is synthesized" instead of
> > truly "variable"?
> 
> That summary seems out-dated. The variable length of transfer word is
> actually the maximum length of a single transfer and is 128 bits in the
> latest version.

So long as they don't couple "transfer" with chipselect activation
and then de-activation, that's normal.

128 bits is pretty big, but it should make no difference to the slave
whether the host thinks of its data as one 128-bit word, sixteen 8-bit
words, one 9-bit word followed by a 119-bit one, or whatever.

Unless the design is broken, so that you can't send words without
flapping the chipselect.  That would surprise me.


> I'm not sure whether this is supposed to be the same as the word size. If it
> is it would mean that a single transfer can always only transfer one word.
> Which is kind of inefficient, I would think.

A "struct spi_transfer" should include a arbitrary number of
such words.  If the word size is over 8 bits, all the usual
byte ordering concerns come into play.  You may optimize the
register I/O however you like, so long as the bits on the
wire come out in the right sequence.

Ignoring clock options, the canonical SPI transfer starts by
activating a chip select, then clocking out an arbitrary number
of bits (clocking *in* one bit for each one clocked out), and
then de-activating chipselect.  Those bits are usually viewed
as a sequence of various-size words ... not necesarily all
the same size.  Example, some LCD controllers use 9-bit command
words followed by pixel data encoded in bytes.

Now, how the bits get to/from the controller is an area where
silicon can optimize.  For example, it's common to offload
that work to a DMA controller that can do burst operations
to keep the data bus efficiency high ... and to have a FIFO
in there, so those bursts can be bigger than the word size.

- Dave
