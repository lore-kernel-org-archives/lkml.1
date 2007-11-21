Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXKUL5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXKUL5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 06:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbXKUL5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 06:57:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:63649 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbXKUL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 06:57:20 -0500
Subject: Re: MMC sub-system: SDIO block-mode with increment address issue
From: Dean Jenkins <djenkins@mvista.co.uk>
Reply-To: djenkins@mvista.co.uk
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20071120151032.56bf3e31@poseidon.drzeus.cx>
References: <1195472694.18869.57.camel@libdev3.libertesoft.co.uk>
	 <20071120115841.25765bd3@poseidon.drzeus.cx>
	 <1195561571.13874.4.camel@libdev3.libertesoft.co.uk>
	 <20071120151032.56bf3e31@poseidon.drzeus.cx>
Content-Type: text/plain
Organization: MontaVista
Date: Wed, 21 Nov 2007 11:57:01 +0000
Message-Id: <1195646221.20691.71.camel@libdev3.libertesoft.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.0.1.el5) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/S9meE2VZkrhN/JL/XV6rzNjlo973SVEKTFN3
 E8UV73fe0sqcVy9Md0yPr2/OVVFslU/5xbLZoGl4ypXTZdtDVr
 hJWCFBChv8A8y+RrCCVFw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

I've looked at the SD Card Association's SDIO Part E1 V2.00
specification concerning the Incrementing Address OP Code field for
CMD53.

The specification indicates that the START ADDRESS is inserted into the
Register Address register field. When the OP Code field has a value of 1
then the during the transfer the IO address is internally incremented
for each byte transferred. This applies to a single CMD53 command.

Looking at the implementation of sdio_io_rw_ext_helper() in sdio_io.c.
This function can send multiple CMD53 commands. My concern is that with
incrementing address mode selected the START ADDRESS is erroneously
changed for subsequent CMD53 commands in the while loop.

What I am trying to say is I don't believe the START ADDRESS should be
changed by the core driver when incrementing address mode is used. I
think incrementing address mode only applies internally to a single
CMD53 command. The SDIO card must physically have a suitable register
present at the START ADDRESS so changing this address to something
dependent on the data size is going to fail I think.

Do you have any evidence that any card drivers will use
sdio_io_rw_ext_helper() in a manner that needs the START ADDRESS to be
changed by the core driver ?

Regards,
Dean.


On Tue, 2007-11-20 at 15:10 +0100, Pierre Ossman wrote:
> On Tue, 20 Nov 2007 12:26:11 +0000
> Dean Jenkins <djenkins@...> wrote:
> 
> > Hi Pierre,
> > 
> > IMHO the issue is there is no upper bound limit to the valid address
> > range in sdio_io_rw_ext_helper() in sdio_io.c.
> > 
> > I call sdio_memcpy_toio() as it enables the incrementing address flag in
> > the CMD53 command but if I try passing too much data then the actual
> > address of the subsequent CMD53 commands are erroneously incremented out
> > of range.
> > 
> > The difficulty is the SDIO card can transfer 8 blocks in a single CMD53
> > command using the incrementing address flag. However
> > sdio_io_rw_ext_helper() will not prevent the attempt at sending 9 blocks
> > transferred as 2 CMD53 commands of 8 blocks + 1 block and the last block
> > goes to the wrong address. This causes a big system crash. I suspect the
> > SDIO card internally resets and the MMC sub-system can't handle the
> > error condition.
> 
> I'm afraid I still can't see the problem. If you want to transfer 9 blocks, then the method by which you do so shouldn't matter. So 9, or 8 + 1 should give the same end result.
> 
> > 
> > This means the card driver needs to know that it cannot use
> > sdio_memcpy_toio() to send any size of data but must ensure it does not
> > exceed 8 blocks before calling sdio_memcpy_toio(). IMHO this makes the
> > card driver undesirably tightly coupled with the core driver. OK. I'll
> > workaround it using multiple calls to sdio_memcpy_toio().
> > 
> 
> Well, the problem is that the abstraction used should work just fine according to how the SDIO standard is defined. The problem seems to be that some card vendors decided to go their own way and started treating the SDIO interface as something other than a simple register interface.
> 
> As long as that is the case, there will be a lot of pain supporting these weird cards. We can only debate where to put that pain and what compromises to make.
> 
> > BTW. Is the API for the exported SDIO core functions documented
> > anywhere ?
> 
> Yes, as kerneldoc tags for the relevant functions. Have a look in drivers/core/sdio_io.c if you don't want to build the full document.
> 
> Rgds
-- 
Dean Jenkins
Embedded Software Engineer
MontaVista Software (UK)
Professional Services Division

