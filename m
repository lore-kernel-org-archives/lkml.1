Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYJBNVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYJBNVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYJBNS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:18:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:54806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbYJBNSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:18:55 -0400
Message-Id: <20081002131607.946753246@chello.nl>
References: <20081002130504.927878499@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Oct 2008 15:05:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 06/32] mm: expose gfp_to_alloc_flags()
Content-Disposition: inline; filename=mm-gfp-to-alloc_flags-expose.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the gfp to alloc_flags mapping, so we can use it in other parts
of the vm.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/internal.h   |   10 ++++++++++
 mm/page_alloc.c |   10 +---------
 2 files changed, 11 insertions(+), 9 deletions(-)

Index: linux-2.6/mm/internal.h
===================================================================
--- linux-2.6.orig/mm/internal.h
+++ linux-2.6/mm/internal.h
@@ -187,6 +187,16 @@ static inline void free_page_mlock(struc
 #define __paginginit __init
 #endif
 
+#define ALLOC_HARDER		0x01 /* try to alloc harder */
+#define ALLOC_HIGH		0x02 /* __GFP_HIGH set */
+#define ALLOC_WMARK_MIN		0x04 /* use pages_min watermark */
+#define ALLOC_WMARK_LOW		0x08 /* use pages_low watermark */
+#define ALLOC_WMARK_HIGH	0x10 /* use pages_high watermark */
+#define ALLOC_NO_WATERMARKS	0x20 /* don't check watermarks at all */
+#define ALLOC_CPUSET		0x40 /* check for correct cpuset */
+
+int gfp_to_alloc_flags(gfp_t gfp_mask);
+
 /* Memory initialisation debug and verification */
 enum mminit_level {
 	MMINIT_WARNING,
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -1122,14 +1122,6 @@ failed:
 	return NULL;
 }
 
-#define ALLOC_NO_WATERMARKS	0x01 /* don't check watermarks at all */
-#define ALLOC_WMARK_MIN		0x02 /* use pages_min watermark */
-#define ALLOC_WMARK_LOW		0x04 /* use pages_low watermark */
-#define ALLOC_WMARK_HIGH	0x08 /* use pages_high watermark */
-#define ALLOC_HARDER		0x10 /* try to alloc harder */
-#define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
-#define ALLOC_CPUSET		0x40 /* check for correct cpuset */
-
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 
 static struct fail_page_alloc_attr {
@@ -1512,7 +1504,7 @@ static void set_page_owner(struct page *
 /*
  * get the deepest reaching allocation flags for the given gfp_mask
  */
-static int gfp_to_alloc_flags(gfp_t gfp_mask)
+int gfp_to_alloc_flags(gfp_t gfp_mask)
 {
 	struct task_struct *p = current;
 	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;

-- 

