Return-Path: <linux-kernel-owner+w=401wt.eu-S1763054AbZEHM5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763054AbZEHM5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760334AbZEHM5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:57:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37238 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759715AbZEHM53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:57:29 -0400
Subject: [RFC/PATCH v2] mm: Introduce GFP_PANIC for non-failing allocations
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, cl@linux.com, mingo@elte.hu,
       mel@csn.ul.ie, linux-kernel@vger.kernel.org, riel@redhat.com,
       rientjes@google.com, xemul@openvz.org
In-Reply-To: <20090504200925.GD31176@lenovo>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu>
	 <20090504131638.GJ4173@lenovo>
	 <alpine.DEB.1.10.0905040940490.9553@qirst.com>
	 <20090504115335.9bc08587.akpm@linux-foundation.org>
	 <20090504192117.GB31176@lenovo>
	 <20090504123453.d130a6cf.akpm@linux-foundation.org>
	 <20090504200925.GD31176@lenovo>
Date: Fri, 08 May 2009 15:57:28 +0300
Message-Id: <1241787448.28600.26.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

This patch introduces a GFP_PANIC flag that can be used as an annotation
that a call to kmalloc() or alloc_pages() is expected to never fail.
This is useful in early boot code, for example.

To save one GFP flag bit, use a combination of __GFP_NOFAIL,
__GFP_NOREPEAT, and __GFP_NOMEMALLOC to make sure we always end up in
the "nopage" path of the page allocator if an allocation fails.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Yes, this is totally untested and needs to be rebased on top of -mm.

 include/linux/gfp.h |    1 +
 mm/page_alloc.c     |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0bbc15f..c7c8a63 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -70,6 +70,7 @@ struct vm_area_struct;
 #define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
 				 __GFP_HARDWALL | __GFP_HIGHMEM | \
 				 __GFP_MOVABLE)
+#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY | __GFP_NOMEMALLOC)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e2f2699..4b062e5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1670,6 +1670,9 @@ nopage:
 		dump_stack();
 		show_mem();
 	}
+	if (unlikely(gfp_mask & GFP_PANIC))
+		panic("Out of memory: %s order: %d, gfp_mask:0x%x\n",
+			p->comm, order, gfp_mask);
 got_pg:
 	return page;
 }
-- 
1.5.6.3



