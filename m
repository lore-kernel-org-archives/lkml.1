Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbZLZAnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbZLZAnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbZLZAno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:43:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53631 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057AbZLZAnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:43:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Dec 2009 01:43:21 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/3] firewire: core: fw_csr_string addendum
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
       Clemens Ladisch <cladisch@fastmail.net>
In-Reply-To: <tkrat.d7a89db5096e31cd@s5r6.in-berlin.de>
Message-ID: <tkrat.2c5d2d0397876ecd@s5r6.in-berlin.de>
References: <tkrat.d7a89db5096e31cd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Witespace and comment changes, and a different way to say i + 1 < end.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |   26 ++++++++++++++++----------
 include/linux/firewire.h       |    1 -
 2 files changed, 16 insertions(+), 11 deletions(-)

Index: linux-2.6.33-rc2/drivers/firewire/core-device.c
===================================================================
--- linux-2.6.33-rc2.orig/drivers/firewire/core-device.c
+++ linux-2.6.33-rc2/drivers/firewire/core-device.c
@@ -69,19 +69,22 @@ static u32 *search_leaf(u32 *directory, 
 		if (last_key == search_key &&
 		    key == (CSR_DESCRIPTOR | CSR_LEAF))
 			return ci.p - 1 + value;
+
 		last_key = key;
 	}
+
 	return NULL;
 }
 
 static int textual_leaf_to_string(u32 *block, char *buf, size_t size)
 {
-	unsigned int quadlets, length;
+	unsigned int quadlets, i;
+	char c;
 
 	if (!size || !buf)
 		return -EINVAL;
 
-	quadlets = min(block[0] >> 16, 256u);
+	quadlets = min(block[0] >> 16, 256U);
 	if (quadlets < 2)
 		return -ENODATA;
 
@@ -91,31 +94,34 @@ static int textual_leaf_to_string(u32 *b
 
 	block += 3;
 	quadlets -= 2;
-	for (length = 0; length < quadlets * 4 && length + 1 < size; length++) {
-		char c = block[length / 4] >> (24 - 8 * (length % 4));
+	for (i = 0; i < quadlets * 4 && i < size - 1; i++) {
+		c = block[i / 4] >> (24 - 8 * (i % 4));
 		if (c == '\0')
 			break;
-		buf[length] = c;
+		buf[i] = c;
 	}
-	buf[length] = '\0';
-	return length;
+	buf[i] = '\0';
+
+	return i;
 }
 
 /**
  * fw_csr_string - reads a string from the configuration ROM
- * @directory: device or unit directory;
- *             fw_device->config_rom+5 or fw_unit->directory
+ * @directory: e.g. root directory or unit directory
  * @key: the key of the preceding directory entry
  * @buf: where to put the string
  * @size: size of @buf, in bytes
  *
- * Returns string length (>= 0) or error code (< 0).
+ * The string is taken from a minimal ASCII text descriptor leaf after
+ * the immediate entry with @key.  The string is zero-terminated.
+ * Returns strlen(buf) or a negative error code.
  */
 int fw_csr_string(u32 *directory, int key, char *buf, size_t size)
 {
 	u32 *leaf = search_leaf(directory, key);
 	if (!leaf)
 		return -ENOENT;
+
 	return textual_leaf_to_string(leaf, buf, size);
 }
 EXPORT_SYMBOL(fw_csr_string);
Index: linux-2.6.33-rc2/include/linux/firewire.h
===================================================================
--- linux-2.6.33-rc2.orig/include/linux/firewire.h
+++ linux-2.6.33-rc2/include/linux/firewire.h
@@ -71,7 +71,6 @@ struct fw_csr_iterator {
 
 void fw_csr_iterator_init(struct fw_csr_iterator *ci, u32 *p);
 int fw_csr_iterator_next(struct fw_csr_iterator *ci, int *key, int *value);
-
 int fw_csr_string(u32 *directory, int key, char *buf, size_t size);
 
 extern struct bus_type fw_bus_type;

-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/

