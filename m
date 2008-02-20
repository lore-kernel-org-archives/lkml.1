Return-Path: <linux-kernel-owner+w=401wt.eu-S1764583AbYBTAif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764583AbYBTAif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763555AbYBTAgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:36:42 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:37687 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762349AbYBTAgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:36:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=dMJb9qfiyrJ6jPlmMmHxOL3ydsWCkQaswwSB295FpYR0nsrST4Udh74cT6b8sxK98teeQdSSh/4W4CtAvqfeo+yDM9AcFkwJvmbfMzPs7WG6ePnOsBWg15ee6Gxe9LTx/M6fXJf4K36zjvtKxd3gcmYtDjlOUj6awg5kL0gak4E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] falconide: fix resources reservation
Date: Wed, 20 Feb 2008 01:50:26 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Michael Schmitz <schmitz@debian.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200150.26989.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tell IDE layer to not manage resources by setting
  hwif->mmio flag and request resources in falconide_init().

* Use request_mem_region() for resources reservation.

* Use driver name for resources reservation.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@debian.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/falconide.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -22,6 +22,7 @@
 #include <asm/atariints.h>
 #include <asm/atari_stdma.h>
 
+#define DRV_NAME "falconide"
 
     /*
      *  Base of the IDE interface
@@ -74,6 +75,11 @@ static int __init falconide_init(void)
 
 	printk(KERN_INFO "ide: Falcon IDE controller\n");
 
+	if (!request_mem_region(ATA_HD_BASE, 0x40, DRV_NAME)) {
+		printk(KERN_ERR "%s: resources busy\n");
+		return -EBUSY;
+	}
+
 	falconide_setup_ports(&hw);
 
 	hwif = ide_find_port();
@@ -83,6 +89,7 @@ static int __init falconide_init(void)
 
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
+		hwif->mmio = 1;
 
 		ide_get_lock(NULL, NULL);
 		ide_device_add(idx, NULL);
