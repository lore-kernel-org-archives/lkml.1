Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbYCAUrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbYCAUrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 15:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760816AbYCAUn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 15:43:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:27917 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760211AbYCAUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 15:43:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ZNYz88DOS1p8GD9UX3io7mbDHq2wrlQOHnOFkQ2QCwksrsWdQ6CxLS9A5yBY5qDnVMaYKQ+MI3m50bV0fpHjHRTy2FnWk3CejdJCVu9ri7GMfvd+2RqqT8yppESI0wX9mRTcLJW/7jYMXPol5aNoqC5NHkT25GaU07atcnEb7pE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 6/9] cmd640: manage I/O resources in driver
Date: Sat, 1 Mar 2008 19:48:05 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803011948.05361.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tell IDE layer to not manage resources by setting hwif->mmio flag.

* Use {request,release}_region() for resources management.

* Use driver name for resources management.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd640.c |   37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -109,6 +109,8 @@
 
 #include <asm/io.h>
 
+#define DRV_NAME "cmd640"
+
 /*
  * This flag is set in ide.c by the parameter:  ide0=cmd640_vlb
  */
@@ -686,6 +688,24 @@ static const struct ide_port_info cmd640
 #endif
 };
 
+static int cmd640x_init_one(unsigned long base, unsigned long ctl)
+{
+	if (!request_region(base, 8, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX-0x%lX not free.\n",
+				DRV_NAME, base, base + 7);
+		return -EBUSY;
+	}
+
+	if (!request_region(ctl, 1, DRV_NAME)) {
+		printk(KERN_ERR "%s: I/O resource 0x%lX not free.\n",
+				DRV_NAME, ctl);
+		release_region(base, 8);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 /*
  * Probe for a cmd640 chipset, and initialize it if found.
  */
@@ -694,7 +714,7 @@ static int __init cmd640x_init(void)
 #ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
 	int second_port_toggled = 0;
 #endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
-	int second_port_cmd640 = 0;
+	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
 	unsigned int index;
 	u8 b, cfr;
@@ -738,6 +758,17 @@ static int __init cmd640x_init(void)
 		return 0;
 	}
 
+	rc = cmd640x_init_one(0x1f0, 0x3f6);
+	if (rc)
+		return rc;
+
+	rc = cmd640x_init_one(0x170, 0x376);
+	if (rc) {
+		release_region(0x3f6, 1);
+		release_region(0x1f0, 8);
+		return rc;
+	}
+
 	memset(&hw, 0, sizeof(hw));
 
 	ide_std_init_ports(&hw[0], 0x1f0, 0x3f6);
@@ -756,7 +787,7 @@ static int __init cmd640x_init(void)
 	 */
 	if (cmd_hwif0) {
 		ide_init_port_hw(cmd_hwif0, &hw[0]);
-
+		cmd_hwif0->mmio = 1;
 		idx[0] = cmd_hwif0->index;
 	}
 
@@ -809,7 +840,7 @@ static int __init cmd640x_init(void)
 	 */
 	if (second_port_cmd640 && cmd_hwif1) {
 		ide_init_port_hw(cmd_hwif1, &hw[1]);
-
+		cmd_hwif1->mmio = 1;
 		idx[1] = cmd_hwif1->index;
 	}
 	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
