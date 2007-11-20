Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbXKTM0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbXKTM0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbXKTM0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:26:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbXKTM0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:26:44 -0500
Subject: Re: MMC sub-system: SDIO block-mode with increment address issue
From: Dean Jenkins <djenkins@mvista.co.uk>
Reply-To: djenkins@mvista.co.uk
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20071120115841.25765bd3@poseidon.drzeus.cx>
References: <1195472694.18869.57.camel@libdev3.libertesoft.co.uk>
	 <20071120115841.25765bd3@poseidon.drzeus.cx>
Content-Type: text/plain
Organization: MontaVista
Date: Tue, 20 Nov 2007 12:26:11 +0000
Message-Id: <1195561571.13874.4.camel@libdev3.libertesoft.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.0.1.el5) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+D82d/kNVm6JKP8gMuViVxeFUMzNiOkS+3ITs
 lX4qd1FP+S98yccf+kxXdeLdbawhQycNCEBldF3XBHtPpQBO3X
 TInqRVxM5uSbby6nVEjiA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

IMHO the issue is there is no upper bound limit to the valid address
range in sdio_io_rw_ext_helper() in sdio_io.c.

I call sdio_memcpy_toio() as it enables the incrementing address flag in
the CMD53 command but if I try passing too much data then the actual
address of the subsequent CMD53 commands are erroneously incremented out
of range.

The difficulty is the SDIO card can transfer 8 blocks in a single CMD53
command using the incrementing address flag. However
sdio_io_rw_ext_helper() will not prevent the attempt at sending 9 blocks
transferred as 2 CMD53 commands of 8 blocks + 1 block and the last block
goes to the wrong address. This causes a big system crash. I suspect the
SDIO card internally resets and the MMC sub-system can't handle the
error condition.

This means the card driver needs to know that it cannot use
sdio_memcpy_toio() to send any size of data but must ensure it does not
exceed 8 blocks before calling sdio_memcpy_toio(). IMHO this makes the
card driver undesirably tightly coupled with the core driver. OK. I'll
workaround it using multiple calls to sdio_memcpy_toio().

BTW. Is the API for the exported SDIO core functions documented
anywhere ?

Thanks,

Regards,
Dean.


On Tue, 2007-11-20 at 11:58 +0100, Pierre Ossman wrote: 
> On Mon, 19 Nov 2007 11:44:54 +0000
> Dean Jenkins <djenkins@...> wrote:
> 
> > This E-mail is for the attention of Pierre Ossman (MMC sub-system
> > maintainer)
> 
> A cc helps if you want my attention. ;)
> 
> > 
> > Hi Pierre,
> > 
> > I've being trying to get SDIO block-mode with incrementing address to
> > work on an OMAP2430 based reference board with an SDIO card.
> > 
> > Looking at the latest code ( as of 19/11/2007 ) on the mmc-git tree (I'm
> > not a git expert so I'm not sure how to reference the codebase). I have
> > a comment to make concerning the following code snippet...
> 
> git log or git show will give you your current top commit id.
> > 
> > I think the lines
> > 
> > 227                         if (incr_addr)
> > 228                                 addr += size;
> > 
> > are incorrect and should be removed. I think the SDIO increment address
> > parameter relates to the internal operation of the SDIO card and NOT to
> > the external register address of the FIFO. In other words, I think with
> > incrementing address enabled in block mode, the register address of the
> > FIFO in the SDIO function register space will be erroneously changed on
> > the next block write and will fail (it seems to fail on my card). It
> > seems strange to change the register address ?
> > 
> 
> I don't follow. The SDIO specification very clearly defines the behaviour of incrementing address. The referenced code is very much needed to keep that behaviour when we need to split up the transfer.
> 
> I assume what you want is multiple transactions with incrementing address, but each transaction restarting at the same base address. In that case you'll have to call the sdio register functions multiple times.
> 
> Rgds
-- 
Dean Jenkins
Embedded Software Engineer
MontaVista Software (UK)
Professional Services Division

