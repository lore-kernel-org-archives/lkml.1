Return-Path: <linux-kernel-owner+w=401wt.eu-S1765028AbXHFSHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765028AbXHFSHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbXHFSHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:07:03 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:54019 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbXHFSHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:07:01 -0400
Date: Mon, 6 Aug 2007 20:06:55 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdio: enhance IO_RW_EXTENDED support
Message-ID: <20070806200655.77c73130@poseidon.drzeus.cx>
In-Reply-To: <46B73F18.5030109@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
	<20070806171207.59fafa18@poseidon.drzeus.cx>
	<46B73F18.5030109@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Aug 2007 16:32:40 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> 
> Drivers may care about the block size though so you can't have it
> changing behind their backs. e.g., they may need to pad data to a
> multiple of the block size.
> 

Well, we have to assume that they aren't just padding to pass the time.

I can see a couple of reasons:

1. They are padding because it made their code easier by allowing just
one transfer.

This is what I believe is the common case, and one that will go away if
we allow the core free access to the block size. All the complexity is
in the core and the drivers don't even have to bother with setting a
block size.

2. They must write an exact number of bytes to the card before it
activates.

As far as the core is concerned, padding and "real" data are the same
thing, so this poses no restriction on how the core can fiddle with
block sizes and transfers.

3. The entire transfer must be in one transaction.

Now this is a problem as the core might prefer to do two transfers
(probably one block and one byte).

As I believe this will be a rare case, we should try to make sure we
can handle this in a way that can keep less fussy transactions simple.
So I propose changing your sdio_set_block_size() API to
sdio_force_block_size().

That way the driver can lock the block size when it has particular
needs, yet keep it under the (assumingly more optimal) control of the
core at other times.

One could have a calling convention such as specifying a block size of
zero to turn off the forced block size.

One could also use this as a less complex way of informing the drivers
of host restrictions. If the block size specified isn't possible, we
can return an error code stating such. Without that, every driver that
needs this would need to duplicate code that computes possible block
size and would make our life a pain when we want to add new host
restrictions.

> > 
> > I have a counter example. I have here a Marvell wifi card which
> > needs a firmware upload. And it seems to be rather picky about
> > parameters during that upload.
> >
> 
> sdio_set_block_size(func, 64); /* ew, this card is fussy */
> 
> download_firmware();
> 
> sdio_set_block_size(func, func->max_blksize); /* Ahhh, back to the
> card's default */
> 
> If a card is fussy about the block size I don't think there's anything
> cleaner than specifying directly in the driver.
> 

Well, the driver has to specify the information somehow. As to how,
there are a number of options. My proposed sdio_force_block_size() will
work here as well.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
