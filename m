Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbXJVSNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbXJVSNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbXJVSM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:26 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22170 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbXJVSMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:24 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 03/10] [SG] Update crypto/ to sg helpers
Date: Mon, 22 Oct 2007 20:10:57 +0200
Message-Id: <1193076664-13652-4-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 crypto/digest.c      |    2 +-
 crypto/hmac.c        |    3 ++-
 crypto/scatterwalk.c |    2 +-
 crypto/scatterwalk.h |    6 +++---
 crypto/tcrypt.c      |    4 ++--
 crypto/xcbc.c        |    2 +-
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/crypto/digest.c b/crypto/digest.c
index e56de67..8871dec 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -41,7 +41,7 @@ static int update2(struct hash_desc *desc,
 		return 0;
 
 	for (;;) {
-		struct page *pg = sg->page;
+		struct page *pg = sg_page(sg);
 		unsigned int offset = sg->offset;
 		unsigned int l = sg->length;
 
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8802fb6..e4eb6ac 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -159,7 +159,8 @@ static int hmac_digest(struct hash_desc *pdesc, struct scatterlist *sg,
 	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	sg_set_buf(sg1, ipad, bs);
-	sg1[1].page = (void *)sg;
+
+	sg_set_page(&sg[1], (void *) sg);
 	sg1[1].length = 0;
 	sg_set_buf(sg2, opad, bs + ds);
 
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index d6852c3..b9bbda0 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -54,7 +54,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 	if (out) {
 		struct page *page;
 
-		page = walk->sg->page + ((walk->offset - 1) >> PAGE_SHIFT);
+		page = sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT);
 		flush_dcache_page(page);
 	}
 
diff --git a/crypto/scatterwalk.h b/crypto/scatterwalk.h
index 9c73e37..87ed681 100644
--- a/crypto/scatterwalk.h
+++ b/crypto/scatterwalk.h
@@ -22,13 +22,13 @@
 
 static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
 {
-	return (++sg)->length ? sg : (void *)sg->page;
+	return (++sg)->length ? sg : (void *) sg_page(sg);
 }
 
 static inline unsigned long scatterwalk_samebuf(struct scatter_walk *walk_in,
 						struct scatter_walk *walk_out)
 {
-	return !(((walk_in->sg->page - walk_out->sg->page) << PAGE_SHIFT) +
+	return !(((sg_page(walk_in->sg) - sg_page(walk_out->sg)) << PAGE_SHIFT) +
 		 (int)(walk_in->offset - walk_out->offset));
 }
 
@@ -60,7 +60,7 @@ static inline unsigned int scatterwalk_aligned(struct scatter_walk *walk,
 
 static inline struct page *scatterwalk_page(struct scatter_walk *walk)
 {
-	return walk->sg->page + (walk->offset >> PAGE_SHIFT);
+	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
 }
 
 static inline void scatterwalk_unmap(void *vaddr, int out)
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 18d489c..d741c63 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -317,7 +317,7 @@ static void test_cipher(char *algo, int enc,
 				goto out;
 			}
 
-			q = kmap(sg[0].page) + sg[0].offset;
+			q = kmap(sg_page(&sg[0])) + sg[0].offset;
 			hexdump(q, cipher_tv[i].rlen);
 
 			printk("%s\n",
@@ -390,7 +390,7 @@ static void test_cipher(char *algo, int enc,
 			temp = 0;
 			for (k = 0; k < cipher_tv[i].np; k++) {
 				printk("page %u\n", k);
-				q = kmap(sg[k].page) + sg[k].offset;
+				q = kmap(sg_page(&sg[k])) + sg[k].offset;
 				hexdump(q, cipher_tv[i].tap[k]);
 				printk("%s\n",
 					memcmp(q, cipher_tv[i].result + temp,
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 9f502b8..ac68f3b 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -120,7 +120,7 @@ static int crypto_xcbc_digest_update2(struct hash_desc *pdesc,
 
 	do {
 
-		struct page *pg = sg[i].page;
+		struct page *pg = sg_page(&sg[i]);
 		unsigned int offset = sg[i].offset;
 		unsigned int slen = sg[i].length;
 
-- 
1.5.3.GIT

