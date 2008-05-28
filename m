Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbYE1VoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbYE1VoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYE1Vmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:42:47 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:42112 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbYE1Vmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=MJQP5IbwSdy3d7XQFlqGFfSqMq4lhYvw93olm/c3ckD+1RGDg7JB46ajGIuQGZsl2+V+BSkXS4in+0+ewba7EEFEbIyryTdhyVuL5OmgpT8KYgL4PClyTtfhOx22sK1rT7e2o0iLXss5q3iegTg4Yy94yND/F08clJC3UMZKTaQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:40:19 +0200
Message-Id: <20080528214019.16327.16020.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/21] ide: move some bits from ide-timing.h to <linux/ide.h>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move struct ide_timing and IDE_TIMING_* defines to <linux/ide.h>
from drivers/ide/ide-timing.h.

While at it:

- use u8/u16 instead of short for struct ide_timing fields

- use enum for IDE_TIMING_*

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-timing.h |   23 -----------------------
 include/linux/ide.h      |   28 ++++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 23 deletions(-)

Index: b/drivers/ide/ide-timing.h
===================================================================
--- a/drivers/ide/ide-timing.h
+++ b/drivers/ide/ide-timing.h
@@ -28,18 +28,6 @@
 #include <linux/kernel.h>
 #include <linux/hdreg.h>
 
-struct ide_timing {
-	u8    mode;
-	short setup;	/* t1 */
-	short act8b;	/* t2 for 8-bit io */
-	short rec8b;	/* t2i for 8-bit io */
-	short cyc8b;	/* t0 for 8-bit io */
-	short active;	/* t2 or tD */
-	short recover;	/* t2i or tK */
-	short cycle;	/* t0 */
-	short udma;	/* t2CYCTYP/2 */
-};
-
 /*
  * PIO 0-5, MWDMA 0-2 and UDMA 0-6 timings (in nanoseconds).
  * These were taken from ATA/ATAPI-6 standard, rev 0a, except
@@ -79,17 +67,6 @@ static struct ide_timing ide_timing[] = 
 	{ 0xff }
 };
 
-#define IDE_TIMING_SETUP	0x01
-#define IDE_TIMING_ACT8B	0x02
-#define IDE_TIMING_REC8B	0x04
-#define IDE_TIMING_CYC8B	0x08
-#define IDE_TIMING_8BIT		0x0e
-#define IDE_TIMING_ACTIVE	0x10
-#define IDE_TIMING_RECOVER	0x20
-#define IDE_TIMING_CYCLE	0x40
-#define IDE_TIMING_UDMA		0x80
-#define IDE_TIMING_ALL		0xff
-
 #define ENOUGH(v,unit)		(((v)-1)/(unit)+1)
 #define EZ(v,unit)		((v)?ENOUGH(v,unit):0)
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1256,6 +1256,34 @@ static inline int ide_dev_is_sata(struct
 u64 ide_get_lba_addr(struct ide_taskfile *, int);
 u8 ide_dump_status(ide_drive_t *, const char *, u8);
 
+struct ide_timing {
+	u8  mode;
+	u8  setup;	/* t1 */
+	u16 act8b;	/* t2 for 8-bit io */
+	u16 rec8b;	/* t2i for 8-bit io */
+	u16 cyc8b;	/* t0 for 8-bit io */
+	u16 active;	/* t2 or tD */
+	u16 recover;	/* t2i or tK */
+	u16 cycle;	/* t0 */
+	u16 udma;	/* t2CYCTYP/2 */
+};
+
+enum {
+	IDE_TIMING_SETUP	= (1 << 0),
+	IDE_TIMING_ACT8B	= (1 << 1),
+	IDE_TIMING_REC8B	= (1 << 2),
+	IDE_TIMING_CYC8B	= (1 << 3),
+	IDE_TIMING_8BIT		= IDE_TIMING_ACT8B | IDE_TIMING_REC8B |
+				  IDE_TIMING_CYC8B,
+	IDE_TIMING_ACTIVE	= (1 << 4),
+	IDE_TIMING_RECOVER	= (1 << 5),
+	IDE_TIMING_CYCLE	= (1 << 6),
+	IDE_TIMING_UDMA		= (1 << 7),
+	IDE_TIMING_ALL		= IDE_TIMING_SETUP | IDE_TIMING_8BIT |
+				  IDE_TIMING_ACTIVE | IDE_TIMING_RECOVER |
+				  IDE_TIMING_CYCLE | IDE_TIMING_UDMA,
+};
+
 typedef struct ide_pio_timings_s {
 	int	setup_time;	/* Address setup (ns) minimum */
 	int	active_time;	/* Active pulse (ns) minimum */
