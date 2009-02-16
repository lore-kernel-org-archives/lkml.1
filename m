Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbZBPEPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbZBPEPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 23:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZBPEPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 23:15:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:50358 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbZBPEPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 23:15:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ObOWqe7xmLBln8yd/AtZk/HIZ4py/kJYjZL0wx0Jy2Eu5m9KT/CXqafvIg8OsnaF2N
         yq3TENJUo9GHGQQ5j38I4TkzA17ozu1GTD4l3s2umrzP4UWrmmM3+h7kVYgvz21DVwxo
         A1piGQu9Cuz74gNFR70I/3HNDp2O61ki9PgW0=
MIME-Version: 1.0
Date: Sun, 15 Feb 2009 20:15:20 -0800
Message-ID: <3d7ff8e60902152015i1245f7byab20b9eef9425a84@mail.gmail.com>
Subject: [PATCH] fs/bio: bio_alloc_bioset: pass right object ptr to 
	mempool_free
From: Subhash Peddamallu <subhash.peddamallu@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When freeing from bio pool use right ptr to account for bs->front_pad,
instead of bio ptr,

Signed-off-by: Subhash Peddamallu <subhash.peddamallu@gmail.com>
---
 fs/bio.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 062299a..72ab251 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -302,9 +302,10 @@ void bio_init(struct bio *bio)
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
 	struct bio *bio = NULL;
+	void *p;

 	if (bs) {
-		void *p = mempool_alloc(bs->bio_pool, gfp_mask);
+		p = mempool_alloc(bs->bio_pool, gfp_mask);

 		if (p)
 			bio = p + bs->front_pad;
@@ -329,7 +330,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int
nr_iovecs, struct bio_set *bs)
 			}
 			if (unlikely(!bvl)) {
 				if (bs)
-					mempool_free(bio, bs->bio_pool);
+					mempool_free(p, bs->bio_pool);
 				else
 					kfree(bio);
 				bio = NULL;
-- 
1.5.6.3
