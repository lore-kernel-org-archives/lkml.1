Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYIWSoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYIWSoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYIWSnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:43:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35364 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYIWSna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:43:30 -0400
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: agk@sourceware.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] block: Find bio sector offset given idx and offset
Date: Tue, 23 Sep 2008 14:41:11 -0400
Message-Id: <1222195272-18674-2-git-send-email-martin.petersen@oracle.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080920211433.9e1a6872.akpm@linux-foundation.org>
References: <20080920211433.9e1a6872.akpm@linux-foundation.org>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helper function to find the sector offset in a bio given bvec index
and page offset.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio.c            |   34 ++++++++++++++++++++++++++++++++++
 include/linux/bio.h |    1 +
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index e56e768..55ee2fd 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1300,6 +1300,40 @@ struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
 	return bp;
 }
 
+/**
+ *	bio_sector_offset - Find hardware sector offset in bio
+ *	@bio:		bio to inspect
+ *	@index:		bio_vec index
+ *	@offset:	offset in bv_page
+ *
+ *	Return the number of hardware sectors between beginning of bio
+ *	and an end point indicated by a bio_vec index and an offset
+ *	within that vector's page.
+ */
+sector_t bio_sector_offset(struct bio *bio, unsigned short index,
+			   unsigned int offset)
+{
+	struct bio_vec *bv;
+	unsigned int sector_sz = bio->bi_bdev->bd_disk->queue->hardsect_size;
+	sector_t sectors;
+	int i;
+
+	sectors = 0;
+
+	BUG_ON(index >= bio->bi_vcnt);
+
+	bio_for_each_segment(bv, bio, i) {
+		if (i == index) {
+			if (offset > bv->bv_offset)
+				sectors += (offset - bv->bv_offset) / sector_sz;
+			return sectors;
+		}
+
+		sectors += bv->bv_len / sector_sz;
+	}
+
+	BUG();
+}
 
 /*
  * create memory pools for biovec's in a bio_set.
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6aba97d..386a1df 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -327,6 +327,7 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
+extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
-- 
1.5.5.1

