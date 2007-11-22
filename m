Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbXKVMP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbXKVMP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 07:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbXKVMPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 07:15:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:50375 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbXKVMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 07:15:17 -0500
Subject: Re: MMC/SDIO sub-system: block mode versus byte mode
From: Dean Jenkins <djenkins@mvista.co.uk>
Reply-To: djenkins@mvista.co.uk
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20071122124244.4d3808be@poseidon.drzeus.cx>
References: <1195728103.20691.125.camel@libdev3.libertesoft.co.uk>
	 <20071122124244.4d3808be@poseidon.drzeus.cx>
Content-Type: text/plain
Organization: MontaVista
Date: Thu, 22 Nov 2007 12:15:11 +0000
Message-Id: <1195733711.29143.3.camel@libdev3.libertesoft.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.0.1.el5) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/NQId9sq1x8Q+qUiOPUpWcikLigIn04WTtqiW
 17xC7LRwFJ6zHcflF/zMoD3Yt3c7eSIusZx/Yrli/fERIF7GD2
 Ue7YvMN1nfwWLElh4vjlA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

Thanks for information.

My card does support 256 byte transfers in byte mode but I was expecting
block mode to be used as block mode is supported by the card. Indeed,
sdio_io_rw_ext_helper() checks for support of block mode before using
byte mode. eg. block mode is preferred over byte mode in the design of
sdio_io_rw_ext_helper().

Yes, I do think single block transfers is broken :(

Both sdio_io_rw_ext_helper() and mmc_io_rw_extended() are broken for
single block transfers.

Will you be doing a fix or how does a fix get proposed ?

Thanks,

Regards,
Dean.


On Thu, 2007-11-22 at 12:42 +0100, Pierre Ossman wrote: 
> On Thu, 22 Nov 2007 10:41:43 +0000
> Dean Jenkins <djenkins@...> wrote:
> 
> > Hi Pierre,
> > 
> > I've been checking my SDIO CMD53 data transfers and I notice the
> > following:
> > 
> > block size = 256 bytes for my SDIO card.
> > 
> > transfers of 256 bytes uses byte mode ( I expected block mode )
> > transfers of 512 bytes uses block mode ( because blocks = 2 )
> > 
> > From the SD spec a single block transfer seems to be valid.
> > 
> 
> Both are valid, which is the source of the problem. The API was designed under the assumption that hardware actually followed the register interface and didn't distinguish between byte and block transfers. Unfortunately, it seems to be quite common that they do. Your situation is a problematic corner case.
> 
> > 
> > If it is a bug then I suggest the sdio_io_rw_ext_helper() in sdio_io.c
> > be able to select byte mode by setting blocks to 0 and then blocks can
> > be set to 1 to select block mode for a single block.
> > 
> 
> I'm afraid I don't follow. Do you want to add another parameter? Even if you do, sdio_io_rw_ext_helper() is an internal API. Changing it won't make things better for the function drivers.
> 
> > 
> > Technically, there is a bug in sdio_io_rw_ext_helper() in sdio_io.c
> > 
> > 211		while (remainder > func->cur_blksize) {
> > 
> > should be, = missing
> > 
> > 211		while (remainder >= func->cur_blksize) {
> > 
> 
> Unless some hardware is quirky in the opposite way and needs to be able to do byte transfer of 256 bytes. Proper cards won't care either way, but as you can see, we can't support both types of buggy cards.
> 
> > however the resulting call to mmc_io_rw_extended() is the same as blocks
> > = 1 for both the "block mode" while loop (with the "fix") and the "byte
> > mode" while loop (without the "fix"). The "byte mode" while loop has a
> > hard coded value of 1 for the blocks parameter. So the bug is masked. As
> > I said above, I think the "byte mode" should use a value of 0 for the
> > blocks parameter.
> > 
> 
> Ah. mmc_io_rw_extended() is indeed broken in that it can't do single block requests. That should be fixed.
> 
> However, it still won't affect what your function driver can do as mmc_io_rw_extended() is a bunch of layers down.
> 
> I guess I'll have to consider adding a more low-level API. The big problem with such a call would be that it can fail requests because the host or card cannot satisfy them. So a function driver using such an API would have to use a much more defensive programming (which can incur a performance hit).
> 
> Rgds
-- 
Dean Jenkins
Embedded Software Engineer
MontaVista Software (UK)
Professional Services Division

