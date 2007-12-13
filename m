Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbXLMLRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbXLMLRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 06:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXLMLR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 06:17:28 -0500
Received: from gate.crashing.org ([63.228.1.57]:54481 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbXLMLR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 06:17:27 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Robert Hancock <hancockr@shaw.ca>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071213102424.18b621a7@the-village.bc.nu>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no>
	 <fa.EhUqlM3V3y3HCcQkLBLSEKTJxBs@ifi.uio.no>
	 <fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no> <4760B37E.3010002@shaw.ca>
	 <20071213120403.B21124@jurassic.park.msu.ru>
	 <20071213102424.18b621a7@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 22:17:01 +1100
Message-Id: <1197544621.15741.132.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 10:24 +0000, Alan Cox wrote:
> 
> The SIL680 for example has an MMIO BAR at BAR5. Control for that BAR is
> via MMIO_EN which is a bit in PCI config register 0x8A.
> 
> So if we disable the device because of a dangling BAR the users root file
> system goes away. If we leave it as is we have to know the
> firmware/hardware came up with that BAR disabled or how to control it at
> a per device level.

Except that it's very likely that it will be assigned, whether it's used
or not, either by the BIOS or the kernel during
pci_assign_unassign_resources().

If we really have some devices where we -know- we can hide the thing
totally, we can then do a quirk for these.

We may be taking a small risk here, but what else do you propose ? The
problem of dangling BARs is real... One option is for me to address it
on powerpc and leave x86 alone as it might be more of an issue with
random crazy embedded firmware for us than it is for x86. As I said, the
workaround is completely self contained within arch code for now.

> Supporting pci_enable_device_io / pci_enable_device_mmio / pci_iomap_io /
> pci_iomap_mmio seems to cover pretty much all the use cases we have. 
> 
> The users we have right now that are:
> 
>         - pata_cs5520   (can be dealt with easily)
>         - old IDE       (with the new resource handling for legacy IDE
> can use pci_enable_device_io I think, ditto pci/cs5520)
>         - scx200_acb    (looks like a simple substitution works)
>         - lpfc          pci_enable_device_mmio
>         - qla2xxx       pci_enable_device ? (enables IO and MMIO)

Ok.

Ben.


