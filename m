Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZBOXWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZBOXWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 18:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZBOXWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 18:22:35 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53557 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651AbZBOXWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 18:22:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 16 Feb 2009 00:22:05 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: also use vendor ID in root directory for driver
 matches
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.6baddae7f9b6e800@s5r6.in-berlin.de>
Message-ID: <tkrat.b352d0d82f46f560@s5r6.in-berlin.de>
References: <tkrat.4edc17c763388731@s5r6.in-berlin.de>
 <tkrat.6baddae7f9b6e800@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to AV/C protocol extensions, FireDTV devices need a vendor-specific
driver.  But their configuration ROM features a vendor ID only in the
root directory, not in the unit directory.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -58,7 +58,7 @@ EXPORT_SYMBOL(fw_csr_iterator_next);
 
 static int is_fw_unit(struct device *dev);
 
-static int match_unit_directory(u32 *directory,
+static int match_unit_directory(u32 *directory, u32 match_flags,
 				const struct ieee1394_device_id *id)
 {
 	struct fw_csr_iterator ci;
@@ -77,21 +77,31 @@ static int match_unit_directory(u32 *dir
 			match |= IEEE1394_MATCH_VERSION;
 	}
 
-	return (match & id->match_flags) == id->match_flags;
+	return (match & match_flags) == match_flags;
 }
 
 static int fw_unit_match(struct device *dev, struct device_driver *drv)
 {
 	struct fw_unit *unit = fw_unit(dev);
-	struct fw_driver *driver = fw_driver(drv);
-	int i;
+	struct fw_device *device;
+	const struct ieee1394_device_id *id;
 
 	/* We only allow binding to fw_units. */
 	if (!is_fw_unit(dev))
 		return 0;
 
-	for (i = 0; driver->id_table[i].match_flags != 0; i++) {
-		if (match_unit_directory(unit->directory, &driver->id_table[i]))
+	device = fw_device(unit->device.parent);
+
+	for (id = fw_driver(drv)->id_table; id->match_flags != 0; id++) {
+		if (match_unit_directory(unit->directory, id->match_flags, id))
+			return 1;
+
+		/* Also check vendor ID in the root directory. */
+		if ((id->match_flags & IEEE1394_MATCH_VENDOR_ID) &&
+		    match_unit_directory(&device->config_rom[5],
+				IEEE1394_MATCH_VENDOR_ID, id) &&
+		    match_unit_directory(unit->directory, id->match_flags
+				& ~IEEE1394_MATCH_VENDOR_ID, id))
 			return 1;
 	}
 

-- 
Stefan Richter
-=====-==--= --=- =----
http://arcgraph.de/sr/

