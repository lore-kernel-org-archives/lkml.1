Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab0BDRbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:31:32 -0500
Received: from kroah.org ([198.145.64.141]:34754 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274Ab0BDRV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:59 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:09 2010
Message-Id: <20100204171509.312292996@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Greg KH <greg@kroah.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [37/74] firewire: core: add_descriptor size check
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


Backport of commit e300839da40e99581581c5d053a95a172651fec8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/core-card.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)

--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -57,6 +57,9 @@ static LIST_HEAD(card_list);
 static LIST_HEAD(descriptor_list);
 static int descriptor_count;
 
+/* ROM header, bus info block, root dir header, capabilities = 7 quadlets */
+static size_t config_rom_length = 1 + 4 + 1 + 1;
+
 #define BIB_CRC(v)		((v) <<  0)
 #define BIB_CRC_LENGTH(v)	((v) << 16)
 #define BIB_INFO_LENGTH(v)	((v) << 24)
@@ -72,7 +75,7 @@ static int descriptor_count;
 #define BIB_CMC			((1) << 30)
 #define BIB_IMC			((1) << 31)
 
-static u32 *generate_config_rom(struct fw_card *card, size_t *config_rom_length)
+static u32 *generate_config_rom(struct fw_card *card)
 {
 	struct fw_descriptor *desc;
 	static u32 config_rom[256];
@@ -131,7 +134,7 @@ static u32 *generate_config_rom(struct f
 	for (i = 0; i < j; i += length + 1)
 		length = fw_compute_block_crc(config_rom + i);
 
-	*config_rom_length = j;
+	WARN_ON(j != config_rom_length);
 
 	return config_rom;
 }
@@ -140,17 +143,24 @@ static void update_config_roms(void)
 {
 	struct fw_card *card;
 	u32 *config_rom;
-	size_t length;
 
 	list_for_each_entry (card, &card_list, link) {
-		config_rom = generate_config_rom(card, &length);
-		card->driver->set_config_rom(card, config_rom, length);
+		config_rom = generate_config_rom(card);
+		card->driver->set_config_rom(card, config_rom,
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
@@ -166,15 +176,21 @@ int fw_core_add_descriptor(struct fw_des
 
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
 
@@ -183,6 +199,7 @@ void fw_core_remove_descriptor(struct fw
 	mutex_lock(&card_mutex);
 
 	list_del(&desc->link);
+	config_rom_length -= required_space(desc);
 	descriptor_count--;
 	if (desc->immediate > 0)
 		descriptor_count--;
@@ -436,7 +453,6 @@ int fw_card_add(struct fw_card *card,
 		u32 max_receive, u32 link_speed, u64 guid)
 {
 	u32 *config_rom;
-	size_t length;
 	int ret;
 
 	card->max_receive = max_receive;
@@ -445,8 +461,8 @@ int fw_card_add(struct fw_card *card,
 
 	mutex_lock(&card_mutex);
 
-	config_rom = generate_config_rom(card, &length);
-	ret = card->driver->enable(card, config_rom, length);
+	config_rom = generate_config_rom(card);
+	ret = card->driver->enable(card, config_rom, config_rom_length);
 	if (ret == 0)
 		list_add_tail(&card->link, &card_list);
 


