Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYFMV3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYFMV3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 17:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYFMV3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 17:29:16 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:39858 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754134AbYFMV3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 17:29:15 -0400
Date: Fri, 13 Jun 2008 22:29:13 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: [PATCH 1/2] PCI: ROM access changes to support PCI 2.1 VPD
Message-ID: <20080613212913.GA11300@solarflare.com>
References: <cover.1213391292.git.bhutchings@solarflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1213391292.git.bhutchings@solarflare.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move body of ROM image sizing loop into a separate function so it can be
reused for finding VPD.

Move first part of pci_map_rom() into a separate function for use when
reading VPD.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
 drivers/pci/rom.c |  107 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 66 insertions(+), 41 deletions(-)

diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
index bd5c0e0..94d2afd 100644
--- a/drivers/pci/rom.c
+++ b/drivers/pci/rom.c
@@ -54,59 +54,65 @@ static void pci_disable_rom(struct pci_dev *pdev)
 }
 
 /**
- * pci_get_rom_size - obtain the actual size of the ROM image
- * @rom: kernel virtual pointer to image of ROM
+ * pci_get_rom_image_size - obtain the actual size of a ROM image
+ * @rom: kernel virtual pointer to ROM
  * @size: size of PCI window
- *  return: size of actual ROM image
+ * @image: kernel virtual pointer to image
+ * @last: pointer to return flag for whether this is the last image
+ *  return: size of image, or 0 if image is invalid
  *
  * Determine the actual length of the ROM image.
+ */
+static size_t pci_get_rom_image_size(void __iomem *rom, size_t size,
+				     void __iomem *image, bool *last)
+{
+	void __iomem *pds;
+	size_t image_size;
+
+	/* Standard PCI ROMs start out with these bytes 55 AA */
+	if (readb(image) != 0x55 || readb(image + 1) != 0xAA)
+		goto invalid;
+
+	/* get the PCI data structure and check its signature */
+	pds = image + readw(image + 24);
+	if (readb(pds) != 'P' || readb(pds + 1) != 'C' ||
+	    readb(pds + 2) != 'I' || readb(pds + 3) != 'R')
+		goto invalid;
+
+	image_size = readw(pds + 16) * 512;
+	*last = !!(readb(pds + 21) & 0x80);
+
+	/* Check that the size does not extend outside the PCI window */
+	return min_t(size_t, image_size, rom + size - image);
+
+invalid:
+	*last = true;
+	return 0;
+}
+
+/**
+ * pci_get_rom_size - obtain the total size of the ROM images
+ * @rom: kernel virtual pointer to ROM
+ * @size: size of PCI window
+ *  return: size of actual ROM images
+ *
+ * Determine the actual length of the ROM images.
  * The PCI window size could be much larger than the
  * actual image size.
  */
 size_t pci_get_rom_size(void __iomem *rom, size_t size)
 {
 	void __iomem *image;
-	int last_image;
+	bool last;
 
 	image = rom;
-	do {
-		void __iomem *pds;
-		/* Standard PCI ROMs start out with these bytes 55 AA */
-		if (readb(image) != 0x55)
-			break;
-		if (readb(image + 1) != 0xAA)
-			break;
-		/* get the PCI data structure and check its signature */
-		pds = image + readw(image + 24);
-		if (readb(pds) != 'P')
-			break;
-		if (readb(pds + 1) != 'C')
-			break;
-		if (readb(pds + 2) != 'I')
-			break;
-		if (readb(pds + 3) != 'R')
-			break;
-		last_image = readb(pds + 21) & 0x80;
-		/* this length is reliable */
-		image += readw(pds + 16) * 512;
-	} while (!last_image);
-
-	/* never return a size larger than the PCI resource window */
-	/* there are known ROMs that get the size wrong */
-	return min((size_t)(image - rom), size);
+	do
+		image += pci_get_rom_image_size(rom, size, image, &last);
+	while (!last);
+	return image - rom;
 }
 
-/**
- * pci_map_rom - map a PCI ROM to kernel space
- * @pdev: pointer to pci device struct
- * @size: pointer to receive size of pci window over ROM
- * @return: kernel virtual pointer to image of ROM
- *
- * Map a PCI ROM into kernel space. If ROM is boot video ROM,
- * the shadow BIOS copy will be returned instead of the
- * actual ROM.
- */
-void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
+static void __iomem *__pci_map_rom(struct pci_dev *pdev, size_t *size)
 {
 	struct resource *res = &pdev->resource[PCI_ROM_RESOURCE];
 	loff_t start;
@@ -150,9 +156,28 @@ void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
 				    IORESOURCE_ROM_SHADOW |
 				    IORESOURCE_ROM_COPY)))
 			pci_disable_rom(pdev);
-		return NULL;
 	}
 
+	return rom;
+}
+
+/**
+ * pci_map_rom - map a PCI ROM to kernel space
+ * @pdev: pointer to pci device struct
+ * @size: pointer to receive size of pci window over ROM
+ * @return: kernel virtual pointer to image of ROM
+ *
+ * Map a PCI ROM into kernel space. If ROM is boot video ROM,
+ * the shadow BIOS copy will be returned instead of the
+ * actual ROM.
+ */
+void __iomem *pci_map_rom(struct pci_dev *pdev, size_t *size)
+{
+	void __iomem *rom = __pci_map_rom(pdev, size);
+
+	if (!rom)
+		return NULL;
+
 	/*
 	 * Try to find the true size of the ROM since sometimes the PCI window
 	 * size is much larger than the actual size of the ROM.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
