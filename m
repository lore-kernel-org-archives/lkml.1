Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbXGHDxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbXGHDxj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 23:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbXGHDug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 23:50:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49255 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755389AbXGHDuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 23:50:18 -0400
Message-Id: <20070708035017.109044442@sgi.com>
References: <20070708034952.022985379@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 07 Jul 2007 20:49:57 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@vger.kernel.org
Cc: suresh.b.siddha@intel.com
Cc: corey.d.gough@intel.com
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Subject: [patch 05/10] SLUB: Avoid touching page struct when freeing to per cpu slab
Content-Disposition: inline; filename=slub_free_cpu_slab_no_page_struct
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of checking for SlabDebug which requires access the page struct
contents simply check the per cpu freepointer if its not NULL. It can only
be not NULL if !SlabDebug.

This means we will not free to the cpu slab if the per cpu list is
empty. In that case it is likely that the cpu slab is soon being
retired anyways. Not freeing to an empty freelist is also required
to avoid races in the cmpxchg alloc/free version.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc6-mm1/mm/slub.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/mm/slub.c	2007-07-05 19:05:29.000000000 -0700
+++ linux-2.6.22-rc6-mm1/mm/slub.c	2007-07-05 19:05:33.000000000 -0700
@@ -1525,6 +1531,7 @@ new_slab:
 	}
 	return NULL;
 debug:
+	c->freelist = NULL;
 	object = c->page->freelist;
 	if (!alloc_debug_processing(s, c->page, object, addr))
 		goto another_slab;
@@ -1663,7 +1670,7 @@ static void __always_inline slab_free(st
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (likely(page == c->page && !SlabDebug(page))) {
+	if (likely(page == c->page && c->freelist)) {
 		object[c->offset] = c->freelist;
 		c->freelist = object;
 	} else

-- 
