Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbYAaEXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbYAaEXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 23:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYAaEXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 23:23:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:39184 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYAaEXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 23:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=imKzkQfDOiyaGePuuLUQdYpcZEGfFcGfkk0BsWkwlrTLCTonm3JdexsVTG6UA4BNV3aegPUOeGdhv4PqAoLSSmtIrcrR60QKTi0lkrLntzDP6WKWVdxUCN0rCff3obq4o71mrHl2RMxjwruyF40QAQwhOLYeyg4HFWfY4+dg8nw=
Subject: [PATCH] slub: fix shadowed variable sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 20:23:25 -0800
Message-Id: <1201753405.23523.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use *nd for *n:
mm/slub.c:3406:26: warning: symbol 'n' shadows an earlier one
mm/slub.c:3393:6: originally declared here

No need to declare new node:
mm/slub.c:3501:7: warning: symbol 'node' shadows an earlier one
mm/slub.c:3491:6: originally declared here

No need to declare new x:
mm/slub.c:3513:9: warning: symbol 'x' shadows an earlier one
mm/slub.c:3492:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 mm/slub.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5cc4b7d..f9a20bf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3403,19 +3403,19 @@ static int list_locations(struct kmem_cache *s, char *buf,
 	flush_all(s);
 
 	for_each_node_state(node, N_NORMAL_MEMORY) {
-		struct kmem_cache_node *n = get_node(s, node);
+		struct kmem_cache_node *nd = get_node(s, node);
 		unsigned long flags;
 		struct page *page;
 
-		if (!atomic_long_read(&n->nr_slabs))
+		if (!atomic_long_read(&nd->nr_slabs))
 			continue;
 
-		spin_lock_irqsave(&n->list_lock, flags);
-		list_for_each_entry(page, &n->partial, lru)
+		spin_lock_irqsave(&nd->list_lock, flags);
+		list_for_each_entry(page, &nd->partial, lru)
 			process_slab(&t, s, page, alloc);
-		list_for_each_entry(page, &n->full, lru)
+		list_for_each_entry(page, &nd->full, lru)
 			process_slab(&t, s, page, alloc);
-		spin_unlock_irqrestore(&n->list_lock, flags);
+		spin_unlock_irqrestore(&nd->list_lock, flags);
 	}
 
 	for (i = 0; i < t.count; i++) {
@@ -3498,7 +3498,6 @@ static unsigned long slab_objects(struct kmem_cache *s,
 
 	for_each_possible_cpu(cpu) {
 		struct page *page;
-		int node;
 		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
 
 		if (!c)
@@ -3510,8 +3509,6 @@ static unsigned long slab_objects(struct kmem_cache *s,
 			continue;
 		if (page) {
 			if (flags & SO_CPU) {
-				int x = 0;
-
 				if (flags & SO_OBJECTS)
 					x = page->inuse;
 				else
-- 
1.5.4.rc4.1142.gf5a97



