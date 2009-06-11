Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbZFKFVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbZFKFVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757073AbZFKFUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:20:52 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39251 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbZFKFUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:20:52 -0400
Date: Thu, 11 Jun 2009 08:20:54 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, hannes@cmpxchg.org,
       torvalds@linux-foundation.org, yinghai@kernel.org
Subject: [PATCH 4/4] bootmem: fix slab fallback on numa
Message-ID: <Pine.LNX.4.64.0906110820310.2258@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

If the user requested bootmem allocation on a specific node, we should use
kzalloc_node() for the fallback allocation.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/bootmem.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 457269c..282df0a 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -665,6 +665,9 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
 	return ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
 }
 
@@ -696,6 +699,9 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 {
 	void *ptr;
 
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
 	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
@@ -748,6 +754,9 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
 	return ___alloc_bootmem_node(pgdat->bdata, size, align,
 				goal, ARCH_LOW_ADDRESS_LIMIT);
 }
-- 
1.6.0.4

