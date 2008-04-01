Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbYDAPVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbYDAPVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759353AbYDAPSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:18:08 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:26940 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860AbYDAPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:17:56 -0400
Message-Id: <20080401151737.444994893@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:43 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 09/37] ISAPNP: pull pnp_add_card_id() out of isapnp_parse_card_id()
Content-Disposition: inline; filename=isapnp-restructure-parse-card-id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the pnp_add_card_id() part from the PNPID conversion part so we
can move the initial add_id() into the pnp_card allocation.

This makes the PNPID conversion generic so we can use the same
one for both devices and cards.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-31 16:59:11.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-31 17:01:37.000000000 -0600
@@ -817,26 +817,6 @@
 }
 
 /*
- *  Parse EISA id for ISA PnP card.
- */
-static void isapnp_parse_card_id(struct pnp_card *card, unsigned short vendor,
-				 unsigned short device)
-{
-	char id[8];
-
-	id[0] = 'A' + ((vendor >> 2) & 0x3f) - 1;
-	id[1] = 'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1;
-	id[2] = 'A' + ((vendor >> 8) & 0x1f) - 1;
-	id[3] = '0' + ((device >> 4) & 0x0f);
-	id[4] = '0' + (device & 0x0f);
-	id[5] = '0' + ((device >> 12) & 0x0f);
-	id[6] = '0' + ((device >> 8) & 0x0f);
-	id[7] = '\0';
-
-	pnp_add_card_id(card, id);
-}
-
-/*
  *  Build device list for all present ISA PnP devices.
  */
 static int __init isapnp_build_device_list(void)
@@ -844,6 +824,8 @@
 	int csn;
 	unsigned char header[9], checksum;
 	struct pnp_card *card;
+	u32 eisa_id;
+	char id[8];
 
 	isapnp_wait();
 	isapnp_key();
@@ -864,8 +846,10 @@
 
 		card->number = csn;
 		INIT_LIST_HEAD(&card->devices);
-		isapnp_parse_card_id(card, (header[1] << 8) | header[0],
-				     (header[3] << 8) | header[2]);
+		eisa_id = header[0] | header[1] << 8 |
+			  header[2] << 16 | header[3] << 24;
+		pnp_eisa_id_to_string(eisa_id, id);
+		pnp_add_card_id(card, id);
 		card->serial =
 		    (header[7] << 24) | (header[6] << 16) | (header[5] << 8) |
 		    header[4];

-- 
