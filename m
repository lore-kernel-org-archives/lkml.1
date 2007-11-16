Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbXKPMaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbXKPMaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 07:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbXKPMaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 07:30:00 -0500
Received: from proxy2.bredband.net ([195.54.101.72]:47687 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXKPM37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 07:29:59 -0500
X-Greylist: delayed 1237 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2007 07:29:58 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HACoXPUdV4pmXRmdsb2JhbAAMjnUBAQE3
Message-ID: <473D88A5.306@purplescout.se>
Date: Fri, 16 Nov 2007 13:10:13 +0100
From: Jonas Stare <jonas.stare@purplescout.se>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH][RESUBMIT] drivers/ide/ide-probe.c, kernel 2.6.23.1
References: <473434F1.50509@purplescout.se> <200711132303.28424.bzolnier@gmail.com> <473C08B2.1030004@purplescout.se> <200711152159.23607.bzolnier@gmail.com>
In-Reply-To: <200711152159.23607.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmit of IDE-probing-patch. It now checks hwif->drives[unit].present instead of
forced_geom and there is also an if-statement so it doesn't change back to the master
unless it have to. I choose to put it inside the if-statement that checks the return
code from ide_wait_not_busy, since it shouldn't revert back to the master drive unless
something is wrong and we have to leave the function. (I also left the old SELECT_DRIVE
after the for-loop so that we will select the master if everything is ok.) Inside the
if-statement or not makes not big difference until you get more than two drives on the
ide-bus...but this code should be ready for it. :)

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

