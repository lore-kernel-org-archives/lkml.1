Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbYDAPTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbYDAPTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759180AbYDAPRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:17:55 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:4363 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860AbYDAPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:17:46 -0400
Message-Id: <20080401151736.607301967@ldl.fc.hp.com>
References: <20080401151634.730901933@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Tue, 01 Apr 2008 09:16:39 -0600
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
Subject: [patch 05/37] PNP: add pnp_eisa_id_to_string()
Content-Disposition: inline; filename=pnp-common-eisa-id-parse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting the EISA ID to a string is messy and error-prone, and
we might as well use the same code for ISAPNP and PNPBIOS.

PNPACPI uses the conversion done by the ACPI core with
acpi_ex_eisa_id_to_string().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 drivers/pnp/base.h             |    1 +
 drivers/pnp/isapnp/core.c      |   32 +++++++++++---------------------
 drivers/pnp/pnpbios/core.c     |    2 +-
 drivers/pnp/pnpbios/rsparser.c |   26 +++-----------------------
 drivers/pnp/support.c          |   15 +++++++++++++++
 5 files changed, 31 insertions(+), 45 deletions(-)

Index: work7/drivers/pnp/base.h
===================================================================
--- work7.orig/drivers/pnp/base.h	2008-03-31 16:11:29.000000000 -0600
+++ work7/drivers/pnp/base.h	2008-04-01 08:40:48.000000000 -0600
@@ -1,5 +1,6 @@
 extern spinlock_t pnp_lock;
 void *pnp_alloc(long size);
+void pnp_eisa_id_to_string(u32 id, char *str);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
 int pnp_interface_attach_device(struct pnp_dev *dev);
 void pnp_fixup_device(struct pnp_dev *dev);
Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-31 16:19:41.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-04-01 08:40:48.000000000 -0600
@@ -398,24 +398,6 @@
 }
 
 /*
- *  Parse EISA id.
- */
-static void isapnp_parse_id(struct pnp_dev *dev, unsigned short vendor,
-			    unsigned short device)
-{
-	char id[8];
-
-	sprintf(id, "%c%c%c%x%x%x%x",
-		'A' + ((vendor >> 2) & 0x3f) - 1,
-		'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1,
-		'A' + ((vendor >> 8) & 0x1f) - 1,
-		(device >> 4) & 0x0f,
-		device & 0x0f, (device >> 12) & 0x0f, (device >> 8) & 0x0f);
-
-	pnp_add_id(dev, id);
-}
-
-/*
  *  Parse logical device tag.
  */
 static struct pnp_dev *__init isapnp_parse_device(struct pnp_card *card,
@@ -423,13 +405,17 @@
 {
 	unsigned char tmp[6];
 	struct pnp_dev *dev;
+	u32 eisa_id;
+	char id[8];
 
 	isapnp_peek(tmp, size);
 	dev = kzalloc(sizeof(struct pnp_dev), GFP_KERNEL);
 	if (!dev)
 		return NULL;
 	dev->number = number;
-	isapnp_parse_id(dev, (tmp[1] << 8) | tmp[0], (tmp[3] << 8) | tmp[2]);
+	eisa_id = tmp[0] | tmp[1] << 8 | tmp[2] << 16 | tmp[3] << 24;
+	pnp_eisa_id_to_string(eisa_id, id);
+	pnp_add_id(dev, id);
 	dev->regs = tmp[4];
 	dev->card = card;
 	if (size > 5)
@@ -619,6 +605,8 @@
 	unsigned char type, tmp[17];
 	struct pnp_option *option;
 	struct pnp_dev *dev;
+	u32 eisa_id;
+	char id[8];
 
 	if ((dev = isapnp_parse_device(card, size, number++)) == NULL)
 		return 1;
@@ -658,8 +646,10 @@
 		case _STAG_COMPATDEVID:
 			if (size == 4 && compat < DEVICE_COUNT_COMPATIBLE) {
 				isapnp_peek(tmp, 4);
-				isapnp_parse_id(dev, (tmp[1] << 8) | tmp[0],
-						(tmp[3] << 8) | tmp[2]);
+				eisa_id = tmp[0] | tmp[1] << 8 |
+					  tmp[2] << 16 | tmp[3] << 24;
+				pnp_eisa_id_to_string(eisa_id, id);
+				pnp_add_id(dev, id);
 				compat++;
 				size = 0;
 			}
Index: work7/drivers/pnp/pnpbios/core.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/core.c	2008-03-31 16:19:11.000000000 -0600
+++ work7/drivers/pnp/pnpbios/core.c	2008-04-01 08:40:48.000000000 -0600
@@ -332,7 +332,7 @@
 	if (!dev)
 		return -1;
 
-	pnpid32_to_pnpid(node->eisa_id, id);
+	pnp_eisa_id_to_string(node->eisa_id, id);
 	dev_id = pnp_add_id(dev, id);
 	if (!dev_id) {
 		kfree(dev);
Index: work7/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work7.orig/drivers/pnp/pnpbios/rsparser.c	2008-03-31 16:11:13.000000000 -0600
+++ work7/drivers/pnp/pnpbios/rsparser.c	2008-04-01 08:40:47.000000000 -0600
@@ -494,32 +494,12 @@
  * Compatible Device IDs
  */
 
-#define HEX(id,a) hex[((id)>>a) & 15]
-#define CHAR(id,a) (0x40 + (((id)>>a) & 31))
-
-void pnpid32_to_pnpid(u32 id, char *str)
-{
-	const char *hex = "0123456789abcdef";
-
-	id = be32_to_cpu(id);
-	str[0] = CHAR(id, 26);
-	str[1] = CHAR(id, 21);
-	str[2] = CHAR(id, 16);
-	str[3] = HEX(id, 12);
-	str[4] = HEX(id, 8);
-	str[5] = HEX(id, 4);
-	str[6] = HEX(id, 0);
-	str[7] = '\0';
-}
-
-#undef CHAR
-#undef HEX
-
 static unsigned char *pnpbios_parse_compatible_ids(unsigned char *p,
 						   unsigned char *end,
 						   struct pnp_dev *dev)
 {
 	int len, tag;
+	u32 eisa_id;
 	char id[8];
 	struct pnp_id *dev_id;
 
@@ -549,8 +529,8 @@
 		case SMALL_TAG_COMPATDEVID:	/* compatible ID */
 			if (len != 4)
 				goto len_err;
-			pnpid32_to_pnpid(p[1] | p[2] << 8 | p[3] << 16 | p[4] <<
-					 24, id);
+			eisa_id = p[1] | p[2] << 8 | p[3] << 16 | p[4] << 24;
+			pnp_eisa_id_to_string(eisa_id, id);
 			dev_id = pnp_add_id(dev, id);
 			if (!dev_id)
 				return NULL;
Index: work7/drivers/pnp/support.c
===================================================================
--- work7.orig/drivers/pnp/support.c	2008-03-31 16:10:37.000000000 -0600
+++ work7/drivers/pnp/support.c	2008-04-01 08:41:28.000000000 -0600
@@ -25,3 +25,16 @@
 }
 
 EXPORT_SYMBOL(pnp_is_active);
+
+void pnp_eisa_id_to_string(u32 id, char *str)
+{
+	id = be32_to_cpu(id);
+	str[0] = '@' + ((id >> 26) & 0x1f);
+	str[1] = '@' + ((id >> 21) & 0x1f);
+	str[2] = '@' + ((id >> 16) & 0x1f);
+	str[3] = hex_asc((id >> 12) & 0xf);
+	str[4] = hex_asc((id >>  8) & 0xf);
+	str[5] = hex_asc((id >>  4) & 0xf);
+	str[6] = hex_asc((id >>  0) & 0xf);
+	str[7] = '\0';
+}

-- 
