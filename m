Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbYIUAJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbYIUAJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 20:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYIUAJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 20:09:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:25960 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYIUAJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 20:09:50 -0400
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: Introduce integrity data ownership flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Date: Sat, 20 Sep 2008 20:09:44 -0400
Message-ID: <yq1ej3enyuv.fsf@sermon.lab.mkp.net>
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


A filesystem might supply its own integrity metadata.  Introduce a
flag that indicates whether the filesystem or the block layer owns the
integrity buffer.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 fs/bio-integrity.c  |    3 ++-
 include/linux/bio.h |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index c3e174b..8e409ff 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -107,7 +107,8 @@ void bio_integrity_free(struct bio *bio, struct bio_set *bs)
 	BUG_ON(bip == NULL);
 
 	/* A cloned bio doesn't own the integrity metadata */
-	if (!bio_flagged(bio, BIO_CLONED) && bip->bip_buf != NULL)
+	if (!bio_flagged(bio, BIO_CLONED) && !bio_flagged(bio, BIO_FS_INTEGRITY)
+	    && bip->bip_buf != NULL)
 		kfree(bip->bip_buf);
 
 	mempool_free(bip->bip_vec, bs->bvec_pools[bip->bip_pool]);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6520ee1..6aba97d 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -109,6 +109,7 @@ struct bio {
 #define BIO_EOPNOTSUPP	7	/* not supported */
 #define BIO_CPU_AFFINE	8	/* complete bio on same CPU as submitted */
 #define BIO_NULL_MAPPED 9	/* contains invalid user pages */
+#define BIO_FS_INTEGRITY 10	/* fs owns integrity data, not block layer */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
 /*
-- 
1.5.5.1

