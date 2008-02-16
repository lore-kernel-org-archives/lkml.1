Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYBPQ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYBPQ2c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758808AbYBPQZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:25:43 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:28570 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942AbYBPQZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:25:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fJAEF1PPc85E0sq8k34A+5kaLSB5BfrzX4t42mio0mRWJjHErsRBiqcI5INl2Uh16+N2UAnB99gnVyyCXIGbobIsQWpsMzhB+/ZXVC2ayB9jlRSzcad0+DO8Emi2PU1XQIZejH3DjgAPZbr7YCbQnOjf4TAwW10l9IG3CnI1X/g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 17:40:09 +0100
Message-Id: <20080216164009.10174.55119.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
References: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
Subject: [PATCH 11/12] ide: cleanup ide_match_hwif()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove no longer needed matching against I/O base and 'io_base' argument.

* Move printk() to the caller and remove 'name' argument.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/setup-pci.c |   47 +++++++++++++++--------------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -22,42 +22,20 @@
 
 
 /**
- *	ide_match_hwif	-	match a PCI IDE against an ide_hwif
- *	@io_base: I/O base of device
- *	@bootable: set if its bootable
- *	@name: name of device
+ *	ide_match_hwif	-	find free ide_hwifs[] slot
+ *	@bootable: bootable flag
  *
- *	Match a PCI IDE port against an entry in ide_hwifs[],
- *	based on io_base port if possible. Return the matching hwif,
- *	or a new hwif. If we find an error (clashing, out of devices, etc)
- *	return NULL
- *
- *	FIXME: we need to handle mmio matches here too
+ *	Return the new hwif.  If we are out of free slots return NULL.
  */
 
-static ide_hwif_t *ide_match_hwif(unsigned long io_base, u8 bootable, const char *name)
+static ide_hwif_t *ide_match_hwif(u8 bootable)
 {
-	int h;
 	ide_hwif_t *hwif;
+	int h;
 
 	/*
-	 * Look for a hwif with matching io_base default value.
-	 * If chipset is "ide_unknown", then claim that hwif slot.
-	 * Otherwise, some other chipset has already claimed it..  :(
-	 */
-	for (h = 0; h < MAX_HWIFS; ++h) {
-		hwif = &ide_hwifs[h];
-		if (hwif->io_ports[IDE_DATA_OFFSET] == io_base) {
-			if (hwif->chipset == ide_unknown)
-				return hwif; /* match */
-			printk(KERN_ERR "%s: port 0x%04lx already claimed by %s\n",
-				name, io_base, hwif->name);
-			return NULL;	/* already claimed */
-		}
-	}
-	/*
-	 * Okay, there is no hwif matching our io_base,
-	 * so we'll just claim an unassigned slot.
+	 * Claim an unassigned slot.
+	 *
 	 * Give preference to claiming other slots before claiming ide0/ide1,
 	 * just in case there's another interface yet-to-be-scanned
 	 * which uses ports 1f0/170 (the ide0/ide1 defaults).
@@ -83,7 +61,7 @@ static ide_hwif_t *ide_match_hwif(unsign
 		if (hwif->chipset == ide_unknown)
 			return hwif;	/* pick an unused entry */
 	}
-	printk(KERN_ERR "%s: too many IDE interfaces, no room in table\n", name);
+
 	return NULL;
 }
 
@@ -367,8 +345,13 @@ static ide_hwif_t *ide_hwif_configure(st
 		ctl = port ? 0x374 : 0x3f4;
 		base = port ? 0x170 : 0x1f0;
 	}
-	if ((hwif = ide_match_hwif(base, bootable, d->name)) == NULL)
-		return NULL;	/* no room in ide_hwifs[] */
+
+	hwif = ide_match_hwif(bootable);
+	if (hwif == NULL) {
+		printk(KERN_ERR "%s: too many IDE interfaces, no room in "
+				"table\n", d->name);
+		return NULL;
+	}
 
 	memset(&hw, 0, sizeof(hw));
 	hw.irq = irq;
