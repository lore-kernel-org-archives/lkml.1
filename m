Return-Path: <linux-kernel-owner+w=401wt.eu-S933220AbZFQMwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbZFQMwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759452AbZFQMwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:52:45 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52110 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759325AbZFQMwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:52:45 -0400
Subject: [PATCH] kmemleak: Only use GFP_KERNEL|GFP_ATOMIC for the internal
	allocations
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20090617124034.GE28529@csn.ul.ie>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org>
	 <20090616223649.719ea378.akpm@linux-foundation.org>
	 <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu>
	 <1245240677.11889.17.camel@pc1117.cambridge.arm.com>
	 <20090617122803.GD28529@csn.ul.ie>
	 <1245242160.11889.23.camel@pc1117.cambridge.arm.com>
	 <20090617124034.GE28529@csn.ul.ie>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 17 Jun 2009 13:52:10 +0100
Message-Id: <1245243130.11889.27.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2009 12:52:11.0860 (UTC) FILETIME=[6E944940:01C9EF4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kmemleak allocates memory for pointer tracking and it tries to avoid
using GFP_ATOMIC if the caller doesn't require it. However other gfp
flags may be passed by the caller which aren't required by kmemleak.
This patch filters the gfp flags so that only GFP_KERNEL | GFP_ATOMIC
are used.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 58ec86c..25e2034 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -109,6 +109,9 @@
 
 #define BYTES_PER_POINTER	sizeof(void *)
 
+/* GFP bitmask for kmemleak internal allocations */
+#define GFP_KMEMLEAK_MASK	(GFP_KERNEL | GFP_ATOMIC)
+
 /* scanning area inside a memory block */
 struct kmemleak_scan_area {
 	struct hlist_node node;
@@ -462,7 +465,7 @@ static void create_object(unsigned long ptr, size_t size, int min_count,
 	struct prio_tree_node *node;
 	struct stack_trace trace;
 
-	object = kmem_cache_alloc(object_cache, gfp & ~GFP_SLAB_BUG_MASK);
+	object = kmem_cache_alloc(object_cache, gfp & GFP_KMEMLEAK_MASK);
 	if (!object) {
 		kmemleak_panic("kmemleak: Cannot allocate a kmemleak_object "
 			       "structure\n");
@@ -636,7 +639,7 @@ static void add_scan_area(unsigned long ptr, unsigned long offset,
 		return;
 	}
 
-	area = kmem_cache_alloc(scan_area_cache, gfp & ~GFP_SLAB_BUG_MASK);
+	area = kmem_cache_alloc(scan_area_cache, gfp & GFP_KMEMLEAK_MASK);
 	if (!area) {
 		kmemleak_warn("kmemleak: Cannot allocate a scan area\n");
 		goto out;


