Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbZIFQvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbZIFQvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 12:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZIFQvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 12:51:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48873 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbZIFQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 12:51:20 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 6 Sep 2009 18:50:56 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/6] firewire: reduce some memsets
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, PaX Team <pageexec@freemail.hu>
In-Reply-To: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
Message-ID: <tkrat.1d38de48035e916f@s5r6.in-berlin.de>
References: <tkrat.85bb80d9295444c1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 1 kBytes big config ROM was cleared to zero twice at each update.
It is only necessary to clear the trailing unused space in the ROM, and
only once.

While we are at it, replace the trivial fw_memcpy_to_be32() helper by
its open-coded equivalent.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |    4 +---
 drivers/firewire/ohci.c      |   17 ++++++++++++-----
 include/linux/firewire.h     |    4 ----
 3 files changed, 13 insertions(+), 12 deletions(-)

Index: linux-2.6.31-rc9/drivers/firewire/core-card.c
===================================================================
--- linux-2.6.31-rc9.orig/drivers/firewire/core-card.c
+++ linux-2.6.31-rc9/drivers/firewire/core-card.c
@@ -80,46 +80,44 @@ static int descriptor_count;
 static u32 *generate_config_rom(struct fw_card *card, size_t *config_rom_length)
 {
 	struct fw_descriptor *desc;
 	static u32 config_rom[256];
 	int i, j, length;
 
 	/*
 	 * Initialize contents of config rom buffer.  On the OHCI
 	 * controller, block reads to the config rom accesses the host
 	 * memory, but quadlet read access the hardware bus info block
 	 * registers.  That's just crack, but it means we should make
 	 * sure the contents of bus info block in host memory matches
 	 * the version stored in the OHCI registers.
 	 */
 
-	memset(config_rom, 0, sizeof(config_rom));
 	config_rom[0] = BIB_CRC_LENGTH(4) | BIB_INFO_LENGTH(4) | BIB_CRC(0);
 	config_rom[1] = 0x31333934;
 
 	config_rom[2] =
 		BIB_LINK_SPEED(card->link_speed) |
 		BIB_GENERATION(card->config_rom_generation++ % 14 + 2) |
 		BIB_MAX_ROM(2) |
 		BIB_MAX_RECEIVE(card->max_receive) |
 		BIB_BMC | BIB_ISC | BIB_CMC | BIB_IMC;
 	config_rom[3] = card->guid >> 32;
 	config_rom[4] = card->guid;
 
 	/* Generate root directory. */
-	i = 5;
-	config_rom[i++] = 0;
+	i = 6;
 	config_rom[i++] = 0x0c0083c0; /* node capabilities */
 	j = i + descriptor_count;
 
 	/* Generate root directory entries for descriptors. */
 	list_for_each_entry (desc, &descriptor_list, link) {
 		if (desc->immediate > 0)
 			config_rom[i++] = desc->immediate;
 		config_rom[i] = desc->key | (j - i);
 		i++;
 		j += desc->length;
 	}
 
 	/* Update root directory length. */
 	config_rom[5] = (i - 5 - 1) << 16;
 
Index: linux-2.6.31-rc9/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.31-rc9.orig/drivers/firewire/ohci.c
+++ linux-2.6.31-rc9/drivers/firewire/ohci.c
@@ -1464,6 +1464,16 @@ static int software_reset(struct fw_ohci
 	return -EBUSY;
 }
 
+static void copy_config_rom(__be32 *dest, const u32 *src, size_t length)
+{
+	int i;
+
+	for (i = 0; i < length; i++)
+		dest[i] = cpu_to_be32(src[i]);
+
+	memset(&dest[length], 0, CONFIG_ROM_SIZE - length * 4);
+}
+
 static int ohci_enable(struct fw_card *card, u32 *config_rom, size_t length)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
@@ -1565,8 +1575,7 @@ static int ohci_enable(struct fw_card *c
 		if (ohci->next_config_rom == NULL)
 			return -ENOMEM;
 
-		memset(ohci->next_config_rom, 0, CONFIG_ROM_SIZE);
-		fw_memcpy_to_be32(ohci->next_config_rom, config_rom, length * 4);
+		copy_config_rom(ohci->next_config_rom, config_rom, length);
 	} else {
 		/*
 		 * In the suspend case, config_rom is NULL, which
@@ -1659,9 +1668,7 @@ static int ohci_set_config_rom(struct fw
 		ohci->next_config_rom = next_config_rom;
 		ohci->next_config_rom_bus = next_config_rom_bus;
 
-		memset(ohci->next_config_rom, 0, CONFIG_ROM_SIZE);
-		fw_memcpy_to_be32(ohci->next_config_rom, config_rom,
-				  length * 4);
+		copy_config_rom(ohci->next_config_rom, config_rom, length);
 
 		ohci->next_header = config_rom[0];
 		ohci->next_config_rom[0] = 0;
Index: linux-2.6.31-rc9/include/linux/firewire.h
===================================================================
--- linux-2.6.31-rc9.orig/include/linux/firewire.h
+++ linux-2.6.31-rc9/include/linux/firewire.h
@@ -30,10 +30,6 @@ static inline void fw_memcpy_from_be32(v
 		dst[i] = be32_to_cpu(src[i]);
 }
 
-static inline void fw_memcpy_to_be32(void *_dst, void *_src, size_t size)
-{
-	fw_memcpy_from_be32(_dst, _src, size);
-}
 #define CSR_REGISTER_BASE		0xfffff0000000ULL
 
 /* register offsets are relative to CSR_REGISTER_BASE */

-- 
Stefan Richter
-=====-==--= =--= --==-
http://arcgraph.de/sr/

