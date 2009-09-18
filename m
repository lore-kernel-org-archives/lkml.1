Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbZIRT3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbZIRT3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbZIRT3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:29:13 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:43959 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095AbZIRT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:29:12 -0400
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/3] block: Add blk_queue_copy_limits()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4AB3B43D.9000802@ce.jp.nec.com>
Date: Fri, 18 Sep 2009 15:28:56 -0400
In-Reply-To: <4AB3B43D.9000802@ce.jp.nec.com> (Jun'ichi Nomura's message of
	"Sat, 19 Sep 2009 01:24:29 +0900")
Message-ID: <yq1eiq46ohz.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AB3DF7C.0038:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:

+	if (q->limits.max_sectors == 0 || q->limits.max_hw_sectors == 0)
+		blk_queue_max_sectors(q, SAFE_MAX_SECTORS);

I'm really not keen on perpetuating SAFE_MAX_SECTORS for something that
was written in this millennium.

I'd much rather we just do this, then:

block: Set max_sectors correctly for stacking devices

The topology changes unintentionally caused SAFE_MAX_SECTORS to be set
for stacking devices.  Set the default limit to BLK_DEF_MAX_SECTORS and
provide SAFE_MAX_SECTORS in blk_queue_make_request() for legacy hw
drivers that depend on the old behavior.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 83413ff..cd9b730 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -111,7 +111,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->max_hw_segments = MAX_HW_SEGMENTS;
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->max_segment_size = MAX_SEGMENT_SIZE;
-	lim->max_sectors = lim->max_hw_sectors = SAFE_MAX_SECTORS;
+	lim->max_sectors = lim->max_hw_sectors = BLK_DEF_MAX_SECTORS;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
@@ -164,6 +164,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	q->unplug_timer.data = (unsigned long)q;
 
 	blk_set_default_limits(&q->limits);
+	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
 
 	/*
 	 * If the caller didn't supply a lock, fall back to our embedded


