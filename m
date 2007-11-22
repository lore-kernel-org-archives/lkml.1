Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbXKVLnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbXKVLnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 06:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXKVLnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 06:43:01 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:40629 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbXKVLnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 06:43:00 -0500
Date: Thu, 22 Nov 2007 12:42:44 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: djenkins@mvista.co.uk
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MMC/SDIO sub-system: block mode versus byte mode
Message-ID: <20071122124244.4d3808be@poseidon.drzeus.cx>
In-Reply-To: <1195728103.20691.125.camel@libdev3.libertesoft.co.uk>
References: <1195728103.20691.125.camel@libdev3.libertesoft.co.uk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 10:41:43 +0000
Dean Jenkins <djenkins@mvista.co.uk> wrote:

> Hi Pierre,
> 
> I've been checking my SDIO CMD53 data transfers and I notice the
> following:
> 
> block size = 256 bytes for my SDIO card.
> 
> transfers of 256 bytes uses byte mode ( I expected block mode )
> transfers of 512 bytes uses block mode ( because blocks = 2 )
> 
> From the SD spec a single block transfer seems to be valid.
> 

Both are valid, which is the source of the problem. The API was designed under the assumption that hardware actually followed the register interface and didn't distinguish between byte and block transfers. Unfortunately, it seems to be quite common that they do. Your situation is a problematic corner case.

> 
> If it is a bug then I suggest the sdio_io_rw_ext_helper() in sdio_io.c
> be able to select byte mode by setting blocks to 0 and then blocks can
> be set to 1 to select block mode for a single block.
> 

I'm afraid I don't follow. Do you want to add another parameter? Even if you do, sdio_io_rw_ext_helper() is an internal API. Changing it won't make things better for the function drivers.

> 
> Technically, there is a bug in sdio_io_rw_ext_helper() in sdio_io.c
> 
> 211		while (remainder > func->cur_blksize) {
> 
> should be, = missing
> 
> 211		while (remainder >= func->cur_blksize) {
> 

Unless some hardware is quirky in the opposite way and needs to be able to do byte transfer of 256 bytes. Proper cards won't care either way, but as you can see, we can't support both types of buggy cards.

> however the resulting call to mmc_io_rw_extended() is the same as blocks
> = 1 for both the "block mode" while loop (with the "fix") and the "byte
> mode" while loop (without the "fix"). The "byte mode" while loop has a
> hard coded value of 1 for the blocks parameter. So the bug is masked. As
> I said above, I think the "byte mode" should use a value of 0 for the
> blocks parameter.
> 

Ah. mmc_io_rw_extended() is indeed broken in that it can't do single block requests. That should be fixed.

However, it still won't affect what your function driver can do as mmc_io_rw_extended() is a bunch of layers down.

I guess I'll have to consider adding a more low-level API. The big problem with such a call would be that it can fail requests because the host or card cannot satisfy them. So a function driver using such an API would have to use a much more defensive programming (which can incur a performance hit).

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
