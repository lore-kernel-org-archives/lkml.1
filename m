Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286Ab0A2QFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0A2QFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762Ab0A2QFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:05:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:45357 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0A2QFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:05:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=wgAYRcV/EjuONrGwYI2VwdF1T3r2V8f9BbzNa5i1cenqcpLTxCjhVZ6fKEko00VFp0
         k8epSiEeH5gGiKylL1Ycz0u2/D1iVxUF6SWP6Zs9zlharHauvNWlB4tUN6cXX9Tk8Ys6
         VyW9iWdgpMPSJ4l2qoXJEM14BQ7aC8SyJ6n5Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:04:53 +0100
Message-Id: <20100129160453.21495.30904.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 16/68] pata_via: move short cable handling to pata_via.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_via: move short cable handling to pata_via.h

It is a generic code and can be shared between pata_via & via82cxxx drivers.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_via.c |   28 +---------------------------
 drivers/ata/pata_via.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 27 deletions(-)

Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -60,7 +60,6 @@
 #include <linux/delay.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include <linux/dmi.h>
 
 #define DRV_NAME "pata_via"
 #define DRV_VERSION "0.3.4"
@@ -127,32 +126,7 @@ struct via_port {
 	u8 cached_device;
 };
 
-/*
- *	Cable special cases
- */
-
-static const struct dmi_system_id cable_dmi_table[] = {
-	{
-		.ident = "Acer Ferrari 3400",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "Acer,Inc."),
-			DMI_MATCH(DMI_BOARD_NAME, "Ferrari 3400"),
-		},
-	},
-	{ }
-};
-
-static int via_cable_override(struct pci_dev *pdev)
-{
-	/* Systems by DMI */
-	if (dmi_check_system(cable_dmi_table))
-		return 1;
-	/* Arima W730-K8/Targa Visionary 811/... */
-	if (pdev->subsystem_vendor == 0x161F && pdev->subsystem_device == 0x2032)
-		return 1;
-	return 0;
-}
-
+#include "pata_via.h"
 
 /**
  *	via_cable_detect	-	cable detection
Index: b/drivers/ata/pata_via.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_via.h
@@ -0,0 +1,29 @@
+
+#include <linux/dmi.h>
+
+/*
+ *	Cable special cases
+ */
+
+static const struct dmi_system_id cable_dmi_table[] = {
+	{
+		.ident = "Acer Ferrari 3400",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Acer,Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "Ferrari 3400"),
+		},
+	},
+	{ }
+};
+
+static int via_cable_override(struct pci_dev *pdev)
+{
+	/* Systems by DMI */
+	if (dmi_check_system(cable_dmi_table))
+		return 1;
+	/* Arima W730-K8/Targa Visionary 811/... */
+	if (pdev->subsystem_vendor == 0x161F &&
+	    pdev->subsystem_device == 0x2032)
+		return 1;
+	return 0;
+}
