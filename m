Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096Ab0A2QLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab0A2QLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355Ab0A2QLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:11:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:60129 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab0A2QK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:10:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=RdJMTJvdfGDjV+K1unfeYZDoF2hEmZx8jCYbb9m1gyHZdRsKkzYswTd9eDvbbskGlJ
         rhnxounZ/xqHoloCl3Zdb4l81n2I8HK0nDWG5E+/LkPu7yX8mPc2EkTuiFj1oasb99Vu
         RWwqw0LlwsmReiq3s9JA5BgYCq9GdOGLUQO6c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:10:19 +0100
Message-Id: <20100129161019.21495.77643.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 67/68] pata_via: move code to be re-used by ide2libata to pata_via.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_via: move code to be re-used by ide2libata to pata_via.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_via.c |  237 -----------------------------------------------
 drivers/ata/pata_via.h |  242 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 242 insertions(+), 237 deletions(-)

Index: b/drivers/ata/pata_via.c
===================================================================
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -64,64 +64,6 @@
 #define DRV_NAME "pata_via"
 #define DRV_VERSION "0.3.4"
 
-enum {
-	VIA_BAD_PREQ	= 0x01, /* Crashes if PREQ# till DDACK# set */
-	VIA_BAD_CLK66	= 0x02, /* 66 MHz clock doesn't work correctly */
-	VIA_SET_FIFO	= 0x04, /* Needs to have FIFO split set */
-	VIA_NO_UNMASK	= 0x08, /* Doesn't work with IRQ unmasking on */
-	VIA_BAD_ID	= 0x10, /* Has wrong vendor ID (0x1107) */
-	VIA_BAD_AST	= 0x20, /* Don't touch Address Setup Timing */
-	VIA_NO_ENABLES	= 0x40, /* Has no enablebits */
-	VIA_SATA_PATA	= 0x80, /* SATA/PATA combined configuration */
-};
-
-enum {
-	VIA_IDFLAG_SINGLE = (1 << 0), /* single channel controller) */
-};
-
-/*
- * VIA SouthBridge chips.
- */
-
-static const struct via_isa_bridge {
-	const char *name;
-	u16 id;
-	u8 rev_min;
-	u8 rev_max;
-	u8 udma_mask;
-	u8 flags;
-} via_isa_bridges[] = {
-	{ "vx855",	PCI_DEVICE_ID_VIA_VX855,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_NO_ENABLES },
-	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0xff, ATA_UDMA6, VIA_BAD_AST | VIA_NO_ENABLES },
-	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8233a",	PCI_DEVICE_ID_VIA_8233A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ "vt8233c",	PCI_DEVICE_ID_VIA_8233C_0,  0x00, 0x2f, ATA_UDMA5, },
-	{ "vt8233",	PCI_DEVICE_ID_VIA_8233_0,   0x00, 0x2f, ATA_UDMA5, },
-	{ "vt8231",	PCI_DEVICE_ID_VIA_8231,     0x00, 0x2f, ATA_UDMA5, },
-	{ "vt82c686b",	PCI_DEVICE_ID_VIA_82C686,   0x40, 0x4f, ATA_UDMA5, },
-	{ "vt82c686a",	PCI_DEVICE_ID_VIA_82C686,   0x10, 0x2f, ATA_UDMA4, },
-	{ "vt82c686",	PCI_DEVICE_ID_VIA_82C686,   0x00, 0x0f, ATA_UDMA2, VIA_BAD_CLK66 },
-	{ "vt82c596b",	PCI_DEVICE_ID_VIA_82C596,   0x10, 0x2f, ATA_UDMA4, },
-	{ "vt82c596a",	PCI_DEVICE_ID_VIA_82C596,   0x00, 0x0f, ATA_UDMA2, VIA_BAD_CLK66 },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x47, 0x4f, ATA_UDMA2, VIA_SET_FIFO },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x40, 0x46, ATA_UDMA2, VIA_SET_FIFO | VIA_BAD_PREQ },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x30, 0x3f, ATA_UDMA2, VIA_SET_FIFO },
-	{ "vt82c586a",	PCI_DEVICE_ID_VIA_82C586_0, 0x20, 0x2f, ATA_UDMA2, VIA_SET_FIFO },
-	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f,      0x00, VIA_SET_FIFO },
-	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK },
-	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
-	{ "vtxxxx",	PCI_DEVICE_ID_VIA_ANON,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
-	{ NULL }
-};
-
 struct via_port {
 	u8 cached_device;
 };
@@ -188,108 +130,6 @@ static int via_pre_reset(struct ata_link
 	return ata_sff_prereset(link, deadline);
 }
 
-
-/**
- *	via_do_set_mode	-	set transfer mode data
- *	@ap: ATA interface
- *	@adev: ATA device
- *	@mode: ATA mode being programmed
- *	@set_ast: Set to program address setup
- *	@udma_type: UDMA mode/format of registers
- *
- *	Program the VIA registers for DMA and PIO modes. Uses the ata timing
- *	support in order to compute modes.
- *
- *	FIXME: Hotplug will require we serialize multiple mode changes
- *	on the two channels.
- */
-
-static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev,
-			    int mode, int set_ast, int udma_type)
-{
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	struct ata_device *peer = ata_dev_pair(adev);
-	struct ata_timing t, p;
-	static int via_clock = 33333;	/* Bus clock in kHZ */
-	unsigned long T =  1000000000 / via_clock;
-	unsigned long UT = T;
-	int ut;
-	int offset = 3 - (2*ap->port_no) - adev->devno;
-
-	switch (udma_type) {
-	case ATA_UDMA4:
-		UT = T / 2; break;
-	case ATA_UDMA5:
-		UT = T / 3; break;
-	case ATA_UDMA6:
-		UT = T / 4; break;
-	}
-
-	/* Calculate the timing values we require */
-	ata_timing_compute(adev->id, mode, adev->pio_mode, &t, T, UT);
-
-	/* We share 8bit timing so we must merge the constraints */
-	if (peer) {
-		if (peer->pio_mode) {
-			ata_timing_compute(peer->id, peer->pio_mode,
-					   peer->pio_mode, &p, T, UT);
-			ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
-		}
-	}
-
-	/* Address setup is programmable but breaks on UDMA133 setups */
-	if (set_ast) {
-		u8 setup;	/* 2 bits per drive */
-		int shift = 2 * offset;
-
-		pci_read_config_byte(pdev, 0x4C, &setup);
-		setup &= ~(3 << shift);
-		setup |= (clamp_val(t.setup, 1, 4) - 1) << shift;
-		pci_write_config_byte(pdev, 0x4C, setup);
-	}
-
-	/* Load the PIO mode bits */
-	pci_write_config_byte(pdev, 0x4F - ap->port_no,
-		((clamp_val(t.act8b, 1, 16) - 1) << 4) | (clamp_val(t.rec8b, 1, 16) - 1));
-	pci_write_config_byte(pdev, 0x48 + offset,
-		((clamp_val(t.active, 1, 16) - 1) << 4) | (clamp_val(t.recover, 1, 16) - 1));
-
-	/* Load the UDMA bits according to type */
-	switch (udma_type) {
-	case ATA_UDMA2:
-	default:
-		ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 5) - 2)) : 0x03;
-		break;
-	case ATA_UDMA4:
-		ut = t.udma ? (0xe8 | (clamp_val(t.udma, 2, 9) - 2)) : 0x0f;
-		break;
-	case ATA_UDMA5:
-		ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
-		break;
-	case ATA_UDMA6:
-		ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
-		break;
-	}
-
-	/* Set UDMA unless device is not UDMA capable */
-	if (udma_type) {
-		u8 udma_etc;
-
-		pci_read_config_byte(pdev, 0x50 + offset, &udma_etc);
-
-		/* clear transfer mode bit */
-		udma_etc &= ~0x20;
-
-		if (t.udma) {
-			/* preserve 80-wire cable detection bit */
-			udma_etc &= 0x10;
-			udma_etc |= ut;
-		}
-
-		pci_write_config_byte(pdev, 0x50 + offset, udma_etc);
-	}
-}
-
 static void via_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	const struct via_isa_bridge *config = ap->host->private_data;
@@ -431,83 +271,6 @@ static struct ata_port_operations via_po
 	.sff_data_xfer	= ata_sff_data_xfer_noirq,
 };
 
-static const struct via_isa_bridge *via_config_find(void)
-{
-	const struct via_isa_bridge *config;
-	struct pci_dev *isa;
-
-	for (config = via_isa_bridges; config->id != PCI_DEVICE_ID_VIA_ANON;
-	     config++) {
-		isa = pci_get_device(PCI_VENDOR_ID_VIA +
-			!!(config->flags & VIA_BAD_ID), config->id, NULL);
-		if (isa) {
-			u8 rev = isa->revision;
-
-			pci_dev_put(isa);
-
-			if (rev >= config->rev_min && rev <= config->rev_max)
-				break;
-		}
-	}
-
-	return config;
-}
-
-/**
- *	via_config_fifo		-	set up the FIFO
- *	@pdev: PCI device
- *	@flags: configuration flags
- *
- *	Set the FIFO properties for this device if necessary. Used both on
- *	set up and on and the resume path
- */
-
-static void via_config_fifo(struct pci_dev *pdev, unsigned int flags)
-{
-	u8 enable;
-
-	/* 0x40 low bits indicate enabled channels */
-	pci_read_config_byte(pdev, 0x40 , &enable);
-	enable &= 3;
-
-	if (flags & VIA_SET_FIFO) {
-		static const u8 fifo_setting[4] = {0x00, 0x60, 0x00, 0x20};
-		u8 fifo;
-
-		pci_read_config_byte(pdev, 0x43, &fifo);
-
-		/* Clear PREQ# until DDACK# for errata */
-		if (flags & VIA_BAD_PREQ)
-			fifo &= 0x7F;
-		else
-			fifo &= 0x9f;
-		/* Turn on FIFO for enabled channels */
-		fifo |= fifo_setting[enable];
-		pci_write_config_byte(pdev, 0x43, fifo);
-	}
-}
-
-static void via_fixup(struct pci_dev *pdev, const struct via_isa_bridge *config)
-{
-	u32 timing;
-
-	/* Initialise the FIFO for the enabled channels. */
-	via_config_fifo(pdev, config->flags);
-
-	if (config->udma_mask == ATA_UDMA4) {
-		/* The 66 MHz devices require we enable the clock */
-		pci_read_config_dword(pdev, 0x50, &timing);
-		timing |= 0x80008;
-		pci_write_config_dword(pdev, 0x50, timing);
-	}
-	if (config->flags & VIA_BAD_CLK66) {
-		/* Disable the 66MHz clock on problem devices */
-		pci_read_config_dword(pdev, 0x50, &timing);
-		timing &= ~0x80008;
-		pci_write_config_dword(pdev, 0x50, timing);
-	}
-}
-
 /**
  *	via_init_one		-	discovery callback
  *	@pdev: PCI device
Index: b/drivers/ata/pata_via.h
===================================================================
--- a/drivers/ata/pata_via.h
+++ b/drivers/ata/pata_via.h
@@ -1,4 +1,64 @@
 
+#ifdef __LINUX_LIBATA_H__
+enum {
+	VIA_BAD_PREQ	= 0x01, /* Crashes if PREQ# till DDACK# set */
+	VIA_BAD_CLK66	= 0x02, /* 66 MHz clock doesn't work correctly */
+	VIA_SET_FIFO	= 0x04, /* Needs to have FIFO split set */
+	VIA_NO_UNMASK	= 0x08, /* Doesn't work with IRQ unmasking on */
+	VIA_BAD_ID	= 0x10, /* Has wrong vendor ID (0x1107) */
+	VIA_BAD_AST	= 0x20, /* Don't touch Address Setup Timing */
+	VIA_NO_ENABLES	= 0x40, /* Has no enablebits */
+	VIA_SATA_PATA	= 0x80, /* SATA/PATA combined configuration */
+};
+
+enum {
+	VIA_IDFLAG_SINGLE = (1 << 0), /* single channel controller */
+};
+
+/*
+ * VIA SouthBridge chips.
+ */
+
+static const struct via_isa_bridge {
+	const char *name;
+	u16 id;
+	u8 rev_min;
+	u8 rev_max;
+	u8 udma_mask;
+	u8 flags;
+} via_isa_bridges[] = {
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
+	{ NULL }
+};
+#endif
+
 #include <linux/dmi.h>
 
 /*
@@ -27,3 +87,185 @@ static int via_cable_override(struct pci
 		return 1;
 	return 0;
 }
+
+#ifdef __LINUX_LIBATA_H__
+/**
+ *	via_do_set_mode	-	set transfer mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *	@mode: ATA mode being programmed
+ *	@set_ast: Set to program address setup
+ *	@udma_type: UDMA mode/format of registers
+ *
+ *	Program the VIA registers for DMA and PIO modes. Uses the ata timing
+ *	support in order to compute modes.
+ *
+ *	FIXME: Hotplug will require we serialize multiple mode changes
+ *	on the two channels.
+ */
+
+static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev,
+			    int mode, int set_ast, int udma_type)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	struct ata_device *peer = ata_dev_pair(adev);
+	struct ata_timing t, p;
+	static int via_clock = 33333;	/* Bus clock in kHZ */
+	unsigned long T =  1000000000 / via_clock;
+	unsigned long UT = T;
+	int ut;
+	int offset = 3 - (2*ap->port_no) - adev->devno;
+
+	switch (udma_type) {
+	case ATA_UDMA4:
+		UT = T / 2; break;
+	case ATA_UDMA5:
+		UT = T / 3; break;
+	case ATA_UDMA6:
+		UT = T / 4; break;
+	}
+
+	/* Calculate the timing values we require */
+	ata_timing_compute(adev->id, mode, adev->pio_mode, &t, T, UT);
+
+	/* We share 8bit timing so we must merge the constraints */
+	if (peer) {
+		if (peer->pio_mode) {
+			ata_timing_compute(peer->id, peer->pio_mode,
+					   peer->pio_mode, &p, T, UT);
+			ata_timing_merge(&p, &t, &t, ATA_TIMING_8BIT);
+		}
+	}
+
+	/* Address setup is programmable but breaks on UDMA133 setups */
+	if (set_ast) {
+		u8 setup;	/* 2 bits per drive */
+		int shift = 2 * offset;
+
+		pci_read_config_byte(pdev, 0x4C, &setup);
+		setup &= ~(3 << shift);
+		setup |= (clamp_val(t.setup, 1, 4) - 1) << shift;
+		pci_write_config_byte(pdev, 0x4C, setup);
+	}
+
+	/* Load the PIO mode bits */
+	pci_write_config_byte(pdev, 0x4F - ap->port_no,
+		((clamp_val(t.act8b, 1, 16) - 1) << 4) |
+		(clamp_val(t.rec8b, 1, 16) - 1));
+	pci_write_config_byte(pdev, 0x48 + offset,
+		((clamp_val(t.active, 1, 16) - 1) << 4) |
+		(clamp_val(t.recover, 1, 16) - 1));
+
+	/* Load the UDMA bits according to type */
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
+	}
+
+	/* Set UDMA unless device is not UDMA capable */
+	if (udma_type) {
+		u8 udma_etc;
+
+		pci_read_config_byte(pdev, 0x50 + offset, &udma_etc);
+
+		/* clear transfer mode bit */
+		udma_etc &= ~0x20;
+
+		if (t.udma) {
+			/* preserve 80-wire cable detection bit */
+			udma_etc &= 0x10;
+			udma_etc |= ut;
+		}
+
+		pci_write_config_byte(pdev, 0x50 + offset, udma_etc);
+	}
+}
+
+static const struct via_isa_bridge *via_config_find(void)
+{
+	const struct via_isa_bridge *config;
+	struct pci_dev *isa;
+
+	for (config = via_isa_bridges; config->id != PCI_DEVICE_ID_VIA_ANON;
+	     config++) {
+		isa = pci_get_device(PCI_VENDOR_ID_VIA +
+			!!(config->flags & VIA_BAD_ID), config->id, NULL);
+		if (isa) {
+			u8 rev = isa->revision;
+
+			pci_dev_put(isa);
+
+			if (rev >= config->rev_min && rev <= config->rev_max)
+				break;
+		}
+	}
+
+	return config;
+}
+
+/**
+ *	via_config_fifo		-	set up the FIFO
+ *	@pdev: PCI device
+ *	@flags: configuration flags
+ *
+ *	Set the FIFO properties for this device if necessary. Used both on
+ *	set up and on and the resume path
+ */
+
+static void via_config_fifo(struct pci_dev *pdev, unsigned int flags)
+{
+	u8 enable;
+
+	/* 0x40 low bits indicate enabled channels */
+	pci_read_config_byte(pdev, 0x40 , &enable);
+	enable &= 3;
+
+	if (flags & VIA_SET_FIFO) {
+		static const u8 fifo_setting[4] = {0x00, 0x60, 0x00, 0x20};
+		u8 fifo;
+
+		pci_read_config_byte(pdev, 0x43, &fifo);
+
+		/* Clear PREQ# until DDACK# for errata */
+		if (flags & VIA_BAD_PREQ)
+			fifo &= 0x7F;
+		else
+			fifo &= 0x9f;
+		/* Turn on FIFO for enabled channels */
+		fifo |= fifo_setting[enable];
+		pci_write_config_byte(pdev, 0x43, fifo);
+	}
+}
+
+static void via_fixup(struct pci_dev *pdev, const struct via_isa_bridge *config)
+{
+	u32 timing;
+
+	/* Initialise the FIFO for the enabled channels. */
+	via_config_fifo(pdev, config->flags);
+
+	if (config->udma_mask == ATA_UDMA4) {
+		/* The 66 MHz devices require we enable the clock */
+		pci_read_config_dword(pdev, 0x50, &timing);
+		timing |= 0x80008;
+		pci_write_config_dword(pdev, 0x50, timing);
+	}
+	if (config->flags & VIA_BAD_CLK66) {
+		/* Disable the 66MHz clock on problem devices */
+		pci_read_config_dword(pdev, 0x50, &timing);
+		timing &= ~0x80008;
+		pci_write_config_dword(pdev, 0x50, timing);
+	}
+}
+#endif
