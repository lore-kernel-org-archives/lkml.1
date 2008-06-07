Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYFGE5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYFGE5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 00:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYFGE5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 00:57:44 -0400
Received: from jaguar.mkp.net ([192.139.46.146]:38418 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbYFGE5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 00:57:43 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 7] block: Find bio sector offset given idx and offset
X-Mercurial-Node: 318fa71e735d25003f9c35abca3d3c25ad397c2d
Message-Id: <318fa71e735d25003f9c.1212814536@sermon.lab.mkp.net>
In-Reply-To: <patchbomb.1212814533@sermon.lab.mkp.net>
Date: Sat, 07 Jun 2008 00:55:36 -0400
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2 files changed, 26 insertions(+)
fs/bio.c            |   24 ++++++++++++++++++++++++
include/linux/bio.h |    2 ++


Helper function to find the sector offset in a bio given bvec index
and page offset.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 550d61001baa -r 318fa71e735d fs/bio.c
--- a/fs/bio.c	Sat Jun 07 00:45:14 2008 -0400
+++ b/fs/bio.c	Sat Jun 07 00:45:14 2008 -0400
@@ -1232,6 +1232,30 @@
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
diff -r 550d61001baa -r 318fa71e735d include/linux/bio.h
--- a/include/linux/bio.h	Sat Jun 07 00:45:14 2008 -0400
+++ b/include/linux/bio.h	Sat Jun 07 00:45:14 2008 -0400
@@ -315,6 +315,8 @@
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
+extern sector_t bio_sector_offset(struct bio *, unsigned short, unsigned int);
+
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int);
 struct sg_iovec;


