Return-Path: <linux-kernel-owner+w=401wt.eu-S935056AbXHGRy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935056AbXHGRy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 13:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762313AbXHGRyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 13:54:49 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:36519 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758967AbXHGRys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 13:54:48 -0400
Date: Tue, 7 Aug 2007 19:54:45 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David Vrabel <david.vrabel@csr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] sdio: set the functions' block size
Message-ID: <20070807195445.62d107e2@poseidon.drzeus.cx>
In-Reply-To: <46B8A9DA.9030804@csr.com>
References: <11858961933491-git-send-email-david.vrabel@csr.com>
	<20070804152304.65ed8f1b@poseidon.drzeus.cx>
	<46B6F877.7060504@csr.com>
	<20070806171207.59fafa18@poseidon.drzeus.cx>
	<46B73F18.5030109@csr.com>
	<20070806220145.66b97559@poseidon.drzeus.cx>
	<46B86ADB.90000@csr.com>
	<46B86B88.5050009@csr.com>
	<20070807153800.734a6cbf@poseidon.drzeus.cx>
	<46B8A9DA.9030804@csr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 18:20:26 +0100
David Vrabel <david.vrabel@csr.com> wrote:

> Pierre Ossman wrote:
> > On Tue, 07 Aug 2007 13:54:32 +0100
> > David Vrabel <david.vrabel@csr.com> wrote:
> > 
> >>  
> >> Index: mmc/drivers/mmc/core/sdio.c
> >> ===================================================================
> >> --- mmc.orig/drivers/mmc/core/sdio.c	2007-08-07
> >> 00:38:33.000000000 +0100 +++ mmc/drivers/mmc/core/sdio.c
> >> 2007-08-07 07:17:29.000000000 +0100 @@ -53,6 +53,7 @@
> >>  {
> >>  	int ret;
> >>  	struct sdio_func *func;
> >> +	unsigned block_size;
> >>  
> >>  	BUG_ON(fn > SDIO_MAX_FUNCS);
> >>  
> >> @@ -70,6 +71,15 @@
> >>  	if (ret)
> >>  		goto fail;
> >>  
> >> +	/*
> >> +	 * Set the function's block size to the largest supported
> >> by
> >> +	 * both the function and the host.
> >> +	 */
> >> +	block_size = min(func->max_blksize,
> >> func->card->host->max_blk_size);
> >> +	ret = sdio_set_block_size(func, block_size);
> >> +	if (ret)
> >> +		goto fail;
> >> +
> >>  	card->sdio_func[fn - 1] = func;
> >>  
> >>  	return 0;
> > 
> > This is probably better done in the sdio_enable_func().
> 
> I don't think so. A driver might enable/disable a function multiple
> times but there's no need to set the block size every time.
> 

Why would it want to do that?

Anyway, as long as cur_blksz is preserved, sdio_set_block_size() can
easily filter out redundant calls. No need to compromise in the rest of
the code for that.

In the patch I sent, the block size is set the first time is needed.
Wouldn't that avoid all problems?

> It may be best to move setting the block size back to before the probe
> so a driver can be sure the block size is something sensible.
> Consider a failed probe that called sdio_set_block_size() -- this
> will currently mess up drivers probed later.
> 

Right, or remove the lock in the variant I proposed.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
