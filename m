Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbYBPUOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbYBPUOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 15:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbYBPUMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 15:12:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:13719 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759613AbYBPUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 15:12:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=neXMXs5njov25xaLaAGRM+U5wgC0YPwjiph5EMcJf34RQ2As46XAyPEyI7XR8MH3tX7kl5coq7mwSm0yILmenhihIkD3+f7aL4CCzjsivDTGW+JTJYmuKf4r5J/Cki8y6/sbp//5HVVCGfdkGqHgJvV8kEEH5w0vaZO1KwwsI60=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 21:27:22 +0100
Message-Id: <20080216202722.25536.36800.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
References: <20080216202634.25536.78915.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] qd65xx: return error value in qd_probe()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return error value in qd_probe() and use it in qd65xx_init()
instead of checking ide_hwifs[].chipset.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/qd65xx.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -396,7 +396,7 @@ static int __init qd_probe(int base)
 	config = inb(QD_CONFIG_PORT);
 
 	if (! ((config & QD_CONFIG_BASEPORT) >> 1 == (base == 0xb0)) )
-		return 1;
+		return -ENODEV;
 
 	unit = ! (config & QD_CONFIG_IDE_BASEPORT);
 
@@ -410,7 +410,8 @@ static int __init qd_probe(int base)
 
 	if ((config & 0xf0) == QD_CONFIG_QD6500) {
 
-		if (qd_testreg(base)) return 1;		/* bad register */
+		if (qd_testreg(base))
+			 return -ENODEV;	/* bad register */
 
 		/* qd6500 found */
 
@@ -421,7 +422,7 @@ static int __init qd_probe(int base)
 		
 		if (config & QD_CONFIG_DISABLED) {
 			printk(KERN_WARNING "qd6500 is disabled !\n");
-			return 1;
+			return -ENODEV;
 		}
 
 		ide_init_port_hw(hwif, &hw[unit]);
@@ -443,8 +444,8 @@ static int __init qd_probe(int base)
 
 		u8 control;
 
-		if (qd_testreg(base) || qd_testreg(base+0x02)) return 1;
-			/* bad registers */
+		if (qd_testreg(base) || qd_testreg(base + 0x02))
+			return -ENODEV;	/* bad registers */
 
 		/* qd6580 found */
 
@@ -508,7 +509,7 @@ static int __init qd_probe(int base)
 		}
 	}
 	/* no qd65xx found */
-	return 1;
+	return -ENODEV;
 }
 
 int probe_qd65xx = 0;
@@ -518,14 +519,18 @@ MODULE_PARM_DESC(probe, "probe for QD65x
 
 static int __init qd65xx_init(void)
 {
+	int rc1, rc2 = -ENODEV;
+
 	if (probe_qd65xx == 0)
 		return -ENODEV;
 
-	if (qd_probe(0x30))
-		qd_probe(0xb0);
-	if (ide_hwifs[0].chipset != ide_qd65xx &&
-	    ide_hwifs[1].chipset != ide_qd65xx)
+	rc1 = qd_probe(0x30);
+	if (rc1)
+		rc2 = qd_probe(0xb0);
+
+	if (rc1 < 0 && rc2 < 0)
 		return -ENODEV;
+
 	return 0;
 }
 
