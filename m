Return-Path: <linux-kernel-owner+w=401wt.eu-S1763480AbYBGVRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763480AbYBGVRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934801AbYBGVCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:02:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:8399 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760561AbYBGVCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:02:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cHOFlD7LHgqWlLqsodNeH0I+vrrXHYVtG3Lgfs8Mq43gdZOj7TYn4s1noazBzEY3XJAEoZWoIvwBfpyQmrFRTmK8pg+GtlegUXcgFI/oPi4XtLDRbbbQjIVBZRZjrbw7ANkL0YqJRBhG3nJxabbhSzJ5YGuJ7eNqGZJnOZ6+Mpk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] pdc202xx_old: always enable burst mode
Date: Thu, 7 Feb 2008 22:14:43 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802072214.44352.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan has noticed that distros always enabled burst mode
(+ datasheet confirms that it is the right thing to do).

Thus fix pdc202xx_old host driver to do it unconditionally
and remove no longer needed CONFIG_PDC202XX_BURST option.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig            |   17 -----------------
 drivers/ide/pci/pdc202xx_old.c |   22 ----------------------
 2 files changed, 39 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -684,23 +684,6 @@ config BLK_DEV_PDC202XX_OLD
 
 	  If unsure, say N.
 
-config PDC202XX_BURST
-	bool "Special UDMA Feature"
-	depends on BLK_DEV_PDC202XX_OLD
-	help
-	  This option causes the pdc202xx driver to enable UDMA modes on the
-	  PDC202xx even when the PDC202xx BIOS has not done so.
-
-	  It was originally designed for the PDC20246/Ultra33, whose BIOS will
-	  only setup UDMA on the first two PDC20246 cards.  It has also been
-	  used successfully on a PDC20265/Ultra100, allowing use of UDMA modes
-	  when the PDC20265 BIOS has been disabled (for faster boot up).
-
-	  Please read the comments at the top of
-	  <file:drivers/ide/pci/pdc202xx_old.c>.
-
-	  If unsure, say N.
-
 config BLK_DEV_PDC202XX_NEW
 	tristate "PROMISE PDC202{68|69|70|71|75|76|77} support"
 	select BLK_DEV_IDEDMA_PCI
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -3,26 +3,6 @@
  *  Copyright (C) 2006-2007		MontaVista Software, Inc.
  *  Copyright (C) 2007			Bartlomiej Zolnierkiewicz
  *
- *  Promise Ultra33 cards with BIOS v1.20 through 1.28 will need this
- *  compiled into the kernel if you have more than one card installed.
- *  Note that BIOS v1.29 is reported to fix the problem.  Since this is
- *  safe chipset tuning, including this support is harmless
- *
- *  Promise Ultra66 cards with BIOS v1.11 this
- *  compiled into the kernel if you have more than one card installed.
- *
- *  Promise Ultra100 cards.
- *
- *  The latest chipset code will support the following ::
- *  Three Ultra33 controllers and 12 drives.
- *  8 are UDMA supported and 4 are limited to DMA mode 2 multi-word.
- *  The 8/4 ratio is a BIOS code limit by promise.
- *
- *  UNLESS you enable "CONFIG_PDC202XX_BURST"
- *
- */
-
-/*
  *  Portions Copyright (C) 1999 Promise Technology, Inc.
  *  Author: Frank Tiernan (frankt@promise.com)
  *  Released under terms of General Public License
@@ -344,7 +324,6 @@ static void __devinit init_dma_pdc202xx(
 		(primary_mode & 1) ? "MASTER" : "PCI",
 		(secondary_mode & 1) ? "MASTER" : "PCI" );
 
-#ifdef CONFIG_PDC202XX_BURST
 	if (!(udma_speed_flag & 1)) {
 		printk(KERN_INFO "%s: FORCING BURST BIT 0x%02x->0x%02x ",
 			hwif->cds->name, udma_speed_flag,
@@ -352,7 +331,6 @@ static void __devinit init_dma_pdc202xx(
 		outb(udma_speed_flag | 1, dmabase | 0x1f);
 		printk("%sACTIVE\n", (inb(dmabase | 0x1f) & 1) ? "" : "IN");
 	}
-#endif /* CONFIG_PDC202XX_BURST */
 
 	ide_setup_dma(hwif, dmabase);
 }
