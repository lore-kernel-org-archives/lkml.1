Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbZJGWmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbZJGWmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbZJGWmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:42:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44054 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbZJGWmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:42:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Oct 2009 00:41:59 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 6/8] firewire: optimize config ROM creation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.27888275592fd267@s5r6.in-berlin.de>
Message-ID: <tkrat.fcd31a82d098c6bb@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config ROM image of the local node was created in CPU byte order,
then a temporary big endian copy was created to compute the CRC, and
finally the card driver created its own big endian copy.

We now generate it in big endian byte order in the first place to avoid
one byte order conversion and the temporary on-stack copy of the ROM
image (1000 bytes stack usage in process context).  Furthermore, two
1000 bytes memset()s are replaced by one 1000 bytes - ROM length sized
memset.

The trivial fw_memcpy_{from,to}_be32() helpers are now superfluous and
removed.  The newly added __compute_block_crc() function will be folded
into fw_compute_block_crc() in a subsequent change.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |   62 +++++++++++++++++++++--------------
 drivers/firewire/core.h      |    7 ++--
 drivers/firewire/ohci.c      |   30 +++++++++++------
 include/linux/firewire.h     |   14 --------
 4 files changed, 60 insertions(+), 53 deletions(-)

Index: linux-2.6.31/drivers/firewire/core-card.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-card.c
+++ linux-2.6.31/drivers/firewire/core-card.c
@@ -38,6 +38,18 @@
 
 #include "core.h"
 
+static int __compute_block_crc(__be32 *block)
+{
+	int length;
+	u16 crc;
+
+	length = (be32_to_cpu(block[0]) >> 16) & 0xff;
+	crc = crc_itu_t(0, (u8 *)&block[1], length * 4);
+	*block |= cpu_to_be32(crc);
+
+	return length;
+}
+
 int fw_compute_block_crc(u32 *block)
 {
 	__be32 be32_block[256];
@@ -72,11 +84,11 @@ static int descriptor_count;
 #define BIB_CMC			((1) << 30)
 #define BIB_IMC			((1) << 31)
 
-static u32 *generate_config_rom(struct fw_card *card, size_t *config_rom_length)
+static __be32 *generate_config_rom(struct fw_card *card, size_t *rom_length)
 {
 	struct fw_descriptor *desc;
-	static u32 config_rom[256];
-	int i, j, length;
+	static __be32 config_rom[256];
+	int i, j, k, length;
 
 	/*
 	 * Initialize contents of config rom buffer.  On the OHCI
@@ -87,40 +99,39 @@ static u32 *generate_config_rom(struct f
 	 * the version stored in the OHCI registers.
 	 */
 
-	memset(config_rom, 0, sizeof(config_rom));
-	config_rom[0] = BIB_CRC_LENGTH(4) | BIB_INFO_LENGTH(4) | BIB_CRC(0);
-	config_rom[1] = 0x31333934;
-
-	config_rom[2] =
+	config_rom[0] = cpu_to_be32(
+		BIB_CRC_LENGTH(4) | BIB_INFO_LENGTH(4) | BIB_CRC(0));
+	config_rom[1] = cpu_to_be32(0x31333934);
+	config_rom[2] = cpu_to_be32(
 		BIB_LINK_SPEED(card->link_speed) |
 		BIB_GENERATION(card->config_rom_generation++ % 14 + 2) |
 		BIB_MAX_ROM(2) |
 		BIB_MAX_RECEIVE(card->max_receive) |
-		BIB_BMC | BIB_ISC | BIB_CMC | BIB_IMC;
-	config_rom[3] = card->guid >> 32;
-	config_rom[4] = card->guid;
+		BIB_BMC | BIB_ISC | BIB_CMC | BIB_IMC);
+	config_rom[3] = cpu_to_be32(card->guid >> 32);
+	config_rom[4] = cpu_to_be32(card->guid);
 
 	/* Generate root directory. */
-	i = 5;
-	config_rom[i++] = 0;
-	config_rom[i++] = 0x0c0083c0; /* node capabilities */
-	j = i + descriptor_count;
+	config_rom[6] = cpu_to_be32(0x0c0083c0); /* node capabilities */
+	i = 7;
+	j = 7 + descriptor_count;
 
 	/* Generate root directory entries for descriptors. */
 	list_for_each_entry (desc, &descriptor_list, link) {
 		if (desc->immediate > 0)
-			config_rom[i++] = desc->immediate;
-		config_rom[i] = desc->key | (j - i);
+			config_rom[i++] = cpu_to_be32(desc->immediate);
+		config_rom[i] = cpu_to_be32(desc->key | (j - i));
 		i++;
 		j += desc->length;
 	}
 
 	/* Update root directory length. */
-	config_rom[5] = (i - 5 - 1) << 16;
+	config_rom[5] = cpu_to_be32((i - 5 - 1) << 16);
 
 	/* End of root directory, now copy in descriptors. */
 	list_for_each_entry (desc, &descriptor_list, link) {
-		memcpy(&config_rom[i], desc->data, desc->length * 4);
+		for (k = 0; k < desc->length; k++)
+			config_rom[i + k] = cpu_to_be32(desc->data[k]);
 		i += desc->length;
 	}
 
@@ -129,9 +140,9 @@ static u32 *generate_config_rom(struct f
 	 * the bus info block, which is always the case for this
 	 * implementation. */
 	for (i = 0; i < j; i += length + 1)
-		length = fw_compute_block_crc(config_rom + i);
+		length = __compute_block_crc(config_rom + i);
 
-	*config_rom_length = j;
+	*rom_length = j;
 
 	return config_rom;
 }
@@ -139,7 +150,7 @@ static u32 *generate_config_rom(struct f
 static void update_config_roms(void)
 {
 	struct fw_card *card;
-	u32 *config_rom;
+	__be32 *config_rom;
 	size_t length;
 
 	list_for_each_entry (card, &card_list, link) {
@@ -432,7 +443,7 @@ EXPORT_SYMBOL(fw_card_initialize);
 int fw_card_add(struct fw_card *card,
 		u32 max_receive, u32 link_speed, u64 guid)
 {
-	u32 *config_rom;
+	__be32 *config_rom;
 	size_t length;
 	int ret;
 
@@ -462,7 +473,8 @@ EXPORT_SYMBOL(fw_card_add);
  * shutdown still need to be provided by the card driver.
  */
 
-static int dummy_enable(struct fw_card *card, u32 *config_rom, size_t length)
+static int dummy_enable(struct fw_card *card,
+			const __be32 *config_rom, size_t length)
 {
 	BUG();
 	return -1;
@@ -475,7 +487,7 @@ static int dummy_update_phy_reg(struct f
 }
 
 static int dummy_set_config_rom(struct fw_card *card,
-				u32 *config_rom, size_t length)
+				const __be32 *config_rom, size_t length)
 {
 	/*
 	 * We take the card out of card_list before setting the dummy
Index: linux-2.6.31/drivers/firewire/core.h
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core.h
+++ linux-2.6.31/drivers/firewire/core.h
@@ -40,7 +40,8 @@ struct fw_card_driver {
 	 * enable the PHY or set the link_on bit and initiate a bus
 	 * reset.
 	 */
-	int (*enable)(struct fw_card *card, u32 *config_rom, size_t length);
+	int (*enable)(struct fw_card *card,
+		      const __be32 *config_rom, size_t length);
 
 	int (*update_phy_reg)(struct fw_card *card, int address,
 			      int clear_bits, int set_bits);
@@ -48,10 +49,10 @@ struct fw_card_driver {
 	/*
 	 * Update the config rom for an enabled card.  This function
 	 * should change the config rom that is presented on the bus
-	 * an initiate a bus reset.
+	 * and initiate a bus reset.
 	 */
 	int (*set_config_rom)(struct fw_card *card,
-			      u32 *config_rom, size_t length);
+			      const __be32 *config_rom, size_t length);
 
 	void (*send_request)(struct fw_card *card, struct fw_packet *packet);
 	void (*send_response)(struct fw_card *card, struct fw_packet *packet);
Index: linux-2.6.31/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/ohci.c
+++ linux-2.6.31/drivers/firewire/ohci.c
@@ -205,7 +205,7 @@ struct fw_ohci {
 	dma_addr_t config_rom_bus;
 	__be32 *next_config_rom;
 	dma_addr_t next_config_rom_bus;
-	u32 next_header;
+	__be32 next_header;
 
 	struct ar_context ar_request_ctx;
 	struct ar_context ar_response_ctx;
@@ -1355,8 +1355,9 @@ static void bus_reset_tasklet(unsigned l
 		 */
 		reg_write(ohci, OHCI1394_BusOptions,
 			  be32_to_cpu(ohci->config_rom[2]));
-		ohci->config_rom[0] = cpu_to_be32(ohci->next_header);
-		reg_write(ohci, OHCI1394_ConfigROMhdr, ohci->next_header);
+		ohci->config_rom[0] = ohci->next_header;
+		reg_write(ohci, OHCI1394_ConfigROMhdr,
+			  be32_to_cpu(ohci->next_header));
 	}
 
 #ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
@@ -1464,7 +1465,17 @@ static int software_reset(struct fw_ohci
 	return -EBUSY;
 }
 
-static int ohci_enable(struct fw_card *card, u32 *config_rom, size_t length)
+static void copy_config_rom(__be32 *dest, const __be32 *src, size_t length)
+{
+	size_t size = length * 4;
+
+	memcpy(dest, src, size);
+	if (size < CONFIG_ROM_SIZE)
+		memset(&dest[length], 0, CONFIG_ROM_SIZE - size);
+}
+
+static int ohci_enable(struct fw_card *card,
+		       const __be32 *config_rom, size_t length)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	struct pci_dev *dev = to_pci_dev(card->device);
@@ -1565,8 +1576,7 @@ static int ohci_enable(struct fw_card *c
 		if (ohci->next_config_rom == NULL)
 			return -ENOMEM;
 
-		memset(ohci->next_config_rom, 0, CONFIG_ROM_SIZE);
-		fw_memcpy_to_be32(ohci->next_config_rom, config_rom, length * 4);
+		copy_config_rom(ohci->next_config_rom, config_rom, length);
 	} else {
 		/*
 		 * In the suspend case, config_rom is NULL, which
@@ -1576,7 +1586,7 @@ static int ohci_enable(struct fw_card *c
 		ohci->next_config_rom_bus = ohci->config_rom_bus;
 	}
 
-	ohci->next_header = be32_to_cpu(ohci->next_config_rom[0]);
+	ohci->next_header = ohci->next_config_rom[0];
 	ohci->next_config_rom[0] = 0;
 	reg_write(ohci, OHCI1394_ConfigROMhdr, 0);
 	reg_write(ohci, OHCI1394_BusOptions,
@@ -1610,7 +1620,7 @@ static int ohci_enable(struct fw_card *c
 }
 
 static int ohci_set_config_rom(struct fw_card *card,
-			       u32 *config_rom, size_t length)
+			       const __be32 *config_rom, size_t length)
 {
 	struct fw_ohci *ohci;
 	unsigned long flags;
@@ -1659,9 +1669,7 @@ static int ohci_set_config_rom(struct fw
 		ohci->next_config_rom = next_config_rom;
 		ohci->next_config_rom_bus = next_config_rom_bus;
 
-		memset(ohci->next_config_rom, 0, CONFIG_ROM_SIZE);
-		fw_memcpy_to_be32(ohci->next_config_rom, config_rom,
-				  length * 4);
+		copy_config_rom(ohci->next_config_rom, config_rom, length);
 
 		ohci->next_header = config_rom[0];
 		ohci->next_config_rom[0] = 0;
Index: linux-2.6.31/include/linux/firewire.h
===================================================================
--- linux-2.6.31.orig/include/linux/firewire.h
+++ linux-2.6.31/include/linux/firewire.h
@@ -20,20 +20,6 @@
 #define fw_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, ## args)
 #define fw_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
 
-static inline void fw_memcpy_from_be32(void *_dst, void *_src, size_t size)
-{
-	u32    *dst = _dst;
-	__be32 *src = _src;
-	int i;
-
-	for (i = 0; i < size / 4; i++)
-		dst[i] = be32_to_cpu(src[i]);
-}
-
-static inline void fw_memcpy_to_be32(void *_dst, void *_src, size_t size)
-{
-	fw_memcpy_from_be32(_dst, _src, size);
-}
 #define CSR_REGISTER_BASE		0xfffff0000000ULL
 
 /* register offsets are relative to CSR_REGISTER_BASE */

-- 
Stefan Richter
-=====-==--= =-=- -=---
http://arcgraph.de/sr/

