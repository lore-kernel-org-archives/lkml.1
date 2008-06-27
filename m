Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbYF0PTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbYF0PTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760685AbYF0PSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:18:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58822 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760428AbYF0PSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:18:34 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 27 Jun 2008 20:48:28 +0530
Message-Id: <20080627151828.31664.35650.sendpatchset@balbir-laptop>
In-Reply-To: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
References: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
Subject: [RFC 2/5] Add delete max to prio heap
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch enhances the priority heap infrastructure to add a delete_max
routine. This patch and routines are helpful as

1. They allow me to delete nodes from the prio_heap (max heap), which is
   currently missing
2. This infrastructure would be useful for the soft limit patches I am working
   on for the memory controller

Some of the common code has been factored into heap_adjust() a.k.a heapify
in data structures terminology.

I've tested them by porting the code to user space (very easy to do) and
I wrote a simple test routine, that ensures that elements are removed
from the heap in descending order.

Reviewed-by: Paul Menage <menage@google.com>

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/prio_heap.h |   10 +++++++-
 lib/prio_heap.c           |   56 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 48 insertions(+), 18 deletions(-)

diff -puN include/linux/prio_heap.h~prio_heap_delete_max include/linux/prio_heap.h
--- linux-2.6.26-rc5/include/linux/prio_heap.h~prio_heap_delete_max	2008-06-27 20:43:08.000000000 +0530
+++ linux-2.6.26-rc5-balbir/include/linux/prio_heap.h	2008-06-27 20:43:08.000000000 +0530
@@ -53,6 +53,14 @@ void heap_free(struct ptr_heap *heap);
  */
 extern void *heap_insert(struct ptr_heap *heap, void *p);
 
-
+/**
+ * heap_delete_max - delete the maximum element from the top of the heap
+ * @heap: The heap to be operated upon
+ *
+ * The top of the heap is removed, the last element is moved to the
+ * top and the entire heap is adjusted, so that the largest element bubbles
+ * up again
+ */
+extern void *heap_delete_max(struct ptr_heap *heap);
 
 #endif /* _LINUX_PRIO_HEAP_H */
diff -puN lib/prio_heap.c~prio_heap_delete_max lib/prio_heap.c
--- linux-2.6.26-rc5/lib/prio_heap.c~prio_heap_delete_max	2008-06-27 20:43:08.000000000 +0530
+++ linux-2.6.26-rc5-balbir/lib/prio_heap.c	2008-06-27 20:43:08.000000000 +0530
@@ -23,11 +23,33 @@ void heap_free(struct ptr_heap *heap)
 	kfree(heap->ptrs);
 }
 
+static void heap_adjust(struct ptr_heap *heap)
+{
+	int pos = 0;
+	void **ptrs = heap->ptrs;
+	void *p = ptrs[pos];
+
+	while (1) {
+		int left = 2 * pos + 1;
+		int right = 2 * pos + 2;
+		int largest = pos;
+		if (left < heap->size && heap->gt(ptrs[left], p))
+			largest = left;
+		if (right < heap->size && heap->gt(ptrs[right], ptrs[largest]))
+			largest = right;
+		if (largest == pos)
+			break;
+		/* Push p down the heap one level and bump one up */
+		ptrs[pos] = ptrs[largest];
+		ptrs[largest] = p;
+		pos = largest;
+	}
+}
+
 void *heap_insert(struct ptr_heap *heap, void *p)
 {
 	void *res;
 	void **ptrs = heap->ptrs;
-	int pos;
 
 	if (heap->size < heap->max) {
 		/* Heap insertion */
@@ -49,22 +71,22 @@ void *heap_insert(struct ptr_heap *heap,
 	/* Replace the current max and heapify */
 	res = ptrs[0];
 	ptrs[0] = p;
-	pos = 0;
+	heap_adjust(heap);
+	return res;
+}
+
+void *heap_delete_max(struct ptr_heap *heap)
+{
+	void **ptrs = heap->ptrs;
+	void *res;
+
+	if (heap->size == 0)
+		return NULL;		/* The heap is empty */
+
+	res = ptrs[0];
+	heap->size--;
+	ptrs[0] = ptrs[heap->size];	/* Put a leaf on top */
+	heap_adjust(heap);
 
-	while (1) {
-		int left = 2 * pos + 1;
-		int right = 2 * pos + 2;
-		int largest = pos;
-		if (left < heap->size && heap->gt(ptrs[left], p))
-			largest = left;
-		if (right < heap->size && heap->gt(ptrs[right], ptrs[largest]))
-			largest = right;
-		if (largest == pos)
-			break;
-		/* Push p down the heap one level and bump one up */
-		ptrs[pos] = ptrs[largest];
-		ptrs[largest] = p;
-		pos = largest;
-	}
 	return res;
 }
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
