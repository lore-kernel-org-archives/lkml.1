Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZJGWna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZJGWna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbZJGWn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:43:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44056 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbZJGWn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:43:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 8 Oct 2009 00:42:27 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 7/8] firewire: core: clarify generate_config_rom usage
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.27888275592fd267@s5r6.in-berlin.de>
Message-ID: <tkrat.666fc82e31e3111e@s5r6.in-berlin.de>
References: <tkrat.27888275592fd267@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the static config ROM buffer into the scope of the two callers of
generate_config_rom().  That way the ROM length can be passed over as
return value rather than through a pointer argument.

It also becomes more obvious that accesses to the config ROM buffer have
to be serialized and how this is accomplished.  And firewire-core.ko
shrinks a bit as well.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-card.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

Index: linux-2.6.31/drivers/firewire/core-card.c
===================================================================
--- linux-2.6.31.orig/drivers/firewire/core-card.c
+++ linux-2.6.31/drivers/firewire/core-card.c
@@ -69,6 +69,8 @@ static LIST_HEAD(card_list);
 static LIST_HEAD(descriptor_list);
 static int descriptor_count;
 
+static __be32 tmp_config_rom[256];
+
 #define BIB_CRC(v)		((v) <<  0)
 #define BIB_CRC_LENGTH(v)	((v) << 16)
 #define BIB_INFO_LENGTH(v)	((v) << 24)
@@ -84,10 +86,9 @@ static int descriptor_count;
 #define BIB_CMC			((1) << 30)
 #define BIB_IMC			((1) << 31)
 
-static __be32 *generate_config_rom(struct fw_card *card, size_t *rom_length)
+static size_t generate_config_rom(struct fw_card *card, __be32 *config_rom)
 {
 	struct fw_descriptor *desc;
-	static __be32 config_rom[256];
 	int i, j, k, length;
 
 	/*
@@ -142,20 +143,17 @@ static __be32 *generate_config_rom(struc
 	for (i = 0; i < j; i += length + 1)
 		length = __compute_block_crc(config_rom + i);
 
-	*rom_length = j;
-
-	return config_rom;
+	return j;
 }
 
 static void update_config_roms(void)
 {
 	struct fw_card *card;
-	__be32 *config_rom;
 	size_t length;
 
 	list_for_each_entry (card, &card_list, link) {
-		config_rom = generate_config_rom(card, &length);
-		card->driver->set_config_rom(card, config_rom, length);
+		length = generate_config_rom(card, tmp_config_rom);
+		card->driver->set_config_rom(card, tmp_config_rom, length);
 	}
 }
 
@@ -443,7 +441,6 @@ EXPORT_SYMBOL(fw_card_initialize);
 int fw_card_add(struct fw_card *card,
 		u32 max_receive, u32 link_speed, u64 guid)
 {
-	__be32 *config_rom;
 	size_t length;
 	int ret;
 
@@ -453,8 +450,8 @@ int fw_card_add(struct fw_card *card,
 
 	mutex_lock(&card_mutex);
 
-	config_rom = generate_config_rom(card, &length);
-	ret = card->driver->enable(card, config_rom, length);
+	length = generate_config_rom(card, tmp_config_rom);
+	ret = card->driver->enable(card, tmp_config_rom, length);
 	if (ret == 0)
 		list_add_tail(&card->link, &card_list);
 

-- 
Stefan Richter
-=====-==--= =-=- -=---
http://arcgraph.de/sr/

