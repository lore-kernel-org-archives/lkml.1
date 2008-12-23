Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbYLWSiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbYLWSiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 13:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYLWSh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 13:37:57 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:30595 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751079AbYLWSh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 13:37:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=o546HattQITjUYDUosO7fh/Ceq5EuwX/DYQcbaJ5BJm59PfnjfJXfbcM7meQyxxmcdqsAepfWgNpMbzJ+gDzpZBrZ2gOYPxunOR2Hio3eb9yYxzLXxzye37Ls7p3X3SpT0mhbbkqyFBSkCv4f6BWtkyUYJR/E+SYssw5WyHhfiE=  ;
X-YMail-OSG: IZepe9AVM1n9mIJEtbCGbrfr0Kzu8QjcztZaNPizJcqXBZLrMh5.KD8saZrtTTsciCWfvahZlHrECXXmKVgUSAmwteqqO7IaYAIhvxqW3x5kby0m373pYVA4seTJd9wZYJEdrZlu2GrF9v6OtkWGqr8aRkp_.Qm5cVo8I40x7YGl59WJlKp9ArJW03qf
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [patch 2.6.28-rc9] spi: spi_write_then_read() regression fix
Date: Tue, 23 Dec 2008 10:37:53 -0800
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Vernon Sauder <vernoninhand@gmail.com>
References: <200812202332.36281.david-b@pacbell.net> <200812211648.26699.david-b@pacbell.net> <200812230254.00249.ioe-lkml@rameria.de>
In-Reply-To: <200812230254.00249.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812231037.53955.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 December 2008, Ingo Oeser wrote:
> Hi David,
> 
> On Monday 22 December 2008, you wrote:
> > 	  The write_then_read() helper is
> > simplifying a common half-duplex idiom for short operations,
> > but the hardware still does full duplex.  Buffer layout is:
> > 
> >   Before:	WWWWW0000000
> >   After:	xxxxxRRRRRRR
> > 
> > That is, for every bit shifted out (W, 0) another one gets
> > shifted in (x, R).  The I/O primitive essentially swaps
> > contents of a one-word shift register between master and
> > slave; or, sequences of such words.  Words don't need to
> > be byte-size, though that's a common option.
> 
> ...
> 
> Wow, what interesting hardware logic and a nice explanation.

It's standard SPI ... yes, it's kind of interesting, and I've
not come across anything else that synchronizes RX and TX in
quite the same way.

I suspect that hardware designers find the ability to get
quick transfers (tens of megabits/second) from just a shift
register is fairly attractive.  Less work than high speed
I2C, for one example.


> Could you put that into a comment somewhere close to those helpers?

Fair enough.  That file does lack any mention of the I/O model
for SPI ... and it's certainly a bit of a surprise to anyone
who's not had to look at it before!

 
> You can safely assume, that any code which Linus doesn't understand
> is non-trivial and needs a comment :-)

I'm not sure I'd agree with that -- while he's many things,
"expert in everything" is not one of them! -- but I do agree
that comment would be worth adding.


However, with regards to $PATCH ... considering that the '28
release is just around the corner, I changed my mind and would
suggest just reverting f9b90e39cbc5c4d6ef60022fd1f25d541df0aad1
much though I very much like that fix in general.

Reason being:  it needs a bit more work, I forgot that it will
break for example drivers using drivers/spi/omap_uwire.c since
that is built on top of truly half-duplex hardware.  (Used with
OMAP1 SOCs.)  The kerneldoc says it's for providing MicroWire
style transactions, so it's kind of significant that it work
on MicroWire hardware too.  ;)

So an updated version would need to both zero the TX bits when
using normal full-duplex SPI hardware ... and use more or less
the current code when running on half-duplex variants.

- Dave


