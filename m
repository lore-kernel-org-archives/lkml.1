Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009Ab0A2QUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab0A2QUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501Ab0A2QE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:04:29 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab0A2QEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:04:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VL+q9CodJriH7xChj8xw5bXMu78G8KBlzjn9YkNhZ/H3JC3xJoGaYG7UAJHPBfSD/g
         XwX7sQtwMR1ocJMugAJ783lqiqAYb058TXHK6A2jekfm9/CP36nR+IEghCjKKdgjIEAs
         fSa7u9OJpzs40/hh281nrNf/HQMkF1Lavsh/4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:04:14 +0100
Message-Id: <20100129160414.21495.6865.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 10/68] ata_piix: move short cable handling to ata_piix.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ata_piix: move short cable handling to ata_piix.h

It is a generic code and can be shared between ata_piix & piix drivers.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c |   45 +--------------------------------------------
 drivers/ata/ata_piix.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 44 deletions(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -581,50 +581,7 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
-struct ich_laptop {
-	u16 device;
-	u16 subvendor;
-	u16 subdevice;
-};
-
-/*
- *	List of laptops that use short cables rather than 80 wire
- */
-
-static const struct ich_laptop ich_laptop[] = {
-	/* devid, subvendor, subdev */
-	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
-	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
-	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
-	{ 0x27DF, 0x1028, 0x02b0 },	/* ICH7 on unknown Dell */
-	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
-	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
-	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unkown HP  */
-	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
-	{ 0x27DF, 0x152D, 0x0778 },	/* ICH7 on unknown Intel */
-	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
-	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
-	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
-	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
-	{ 0x27df, 0x104d, 0x900e },	/* ICH7 on Sony TZ-90 */
-	/* end marker */
-	{ 0, }
-};
-
-static int ich_short_ata40(struct pci_dev *pdev)
-{
-	const struct ich_laptop *lap = &ich_laptop[0];
-
-	while (lap->device) {
-		if (lap->device == pdev->device &&
-		    lap->subvendor == pdev->subsystem_vendor &&
-		    lap->subdevice == pdev->subsystem_device)
-			return 1;
-		lap++;
-	}
-
-	return 0;
-}
+#include "ata_piix.h"
 
 /**
  *	ich_pata_cable_detect - Probe host controller cable detect info
Index: b/drivers/ata/ata_piix.h
===================================================================
--- /dev/null
+++ b/drivers/ata/ata_piix.h
@@ -0,0 +1,45 @@
+
+struct ich_laptop {
+	u16 device;
+	u16 subvendor;
+	u16 subdevice;
+};
+
+/*
+ *	List of laptops that use short cables rather than 80 wire
+ */
+
+static const struct ich_laptop ich_laptop[] = {
+	/* devid, subvendor, subdev */
+	{ 0x27DF, 0x0005, 0x0280 },	/* ICH7 on Acer 5602WLMi */
+	{ 0x27DF, 0x1025, 0x0102 },	/* ICH7 on Acer 5602aWLMi */
+	{ 0x27DF, 0x1025, 0x0110 },	/* ICH7 on Acer 3682WLMi */
+	{ 0x27DF, 0x1028, 0x02b0 },	/* ICH7 on unknown Dell */
+	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
+	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
+	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unkown HP  */
+	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
+	{ 0x27DF, 0x152D, 0x0778 },	/* ICH7 on unknown Intel */
+	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
+	{ 0x24CA, 0x1025, 0x003d },	/* ICH4 on ACER TM290 */
+	{ 0x266F, 0x1025, 0x0066 },	/* ICH6 on ACER Aspire 1694WLMi */
+	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
+	{ 0x27df, 0x104d, 0x900e },	/* ICH7 on Sony TZ-90 */
+	/* end marker */
+	{ 0, }
+};
+
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
