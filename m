Return-Path: <linux-kernel-owner+w=401wt.eu-S1761738AbZFLUi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761738AbZFLUi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 16:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZFLUiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 16:38:19 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:7608 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848AbZFLUiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 16:38:19 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: Non-requested PCI IRQs unavailable to ISA PnP devices and pci_dev_uses_irq()
Date: Fri, 12 Jun 2009 14:38:17 -0600
User-Agent: KMail/1.9.10
Cc: abelay@mit.edu, "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200906122143.59510.linux@rainbow-software.org>
In-Reply-To: <200906122143.59510.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906121438.17750.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 June 2009 01:43:57 pm Ondrej Zary wrote:
> Hello,
> some PCI devices have an IRQ but the driver does not use it. Such an example 
> is matroxfb. It does request_irq() only for some vblank operations. Thus, the 
> irq is not marked as used in /proc/interrupts:
>            CPU0
>   0:     246481    XT-PIC-XT        timer
>   1:       3507    XT-PIC-XT        i8042
>   2:          0    XT-PIC-XT        cascade
>   3:          1    XT-PIC-XT
>   4:          1    XT-PIC-XT
>   5:       4306    XT-PIC-XT        eth0
>   6:          5    XT-PIC-XT        floppy
>   7:          1    XT-PIC-XT        parport0
>   8:          1    XT-PIC-XT        rtc
>   9:          0    XT-PIC-XT        acpi
>  11:      13748    XT-PIC-XT        pata_it821x, uhci_hcd:usb1
>  12:      65539    XT-PIC-XT        i8042
>  14:          0    XT-PIC-XT        ata_piix
>  15:      33052    XT-PIC-XT        ata_piix
> NMI:          0   Non-maskable interrupts
> ERR:          0
> 
> IRQ 10 is not listed but is used by one of the two Matrox cards:
> 
> pci 0000:00:13.0: Boot video device
> ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> PCI: setting IRQ 11 as level-triggered
> matroxfb 0000:00:13.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 
> 11
> matroxfb: Matrox Mystique (PCI) detected
> PInS memtype = 0
> matroxfb: MTRR's turned on
> matroxfb: 1024x768x8bpp (virtual: 1024x4096)
> matroxfb: framebuffer at 0xE1000000, mapped to 0xd0880000, size 4194304
> Console: switching to colour frame buffer device 128x48
> fb0: MATROX frame buffer device
> matroxfb 0000:00:14.0: enabling device (0000 -> 0002)
> ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
> PCI: setting IRQ 10 as level-triggered
> matroxfb 0000:00:14.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 
> 10
> matroxfb: Matrox Millennium II (PCI) detected
> PInS memtype = 0
> matroxfb: MTRR's turned on
> matroxfb: 1024x768x8bpp (virtual: 1024x4096)
> matroxfb: framebuffer at 0xE3000000, mapped to 0xd1100000, size 4194304
> fb1: MATROX frame buffer device
> fb1: initializing hardware
> 
> 
> But this interrupt is not available to ISA PnP devices because 
> drivers/pnp/resource.c calls pci_uses_irq() function which in turn calls 
> pci_dev_uses_irq() for all PCI devices. pci_dev_uses_irq() simply checks the 
> irq field in struct pci_dev.
> 
> I wonder if that's correct (is it a bug or a feature)?

The code that tries to keep PCI and PNP IRQs from clashing is
definitely sub-optimal.  Of course, PNP doesn't know what the
matroxfb driver doesn't need the interrupt.  Some drivers request
and free the IRQ dynamically, depending on whether the device is
in use.

Maybe what we should be doing here is more sharing of PCI interrupts
to leave more available for PNP.  For example, the 00:14.0 device
that's currently using IRQ 10 is connected to a programmable IRQ
link (LNKA).  Possibly that link could be programmed to share IRQ 11
instead.

In the absence of an automatic mechanism, can you work around this
with the "acpi_irq_isa=10" kernel parameter?

Bjorn

> I can't use CMI8239A sound card on my machine because of this (it needs two 
> IRQs). When I comment out that check (and move eth0 to IRQ3), the sound card 
> works, allocating IRQ 10 and 3 (with some modifications to cmi8330 driver - 
> will be posted separately).



