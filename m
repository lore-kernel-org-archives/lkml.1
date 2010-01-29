Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057Ab0A2QEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab0A2QEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888Ab0A2QES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:04:18 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0A2QEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:04:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XQ/QpehrLp8MZyZvm8yG6L4V60lsgA45vWg72sGvFIwW6hOuD+8nwTp/ZvSYD3sa1t
         fr7FDcLkktLpagkM6AjJjQGAe9ESrF3QMf2i9+l01kIF0EcDHIlNqS0jVPikfTq0u0Rn
         /r26y3WxkTHWYGtTQGLPzl2OA2LBQGj358WIc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:04:08 +0100
Message-Id: <20100129160408.21495.10059.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 09/68] ata_piix: factor out short cable detection code to ich_short_ata40()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ata_piix: factor out short cable detection code to ich_short_ata40()

Fix up ich_pata_cable_detect() documentation while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -611,6 +611,21 @@ static const struct ich_laptop ich_lapto
 	{ 0, }
 };
 
+static int ich_short_ata40(struct pci_dev *pdev)
+{
+	const struct ich_laptop *lap = &ich_laptop[0];
+
+	while (lap->device) {
+		if (lap->device == pdev->device &&
+		    lap->subvendor == pdev->subsystem_vendor &&
+		    lap->subdevice == pdev->subsystem_device)
+			return 1;
+		lap++;
+	}
+
+	return 0;
+}
+
 /**
  *	ich_pata_cable_detect - Probe host controller cable detect info
  *	@ap: Port for which cable detect info is desired
@@ -626,18 +641,11 @@ static int ich_pata_cable_detect(struct
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct piix_host_priv *hpriv = ap->host->private_data;
-	const struct ich_laptop *lap = &ich_laptop[0];
 	u8 mask;
 
-	/* Check for specials - Acer Aspire 5602WLMi */
-	while (lap->device) {
-		if (lap->device == pdev->device &&
-		    lap->subvendor == pdev->subsystem_vendor &&
-		    lap->subdevice == pdev->subsystem_device)
-			return ATA_CBL_PATA40_SHORT;
-
-		lap++;
-	}
+	/* check for specials */
+	if (ich_short_ata40(pdev))
+		return ATA_CBL_PATA40_SHORT;
 
 	/* check BIOS cable detect results */
 	mask = ap->port_no == 0 ? PIIX_80C_PRI : PIIX_80C_SEC;
