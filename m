Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYE1VpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYE1VpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYE1VnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:43:17 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:50110 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbYE1VnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XWnhud2GyZ8xr1qphO0RDPNocXyDcMI5LDqExxZfi10Sk357R+lbE5msUeNn17ryULXgG/3GyidgL/IBUn6PWmDJpHW57azgMm+4Ewqx9zdxAVqv5NUHk6YN4EBUK0uk/SDcW2MSKV1pM/HxwAIZBZwXqk8QERVTB1yS+rk5Zpc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:40:44 +0200
Message-Id: <20080528214044.16327.44511.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/21] ide: convert ide-timing.h to ide-timings.c library
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Don't include ide-timing.h in cs5535 and sis5513 host drivers
  (they don't need it currently).

* Convert ide-timing.h to ide-timings.c library and add CONFIG_IDE_TIMINGS
  config option to be selected by host drivers using the library.

While at it:

- fix ide_timing_find_mode() placement

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig           |    7 +
 drivers/ide/Makefile          |    1 
 drivers/ide/arm/palm_bk3710.c |    2 
 drivers/ide/ide-timing.h      |  183 ------------------------------------------
 drivers/ide/ide-timings.c     |  179 +++++++++++++++++++++++++++++++++++++++++
 drivers/ide/pci/amd74xx.c     |    2 
 drivers/ide/pci/cs5535.c      |    2 
 drivers/ide/pci/sis5513.c     |    3 
 drivers/ide/pci/via82cxxx.c   |    2 
 drivers/ide/ppc/pmac.c        |    2 
 include/linux/ide.h           |    5 +
 11 files changed, 192 insertions(+), 196 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -98,6 +98,9 @@ if BLK_DEV_IDE
 
 comment "Please see Documentation/ide/ide.txt for help/info on IDE drives"
 
+config IDE_TIMINGS
+	bool
+
 config IDE_ATAPI
 	bool
 
@@ -469,6 +472,7 @@ config BLK_DEV_ALI15X3
 config BLK_DEV_AMD74XX
 	tristate "AMD and nVidia IDE support"
 	depends on !ARM
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds explicit support for AMD-7xx and AMD-8111 chips
@@ -725,6 +729,7 @@ config BLK_DEV_TRM290
 
 config BLK_DEV_VIA82CXXX
 	tristate "VIA82CXXX chipset support"
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_PCI
 	help
 	  This driver adds explicit support for VIA BusMastering IDE chips.
@@ -751,6 +756,7 @@ endif
 config BLK_DEV_IDE_PMAC
 	tristate "PowerMac on-board IDE support"
 	depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y
+	select IDE_TIMINGS
 	help
 	  This driver provides support for the on-board IDE controller on
 	  most of the recent Apple Power Macintoshes and PowerBooks.
@@ -919,6 +925,7 @@ config BLK_DEV_Q40IDE
 config BLK_DEV_PALMCHIP_BK3710
 	tristate "Palmchip bk3710 IDE controller support"
 	depends on ARCH_DAVINCI
+	select IDE_TIMINGS
 	select BLK_DEV_IDEDMA_SFF
 	help
 	  Say Y here if you want to support the onchip IDE controller on the
Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -14,6 +14,7 @@ EXTRA_CFLAGS				+= -Idrivers/ide
 ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o ide-taskfile.o
 
 # core IDE code
+ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
 ide-core-$(CONFIG_IDE_ATAPI)		+= ide-atapi.o
 ide-core-$(CONFIG_BLK_DEV_IDEPCI)	+= setup-pci.o
 ide-core-$(CONFIG_BLK_DEV_IDEDMA)	+= ide-dma.o
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -74,8 +74,6 @@ struct palm_bk3710_udmatiming {
 #define BK3710_IORDYTMP		0x78
 #define BK3710_IORDYTMS		0x7C
 
-#include "../ide-timing.h"
-
 static long ide_palm_clk;
 
 static const struct palm_bk3710_udmatiming palm_bk3710_udmatimings[6] = {
Index: b/drivers/ide/ide-timing.h
===================================================================
--- a/drivers/ide/ide-timing.h
+++ /dev/null
@@ -1,183 +0,0 @@
-#ifndef _IDE_TIMING_H
-#define _IDE_TIMING_H
-
-/*
- *  Copyright (c) 1999-2001 Vojtech Pavlik
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * Should you need to contact me, the author, you can do so either by
- * e-mail - mail your message to <vojtech@ucw.cz>, or by paper mail:
- * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
- */
-
-#include <linux/kernel.h>
-#include <linux/hdreg.h>
-
-/*
- * PIO 0-5, MWDMA 0-2 and UDMA 0-6 timings (in nanoseconds).
- * These were taken from ATA/ATAPI-6 standard, rev 0a, except
- * for PIO 5, which is a nonstandard extension and UDMA6, which
- * is currently supported only by Maxtor drives.
- */
-
-static struct ide_timing ide_timing[] = {
-
-	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0,   0,  15 },
-	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0,   0,  20 },
-	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0,   0,  30 },
-	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0,   0,  45 },
-
-	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0,   0,  60 },
-	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
-	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
-
-	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
-	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
-	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
-
-	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
-	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
-	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
-
-	{ XFER_PIO_5,     20,  50,  30, 100,  50,  30, 100,   0 },
-	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
-	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
-
-	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 240,   0 },
-	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 383,   0 },
-	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 600,   0 },
-
-	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 },
-
-	{ 0xff }
-};
-
-#define ENOUGH(v, unit)		(((v) - 1) / (unit) + 1)
-#define EZ(v, unit)		((v) ? ENOUGH(v, unit) : 0)
-
-static void ide_timing_quantize(struct ide_timing *t, struct ide_timing *q,
-				int T, int UT)
-{
-	q->setup   = EZ(t->setup   * 1000,  T);
-	q->act8b   = EZ(t->act8b   * 1000,  T);
-	q->rec8b   = EZ(t->rec8b   * 1000,  T);
-	q->cyc8b   = EZ(t->cyc8b   * 1000,  T);
-	q->active  = EZ(t->active  * 1000,  T);
-	q->recover = EZ(t->recover * 1000,  T);
-	q->cycle   = EZ(t->cycle   * 1000,  T);
-	q->udma    = EZ(t->udma    * 1000, UT);
-}
-
-static void ide_timing_merge(struct ide_timing *a, struct ide_timing *b,
-			     struct ide_timing *m, unsigned int what)
-{
-	if (what & IDE_TIMING_SETUP)
-		m->setup   = max(a->setup,   b->setup);
-	if (what & IDE_TIMING_ACT8B)
-		m->act8b   = max(a->act8b,   b->act8b);
-	if (what & IDE_TIMING_REC8B)
-		m->rec8b   = max(a->rec8b,   b->rec8b);
-	if (what & IDE_TIMING_CYC8B)
-		m->cyc8b   = max(a->cyc8b,   b->cyc8b);
-	if (what & IDE_TIMING_ACTIVE)
-		m->active  = max(a->active,  b->active);
-	if (what & IDE_TIMING_RECOVER)
-		m->recover = max(a->recover, b->recover);
-	if (what & IDE_TIMING_CYCLE)
-		m->cycle   = max(a->cycle,   b->cycle);
-	if (what & IDE_TIMING_UDMA)
-		m->udma    = max(a->udma,    b->udma);
-}
-
-static struct ide_timing *ide_timing_find_mode(u8 speed)
-{
-	struct ide_timing *t;
-
-	for (t = ide_timing; t->mode != speed; t++)
-		if (t->mode == 0xff)
-			return NULL;
-	return t;
-}
-
-static int ide_timing_compute(ide_drive_t *drive, u8 speed,
-			      struct ide_timing *t, int T, int UT)
-{
-	struct hd_driveid *id = drive->id;
-	struct ide_timing *s, p;
-
-	/*
-	 * Find the mode.
-	 */
-	s = ide_timing_find_mode(speed);
-	if (s == NULL)
-		return -EINVAL;
-
-	/*
-	 * Copy the timing from the table.
-	 */
-	*t = *s;
-
-	/*
-	 * If the drive is an EIDE drive, it can tell us it needs extended
-	 * PIO/MWDMA cycle timing.
-	 */
-	if (id && id->field_valid & 2) {	/* EIDE drive */
-
-		memset(&p, 0, sizeof(p));
-
-		if (speed <= XFER_PIO_2)
-			p.cycle = p.cyc8b = id->eide_pio;
-		else if (speed <= XFER_PIO_5)
-			p.cycle = p.cyc8b = id->eide_pio_iordy;
-		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
-			p.cycle = id->eide_dma_min;
-
-		ide_timing_merge(&p, t, t, IDE_TIMING_CYCLE | IDE_TIMING_CYC8B);
-	}
-
-	/*
-	 * Convert the timing to bus clock counts.
-	 */
-	ide_timing_quantize(t, t, T, UT);
-
-	/*
-	 * Even in DMA/UDMA modes we still use PIO access for IDENTIFY,
-	 * S.M.A.R.T and some other commands. We have to ensure that the
-	 * DMA cycle timing is slower/equal than the fastest PIO timing.
-	 */
-	if (speed >= XFER_SW_DMA_0) {
-		u8 pio = ide_get_best_pio_mode(drive, 255, 5);
-		ide_timing_compute(drive, XFER_PIO_0 + pio, &p, T, UT);
-		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
-	}
-
-	/*
-	 * Lengthen active & recovery time so that cycle time is correct.
-	 */
-	if (t->act8b + t->rec8b < t->cyc8b) {
-		t->act8b += (t->cyc8b - (t->act8b + t->rec8b)) / 2;
-		t->rec8b = t->cyc8b - t->act8b;
-	}
-
-	if (t->active + t->recover < t->cycle) {
-		t->active += (t->cycle - (t->active + t->recover)) / 2;
-		t->recover = t->cycle - t->active;
-	}
-
-	return 0;
-}
-
-#endif
Index: b/drivers/ide/ide-timings.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-timings.c
@@ -0,0 +1,179 @@
+/*
+ *  Copyright (c) 1999-2001 Vojtech Pavlik
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Should you need to contact me, the author, you can do so either by
+ * e-mail - mail your message to <vojtech@ucw.cz>, or by paper mail:
+ * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
+ */
+
+#include <linux/kernel.h>
+#include <linux/hdreg.h>
+#include <linux/ide.h>
+
+/*
+ * PIO 0-5, MWDMA 0-2 and UDMA 0-6 timings (in nanoseconds).
+ * These were taken from ATA/ATAPI-6 standard, rev 0a, except
+ * for PIO 5, which is a nonstandard extension and UDMA6, which
+ * is currently supported only by Maxtor drives.
+ */
+
+static struct ide_timing ide_timing[] = {
+
+	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0,   0,  15 },
+	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0,   0,  20 },
+	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0,   0,  30 },
+	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0,   0,  45 },
+
+	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0,   0,  60 },
+	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
+	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
+
+	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
+	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
+	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
+
+	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
+	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
+	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
+
+	{ XFER_PIO_5,     20,  50,  30, 100,  50,  30, 100,   0 },
+	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
+	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
+
+	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 240,   0 },
+	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 383,   0 },
+	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 600,   0 },
+
+	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 },
+
+	{ 0xff }
+};
+
+struct ide_timing *ide_timing_find_mode(u8 speed)
+{
+	struct ide_timing *t;
+
+	for (t = ide_timing; t->mode != speed; t++)
+		if (t->mode == 0xff)
+			return NULL;
+	return t;
+}
+
+#define ENOUGH(v, unit)		(((v) - 1) / (unit) + 1)
+#define EZ(v, unit)		((v) ? ENOUGH(v, unit) : 0)
+
+static void ide_timing_quantize(struct ide_timing *t, struct ide_timing *q,
+				int T, int UT)
+{
+	q->setup   = EZ(t->setup   * 1000,  T);
+	q->act8b   = EZ(t->act8b   * 1000,  T);
+	q->rec8b   = EZ(t->rec8b   * 1000,  T);
+	q->cyc8b   = EZ(t->cyc8b   * 1000,  T);
+	q->active  = EZ(t->active  * 1000,  T);
+	q->recover = EZ(t->recover * 1000,  T);
+	q->cycle   = EZ(t->cycle   * 1000,  T);
+	q->udma    = EZ(t->udma    * 1000, UT);
+}
+
+void ide_timing_merge(struct ide_timing *a, struct ide_timing *b,
+		      struct ide_timing *m, unsigned int what)
+{
+	if (what & IDE_TIMING_SETUP)
+		m->setup   = max(a->setup,   b->setup);
+	if (what & IDE_TIMING_ACT8B)
+		m->act8b   = max(a->act8b,   b->act8b);
+	if (what & IDE_TIMING_REC8B)
+		m->rec8b   = max(a->rec8b,   b->rec8b);
+	if (what & IDE_TIMING_CYC8B)
+		m->cyc8b   = max(a->cyc8b,   b->cyc8b);
+	if (what & IDE_TIMING_ACTIVE)
+		m->active  = max(a->active,  b->active);
+	if (what & IDE_TIMING_RECOVER)
+		m->recover = max(a->recover, b->recover);
+	if (what & IDE_TIMING_CYCLE)
+		m->cycle   = max(a->cycle,   b->cycle);
+	if (what & IDE_TIMING_UDMA)
+		m->udma    = max(a->udma,    b->udma);
+}
+
+int ide_timing_compute(ide_drive_t *drive, u8 speed,
+		       struct ide_timing *t, int T, int UT)
+{
+	struct hd_driveid *id = drive->id;
+	struct ide_timing *s, p;
+
+	/*
+	 * Find the mode.
+	 */
+	s = ide_timing_find_mode(speed);
+	if (s == NULL)
+		return -EINVAL;
+
+	/*
+	 * Copy the timing from the table.
+	 */
+	*t = *s;
+
+	/*
+	 * If the drive is an EIDE drive, it can tell us it needs extended
+	 * PIO/MWDMA cycle timing.
+	 */
+	if (id && id->field_valid & 2) {	/* EIDE drive */
+
+		memset(&p, 0, sizeof(p));
+
+		if (speed <= XFER_PIO_2)
+			p.cycle = p.cyc8b = id->eide_pio;
+		else if (speed <= XFER_PIO_5)
+			p.cycle = p.cyc8b = id->eide_pio_iordy;
+		else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
+			p.cycle = id->eide_dma_min;
+
+		ide_timing_merge(&p, t, t, IDE_TIMING_CYCLE | IDE_TIMING_CYC8B);
+	}
+
+	/*
+	 * Convert the timing to bus clock counts.
+	 */
+	ide_timing_quantize(t, t, T, UT);
+
+	/*
+	 * Even in DMA/UDMA modes we still use PIO access for IDENTIFY,
+	 * S.M.A.R.T and some other commands. We have to ensure that the
+	 * DMA cycle timing is slower/equal than the fastest PIO timing.
+	 */
+	if (speed >= XFER_SW_DMA_0) {
+		u8 pio = ide_get_best_pio_mode(drive, 255, 5);
+		ide_timing_compute(drive, XFER_PIO_0 + pio, &p, T, UT);
+		ide_timing_merge(&p, t, t, IDE_TIMING_ALL);
+	}
+
+	/*
+	 * Lengthen active & recovery time so that cycle time is correct.
+	 */
+	if (t->act8b + t->rec8b < t->cyc8b) {
+		t->act8b += (t->cyc8b - (t->act8b + t->rec8b)) / 2;
+		t->rec8b = t->cyc8b - t->act8b;
+	}
+
+	if (t->active + t->recover < t->cycle) {
+		t->active += (t->cycle - (t->active + t->recover)) / 2;
+		t->recover = t->cycle - t->active;
+	}
+
+	return 0;
+}
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -21,8 +21,6 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 
-#include "ide-timing.h"
-
 enum {
 	AMD_IDE_CONFIG		= 0x41,
 	AMD_CABLE_DETECT	= 0x42,
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -26,8 +26,6 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
-#include "ide-timing.h"
-
 #define MSR_ATAC_BASE		0x51300000
 #define ATAC_GLD_MSR_CAP	(MSR_ATAC_BASE+0)
 #define ATAC_GLD_MSR_CONFIG	(MSR_ATAC_BASE+0x01)
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -52,8 +52,6 @@
 #include <linux/init.h>
 #include <linux/ide.h>
 
-#include "ide-timing.h"
-
 /* registers layout and init values are chipset family dependant */
 
 #define ATA_16		0x01
@@ -616,7 +614,6 @@ MODULE_LICENSE("GPL");
 /*
  * TODO:
  *	- CLEANUP
- *	- Use drivers/ide/ide-timing.h !
  *	- More checks in the config registers (force values instead of
  *	  relying on the BIOS setting them correctly).
  *	- Further optimisations ?
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -35,8 +35,6 @@
 #include <asm/processor.h>
 #endif
 
-#include "ide-timing.h"
-
 #define VIA_IDE_ENABLE		0x40
 #define VIA_IDE_CONFIG		0x41
 #define VIA_FIFO_CONFIG		0x43
Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -48,8 +48,6 @@
 #include <asm/mediabay.h>
 #endif
 
-#include "../ide-timing.h"
-
 #undef IDE_PMAC_DEBUG
 
 #define DMA_WAIT_TIMEOUT	50
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1284,6 +1284,11 @@ enum {
 				  IDE_TIMING_CYCLE | IDE_TIMING_UDMA,
 };
 
+struct ide_timing *ide_timing_find_mode(u8);
+void ide_timing_merge(struct ide_timing *, struct ide_timing *,
+		      struct ide_timing *, unsigned int);
+int ide_timing_compute(ide_drive_t *, u8, struct ide_timing *, int, int);
+
 typedef struct ide_pio_timings_s {
 	int	setup_time;	/* Address setup (ns) minimum */
 	int	active_time;	/* Active pulse (ns) minimum */
