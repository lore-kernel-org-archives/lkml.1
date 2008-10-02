Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbYJBCqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbYJBCqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 22:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYJBCp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 22:45:58 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24079 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYJBCp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 22:45:57 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, neilb@suse.de,
       agk@sourceware.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCH 5/7] block: Find bio sector offset given idx and offset
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
	<1222846723-18213-6-git-send-email-martin.petersen@oracle.com>
	<20081001081056.GB19428@kernel.dk>
Date: Wed, 01 Oct 2008 22:42:53 -0400
In-Reply-To: <20081001081056.GB19428@kernel.dk> (Jens Axboe's message of "Wed\, 1 Oct 2008 10\:10\:56 +0200")
Message-ID: <yq163obiuoi.fsf@sermon.lab.mkp.net>
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

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> Too may BUG's there, me thinks, and the interface looks
Jens> fragile. What if the bio is alreday done (bi_idx == bi_vcnt)?

Good point!  Obviously I've only used the function for bio splitting
and not at completion time.  Updated patch below.


block: Find bio sector offset given idx and offset

Helper function to find the sector offset in a bio given bvec index
and page offset.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio.c            |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |    1 +
 2 files changed, 37 insertions(+)

diff --git a/fs/bio.c b/fs/bio.c
index e56e768..a5af580 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1300,6 +1300,42 @@ struct bio_pair *bio_split(struct bio *bi, mempool_t *pool, int first_sectors)
 	return bp;
 }
 
+/**
+ *      bio_sector_offset - Find hardware sector offset in bio
+ *      @bio:           bio to inspect
+ *      @index:         bio_vec index
+ *      @offset:        offset in bv_page
+ *
+ *      Return the number of hardware sectors between beginning of bio
+ *      and an end point indicated by a bio_vec index and an offset
+ *      within that vector's page.
+ */
+sector_t bio_sector_offset(struct bio *bio, unsigned short index,
+			   unsigned int offset)
+{
+	unsigned int sector_sz = queue_hardsect_size(bio->bi_bdev->bd_disk->queue);
+	struct bio_vec *bv;
+	sector_t sectors;
+	int i;
+
+	sectors = 0;
+
+	if (index >= bio->bi_idx)
+		index = bio->bi_vcnt - 1;
+
+	__bio_for_each_segment(bv, bio, i, 0) {
+		if (i == index) {
+			if (offset > bv->bv_offset)
+				sectors += (offset - bv->bv_offset) / sector_sz;
+			break;
+		}
+
+		sectors += bv->bv_len / sector_sz;
+	}
+
+	return sectors;
+}
+EXPORT_SYMBOL(bio_sector_offset);
 
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
