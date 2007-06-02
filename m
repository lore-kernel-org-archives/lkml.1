Return-Path: <linux-kernel-owner+w=401wt.eu-S1762729AbXFBS7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762729AbXFBS7r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 14:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758733AbXFBS7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 14:59:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:5398 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896AbXFBS7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 14:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=nkkiOJunOks/flEOBqJ7OM21sDwXFXgeGqvQsFF2RqHeCX6e9eDA2JUhMq/9rP+GTE8giISKFL7XwAAouV9D2l2/rt06OEcqE1Wv6U6RsvkFRcElucl6upgq/RvJwfx8OmyAIdfBbGVhRXB50EVGX4AblMqBnjhIE666EOFvEIU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] serverworks: fix CSB6 tuning logic
Date: Sat, 2 Jun 2007 21:05:01 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706022105.01965.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Problem noticed by Joe Zbiciak, see

	http://kerneltrap.org/node/8252

for details.

On CSB6 the driver is using BIOS settings and not programming DMA/PIO timings
itself.  However the logic was completely broken and resulted in wrong timings
being silently allowed (instead of being corrected by the driver).

This bug would explain some data corruption/timeout issues with Serverworks
MegaIDE in RAID mode that Alan Cox has fixed recently with:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2074a106f52b6371885afbd714e929d60d0e3f64

For 2.6.23 we may be better off with completely switching the driver to always
programming timings (libata pata_serverworks.c driver is doing things this way
and there were no problems reported so far) but for 2.6.22 lets fix the bug
in the simplest and the least intrusive way.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/serverworks.c |   40 +++++++++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 13 deletions(-)

Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/serverworks.c		Version 0.10	Jun 2 2007
+ * linux/drivers/ide/pci/serverworks.c		Version 0.11	Jun 2 2007
  *
  * Copyright (C) 1998-2000 Michel Aubry
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
@@ -176,35 +176,49 @@ static int svwks_tune_chipset (ide_drive
 				return 0;
 			} else if ((dma_timing) &&
 				   ((dma_stat&(1<<(5+unit)))==(1<<(5+unit)))) {
-				u8 dmaspeed = dma_timing;
+				u8 dmaspeed;
 
-				if ((dmaspeed & 0x20) == 0x20)
+				switch (dma_timing & 0x77) {
+				case 0x20:
 					dmaspeed = XFER_MW_DMA_2;
-				else if ((dmaspeed & 0x21) == 0x21)
+					break;
+				case 0x21:
 					dmaspeed = XFER_MW_DMA_1;
-				else if ((dmaspeed & 0x77) == 0x77)
+					break;
+				case 0x77:
 					dmaspeed = XFER_MW_DMA_0;
-				else
+					break;
+				default:
 					goto dma_pio;
+				}
+
 				drive->current_speed = drive->init_speed = dmaspeed;
 				return 0;
 			}
 dma_pio:
 			if (pio_timing) {
-				u8 piospeed = pio_timing;
+				u8 piospeed;
 
-				if ((piospeed & 0x20) == 0x20)
+				switch (pio_timing & 0x7f) {
+				case 0x20:
 					piospeed = XFER_PIO_4;
-				else if ((piospeed & 0x22) == 0x22)
+					break;
+				case 0x22:
 					piospeed = XFER_PIO_3;
-				else if ((piospeed & 0x34) == 0x34)
+					break;
+				case 0x34:
 					piospeed = XFER_PIO_2;
-				else if ((piospeed & 0x47) == 0x47)
+					break;
+				case 0x47:
 					piospeed = XFER_PIO_1;
-				else if ((piospeed & 0x5d) == 0x5d)
+					break;
+				case 0x5d:
 					piospeed = XFER_PIO_0;
-				else
+					break;
+				default:
 					goto oem_setup_failed;
+				}
+
 				drive->current_speed = drive->init_speed = piospeed;
 				return 0;
 			}
