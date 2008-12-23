Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbYLWUzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbYLWUzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 15:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYLWUy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 15:54:58 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:36166 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751221AbYLWUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 15:54:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uFogWHGpIPwc4jr+6MQCkkTJxCPjKeiqgAEeDKl8mkP2JqbnBOM1umhHToD5i6gnGaNDaHK0zU4TUcE/Fsc3RN7U4M4bj5pt5v2Mhwzu5Jc/n0W4ud19ck8d252kYtsqt4+dtIs8zSKGvTlgX6UinDpWo7I6kGRIwwA1tawwiXY=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2.6.28-rc9] spi: spi_write_then_read() regression fix
Date: Tue, 23 Dec 2008 12:54:54 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Vernon Sauder <vernoninhand@gmail.com>
References: <200812202332.36281.david-b@pacbell.net> <200812211648.26699.david-b@pacbell.net> <alpine.LFD.2.00.0812231040080.3535@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812231040080.3535@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812231254.55284.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 December 2008, Linus Torvalds wrote:
> 
> On Sun, 21 Dec 2008, David Brownell wrote:
> 
> > On Sunday 21 December 2008, Linus Torvalds wrote:
> > > 
> > > Hmm. In addition, isn't this broken (in that same function):
> > 
> > No -- this is full duplex.  The write_then_read() helper is
> > simplifying a common half-duplex idiom for short operations,
> > but the hardware still does full duplex.  Buffer layout is:
> > 
> >   Before:	WWWWW0000000
> >   After:	xxxxxRRRRRRR
> 
> Then, the problem is this:
> 
>         x.tx_buf = local_buf;
>         x.rx_buf = local_buf;
> 
> which makes no sense. It's not two separate "tx_buf"/"rx_buf" things,
> it's just a single "buf".

In *this* specific case, yes.  That's the whole point of this
routine:  letting drivers treat a full duplex hardware protocol
as if it were a half duplex model.

Note that the *caller* provides two separate buffers ... which
can safely be on the stack; memcpy is used to access them.

The whole local_buf thing is a bounce-buffer, letting the caller
ignore DMA and other I/O issues that can be confusing.


You're not quite understanding an optimization, I suspect.

The original version of this code had two separate tranfers,
and each was half duplex:  first a TX, then an RX ... and with
the buffer pointer in the RX transfer offset as you seem to
expect.  But it uses local_buf in the *same* way.  The only thing
different is how the I/O is described.  With ", " separating
the first and second transfers:

  Before:	WWWWW, 0000000
  After:	xxxxx, RRRRRRR

Previously "discard RX data" (xxxxx) and "TX zeroes" (000000)
were implicit, because the TX transfer had no RX buffer and
then the RX transfer had no TX buffer.  (You'll get that code
if you revert the patch, as I suggest for '28-final.)  The
"interesting" RX data landed in the same place.

Thing is, the mid-message switch between two transfers made
for nasty performance when DMA or similar pipelining (FIFOs)
is involved.  The cost to switch from the TX transfer to the
RX transfer could easily double the time to perform the whole
write-then-read message.  (And it exposed a bug in one SPI
master controller driver, since fixed.)


Hence the switch to a lower overhead implementation, which
implements the same on-the-wire protocol more efficiently.
It made the "xxxxx" and "0000000" parts explicit, and uses
one transfer not two.  (And exposed DMA bugs in other SPI
master controller drivers ... in one case, its fix seemed
to resolve some longstanding hard-to-reproduce problems.)

And that's why the offset to the RRRRRRR bits went from
being explicit to being implicit:  it's doing the whole
thing in one transfer, rather than two.


> Having two separate pointers is not only confusing, but it's actively 
> WRONG, since the "rx_buf" clearly does not start at local_buf.

Erm, no.  It's right as is.  Watch the bits on the wire,
or as they arrive in the buffers -- it's correct.  Bits
are arriving and going into rx_buf, starting at exactly
the beginning of local_buf.  

But none of those bits are interesting to the caller until
the ones read AFTER the write completes. Hence the name
of the function:  write, then read.  SPI itself does both
at the same time.


> So please explain how it can _possibly_ make sense to
> 
>  - have two separate pointers

In the general case, the full duplex nature of SPI is available for
drivers to do what they want.  This version of write_then_read() is
using that for a performance optimization.

It would be extremely surprising for a driver to write data and
always have its transmit buffer overwritten -- unless it asked
for that behavior.  Especially for a driver that doesn't care
about the data the slave returns from that particular message!
Likewise if it had to initialize each RX buffer before using it.

The per-transfer interface prevents such surprises by splitting
out the RX and TX buffers.  Code that wants overwriting can get
it; code that doesn't, isn't forced to cope with that.


>  - and have one of them point to what is clearly not the data it is 
>    supposed to point to.

See above ... you're not seeing the consequences of each transfer
being full duplex.  There aren't many ways to package an interface
to hardware transfers where no bit is received without transmitting
another one:

  - Only provide half duplex transfers ... not a good choice,
    some devices do need full duplex, and custom drivers have
    wanted to leverage the full duplex hardware.

  - Only provide a primitive where every TX buffer gets clobbered
    by RX data, and every RX buffer must be zeroed ... limiting,
    because of half-duplex variants (Microwire, and "3-wire SPI")
    that would be precluded.

  - Provide a primitive with both RX and TX buffers, and let the
    drivers set them up as needed.

The current framework uses the last option, which still seems to
me to be the best choice.

- Dave
