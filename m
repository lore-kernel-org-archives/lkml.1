Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab0BKUyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:54:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36916 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab0BKUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:54:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20100211953.850854588@firstfloor.org>
In-Reply-To: <20100211953.850854588@firstfloor.org>
To: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com, rientjes@google.com
Subject: [PATCH] [1/4] SLAB: Handle node-not-up case in fallback_alloc() v2
Message-Id: <20100211205401.002CFB1978@basil.firstfloor.org>
Date: Thu, 11 Feb 2010 21:54:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When fallback_alloc() runs the node of the CPU might not be initialized yet.
Handle this case by allocating in another node.

v2: Try to allocate from all nodes (David Rientjes)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/slab.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

Index: linux-2.6.32-memhotadd/mm/slab.c
===================================================================
--- linux-2.6.32-memhotadd.orig/mm/slab.c
+++ linux-2.6.32-memhotadd/mm/slab.c
@@ -3188,7 +3188,24 @@ retry:
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
+				if (cache->nodelists[nid]) {
+					obj = kmem_getpages(cache, local_flags, nid);
+					if (obj)
+						break;
+				}
+			}
+		} else
+			obj = kmem_getpages(cache, local_flags, nid);
+
 		if (local_flags & __GFP_WAIT)
 			local_irq_disable();
 		if (obj) {
