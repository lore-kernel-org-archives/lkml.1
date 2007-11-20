Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbXKTOKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbXKTOKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbXKTOKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:10:39 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:42657 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbXKTOKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:10:39 -0500
Date: Tue, 20 Nov 2007 15:10:32 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: djenkins@mvista.co.uk
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MMC sub-system: SDIO block-mode with increment address issue
Message-ID: <20071120151032.56bf3e31@poseidon.drzeus.cx>
In-Reply-To: <1195561571.13874.4.camel@libdev3.libertesoft.co.uk>
References: <1195472694.18869.57.camel@libdev3.libertesoft.co.uk>
	<20071120115841.25765bd3@poseidon.drzeus.cx>
	<1195561571.13874.4.camel@libdev3.libertesoft.co.uk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 12:26:11 +0000
Dean Jenkins <djenkins@mvista.co.uk> wrote:

> Hi Pierre,
> 
> IMHO the issue is there is no upper bound limit to the valid address
> range in sdio_io_rw_ext_helper() in sdio_io.c.
> 
> I call sdio_memcpy_toio() as it enables the incrementing address flag in
> the CMD53 command but if I try passing too much data then the actual
> address of the subsequent CMD53 commands are erroneously incremented out
> of range.
> 
> The difficulty is the SDIO card can transfer 8 blocks in a single CMD53
> command using the incrementing address flag. However
> sdio_io_rw_ext_helper() will not prevent the attempt at sending 9 blocks
> transferred as 2 CMD53 commands of 8 blocks + 1 block and the last block
> goes to the wrong address. This causes a big system crash. I suspect the
> SDIO card internally resets and the MMC sub-system can't handle the
> error condition.

I'm afraid I still can't see the problem. If you want to transfer 9 blocks, then the method by which you do so shouldn't matter. So 9, or 8 + 1 should give the same end result.

> 
> This means the card driver needs to know that it cannot use
> sdio_memcpy_toio() to send any size of data but must ensure it does not
> exceed 8 blocks before calling sdio_memcpy_toio(). IMHO this makes the
> card driver undesirably tightly coupled with the core driver. OK. I'll
> workaround it using multiple calls to sdio_memcpy_toio().
> 

Well, the problem is that the abstraction used should work just fine according to how the SDIO standard is defined. The problem seems to be that some card vendors decided to go their own way and started treating the SDIO interface as something other than a simple register interface.

As long as that is the case, there will be a lot of pain supporting these weird cards. We can only debate where to put that pain and what compromises to make.

> BTW. Is the API for the exported SDIO core functions documented
> anywhere ?

Yes, as kerneldoc tags for the relevant functions. Have a look in drivers/core/sdio_io.c if you don't want to build the full document.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
