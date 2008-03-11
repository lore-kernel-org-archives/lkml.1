Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYCKUOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYCKUOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYCKUN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:13:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:7171 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbYCKUN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=f27IGAiKh7TsdcPoFqUbfcGBN+28XXDKiropHwYXI0zhxXqVlvX9DMVxz3TrYdAFJDpJGt5b5vBD4DM+js7911JQ9RJ6GsZS5CrtV+vhVdLTsM0holKo5Jnw8Imv98LDNFItqfTUkedpgdAHNQSe/NJjO3HI1Y/tPa/QcTHEsUs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove obsoleted "idex=noprobe" kernel parameter (take 2)
Date: Tue, 11 Mar 2008 21:25:22 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112125.22982.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove obsoleted "idex=noprobe" kernel parameter.

* Remove no longer needed hwif->noprobe quirk from ide_hwif_configure()
  and hwif->noprobe checking from cmd640.c.

v2:
* "ide?=noprobe" -> "ide?=ata66" in Documentation/kernel-parameters.txt.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
replacement patch

 Documentation/kernel-parameters.txt |    2 +-
 drivers/ide/ide.c                   |    6 ++----
 drivers/ide/pci/cmd640.c            |    3 +--
 drivers/ide/setup-pci.c             |    7 -------
 4 files changed, 4 insertions(+), 14 deletions(-)

Index: b/Documentation/kernel-parameters.txt
===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -769,7 +769,7 @@ and is between 256 and 4096 characters. 
 			See Documentation/ide/ide.txt.
 
 	ide?=		[HW] (E)IDE subsystem
-			Format: ide?=noprobe or chipset specific parameters.
+			Format: ide?=ata66 or chipset specific parameters.
 			See Documentation/ide/ide.txt.
 
 	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1141,7 +1141,7 @@ static int __init ide_setup(char *s)
 		 * (-8, -9, -10) are reserved to ease the hardcoding.
 		 */
 		static const char *ide_words[] = {
-			"noprobe", "serialize", "minus3", "minus4",
+			"minus1", "serialize", "minus3", "minus4",
 			"reset", "minus6", "ata66", "minus8", "minus9",
 			"minus10", "four", "qd65xx", "ht6560b", "cmd640_vlb",
 			"dtc2278", "umc8672", "ali14xx", NULL };
@@ -1233,9 +1233,7 @@ static int __init ide_setup(char *s)
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
 
