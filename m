Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYJUVXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYJUVXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYJUVXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:23:23 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:3091 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYJUVXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:23:22 -0400
Date: Tue, 21 Oct 2008 16:23:22 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>, fujita.tomonori@lab.ntt.co.jp,
       adobriyan@gmail.com
Subject: [PATCH 2/2] cciss:fix regression firmware not displayed in procfs (again and again)
Message-ID: <20081021212322.GA6421@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 2 of 2

Sorry for the delay. I've been out of the office and the network has been
down since before lunch CDT. This regression was introduced by commit
6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
This patch fixes a regression where the controller firmware version is not
displayed in procfs. The previous patch would be called anytime something
changed. This will get called only once for each controller.

In this patch I again initialize *inq_buff to NULL per Tomo's comments. I
also use a goto clean 4 instead of returning -ENOMEM if the kzalloc fails.

I hope this finally meets everyones expectations.

Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0f367b1..eb68f39 100644
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
+		goto clean4;
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
@@ -3520,6 +3540,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	return 1;
 
 clean4:
+	kfree(inq_buff);
 #ifdef CONFIG_CISS_SCSI_TAPE
 	kfree(hba[i]->scsi_rejects.complete);
 #endif
