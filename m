Return-Path: <linux-kernel-owner+w=401wt.eu-S1763641AbXKPW4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763641AbXKPW4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757151AbXKPWz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:55:56 -0500
Received: from proxy3.bredband.net ([195.54.101.73]:36066 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbXKPWzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:55:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAM6uPUdV4pmXRmdsb2JhbAAMhyeHUAEBATc
Message-ID: <473E2049.4070806@purplescout.se>
Date: Fri, 16 Nov 2007 23:57:13 +0100
From: Jonas Stare <jonas.stare@purplescout.se>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-ide@vger.kernel.org
Subject: [PATCH] drivers/ide/ide-probe.c Skip ide_wait_not_busy on noprobe-disks.
  was: [PATCH][RESUBMIT] drivers/ide/ide-probe.c, kernel 2.6.23.1
References: <473434F1.50509@purplescout.se> <200711152159.23607.bzolnier@gmail.com> <473D88A5.306@purplescout.se> <200711162222.54847.bzolnier@gmail.com>
In-Reply-To: <200711162222.54847.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a problem in some hardware where the kernel will stall for
35 seconds waiting for disks that dont exist. This patch will skip
waiting for the BSY-bit on ide-drives to go away if you set
hdx=noprobe as a kernel option and the disk is not marked
as 'present' (like when you set the geometry by hand).

If no noprobe-option is set the code will work (more or less) as the 
original but if set the code will skip the ide_wait_not_busy() for that 
drive. Even if there would be a drive there and it is still BSY 
afterwards it should not matter since it isn't probed for later.

(The code also honors the MAX_DRIVES variable instead of assuming that 
there will be two harddrives on the bus.)


Signed-off-by: Jonas Stare <jonas.stare@purplescout.se>

diff -u linux-2.6.23.1-orig/drivers/ide/ide-probe.c linux-2.6.23.1/drivers/ide/ide-probe.c 
--- linux-2.6.23.1-orig/drivers/ide/ide-probe.c 2007-10-12 18:43:44.000000000 +0200
+++ linux-2.6.23.1/drivers/ide/ide-probe.c      2007-11-16 10:26:23.000000000 +0100
@@ -643,6 +643,7 @@
 static int wait_hwif_ready(ide_hwif_t *hwif)
 {
        int rc;
+       int unit;
 
        printk(KERN_DEBUG "Probing IDE interface %s...\n", hwif->name);
 
@@ -659,16 +660,25 @@
                return rc;
 
        /* Now make sure both master & slave are ready */
-       SELECT_DRIVE(&hwif->drives[0]);
-       hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
-       mdelay(2);
-       rc = ide_wait_not_busy(hwif, 35000);
-       if (rc)
-               return rc;
-       SELECT_DRIVE(&hwif->drives[1]);
-       hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
-       mdelay(2);
-       rc = ide_wait_not_busy(hwif, 35000);
+       for (unit = 0; unit < MAX_DRIVES; ++unit) {
+               /* Ignore disks that we will not probe for later. */
+               if (!hwif->drives[unit].noprobe ||
+                   hwif->drives[unit].present) {
+                       SELECT_DRIVE(&hwif->drives[unit]);
+                       hwif->OUTB(8, hwif->io_ports[IDE_CONTROL_OFFSET]);
+                       mdelay(2);
+                       rc = ide_wait_not_busy(hwif, 35000);
+                       if (rc) {
+                               /* Exit function with master reselected */
+                               if (unit != 0)
+                                       SELECT_DRIVE(&hwif->drives[0]);
+                               return rc;
+                       }
+               } else {
+                       printk(KERN_DEBUG "Skip ide_wait_not_busy for %s:%d\n",
+                               hwif->name, unit);
+               }
+       }
 
        /* Exit function with master reselected (let's be sane) */
        SELECT_DRIVE(&hwif->drives[0]);
