Return-Path: <linux-kernel-owner+w=401wt.eu-S1764392AbZFLToR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764392AbZFLToR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbZFLToF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:44:05 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:50080 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbZFLToE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:44:04 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: abelay@mit.edu, bjorn.helgaas@hp.com,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Non-requested PCI IRQs unavailable to ISA PnP devices and pci_dev_uses_irq()
Date: Fri, 12 Jun 2009 21:43:57 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2491
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200906122143.59510.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
some PCI devices have an IRQ but the driver does not use it. Such an example 
is matroxfb. It does request_irq() only for some vblank operations. Thus, the 
irq is not marked as used in /proc/interrupts:
           CPU0
  0:     246481    XT-PIC-XT        timer
  1:       3507    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  3:          1    XT-PIC-XT
  4:          1    XT-PIC-XT
  5:       4306    XT-PIC-XT        eth0
  6:          5    XT-PIC-XT        floppy
  7:          1    XT-PIC-XT        parport0
  8:          1    XT-PIC-XT        rtc
  9:          0    XT-PIC-XT        acpi
 11:      13748    XT-PIC-XT        pata_it821x, uhci_hcd:usb1
 12:      65539    XT-PIC-XT        i8042
 14:          0    XT-PIC-XT        ata_piix
 15:      33052    XT-PIC-XT        ata_piix
NMI:          0   Non-maskable interrupts
ERR:          0

IRQ 10 is not listed but is used by one of the two Matrox cards:

pci 0000:00:13.0: Boot video device
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
matroxfb 0000:00:13.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 
11
matroxfb: Matrox Mystique (PCI) detected
PInS memtype = 0
matroxfb: MTRR's turned on
matroxfb: 1024x768x8bpp (virtual: 1024x4096)
matroxfb: framebuffer at 0xE1000000, mapped to 0xd0880000, size 4194304
Console: switching to colour frame buffer device 128x48
fb0: MATROX frame buffer device
matroxfb 0000:00:14.0: enabling device (0000 -> 0002)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
matroxfb 0000:00:14.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 
10
matroxfb: Matrox Millennium II (PCI) detected
PInS memtype = 0
matroxfb: MTRR's turned on
matroxfb: 1024x768x8bpp (virtual: 1024x4096)
matroxfb: framebuffer at 0xE3000000, mapped to 0xd1100000, size 4194304
fb1: MATROX frame buffer device
fb1: initializing hardware


But this interrupt is not available to ISA PnP devices because 
drivers/pnp/resource.c calls pci_uses_irq() function which in turn calls 
pci_dev_uses_irq() for all PCI devices. pci_dev_uses_irq() simply checks the 
irq field in struct pci_dev.

I wonder if that's correct (is it a bug or a feature)?

I can't use CMI8239A sound card on my machine because of this (it needs two 
IRQs). When I comment out that check (and move eth0 to IRQ3), the sound card 
works, allocating IRQ 10 and 3 (with some modifications to cmi8330 driver - 
will be posted separately).


-- 
Ondrej Zary
