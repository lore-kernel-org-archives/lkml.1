Return-Path: <linux-kernel-owner+w=401wt.eu-S1761624AbXGXOLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761624AbXGXOLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757522AbXGXOLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:11:37 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43024 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756522AbXGXOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:11:36 -0400
Date: Tue, 24 Jul 2007 15:17:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jeff@garzik.org
Subject: [PATCH] pata_hpt37x: Fix 2.6.22 clock PLL regression
Message-ID: <20070724151748.7e99f4f0@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


	Just one version of Linux ago
	The PLL code broke - oh no!
	But set the right mode
	And fix up the code
	Makes the PLL timing sync go

Closes-bug: #8791
Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1/drivers/ata/pata_hpt37x.c linux-2.6.23rc1/drivers/ata/pata_hpt37x.c
--- linux.vanilla-2.6.23rc1/drivers/ata/pata_hpt37x.c	2007-07-23 12:56:11.000000000 +0100
+++ linux-2.6.23rc1/drivers/ata/pata_hpt37x.c	2007-07-23 14:44:39.000000000 +0100
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.6"
+#define DRV_VERSION	"0.6.7"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -1103,17 +1103,17 @@
 
 		/* Select the DPLL clock. */
 		pci_write_config_byte(dev, 0x5b, 0x21);
-		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
+		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
 
 		for(adjust = 0; adjust < 8; adjust++) {
 			if (hpt37x_calibrate_dpll(dev))
 				break;
 			/* See if it'll settle at a fractionally different clock */
-			if ((adjust & 3) == 3) {
-				f_low --;
-				f_high ++;
-			}
-			pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
+			if (adjust & 1)
+				f_low -= adjust >> 1;
+			else
+				f_high += adjust >> 1;
+			pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low | 0x100);
 		}
 		if (adjust == 8) {
 			printk(KERN_WARNING "hpt37x: DPLL did not stabilize.\n");
