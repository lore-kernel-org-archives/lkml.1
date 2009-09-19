Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZISPlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZISPlK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 11:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZISPlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 11:41:09 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:57526 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZISPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 11:41:08 -0400
Message-ID: <4AB4FA40.70700@ce.jp.nec.com>
Date: Sun, 20 Sep 2009 00:35:28 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>, David Strand <dpstrand@gmail.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] block: Add blk_queue_copy_limits()
References: <4AB3B43D.9000802@ce.jp.nec.com> <20090918203328.GT23126@kernel.dk> <20090918203533.GU23126@kernel.dk>
In-Reply-To: <20090918203533.GU23126@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Fri, Sep 18 2009, Jens Axboe wrote:
>> On Sat, Sep 19 2009, Jun'ichi Nomura wrote:
>>> This patch is a preparation for the last patch in this patchset
>>> which changes blk_set_default_limits() to set 0 to max_sectors.
>>>
>>> dm uses blk_stack_limits() to merge limits of underlying devices
>>> and copy the end result to the queue.
>>> But if there's no underlying device (like 'zero' target),
>>> max_sectors/max_hw_sectors are left unchanged from the default 0
>>> and just copying it to the queue causes problems.
>>>
>>> Provide blk_queue_copy_limits() to get a safe copy with
>>> invalid values fixed-up.
>> Added for 2.6.32.
> 
> And removed, it's white space damaged and doesn't apply to the current
> tree.

Sorry... I forgot to disable line-wrapping and broke the patch.
Re-sending with Mike's correction to English applied.


This patch is a preparation for the last patch in this patchset
which changes blk_set_default_limits() to set max_sectors to 0.

dm uses blk_stack_limits() to merge limits of underlying devices
and copy the end result to the queue.
But if there's no underlying device (like 'zero' target),
max_sectors/max_hw_sectors are left unchanged from the default 0
and just copying it to the queue causes problems.

Provide blk_queue_copy_limits() to get a safe copy with
invalid values fixed-up.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: David Strand <dpstrand@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-settings.c   |   28 ++++++++++++++++++++++++++++
 include/linux/blkdev.h |    1 +
 2 files changed, 29 insertions(+)

Index: linux-2.6.31.work/block/blk-settings.c
===================================================================
--- linux-2.6.31.work.orig/block/blk-settings.c
+++ linux-2.6.31.work/block/blk-settings.c
@@ -122,6 +122,34 @@ void blk_set_default_limits(struct queue
 EXPORT_SYMBOL(blk_set_default_limits);

 /**
+ * blk_queue_copy_limits - copy limits to queue
+ * @q:  the request queue whose limits as a copy destination
+ * @lim:  the queue_limits structure as a copy source
+ *
+ * Description:
+ *   Copies a queue_limit struct contents to @q with fix-ups to
+ *   invalid values.
+ */
+void blk_queue_copy_limits(struct request_queue *q, struct queue_limits *lim)
+{
+	q->limits = *lim;
+
+	/*
+	 * blk_set_default_limits() sets max_sectors/max_hw_sectors to 0
+	 * so that blk_stack_limits() appropriately propagate the values
+	 * of lower-stack by min_not_zero().
+	 * However, if the default value 0 is unchanged (e.g. the stacking
+	 * device is virtual and has no underlying device), it results
+	 * in unusable device.
+	 * Check if max_sectors/max_hw_sectors have non-zero values,
+	 * and set SAFE_MAX_SECTORS if they do.
+	 */
+	if (q->limits.max_sectors == 0 || q->limits.max_hw_sectors == 0)
+		blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
+}
+EXPORT_SYMBOL(blk_queue_copy_limits);
+
+/**
  * blk_queue_make_request - define an alternate make_request function for a device
  * @q:  the request queue for the device to be affected
  * @mfn: the alternate make_request function
Index: linux-2.6.31.work/include/linux/blkdev.h
===================================================================
--- linux-2.6.31.work.orig/include/linux/blkdev.h
+++ linux-2.6.31.work/include/linux/blkdev.h
@@ -917,6 +917,7 @@ extern void blk_limits_io_min(struct que
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_default_limits(struct queue_limits *lim);
+extern void blk_queue_copy_limits(struct request_queue *q, struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
 extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,

