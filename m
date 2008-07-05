Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYGEKmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYGEKmT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 06:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYGEKmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 06:42:11 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:55545 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbYGEKmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 06:42:09 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: pata_it821x completely broken
Date: Sat, 5 Jul 2008 12:41:58 +0200
User-Agent: KMail/1.9.9
Cc: alan@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <200807042339.02444.linux@rainbow-software.org> <20080704224636.352e4a7b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080704224636.352e4a7b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807051242.00545.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2008 23:46:36 Alan Cox wrote:
> > It complains pretty loudly - something like 3 screens (with framebuffer
> > at 1024x768) of errors like this:
>
> Interesting. I need to have a poke at that - it used to work fine but
> I've not tested the 821x recently and the HPA code has changed. It
> shouldn't be issuing HPA commands in the first place. Added to the TODO
> list. The HPA is supposed to be cleared by the driver setup code but if
> the newer firmware is faking it then I wonder what it does if we allow
> the command through.
>
> > It's BIOS v1.7.1.94, firmware 02093030. Haven't tried waiting for the
> > rebuild to complete. It will probably take ages for 400GB drives. I'll
> > try with some much smaller drives (something <1GB).
>
> Thanks

Tested with various drives connected as slaves (in addidion to the two 400GB 
Samsungs). Seems like any drive that can't do UDMA fails (looks like MWDMA is 
broken). The controller BIOS creates the array fine but it doesn't work in 
Linux. In smart mode, it fails to identify (this is probably the same problem 
as with any other RAID array):

pata_it821x: controller in smart mode.
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> 
IRQ 11
PCI: Setting latency timer of device 0000:00:12.0 to 64
scsi2 : pata_it821x
scsi3 : pata_it821x
ata3: PATA max MWDMA2 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
ata4: PATA max MWDMA2 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
ata3.01: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
ata3: failed to recover some devices, retrying in 5 secs
ata3.01: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
ata3: failed to recover some devices, retrying in 5 secs
ata3.01: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
ata3: failed to recover some devices, retrying in 5 secs
ata3.00: ATA-7: SAMSUNG HD400LD, WQ100-15, max UDMA/100
ata3.00: 781422768 sectors, multi 0: LBA48
ata3.00: configured for DMA
ata4.00: ATA-7: SAMSUNG HD400LD, WQ100-15, max UDMA/100
ata4.00: 781422768 sectors, multi 0: LBA48
ata4.00: configured for DMA

When I force the pass-through mode, it oopses (haven't captured it yet as it's 
too long). Forcing pass-through mode works fine with UDMA-capable drives:

pata_it821x: forcing bypass mode.
pata_it821x: controller in pass through mode.
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> 
IRQ 11
scsi2 : pata_it821x
scsi3 : pata_it821x
ata3: PATA max UDMA/133 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
ata4: PATA max UDMA/133 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
ata3.00: ATA-7: SAMSUNG HD400LD, WQ100-15, max UDMA/100
ata3.00: 781422768 sectors, multi 0: LBA48
ata3.01: ATA-4: ST36531A, 3.11, max UDMA/33
ata3.01: 12706470 sectors, multi 0: LBA
ata3.00: configured for UDMA/100
ata3.01: configured for UDMA/33
ata4.00: ATA-7: SAMSUNG HD400LD, WQ100-15, max UDMA/100
ata4.00: 781422768 sectors, multi 0: LBA48
ata4.01: ATA-4: QUANTUM FIREBALL EL2.5A, A08.1100, max UDMA/33
ata4.01: 5008500 sectors, multi 0: LBA
ata4.00: limited to UDMA/33 due to 40-wire cable
ata4.00: configured for UDMA/33
ata4.01: configured for UDMA/33


Then I created RAID 1 from the Seagate and Quantum drives. No matter if the 
rebuild process is running or not, the result is the same - the drives that 
form RAID aren't accessible, the other drives work:

pata_it821x: controller in smart mode.
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:12.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> 
IRQ 11
PCI: Setting latency timer of device 0000:00:12.0 to 64
scsi2 : pata_it821x
scsi3 : pata_it821x
ata3: PATA max MWDMA2 cmd 0x6800 ctl 0x6c00 bmdma 0x7800 irq 11
ata4: PATA max MWDMA2 cmd 0x7000 ctl 0x7400 bmdma 0x7808 irq 11
ata3.01: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
ata3: failed to recover some devices, retrying in 5 secs
ata3.01: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
ata3: failed to recover some devices, retrying in 5 secs
ata3.01: failed to IDENTIFY (INIT_DEV_PARAMS failed, err_mask=0x80)
ata3: failed to recover some devices, retrying in 5 secs
ata3.00: ATA-7: SAMSUNG HD400LD, WQ100-15, max UDMA/100
ata3.00: 781422768 sectors, multi 0: LBA48
ata3.00: configured for DMA
ata4.00: ATA-7: SAMSUNG HD400LD, WQ100-15, max UDMA/100
ata4.00: 781422768 sectors, multi 0: LBA48
ata4.00: configured for DMA


(the secondary slave is missing - interesting)


-- 
Ondrej Zary
