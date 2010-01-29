Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828Ab0A2QEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0A2QEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606Ab0A2QEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:04:37 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab0A2QEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:04:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=sKJf2iZC+qkGmmaNwOQmipWgwjWdj+MaD7T6RVWOnxpPWmyVEPQUP4WLzIMtUUAzak
         KUsZEvaoz8PeAnI6bgYtEdHw09jc+rA66Y+pJBtI0xGh2iA07e+QIpEIntznYFSwPTdB
         ETwna0FmNS6wIIfBo1Z1c/tOELzO0uvg1U0io=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:04:27 +0100
Message-Id: <20100129160427.21495.26006.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 12/68] pata_ali: move short cable handling to pata_ali.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_ali: move short cable handling to pata_ali.h

It is a generic code and can be shared between pata_ali & alim15x3 drivers.

Fix typo while at it ("Satelite" -> "Satellite").

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_ali.c |   37 +------------------------------------
 drivers/ata/pata_ali.h |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 36 deletions(-)

Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -32,7 +32,6 @@
 #include <linux/delay.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <linux/dmi.h>
 
 #define DRV_NAME "pata_ali"
 #define DRV_VERSION "0.7.8"
@@ -43,41 +42,7 @@ MODULE_PARM_DESC(atapi_dma, "Enable ATAP
 
 static struct pci_dev *ali_isa_bridge;
 
-/*
- *	Cable special cases
- */
-
-static const struct dmi_system_id cable_dmi_table[] = {
-	{
-		.ident = "HP Pavilion N5430",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
-		},
-	},
-	{
-		.ident = "Toshiba Satelite S1800-814",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "S1800-814"),
-		},
-	},
-	{ }
-};
-
-static int ali_cable_override(struct pci_dev *pdev)
-{
-	/* Fujitsu P2000 */
-	if (pdev->subsystem_vendor == 0x10CF && pdev->subsystem_device == 0x10AF)
-	   	return 1;
-	/* Mitac 8317 (Winbook-A) and relatives */
-	if (pdev->subsystem_vendor == 0x1071 && pdev->subsystem_device == 0x8317)
-		return 1;
-	/* Systems by DMI */
-	if (dmi_check_system(cable_dmi_table))
-		return 1;
-	return 0;
-}
+#include "pata_ali.h"
 
 /**
  *	ali_c2_cable_detect	-	cable detection
Index: b/drivers/ata/pata_ali.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_ali.h
@@ -0,0 +1,40 @@
+
+#include <linux/dmi.h>
+
+/*
+ *	Cable special cases
+ */
+
+static const struct dmi_system_id cable_dmi_table[] = {
+	{
+		.ident = "HP Pavilion N5430",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
+		},
+	},
+	{
+		.ident = "Toshiba Satellite S1800-814",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "S1800-814"),
+		},
+	},
+	{ }
+};
+
+static int ali_cable_override(struct pci_dev *pdev)
+{
+	/* Fujitsu P2000 */
+	if (pdev->subsystem_vendor == 0x10CF &&
+	    pdev->subsystem_device == 0x10AF)
+		return 1;
+	/* Mitac 8317 (Winbook-A) and relatives */
+	if (pdev->subsystem_vendor == 0x1071 &&
+	    pdev->subsystem_device == 0x8317)
+		return 1;
+	/* Systems by DMI */
+	if (dmi_check_system(cable_dmi_table))
+		return 1;
+	return 0;
+}
