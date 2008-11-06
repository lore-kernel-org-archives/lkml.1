Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbYKFUMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbYKFUMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYKFUMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:12:17 -0500
Received: from mail.tpi.com ([198.107.51.143]:3551 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYKFUMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:12:17 -0500
To: mike.miller@hp.com
Subject: [PATCH] cciss: firmware version is invalid
Cc: bryan.stillwell@hp.com, iss_storagedev@hp.com,
       linux-kernel@vger.kernel.org
Message-Id: <20081106201204.9C2AEF8A65@sepang.rtg.net>
Date: Thu,  6 Nov 2008 13:12:04 -0700 (MST)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b659b0b0e14f5e3c049bf5c8d2883587cdbfe344 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Thu, 6 Nov 2008 12:34:25 -0700
Subject: [PATCH] cciss: Firmware Version is invalid
 OriginalAuthor: bryan.stillwell@hp.com
 OriginalLocation: http://launchpadlibrarian.net/18582511/cciss_firmware_version_fix.patch
 Bug: https://bugs.launchpad.net/bugs/284031

Emit a CISS_INQUIRY command to read the firmware version.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Cc: stable@kernel.org
---
 drivers/block/cciss.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b73116e..844b806 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1631,6 +1631,7 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 	int ctlr = h->ctlr;
 	int num_luns;
 	ReportLunData_struct *ld_buff = NULL;
+	InquiryData_struct *inq_buff = NULL;
 	int return_code;
 	int listlength = 0;
 	int i;
@@ -1651,6 +1652,26 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 	h->busy_configuring = 1;
 	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 
+	inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
+	if (inq_buff == NULL) {
+		printk(KERN_ERR "cciss: out of memory\n");
+		return ENOMEM;
+	}
+
+	/* Get the firmware version */
+	return_code = sendcmd_withirq(CISS_INQUIRY, ctlr, inq_buff,
+		sizeof(InquiryData_struct), 0, 0 ,0, TYPE_CMD);
+	if (return_code == IO_OK) {
+		h->firm_ver[0] = inq_buff->data_byte[32];
+		h->firm_ver[1] = inq_buff->data_byte[33];
+		h->firm_ver[2] = inq_buff->data_byte[34];
+		h->firm_ver[3] = inq_buff->data_byte[35];
+	} else {         /* send command failed */
+		printk(KERN_WARNING "cciss: unable to determine firmware"
+			" version of controller\n");
+	}
+
+	/* Get the number of logical volumes */
 	ld_buff = kzalloc(sizeof(ReportLunData_struct), GFP_KERNEL);
 	if (ld_buff == NULL)
 		goto mem_msg;
-- 
1.5.6.3

