Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbYFKU0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbYFKU0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYFKU0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:26:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:60265 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYFKU0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=ChgX9M+6hlOlQgOANFNozE6DQ5gN2O+2jLY8l0S3sg0krAXlCY8nW9aqgNa9XGzT+X
         Zyas1dBo3FKB6MOuX8Y+ZfdupBsfSEhFEwPwqMfGPAAEQAvn8osY/GkKrocPr83p/60n
         H2EIWp9zNom+o9oHj0BGltgFV3uLWNHUQznPg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/5] icside: always try to probe first interface
Date: Wed, 11 Jun 2008 21:20:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806112120.39616.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to probe first interface even if ide_hwifs[]'s slot for the second
interface cannot be obtained.

While at it:

- Add DRV_NAME define and use it for request_dma() instead of hwif->name.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/icside.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

Index: b/drivers/ide/arm/icside.c
===================================================================
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -21,6 +21,8 @@
 #include <asm/dma.h>
 #include <asm/ecard.h>
 
+#define DRV_NAME "icside"
+
 #define ICS_IDENT_OFFSET		0x2280
 
 #define ICS_ARCIN_V5_INTRSTAT		0x0000
@@ -546,27 +548,27 @@ icside_register_v6(struct icside_state *
 	ide_init_port_hw(hwif, &hw[0]);
 	default_hwif_mmiops(hwif);
 
+	idx[0] = hwif->index;
+
 	mate = ide_find_port();
-	if (mate == NULL)
-		return -ENODEV;
+	if (mate) {
+		ide_init_port_hw(mate, &hw[1]);
+		default_hwif_mmiops(mate);
 
-	ide_init_port_hw(mate, &hw[1]);
-	default_hwif_mmiops(mate);
+		idx[1] = mate->index;
+	}
 
 	state->hwif[0]    = hwif;
 	state->hwif[1]    = mate;
 
 	ecard_set_drvdata(ec, state);
 
-	if (ec->dma != NO_DMA && !request_dma(ec->dma, hwif->name)) {
+	if (ec->dma != NO_DMA && !request_dma(ec->dma, DRV_NAME)) {
 		d.init_dma = icside_dma_init;
 		d.port_ops = &icside_v6_port_ops;
 		d.dma_ops = NULL;
 	}
 
-	idx[0] = hwif->index;
-	idx[1] = mate->index;
-
 	ide_device_add(idx, &d);
 
 	return 0;
