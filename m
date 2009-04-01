Return-Path: <linux-kernel-owner+w=401wt.eu-S934408AbZDAUoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408AbZDAUoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 16:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761490AbZDAUn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 16:43:58 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:40289 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509AbZDAUn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 16:43:56 -0400
Date: Wed, 1 Apr 2009 22:43:50 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] ide: falconide/q40ide - Use __ide_mm_{in,out}sw() for data
 transfer
Message-ID: <Pine.LNX.4.64.0904012243060.29342@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both of commits f94116aeec7a299640dd692128e1d22178affa8d ("ide: cleanup
<asm-m68k/ide.h>") and 15a453a955f89f6545118770c669b52e925368bd ("ide: include
<asm/ide.h> only when needed") break falconide:

| Uniform Multi-Platform E-IDE driver
| ide: Falcon IDE controller
| Probing IDE interface ide0...
| hda: Sarge m68k, ATA DISK drive
| ide0 at 0xfff00000 on irq 15 (serialized)
| ide-gd driver 1.18
| hda: max request size: 128KiB
| hda: 2118816 sectors (1084 MB) w/256KiB Cache, CHS=2102/16/63
|  hda:<4>hda: lost interrupt

This happens because falconide relies on {in,out}sw() being redefined in
<asm/ide.h>, as included by <linux/ide.h>, which is no longer the case.
Use __ide_mm_{in,out}sw() from <asm/ide.h> instead, just like
ide_{in,out}put_data() do.

The same problem seems to exist in q40ide.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/ide/falconide.c |   13 +++++++++----
 drivers/ide/q40ide.c    |   14 ++++++++++----
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/falconide.c b/drivers/ide/falconide.c
index b368a5e..1f790da 100644
--- a/drivers/ide/falconide.c
+++ b/drivers/ide/falconide.c
@@ -20,6 +20,7 @@
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
 #include <asm/atari_stdma.h>
+#include <asm/ide.h>
 
 #define DRV_NAME "falconide"
 
@@ -67,8 +68,10 @@ static void falconide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
-		return insw(data_addr, buf, (len + 1) / 2);
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS)) {
+		__ide_mm_insw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	raw_insw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
@@ -78,8 +81,10 @@ static void falconide_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
-		return outsw(data_addr, buf, (len + 1) / 2);
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS)) {
+		__ide_mm_outsw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	raw_outsw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
diff --git a/drivers/ide/q40ide.c b/drivers/ide/q40ide.c
index 2a43a2f..f054186 100644
--- a/drivers/ide/q40ide.c
+++ b/drivers/ide/q40ide.c
@@ -16,6 +16,8 @@
 #include <linux/blkdev.h>
 #include <linux/ide.h>
 
+#include <asm/ide.h>
+
     /*
      *  Bases of the IDE interfaces
      */
@@ -77,8 +79,10 @@ static void q40ide_input_data(ide_drive_t *drive, struct ide_cmd *cmd,
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
-		return insw(data_addr, buf, (len + 1) / 2);
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS)) {
+		__ide_mm_insw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	raw_insw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
@@ -88,8 +92,10 @@ static void q40ide_output_data(ide_drive_t *drive, struct ide_cmd *cmd,
 {
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
-	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS))
-		return outsw(data_addr, buf, (len + 1) / 2);
+	if (drive->media == ide_disk && cmd && (cmd->tf_flags & IDE_TFLAG_FS)) {
+		__ide_mm_outsw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	raw_outsw_swapw((u16 *)data_addr, buf, (len + 1) / 2);
 }
-- 
1.6.2.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
