Return-Path: <linux-kernel-owner+w=401wt.eu-S934554AbXHGNdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554AbXHGNdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933310AbXHGNdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:33:37 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:54760 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762482AbXHGNdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:33:36 -0400
Date: Tue, 7 Aug 2007 15:33:33 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org, david.vrabel@csr.com
Subject: Re: sdio: enhance IO_RW_EXTENDED support
Message-ID: <20070807153333.01c22a67@poseidon.drzeus.cx>
In-Reply-To: <46B86ADB.90000@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
	<20070806171207.59fafa18@poseidon.drzeus.cx>
	<46B73F18.5030109@csr.com>
	<20070806220145.66b97559@poseidon.drzeus.cx>
	<46B86ADB.90000@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 13:51:39 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> 
> In conclusion, the optimum block size is based solely on the card and
> host capabilities and should be limited to at most 512.  Hence the
> block size can (and should) only be set once during card
> initialization.
> 

Well, I can hardly argue with that thorough analysis. :)

I still like the idea of having the control in the core as much as
possible though. It allows people to experiment and figure out new and
clever ways of solving this in a way that can benefit all drivers.

So could we do most of what you propose, where we set the block size to
maximum, yet <= 512. Drivers can tweak this further by calling
sdio_force_block_size() (as need e.g. by my marvell card), and keep the
convention of 0 meaning "back to core default"? That way we can modify
the meaning of "core default" if more clever ways are available.

> > +		if (size <= 512)
> > +			goto byte_remainder;
> 
> The maximum size for a byte mode transfer is the block size set in
> the card.
> 

Right, sorry. It was late when I was hacking on this.

> > +		/* avoid changing blksize needlessly */
> > +		if (func->cur_blksz && ((blksz % func->cur_blksz)
> > == 0))
> > +			blksz = func->cur_blksz;
> 
> If func->blksize == 1024 and we perform transfers in the 512 to 1024
> range, this would set the block size on every transfer.
> 

Quite right. I had no doubts that thing had room for improvement. But I
agree that we might as well select a fixed block size and stick with it
for the general case.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
