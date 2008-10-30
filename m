Return-Path: <linux-kernel-owner+w=401wt.eu-S1752745AbYJ3FQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbYJ3FQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYJ3FQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:16:20 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39311 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYJ3FQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:16:19 -0400
Message-ID: <490942D4.3070504@ce.jp.nec.com>
Date: Thu, 30 Oct 2008 14:15:00 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: device-mapper development <dm-devel@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       linux-kernel@vger.kernel.org, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH] Add gfp_mask to bio_integrity_clone()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

What do you think about adding gfp_mask parameter to bio_integrity_clone()
like the attached patch?

Kiyoshi Ueda and I are working on request-based device-mapper (*1)
and it clones bios like the existing bio-based dm.
However, since the request cloning may happen in interrupt context,
GFP_ATOMIC is used in our case (*2).

(*1) http://lkml.org/lkml/2008/10/3/177
(*2) http://lkml.org/lkml/2008/10/3/188

To cope with cloning the integrity payload,
we want to pass gfp_mask to bio_integrity_clone().

It also seems natural to inherit gfp_mask from bio_clone when
bio_integrity_clone is called from it.
Since bio_clone() is the only caller of bio_integrity_clone() in 2.6.28-rc2
and all in-tree callers of bio_clone() are using GFP_NOIO,
the patch does nothing other than changing the interface.


Add gfp_mask parameter to bio_integrity_clone().

Stricter gfp_mask might be required for clone allocation.
For example, request-based dm may clone bio in interrupt context
so it has to use GFP_ATOMIC.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>

---
 fs/bio-integrity.c  |    5 +++--
 fs/bio.c            |    2 +-
 include/linux/bio.h |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

Index: linux-2.6.28-rc2/fs/bio-integrity.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/bio-integrity.c
+++ linux-2.6.28-rc2/fs/bio-integrity.c
@@ -681,19 +681,20 @@ EXPORT_SYMBOL(bio_integrity_split);
  * bio_integrity_clone - Callback for cloning bios with integrity metadata
  * @bio:	New bio
  * @bio_src:	Original bio
+ * @gfp_mask:	Memory allocation mask
  * @bs:		bio_set to allocate bip from
  *
  * Description:	Called to allocate a bip when cloning a bio
  */
 int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
-			struct bio_set *bs)
+			gfp_t gfp_mask, struct bio_set *bs)
 {
 	struct bio_integrity_payload *bip_src = bio_src->bi_integrity;
 	struct bio_integrity_payload *bip;
 
 	BUG_ON(bip_src == NULL);
 
-	bip = bio_integrity_alloc_bioset(bio, GFP_NOIO, bip_src->bip_vcnt, bs);
+	bip = bio_integrity_alloc_bioset(bio, gfp_mask, bip_src->bip_vcnt, bs);
 
 	if (bip == NULL)
 		return -EIO;
Index: linux-2.6.28-rc2/include/linux/bio.h
===================================================================
--- linux-2.6.28-rc2.orig/include/linux/bio.h
+++ linux-2.6.28-rc2/include/linux/bio.h
@@ -496,7 +496,7 @@ extern void bio_integrity_endio(struct b
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
 extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
-extern int bio_integrity_clone(struct bio *, struct bio *, struct bio_set *);
+extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t, struct bio_set *);
 extern int bioset_integrity_create(struct bio_set *, int);
 extern void bioset_integrity_free(struct bio_set *);
 extern void bio_integrity_init_slab(void);
@@ -507,7 +507,7 @@ extern void bio_integrity_init_slab(void
 #define bioset_integrity_create(a, b)	(0)
 #define bio_integrity_prep(a)		(0)
 #define bio_integrity_enabled(a)	(0)
-#define bio_integrity_clone(a, b, c)	(0)
+#define bio_integrity_clone(a, b, c, d)	(0)
 #define bioset_integrity_free(a)	do { } while (0)
 #define bio_integrity_free(a, b)	do { } while (0)
 #define bio_integrity_endio(a, b)	do { } while (0)
Index: linux-2.6.28-rc2/fs/bio.c
===================================================================
--- linux-2.6.28-rc2.orig/fs/bio.c
+++ linux-2.6.28-rc2/fs/bio.c
@@ -309,7 +309,7 @@ struct bio *bio_clone(struct bio *bio, g
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, fs_bio_set);
+		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
 
 		if (ret < 0)
 			return NULL;
