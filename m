Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYL3QMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYL3QMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 11:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYL3QM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 11:12:27 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:48242 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbYL3QM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 11:12:26 -0500
X-Greylist: delayed 2353 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2008 11:12:25 EST
From: Kirill Smelkov <kirr@mns.spb.ru>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kirr@landau.phys.spbu.ru,
       Dmitry Gryazin <gdu@mns.spb.ru>, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH] ide: motherboard-info based blacklist for ide-dma
Date: Tue, 30 Dec 2008 18:33:59 +0300
Message-Id: <1230651239-29388-1-git-send-email-kirr@mns.spb.ru>
X-Mailer: git-send-email 1.6.1.49.g94ee8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Gryazin <gdu@mns.spb.ru>

We need to keep our kernel working on both legacy and modern hardware.

As it turned out, some boards don't have proper IDE DMA support for
CompactFlash (CF) adaptors, because pin connectors which relate to DMA are left
unsoldered (*).

To verify this we even bought external IDE CF adaptor which showed the same
symthoms, and then manually soldered pins that were left dangling, and voila,
DMA started to work!

Again, as they say, lots of manufacturers of not-so-new hardware did CF
soldering by the wrong way with respect to DMA, so we need a workaround.

For this __ide_dma_bad_drive function is enhance to check not only drives
blacklist but motherboards blacklist too.

Please apply before 2.6.29

(*) On IEI PCISA-C3/EDEN the kernel boots _very_ slowly, becuase we have lots
of DMA timer expiry:

    <~30s pause>
    hdc: dma_timer_epiry: dma_status == 0x21
    hdc: DMA timeout error
    ...
    hdc: DMA disabled
    ide1: dma reset

    <and the whole story repeats:>
    <~30s pause>
    hdc: dma_timer_epiry: dma_status == 0x21
    ...

Also see this posts from 2006 where they say this is usually a problem with CF
adapter not fully soldered:

http://lkml.org/lkml/2006/5/23/198
http://lkml.org/lkml/2006/6/20/164

Signed-off-by: Dmitry Gryazin <gdu@mns.spb.ru>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/ide/ide-dma.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index fffd117..adb5d9d 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -33,6 +33,21 @@
 #include <linux/ide.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmi.h>
+
+/* Internal structure for blacklisted boards */
+struct board_blacklist_entry {
+	const char *board_vendor;
+	const char *board_name;
+	const char *drive_name;
+};
+
+/* Blacklisted boards which have problems with DMA */
+static const struct board_blacklist_entry board_blacklist[] = {
+	/* on IEI PCISA-C3 CF adapter pin connectors for DMA are missing */
+	{ "FIC"		,	"PT-2200"	,	"hdc"	},
+	{ NULL		,	NULL		,	NULL	}
+};
 
 static const struct drive_list_entry drive_whitelist[] = {
 	{ "Micropolis 2112A"	,       NULL		},
@@ -207,6 +222,30 @@ void ide_dma_on(ide_drive_t *drive)
 	drive->hwif->dma_ops->dma_host_set(drive, 1);
 }
 
+static int __ide_dma_bad_adaptor(ide_drive_t *drive)
+{
+	const struct board_blacklist_entry *table = board_blacklist;
+
+	const char *board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
+	const char *board_name   = dmi_get_system_info(DMI_BOARD_NAME);
+
+	if (!board_vendor || !board_name)
+		return 0;
+
+	for ( ; table->board_name ; table++)
+		if ((!strcmp(board_vendor, table->board_vendor)) &&
+		    (!strcmp(board_name,   table->board_name))   &&
+		    (!strcmp(drive->name,  table->drive_name))) {
+			printk(KERN_WARNING "%s: Disabling (U)DMA for %s "
+				"(Board %s %s is blacklisted)\n", drive->name,
+				(char *)&drive->id[ATA_ID_PROD], board_vendor,
+				board_name);
+			return 1;
+		}
+
+	return 0;
+}
+
 int __ide_dma_bad_drive(ide_drive_t *drive)
 {
 	u16 *id = drive->id;
@@ -217,7 +256,8 @@ int __ide_dma_bad_drive(ide_drive_t *drive)
 				    drive->name, (char *)&id[ATA_ID_PROD]);
 		return blacklist;
 	}
-	return 0;
+
+	return __ide_dma_bad_adaptor(drive);
 }
 EXPORT_SYMBOL(__ide_dma_bad_drive);
 
-- 
1.6.1.49.g94ee8

