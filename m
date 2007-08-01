Return-Path: <linux-kernel-owner+w=401wt.eu-S1763918AbXHAUOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763918AbXHAUOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762091AbXHAUNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:13:46 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:53484 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbXHAUNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:13:44 -0400
Message-ID: <46B0E975.30404@free.fr>
Date: Wed, 01 Aug 2007 22:13:41 +0200
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2 (checks-for-80wire-cable-use-in-pata_via)
References: <20070731230932.a9459617.akpm@linux-foundation.org>
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01.08.2007 08:09, Andrew Morton a écrit :
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm2/
...
> +libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
...
>  sata/pata things

Alan,

this does not work after a suspend-resume cycle, I get a " ACPI get
timing mode failed (AE 0x1001)" error.

$ dmesg | grep ata
...
scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma
0x0001b800 irq 14
ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma
0x0001b808 irq 15
ata1.00: ATA-5: ST340016A, 3.75, max UDMA/100
ata1.00: 78165360 sectors, multi 16: LBA
ata1.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
ata1.01: 160086528 sectors, multi 16: LBA
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/100
ata2.00: ATAPI: HL-DT-ST DVDRAM GSA-4165B, DL03, max UDMA/33
ata2.01: ATAPI: CD-950E/AKU, A4Q, max MWDMA2, CDB intr
ata2.00: configured for UDMA/33
ata2.01: configured for MWDMA2
ata1.00: Unable to set Link PM policy
ata1.01: Unable to set Link PM policy
ata2.00: Unable to set Link PM policy
ata2.01: Unable to set Link PM policy
...
[ suspend-to-disk/resume cycle happens here ]
...
ata1.00: Unable to set Link PM policy
ata1.01: Unable to set Link PM policy
ata2.00: Unable to set Link PM policy
ata2.01: Unable to set Link PM policy
ata1: ACPI get timing mode failed (AE 0x1001)   <==========
ata1.00: limited to UDMA/33 due to 40-wire cable
ata1.01: limited to UDMA/33 due to 40-wire cable
ata1.00: configured for UDMA/33
ata1.01: configured for UDMA/33
ata2: ACPI get timing mode failed (AE 0x1001)
ata2.00: configured for UDMA/33
ata2.01: configured for MWDMA2


Anyway, long before 2.6.23-rc1-mm2, 80-wire cable detection was
already wrong after a suspend-resume cycle. So I cooked the
following patch 2 days ago.

It may be the wrong approach but it works for me.

-- 
pata_via: preserve cable detection bits in via_do_set_mode

via_cable_detect performs cable detection by checking bits in PCI
layer. But via_do_set_mode overwrites these bits. This behaviour
breaks cable detection after suspend/resume cycle.

So let's teach via_do_set_mode to preserve cable detection bits.

Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>
---

 drivers/ata/pata_via.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6-mm/drivers/ata/pata_via.c
===================================================================
--- linux-2.6-mm.orig/drivers/ata/pata_via.c
+++ linux-2.6-mm/drivers/ata/pata_via.c
@@ -238,6 +238,7 @@ static void via_do_set_mode(struct ata_p
 	unsigned long T =  1000000000 / via_clock;
 	unsigned long UT = T/tdiv;
 	int ut;
+	u8 cable80_status;
 	int offset = 3 - (2*ap->port_no) - adev->devno;


@@ -287,6 +288,12 @@ static void via_do_set_mode(struct ata_p
 			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 9) - 2)) : 0x07;
 			break;
 	}
+
+	/* Preserve cable detection bit */
+	pci_read_config_byte(pdev, 0x50 + offset, &cable80_status);
+	cable80_status &= 0x10;
+	ut |= cable80_status;
+
 	/* Set UDMA unless device is not UDMA capable */
 	if (udma_type)
 		pci_write_config_byte(pdev, 0x50 + offset, ut);



