Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZDVSpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZDVSpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZDVSpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:45:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:50580 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbZDVSpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:45:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=XRcrTppedSC5iIs9hCNA9q9TFsvC4BJ/zOF0Z/fnt9DQVWPpy9zL9IbXwkKUY/9L28
         XFJlX3+wibaHiVGirJcAi609dVZpzoSvwqYxfZfpVy8OI2xwh2fKQniAf07UYorRsa+E
         mPF8LDAzky0MgJ6R7MzbsEAS8BFwBHAm+su4U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 22 Apr 2009 20:48:15 +0200
Message-Id: <200904222048.15556.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ mediabay.c changes are limited to <linux/ide.h> include removal ]

Linus, please pull from 'for-linus' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-linus

to receive the following updates:

 drivers/ide/ide-cd.c         |    2 +-
 drivers/ide/ide-gd.c         |   17 ++++++++++++++++-
 drivers/ide/palm_bk3710.c    |   26 ++++++++++++--------------
 drivers/macintosh/mediabay.c |    1 -
 4 files changed, 29 insertions(+), 17 deletions(-)


Bartlomiej Zolnierkiewicz (1):
      mediabay: fix build for CONFIG_BLOCK=n

Bruno Prémont (1):
      ide: Stop disks on reboot for laptop which cuts power

David Brownell (1):
      palm_bk3710: UDMA performance fix

Helge Deller (1):
      ide-cd: fix kernel crash on hppa regression


diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3aec19d..3d4e099 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -609,7 +609,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 	struct request *rq = hwif->rq;
 	ide_expiry_t *expiry = NULL;
 	int dma_error = 0, dma, thislen, uptodate = 0;
-	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc, nsectors;
+	int write = (rq_data_dir(rq) == WRITE) ? 1 : 0, rc = 0, nsectors;
 	int sense = blk_sense_request(rq);
 	unsigned int timeout;
 	u16 len;
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 1aebdf1..4b6b71e 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -7,6 +7,7 @@
 #include <linux/mutex.h>
 #include <linux/ide.h>
 #include <linux/hdreg.h>
+#include <linux/dmi.h>
 
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define IDE_DISK_MINORS		(1 << PARTN_BITS)
@@ -99,6 +100,19 @@ static void ide_gd_resume(ide_drive_t *drive)
 		(void)drive->disk_ops->get_capacity(drive);
 }
 
+static const struct dmi_system_id ide_coldreboot_table[] = {
+	{
+		/* Acer TravelMate 66x cuts power during reboot */
+		.ident   = "Acer TravelMate 660",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
+		},
+	},
+
+	{ }	/* terminate list */
+};
+
 static void ide_gd_shutdown(ide_drive_t *drive)
 {
 #ifdef	CONFIG_ALPHA
@@ -115,7 +129,8 @@ static void ide_gd_shutdown(ide_drive_t *drive)
 	   the disk to expire its write cache. */
 	if (system_state != SYSTEM_POWER_OFF) {
 #else
-	if (system_state == SYSTEM_RESTART) {
+	if (system_state == SYSTEM_RESTART &&
+		!dmi_check_system(ide_coldreboot_table)) {
 #endif
 		drive->disk_ops->flush(drive);
 		return;
diff --git a/drivers/ide/palm_bk3710.c b/drivers/ide/palm_bk3710.c
index c7acca0..d1513b4 100644
--- a/drivers/ide/palm_bk3710.c
+++ b/drivers/ide/palm_bk3710.c
@@ -39,14 +39,6 @@
 /* Primary Control Offset */
 #define IDE_PALM_ATA_PRI_CTL_OFFSET 0x3F6
 
-/*
- * PalmChip 3710 IDE Controller UDMA timing structure Definition
- */
-struct palm_bk3710_udmatiming {
-	unsigned int rptime;	/* Ready to pause time  */
-	unsigned int cycletime;	/* Cycle Time           */
-};
-
 #define BK3710_BMICP		0x00
 #define BK3710_BMISP		0x02
 #define BK3710_BMIDTP		0x04
@@ -75,13 +67,19 @@ struct palm_bk3710_udmatiming {
 
 static unsigned ideclk_period; /* in nanoseconds */
 
+struct palm_bk3710_udmatiming {
+	unsigned int rptime;	/* tRP -- Ready to pause time (nsec) */
+	unsigned int cycletime;	/* tCYCTYP2/2 -- avg Cycle Time (nsec) */
+				/* tENV is always a minimum of 20 nsec */
+};
+
 static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
-	{160, 240},		/* UDMA Mode 0 */
-	{125, 160},		/* UDMA Mode 1 */
-	{100, 120},		/* UDMA Mode 2 */
-	{100, 90},		/* UDMA Mode 3 */
-	{100, 60},		/* UDMA Mode 4 */
-	{85,  40},		/* UDMA Mode 5 */
+	{160, 240 / 2,},	/* UDMA Mode 0 */
+	{125, 160 / 2,},	/* UDMA Mode 1 */
+	{100, 120 / 2,},	/* UDMA Mode 2 */
+	{100, 90 / 2,},		/* UDMA Mode 3 */
+	{100, 60 / 2,},		/* UDMA Mode 4 */
+	{85,  40 / 2,},		/* UDMA Mode 5 */
 };
 
 static void palm_bk3710_setudmamode(void __iomem *base, unsigned int dev,
diff --git a/drivers/macintosh/mediabay.c b/drivers/macintosh/mediabay.c
index d7e46d3..eca55ef 100644
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -18,7 +18,6 @@
 #include <linux/timer.h>
 #include <linux/stddef.h>
 #include <linux/init.h>
-#include <linux/ide.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <asm/prom.h>
