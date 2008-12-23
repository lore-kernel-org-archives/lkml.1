Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYLWByP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYLWByP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 20:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbYLWBx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 20:53:59 -0500
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:54463 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbYLWBx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 20:53:59 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.28-rc9] spi: spi_write_then_read() regression fix
Date: Tue, 23 Dec 2008 02:53:59 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; x86_64; ; )
References: <200812202332.36281.david-b@pacbell.net> <alpine.LFD.2.00.0812211545520.24883@localhost.localdomain> <200812211648.26699.david-b@pacbell.net>
In-Reply-To: <200812211648.26699.david-b@pacbell.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Vernon Sauder <vernoninhand@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812230254.00249.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Monday 22 December 2008, you wrote:
> On Sunday 21 December 2008, Linus Torvalds wrote:
> > 
> > On Sat, 20 Dec 2008, David Brownell wrote:
> > > 
> > > All SPI transfers are full duplex, and are packaged as half duplex
> > > by either discarding the data that's read ("write only"), or else
> > > by writing zeroes ("read only").  That patch wasn't ensuring that
> > > zeroes were getting written out during the "half duplex read" part
> > > of the transaction; instead, old RX bits were getting sent.
> > 
> > Hmm. In addition, isn't this broken (in that same function):
> 
> No -- this is full duplex.  The write_then_read() helper is
> simplifying a common half-duplex idiom for short operations,
> but the harware still does full duplex.  Buffer layout is:
> 
>   Before:	WWWWW0000000
>   After:	xxxxxRRRRRRR
> 
> That is, for every bit shifted out (W, 0) another one gets
> shifted in (x, R).  The I/O primitive essentially swaps
> contents of a one-word shift register between master and
> slave; or, sequences of such words.  Words don't need to
> be byte-size, though that's a common option.

> See above.  We only want the "R" bits which were shifted in
> right *after* the n_tx "W" bits.  If we offset rx_buf before
> the I/O, we'd start with the "x" don't-care bits and need to
> do something else to discard them.  (Plus, allocate more
> space at the end of the buffer.)

Wow, what interesting hardware logic and a nice explanation.

Could you put that into a comment somewhere close to those helpers?

You can safely assume, that any code which Linus doesn't understand
is non-trivial and needs a comment :-)


Best Regards

Ingo Oeser
