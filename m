Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZEHPKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZEHPKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZEHPKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:10:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51415 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZEHPK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:10:29 -0400
Subject: [PATCH 1/2] mm: Introduce GFP_PANIC for early-boot allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
Cc: gorcunov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie,
       cl@linux-foundation.org, riel@redhat.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rientjes@google.com
Date: Fri, 08 May 2009 18:10:28 +0300
Message-Id: <1241795428.28600.60.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch introduces a GFP_PANIC flag that can be used as an annotation
that an early-boot call to kmalloc() or alloc_pages() is expected to
never fail.

To save one GFP flag bit, use a combination of __GFP_NOFAIL and
__GFP_NOREPEAT to make sure we always end up in the "nopage" path of the
page allocator if an allocation fails.

[ gorcunov@openvz.org: initial version of the patch ]
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Andrew, this one is rebased on top of -mm.

 include/linux/gfp.h |    1 +
 mm/page_alloc.c     |   12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index c7429b8..2e76e7b 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -71,6 +71,7 @@ struct vm_area_struct;
 #define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
 				 __GFP_HARDWALL | __GFP_HIGHMEM | \
 				 __GFP_MOVABLE)
+#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index be0ed90..eb8d953 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1516,8 +1516,11 @@ static inline int
 should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 				unsigned long pages_reclaimed)
 {
-	/* Do not loop if specifically requested */
-	if (gfp_mask & __GFP_NORETRY)
+	/*
+	 * Do not loop if specifically requested. Note: GFP_PANIC sets both
+	 * flags.
+	 */
+	if ((gfp_mask & __GFP_NORETRY) && !(gfp_mask & __GFP_NOFAIL))
 		return 0;
 
 	/*
@@ -1813,6 +1816,11 @@ rebalance:
 	}
 
 nopage:
+	if (unlikely((gfp_mask & GFP_PANIC) == GFP_PANIC)) {
+		show_mem();
+		panic("Out of memory: %s order: %d, gfp_mask:0x%x\n",
+			p->comm, order, gfp_mask);
+	}
 	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
 		printk(KERN_WARNING "%s: page allocation failure."
 			" order:%d, mode:0x%x\n",
-- 
1.5.6.3



