Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZIRQrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZIRQrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbZIRQrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:47:10 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61264 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbZIRQrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:47:08 -0400
Message-ID: <4AB3B584.7050600@ce.jp.nec.com>
Date: Sat, 19 Sep 2009 01:29:56 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>
CC: David Strand <dpstrand@gmail.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] block: blk_set_default_limits sets 0 to max_sectors
References: <4AB3B43D.9000802@ce.jp.nec.com>
In-Reply-To: <4AB3B43D.9000802@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_sectors and max_hw_sectors of dm device are set to smaller values
than those of underlying devices.  E.g:
    # cat /sys/block/sdj/queue/max_sectors_kb
    512
    # cat /sys/block/sdj/queue/max_hw_sectors_kb
    32767
    # echo "0 10 linear /dev/sdj 0" | dmsetup create test
    # cat /sys/block/dm-0/queue/max_sectors_kb
    127
    # cat /sys/block/dm-0/queue/max_hw_sectors_kb
    127
This prevents the I/O size of struct request from becoming large,
and causes undesired request fragmentation in request-based dm.

This is caused by the queue_limits stacking.
In dm_calculate_queue_limits(), the block-layer's safe default value
(SAFE_MAX_SECTORS, 255) is included in the merging process of target's
queue_limits. So underlying queue_limits is not propagated correctly.

Initialize default values of all max_sectors to '0'
in blk_set_default_limits() so that the values propagate properly
from underlying devices.

Check this thread for further background:
https://www.redhat.com/archives/dm-devel/2009-September/msg00176.html

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Reported-by: David Strand <dpstrand@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-settings.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.31.work/block/blk-settings.c
===================================================================
--- linux-2.6.31.work.orig/block/blk-settings.c
+++ linux-2.6.31.work/block/blk-settings.c
@@ -111,7 +111,7 @@ void blk_set_default_limits(struct queue
 	lim->max_hw_segments = MAX_HW_SEGMENTS;
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->max_segment_size = MAX_SEGMENT_SIZE;
-	lim->max_sectors = lim->max_hw_sectors = SAFE_MAX_SECTORS;
+	lim->max_sectors = lim->max_hw_sectors = 0;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
@@ -192,6 +192,7 @@ void blk_queue_make_request(struct reque
 	q->unplug_timer.data = (unsigned long)q;

 	blk_set_default_limits(&q->limits);
+	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);

 	/*
 	 * If the caller didn't supply a lock, fall back to our embedded
