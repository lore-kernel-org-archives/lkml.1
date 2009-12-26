Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbZLZAoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbZLZAoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbZLZAob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:44:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53634 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366AbZLZAoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:44:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Dec 2009 01:44:10 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/3] firewire: qualify config ROM cache pointers as const
 pointers
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
       Clemens Ladisch <cladisch@fastmail.net>
In-Reply-To: <tkrat.d7a89db5096e31cd@s5r6.in-berlin.de>
Message-ID: <tkrat.ed128dbc60c26f4f@s5r6.in-berlin.de>
References: <tkrat.d7a89db5096e31cd@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several config ROM related functions only peek at the ROM cache; mark
their arguments as const pointers.  Ditto fw_device.config_rom and
fw_unit.directory, as the memory behind them is meant to be write-once.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |   21 +++++++++++----------
 drivers/firewire/sbp2.c        |    5 +++--
 include/linux/firewire.h       |   12 ++++++------
 3 files changed, 20 insertions(+), 18 deletions(-)

Index: linux-2.6.33-rc2/drivers/firewire/core-device.c
===================================================================
--- linux-2.6.33-rc2.orig/drivers/firewire/core-device.c
+++ linux-2.6.33-rc2/drivers/firewire/core-device.c
@@ -43,7 +43,7 @@
 
 #include "core.h"
 
-void fw_csr_iterator_init(struct fw_csr_iterator *ci, u32 * p)
+void fw_csr_iterator_init(struct fw_csr_iterator *ci, const u32 *p)
 {
 	ci->p = p + 1;
 	ci->end = ci->p + (p[0] >> 16);
@@ -59,7 +59,7 @@ int fw_csr_iterator_next(struct fw_csr_i
 }
 EXPORT_SYMBOL(fw_csr_iterator_next);
 
-static u32 *search_leaf(u32 *directory, int search_key)
+static const u32 *search_leaf(const u32 *directory, int search_key)
 {
 	struct fw_csr_iterator ci;
 	int last_key = 0, key, value;
@@ -76,7 +76,7 @@ static u32 *search_leaf(u32 *directory, 
 	return NULL;
 }
 
-static int textual_leaf_to_string(u32 *block, char *buf, size_t size)
+static int textual_leaf_to_string(const u32 *block, char *buf, size_t size)
 {
 	unsigned int quadlets, i;
 	char c;
@@ -116,9 +116,9 @@ static int textual_leaf_to_string(u32 *b
  * the immediate entry with @key.  The string is zero-terminated.
  * Returns strlen(buf) or a negative error code.
  */
-int fw_csr_string(u32 *directory, int key, char *buf, size_t size)
+int fw_csr_string(const u32 *directory, int key, char *buf, size_t size)
 {
-	u32 *leaf = search_leaf(directory, key);
+	const u32 *leaf = search_leaf(directory, key);
 	if (!leaf)
 		return -ENOENT;
 
@@ -128,7 +128,7 @@ EXPORT_SYMBOL(fw_csr_string);
 
 static bool is_fw_unit(struct device *dev);
 
-static int match_unit_directory(u32 *directory, u32 match_flags,
+static int match_unit_directory(const u32 *directory, u32 match_flags,
 				const struct ieee1394_device_id *id)
 {
 	struct fw_csr_iterator ci;
@@ -262,7 +262,7 @@ static ssize_t show_immediate(struct dev
 	struct config_rom_attribute *attr =
 		container_of(dattr, struct config_rom_attribute, attr);
 	struct fw_csr_iterator ci;
-	u32 *dir;
+	const u32 *dir;
 	int key, value, ret = -ENOENT;
 
 	down_read(&fw_device_rwsem);
@@ -293,7 +293,7 @@ static ssize_t show_text_leaf(struct dev
 {
 	struct config_rom_attribute *attr =
 		container_of(dattr, struct config_rom_attribute, attr);
-	u32 *dir;
+	const u32 *dir;
 	size_t bufsize;
 	char dummy_buf[2];
 	int ret;
@@ -421,7 +421,7 @@ static ssize_t guid_show(struct device *
 	return ret;
 }
 
-static int units_sprintf(char *buf, u32 *directory)
+static int units_sprintf(char *buf, const u32 *directory)
 {
 	struct fw_csr_iterator ci;
 	int key, value;
@@ -503,7 +503,8 @@ static int read_rom(struct fw_device *de
  */
 static int read_bus_info_block(struct fw_device *device, int generation)
 {
-	u32 *rom, *stack, *old_rom, *new_rom;
+	const u32 *old_rom, *new_rom;
+	u32 *rom, *stack;
 	u32 sp, key;
 	int i, end, length, ret = -1;
 
Index: linux-2.6.33-rc2/drivers/firewire/sbp2.c
===================================================================
--- linux-2.6.33-rc2.orig/drivers/firewire/sbp2.c
+++ linux-2.6.33-rc2/drivers/firewire/sbp2.c
@@ -1014,7 +1014,8 @@ static int sbp2_add_logical_unit(struct 
 	return 0;
 }
 
-static int sbp2_scan_logical_unit_dir(struct sbp2_target *tgt, u32 *directory)
+static int sbp2_scan_logical_unit_dir(struct sbp2_target *tgt,
+				      const u32 *directory)
 {
 	struct fw_csr_iterator ci;
 	int key, value;
@@ -1027,7 +1028,7 @@ static int sbp2_scan_logical_unit_dir(st
 	return 0;
 }
 
-static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
+static int sbp2_scan_unit_dir(struct sbp2_target *tgt, const u32 *directory,
 			      u32 *model, u32 *firmware_revision)
 {
 	struct fw_csr_iterator ci;
Index: linux-2.6.33-rc2/include/linux/firewire.h
===================================================================
--- linux-2.6.33-rc2.orig/include/linux/firewire.h
+++ linux-2.6.33-rc2/include/linux/firewire.h
@@ -65,13 +65,13 @@
 #define CSR_DIRECTORY_ID	0x20
 
 struct fw_csr_iterator {
-	u32 *p;
-	u32 *end;
+	const u32 *p;
+	const u32 *end;
 };
 
-void fw_csr_iterator_init(struct fw_csr_iterator *ci, u32 *p);
+void fw_csr_iterator_init(struct fw_csr_iterator *ci, const u32 *p);
 int fw_csr_iterator_next(struct fw_csr_iterator *ci, int *key, int *value);
-int fw_csr_string(u32 *directory, int key, char *buf, size_t size);
+int fw_csr_string(const u32 *directory, int key, char *buf, size_t size);
 
 extern struct bus_type fw_bus_type;
 
@@ -163,7 +163,7 @@ struct fw_device {
 	struct mutex client_list_mutex;
 	struct list_head client_list;
 
-	u32 *config_rom;
+	const u32 *config_rom;
 	size_t config_rom_length;
 	int config_rom_retries;
 	unsigned is_local:1;
@@ -205,7 +205,7 @@ int fw_device_enable_phys_dma(struct fw_
  */
 struct fw_unit {
 	struct device device;
-	u32 *directory;
+	const u32 *directory;
 	struct fw_attribute_group attribute_group;
 };
 

-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/

