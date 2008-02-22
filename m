Return-Path: <linux-kernel-owner+w=401wt.eu-S1763185AbYBVS7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763185AbYBVS7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbYBVS6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:58:55 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:36026 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756726AbYBVS6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:58:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Wt92DUZQlA+Pgzg0cY8Ely+ABI1FEKHmIEmqEg6diXedfFu+p8VpEkS+/jlOQ9mudKm8MXjE0geVbPe3kSq/TLhaLGMDZgv7IH1tzdjXg3mhfLgxD8aIBGCttaUJIyt4cdB+NRGEmRWKXqxMBibMWMO+Aau9CA4C4ATiktJyKyk=  ;
X-YMail-OSG: KWIq50sVM1kHGmpTCxplPvO6cCFCNeecbGC5IlLke1sg13OeYqOCdqwROybhw2456.zEKyQdEA--
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 22 Feb 2008 10:58:52 -0800
From: David Brownell <david-b@pacbell.net>
To: marc.pignat@hevs.ch, anemo@mba.ocn.ne.jp
Subject: Re: [spi-devel-general] [PATCH] atmel_spi: support zero length 
 transfer
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200802211026.17816.marc.pignat@hevs.ch>
 <20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <200802221030.32263.marc.pignat@hevs.ch>
 <20080222.231510.56565462.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080222.231510.56565462.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080222185852.5863D28E371@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoth Atsushi Nemoto on Fri, 22 Feb 2008:
> On Fri, 22 Feb 2008 10:30:31 +0100, Marc Pignat <marc.pignat@hevs.ch> wrote:
> > > > David, do you think writing 0 bytes is a valid use of this API?
> > > 
> > > Just a zero byte transfer ... no, though it depends what you mean
> > > by "valid".  (I'm not sure I'd expect all controller drivers to
> > > reject such requests.)  That has no effect on bits-on-the-wire,
> > > and would make trouble for various DMA engines.
> >
> > So, the behaviour is undefined,

Not what I said.  To repeat:  it makes sense to pass zero bytes
in at least one case, which is not "just" a zero byte transfer.

And in a practical sense, until we have some kind of regression
testing scheme -- with some kind of "golden device" -- it's not
very sensible for any SPI Protocol Driver to expect that all SPI
Master Controller Drivers act consistently in such cases.


> >	something between 'crash my dma engine',
> > 'assert chip select and wait some time', or 'do_nothing'...
>
> If the driver could not handle zero length transfer, then the driver
> should reject it (just like unsupported transfer mode).

Exactly.  Behaviors like "crash my DMA engine" are clearly "invalid",
in *ALL* cases.  Bugs to get fixed as soon as they're noticed.


>	Then the
> behavior will be 'assert chip select and wait some time' or 'rejected
> by the driver'.

The "wait" mode is what started this thread -- not "just" a zero
byte transfer, but one which does real work.

For "just" a zero byte transfer, I see two main implementation
options ... with no compelling reason to force either one.

  - "ignored" ... the implementation sibling of "wait"
  - "rejected" ... more work

The argument for "rejected" would seem to be only that this is a
case of "protocol drivers should not do this".  But if they don't,
then the difference doesn't matter.


> > > And it would probably deserve a mode flag (sigh) unless someone
> > > can update every master controller driver.
> >
> > Supporting the zero-len-write means checking and perhpaps updating
> > each driver for the benefit of having an unknown length delay.
> > 
> > We should add the delay field in the spi_device, but this means more work.
> > 
> > Is this kind of device so common that we need to do all that work? or can we
> > leave it as is (verified to work only with atmel_spi)?
>
> I think my case is not so common.  But if the driver could support
> zero length transfer easily, there is no reason to reject it.
>
> And if nobody wanted to support zero length transfer on that driver,
> it would be no reason to update it ;)

So long as the controller driver doesn't misbehave, I can't see any
reason to worry about this behavior.

- Dave

