Return-Path: <linux-kernel-owner+w=401wt.eu-S933401AbZJaXTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbZJaXTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 19:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933328AbZJaXTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 19:19:33 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:1070 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303AbZJaXTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 19:19:32 -0400
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com, tj@kernel.org,
       Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Fix bio_alloc() and bio_kmalloc() documentation
Date: Sat, 31 Oct 2009 20:18:36 -0300
Message-Id: <1257031116-17934-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 451a9ebf accidentally broke bio_alloc() and bio_kmalloc() comments by
(almost) swapping them.

This patch fixes that, by placing the comments in the right place.

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---

I'm not completely sure the mempool part is in the right place. If it's not,
let me know and I'll fix the patch.

Thanks a lot,
		Alberto


 fs/bio.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index bcab9e9..12da5db 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -325,8 +325,16 @@ static void bio_fs_destructor(struct bio *bio)
  *	@gfp_mask: allocation mask to use
  *	@nr_iovecs: number of iovecs
  *
- *	Allocate a new bio with @nr_iovecs bvecs.  If @gfp_mask
- *	contains __GFP_WAIT, the allocation is guaranteed to succeed.
+ *	bio_alloc will allocate a bio and associated bio_vec array that can hold
+ *	at least @nr_iovecs entries. Allocations will be done from the
+ *	fs_bio_set. Also see @bio_alloc_bioset and @bio_kmalloc.
+ *
+ *	If %__GFP_WAIT is set, then bio_alloc will always be able to allocate
+ *	a bio. This is due to the mempool guarantees. To make this work, callers
+ *	must never allocate more than 1 bio at a time from this pool. Callers
+ *	that need to allocate more than 1 bio must always submit the previously
+ *	allocated bio for IO before attempting to allocate a new one. Failure to
+ *	do so can cause livelocks under memory pressure.
  *
  *	RETURNS:
  *	Pointer to new bio on success, NULL on failure.
@@ -350,21 +358,13 @@ static void bio_kmalloc_destructor(struct bio *bio)
 }
 
 /**
- * bio_alloc - allocate a bio for I/O
+ * bio_kmalloc - allocate a bio for I/O using kmalloc()
  * @gfp_mask:   the GFP_ mask given to the slab allocator
  * @nr_iovecs:	number of iovecs to pre-allocate
  *
  * Description:
- *   bio_alloc will allocate a bio and associated bio_vec array that can hold
- *   at least @nr_iovecs entries. Allocations will be done from the
- *   fs_bio_set. Also see @bio_alloc_bioset.
- *
- *   If %__GFP_WAIT is set, then bio_alloc will always be able to allocate
- *   a bio. This is due to the mempool guarantees. To make this work, callers
- *   must never allocate more than 1 bio at a time from this pool. Callers
- *   that need to allocate more than 1 bio must always submit the previously
- *   allocated bio for IO before attempting to allocate a new one. Failure to
- *   do so can cause livelocks under memory pressure.
+ *   Allocate a new bio with @nr_iovecs bvecs.  If @gfp_mask contains
+ *   %__GFP_WAIT, the allocation is guaranteed to succeed.
  *
  **/
 struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs)
-- 
1.6.3.3

