Return-Path: <linux-kernel-owner+w=401wt.eu-S967117AbYD1Wkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967117AbYD1Wkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965981AbYD1Wg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:36:29 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:34266 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965628AbYD1Wg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:36:27 -0400
Message-Id: <20080428223617.665087408@ldl.fc.hp.com>
References: <20080428223347.233593713@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 16:33:53 -0600
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
Subject: [patch 06/55] PNP: add pnp_eisa_id_to_string()
Content-Disposition: inline; filename=pnp-common-eisa-id-parse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting the EISA ID to a string is messy and error-prone, and
we might as well use the same code for ISAPNP and PNPBIOS.

PNPACPI uses the conversion done by the ACPI core with
acpi_ex_eisa_id_to_string().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-By: Rene Herman <rene.herman@gmail.com>

---
 drivers/pnp/base.h             |    2 ++
 drivers/pnp/isapnp/core.c      |   32 +++++++++++---------------------
 drivers/pnp/pnpbios/core.c     |    2 +-
 drivers/pnp/pnpbios/rsparser.c |   26 +++-----------------------
 drivers/pnp/support.c          |   26 ++++++++++++++++++++++++++
 5 files changed, 43 insertions(+), 45 deletions(-)

Index: work10/drivers/pnp/base.h
===================================================================
--- work10.orig/drivers/pnp/base.h	2008-04-28 16:09:10.000000000 -0600
+++ work10/drivers/pnp/base.h	2008-04-28 16:09:11.000000000 -0600
@@ -1,5 +1,7 @@
 extern spinlock_t pnp_lock;
 void *pnp_alloc(long size);
+#define PNP_EISA_ID_MASK 0x7fffffff
+void pnp_eisa_id_to_string(u32 id, char *str);
 struct pnp_id *pnp_add_id(struct pnp_dev *dev, char *id);
 int pnp_interface_attach_device(struct pnp_dev *dev);
 void pnp_fixup_device(struct pnp_dev *dev);
Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-04-28 16:09:10.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-04-28 16:09:11.000000000 -0600
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
Index: work10/drivers/pnp/pnpbios/core.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/core.c	2008-04-28 16:09:10.000000000 -0600
+++ work10/drivers/pnp/pnpbios/core.c	2008-04-28 16:09:11.000000000 -0600
@@ -332,7 +332,7 @@
 	if (!dev)
 		return -1;
 
-	pnpid32_to_pnpid(node->eisa_id, id);
+	pnp_eisa_id_to_string(node->eisa_id & PNP_EISA_ID_MASK, id);
 	dev_id = pnp_add_id(dev, id);
 	if (!dev_id) {
 		kfree(dev);
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:10.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-04-28 16:09:11.000000000 -0600
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
+			pnp_eisa_id_to_string(eisa_id & PNP_EISA_ID_MASK, id);
 			dev_id = pnp_add_id(dev, id);
 			if (!dev_id)
 				return NULL;
Index: work10/drivers/pnp/support.c
===================================================================
--- work10.orig/drivers/pnp/support.c	2008-04-28 15:57:04.000000000 -0600
+++ work10/drivers/pnp/support.c	2008-04-28 16:09:11.000000000 -0600
@@ -25,3 +25,29 @@
 }
 
 EXPORT_SYMBOL(pnp_is_active);
+
+/*
+ * Functionally similar to acpi_ex_eisa_id_to_string(), but that's
+ * buried in the ACPI CA, and we can't depend on it being present.
+ */
+void pnp_eisa_id_to_string(u32 id, char *str)
+{
+	id = be32_to_cpu(id);
+
+	/*
+	 * According to the specs, the first three characters are five-bit
+	 * compressed ASCII, and the left-over high order bit should be zero.
+	 * However, the Linux ISAPNP code historically used six bits for the
+	 * first character, and there seem to be IDs that depend on that,
+	 * e.g., "nEC8241" in the Linux 8250_pnp serial driver and the
+	 * FreeBSD sys/pc98/cbus/sio_cbus.c driver.
+	 */
+	str[0] = 'A' + ((id >> 26) & 0x3f) - 1;
+	str[1] = 'A' + ((id >> 21) & 0x1f) - 1;
+	str[2] = 'A' + ((id >> 16) & 0x1f) - 1;
+	str[3] = hex_asc((id >> 12) & 0xf);
+	str[4] = hex_asc((id >>  8) & 0xf);
+	str[5] = hex_asc((id >>  4) & 0xf);
+	str[6] = hex_asc((id >>  0) & 0xf);
+	str[7] = '\0';
+}

-- 
