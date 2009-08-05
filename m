Return-Path: <linux-kernel-owner+w=401wt.eu-S934099AbZHEKm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbZHEKm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933413AbZHEKmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:42:55 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:40740 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284AbZHEKmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:42:54 -0400
Message-ID: <4A7961DE.1090702@gmail.com>
Date: Wed, 05 Aug 2009 12:41:34 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Mike Miller <mike.miller@hp.com>
CC: linux kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] cciss: memory leak in cciss_init_one()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 05 Aug 2009 12:41:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 22bece00dc1f28dd3374c55e464c9f02eb642876
(cciss: fix regression firmware not displayed in procfs)
added a small memory leak in cciss_init_one()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a52cc7f..0589dfb 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3889,7 +3889,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	int j = 0;
 	int rc;
 	int dac, return_code;
-	InquiryData_struct *inq_buff = NULL;
+	InquiryData_struct *inq_buff;
 
 	if (reset_devices) {
 		/* Reset the controller with a PCI power-cycle */
@@ -4029,6 +4029,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 		printk(KERN_WARNING "cciss: unable to determine firmware"
 			" version of controller\n");
 	}
+	kfree(inq_buff);
 
 	cciss_procinit(i);
 
@@ -4045,7 +4046,6 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	return 1;
 
 clean4:
-	kfree(inq_buff);
 	kfree(hba[i]->cmd_pool_bits);
 	if (hba[i]->cmd_pool)
 		pci_free_consistent(hba[i]->pdev,
