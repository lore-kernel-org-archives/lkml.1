Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbYB0Wud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbYB0Wud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYB0WuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:50:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:56272 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbYB0WuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XLSMlHQ1SUaqr/nghcMYzAdR1kMK7V2ZTYbNT6/poRwp4KZVxP8SdLu+jyIBY+n2Td8vmyGxtiHsZpBY8A6kJ6OBFNf8luZkfC6iOPcMyMDiR8AfErzaCvk26+7XqApQzFd4jkOsUsl5o5FyxK18jmheOeXRSYqaLWsZx+LBwFc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/3] ide: remove ide_hwif_release_regions()
Date: Thu, 28 Feb 2008 00:04:19 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802280004.19218.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All host drivers using ide_unregister()/module_exit() have been fixed
to manage resources themselves so this function can be removed now.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c   |   25 -------------------------
 include/linux/ide.h |    1 -
 2 files changed, 26 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -279,29 +279,6 @@ control_region_busy:
 	return -EBUSY;
 }
 
-/**
- *	ide_hwif_release_regions - free IDE resources
- *
- *	Note that we only release the standard ports,
- *	and do not even try to handle any extra ports
- *	allocated for weird IDE interface chipsets.
- *
- *	Note also that we don't yet handle mmio resources here. More
- *	importantly our caller should be doing this so we need to 
- *	restructure this as a helper function for drivers.
- */
-
-void ide_hwif_release_regions(ide_hwif_t *hwif)
-{
-	if (hwif->mmio)
-		return;
-
-	if (hwif->io_ports[IDE_CONTROL_OFFSET])
-		release_region(hwif->io_ports[IDE_CONTROL_OFFSET], 1);
-
-	release_region(hwif->io_ports[IDE_DATA_OFFSET], 8);
-}
-
 void ide_remove_port_from_hwgroup(ide_hwif_t *hwif)
 {
 	ide_hwgroup_t *hwgroup = hwif->hwgroup;
@@ -440,8 +417,6 @@ void ide_unregister(unsigned int index)
 	if (hwif->dma_base)
 		(void)ide_release_dma(hwif);
 
-	ide_hwif_release_regions(hwif);
-
 	/* restore hwif data to pristine status */
 	ide_init_port_data(hwif, index);
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1205,7 +1205,6 @@ static inline void ide_acpi_set_state(id
 
 void ide_remove_port_from_hwgroup(ide_hwif_t *);
 extern int ide_hwif_request_regions(ide_hwif_t *hwif);
-extern void ide_hwif_release_regions(ide_hwif_t* hwif);
 void ide_unregister(unsigned int);
 
 void ide_register_region(struct gendisk *);
