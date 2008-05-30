Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYE3UGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYE3UGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYE3UDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:03:22 -0400
Received: from saeurebad.de ([85.214.36.134]:60914 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbYE3UDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:03:21 -0400
Message-Id: <20080530194739.627414261@saeurebad.de>
References: <20080530194220.286976884@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 30 May 2008 21:42:32 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH -mm 12/14] bootmem: Make __alloc_bootmem_low_node fall back to other nodes
Content-Disposition: inline; filename=bootmem-make__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__alloc_bootmem_node already does this, make the interface consistent.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>
---

 mm/bootmem.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -595,6 +595,19 @@ void * __init __alloc_bootmem_low(unsign
 	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
 }
 
+static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
+				unsigned long size, unsigned long align,
+				unsigned long goal, unsigned long limit)
+{
+	void *ptr;
+
+	ptr = alloc_bootmem_core(bdata, size, align, goal, limit);
+	if (ptr)
+		return ptr;
+
+	return ___alloc_bootmem(size, align, goal, limit);
+}
+
 /**
  * __alloc_bootmem_node - allocate boot memory from a specific node
  * @pgdat: node to allocate from
@@ -613,13 +626,7 @@ void * __init __alloc_bootmem_low(unsign
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-	void *ptr;
-
-	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
-	if (ptr)
-		return ptr;
-
-	return __alloc_bootmem(size, align, goal);
+	return ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
 }
 
 /**
@@ -640,8 +647,8 @@ void * __init __alloc_bootmem_node(pg_da
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	return alloc_bootmem_core(pgdat->bdata, size, align, goal,
-				ARCH_LOW_ADDRESS_LIMIT);
+	return ___alloc_bootmem_node(pgdat->bdata, size, align,
+				goal, ARCH_LOW_ADDRESS_LIMIT);
 }
 
 #ifdef CONFIG_SPARSEMEM

-- 

