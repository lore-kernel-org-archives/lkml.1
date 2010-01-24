Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690Ab0AXNrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab0AXNrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 08:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112Ab0AXNrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 08:47:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39566 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab0AXNrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 08:47:10 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Jan 2010 14:47:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: add_descriptor size check
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.e2742c96fc3ed717@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presently, firewire-core only checks whether descriptors that are to be
added by userspace drivers to the local node's config ROM do not exceed
a size of 256 quadlets.  However, the sum of the bare minimum ROM plus
all descriptors (from firewire-core, from firewire-net, from userspace)
must not exceed 256 quadlets.

Otherwise, the bounds of a statically allocated buffer will be
overwritten.  If the kernel survives that, firewire-core will
subsequently be unable to parse the local node's config ROM.

(Note, userspace drivers can add descriptors only through device files
of local nodes.  These are usually only accessible by root, unlike
device files of remote nodes which may be accessible to lesser
privileged users.)

Therefore add a test which takes the actual present and required ROM
size into account for all descriptors of kernelspace and userspace
drivers.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |   41 ++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 13 deletions(-)

Index: linux/drivers/firewire/core-card.c
===================================================================
--- linux.orig/drivers/firewire/core-card.c
+++ linux/drivers/firewire/core-card.c
@@ -57,6 +57,8 @@ static LIST_HEAD(descriptor_list);
 static int descriptor_count;
 
 static __be32 tmp_config_rom[256];
+/* ROM header, bus info block, root dir header, capabilities = 7 quadlets */
+static size_t config_rom_length = 1 + 4 + 1 + 1;
 
 #define BIB_CRC(v)		((v) <<  0)
 #define BIB_CRC_LENGTH(v)	((v) << 16)
@@ -73,7 +75,7 @@ static __be32 tmp_config_rom[256];
 #define BIB_CMC			((1) << 30)
 #define BIB_IMC			((1) << 31)
 
-static size_t generate_config_rom(struct fw_card *card, __be32 *config_rom)
+static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
 {
 	struct fw_descriptor *desc;
 	int i, j, k, length;
@@ -130,23 +132,30 @@ static size_t generate_config_rom(struct
 	for (i = 0; i < j; i += length + 1)
 		length = fw_compute_block_crc(config_rom + i);
 
-	return j;
+	WARN_ON(j != config_rom_length);
 }
 
 static void update_config_roms(void)
 {
 	struct fw_card *card;
-	size_t length;
 
 	list_for_each_entry (card, &card_list, link) {
-		length = generate_config_rom(card, tmp_config_rom);
-		card->driver->set_config_rom(card, tmp_config_rom, length);
+		generate_config_rom(card, tmp_config_rom);
+		card->driver->set_config_rom(card, tmp_config_rom,
+					     config_rom_length);
 	}
 }
 
+static size_t required_space(struct fw_descriptor *desc)
+{
+	/* descriptor + entry into root dir + optional immediate entry */
+	return desc->length + 1 + (desc->immediate > 0 ? 1 : 0);
+}
+
 int fw_core_add_descriptor(struct fw_descriptor *desc)
 {
 	size_t i;
+	int ret;
 
 	/*
 	 * Check descriptor is valid; the length of all blocks in the
@@ -162,15 +171,21 @@ int fw_core_add_descriptor(struct fw_des
 
 	mutex_lock(&card_mutex);
 
-	list_add_tail(&desc->link, &descriptor_list);
-	descriptor_count++;
-	if (desc->immediate > 0)
+	if (config_rom_length + required_space(desc) > 256) {
+		ret = -EBUSY;
+	} else {
+		list_add_tail(&desc->link, &descriptor_list);
+		config_rom_length += required_space(desc);
 		descriptor_count++;
-	update_config_roms();
+		if (desc->immediate > 0)
+			descriptor_count++;
+		update_config_roms();
+		ret = 0;
+	}
 
 	mutex_unlock(&card_mutex);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(fw_core_add_descriptor);
 
@@ -179,6 +194,7 @@ void fw_core_remove_descriptor(struct fw
 	mutex_lock(&card_mutex);
 
 	list_del(&desc->link);
+	config_rom_length -= required_space(desc);
 	descriptor_count--;
 	if (desc->immediate > 0)
 		descriptor_count--;
@@ -428,7 +444,6 @@ EXPORT_SYMBOL(fw_card_initialize);
 int fw_card_add(struct fw_card *card,
 		u32 max_receive, u32 link_speed, u64 guid)
 {
-	size_t length;
 	int ret;
 
 	card->max_receive = max_receive;
@@ -437,8 +452,8 @@ int fw_card_add(struct fw_card *card,
 
 	mutex_lock(&card_mutex);
 
-	length = generate_config_rom(card, tmp_config_rom);
-	ret = card->driver->enable(card, tmp_config_rom, length);
+	generate_config_rom(card, tmp_config_rom);
+	ret = card->driver->enable(card, tmp_config_rom, config_rom_length);
 	if (ret == 0)
 		list_add_tail(&card->link, &card_list);
 

-- 
Stefan Richter
-=====-==-=- ---= ==---
http://arcgraph.de/sr/

