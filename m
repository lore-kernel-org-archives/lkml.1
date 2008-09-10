Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYIJWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYIJWAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYIJWAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:00:22 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56222 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYIJWAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:00:21 -0400
Subject: Cleanups for: [PATCH 5/9] Memory managemnet (restore)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <1221082922.6781.62.camel@nimitz>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0809040404060.5982@takamine.ncl.cs.columbia.edu>
	 <1220551683.23386.32.camel@nimitz> <48C345D2.1020603@cs.columbia.edu>
	 <1220892596.23386.166.camel@nimitz> <48C6113A.3080804@cs.columbia.edu>
	 <1221082922.6781.62.camel@nimitz>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 15:00:14 -0700
Message-Id: <1221084015.6781.66.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the restore side of my cleanups on top of the v4 patches and the
one against 4/9 I just sent.

This purely makes it compile again.

---

 linux-2.6.git-dave/checkpoint/ckpt_mem.c |    2 --
 linux-2.6.git-dave/checkpoint/ckpt_mem.h |    4 ++++
 linux-2.6.git-dave/checkpoint/rstr_mem.c |   30 +++++++++++++++++++-----------
 3 files changed, 23 insertions(+), 13 deletions(-)

diff -puN checkpoint/rstr_mem.c~p5-dave checkpoint/rstr_mem.c
--- linux-2.6.git/checkpoint/rstr_mem.c~p5-dave	2008-09-10 14:51:26.000000000 -0700
+++ linux-2.6.git-dave/checkpoint/rstr_mem.c	2008-09-10 14:58:53.000000000 -0700
@@ -31,27 +31,35 @@
  * read in directly to the address space of the current process
  */
 
+static int pgarr_nr_free(struct cr_pgarr *pgarr)
+{
+	return CR_PGARR_TOTAL - pgarr->nr_used;
+}
+
 /**
- * cr_vma_read_pages_vaddrs - read addresses of pages to page-array chain
+ * cr_vma_restore_contents - read addresses of pages to page-array chain
  * @ctx - restart context
  * @npages - number of pages
  */
-static int cr_vma_read_pages_vaddrs(struct cr_ctx *ctx, int npages)
+static int cr_vma_restore_contents(struct cr_ctx *ctx, int pages_to_read)
 {
 	struct cr_pgarr *pgarr;
 	int nr, ret;
 
-	while (npages) {
-		pgarr = cr_pgarr_prep(ctx);
+	while (pages_to_read) {
+		unsigned long *vaddr_position;
+		pgarr = cr_get_empty_pgarr(ctx);
 		if (!pgarr)
 			return -ENOMEM;
-		nr = min(npages, (int) pgarr->nr_free);
-		ret = cr_kread(ctx, pgarr->vaddrs, nr * sizeof(unsigned long));
+		nr = pages_to_read;
+	       	if (nr > pgarr_nr_free(pgarr))
+			nr = pgarr_nr_free(pgarr);
+		vaddr_position = &pgarr->vaddrs[pgarr->nr_used];
+		ret = cr_kread(ctx, vaddr_position, nr * sizeof(unsigned long));
 		if (ret < 0)
 			return ret;
-		pgarr->nr_free -= nr;
 		pgarr->nr_used += nr;
-		npages -= nr;
+		pages_to_read -= nr;
 	}
 	return 0;
 }
@@ -67,7 +75,7 @@ static int cr_vma_read_pages_contents(st
 	unsigned long *vaddrs;
 	int i, ret;
 
-	list_for_each_entry(pgarr, &ctx->pgarr, list) {
+	list_for_each_entry(pgarr, &ctx->pgarr_list, list) {
 		vaddrs = pgarr->vaddrs;
 		for (i = 0; i < pgarr->nr_used; i++) {
 			void *ptr = (void *) vaddrs[i];
@@ -126,14 +134,14 @@ static int cr_vma_read_pages(struct cr_c
 		ret = cr_vma_set_writable(mm, hh->vm_start, hh->vm_end, 1);
 	if (ret < 0)
 		goto out;
-	ret = cr_vma_read_pages_vaddrs(ctx, hh->nr_pages);
+	ret = cr_vma_restore_contents(ctx, hh->nr_pages);
 	if (ret < 0)
 		goto out;
 	ret = cr_vma_read_pages_contents(ctx, hh->nr_pages);
 	if (ret < 0)
 		goto out;
 
-	cr_pgarr_reset(ctx);	/* reset page-array chain */
+	cr_reset_all_pgarrs(ctx);	/* reset page-array chain */
 
 	/* restore original protection for this vma */
 	if (!(hh->vm_flags & VM_WRITE))
diff -puN checkpoint/ckpt_mem.c~p5-dave checkpoint/ckpt_mem.c
--- linux-2.6.git/checkpoint/ckpt_mem.c~p5-dave	2008-09-10 14:51:33.000000000 -0700
+++ linux-2.6.git-dave/checkpoint/ckpt_mem.c	2008-09-10 14:51:54.000000000 -0700
@@ -35,8 +35,6 @@
  * freed (that is, dereference page pointers).
  */
 
-#define CR_PGARR_TOTAL  (PAGE_SIZE / sizeof(void *))
-
 /* release pages referenced by a page-array */
 void cr_pgarr_release_pages(struct cr_pgarr *pgarr)
 {
diff -puN checkpoint/ckpt_mem.h~p5-dave checkpoint/ckpt_mem.h
--- linux-2.6.git/checkpoint/ckpt_mem.h~p5-dave	2008-09-10 14:52:17.000000000 -0700
+++ linux-2.6.git-dave/checkpoint/ckpt_mem.h	2008-09-10 14:57:09.000000000 -0700
@@ -26,7 +26,11 @@ struct cr_pgarr {
 	struct list_head list;
 };
 
+#define CR_PGARR_TOTAL  (PAGE_SIZE / sizeof(void *))
+
 void cr_pgarr_free(struct cr_ctx *ctx);
+void cr_reset_all_pgarrs(struct cr_ctx *ctx);
 struct cr_pgarr *cr_pgarr_prep(struct cr_ctx *ctx);
+struct cr_pgarr *cr_get_empty_pgarr(struct cr_ctx *ctx);
 
 #endif /* _CHECKPOINT_CKPT_MEM_H_ */
_


-- Dave

