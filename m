Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979Ab0ARRSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0ARRSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959Ab0ARRSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:18:48 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52797 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab0ARRSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:18:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vP1SF3icXCrbQOF0D+h322MOhcfWk8UZe5+nks+rpMlKH10Rkodo0qYT7S8+ge8xIL
         bHuOJmDFyAMXSXoHA0Hj+TcIlvwX+WBvYT0jL+C7h/MOOrrgZskw8KBXDEekbLD+DgUX
         +l5M0a7EybhK0g5Cvhi3PNqdqFvvq0JGNWIzc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:17:12 +0100
Message-Id: <20100118171712.14623.9408.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 23/64] pata_via: store UDMA masks in via_isa_bridges table
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_via: store UDMA masks in via_isa_bridges table

* store UDMA masks in via_isa_bridges[] and while at it make "flags"
  field to be u8 instead of u16

* convert the driver to use UDMA masks from via_isa_bridges[]

* remove no longer needed VIA_UDMA* defines

Make some minor documentation and CodingStyle fixes while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_via.c |  198 +++++++++++++++++++++++--------------------------
 1 file changed, 93 insertions(+), 105 deletions(-)

Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -22,6 +22,7 @@
  *	VIA VT8233c	-	UDMA100
  *	VIA VT8235	-	UDMA133
  *	VIA VT8237	-	UDMA133
+ *	VIA VT8237A	-	UDMA133
  *	VIA VT8237S	-	UDMA133
  *	VIA VT8251	-	UDMA133
  *
@@ -64,26 +65,15 @@
 #define DRV_NAME "pata_via"
 #define DRV_VERSION "0.3.4"
 
-/*
- *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
- *	driver.
- */
-
 enum {
-	VIA_UDMA	= 0x007,
-	VIA_UDMA_NONE	= 0x000,
-	VIA_UDMA_33	= 0x001,
-	VIA_UDMA_66	= 0x002,
-	VIA_UDMA_100	= 0x003,
-	VIA_UDMA_133	= 0x004,
-	VIA_BAD_PREQ	= 0x010, /* Crashes if PREQ# till DDACK# set */
-	VIA_BAD_CLK66	= 0x020, /* 66 MHz clock doesn't work correctly */
-	VIA_SET_FIFO	= 0x040, /* Needs to have FIFO split set */
-	VIA_NO_UNMASK	= 0x080, /* Doesn't work with IRQ unmasking on */
-	VIA_BAD_ID	= 0x100, /* Has wrong vendor ID (0x1107) */
-	VIA_BAD_AST	= 0x200, /* Don't touch Address Setup Timing */
-	VIA_NO_ENABLES	= 0x400, /* Has no enablebits */
-	VIA_SATA_PATA	= 0x800, /* SATA/PATA combined configuration */
+	VIA_BAD_PREQ	= 0x01, /* Crashes if PREQ# till DDACK# set */
+	VIA_BAD_CLK66	= 0x02, /* 66 MHz clock doesn't work correctly */
+	VIA_SET_FIFO	= 0x04, /* Needs to have FIFO split set */
+	VIA_NO_UNMASK	= 0x08, /* Doesn't work with IRQ unmasking on */
+	VIA_BAD_ID	= 0x10, /* Has wrong vendor ID (0x1107) */
+	VIA_BAD_AST	= 0x20, /* Don't touch Address Setup Timing */
+	VIA_NO_ENABLES	= 0x40, /* Has no enablebits */
+	VIA_SATA_PATA	= 0x80, /* SATA/PATA combined configuration */
 };
 
 enum {
@@ -99,40 +89,37 @@ static const struct via_isa_bridge {
 	u16 id;
 	u8 rev_min;
 	u8 rev_max;
-	u16 flags;
+	u8 udma_mask;
+	u8 flags;
 } via_isa_bridges[] = {
-	{ "vx855",	PCI_DEVICE_ID_VIA_VX855,    0x00, 0x2f,
-	  VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 |
-	VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f,
-	  VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
-	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0xff, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
-	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8233a",	PCI_DEVICE_ID_VIA_8233A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8233c",	PCI_DEVICE_ID_VIA_8233C_0,  0x00, 0x2f, VIA_UDMA_100 },
-	{ "vt8233",	PCI_DEVICE_ID_VIA_8233_0,   0x00, 0x2f, VIA_UDMA_100 },
-	{ "vt8231",	PCI_DEVICE_ID_VIA_8231,     0x00, 0x2f, VIA_UDMA_100 },
-	{ "vt82c686b",	PCI_DEVICE_ID_VIA_82C686,   0x40, 0x4f, VIA_UDMA_100 },
-	{ "vt82c686a",	PCI_DEVICE_ID_VIA_82C686,   0x10, 0x2f, VIA_UDMA_66 },
-	{ "vt82c686",	PCI_DEVICE_ID_VIA_82C686,   0x00, 0x0f, VIA_UDMA_33 | VIA_BAD_CLK66 },
-	{ "vt82c596b",	PCI_DEVICE_ID_VIA_82C596,   0x10, 0x2f, VIA_UDMA_66 },
-	{ "vt82c596a",	PCI_DEVICE_ID_VIA_82C596,   0x00, 0x0f, VIA_UDMA_33 | VIA_BAD_CLK66 },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x47, 0x4f, VIA_UDMA_33 | VIA_SET_FIFO },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x40, 0x46, VIA_UDMA_33 | VIA_SET_FIFO | VIA_BAD_PREQ },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x30, 0x3f, VIA_UDMA_33 | VIA_SET_FIFO },
-	{ "vt82c586a",	PCI_DEVICE_ID_VIA_82C586_0, 0x20, 0x2f, VIA_UDMA_33 | VIA_SET_FIFO },
-	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f, VIA_UDMA_NONE | VIA_SET_FIFO },
-	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f, VIA_UDMA_NONE | VIA_SET_FIFO | VIA_NO_UNMASK },
-	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f, VIA_UDMA_NONE | VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
-	{ "vtxxxx",	PCI_DEVICE_ID_VIA_ANON,    0x00, 0x2f,
-	  VIA_UDMA_133 | VIA_BAD_AST },
+	{ "vx855",	PCI_DEVICE_ID_VIA_VX855,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
+	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
+	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
+	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_NO_ENABLES },
+	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0xff, ATA_UDMA6, VIA_BAD_AST | VIA_NO_ENABLES },
+	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8233a",	PCI_DEVICE_ID_VIA_8233A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8233c",	PCI_DEVICE_ID_VIA_8233C_0,  0x00, 0x2f, ATA_UDMA5, },
+	{ "vt8233",	PCI_DEVICE_ID_VIA_8233_0,   0x00, 0x2f, ATA_UDMA5, },
+	{ "vt8231",	PCI_DEVICE_ID_VIA_8231,     0x00, 0x2f, ATA_UDMA5, },
+	{ "vt82c686b",	PCI_DEVICE_ID_VIA_82C686,   0x40, 0x4f, ATA_UDMA5, },
+	{ "vt82c686a",	PCI_DEVICE_ID_VIA_82C686,   0x10, 0x2f, ATA_UDMA4, },
+	{ "vt82c686",	PCI_DEVICE_ID_VIA_82C686,   0x00, 0x0f, ATA_UDMA2, VIA_BAD_CLK66 },
+	{ "vt82c596b",	PCI_DEVICE_ID_VIA_82C596,   0x10, 0x2f, ATA_UDMA4, },
+	{ "vt82c596a",	PCI_DEVICE_ID_VIA_82C596,   0x00, 0x0f, ATA_UDMA2, VIA_BAD_CLK66 },
+	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x47, 0x4f, ATA_UDMA2, VIA_SET_FIFO },
+	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x40, 0x46, ATA_UDMA2, VIA_SET_FIFO | VIA_BAD_PREQ },
+	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x30, 0x3f, ATA_UDMA2, VIA_SET_FIFO },
+	{ "vt82c586a",	PCI_DEVICE_ID_VIA_82C586_0, 0x20, 0x2f, ATA_UDMA2, VIA_SET_FIFO },
+	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f,      0x00, VIA_SET_FIFO },
+	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK },
+	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
+	{ "vtxxxx",	PCI_DEVICE_ID_VIA_ANON,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ NULL }
 };
 
@@ -191,10 +178,10 @@ static int via_cable_detect(struct ata_p
 		return ATA_CBL_SATA;
 
 	/* Early chips are 40 wire */
-	if ((config->flags & VIA_UDMA) < VIA_UDMA_66)
+	if (config->udma_mask < ATA_UDMA4)
 		return ATA_CBL_PATA40;
 	/* UDMA 66 chips have only drive side logic */
-	else if ((config->flags & VIA_UDMA) < VIA_UDMA_100)
+	else if (config->udma_mask < ATA_UDMA5)
 		return ATA_CBL_PATA_UNK;
 	/* UDMA 100 or later */
 	pci_read_config_dword(pdev, 0x50, &ata66);
@@ -233,7 +220,6 @@ static int via_pre_reset(struct ata_link
  *	@ap: ATA interface
  *	@adev: ATA device
  *	@mode: ATA mode being programmed
- *	@tdiv: Clocks per PCI clock
  *	@set_ast: Set to program address setup
  *	@udma_type: UDMA mode/format of registers
  *
@@ -244,17 +230,27 @@ static int via_pre_reset(struct ata_link
  *	on the two channels.
  */
 
-static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mode, int tdiv, int set_ast, int udma_type)
+static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev,
+			    int mode, int set_ast, int udma_type)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct ata_device *peer = ata_dev_pair(adev);
 	struct ata_timing t, p;
-	static int via_clock = 33333;	/* Bus clock in kHZ - ought to be tunable one day */
+	static int via_clock = 33333;	/* Bus clock in kHZ */
 	unsigned long T =  1000000000 / via_clock;
-	unsigned long UT = T/tdiv;
+	unsigned long UT = T;
 	int ut;
 	int offset = 3 - (2*ap->port_no) - adev->devno;
 
+	switch (udma_type) {
+	case ATA_UDMA4:
+		UT = T / 2; break;
+	case ATA_UDMA5:
+		UT = T / 3; break;
+	case ATA_UDMA6:
+		UT = T / 4; break;
+	}
+
 	/* Calculate the timing values we require */
 	ata_timing_compute(adev, mode, &t, T, UT);
 
@@ -284,22 +280,20 @@ static void via_do_set_mode(struct ata_p
 		((clamp_val(t.active, 1, 16) - 1) << 4) | (clamp_val(t.recover, 1, 16) - 1));
 
 	/* Load the UDMA bits according to type */
-	switch(udma_type) {
-		default:
-			/* BUG() ? */
-			/* fall through */
-		case 33:
-			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 5) - 2)) : 0x03;
-			break;
-		case 66:
-			ut = t.udma ? (0xe8 | (clamp_val(t.udma, 2, 9) - 2)) : 0x0f;
-			break;
-		case 100:
-			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
-			break;
-		case 133:
-			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
-			break;
+	switch (udma_type) {
+	case ATA_UDMA2:
+	default:
+		ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 5) - 2)) : 0x03;
+		break;
+	case ATA_UDMA4:
+		ut = t.udma ? (0xe8 | (clamp_val(t.udma, 2, 9) - 2)) : 0x0f;
+		break;
+	case ATA_UDMA5:
+		ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
+		break;
+	case ATA_UDMA6:
+		ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
+		break;
 	}
 
 	/* Set UDMA unless device is not UDMA capable */
@@ -325,22 +319,16 @@ static void via_set_piomode(struct ata_p
 {
 	const struct via_isa_bridge *config = ap->host->private_data;
 	int set_ast = (config->flags & VIA_BAD_AST) ? 0 : 1;
-	int mode = config->flags & VIA_UDMA;
-	static u8 tclock[5] = { 1, 1, 2, 3, 4 };
-	static u8 udma[5] = { 0, 33, 66, 100, 133 };
 
-	via_do_set_mode(ap, adev, adev->pio_mode, tclock[mode], set_ast, udma[mode]);
+	via_do_set_mode(ap, adev, adev->pio_mode, set_ast, config->udma_mask);
 }
 
 static void via_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	const struct via_isa_bridge *config = ap->host->private_data;
 	int set_ast = (config->flags & VIA_BAD_AST) ? 0 : 1;
-	int mode = config->flags & VIA_UDMA;
-	static u8 tclock[5] = { 1, 1, 2, 3, 4 };
-	static u8 udma[5] = { 0, 33, 66, 100, 133 };
 
-	via_do_set_mode(ap, adev, adev->dma_mode, tclock[mode], set_ast, udma[mode]);
+	via_do_set_mode(ap, adev, adev->dma_mode, set_ast, config->udma_mask);
 }
 
 /**
@@ -509,7 +497,7 @@ static void via_fixup(struct pci_dev *pd
 	/* Initialise the FIFO for the enabled channels. */
 	via_config_fifo(pdev, config->flags);
 
-	if ((config->flags & VIA_UDMA) == VIA_UDMA_66) {
+	if (config->udma_mask == ATA_UDMA4) {
 		/* The 66 MHz devices require we enable the clock */
 		pci_read_config_dword(pdev, 0x50, &timing);
 		timing |= 0x80008;
@@ -621,28 +609,28 @@ static int via_init_one(struct pci_dev *
 	}
 
 	/* Clock set up */
-	switch(config->flags & VIA_UDMA) {
-		case VIA_UDMA_NONE:
-			if (config->flags & VIA_NO_UNMASK)
-				ppi[0] = &via_mwdma_info_borked;
-			else
-				ppi[0] = &via_mwdma_info;
-			break;
-		case VIA_UDMA_33:
-			ppi[0] = &via_udma33_info;
-			break;
-		case VIA_UDMA_66:
-			ppi[0] = &via_udma66_info;
-			break;
-		case VIA_UDMA_100:
-			ppi[0] = &via_udma100_info;
-			break;
-		case VIA_UDMA_133:
-			ppi[0] = &via_udma133_info;
-			break;
-		default:
-			WARN_ON(1);
-			return -ENODEV;
+	switch (config->udma_mask) {
+	case 0x00:
+		if (config->flags & VIA_NO_UNMASK)
+			ppi[0] = &via_mwdma_info_borked;
+		else
+			ppi[0] = &via_mwdma_info;
+		break;
+	case ATA_UDMA2:
+		ppi[0] = &via_udma33_info;
+		break;
+	case ATA_UDMA4:
+		ppi[0] = &via_udma66_info;
+		break;
+	case ATA_UDMA5:
+		ppi[0] = &via_udma100_info;
+		break;
+	case ATA_UDMA6:
+		ppi[0] = &via_udma133_info;
+		break;
+	default:
+		WARN_ON(1);
+		return -ENODEV;
 	}
 
 	via_fixup(pdev, config);
