Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZGUTz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZGUTz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZGUTz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:55:27 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:48118 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbZGUTzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:55:24 -0400
Subject: [PATCH 2 1/4] cciss: remove logical drive sysfs entries during driver
	cleanup.
To: linux-kernel@vger.kernel.org
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, mike.miller@hp.com,
       jens.axboe@oracle.com
Date: Tue, 21 Jul 2009 13:55:22 -0600
Message-ID: <20090721195522.20740.48970.stgit@bob.kio>
In-Reply-To: <20090721195517.20740.18994.stgit@bob.kio>
References: <20090721195517.20740.18994.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cciss: remove logical drive sysfs entries during driver cleanup.

Sysfs entries for logical drives need to be removed when a drive is
deleted during driver cleanup.

Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a52cc7f..970c896 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1977,7 +1977,6 @@ static int rebuild_lun_table(ctlr_info_t *h, int first_time)
 			h->drv[i].busy_configuring = 1;
 			spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 			return_code = deregister_disk(h, i, 1);
-			cciss_destroy_ld_sysfs_entry(&h->drv[i]);
 			h->drv[i].busy_configuring = 0;
 		}
 	}
@@ -2118,6 +2117,7 @@ static int deregister_disk(ctlr_info_t *h, int drv_index,
 				 * indicate that this element of the drive
 				 * array is free.
 				 */
+	cciss_destroy_ld_sysfs_entry(drv);
 
 	if (clear_all) {
 		/* check to see if it was the last disk */
@@ -4141,6 +4141,9 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 			if (q)
 				blk_cleanup_queue(q);
 		}
+		if (hba[i]->drv[j].raid_level != -1)
+			cciss_destroy_ld_sysfs_entry(&hba[i]->drv[j]);
+
 	}
 
 #ifdef CONFIG_CISS_SCSI_TAPE

