Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357Ab0AUEXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0AUEXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789Ab0AUEW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:22:58 -0500
Received: from kroah.org ([198.145.64.141]:60081 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab0AUEWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:33 2010
Message-Id: <20100121041833.250773470@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       jens.axboe@oracle.com,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [06/30] block: Fix incorrect reporting of partition alignment
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 81744ee44ab2845c16ffd7d6f762f7b4a49a4750 upstream

queue_sector_alignment_offset returned the wrong value which caused
partitions to report an incorrect alignment_offset. Since offset
calculation is needed several places it has been split into a separate
helper function.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Tested-by: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/blkdev.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1114,11 +1114,18 @@ static inline int queue_alignment_offset
 	return q->limits.alignment_offset;
 }
 
+static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t offset)
+{
+	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
+
+	offset &= granularity - 1;
+	return (granularity + lim->alignment_offset - offset) & (granularity - 1);
+}
+
 static inline int queue_sector_alignment_offset(struct request_queue *q,
 						sector_t sector)
 {
-	return ((sector << 9) - q->limits.alignment_offset)
-		& (q->limits.io_min - 1);
+	return queue_limit_alignment_offset(&q->limits, sector << 9);
 }
 
 static inline int bdev_alignment_offset(struct block_device *bdev)


