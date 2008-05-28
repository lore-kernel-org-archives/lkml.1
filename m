Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbYE1Vti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbYE1Vti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755697AbYE1VqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:46:10 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:51999 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbYE1VqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=r23VBeEodqcaUyJX5YjgVMd/uT60NVnKJxWMb90aIAdvWqi1YxPQi04bGrkQw6IMeqKTl5y9ElxbIIgP5REWs42m1Nb7pmehyhGa8+pvtKWezRCmzklpyFGLWfN1bV6YyufqEsYofhCRSN0Tdi6Q7nZguZ5BL+PKwLyVgiIxDZ8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:43:36 +0200
Message-Id: <20080528214336.16327.94684.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 21/21] ide: move PIO blacklist to ide-pio-blacklist.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move PIO blacklist to ide-pio-blacklist.c.

While at it:

- fix comment

- fix whitespace damage

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Makefile            |    3 -
 drivers/ide/ide-lib.c           |   96 ----------------------------------------
 drivers/ide/ide-pio-blacklist.c |   94 +++++++++++++++++++++++++++++++++++++++
 include/linux/ide.h             |    2 
 4 files changed, 98 insertions(+), 97 deletions(-)

Index: b/drivers/ide/Makefile
===================================================================
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -11,7 +11,8 @@
 
 EXTRA_CFLAGS				+= -Idrivers/ide
 
-ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o ide-taskfile.o
+ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o ide-taskfile.o \
+	      ide-pio-blacklist.o
 
 # core IDE code
 ide-core-$(CONFIG_IDE_TIMINGS)		+= ide-timings.o
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -75,102 +75,6 @@ static u8 ide_rate_filter(ide_drive_t *d
 	return min(speed, mode);
 }
 
-/*
- * Shared data/functions for determining best PIO mode for an IDE drive.
- * Most of this stuff originally lived in cmd640.c, and changes to the
- * ide_pio_blacklist[] table should be made with EXTREME CAUTION to avoid
- * breaking the fragile cmd640.c support.
- */
-
-/*
- * Black list. Some drives incorrectly report their maximal PIO mode,
- * at least in respect to CMD640. Here we keep info on some known drives.
- */
-static struct ide_pio_info {
-	const char	*name;
-	int		pio;
-} ide_pio_blacklist [] = {
-	{ "Conner Peripherals 540MB - CFS540A", 3 },
-
-	{ "WDC AC2700",  3 },
-	{ "WDC AC2540",  3 },
-	{ "WDC AC2420",  3 },
-	{ "WDC AC2340",  3 },
-	{ "WDC AC2250",  0 },
-	{ "WDC AC2200",  0 },
-	{ "WDC AC21200", 4 },
-	{ "WDC AC2120",  0 },
-	{ "WDC AC2850",  3 },
-	{ "WDC AC1270",  3 },
-	{ "WDC AC1170",  1 },
-	{ "WDC AC1210",  1 },
-	{ "WDC AC280",   0 },
-	{ "WDC AC31000", 3 },
-	{ "WDC AC31200", 3 },
-
-	{ "Maxtor 7131 AT", 1 },
-	{ "Maxtor 7171 AT", 1 },
-	{ "Maxtor 7213 AT", 1 },
-	{ "Maxtor 7245 AT", 1 },
-	{ "Maxtor 7345 AT", 1 },
-	{ "Maxtor 7546 AT", 3 },
-	{ "Maxtor 7540 AV", 3 },
-
-	{ "SAMSUNG SHD-3121A", 1 },
-	{ "SAMSUNG SHD-3122A", 1 },
-	{ "SAMSUNG SHD-3172A", 1 },
-
-	{ "ST5660A",  3 },
-	{ "ST3660A",  3 },
-	{ "ST3630A",  3 },
-	{ "ST3655A",  3 },
-	{ "ST3391A",  3 },
-	{ "ST3390A",  1 },
-	{ "ST3600A",  1 },
-	{ "ST3290A",  0 },
-	{ "ST3144A",  0 },
-	{ "ST3491A",  1 },	/* reports 3, should be 1 or 2 (depending on */	
-				/* drive) according to Seagates FIND-ATA program */
-
-	{ "QUANTUM ELS127A", 0 },
-	{ "QUANTUM ELS170A", 0 },
-	{ "QUANTUM LPS240A", 0 },
-	{ "QUANTUM LPS210A", 3 },
-	{ "QUANTUM LPS270A", 3 },
-	{ "QUANTUM LPS365A", 3 },
-	{ "QUANTUM LPS540A", 3 },
-	{ "QUANTUM LIGHTNING 540A", 3 },
-	{ "QUANTUM LIGHTNING 730A", 3 },
-
-        { "QUANTUM FIREBALL_540", 3 }, /* Older Quantum Fireballs don't work */
-        { "QUANTUM FIREBALL_640", 3 }, 
-        { "QUANTUM FIREBALL_1080", 3 },
-        { "QUANTUM FIREBALL_1280", 3 },
-	{ NULL,	0 }
-};
-
-/**
- *	ide_scan_pio_blacklist 	-	check for a blacklisted drive
- *	@model: Drive model string
- *
- *	This routine searches the ide_pio_blacklist for an entry
- *	matching the start/whole of the supplied model name.
- *
- *	Returns -1 if no match found.
- *	Otherwise returns the recommended PIO mode from ide_pio_blacklist[].
- */
-
-static int ide_scan_pio_blacklist (char *model)
-{
-	struct ide_pio_info *p;
-
-	for (p = ide_pio_blacklist; p->name != NULL; p++) {
-		if (strncmp(p->name, model, strlen(p->name)) == 0)
-			return p->pio;
-	}
-	return -1;
-}
-
 /**
  *	ide_get_best_pio_mode	-	get PIO mode from drive
  *	@drive: drive to consider
Index: b/drivers/ide/ide-pio-blacklist.c
===================================================================
--- /dev/null
+++ b/drivers/ide/ide-pio-blacklist.c
@@ -0,0 +1,94 @@
+/*
+ * PIO blacklist.  Some drives incorrectly report their maximal PIO mode,
+ * at least in respect to CMD640.  Here we keep info on some known drives.
+ *
+ * Changes to the ide_pio_blacklist[] should be made with EXTREME CAUTION
+ * to avoid breaking the fragile cmd640.c support.
+ */
+
+#include <linux/string.h>
+
+static struct ide_pio_info {
+	const char	*name;
+	int		pio;
+} ide_pio_blacklist [] = {
+	{ "Conner Peripherals 540MB - CFS540A", 3 },
+
+	{ "WDC AC2700",  3 },
+	{ "WDC AC2540",  3 },
+	{ "WDC AC2420",  3 },
+	{ "WDC AC2340",  3 },
+	{ "WDC AC2250",  0 },
+	{ "WDC AC2200",  0 },
+	{ "WDC AC21200", 4 },
+	{ "WDC AC2120",  0 },
+	{ "WDC AC2850",  3 },
+	{ "WDC AC1270",  3 },
+	{ "WDC AC1170",  1 },
+	{ "WDC AC1210",  1 },
+	{ "WDC AC280",   0 },
+	{ "WDC AC31000", 3 },
+	{ "WDC AC31200", 3 },
+
+	{ "Maxtor 7131 AT", 1 },
+	{ "Maxtor 7171 AT", 1 },
+	{ "Maxtor 7213 AT", 1 },
+	{ "Maxtor 7245 AT", 1 },
+	{ "Maxtor 7345 AT", 1 },
+	{ "Maxtor 7546 AT", 3 },
+	{ "Maxtor 7540 AV", 3 },
+
+	{ "SAMSUNG SHD-3121A", 1 },
+	{ "SAMSUNG SHD-3122A", 1 },
+	{ "SAMSUNG SHD-3172A", 1 },
+
+	{ "ST5660A",  3 },
+	{ "ST3660A",  3 },
+	{ "ST3630A",  3 },
+	{ "ST3655A",  3 },
+	{ "ST3391A",  3 },
+	{ "ST3390A",  1 },
+	{ "ST3600A",  1 },
+	{ "ST3290A",  0 },
+	{ "ST3144A",  0 },
+	{ "ST3491A",  1 }, /* reports 3, should be 1 or 2 (depending on drive)
+			      according to Seagate's FIND-ATA program */
+
+	{ "QUANTUM ELS127A", 0 },
+	{ "QUANTUM ELS170A", 0 },
+	{ "QUANTUM LPS240A", 0 },
+	{ "QUANTUM LPS210A", 3 },
+	{ "QUANTUM LPS270A", 3 },
+	{ "QUANTUM LPS365A", 3 },
+	{ "QUANTUM LPS540A", 3 },
+	{ "QUANTUM LIGHTNING 540A", 3 },
+	{ "QUANTUM LIGHTNING 730A", 3 },
+
+	{ "QUANTUM FIREBALL_540", 3 }, /* Older Quantum Fireballs don't work */
+	{ "QUANTUM FIREBALL_640", 3 },
+	{ "QUANTUM FIREBALL_1080", 3 },
+	{ "QUANTUM FIREBALL_1280", 3 },
+	{ NULL, 0 }
+};
+
+/**
+ *	ide_scan_pio_blacklist 	-	check for a blacklisted drive
+ *	@model: Drive model string
+ *
+ *	This routine searches the ide_pio_blacklist for an entry
+ *	matching the start/whole of the supplied model name.
+ *
+ *	Returns -1 if no match found.
+ *	Otherwise returns the recommended PIO mode from ide_pio_blacklist[].
+ */
+
+int ide_scan_pio_blacklist(char *model)
+{
+	struct ide_pio_info *p;
+
+	for (p = ide_pio_blacklist; p->name != NULL; p++) {
+		if (strncmp(p->name, model, strlen(p->name)) == 0)
+			return p->pio;
+	}
+	return -1;
+}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1290,6 +1290,8 @@ void ide_timing_merge(struct ide_timing 
 		      struct ide_timing *, unsigned int);
 int ide_timing_compute(ide_drive_t *, u8, struct ide_timing *, int, int);
 
+int ide_scan_pio_blacklist(char *);
+
 u8 ide_get_best_pio_mode(ide_drive_t *, u8, u8);
 
 int ide_set_pio_mode(ide_drive_t *, u8);
