Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbYBCWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbYBCWFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 17:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYBCWEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 17:04:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47698 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYBCWEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 17:04:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 3 Feb 2008 23:04:38 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/9] firewire: fw-sbp2: add INQUIRY delay workaround
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
Message-ID: <tkrat.b8a4817b51d0c9c9@s5r6.in-berlin.de>
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several different SBP-2 bridges accept a login early while the IDE
device is still powering up.  They are therefore unable to respond to
SCSI INQUIRY immediately, and the SCSI core has to retry the INQUIRY.
One of these retries is typically successful, and all is well.

But in case of Momobay FX-3A, the INQUIRY retries tend to fail entirely.
This can usually be avoided by waiting a little while after login before
letting the SCSI core send the INQUIRY.  The old sbp2 driver handles
this more gracefully for as yet unknown reasons (perhaps because it
waits for fetch agent resets to complete, unlike fw-sbp2 which quickly
proceeds after requesting the agent reset).  Therefore the workaround is
not as much necessary for sbp2.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/mod_devicetable.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
@@ -82,6 +83,9 @@ MODULE_PARM_DESC(exclusive_login, "Exclu
  *   Avoids access beyond actual disk limits on devices with an off-by-one bug.
  *   Don't use this with devices which don't have this bug.
  *
+ * - delay inquiry
+ *   Wait extra SBP2_INQUIRY_DELAY seconds after login before SCSI inquiry.
+ *
  * - override internal blacklist
  *   Instead of adding to the built-in blacklist, use only the workarounds
  *   specified in the module load parameter.
@@ -91,6 +95,8 @@ MODULE_PARM_DESC(exclusive_login, "Exclu
 #define SBP2_WORKAROUND_INQUIRY_36	0x2
 #define SBP2_WORKAROUND_MODE_SENSE_8	0x4
 #define SBP2_WORKAROUND_FIX_CAPACITY	0x8
+#define SBP2_WORKAROUND_DELAY_INQUIRY	0x10
+#define SBP2_INQUIRY_DELAY		12
 #define SBP2_WORKAROUND_OVERRIDE	0x100
 
 static int sbp2_param_workarounds;
@@ -100,6 +106,7 @@ MODULE_PARM_DESC(workarounds, "Work arou
 	", 36 byte inquiry = "    __stringify(SBP2_WORKAROUND_INQUIRY_36)
 	", skip mode page 8 = "   __stringify(SBP2_WORKAROUND_MODE_SENSE_8)
 	", fix capacity = "       __stringify(SBP2_WORKAROUND_FIX_CAPACITY)
+	", delay inquiry = "      __stringify(SBP2_WORKAROUND_DELAY_INQUIRY)
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
@@ -303,6 +310,11 @@ static const struct {
 		.workarounds		= SBP2_WORKAROUND_INQUIRY_36 |
 					  SBP2_WORKAROUND_MODE_SENSE_8,
 	},
+	/* DViCO Momobay FX-3A with TSB42AA9A bridge */ {
+		.firmware_revision	= 0x002800,
+		.model			= 0x000000,
+		.workarounds		= SBP2_WORKAROUND_DELAY_INQUIRY,
+	},
 	/* Initio bridges, actually only needed for some older ones */ {
 		.firmware_revision	= 0x000200,
 		.model			= ~0,
@@ -712,6 +724,9 @@ static void sbp2_login(struct work_struc
 	PREPARE_DELAYED_WORK(&lu->work, sbp2_reconnect);
 	sbp2_agent_reset(lu);
 
+	if (lu->tgt->workarounds & SBP2_WORKAROUND_DELAY_INQUIRY)
+		ssleep(SBP2_INQUIRY_DELAY);
+
 	memset(&eight_bytes_lun, 0, sizeof(eight_bytes_lun));
 	eight_bytes_lun.scsi_lun[0] = (lu->lun >> 8) & 0xff;
 	eight_bytes_lun.scsi_lun[1] = lu->lun & 0xff;

-- 
Stefan Richter
-=====-==--- --=- ---==
http://arcgraph.de/sr/

