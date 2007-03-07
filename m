Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbXCGPjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbXCGPjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXCGPjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:39:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55648 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbXCGPjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:39:13 -0500
Date: Wed, 7 Mar 2007 16:43:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] pata_cmd640: Multiple updates
Message-ID: <20070307164329.752993ff@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add suspend/resume support
Write 0x5B to 0 not 0x5C

The former is important as we must kill the FIFO on a resume

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2-mm2/drivers/ata/pata_cmd640.c linux-2.6.21-rc2-mm2/drivers/ata/pata_cmd640.c
--- linux.vanilla-2.6.21-rc2-mm2/drivers/ata/pata_cmd640.c	2007-03-06 23:09:46.000000000 +0000
+++ linux-2.6.21-rc2-mm2/drivers/ata/pata_cmd640.c	2007-03-06 23:52:21.000000000 +0000
@@ -23,7 +23,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cmd640"
-#define DRV_VERSION "0.0.3"
+#define DRV_VERSION "0.0.5"
 
 struct cmd640_reg {
 	int last;
@@ -43,6 +43,7 @@
 
 /**
  *	cmd640_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA port
  *	@adev: ATA device
  *
  *	Called to do the PIO mode setup.
@@ -106,7 +107,7 @@
 		pci_write_config_byte(pdev, arttim + 1, (t.active << 4) | t.recover);
 	} else {
 		/* Save the shared timings for channel, they will be loaded
-		   by qc_issue_prot. Reloading the setup time is expensive
+		   by qc_issue_prot. Reloading the setup time is expensive 
 		   so we keep a merged one loaded */
 		pci_read_config_byte(pdev, ARTIM23, &reg);
 		reg &= 0x3F;
@@ -219,30 +220,21 @@
 	.port_start	= cmd640_port_start,
 };
 
-static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
+static void cmd640_hardware_init(struct pci_dev *pdev)
 {
 	u8 r;
 	u8 ctrl;
 
-	static struct ata_port_info info = {
-		.sht = &cmd640_sht,
-		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
-		.pio_mask = 0x1f,
-		.port_ops = &cmd640_port_ops
-	};
-
-	static struct ata_port_info *port_info[2] = { &info, &info };
-
 	/* CMD640 detected, commiserations */
-	pci_write_config_byte(pdev, 0x5C, 0x00);
+	pci_write_config_byte(pdev, 0x5B, 0x00);
 	/* Get version info */
 	pci_read_config_byte(pdev, CFR, &r);
 	/* PIO0 command cycles */
 	pci_write_config_byte(pdev, CMDTIM, 0);
 	/* 512 byte bursts (sector) */
 	pci_write_config_byte(pdev, BRST, 0x40);
-	/*
-	 * A reporter a long time ago
+	/* 
+	 * A reporter a long time ago
 	 * Had problems with the data fifo
 	 * So don't run the risk
 	 * Of putting crap on the disk
@@ -255,12 +247,26 @@
 	pci_read_config_byte(pdev, ARTIM23, &ctrl);
 	ctrl |= 0x0C;
 	pci_write_config_byte(pdev, ARTIM23, ctrl);
+}
+
+static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	static struct ata_port_info info = {
+		.sht = &cmd640_sht,
+		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.pio_mask = 0x1f,
+		.port_ops = &cmd640_port_ops
+	};
+
+	static struct ata_port_info *port_info[2] = { &info, &info };
 
+	cmd640_hardware_init(pdev);
 	return ata_pci_init_one(pdev, port_info, 2);
 }
 
 static int cmd640_reinit_one(struct pci_dev *pdev)
 {
+	cmd640_hardware_init(pdev);
 	return ata_pci_device_resume(pdev);
 }
 
