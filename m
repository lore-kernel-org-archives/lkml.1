Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbYLVAsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbYLVAsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 19:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbYLVAs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 19:48:29 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:42888 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751330AbYLVAs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 19:48:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cOjaQ6CFe4sAewqIUcQtvme3i+CSrCDCSUZMLCIAc/ekR+Tk/fIwEaM6topWG9fVD5WjPZG7g4IYu/XuQNIbJ8RaQbjcG1nH4Atg8CBJOUx8Li7WbmOwHiRNu0hCXZYh8vSgd1ct4eErdYJgGfvj6lVnoCRfo2YxmB5m/jprY/4=  ;
X-YMail-OSG: .YVDcMoVM1l6AvqW9SheFivjHNcPfEH.okO8MTdDjvWiQcMZ2Wpa7kQQeSfQ38LJB4pfuaWBP7beXZkvoKQVHohcLy8dTxjFDvYembqGRZBX3AyNqF4VqAVvCRpPlPkf1nuvDaVGUyCyadek9lMGrYsjPSBcWjKuOIeiCvoxne_aRmqbBmqJ3MqNLlZO
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2.6.28-rc9] spi: spi_write_then_read() regression fix
Date: Sun, 21 Dec 2008 16:48:26 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Vernon Sauder <vernoninhand@gmail.com>
References: <200812202332.36281.david-b@pacbell.net> <alpine.LFD.2.00.0812211545520.24883@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812211545520.24883@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812211648.26699.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 December 2008, Linus Torvalds wrote:
> 
> On Sat, 20 Dec 2008, David Brownell wrote:
> > 
> > All SPI transfers are full duplex, and are packaged as half duplex
> > by either discarding the data that's read ("write only"), or else
> > by writing zeroes ("read only").  That patch wasn't ensuring that
> > zeroes were getting written out during the "half duplex read" part
> > of the transaction; instead, old RX bits were getting sent.
> 
> Hmm. In addition, isn't this broken (in that same function):

No -- this is full duplex.  The write_then_read() helper is
simplifying a common half-duplex idiom for short operations,
but the harware still does full duplex.  Buffer layout is:

  Before:	WWWWW0000000
  After:	xxxxxRRRRRRR

That is, for every bit shifted out (W, 0) another one gets
shifted in (x, R).  The I/O primitive essentially swaps
contents of a one-word shift register between master and
slave; or, sequences of such words.  Words don't need to
be byte-size, though that's a common option.

 
>         memcpy(local_buf, txbuf, n_tx);
>         x.tx_buf = local_buf;
>         x.rx_buf = local_buf;
> 
>         /* do the i/o */
>         status = spi_sync(spi, &message);
>         if (status == 0)
>                 memcpy(rxbuf, x.rx_buf + n_tx, n_rx);
> 
> shouldn't that 'rx_buf' setup be
> 
> 	x.rx_buf = local_buf + n_tx;
> 
> since the whole point was that we allocated a buffer that can hold _both_ 
> the rx and tx parts? Especially as that final copy into the resulting 
> "rxbuf" thing uses that "+ n_tx" addition?

See above.  We only want the "R" bits which were shifted in
right *after* the n_tx "W" bits.  If we offset rx_buf before
the I/O, we'd start with the "x" don't-care bits and need to
do something else to discard them.  (Plus, allocate more
space at the end of the buffer.)

- Dave


> 			Linus
> 
> 


