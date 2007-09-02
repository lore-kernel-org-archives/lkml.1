Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbXIBTDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbXIBTDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXIBTDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:03:24 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:46652 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbXIBTDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:03:23 -0400
Message-ID: <46DB088C.6080907@free.fr>
Date: Sun, 02 Sep 2007 21:01:32 +0200
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1: broke pata_via cable detection
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01.09.2007 06:58, Andrew Morton a écrit :
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/
[...]
> +libata-correct-handling-of-srst-reset-sequences.patch
[...]

Alan,

libata-correct-handling-of-srst-reset-sequences.patch broke 80-wire
cable detection on pata_via driver:

> $ dmesg | grep ata1
> ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xb800 irq 14
> ata1.00: ATA-5: ST340016A, 3.75, max UDMA/100
> ata1.00: 78165360 sectors, multi 16: LBA 
> ata1.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
> ata1.01: 160086528 sectors, multi 16: LBA 
> ata1.00: limited to UDMA/33 due to 40-wire cable
> ata1.01: limited to UDMA/33 due to 40-wire cable
> ata1.00: configured for UDMA/33
> ata1.01: configured for UDMA/33

2.6.23-rc3-mm1 and 2.6.23-rc4 work fine (ata1 devices are configured
for UDMA/100).

Few weeks ago, I wrote a patch to solve a wrong cable detection
problem after suspend-to-disk/resume, and it solves this problem
too. Is it the right way to go ?



via_do_set_mode overwrites 80-wire cable detection bits. Let's
preserve them.

Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>
---
 drivers/ata/pata_via.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6-mm/drivers/ata/pata_via.c
===================================================================
--- linux-2.6-mm.orig/drivers/ata/pata_via.c
+++ linux-2.6-mm/drivers/ata/pata_via.c
@@ -245,6 +245,7 @@ static void via_do_set_mode(struct ata_p
 	unsigned long T =  1000000000 / via_clock;
 	unsigned long UT = T/tdiv;
 	int ut;
+	u8 cable80_status;
 	int offset = 3 - (2*ap->port_no) - adev->devno;


@@ -294,9 +295,14 @@ static void via_do_set_mode(struct ata_p
 			ut = t.udma ? (0xe0 | (FIT(t.udma, 2, 9) - 2)) : 0x07;
 			break;
 	}
+
+	/* Get 80-wire cable detection bit */
+	pci_read_config_byte(pdev, 0x50 + offset, &cable80_status);
+	cable80_status &= 0x10;
+
 	/* Set UDMA unless device is not UDMA capable */
 	if (udma_type)
-		pci_write_config_byte(pdev, 0x50 + offset, ut);
+		pci_write_config_byte(pdev, 0x50 + offset, ut | cable80_status);
 }

 static void via_set_piomode(struct ata_port *ap, struct ata_device
*adev)


