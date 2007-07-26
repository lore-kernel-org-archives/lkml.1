Return-Path: <linux-kernel-owner+w=401wt.eu-S1765321AbXGZPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765321AbXGZPsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759175AbXGZPsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:48:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758828AbXGZPsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:48:01 -0400
Date: Thu, 26 Jul 2007 11:47:49 -0400 (EDT)
Message-Id: <20070726.114749.74755465.k-ueda@ct.jp.nec.com>
To: mike.miller@hp.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [QUESTION] cciss/cpqarray: can we use __end_that_request_first()?
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Why do cciss/cpqarray directly call "bio_endio" and "disk_stat_add"
when request completion instead of using "end_that_request_first"?
Are there any problems in using "end_that_request_first"?


BACKGROUND:
I'm working on refining request completion procedures like:
    Before: 2 steps completion using "end_that_request_{first/chunk}"
            and "end_that_request_last"
    After:  1 step completion using generic block-layer helper
            which I'm calling "blk_end_request"
"blk_end_request" works like calling "__end_that_request_first"
and "end_that_request_last".
<http://marc.info/?l=linux-kernel&m=116846938806220&w=2>

However, while auditing various drivers, I found some drivers
are not using "end_that_request_{first/chunk}".
So I have to be careful not to break such drivers.

In the case of cciss/cpqarray, they call block layer functions
directly instead of using "end_that_request_first".
    o. Call blk_trace_add_rq() (cpqarray doesn't call it though)
    o. Call disk_stat_add()
    o. Complete bios in a request using bio_endio()
But "__end_that_request_first" does all of them.
So I can't understand why cciss/cpqarray don't use it.
Hence the question above.

Are there any problems in using "end_that_request_first" like
the patch below?
If no problem, testing the patch would be very helpful because I have
no hardware for those device drivers.  (I have done only build test.)

If it causes problems, some tricky work may be needed to skip
"__end_that_request_first" in "blk_end_request".

Thanks,
Kiyoshi Ueda


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

diff -rupN 2.6.23-rc1-mm1/drivers/block/cciss.c refine/drivers/block/cciss.c
--- 2.6.23-rc1-mm1/drivers/block/cciss.c	2007-07-25 14:00:10.000000000 -0400
+++ refine/drivers/block/cciss.c	2007-07-26 11:29:32.000000000 -0400
@@ -1250,6 +1250,7 @@ static void cciss_softirq_done(struct re
 	unsigned long flags;
 	u64bit temp64;
 	int i, ddir;
+	int uptodate = rq->errors ? 0 : 1;
 
 	if (cmd->Request.Type.Direction == XFER_READ)
 		ddir = PCI_DMA_FROMDEVICE;
@@ -1264,13 +1265,7 @@ static void cciss_softirq_done(struct re
 		pci_unmap_page(h->pdev, temp64.val, cmd->SG[i].Len, ddir);
 	}
 
-	complete_buffers(rq->bio, (rq->errors == 0));
-
-	if (blk_fs_request(rq)) {
-		const int rw = rq_data_dir(rq);
-
-		disk_stat_add(rq->rq_disk, sectors[rw], rq->nr_sectors);
-	}
+	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
 
 #ifdef CCISS_DEBUG
 	printk("Done with %p\n", rq);
@@ -1278,7 +1273,7 @@ static void cciss_softirq_done(struct re
 
 	add_disk_randomness(rq->rq_disk);
 	spin_lock_irqsave(&h->lock, flags);
-	end_that_request_last(rq, (rq->errors == 0));
+	end_that_request_last(rq, uptodate);
 	cmd_free(h, cmd, 1);
 	cciss_check_queues(h);
 	spin_unlock_irqrestore(&h->lock, flags);
@@ -2504,7 +2499,6 @@ after_error_processing:
 	}
 	cmd->rq->data_len = 0;
 	cmd->rq->completion_data = cmd;
-	blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
 	blk_complete_request(cmd->rq);
 }
 
diff -rupN 2.6.23-rc1-mm1/drivers/block/cpqarray.c refine/drivers/block/cpqarray.c
--- 2.6.23-rc1-mm1/drivers/block/cpqarray.c	2007-07-25 14:00:10.000000000 -0400
+++ refine/drivers/block/cpqarray.c	2007-07-26 11:30:23.000000000 -0400
@@ -1030,13 +1030,7 @@ static inline void complete_command(cmdl
                 pci_unmap_page(hba[cmd->ctlr]->pci_dev, cmd->req.sg[i].addr,
 				cmd->req.sg[i].size, ddir);
 
-	complete_buffers(rq->bio, ok);
-
-	if (blk_fs_request(rq)) {
-		const int rw = rq_data_dir(rq);
-
-		disk_stat_add(rq->rq_disk, sectors[rw], rq->nr_sectors);
-	}
+	end_that_request_first(rq, ok, rq->hard_nr_sectors);
 
 	add_disk_randomness(rq->rq_disk);
 
