Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646Ab0A2QPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab0A2QPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:15:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121Ab0A2QHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:07:47 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab0A2QHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:07:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qMhxGz+j//GX43/GceOR5imPoJlUDhrQSMu1LLVBNGFjFSLLuo9QnNKAUahykPlY63
         OtHt5plPhB/tVCACvbIpTqm+r6FGuqU/P8n78QvQ153kgXdGJb5M1yhnW2O9ANn6sV1V
         UCv491AAF6bBOTx/moP9wg3IdIK4O+Bh7xCOM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:07:37 +0100
Message-Id: <20100129160737.21495.16421.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 42/68] pata_cs5520: move code to be re-used by ide2libata to pata_cs5520.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5520: move code to be re-used by ide2libata to pata_cs5520.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5520.c |   60 ----------------------------------------------
 drivers/ata/pata_cs5520.h |   60 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 59 deletions(-)

Index: b/drivers/ata/pata_cs5520.c
===================================================================
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -43,65 +43,7 @@
 #define DRV_NAME	"pata_cs5520"
 #define DRV_VERSION	"0.6.6"
 
-struct pio_clocks
-{
-	int address;
-	int assert;
-	int recovery;
-};
-
-static const struct pio_clocks cs5520_pio_clocks[]={
-	{3, 6, 11},
-	{2, 5, 6},
-	{1, 4, 3},
-	{1, 3, 2},
-	{1, 2, 1}
-};
-
-/**
- *	cs5520_set_timings	-	program PIO timings
- *	@ap: ATA port
- *	@adev: ATA device
- *
- *	Program the PIO mode timings for the controller according to the pio
- *	clocking table.
- */
-
-static void cs5520_set_timings(struct ata_port *ap, struct ata_device *adev, int pio)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int slave = adev->devno;
-
-	pio -= XFER_PIO_0;
-
-	/* Channel command timing */
-	pci_write_config_byte(pdev, 0x62 + ap->port_no,
-				(cs5520_pio_clocks[pio].recovery << 4) |
-				(cs5520_pio_clocks[pio].assert));
-	/* FIXME: should these use address ? */
-	/* Read command timing */
-	pci_write_config_byte(pdev, 0x64 +  4*ap->port_no + slave,
-				(cs5520_pio_clocks[pio].recovery << 4) |
-				(cs5520_pio_clocks[pio].assert));
-	/* Write command timing */
-	pci_write_config_byte(pdev, 0x66 +  4*ap->port_no + slave,
-				(cs5520_pio_clocks[pio].recovery << 4) |
-				(cs5520_pio_clocks[pio].assert));
-}
-
-/**
- *	cs5520_set_piomode	-	program PIO timings
- *	@ap: ATA port
- *	@adev: ATA device
- *
- *	Program the PIO mode timings for the controller according to the pio
- *	clocking table.
- */
-
-static void cs5520_set_piomode(struct ata_port *ap, struct ata_device *adev)
-{
-	cs5520_set_timings(ap, adev, adev->pio_mode);
-}
+#include "pata_cs5520.h"
 
 static struct scsi_host_template cs5520_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
Index: b/drivers/ata/pata_cs5520.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_cs5520.h
@@ -0,0 +1,60 @@
+
+struct pio_clocks {
+	int address;
+	int assert;
+	int recovery;
+};
+
+static const struct pio_clocks cs5520_pio_clocks[] = {
+	{ 3, 6, 11 },
+	{ 2, 5,  6 },
+	{ 1, 4,  3 },
+	{ 1, 3,  2 },
+	{ 1, 2,  1 }
+};
+
+/**
+ *	cs5520_set_timings	-	program PIO timings
+ *	@ap: ATA port
+ *	@adev: ATA device
+ *
+ *	Program the PIO mode timings for the controller according to the pio
+ *	clocking table.
+ */
+
+static void cs5520_set_timings(struct ata_port *ap, struct ata_device *adev,
+			       int pio)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	int slave = adev->devno;
+
+	pio -= XFER_PIO_0;
+
+	/* Channel command timing */
+	pci_write_config_byte(pdev, 0x62 + ap->port_no,
+				(cs5520_pio_clocks[pio].recovery << 4) |
+				(cs5520_pio_clocks[pio].assert));
+	/* FIXME: should these use address ? */
+	/* Read command timing */
+	pci_write_config_byte(pdev, 0x64 +  4*ap->port_no + slave,
+				(cs5520_pio_clocks[pio].recovery << 4) |
+				(cs5520_pio_clocks[pio].assert));
+	/* Write command timing */
+	pci_write_config_byte(pdev, 0x66 +  4*ap->port_no + slave,
+				(cs5520_pio_clocks[pio].recovery << 4) |
+				(cs5520_pio_clocks[pio].assert));
+}
+
+/**
+ *	cs5520_set_piomode	-	program PIO timings
+ *	@ap: ATA port
+ *	@adev: ATA device
+ *
+ *	Program the PIO mode timings for the controller according to the pio
+ *	clocking table.
+ */
+
+static void cs5520_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	cs5520_set_timings(ap, adev, adev->pio_mode);
+}
