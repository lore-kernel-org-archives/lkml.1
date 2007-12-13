Return-Path: <linux-kernel-owner+w=401wt.eu-S1761590AbXLMKay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590AbXLMKay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbXLMKap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:30:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43446 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752847AbXLMKan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:30:43 -0500
Date: Thu, 13 Dec 2007 10:24:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Robert Hancock <hancockr@shaw.ca>, benh@kernel.crashing.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Possible issue with dangling PCI BARs
Message-ID: <20071213102424.18b621a7@the-village.bc.nu>
In-Reply-To: <20071213120403.B21124@jurassic.park.msu.ru>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no>
	<fa.EhUqlM3V3y3HCcQkLBLSEKTJxBs@ifi.uio.no>
	<fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no>
	<4760B37E.3010002@shaw.ca>
	<20071213120403.B21124@jurassic.park.msu.ru>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So disabling memory or IO decode in a command register seems to be
> the only safe option. This depends on architecture, though.

You are assuming a degree of sanity that seems unwise (at least for PC
class hardware).

Whether a given BAR is decoded depends not only on the contents of the
BAR but also the hardware configuration *specific* to the device.

The SIL680 for example has an MMIO BAR at BAR5. Control for that BAR is
via MMIO_EN which is a bit in PCI config register 0x8A.

So if we disable the device because of a dangling BAR the users root file
system goes away. If we leave it as is we have to know the
firmware/hardware came up with that BAR disabled or how to control it at
a per device level.

Supporting pci_enable_device_io / pci_enable_device_mmio / pci_iomap_io /
pci_iomap_mmio seems to cover pretty much all the use cases we have. 

The users we have right now that are:

	- pata_cs5520   (can be dealt with easily)
	- old IDE	(with the new resource handling for legacy IDE
can use pci_enable_device_io I think, ditto pci/cs5520)
	- scx200_acb	(looks like a simple substitution works)
	- lpfc		pci_enable_device_mmio
	- qla2xxx	pci_enable_device ? (enables IO and MMIO)

Alan
