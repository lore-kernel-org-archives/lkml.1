Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYIUANn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYIUANn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 20:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYIUANf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 20:13:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:26206 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbYIUANe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 20:13:34 -0400
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: Find bio sector offset given idx and offset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Date: Sat, 20 Sep 2008 20:13:29 -0400
Message-ID: <yq17i96nyom.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
 fs/bio.c            |   24 ++++++++++++++++++++++++
 include/linux/bio.h |    2 ++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index e56e768..6fd3a86 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1300,6 +1300,30 @@ struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
 	return bp;
 }
 
+sector_t bio_sector_offset(struct bio *bio, unsigned short index, unsigned int offset)
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
+EXPORT_SYMBOL(bio_sector_offset);
 
 /*
  * create memory pools for biovec's in a bio_set.
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6aba97d..895a960 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -327,6 +327,8 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
+extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
+
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
-- 
1.5.5.1

