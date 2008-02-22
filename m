Return-Path: <linux-kernel-owner+w=401wt.eu-S936655AbYBVWrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936655AbYBVWrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYBVWpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:45:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:48809 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076AbYBVWpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:45:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=YDCkWJb6VxnUr14MUvfT/H+H7Bb3r+bR7Uy//LqQqJ8PlbUbeCA8ELKm4SxYwSFoIQEcjieejctJwE2jRpY842cKAQAGJvsYKCBDE0xvoZlhAq/i81r9dVGqmdG7pg9BdFC10VFTi4rhzNKQEC3EuU1E1/bFXbDuOKPqpUu2Un8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove obsoleted "idex=noprobe" kernel parameter
Date: Fri, 22 Feb 2008 23:59:02 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802222359.02590.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove obsoleted "idex=noprobe" kernel parameter.

* Remove no longer needed hwif->noprobe quirk from ide_hwif_configure()
  and hwif->noprobe checking from cmd640.c.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes before "ide: move default IDE ports setup to ide_generic host driver"
patch in IDE quilt tree

 drivers/ide/ide.c        |    6 ++----
 drivers/ide/pci/cmd640.c |    3 +--
 drivers/ide/setup-pci.c  |    7 -------
 3 files changed, 3 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1144,7 +1144,7 @@ static int __init ide_setup(char *s)
 		 * (-8, -9, -10) are reserved to ease the hardcoding.
 		 */
 		static const char *ide_words[] = {
-			"noprobe", "serialize", "minus3", "minus4",
+			"minus1", "serialize", "minus3", "minus4",
 			"reset", "minus6", "ata66", "minus8", "minus9",
 			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
 			"dtc2278", "umc8672", "ali14xx", NULL };
@@ -1236,9 +1236,7 @@ static int __init ide_setup(char *s)
 				hwif->serialized = hwif->mate->serialized = 1;
 				goto obsolete_option;
 
-			case -1: /* "noprobe" */
-				hwif->noprobe = 1;
-				goto obsolete_option;
+			case -1:
 			case 0:
 			case 1:
 			case 2:
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -789,8 +789,7 @@ static int __init cmd640x_init(void)
 	/*
 	 * Try to enable the secondary interface, if not already enabled
 	 */
-	if (cmd_hwif1->noprobe ||
-	    (cmd_hwif1->drives[0].noprobe && cmd_hwif1->drives[1].noprobe)) {
+	if (cmd_hwif1->drives[0].noprobe && cmd_hwif1->drives[1].noprobe) {
 		port2 = "not probed";
 	} else {
 		b = get_cmd640_reg(CNTRL);
Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -345,7 +345,6 @@ static ide_hwif_t *ide_hwif_configure(st
 	unsigned long ctl = 0, base = 0;
 	ide_hwif_t *hwif;
 	u8 bootable = (d->host_flags & IDE_HFLAG_BOOTABLE) ? 1 : 0;
-	u8 oldnoprobe = 0;
 	struct hw_regs_s hw;
 
 	if ((d->host_flags & IDE_HFLAG_ISA_PORTS) == 0) {
@@ -376,14 +375,8 @@ static ide_hwif_t *ide_hwif_configure(st
 	hw.chipset = d->chipset ? d->chipset : ide_pci;
 	ide_std_init_ports(&hw, base, ctl | 2);
 
-	if (hwif->io_ports[IDE_DATA_OFFSET] == base &&
-	    hwif->io_ports[IDE_CONTROL_OFFSET] == (ctl | 2))
-		oldnoprobe = hwif->noprobe;
-
 	ide_init_port_hw(hwif, &hw);
 
-	hwif->noprobe = oldnoprobe;
-
 	hwif->dev = &dev->dev;
 	hwif->cds = d;
 
