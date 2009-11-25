Return-Path: <linux-kernel-owner+w=401wt.eu-S934878AbZKYROM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878AbZKYROM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934831AbZKYROJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:14:09 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52976 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934822AbZKYRNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:13:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=d+0FsHTgMvgfnmbe/AnMycVqJSXG6oD6NfEV54X4vOUSTsPUHi/pgMo1LfgHO0DjD7
         OxrhB4llBMVl0x6hz+J8e9EoFkXBiarJU7ZpO4JBSi8+mFDPcp8NObgWhjH7rriQ8wXS
         OScQ4HO95jW4AcSzTC3Awm3OBHYsmMr1LBJR4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:12:32 +0100
Message-Id: <20091125171232.5446.28166.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 84/86] libata: add ata_mwdma_to_pio() inline helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: add ata_mwdma_to_pio() inline helper

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c     |   11 ++---------
 drivers/ata/pata_efar.c    |    8 +-------
 drivers/ata/pata_it8213.c  |    8 +-------
 drivers/ata/pata_oldpiix.c |    9 +--------
 drivers/ata/pata_radisys.c |   12 +++---------
 drivers/ata/pata_rdc.c     |   11 ++---------
 include/linux/ata.h        |   11 +++++++++++
 7 files changed, 21 insertions(+), 49 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -831,16 +831,9 @@ static void do_pata_set_dmamode(struct a
 		pci_write_config_byte(dev, 0x48, udma_enable);
 
 		spin_unlock_irqrestore(&piix_lock, flags);
-	} else {
+	} else
 		/* MWDMA is driven by the PIO timings. */
-		unsigned int mwdma = speed - XFER_MW_DMA_0;
-		const unsigned int needed_pio[3] = {
-			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-		};
-		int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-		piix_set_timings(ap, adev, pio, 1);
-	}
+		piix_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
 }
 
 /**
Index: b/drivers/ata/pata_efar.c
===================================================================
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -176,13 +176,7 @@ static void efar_set_dmamode (struct ata
 		pci_write_config_word(dev, 0x4A, udma_timing);
 	} else {
 		/* MWDMA is driven by the PIO timings. */
-		unsigned int mwdma = speed - XFER_MW_DMA_0;
-		const unsigned int needed_pio[3] = {
-			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-		};
-		int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-		efar_set_timings(ap, adev, pio, 1);
+		efar_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
 
 		udma_enable &= ~(1 << devid);
 	}
Index: b/drivers/ata/pata_it8213.c
===================================================================
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -186,13 +186,7 @@ static void it8213_set_dmamode (struct a
 		pci_write_config_word(dev, 0x54, ideconf);
 	} else {
 		/* MWDMA is driven by the PIO timings. */
-		unsigned int mwdma = speed - XFER_MW_DMA_0;
-		static const unsigned int needed_pio[3] = {
-			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-		};
-		int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-		it8213_set_timings(ap, adev, pio, 1);
+		it8213_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
 
 		udma_enable &= ~(1 << devid);
 	}
Index: b/drivers/ata/pata_oldpiix.c
===================================================================
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -135,14 +135,7 @@ static void oldpiix_set_piomode(struct a
 static void oldpiix_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 {
 	/* MWDMA is driven by the PIO timings. */
-
-	unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
-	const unsigned int needed_pio[3] = {
-		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-	};
-	int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-	oldpiix_set_timings(ap, adev, pio, 1);
+	oldpiix_set_timings(ap, adev, ata_mwdma_to_pio(adev->dma_mode), 1);
 }
 
 /**
Index: b/drivers/ata/pata_radisys.c
===================================================================
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -102,18 +102,12 @@ static void radisys_set_dmamode (struct
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	u8 udma_enable;
 
-	/* MWDMA is driven by the PIO timings. */
-
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 
 	if (adev->dma_mode < XFER_UDMA_0) {
-		unsigned int mwdma	= adev->dma_mode - XFER_MW_DMA_0;
-		const unsigned int needed_pio[3] = {
-			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-		};
-		int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-		radisys_set_timings(ap, adev, pio, 1);
+		/* MWDMA is driven by the PIO timings. */
+		radisys_set_timings(ap, adev,
+				    ata_mwdma_to_pio(adev->dma_mode), 1);
 
 		udma_enable &= ~(1 << adev->devno);
 	} else {
Index: b/drivers/ata/pata_rdc.c
===================================================================
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -227,16 +227,9 @@ static void rdc_set_dmamode(struct ata_p
 		pci_write_config_word(dev, 0x54, ideconf);
 
 		pci_write_config_byte(dev, 0x48, udma_enable);
-	} else {
+	} else
 		/* MWDMA is driven by the PIO timings. */
-		unsigned int mwdma = speed - XFER_MW_DMA_0;
-		const unsigned int needed_pio[3] = {
-			XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
-		};
-		int pio = needed_pio[mwdma] - XFER_PIO_0;
-
-		rdc_set_timings(ap, adev, pio, 1);
-	}
+		rdc_set_timings(ap, adev, ata_mwdma_to_pio(speed), 1);
 }
 
 static struct ata_port_operations rdc_pata_ops = {
Index: b/include/linux/ata.h
===================================================================
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -1012,4 +1012,15 @@ static inline int lba_48_ok(u64 block, u
 #define sata_pmp_gscr_rev(gscr)		(((gscr)[SATA_PMP_GSCR_REV] >> 8) & 0xff)
 #define sata_pmp_gscr_ports(gscr)	((gscr)[SATA_PMP_GSCR_PORT_INFO] & 0xf)
 
+/* returns PIO number matching given MWDMA mode */
+static inline u8 ata_mwdma_to_pio(u8 mwdma_mode)
+{
+	unsigned int mwdma = mwdma_mode - XFER_MW_DMA_0;
+	const unsigned int needed_pio[3] = {
+		XFER_PIO_0, XFER_PIO_3, XFER_PIO_4
+	};
+
+	return needed_pio[mwdma] - XFER_PIO_0;
+}
+
 #endif /* __LINUX_ATA_H__ */
