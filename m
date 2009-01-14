Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbZANK31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbZANK31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZANK3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:29:16 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36925 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbZANK3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:29:15 -0500
Date: Wed, 14 Jan 2009 12:29:13 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: cl@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] SLUB: Use ->objsize from struct kmem_cache_cpu in slab_free()
Message-ID: <Pine.LNX.4.64.0901141225540.22173@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

There's no reason to use ->objsize from struct kmem_cache in slab_free() for
the SLAB_DEBUG_OBJECTS case. All it does is generate extra cache pressure 
as no one else touches struct kmem_cache in the fast-path.

Not that it matters all that much as the code is optimized away when 
CONFIG_DEBUG_OBJECTS is disabled and when it is enabled, the 
actual debugging checks are quite heavy-weight.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 57aa749..fa651c1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1727,7 +1727,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
 	c = get_cpu_slab(s, smp_processor_id());
 	debug_check_no_locks_freed(object, c->objsize);
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(object, s->objsize);
+		debug_check_no_obj_freed(object, c->objsize);
 	if (likely(page == c->page && c->node >= 0)) {
 		object[c->offset] = c->freelist;
 		c->freelist = object;
-- 
1.5.4.3

