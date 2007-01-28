Return-Path: <linux-kernel-owner+w=401wt.eu-S932939AbXA1W6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939AbXA1W6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 17:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932951AbXA1W6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 17:58:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:38393 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939AbXA1W6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 17:58:52 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45B95D3A.10108@pobox.com>
References: <20070125150905.652f9ce2@localhost.localdomain>
	 <1169741658.3593.98.camel@shinybook.infradead.org>
	 <20070125172739.0c990a9a@localhost.localdomain>
	 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
	 <1169770985.3593.146.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
	 <45B95D3A.10108@pobox.com>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 09:57:19 +1100
Message-Id: <1170025039.26655.96.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On sparc64, for example, after I pointed this out to DaveM, he was able 
> to implement the new iomap interface without the 'if (pio-mem-area)' 
> branch present on x86.

Yup, we did that from day 1 on powerpc :-) However, I don't totally
agree with adding some other remapping layer here, I think if we want
PIO 0 to be illegal, then make it illegal at the HW level too.

The reason is in fact the same as Linus invoked for remapping it in the
first place -> make things look like an x86 :-)

That is, quite a few non-x86 machines do have some kind of superIO chip
or other set of legacy devices around. They also commonly have VGA cards
hard decoding VGA PIO addresses.

So here's a very simplified version on how most non-x86 platforms do
PIO :

at boot:

 pci_io_base = ioremap(MAGIC_PIO_REGION);

and then

 #define inb(port)	(readb(pci_io_base + (port)))

The nice thing with that approach is that all those legacy x86 drivers
for bits in your SuperIO chip or for VGA do actually still work when they
do

 inb(STUPID_HARD_CODED_IO_PORT);

While if we now add some magic remapping to make 0 illegal, that will break
and all those legacy drivers would have to be fixed, which nobody wants
to do.

So I do stand firm there. I don't necessarily mind deciding that 0 is an
illegal PIO address, but if we're going to do that, we should make it
illegal as a HW PIO address, not by adding a remapping trick to something
that really doesn't want more than it already has :-)

Ben.


