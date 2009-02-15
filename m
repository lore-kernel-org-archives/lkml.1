Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZBOWNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZBOWNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 17:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZBOWMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 17:12:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53332 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZBOWMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 17:12:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 15 Feb 2009 23:12:34 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: share device ID table type with ieee1394
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.4edc17c763388731@s5r6.in-berlin.de>
Message-ID: <tkrat.6baddae7f9b6e800@s5r6.in-berlin.de>
References: <tkrat.4edc17c763388731@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That way, the new firedtv driver will be able to use a single ID table
in builds against ieee1394 core and/or against firewire core.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |   16 +++++++++-------
 drivers/firewire/fw-device.h |   19 +++----------------
 drivers/firewire/fw-sbp2.c   |    5 +++--
 3 files changed, 15 insertions(+), 25 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -26,6 +26,7 @@
 #include <linux/jiffies.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
+#include <linux/mod_devicetable.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/semaphore.h>
@@ -57,7 +58,8 @@ EXPORT_SYMBOL(fw_csr_iterator_next);
 
 static int is_fw_unit(struct device *dev);
 
-static int match_unit_directory(u32 * directory, const struct fw_device_id *id)
+static int match_unit_directory(u32 *directory,
+				const struct ieee1394_device_id *id)
 {
 	struct fw_csr_iterator ci;
 	int key, value, match;
@@ -65,14 +67,14 @@ static int match_unit_directory(u32 * di
 	match = 0;
 	fw_csr_iterator_init(&ci, directory);
 	while (fw_csr_iterator_next(&ci, &key, &value)) {
-		if (key == CSR_VENDOR && value == id->vendor)
-			match |= FW_MATCH_VENDOR;
-		if (key == CSR_MODEL && value == id->model)
-			match |= FW_MATCH_MODEL;
+		if (key == CSR_VENDOR && value == id->vendor_id)
+			match |= IEEE1394_MATCH_VENDOR_ID;
+		if (key == CSR_MODEL && value == id->model_id)
+			match |= IEEE1394_MATCH_MODEL_ID;
 		if (key == CSR_SPECIFIER_ID && value == id->specifier_id)
-			match |= FW_MATCH_SPECIFIER_ID;
+			match |= IEEE1394_MATCH_SPECIFIER_ID;
 		if (key == CSR_VERSION && value == id->version)
-			match |= FW_MATCH_VERSION;
+			match |= IEEE1394_MATCH_VERSION;
 	}
 
 	return (match & id->match_flags) == id->match_flags;
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -24,6 +24,7 @@
 #include <linux/idr.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/mod_devicetable.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/sysfs.h>
@@ -168,25 +169,11 @@ void fw_csr_iterator_init(struct fw_csr_
 int fw_csr_iterator_next(struct fw_csr_iterator *ci,
 			 int *key, int *value);
 
-#define FW_MATCH_VENDOR		0x0001
-#define FW_MATCH_MODEL		0x0002
-#define FW_MATCH_SPECIFIER_ID	0x0004
-#define FW_MATCH_VERSION	0x0008
-
-struct fw_device_id {
-	u32 match_flags;
-	u32 vendor;
-	u32 model;
-	u32 specifier_id;
-	u32 version;
-	void *driver_data;
-};
-
 struct fw_driver {
 	struct device_driver driver;
 	/* Called when the parent device sits through a bus reset. */
-	void (*update) (struct fw_unit *unit);
-	const struct fw_device_id *id_table;
+	void (*update)(struct fw_unit *unit);
+	const struct ieee1394_device_id *id_table;
 };
 
 static inline struct fw_driver *fw_driver(struct device_driver *drv)
Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -1259,9 +1259,10 @@ static void sbp2_update(struct fw_unit *
 #define SBP2_UNIT_SPEC_ID_ENTRY	0x0000609e
 #define SBP2_SW_VERSION_ENTRY	0x00010483
 
-static const struct fw_device_id sbp2_id_table[] = {
+static const struct ieee1394_device_id sbp2_id_table[] = {
 	{
-		.match_flags  = FW_MATCH_SPECIFIER_ID | FW_MATCH_VERSION,
+		.match_flags  = IEEE1394_MATCH_SPECIFIER_ID |
+				IEEE1394_MATCH_VERSION,
 		.specifier_id = SBP2_UNIT_SPEC_ID_ENTRY,
 		.version      = SBP2_SW_VERSION_ENTRY,
 	},

-- 
Stefan Richter
-=====-==--= --=- -====
http://arcgraph.de/sr/

