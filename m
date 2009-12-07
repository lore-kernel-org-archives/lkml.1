Return-Path: <linux-kernel-owner+w=401wt.eu-S934038AbZLGLgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038AbZLGLgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 06:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbZLGLgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 06:36:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51412 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbZLGLgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 06:36:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: [early RFC][PATCH 8/7] vmscan: Don't deactivate many touched page
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
In-Reply-To: <20091204173233.5891.A69D9226@jp.fujitsu.com>
References: <20091204173233.5891.A69D9226@jp.fujitsu.com>
Message-Id: <20091207203427.E955.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  7 Dec 2009 20:36:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrea, Can you please try following patch on your workload?


>From a7758c66d36a136d5fbbcf0b042839445f0ca522 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 7 Dec 2009 18:37:20 +0900
Subject: [PATCH] [RFC] vmscan: Don't deactivate many touched page

Changelog
 o from andrea's original patch
   - Rebase topon my patches.
   - Use list_cut_position/list_splice_tail pair instead
     list_del/list_add to make pte scan fairness.
   - Only use max young threshold when soft_try is true.
     It avoid wrong OOM sideeffect.
   - Return SWAP_AGAIN instead successful result if max
     young threshold exceed. It prevent the pages without clear
     pte young bit will be deactivated wrongly.
   - Add to treat ksm page logic

Many shared and frequently used page don't need deactivate and
try_to_unamp(). It's pointless while VM pressure is low, the page
might reactivate soon. it's only makes cpu wasting.

Then, This patch makes to stop pte scan if wipe_page_reference()
found lots young pte bit.

Originally-Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/rmap.h |   17 +++++++++++++++++
 mm/ksm.c             |    4 ++++
 mm/rmap.c            |   19 +++++++++++++++++++
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 499972e..9ad69b5 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -128,6 +128,23 @@ int wipe_page_reference_one(struct page *page,
 			    struct page_reference_context *refctx,
 			    struct vm_area_struct *vma, unsigned long address);
 
+#define MAX_YOUNG_BIT_CLEARED 64
+/*
+ * if VM pressure is low and the page have too many active mappings, there isn't
+ * any reason to continue clear young bit of other ptes. Otherwise,
+ *  - Makes meaningless cpu wasting, many touched page sholdn't be reclaimed.
+ *  - Makes lots IPI for pte change and it might cause another sadly lock
+ *    contention. 
+ */
+static inline
+int too_many_young_bit_found(struct page_reference_context *refctx)
+{
+	if (refctx->soft_try &&
+	    refctx->referenced >= MAX_YOUNG_BIT_CLEARED)
+		return 1;
+	return 0;
+}
+
 enum ttu_flags {
 	TTU_UNMAP = 0,			/* unmap mode */
 	TTU_MIGRATION = 1,		/* migration mode */
diff --git a/mm/ksm.c b/mm/ksm.c
index 3c121c8..46ea519 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1586,6 +1586,10 @@ again:
 						      rmap_item->address);
 			if (ret != SWAP_SUCCESS)
 				goto out;
+			if (too_many_young_bit_found(refctx)) {
+				ret = SWAP_AGAIN;
+				goto out;
+			}
 			mapcount--;
 			if (!search_new_forks || !mapcount)
 				break;
diff --git a/mm/rmap.c b/mm/rmap.c
index cfda0a0..f4517f3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -473,6 +473,21 @@ static int wipe_page_reference_anon(struct page *page,
 		ret = wipe_page_reference_one(page, refctx, vma, address);
 		if (ret != SWAP_SUCCESS)
 			break;
+		if (too_many_young_bit_found(refctx)) {
+			LIST_HEAD(tmp_list);
+
+			/*
+			 * The scanned ptes move to list tail. it help every ptes
+			 * on this page will be tested by ptep_clear_young().
+			 * Otherwise, this shortcut makes unfair thing.
+			 */
+			list_cut_position(&tmp_list,
+					  &vma->anon_vma_node,
+					  &anon_vma->head);
+			list_splice_tail(&tmp_list, &vma->anon_vma_node);
+			ret = SWAP_AGAIN;
+			break;
+		}
 		mapcount--;
 		if (!mapcount || refctx->maybe_mlocked)
 			break;
@@ -543,6 +558,10 @@ static int wipe_page_reference_file(struct page *page,
 		ret = wipe_page_reference_one(page, refctx, vma, address);
 		if (ret != SWAP_SUCCESS)
 			break;
+		if (too_many_young_bit_found(refctx)) {
+			ret = SWAP_AGAIN;
+			break;
+		}
 		mapcount--;
 		if (!mapcount || refctx->maybe_mlocked)
 			break;
-- 
1.6.5.2



