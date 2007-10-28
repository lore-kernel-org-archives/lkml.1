Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbXJ1DdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbXJ1DdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 23:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbXJ1DdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 23:33:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59545 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750948AbXJ1Dc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 23:32:59 -0400
Message-Id: <20071028033258.779134394@sgi.com>
References: <20071028033156.022983073@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Oct 2007 20:31:58 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 02/10] SLUB: Noinline some functions to avoid them being folded into alloc/free
Content-Disposition: inline; filename=slub_noinline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some function tend to get folded into __slab_free and __slab_alloc
although they are rarely called. They cause register pressure that
leads to bad code generation.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-10-25 19:36:10.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-10-25 19:36:59.000000000 -0700
@@ -831,8 +831,8 @@ static void setup_object_debug(struct km
 	init_tracking(s, object);
 }
 
-static int alloc_debug_processing(struct kmem_cache *s, struct page *page,
-						void *object, void *addr)
+static noinline int alloc_debug_processing(struct kmem_cache *s,
+		struct page *page, void *object, void *addr)
 {
 	if (!check_slab(s, page))
 		goto bad;
@@ -871,8 +871,8 @@ bad:
 	return 0;
 }
 
-static int free_debug_processing(struct kmem_cache *s, struct page *page,
-						void *object, void *addr)
+static noinline int free_debug_processing(struct kmem_cache *s,
+			struct page *page, void *object, void *addr)
 {
 	if (!check_slab(s, page))
 		goto fail;
@@ -1075,7 +1075,8 @@ static void setup_object(struct kmem_cac
 		s->ctor(s, object);
 }
 
-static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
+static noinline struct page *new_slab(struct kmem_cache *s,
+						gfp_t flags, int node)
 {
 	struct page *page;
 	struct kmem_cache_node *n;
@@ -1209,7 +1210,7 @@ static void add_partial(struct kmem_cach
 	spin_unlock(&n->list_lock);
 }
 
-static void remove_partial(struct kmem_cache *s,
+static noinline void remove_partial(struct kmem_cache *s,
 						struct page *page)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));

-- 
