Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbZAXSob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbZAXSob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 13:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbZAXSoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 13:44:22 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57576 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZAXSoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 13:44:21 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 Jan 2009 19:44:12 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/7] ieee1394: sbp2: don't assume zero model_id or
 firmware_revision if there is none
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
Message-ID: <tkrat.0f00c754d7905d2c@s5r6.in-berlin.de>
References: <tkrat.6fe4fe5b72231863@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sbp2 behave more like firewire-sbp2 which reports 0xff000000
as immediate value if there are no unit directory entries for model_id
or firmware_revision.

It does not reduce matches with the currently existing quirks table; the
only zero entry there is for a device which actually does have a zero
model_id.  It only changes how model_id and firmware_revision are logged
if they are missing.

Other functionally unrelated changes:  The model_id member of quirks
list entries is renamed to model;  the value (but not teh effect) of
SBP2_ROM_VALUE_WILDCARD is changed.  Now this part of the source is
identical with firewire-sbp2 for easier maintenance.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -347,8 +347,8 @@ static struct scsi_host_template sbp2_sh
 	.sdev_attrs		 = sbp2_sysfs_sdev_attrs,
 };
 
-/* for match-all entries in sbp2_workarounds_table */
-#define SBP2_ROM_VALUE_WILDCARD 0x1000000
+#define SBP2_ROM_VALUE_WILDCARD ~0         /* match all */
+#define SBP2_ROM_VALUE_MISSING  0xff000000 /* not present in the unit dir. */
 
 /*
  * List of devices with known bugs.
@@ -359,60 +359,60 @@ static struct scsi_host_template sbp2_sh
  */
 static const struct {
 	u32 firmware_revision;
-	u32 model_id;
+	u32 model;
 	unsigned workarounds;
 } sbp2_workarounds_table[] = {
 	/* DViCO Momobay CX-1 with TSB42AA9 bridge */ {
 		.firmware_revision	= 0x002800,
-		.model_id		= 0x001010,
+		.model			= 0x001010,
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36 |
 					  SBP2_WORKAROUND_MODE_SENSE_8 |
 					  SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* DViCO Momobay FX-3A with TSB42AA9A bridge */ {
 		.firmware_revision	= 0x002800,
-		.model_id		= 0x000000,
+		.model			= 0x000000,
 		.workarounds		= SBP2_WORKAROUND_DELAY_INQUIRY |
 					  SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,
-		.model_id		= SBP2_ROM_VALUE_WILDCARD,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36,
 	},
 	/* PL-3507 bridge with Prolific firmware */ {
 		.firmware_revision	= 0x012800,
-		.model_id		= SBP2_ROM_VALUE_WILDCARD,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_POWER_CONDITION,
 	},
 	/* Symbios bridge */ {
 		.firmware_revision	= 0xa0b800,
-		.model_id		= SBP2_ROM_VALUE_WILDCARD,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
 	/* Datafab MD2-FW2 with Symbios/LSILogic SYM13FW500 bridge */ {
 		.firmware_revision	= 0x002600,
-		.model_id		= SBP2_ROM_VALUE_WILDCARD,
+		.model			= SBP2_ROM_VALUE_WILDCARD,
 		.workarounds		= SBP2_WORKAROUND_128K_MAX_TRANS,
 	},
 	/* iPod 4th generation */ {
 		.firmware_revision	= 0x0a2700,
-		.model_id		= 0x000021,
+		.model			= 0x000021,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},
 	/* iPod mini */ {
 		.firmware_revision	= 0x0a2700,
-		.model_id		= 0x000022,
+		.model			= 0x000022,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},
 	/* iPod mini */ {
 		.firmware_revision	= 0x0a2700,
-		.model_id		= 0x000023,
+		.model			= 0x000023,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	},
 	/* iPod Photo */ {
 		.firmware_revision	= 0x0a2700,
-		.model_id		= 0x00007e,
+		.model			= 0x00007e,
 		.workarounds		= SBP2_WORKAROUND_FIX_CAPACITY,
 	}
 };
@@ -1341,13 +1341,15 @@ static void sbp2_parse_unit_directory(st
 	struct csr1212_keyval *kv;
 	struct csr1212_dentry *dentry;
 	u64 management_agent_addr;
-	u32 unit_characteristics, firmware_revision;
+	u32 unit_characteristics, firmware_revision, model;
 	unsigned workarounds;
 	int i;
 
 	management_agent_addr = 0;
 	unit_characteristics = 0;
-	firmware_revision = 0;
+	firmware_revision = SBP2_ROM_VALUE_MISSING;
+	model = ud->flags & UNIT_DIRECTORY_MODEL_ID ?
+				ud->model_id : SBP2_ROM_VALUE_MISSING;
 
 	csr1212_for_each_dir_entry(ud->ne->csr, kv, ud->ud_kv, dentry) {
 		switch (kv->key.id) {
@@ -1388,9 +1390,9 @@ static void sbp2_parse_unit_directory(st
 			    sbp2_workarounds_table[i].firmware_revision !=
 			    (firmware_revision & 0xffff00))
 				continue;
-			if (sbp2_workarounds_table[i].model_id !=
+			if (sbp2_workarounds_table[i].model !=
 			    SBP2_ROM_VALUE_WILDCARD &&
-			    sbp2_workarounds_table[i].model_id != ud->model_id)
+			    sbp2_workarounds_table[i].model != model)
 				continue;
 			workarounds |= sbp2_workarounds_table[i].workarounds;
 			break;
@@ -1403,7 +1405,7 @@ static void sbp2_parse_unit_directory(st
 			  NODE_BUS_ARGS(ud->ne->host, ud->ne->nodeid),
 			  workarounds, firmware_revision,
 			  ud->vendor_id ? ud->vendor_id : ud->ne->vendor_id,
-			  ud->model_id);
+			  model);
 
 	/* We would need one SCSI host template for each target to adjust
 	 * max_sectors on the fly, therefore warn only. */

-- 
Stefan Richter
-=====-==--= ---= ==---
http://arcgraph.de/sr/

