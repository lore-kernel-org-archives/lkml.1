Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYAZSDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYAZSDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 13:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYAZSDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 13:03:22 -0500
Received: from aun.it.uu.se ([130.238.12.36]:53866 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYAZSDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 13:03:21 -0500
Date: Sat, 26 Jan 2008 19:03:15 +0100 (MET)
Message-Id: <200801261803.m0QI3Fen025895@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: matthew@wil.cx
Subject: [PATCH 2.6.24] sym53c8xx_2 modpost section mismatch fix
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building 2.6.24 with

# CONFIG_HOTPLUG is not set
CONFIG_SCSI_SYM53C8XX_2=y

results in the following during modpost:

WARNING: vmlinux.o(.text+0x14b36c): Section mismatch: reference to .exit.text:sym2_remove (between 'sym2_io_error_detected' and 'sym_set_cam_result_error')

because sym2_io_error_detected() calls sym2_remove(), which is marked __devexit.

Fixed by removing the __devexit from sym2_remove().

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
Resend. Previously reported against 2.6.24-rc6 on 2007-12-15.

--- linux-2.6.24-rc5/drivers/scsi/sym53c8xx_2/sym_glue.c.~1~	2007-12-15 15:37:04.000000000 +0100
+++ linux-2.6.24-rc5/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-12-15 16:22:08.000000000 +0100
@@ -1744,7 +1744,7 @@ static int __devinit sym2_probe(struct p
 	return -ENODEV;
 }
 
-static void __devexit sym2_remove(struct pci_dev *pdev)
+static void sym2_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 
@@ -2056,7 +2056,7 @@ static struct pci_driver sym2_driver = {
 	.name		= NAME53C8XX,
 	.id_table	= sym2_id_table,
 	.probe		= sym2_probe,
-	.remove		= __devexit_p(sym2_remove),
+	.remove		= sym2_remove,
 	.err_handler 	= &sym2_err_handler,
 };
 
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

