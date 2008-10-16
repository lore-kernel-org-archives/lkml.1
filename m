Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbYJPWtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbYJPWtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYJPWs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:48:59 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44493 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbYJPWs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:48:59 -0400
Date: Thu, 16 Oct 2008 17:48:58 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/2] cciss: fix regression firmware version not displayed in procfs (again)
Message-ID: <20081016224858.GB26564@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2 of 2

The regression was introduced by commit
6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
This patch fixes a regression where the controller firmware version is not
displayed in procfs. The previous patch would be called anytime something
changed. This will get called only once for each controller.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0f367b1..1c830bd 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3404,7 +3404,8 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	int i;
 	int j = 0;
 	int rc;
-	int dac;
+	int dac, return_code;
+	InquiryData_struct *inq_buff = NULL;
 
 	i = alloc_cciss_hba();
 	if (i < 0)
@@ -3510,6 +3511,25 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	/* Turn the interrupts on so we can service requests */
 	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_ON);
 
+	/* Get the firmware version */
+	inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
+	if (inq_buff == NULL) {
+		printk(KERN_ERR "cciss: out of memory\n");
+		return -ENOMEM;
+	}
+
+	return_code = sendcmd_withirq(CISS_INQUIRY, i, inq_buff,
+		sizeof(InquiryData_struct), 0, 0 , 0, TYPE_CMD);
+	if (return_code == IO_OK) {
+		hba[i]->firm_ver[0] = inq_buff->data_byte[32];
+		hba[i]->firm_ver[1] = inq_buff->data_byte[33];
+		hba[i]->firm_ver[2] = inq_buff->data_byte[34];
+		hba[i]->firm_ver[3] = inq_buff->data_byte[35];
+	} else {	 /* send command failed */
+		printk(KERN_WARNING "cciss: unable to determine firmware"
+			" version of controller\n");
+	}
+
 	cciss_procinit(i);
 
 	hba[i]->cciss_max_sectors = 2048;
