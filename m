Return-Path: <linux-kernel-owner+w=401wt.eu-S1030584AbXAZCBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030584AbXAZCBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030586AbXAZCBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:01:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41279 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030584AbXAZCBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:01:53 -0500
Date: Thu, 25 Jan 2007 18:01:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jgarzik@pobox.com>
cc: David Woodhouse <dwmw2@infradead.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
In-Reply-To: <45B95D3A.10108@pobox.com>
Message-ID: <Pine.LNX.4.64.0701251751380.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain> 
 <1169741658.3593.98.camel@shinybook.infradead.org> 
 <20070125172739.0c990a9a@localhost.localdomain> 
 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
 <1169770985.3593.146.camel@shinybook.infradead.org>
 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
 <45B95D3A.10108@pobox.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jan 2007, Jeff Garzik wrote:
> 
> On sparc64, for example, after I pointed this out to DaveM, he was able to
> implement the new iomap interface without the 'if (pio-mem-area)' branch
> present on x86.

However, in all honesty, we have triggered bugs in that area too, simply 
because some driver code "knew" that PIO addresses could fit in 16 bits, 
and used u16 or "unsigned short" to remember the PIO address. Both ARM and 
Sparc was bitten by this, although usually the issue is trivial to fix 
once found.

Also, many ISA-only drivers actually have hardcoded PIO numbers (eg 
"0x1f0").

But yes, I would generally suggest that architectures where the PIO range 
is really just another magic MMIO range (which is most of the non-x86 
world, as you point out) might as well at least aim for doing the 
remapping early (ie with "pci_resource_start()")

Making that easy was one of my goals for the "new" IO accessor functions, 
in fact.

Not that many people actually use them.

So *if* you use the new "iomap" interfaces, and the new "pci_iomap()" 
things, that should actually not just allow drivers (like the ATA layer) 
to share much more code between the PIO and MMIO cases, but it hopefully 
actually makes it easier for strange architectures to do it all.

So traditionally, we've had PIO be "limited integer addresses, and some 
drivers know magic numbers", but hopefully new drivers could at least try 
to use some of the infrastructure where we try to help people not have to 
deal with it so much as a special case any more.

			Linus
