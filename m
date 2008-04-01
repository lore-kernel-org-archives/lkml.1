Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbYDAPVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbYDAPVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759375AbYDAPSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:18:11 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:26964 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218AbYDAPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:17:57 -0400
Message-Id: <20080401151737.646628835@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:44 -0600
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
Subject: [patch 10/37] PNP: add pnp_alloc_card()
Content-Disposition: inline; filename=pnp-alloc-card
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pnp_alloc_card() to allocate a struct pnp_card and fill in the
protocol, instance number, and initial PNP ID.  Now it is always
valid to use dev_printk() on any pnp_card pointer.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h        |    1 +
 drivers/pnp/card.c        |   28 +++++++++++++++++++++++++---
 drivers/pnp/isapnp/core.c |   11 ++++-------
 3 files changed, 30 insertions(+), 10 deletions(-)

Index: work7/drivers/pnp/base.h
===================================================================
--- work7.orig/drivers/pnp/base.h	2008-03-31 17:07:27.000000000 -0600
+++ work7/drivers/pnp/base.h	2008-03-31 17:07:34.000000000 -0600
@@ -2,6 +2,7 @@
 void *pnp_alloc(long size);
 void pnp_eisa_id_to_string(u32 id, char *str);
 struct pnp_dev *pnp_alloc_dev(struct pnp_protocol *, int id, char *pnpid);
+struct pnp_card *pnp_alloc_card(struct pnp_protocol *, int id, char *pnpid);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
 struct pnp_id *pnp_add_card_id(struct pnp_card *card, char *id);
 int pnp_interface_attach_device(struct pnp_dev *dev);
Index: work7/drivers/pnp/card.c
===================================================================
--- work7.orig/drivers/pnp/card.c	2008-03-31 17:07:27.000000000 -0600
+++ work7/drivers/pnp/card.c	2008-03-31 17:07:34.000000000 -0600
@@ -151,6 +151,31 @@
 	kfree(card);
 }
 
+struct pnp_card *pnp_alloc_card(struct pnp_protocol *protocol, int id, char *pnpid)
+{
+	struct pnp_card *card;
+	struct pnp_id *dev_id;
+
+	card = kzalloc(sizeof(struct pnp_card), GFP_KERNEL);
+	if (!card)
+		return NULL;
+
+	card->protocol = protocol;
+	card->number = id;
+
+	card->dev.parent = &card->protocol->dev;
+	sprintf(card->dev.bus_id, "%02x:%02x", card->protocol->number,
+		card->number);
+
+	dev_id = pnp_add_card_id(card, pnpid);
+	if (!dev_id) {
+		kfree(card);
+		return NULL;
+	}
+
+	return card;
+}
+
 static ssize_t pnp_show_card_name(struct device *dmdev,
 				  struct device_attribute *attr, char *buf)
 {
@@ -206,9 +231,6 @@
 	int error;
 	struct list_head *pos, *temp;
 
-	sprintf(card->dev.bus_id, "%02x:%02x", card->protocol->number,
-		card->number);
-	card->dev.parent = &card->protocol->dev;
 	card->dev.bus = NULL;
 	card->dev.release = &pnp_release_card;
 	error = device_register(&card->dev);
Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-31 17:07:27.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-31 17:10:26.000000000 -0600
@@ -840,16 +840,14 @@
 		       header[5], header[6], header[7], header[8]);
 		printk(KERN_DEBUG "checksum = 0x%x\n", checksum);
 #endif
-		if ((card =
-		     kzalloc(sizeof(struct pnp_card), GFP_KERNEL)) == NULL)
-			continue;
-
-		card->number = csn;
-		INIT_LIST_HEAD(&card->devices);
 		eisa_id = header[0] | header[1] << 8 |
 			  header[2] << 16 | header[3] << 24;
 		pnp_eisa_id_to_string(eisa_id, id);
-		pnp_add_card_id(card, id);
+		card = pnp_alloc_card(&isapnp_protocol, csn, id);
+		if (!card)
+			continue;
+
+		INIT_LIST_HEAD(&card->devices);
 		card->serial =
 		    (header[7] << 24) | (header[6] << 16) | (header[5] << 8) |
 		    header[4];
@@ -860,7 +858,6 @@
 			       "isapnp: checksum for device %i is not valid (0x%x)\n",
 			       csn, isapnp_checksum_value);
 		card->checksum = isapnp_checksum_value;
-		card->protocol = &isapnp_protocol;
 
 		pnp_add_card(card);
 	}

-- 
