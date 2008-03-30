Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYC3Pdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYC3Pdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 11:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYC3Pc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 11:32:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:13570 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbYC3Pch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 11:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=W1EdJa7didCWnuUQ5sXFptBilW6Luz6bHrMdFB2tGSBqySAbaJj3RSkrSjR39iPVyCJDSGGlS6laQzrJDvoQsXr+TNwrmVGfDYcaDMF7QJ4EjgmwRebGrzGfwKXztXcSPXUOUWOvgAmRP7cKnb62mZymAW0SjDM/a6QdlXsHaN8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 5/5] falconide/q40ide: add ->atapi_*put_bytes and ->ata_*put_data methods
Date: Sun, 30 Mar 2008 17:14:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Michael Schmitz <schmitz@debian.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803301714.04527.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Add ->atapi_{in,out}put_bytes and ->ata_{in,out}put_data methods to
  falconide and q40ide host drivers (->ata_* methods are implemented on
  top of ->atapi_* methods so they also do byte-swapping now).

* Cleanup atapi_{in,out}put_bytes().

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@debian.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
PS one of future patches will merge ->atapi_ and ->ata_ methods for IDE

 drivers/ide/ide-iops.c         |   14 --------------
 drivers/ide/legacy/falconide.c |   30 ++++++++++++++++++++++++++++++
 drivers/ide/legacy/q40ide.c    |   28 ++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 14 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -248,13 +248,6 @@ static void atapi_input_bytes(ide_drive_
 	ide_hwif_t *hwif = HWIF(drive);
 
 	++bytecount;
-#if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
-	if (MACH_IS_ATARI || MACH_IS_Q40) {
-		/* Atari has a byte-swapped IDE interface */
-		insw_swapw(hwif->io_ports.data_addr, buffer, bytecount / 2);
-		return;
-	}
-#endif /* CONFIG_ATARI || CONFIG_Q40 */
 	hwif->ata_input_data(drive, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
 		hwif->INSW(hwif->io_ports.data_addr,
@@ -266,13 +259,6 @@ static void atapi_output_bytes(ide_drive
 	ide_hwif_t *hwif = HWIF(drive);
 
 	++bytecount;
-#if defined(CONFIG_ATARI) || defined(CONFIG_Q40)
-	if (MACH_IS_ATARI || MACH_IS_Q40) {
-		/* Atari has a byte-swapped IDE interface */
-		outsw_swapw(hwif->io_ports.data_addr, buffer, bytecount / 2);
-		return;
-	}
-#endif /* CONFIG_ATARI || CONFIG_Q40 */
 	hwif->ata_output_data(drive, buffer, bytecount / 4);
 	if ((bytecount & 0x03) >= 2)
 		hwif->OUTSW(hwif->io_ports.data_addr,
Index: b/drivers/ide/legacy/falconide.c
===================================================================
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -44,6 +44,30 @@
 int falconide_intr_lock;
 EXPORT_SYMBOL(falconide_intr_lock);
 
+static void falconide_atapi_input_bytes(ide_drive_t *drive, void *buf,
+					unsigned int len)
+{
+	insw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void falconide_atapi_output_bytes(ide_drive_t *drive, void *buf,
+					 unsigned int len)
+{
+	outsw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void falconide_ata_input_data(ide_drive_t *drive, void *buf,
+				     unsigned int wcount)
+{
+	falconide_atapi_input_bytes(drive, buf, wcount * 4);
+}
+
+static void falconide_ata_output_data(ide_drive_t *drive, void *buf,
+				      unsigned int wcount)
+{
+	falconide_atapi_output_bytes(drive, buf, wcount * 4);
+}
+
 static void __init falconide_setup_ports(hw_regs_t *hw)
 {
 	int i;
@@ -89,6 +113,12 @@ static int __init falconide_init(void)
 
 		ide_init_port_hw(hwif, &hw);
 
+		/* Atari has a byte-swapped IDE interface */
+		hwif->atapi_input_bytes  = falconide_atapi_input_bytes;
+		hwif->atapi_output_bytes = falconide_atapi_output_bytes;
+		hwif->ata_input_data	 = falconide_ata_input_data;
+		hwif->ata_output_data	 = falconide_ata_output_data;
+
 		ide_get_lock(NULL, NULL);
 		ide_device_add(idx, NULL);
 		ide_release_lock();
Index: b/drivers/ide/legacy/q40ide.c
===================================================================
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -90,7 +90,29 @@ void q40_ide_setup_ports ( hw_regs_t *hw
 	hw->ack_intr = ack_intr;
 }
 
+static void q40ide_atapi_input_bytes(ide_drive_t *drive, void *buf,
+				     unsigned int len)
+{
+	insw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
 
+static void q40ide_atapi_output_bytes(ide_drive_t *drive, void *buf,
+				      unsigned int len)
+{
+	outsw_swapw(drive->hwif->io_ports.data_addr, buf, (len + 1) / 2);
+}
+
+static void q40ide_ata_input_data(ide_drive_t *drive, void *buf,
+				  unsigned int wcount)
+{
+	q40ide_atapi_input_bytes(drive, buf, wcount * 4);
+}
+
+static void q40ide_ata_output_data(ide_drive_t *drive, void *buf,
+				   unsigned int wcount)
+{
+	q40ide_atapi_output_bytes(drive, buf, wcount * 4);
+}
 
 /* 
  * the static array is needed to have the name reported in /proc/ioports,
@@ -141,6 +163,12 @@ static int __init q40ide_init(void)
 	if (hwif) {
 		ide_init_port_hw(hwif, &hw);
 
+		/* Q40 has a byte-swapped IDE interface */
+		hwif->atapi_input_bytes  = q40ide_atapi_input_bytes;
+		hwif->atapi_output_bytes = q40ide_atapi_output_bytes;
+		hwif->ata_input_data	 = q40ide_ata_input_data;
+		hwif->ata_output_data	 = q40ide_ata_output_data;
+
 		idx[i] = hwif->index;
 	}
     }
