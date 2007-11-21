Return-Path: <linux-kernel-owner+w=401wt.eu-S1759716AbXKUNI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbXKUNI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 08:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXKUNIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 08:08:45 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:47513 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbXKUNIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 08:08:44 -0500
Date: Wed, 21 Nov 2007 14:08:40 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: djenkins@mvista.co.uk
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MMC sub-system: SDIO block-mode with increment address issue
Message-ID: <20071121140840.6476c6aa@poseidon.drzeus.cx>
In-Reply-To: <1195646221.20691.71.camel@libdev3.libertesoft.co.uk>
References: <1195472694.18869.57.camel@libdev3.libertesoft.co.uk>
	<20071120115841.25765bd3@poseidon.drzeus.cx>
	<1195561571.13874.4.camel@libdev3.libertesoft.co.uk>
	<20071120151032.56bf3e31@poseidon.drzeus.cx>
	<1195646221.20691.71.camel@libdev3.libertesoft.co.uk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 11:57:01 +0000
Dean Jenkins <djenkins@mvista.co.uk> wrote:

> Hi Pierre,
> 
> I've looked at the SD Card Association's SDIO Part E1 V2.00
> specification concerning the Incrementing Address OP Code field for
> CMD53.
> 
> The specification indicates that the START ADDRESS is inserted into the
> Register Address register field. When the OP Code field has a value of 1
> then the during the transfer the IO address is internally incremented
> for each byte transferred. This applies to a single CMD53 command.
> 
> Looking at the implementation of sdio_io_rw_ext_helper() in sdio_io.c.
> This function can send multiple CMD53 commands. My concern is that with
> incrementing address mode selected the START ADDRESS is erroneously
> changed for subsequent CMD53 commands in the while loop.
> 

Since the caller is not supposed to care about the internal operation of sdio_io_rw_ext_helper(), the address increase is a must to maintain a consistent behaviour regardless of what transactions it decides to use.

I.e. if I write 2048 bytes with start address 0x1000, I expect it to do a single write to register 0x1000 through 0x17FF, not and unknown number of writes to some unknown interval.

Now what I suspect you're championing is to support some broken card that treats the address increase bit in CMD53 as "Magic voodoo bit #5" instead of the definition in the SDIO spec. I.e. the only address it cares about is the start address and hence needs it to be the same for each transaction. This kind of blatant disregard for the SDIO register design is of course not what sdio_io_rw_ext_helper() was designed for, and probably never will be.

> What I am trying to say is I don't believe the START ADDRESS should be
> changed by the core driver when incrementing address mode is used. I
> think incrementing address mode only applies internally to a single
> CMD53 command. The SDIO card must physically have a suitable register
> present at the START ADDRESS so changing this address to something
> dependent on the data size is going to fail I think.
> 

The SDIO card must physically have a suitable register present at the entire relevant range, not just the start address. If it doesn't then it isn't following the register interface design of SDIO (having the "increase address" bit would just be silly if the arguments were arbitrary tokens and not part of a consistent address space).

> Do you have any evidence that any card drivers will use
> sdio_io_rw_ext_helper() in a manner that needs the START ADDRESS to be 
> changed by the core driver ?
> 

There are no drivers using "increase address" yet. The ones so far have all used a single byte FIFO port.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
