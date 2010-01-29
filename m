Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884Ab0A2QHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0A2QHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502Ab0A2QG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:06:59 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab0A2QGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:06:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=k4cUoPZBInvb4GLAEt3bzi6cUS52qynWyFqRBusqwIcV9agV+Er9TBN2e8tqiFgstB
         S3fOOlO6mypUbjsDnhMSbaHdQdvPc3UiR4w3mhvi45VQoqeSw0k5ghaJVuGbIvIHWiRd
         XigwS6CebT64PBXYaJgUnlZO3dmPEQmCoE144=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:06:41 +0100
Message-Id: <20100129160641.21495.77291.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 33/68] pata_amd: move code to be re-used by ide2libata to pata_amd.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_amd: move code to be re-used by ide2libata to pata_amd.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_amd.c |   87 ----------------------------------------------
 drivers/ata/pata_amd.h |   92 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 86 deletions(-)

Index: b/drivers/ata/pata_amd.c
===================================================================
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -26,92 +26,7 @@
 #define DRV_NAME "pata_amd"
 #define DRV_VERSION "0.4.1"
 
-/**
- *	timing_setup		-	shared timing computation and load
- *	@ap: ATA port being set up
- *	@adev: drive being configured
- *	@offset: port offset
- *	@speed: target speed
- *	@clock: clock multiplier (number of times 33MHz for this part)
- *
- *	Perform the actual timing set up for Nvidia or AMD PATA devices.
- *	The actual devices vary so they all call into this helper function
- *	providing the clock multipler and offset (because AMD and Nvidia put
- *	the ports at different locations).
- */
-
-static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offset, int speed, int clock)
-{
-	static const unsigned char amd_cyc2udma[] = {
-		6, 6, 5, 4, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 7
-	};
-
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	struct ata_device *peer = ata_dev_pair(adev);
-	int dn = ap->port_no * 2 + adev->devno;
-	struct ata_timing at, apeer;
-	int T, UT;
-	const int amd_clock = 33333;	/* KHz. */
-	u8 t;
-
-	T = 1000000000 / amd_clock;
-	UT = T;
-	if (clock >= 2)
-		UT = T / 2;
-
-	ata_timing_compute(adev->id, speed, adev->pio_mode, &at, T, UT);
-
-	if (peer) {
-		ata_timing_compute(peer->id, peer->pio_mode,
-				   peer->pio_mode, &apeer, T, UT);
-		ata_timing_merge(&apeer, &at, &at, ATA_TIMING_8BIT);
-	}
-
-	if (speed == XFER_UDMA_5 && amd_clock <= 33333) at.udma = 1;
-	if (speed == XFER_UDMA_6 && amd_clock <= 33333) at.udma = 15;
-
-	/*
-	 *	Now do the setup work
-	 */
-
-	/* Configure the address set up timing */
-	pci_read_config_byte(pdev, offset + 0x0C, &t);
-	t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(at.setup, 1, 4) - 1) << ((3 - dn) << 1));
-	pci_write_config_byte(pdev, offset + 0x0C , t);
-
-	/* Configure the 8bit I/O timing */
-	pci_write_config_byte(pdev, offset + 0x0E + (1 - (dn >> 1)),
-		((clamp_val(at.act8b, 1, 16) - 1) << 4) | (clamp_val(at.rec8b, 1, 16) - 1));
-
-	/* Drive timing */
-	pci_write_config_byte(pdev, offset + 0x08 + (3 - dn),
-		((clamp_val(at.active, 1, 16) - 1) << 4) | (clamp_val(at.recover, 1, 16) - 1));
-
-	switch (clock) {
-		case 1:
-		t = at.udma ? (0xc0 | (clamp_val(at.udma, 2, 5) - 2)) : 0x03;
-		break;
-
-		case 2:
-		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 2, 10)]) : 0x03;
-		break;
-
-		case 3:
-		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 1, 10)]) : 0x03;
-		break;
-
-		case 4:
-		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 1, 15)]) : 0x03;
-		break;
-
-		default:
-			return;
-	}
-
-	/* UDMA timing */
-	if (at.udma)
-		pci_write_config_byte(pdev, offset + 0x10 + (3 - dn), t);
-}
+#include "pata_amd.h"
 
 /**
  *	amd_pre_reset		-	perform reset handling
Index: b/drivers/ata/pata_amd.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_amd.h
@@ -0,0 +1,92 @@
+
+/**
+ *	timing_setup		-	shared timing computation and load
+ *	@ap: ATA port being set up
+ *	@adev: drive being configured
+ *	@offset: port offset
+ *	@speed: target speed
+ *	@clock: clock multiplier (number of times 33MHz for this part)
+ *
+ *	Perform the actual timing set up for Nvidia or AMD PATA devices.
+ *	The actual devices vary so they all call into this helper function
+ *	providing the clock multipler and offset (because AMD and Nvidia put
+ *	the ports at different locations).
+ */
+
+static void timing_setup(struct ata_port *ap, struct ata_device *adev,
+			 int offset, int speed, int clock)
+{
+	static const unsigned char amd_cyc2udma[] = {
+		6, 6, 5, 4, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 7
+	};
+
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct ata_device *peer = ata_dev_pair(adev);
+	int dn = ap->port_no * 2 + adev->devno;
+	struct ata_timing at, apeer;
+	int T, UT;
+	const int amd_clock = 33333;	/* KHz. */
+	u8 t;
+
+	T = 1000000000 / amd_clock;
+	UT = T;
+	if (clock >= 2)
+		UT = T / 2;
+
+	ata_timing_compute(adev->id, speed, adev->pio_mode, &at, T, UT);
+
+	if (peer) {
+		ata_timing_compute(peer->id, peer->pio_mode,
+				   peer->pio_mode, &apeer, T, UT);
+		ata_timing_merge(&apeer, &at, &at, ATA_TIMING_8BIT);
+	}
+
+	if (speed == XFER_UDMA_5 && amd_clock <= 33333)
+		at.udma = 1;
+	if (speed == XFER_UDMA_6 && amd_clock <= 33333)
+		at.udma = 15;
+
+	/*
+	 *	Now do the setup work
+	 */
+
+	/* Configure the address set up timing */
+	pci_read_config_byte(pdev, offset + 0x0C, &t);
+	t = (t & ~(3 << ((3 - dn) << 1))) |
+	    ((clamp_val(at.setup, 1, 4) - 1) << ((3 - dn) << 1));
+	pci_write_config_byte(pdev, offset + 0x0C , t);
+
+	/* Configure the 8bit I/O timing */
+	pci_write_config_byte(pdev, offset + 0x0E + (1 - (dn >> 1)),
+		((clamp_val(at.act8b, 1, 16) - 1) << 4) |
+		(clamp_val(at.rec8b, 1, 16) - 1));
+
+	/* Drive timing */
+	pci_write_config_byte(pdev, offset + 0x08 + (3 - dn),
+		((clamp_val(at.active, 1, 16) - 1) << 4) |
+		(clamp_val(at.recover, 1, 16) - 1));
+
+	switch (clock) {
+	case 1:
+		t = at.udma ? (0xc0 | (clamp_val(at.udma, 2, 5) - 2)) : 0x03;
+		break;
+	case 2:
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 2, 10)])
+			    : 0x03;
+		break;
+	case 3:
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 1, 10)])
+			    : 0x03;
+		break;
+	case 4:
+		t = at.udma ? (0xc0 | amd_cyc2udma[clamp_val(at.udma, 1, 15)])
+			    : 0x03;
+		break;
+	default:
+		return;
+	}
+
+	/* UDMA timing */
+	if (at.udma)
+		pci_write_config_byte(pdev, offset + 0x10 + (3 - dn), t);
+}
