Return-Path: <linux-kernel-owner+w=401wt.eu-S1763146AbZANPUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763146AbZANPUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZANPUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:20:24 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52288 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbZANPUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:20:22 -0500
Date: Wed, 14 Jan 2009 17:20:19 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: cl@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SLUB: Use WARN_ON instead of BUG_ON where appropriate
Message-ID: <Pine.LNX.4.64.0901141719560.12990@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

It's better to WARN_ON and let the kernel limp along to increase the likelihood
of an user detecting the error and reporting it to us.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 6392ae5..e4404a1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1119,7 +1119,8 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 	void *last;
 	void *p;
 
-	BUG_ON(flags & GFP_SLAB_BUG_MASK);
+	if (WARN_ON(flags & GFP_SLAB_BUG_MASK))
+		return NULL;
 
 	page = allocate_slab(s,
 		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
@@ -2746,12 +2747,13 @@ void kfree(const void *x)
 		return;
 
 	page = virt_to_head_page(x);
-	if (unlikely(!PageSlab(page))) {
-		BUG_ON(!PageCompound(page));
-		put_page(page);
+	if (likely(PageSlab(page))) {
+		slab_free(page->slab, page, object, _RET_IP_);
 		return;
-	}
-	slab_free(page->slab, page, object, _RET_IP_);
+	} else if (WARN_ON(!PageCompound(page)))
+		return;
+
+	put_page(page);
 }
 EXPORT_SYMBOL(kfree);
 
@@ -4285,7 +4287,8 @@ static char *create_unique_id(struct kmem_cache *s)
 	char *name = kmalloc(ID_STR_LENGTH, GFP_KERNEL);
 	char *p = name;
 
-	BUG_ON(!name);
+	if (WARN_ON(!name))
+		return NULL;
 
 	*p++ = ':';
 	/*
@@ -4304,7 +4307,8 @@ static char *create_unique_id(struct kmem_cache *s)
 	if (p != name + 1)
 		*p++ = '-';
 	p += sprintf(p, "%07d", s->size);
-	BUG_ON(p > name + ID_STR_LENGTH - 1);
+	if (WARN_ON(p > name + ID_STR_LENGTH - 1))
+		return NULL;
 	return name;
 }
 
@@ -4333,6 +4337,8 @@ static int sysfs_slab_add(struct kmem_cache *s)
 		 * for the symlinks.
 		 */
 		name = create_unique_id(s);
+		if (!name)
+			return -EINVAL;
 	}
 
 	s->kobj.kset = slab_kset;
-- 
1.5.4.3

