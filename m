Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYBCWIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYBCWIH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYBCWHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:07:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47778 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYBCWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:07:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2008 23:07:44 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/9] ieee1394: sbp2: add INQUIRY delay workaround
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
Message-ID: <tkrat.671012af0e073ed0@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the same workaround as found in fw-sbp2 for feature parity and
compatibility of the workarounds module parameter.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   12 ++++++++++++
 drivers/ieee1394/sbp2.h |    2 ++
 2 files changed, 14 insertions(+)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -183,6 +183,9 @@ MODULE_PARM_DESC(exclusive_login, "Exclu
  *   Avoids access beyond actual disk limits on devices with an off-by-one bug.
  *   Don't use this with devices which don't have this bug.
  *
+ * - delay inquiry
+ *   Wait extra SBP2_INQUIRY_DELAY seconds after login before SCSI inquiry.
+ *
  * - override internal blacklist
  *   Instead of adding to the built-in blacklist, use only the workarounds
  *   specified in the module load parameter.
@@ -195,6 +198,7 @@ MODULE_PARM_DESC(workarounds, "Work arou
 	", 36 byte inquiry = "    __stringify(SBP2_WORKAROUND_INQUIRY_36)
 	", skip mode page 8 = "   __stringify(SBP2_WORKAROUND_MODE_SENSE_8)
 	", fix capacity = "       __stringify(SBP2_WORKAROUND_FIX_CAPACITY)
+	", delay inquiry = "      __stringify(SBP2_WORKAROUND_DELAY_INQUIRY)
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
@@ -357,6 +361,11 @@ static const struct {
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36 |
 					  SBP2_WORKAROUND_MODE_SENSE_8,
 	},
+	/* DViCO Momobay FX-3A with TSB42AA9A bridge */ {
+		.firmware_revision	= 0x002800,
+		.model_id		= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_DELAY_INQUIRY,
+	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,
 		.model_id		= SBP2_ROM_VALUE_WILDCARD,
@@ -914,6 +923,9 @@ static int sbp2_start_device(struct sbp2
 	sbp2_agent_reset(lu, 1);
 	sbp2_max_speed_and_size(lu);
 
+	if (lu->workarounds & SBP2_WORKAROUND_DELAY_INQUIRY)
+		ssleep(SBP2_INQUIRY_DELAY);
+
 	error = scsi_add_device(lu->shost, 0, lu->ud->id, 0);
 	if (error) {
 		SBP2_ERR("scsi_add_device failed");
Index: linux/drivers/ieee1394/sbp2.h
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.h
+++ linux/drivers/ieee1394/sbp2.h
@@ -343,6 +343,8 @@ enum sbp2lu_state_types {
 #define SBP2_WORKAROUND_INQUIRY_36	0x2
 #define SBP2_WORKAROUND_MODE_SENSE_8	0x4
 #define SBP2_WORKAROUND_FIX_CAPACITY	0x8
+#define SBP2_WORKAROUND_DELAY_INQUIRY	0x10
+#define SBP2_INQUIRY_DELAY		12
 #define SBP2_WORKAROUND_OVERRIDE	0x100
 
 #endif /* SBP2_H */

-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

