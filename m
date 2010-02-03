Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0BCVjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:39:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42214 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815Ab0BCVjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:39:16 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201002031039.710275915@firstfloor.org>
In-Reply-To: <201002031039.710275915@firstfloor.org>
To: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: [PATCH] [1/4] SLAB: Handle node-not-up case in fallback_alloc()
Message-Id: <20100203213912.D3081B1620@basil.firstfloor.org>
Date: Wed,  3 Feb 2010 22:39:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When fallback_alloc() runs the node of the CPU might not be initialized yet.
Handle this case by allocating in another node.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/slab.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux-2.6.33-rc3-ak/mm/slab.c
===================================================================
--- linux-2.6.33-rc3-ak.orig/mm/slab.c
+++ linux-2.6.33-rc3-ak/mm/slab.c
@@ -3210,7 +3210,24 @@ retry:
 		if (local_flags & __GFP_WAIT)
 			local_irq_enable();
 		kmem_flagcheck(cache, flags);
-		obj = kmem_getpages(cache, local_flags, numa_node_id());
+
+		/*
+		 * Node not set up yet? Try one that the cache has been set up
+		 * for.
+		 */
+		nid = numa_node_id();
+		if (cache->nodelists[nid] == NULL) {
+			for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
+				nid = zone_to_nid(zone);
+				if (cache->nodelists[nid])
+					break;
+			}
+			if (!cache->nodelists[nid])
+				return NULL;
+		}
+
+
+		obj = kmem_getpages(cache, local_flags, nid);
 		if (local_flags & __GFP_WAIT)
 			local_irq_disable();
 		if (obj) {
