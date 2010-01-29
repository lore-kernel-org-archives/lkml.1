Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678Ab0A2QLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0A2QLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944Ab0A2QKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:10:11 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:47963 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab0A2QKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:10:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=affHHpAL2zz10+Dppa7OIlAYcwSfzvW7Zta8I56DpXlm+Lokf02GhiT38TvQu5oJvj
         /5pTaeaO9iDC4eeFze1mNW0r3TIOqF4pWuvRmmMBqKf2rZH/KKt40nSCQHa+nv61EPYr
         dzbZNkkqNVzq2bSJJR9oJD62E/gPGjhA3CiFk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:10:00 +0100
Message-Id: <20100129161000.21495.71355.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 64/68] pata_triflex: move code to be re-used by ide2libata to pata_triflex.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_triflex: move code to be re-used by ide2libata to pata_triflex.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_triflex.c |   72 ---------------------------------------------
 drivers/ata/pata_triflex.h |   69 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 71 deletions(-)

Index: b/drivers/ata/pata_triflex.c
===================================================================
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -69,77 +69,7 @@ static int triflex_prereset(struct ata_l
 	return ata_sff_prereset(link, deadline);
 }
 
-
-
-/**
- *	triflex_load_timing		-	timing configuration
- *	@ap: ATA interface
- *	@adev: Device on the bus
- *	@speed: speed to configure
- *
- *	The Triflex has one set of timings per device per channel. This
- *	means we must do some switching. As the PIO and DMA timings don't
- *	match we have to do some reloading unlike PIIX devices where tuning
- *	tricks can avoid it.
- */
-
-static void triflex_load_timing(struct ata_port *ap, struct ata_device *adev, int speed)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 timing = 0;
-	u32 triflex_timing, old_triflex_timing;
-	int channel_offset = ap->port_no ? 0x74: 0x70;
-	unsigned int is_slave	= (adev->devno != 0);
-
-
-	pci_read_config_dword(pdev, channel_offset, &old_triflex_timing);
-	triflex_timing = old_triflex_timing;
-
-	switch(speed)
-	{
-		case XFER_MW_DMA_2:
-			timing = 0x0103;break;
-		case XFER_MW_DMA_1:
-			timing = 0x0203;break;
-		case XFER_MW_DMA_0:
-			timing = 0x0808;break;
-		case XFER_SW_DMA_2:
-		case XFER_SW_DMA_1:
-		case XFER_SW_DMA_0:
-			timing = 0x0F0F;break;
-		case XFER_PIO_4:
-			timing = 0x0202;break;
-		case XFER_PIO_3:
-			timing = 0x0204;break;
-		case XFER_PIO_2:
-			timing = 0x0404;break;
-		case XFER_PIO_1:
-			timing = 0x0508;break;
-		case XFER_PIO_0:
-			timing = 0x0808;break;
-		default:
-			BUG();
-	}
-	triflex_timing &= ~ (0xFFFF << (16 * is_slave));
-	triflex_timing |= (timing << (16 * is_slave));
-
-	if (triflex_timing != old_triflex_timing)
-		pci_write_config_dword(pdev, channel_offset, triflex_timing);
-}
-
-/**
- *	triflex_set_piomode	-	set initial PIO mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *
- *	Use the timing loader to set up the PIO mode. We have to do this
- *	because DMA start/stop will only be called once DMA occurs. If there
- *	has been no DMA then the PIO timings are still needed.
- */
-static void triflex_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	triflex_load_timing(ap, adev, adev->pio_mode);
-}
+#include "pata_triflex.h"
 
 /**
  *	triflex_dma_start	-	DMA start callback
Index: b/drivers/ata/pata_triflex.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_triflex.h
@@ -0,0 +1,69 @@
+
+/**
+ *	triflex_load_timing		-	timing configuration
+ *	@ap: ATA interface
+ *	@adev: Device on the bus
+ *	@speed: speed to configure
+ *
+ *	The Triflex has one set of timings per device per channel. This
+ *	means we must do some switching. As the PIO and DMA timings don't
+ *	match we have to do some reloading unlike PIIX devices where tuning
+ *	tricks can avoid it.
+ */
+
+static void triflex_load_timing(struct ata_port *ap, struct ata_device *adev,
+				int speed)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u32 timing = 0;
+	u32 triflex_timing, old_triflex_timing;
+	int channel_offset = ap->port_no ? 0x74 : 0x70;
+	unsigned int is_slave	= (adev->devno != 0);
+
+	pci_read_config_dword(pdev, channel_offset, &old_triflex_timing);
+	triflex_timing = old_triflex_timing;
+
+	switch (speed) {
+	case XFER_MW_DMA_2:
+		timing = 0x0103; break;
+	case XFER_MW_DMA_1:
+		timing = 0x0203; break;
+	case XFER_MW_DMA_0:
+		timing = 0x0808; break;
+	case XFER_SW_DMA_2:
+	case XFER_SW_DMA_1:
+	case XFER_SW_DMA_0:
+		timing = 0x0F0F; break;
+	case XFER_PIO_4:
+		timing = 0x0202; break;
+	case XFER_PIO_3:
+		timing = 0x0204; break;
+	case XFER_PIO_2:
+		timing = 0x0404; break;
+	case XFER_PIO_1:
+		timing = 0x0508; break;
+	case XFER_PIO_0:
+		timing = 0x0808; break;
+	default:
+		BUG();
+	}
+	triflex_timing &= ~(0xFFFF << (16 * is_slave));
+	triflex_timing |= (timing << (16 * is_slave));
+
+	if (triflex_timing != old_triflex_timing)
+		pci_write_config_dword(pdev, channel_offset, triflex_timing);
+}
+
+/**
+ *	triflex_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Use the timing loader to set up the PIO mode. We have to do this
+ *	because DMA start/stop will only be called once DMA occurs. If there
+ *	has been no DMA then the PIO timings are still needed.
+ */
+static void triflex_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	triflex_load_timing(ap, adev, adev->pio_mode);
+}
