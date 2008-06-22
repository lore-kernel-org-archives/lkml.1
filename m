Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYFVRQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYFVRQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYFVRQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:16:06 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:22396 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYFVRQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=mmChVk1lbC7Km6JFyrryDm1tFIu6dyrSd1PZj/gSbnVrMlqHwV6Av1nLpCMSLm+ysB
         cS9OXLLNBCohmSSitUQUDbgm9bwwv39cNymq7dzuPe2KCEJ+khnkqXSnDeAN6yb4bGwM
         zPouAnHl1uNsHSdBwili4fD22QKuoYudHTSkU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] gayle: reserve memory resources at once
Date: Sun, 22 Jun 2008 19:16:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806221916.59751.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Reserve memory resources for all IDE ports at once by moving
  request_mem_region() out of 'for ()' loop and always defining
  GAYLE_IDEREG_SIZE to 0x2000.

* Keep memory resources even if no free IDE slots can be found
  (this driver is unloadable currently).

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/gayle.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

Index: b/drivers/ide/legacy/gayle.c
===================================================================
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -31,6 +31,8 @@
 #define GAYLE_BASE_4000	0xdd2020	/* A4000/A4000T */
 #define GAYLE_BASE_1200	0xda0000	/* A1200/A600 and E-Matrix 530 */
 
+#define GAYLE_IDEREG_SIZE	0x2000
+
     /*
      *  Offsets from one of the above bases
      */
@@ -56,13 +58,11 @@
 #define GAYLE_NUM_HWIFS		1
 #define GAYLE_NUM_PROBE_HWIFS	GAYLE_NUM_HWIFS
 #define GAYLE_HAS_CONTROL_REG	1
-#define GAYLE_IDEREG_SIZE	0x2000
 #else /* CONFIG_BLK_DEV_IDEDOUBLER */
 #define GAYLE_NUM_HWIFS		2
 #define GAYLE_NUM_PROBE_HWIFS	(ide_doubler ? GAYLE_NUM_HWIFS : \
 					       GAYLE_NUM_HWIFS-1)
 #define GAYLE_HAS_CONTROL_REG	(!ide_doubler)
-#define GAYLE_IDEREG_SIZE	(ide_doubler ? 0x1000 : 0x2000)
 
 static int ide_doubler;
 module_param_named(doubler, ide_doubler, bool, 0);
@@ -124,6 +124,9 @@ static void __init gayle_setup_ports(hw_
 
 static int __init gayle_init(void)
 {
+    unsigned long phys_base, res_start, res_n;
+    unsigned long base, ctrlport, irqport;
+    ide_ack_intr_t *ack_intr;
     int a4000, i;
     hw_regs_t hw[GAYLE_NUM_HWIFS], *hws[] = { NULL, NULL, NULL, NULL };
     u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
@@ -149,12 +152,6 @@ found:
 #endif
 			 "");
 
-    for (i = 0; i < GAYLE_NUM_PROBE_HWIFS; i++) {
-	unsigned long base, ctrlport, irqport;
-	ide_ack_intr_t *ack_intr;
-	ide_hwif_t *hwif;
-	unsigned long phys_base, res_start, res_n;
-
 	if (a4000) {
 	    phys_base = GAYLE_BASE_4000;
 	    irqport = (unsigned long)ZTWO_VADDR(GAYLE_IRQ_4000);
@@ -168,15 +165,16 @@ found:
  * FIXME: we now have selectable modes between mmio v/s iomio
  */
 
-	phys_base += i*GAYLE_NEXT_PORT;
-
 	res_start = ((unsigned long)phys_base) & ~(GAYLE_NEXT_PORT-1);
 	res_n = GAYLE_IDEREG_SIZE;
 
 	if (!request_mem_region(res_start, res_n, "IDE"))
-	    continue;
+		return -EBUSY;
 
-	base = (unsigned long)ZTWO_VADDR(phys_base);
+    for (i = 0; i < GAYLE_NUM_PROBE_HWIFS; i++) {
+	ide_hwif_t *hwif;
+
+	base = (unsigned long)ZTWO_VADDR(phys_base + i * GAYLE_NEXT_PORT);
 	ctrlport = GAYLE_HAS_CONTROL_REG ? (base + GAYLE_CONTROL) : 0;
 
 	gayle_setup_ports(&hw[i], base, ctrlport, irqport, ack_intr);
@@ -187,8 +185,7 @@ found:
 
 	    hws[i] = &hw[i];
 	    idx[i] = hwif->index;
-	} else
-	    release_mem_region(res_start, res_n);
+	}
     }
 
     ide_device_add(idx, NULL, hws);
