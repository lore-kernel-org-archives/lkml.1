Return-Path: <linux-kernel-owner+w=401wt.eu-S1765392AbXEYTo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765392AbXEYTo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbXEYToK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:44:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33562 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754172AbXEYToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:44:09 -0400
Date: Fri, 25 May 2007 20:48:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jeff@garzik.org, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_hpt37x: Further improvements based on the IDE updates
 and vendor drivers
Message-ID: <20070525204855.4d72b9a4@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Better DPLL use and calibration


Signed-off-by: Alan Cox <alan@redhat.com>


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc2-mm1/drivers/ata/pata_hpt37x.c linux-2.6.22-rc2-mm1/drivers/ata/pata_hpt37x.c
--- linux.vanilla-2.6.22-rc2-mm1/drivers/ata/pata_hpt37x.c	2007-05-25 17:39:06.000000000 +0100
+++ linux-2.6.22-rc2-mm1/drivers/ata/pata_hpt37x.c	2007-05-25 18:20:38.000000000 +0100
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.5"
+#define DRV_VERSION	"0.6.6"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -931,15 +931,6 @@
 		.udma_mask = 0x7f,
 		.port_ops = &hpt372_port_ops
 	};
-	/* HPT371, 372 and friends - UDMA100 at 50MHz clock */
-	static const struct ata_port_info info_hpt372_50 = {
-		.sht = &hpt37x_sht,
-		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
-		.pio_mask = 0x1f,
-		.mwdma_mask = 0x07,
-		.udma_mask = 0x3f,
-		.port_ops = &hpt372_port_ops
-	};
 	/* HPT374 - UDMA133 */
 	static const struct ata_port_info info_hpt374 = {
 		.sht = &hpt37x_sht,
@@ -1098,17 +1089,21 @@
 		 *	use a 50MHz DPLL by choice
 		 */
 		unsigned int f_low, f_high;
-		int adjust;
+		int dpll, adjust;
 
-		clock_slot = 2;
+		/* Compute DPLL */
+		dpll = 2;
 		if (port->udma_mask & 0xE0)
-			clock_slot = 3;
+			dpll = 3;
 
-		f_low = (MHz[clock_slot] * chip_table->base) / 192;
+		f_low = (MHz[clock_slot] * 48) / MHz[dpll];
 		f_high = f_low + 2;
+		if (clock_slot > 1)
+			f_high += 2;
 
 		/* Select the DPLL clock. */
 		pci_write_config_byte(dev, 0x5b, 0x21);
+		pci_write_config_dword(dev, 0x5C, (f_high << 16) | f_low);
 
 		for(adjust = 0; adjust < 8; adjust++) {
 			if (hpt37x_calibrate_dpll(dev))
@@ -1124,12 +1119,12 @@
 			printk(KERN_WARNING "hpt37x: DPLL did not stabilize.\n");
 			return -ENODEV;
 		}
-		if (clock_slot == 3)
+		if (dpll == 3)
 			private_data = (void *)hpt37x_timings_66;
 		else
 			private_data = (void *)hpt37x_timings_50;
 
-		printk(KERN_INFO "hpt37x: Bus clock %dMHz, using DPLL.\n", MHz[clock_slot]);
+		printk(KERN_INFO "hpt37x: Bus clock %dMHz, using DPLL.\n", MHz[dpll]);
 	} else {
 		private_data = (void *)chip_table->clocks[clock_slot];
 		/*
