Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbXEaAay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbXEaAay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 20:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbXEaAaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 20:30:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60133 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752887AbXEaAaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 20:30:14 -0400
Message-Id: <20070531003012.532539202@sgi.com>
References: <20070531002047.702473071@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 17:20:49 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [RFC 2/4] CONFIG_STABLE: Switch off kmalloc(0) tests in slab allocators
Content-Disposition: inline; filename=stable_kmalloc_zero
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We do not want kmalloc(0) to trigger stackdumps if this is a stable
kernel. kmalloc(0) is currently harmless.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |    2 ++
 mm/slab.c                |    2 ++
 2 files changed, 4 insertions(+)

Index: slub/include/linux/slub_def.h
===================================================================
--- slub.orig/include/linux/slub_def.h	2007-05-30 16:35:05.000000000 -0700
+++ slub/include/linux/slub_def.h	2007-05-30 16:37:39.000000000 -0700
@@ -74,6 +74,7 @@ extern struct kmem_cache kmalloc_caches[
  */
 static inline int kmalloc_index(size_t size)
 {
+#ifndef CONFIG_STABLE
 	/*
 	 * We should return 0 if size == 0 (which would result in the
 	 * kmalloc caller to get NULL) but we use the smallest object
@@ -81,6 +82,7 @@ static inline int kmalloc_index(size_t s
 	 * we can discover locations where we do 0 sized allocations.
 	 */
 	WARN_ON_ONCE(size == 0);
+#endif
 
 	if (size > KMALLOC_MAX_SIZE)
 		return -1;
Index: slub/mm/slab.c
===================================================================
--- slub.orig/mm/slab.c	2007-05-30 16:35:05.000000000 -0700
+++ slub/mm/slab.c	2007-05-30 16:37:39.000000000 -0700
@@ -774,7 +774,9 @@ static inline struct kmem_cache *__find_
 	 */
 	BUG_ON(malloc_sizes[INDEX_AC].cs_cachep == NULL);
 #endif
+#ifndef CONFIG_STABLE
 	WARN_ON_ONCE(size == 0);
+#endif
 	while (size > csizep->cs_size)
 		csizep++;
 

-- 
