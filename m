Return-Path: <linux-kernel-owner+w=401wt.eu-S1757578AbZLZAmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbZLZAmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbZLZAmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:42:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53628 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbZLZAmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:42:51 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Dec 2009 01:42:28 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/3 resend] firewire: add fw_csr_string() helper function
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
       Clemens Ladisch <cladisch@fastmail.net>
In-Reply-To: <tkrat.d7a89db5096e31cd@s5r6.in-berlin.de>
Message-ID: <tkrat.033aeb4c3d7dc6d0@s5r6.in-berlin.de>
References: <tkrat.d7a89db5096e31cd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Thu, 24 Dec 2009 11:59:57 +0100
From: Clemens Ladisch <clemens@ladisch.de>

The core (sysfs attributes), the firedtv driver, and possible future
drivers all read strings from some configuration ROM directory.  Factor
out the generic code from show_text_leaf() into a new helper function,
modified slightly to handle arbitrary buffer sizes.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c          |  110 +++++++++++++++++-------
 drivers/media/dvb/firewire/firedtv-fw.c |   39 +--------
 include/linux/firewire.h                |    2 +
 3 files changed, 84 insertions(+), 67 deletions(-)

Index: linux-2.6.33-rc2/include/linux/firewire.h
===================================================================
--- linux-2.6.33-rc2.orig/include/linux/firewire.h
+++ linux-2.6.33-rc2/include/linux/firewire.h
@@ -72,6 +72,8 @@ struct fw_csr_iterator {
 void fw_csr_iterator_init(struct fw_csr_iterator *ci, u32 *p);
 int fw_csr_iterator_next(struct fw_csr_iterator *ci, int *key, int *value);
 
+int fw_csr_string(u32 *directory, int key, char *buf, size_t size);
+
 extern struct bus_type fw_bus_type;
 
 struct fw_card_driver;
Index: linux-2.6.33-rc2/drivers/firewire/core-device.c
===================================================================
--- linux-2.6.33-rc2.orig/drivers/firewire/core-device.c
+++ linux-2.6.33-rc2/drivers/firewire/core-device.c
@@ -59,6 +59,67 @@ int fw_csr_iterator_next(struct fw_csr_i
 }
 EXPORT_SYMBOL(fw_csr_iterator_next);
 
+static u32 *search_leaf(u32 *directory, int search_key)
+{
+	struct fw_csr_iterator ci;
+	int last_key = 0, key, value;
+
+	fw_csr_iterator_init(&ci, directory);
+	while (fw_csr_iterator_next(&ci, &key, &value)) {
+		if (last_key == search_key &&
+		    key == (CSR_DESCRIPTOR | CSR_LEAF))
+			return ci.p - 1 + value;
+		last_key = key;
+	}
+	return NULL;
+}
+
+static int textual_leaf_to_string(u32 *block, char *buf, size_t size)
+{
+	unsigned int quadlets, length;
+
+	if (!size || !buf)
+		return -EINVAL;
+
+	quadlets = min(block[0] >> 16, 256u);
+	if (quadlets < 2)
+		return -ENODATA;
+
+	if (block[1] != 0 || block[2] != 0)
+		/* unknown language/character set */
+		return -ENODATA;
+
+	block += 3;
+	quadlets -= 2;
+	for (length = 0; length < quadlets * 4 && length + 1 < size; length++) {
+		char c = block[length / 4] >> (24 - 8 * (length % 4));
+		if (c == '\0')
+			break;
+		buf[length] = c;
+	}
+	buf[length] = '\0';
+	return length;
+}
+
+/**
+ * fw_csr_string - reads a string from the configuration ROM
+ * @directory: device or unit directory;
+ *             fw_device->config_rom+5 or fw_unit->directory
+ * @key: the key of the preceding directory entry
+ * @buf: where to put the string
+ * @size: size of @buf, in bytes
+ *
+ * Returns string length (>= 0) or error code (< 0).
+ */
+int fw_csr_string(u32 *directory, int key, char *buf, size_t size)
+{
+	u32 *leaf = search_leaf(directory, key);
+	if (!leaf)
+		return -ENOENT;
+	return textual_leaf_to_string(leaf, buf, size);
+}
+EXPORT_SYMBOL(fw_csr_string);
+
 static bool is_fw_unit(struct device *dev);
 
 static int match_unit_directory(u32 *directory, u32 match_flags,
@@ -226,10 +287,10 @@ static ssize_t show_text_leaf(struct dev
 {
 	struct config_rom_attribute *attr =
 		container_of(dattr, struct config_rom_attribute, attr);
-	struct fw_csr_iterator ci;
-	u32 *dir, *block = NULL, *p, *end;
-	int length, key, value, last_key = 0, ret = -ENOENT;
-	char *b;
+	u32 *dir;
+	size_t bufsize;
+	char dummy_buf[2];
+	int ret;
 
 	down_read(&fw_device_rwsem);
 
@@ -238,40 +299,23 @@ static ssize_t show_text_leaf(struct dev
 	else
 		dir = fw_device(dev)->config_rom + 5;
 
-	fw_csr_iterator_init(&ci, dir);
-	while (fw_csr_iterator_next(&ci, &key, &value)) {
-		if (attr->key == last_key &&
-		    key == (CSR_DESCRIPTOR | CSR_LEAF))
-			block = ci.p - 1 + value;
-		last_key = key;
+	if (buf) {
+		bufsize = PAGE_SIZE - 1;
+	} else {
+		buf = dummy_buf;
+		bufsize = 1;
 	}
 
-	if (block == NULL)
-		goto out;
-
-	length = min(block[0] >> 16, 256U);
-	if (length < 3)
-		goto out;
-
-	if (block[1] != 0 || block[2] != 0)
-		/* Unknown encoding. */
-		goto out;
+	ret = fw_csr_string(dir, attr->key, buf, bufsize);
 
-	if (buf == NULL) {
-		ret = length * 4;
-		goto out;
+	if (ret >= 0) {
+		/* Strip trailing whitespace and add newline. */
+		while (ret > 0 && isspace(buf[ret - 1]))
+			ret--;
+		strcpy(buf + ret, "\n");
+		ret++;
 	}
 
-	b = buf;
-	end = &block[length + 1];
-	for (p = &block[3]; p < end; p++, b += 4)
-		* (u32 *) b = (__force u32) __cpu_to_be32(*p);
-
-	/* Strip trailing whitespace and add newline. */
-	while (b--, (isspace(*b) || *b == '\0') && b > buf);
-	strcpy(b + 1, "\n");
-	ret = b + 2 - buf;
- out:
 	up_read(&fw_device_rwsem);
 
 	return ret;
Index: linux-2.6.33-rc2/drivers/media/dvb/firewire/firedtv-fw.c
===================================================================
--- linux-2.6.33-rc2.orig/drivers/media/dvb/firewire/firedtv-fw.c
+++ linux-2.6.33-rc2/drivers/media/dvb/firewire/firedtv-fw.c
@@ -239,47 +239,18 @@ static const struct fw_address_region fc
 };
 
 /* Adjust the template string if models with longer names appear. */
-#define MAX_MODEL_NAME_LEN ((int)DIV_ROUND_UP(sizeof("FireDTV ????"), 4))
-
-static size_t model_name(u32 *directory, __be32 *buffer)
-{
-	struct fw_csr_iterator ci;
-	int i, length, key, value, last_key = 0;
-	u32 *block = NULL;
-
-	fw_csr_iterator_init(&ci, directory);
-	while (fw_csr_iterator_next(&ci, &key, &value)) {
-		if (last_key == CSR_MODEL &&
-		    key == (CSR_DESCRIPTOR | CSR_LEAF))
-			block = ci.p - 1 + value;
-		last_key = key;
-	}
-
-	if (block == NULL)
-		return 0;
-
-	length = min((int)(block[0] >> 16) - 2, MAX_MODEL_NAME_LEN);
-	if (length <= 0)
-		return 0;
-
-	/* fast-forward to text string */
-	block += 3;
-
-	for (i = 0; i < length; i++)
-		buffer[i] = cpu_to_be32(block[i]);
-
-	return length * 4;
-}
+#define MAX_MODEL_NAME_LEN sizeof("FireDTV ????")
 
 static int node_probe(struct device *dev)
 {
 	struct firedtv *fdtv;
-	__be32 name[MAX_MODEL_NAME_LEN];
+	char name[MAX_MODEL_NAME_LEN];
 	int name_len, err;
 
-	name_len = model_name(fw_unit(dev)->directory, name);
+	name_len = fw_csr_string(fw_unit(dev)->directory, CSR_MODEL,
+				 name, sizeof(name));
 
-	fdtv = fdtv_alloc(dev, &backend, (char *)name, name_len);
+	fdtv = fdtv_alloc(dev, &backend, name, name_len >= 0 ? name_len : 0);
 	if (!fdtv)
 		return -ENOMEM;
 

-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/

