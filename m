Return-Path: <linux-kernel-owner+w=401wt.eu-S933565AbYDYTF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbYDYTF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764542AbYDYSlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:41:44 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:9749 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761464AbYDYSji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:39:38 -0400
Message-Id: <20080425183925.949094545@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:16 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 09/54] PNP: change pnp_add_card_id() to allocate its own pnp_id structures
Content-Disposition: inline; filename=pnp-move-allocation-into-pnp_add_card_id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves some of the pnp_id knowledge out of the backends and into
the PNP core.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-25 11:14:50.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-25 11:14:50.000000000 -0600
@@ -4,7 +4,7 @@
 void pnp_eisa_id_to_string(u32 id, char *str);
 struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *, int id, char *pnpid);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
-int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card);
+struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id);
 int pnp_interface_attach_device(struct pnp_dev *dev);
 void pnp_fixup_device(struct pnp_dev *dev);
 void pnp_free_option(struct pnp_option *option);
Index: work10/drivers/pnp/card.c
===================================================================
--- work10.orig/drivers/pnp/card.c	2008-04-25 11:12:17.000000000 -0600
+++ work10/drivers/pnp/card.c	2008-04-25 11:14:50.000000000 -0600
@@ -5,6 +5,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/ctype.h>
 #include <linux/slab.h>
 #include <linux/pnp.h>
 #include "base.h"
@@ -100,19 +101,33 @@
  * @id: pointer to a pnp_id structure
  * @card: pointer to the desired card
  */
-int pnp_add_card_id(struct pnp_id *id, struct pnp_card *card)
+struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id)
 {
-	struct pnp_id *ptr;
+	struct pnp_id *dev_id, *ptr;
 
-	id->next = NULL;
+	dev_id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
+	if (!dev_id)
+		return NULL;
+
+	dev_id->id[0] = id[0];
+	dev_id->id[1] = id[1];
+	dev_id->id[2] = id[2];
+	dev_id->id[3] = tolower(id[3]);
+	dev_id->id[4] = tolower(id[4]);
+	dev_id->id[5] = tolower(id[5]);
+	dev_id->id[6] = tolower(id[6]);
+	dev_id->id[7] = '\0';
+
+	dev_id->next = NULL;
 	ptr = card->id;
 	while (ptr && ptr->next)
 		ptr = ptr->next;
 	if (ptr)
-		ptr->next = id;
+		ptr->next = dev_id;
 	else
-		card->id = id;
-	return 0;
+		card->id = dev_id;
+
+	return dev_id;
 }
 
 static void pnp_free_card_ids(struct pnp_card *card)
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-25 11:14:49.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-25 11:14:50.000000000 -0600
@@ -822,17 +822,18 @@
 static void isapnp_parse_card_id(struct pnp_card *card, unsigned short vendor,
 				 unsigned short device)
 {
-	struct pnp_id *id = kzalloc(sizeof(struct pnp_id), GFP_KERNEL);
+	char id[8];
 
-	if (!id)
-		return;
-	sprintf(id->id, "%c%c%c%x%x%x%x",
-		'A' + ((vendor >> 2) & 0x3f) - 1,
-		'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
-		'A' + ((vendor >> 8) & 0x1f) - 1,
-		(device >> 4) & 0x0f,
-		device & 0x0f, (device >> 12) & 0x0f, (device >> 8) & 0x0f);
-	pnp_add_card_id(id, card);
+	id[0] = 'A' + ((vendor >> 2) & 0x3f) - 1;
+	id[1] = 'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1;
+	id[2] = 'A' + ((vendor >> 8) & 0x1f) - 1;
+	id[3] = hex_asc((device >> 4) & 0x0f);
+	id[4] = hex_asc(device & 0x0f);
+	id[5] = hex_asc((device >> 12) & 0x0f);
+	id[6] = hex_asc((device >> 8) & 0x0f);
+	id[7] = '\0';
+
+	pnp_add_card_id(card, id);
 }
 
 /*

-- 
