Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbYFJPFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbYFJPFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYFJPFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:05:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54952 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751685AbYFJPFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:05:05 -0400
Date: Tue, 10 Jun 2008 15:48:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] pata_amd: (TEST) See if the ATAPI reports of problems are
 related to the FIFO
Message-ID: <20080610154829.6f2cec75@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please try the following if you are still seeing problems with the AMD PATA and
ATAPI devices (CD/DVD etc).

From: Alan Cox <alan@redhat.com>

The AMD documentation says the FIFO is only valid when we have 32bit wide transfers
running. That is not reliably the case with ATAPI. As we get some people reporting
problems with ATAPI on this controller lets see if this cures it.

I've not touched the Nvidia side. We have no documentation for nVidia stuff as
usual so if they need FIFO management someone from nVidia will just have to
fix it...

Alan
---

 drivers/ata/pata_amd.c |   77 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 58 insertions(+), 19 deletions(-)


diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 57dd00f..5588ba9 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_amd"
-#define DRV_VERSION "0.3.10"
+#define DRV_VERSION "0.4.1"
 
 /**
  *	timing_setup		-	shared timing computation and load
@@ -34,14 +34,18 @@
  *	@offset: port offset
  *	@speed: target speed
  *	@clock: clock multiplier (number of times 33MHz for this part)
+ *	@fifo: true if we can touch the FIFO
  *
  *	Perform the actual timing set up for Nvidia or AMD PATA devices.
  *	The actual devices vary so they all call into this helper function
  *	providing the clock multipler and offset (because AMD and Nvidia put
  *	the ports at different locations).
+ *
+ *	FIXME: We could share a lot of this logic with the VIA driver.
  */
 
-static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offset, int speed, int clock)
+static void timing_setup(struct ata_port *ap, struct ata_device *adev,
+				int offset, int speed, int clock, int fifo)
 {
 	static const unsigned char amd_cyc2udma[] = {
 		6, 6, 5, 4, 0, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 7
@@ -54,6 +58,8 @@ static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offse
 	int T, UT;
 	const int amd_clock = 33333;	/* KHz. */
 	u8 t;
+	u8 ccr;
+	int drive = (3 - dn);
 
 	T = 1000000000 / amd_clock;
 	UT = T;
@@ -84,15 +90,15 @@ static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offse
 
 	/* Configure the address set up timing */
 	pci_read_config_byte(pdev, offset + 0x0C, &t);
-	t = (t & ~(3 << ((3 - dn) << 1))) | ((clamp_val(at.setup, 1, 4) - 1) << ((3 - dn) << 1));
+	t = (t & ~(3 << (drive << 1))) | ((clamp_val(at.setup, 1, 4) - 1) << (drive << 1));
 	pci_write_config_byte(pdev, offset + 0x0C , t);
 
 	/* Configure the 8bit I/O timing */
-	pci_write_config_byte(pdev, offset + 0x0E + (1 - (dn >> 1)),
+	pci_write_config_byte(pdev, offset + 0x0F - ap->port_no,
 		((clamp_val(at.act8b, 1, 16) - 1) << 4) | (clamp_val(at.rec8b, 1, 16) - 1));
 
 	/* Drive timing */
-	pci_write_config_byte(pdev, offset + 0x08 + (3 - dn),
+	pci_write_config_byte(pdev, offset + 0x08 + drive,
 		((clamp_val(at.active, 1, 16) - 1) << 4) | (clamp_val(at.recover, 1, 16) - 1));
 
 	switch (clock) {
@@ -118,7 +124,20 @@ static void timing_setup(struct ata_port *ap, struct ata_device *adev, int offse
 
 	/* UDMA timing */
 	if (at.udma)
-		pci_write_config_byte(pdev, offset + 0x10 + (3 - dn), t);
+		pci_write_config_byte(pdev, offset + 0x10 + drive, t);
+	
+	if (fifo) {
+		/* Disable the FIFO in ATAPI mode as it only works for
+		   32bit wide transfer blocks */
+		int bit = ap->port_no ? 0x10: 0x40;
+		pci_read_config_byte(pdev, offset + 0x01, &ccr);
+		ccr &= ~bit;
+		if (adev->class == ATA_DEV_ATA &&
+			(peer == NULL || peer->class == ATA_DEV_ATA))
+			ccr |= bit;
+		pci_write_config_byte(pdev, offset + 0x01, ccr);
+		
+	}
 }
 
 /**
@@ -168,22 +187,28 @@ static int amd_cable_detect(struct ata_port *ap)
 
 static void amd33_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x40, adev->pio_mode, 1);
+	timing_setup(ap, adev, 0x40, adev->pio_mode, 1, 1);
 }
 
 static void amd66_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x40, adev->pio_mode, 2);
+	timing_setup(ap, adev, 0x40, adev->pio_mode, 2, 1);
 }
 
 static void amd100_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x40, adev->pio_mode, 3);
+	timing_setup(ap, adev, 0x40, adev->pio_mode, 3, 1);
+}
+
+static void amd100_set_piomode_nofifo(struct ata_port *ap,
+						struct ata_device *adev)
+{
+	timing_setup(ap, adev, 0x40, adev->pio_mode, 3, 0);
 }
 
 static void amd133_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x40, adev->pio_mode, 4);
+	timing_setup(ap, adev, 0x40, adev->pio_mode, 4, 1);
 }
 
 /**
@@ -197,22 +222,28 @@ static void amd133_set_piomode(struct ata_port *ap, struct ata_device *adev)
 
 static void amd33_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x40, adev->dma_mode, 1);
+	timing_setup(ap, adev, 0x40, adev->dma_mode, 1, 1);
 }
 
 static void amd66_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x40, adev->dma_mode, 2);
+	timing_setup(ap, adev, 0x40, adev->dma_mode, 2, 1);
 }
 
 static void amd100_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x40, adev->dma_mode, 3);
+	timing_setup(ap, adev, 0x40, adev->dma_mode, 3, 1);
+}
+
+static void amd100_set_dmamode_nofifo(struct ata_port *ap,
+						struct ata_device *adev)
+{
+	timing_setup(ap, adev, 0x40, adev->dma_mode, 3, 0);
 }
 
 static void amd133_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x40, adev->dma_mode, 4);
+	timing_setup(ap, adev, 0x40, adev->dma_mode, 4, 1);
 }
 
 /* Both host-side and drive-side detection results are worthless on NV
@@ -306,12 +337,12 @@ static int nv_pre_reset(struct ata_link *link, unsigned long deadline)
 
 static void nv100_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x50, adev->pio_mode, 3);
+	timing_setup(ap, adev, 0x50, adev->pio_mode, 3, 0);
 }
 
 static void nv133_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x50, adev->pio_mode, 4);
+	timing_setup(ap, adev, 0x50, adev->pio_mode, 4, 0);
 }
 
 /**
@@ -325,12 +356,13 @@ static void nv133_set_piomode(struct ata_port *ap, struct ata_device *adev)
 
 static void nv100_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x50, adev->dma_mode, 3);
+	timing_setup(ap, adev, 0x50, adev->dma_mode, 3, 0
+	);
 }
 
 static void nv133_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	timing_setup(ap, adev, 0x50, adev->dma_mode, 4);
+	timing_setup(ap, adev, 0x50, adev->dma_mode, 4, 0);
 }
 
 static void nv_host_stop(struct ata_host *host)
@@ -371,6 +403,13 @@ static struct ata_port_operations amd100_port_ops = {
 	.set_dmamode	= amd100_set_dmamode,
 };
 
+static struct ata_port_operations amd100_port_nofifo_ops = {
+	.inherits	= &amd_base_port_ops,
+	.cable_detect	= ata_cable_unknown,
+	.set_piomode	= amd100_set_piomode_nofifo,
+	.set_dmamode	= amd100_set_dmamode_nofifo,
+};
+
 static struct ata_port_operations amd133_port_ops = {
 	.inherits	= &amd_base_port_ops,
 	.cable_detect	= amd_cable_detect,
@@ -427,7 +466,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.pio_mask = 0x1f,
 			.mwdma_mask = 0x07,
 			.udma_mask = ATA_UDMA5,	/* UDMA 100 */
-			.port_ops = &amd100_port_ops
+			.port_ops = &amd100_port_nofifo_ops
 		},
 		{	/* 4: AMD 7441 */
 			.flags = ATA_FLAG_SLAVE_POSS,
