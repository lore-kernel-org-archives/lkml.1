Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbZHWJD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbZHWJD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 05:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933115AbZHWJD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 05:03:57 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:59800 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933319AbZHWJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 05:03:49 -0400
Message-ID: <4A91058F.3050708@gmail.com>
Date: Sun, 23 Aug 2009 11:02:07 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Miller <mike.miller@hp.com>,
       linux kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] cciss: memory leak in cciss_init_one()
References: <4A7961DE.1090702@gmail.com>
In-Reply-To: <4A7961DE.1090702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sun, 23 Aug 2009 11:02:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, I originally sent this 18 days ago and got no reply yet,
maybe could you get the baby ?

Thanks

[PATCH] cciss: memory leak in cciss_init_one()

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

