Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZCFP4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZCFP4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZCFPzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:55:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:35722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbZCFPzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:55:47 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, npiggin@suse.de,
       akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] percpu: replace pcpu_realloc() with pcpu_mem_alloc() and pcpu_mem_free()
Date: Sat,  7 Mar 2009 00:54:40 +0900
Message-Id: <1236354883-25063-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236354883-25063-1-git-send-email-tj@kernel.org>
References: <1236354883-25063-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 15:54:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code reorganization for later changes

With static map handling moved to pcpu_split_block(), pcpu_realloc()
only clutters the code and it's also unsuitable for scheduled locking
changes.  Implement and use pcpu_mem_alloc/free() instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |   85 +++++++++++++++++++++++++++++------------------------------
 1 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index ef8e169..f1d0e90 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -164,39 +164,41 @@ static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
 }
 
 /**
- * pcpu_realloc - versatile realloc
- * @p: the current pointer (can be NULL for new allocations)
- * @size: the current size in bytes (can be 0 for new allocations)
- * @new_size: the wanted new size in bytes (can be 0 for free)
+ * pcpu_mem_alloc - allocate memory
+ * @size: bytes to allocate
  *
- * More robust realloc which can be used to allocate, resize or free a
- * memory area of arbitrary size.  If the needed size goes over
- * PAGE_SIZE, kernel VM is used.
+ * Allocate @size bytes.  If @size is smaller than PAGE_SIZE,
+ * kzalloc() is used; otherwise, vmalloc() is used.  The returned
+ * memory is always zeroed.
  *
  * RETURNS:
- * The new pointer on success, NULL on failure.
+ * Pointer to the allocated area on success, NULL on failure.
  */
-static void *pcpu_realloc(void *p, size_t size, size_t new_size)
+static void *pcpu_mem_alloc(size_t size)
 {
-	void *new;
-
-	if (new_size <= PAGE_SIZE)
-		new = kmalloc(new_size, GFP_KERNEL);
-	else
-		new = vmalloc(new_size);
-	if (new_size && !new)
-		return NULL;
-
-	memcpy(new, p, min(size, new_size));
-	if (new_size > size)
-		memset(new + size, 0, new_size - size);
+	if (size <= PAGE_SIZE)
+		return kzalloc(size, GFP_KERNEL);
+	else {
+		void *ptr = vmalloc(size);
+		if (ptr)
+			memset(ptr, 0, size);
+		return ptr;
+	}
+}
 
+/**
+ * pcpu_mem_free - free memory
+ * @ptr: memory to free
+ * @size: size of the area
+ *
+ * Free @ptr.  @ptr should have been allocated using pcpu_mem_alloc().
+ */
+static void pcpu_mem_free(void *ptr, size_t size)
+{
 	if (size <= PAGE_SIZE)
-		kfree(p);
+		kfree(ptr);
 	else
-		vfree(p);
-
-	return new;
+		vfree(ptr);
 }
 
 /**
@@ -331,29 +333,27 @@ static int pcpu_split_block(struct pcpu_chunk *chunk, int i, int head, int tail)
 	if (chunk->map_alloc < target) {
 		int new_alloc;
 		int *new;
+		size_t size;
 
 		new_alloc = PCPU_DFL_MAP_ALLOC;
 		while (new_alloc < target)
 			new_alloc *= 2;
 
-		if (chunk->map_alloc < PCPU_DFL_MAP_ALLOC) {
-			/*
-			 * map_alloc smaller than the default size
-			 * indicates that the chunk is one of the
-			 * first chunks and still using static map.
-			 * Allocate a dynamic one and copy.
-			 */
-			new = pcpu_realloc(NULL, 0, new_alloc * sizeof(new[0]));
-			if (new)
-				memcpy(new, chunk->map,
-				       chunk->map_alloc * sizeof(new[0]));
-		} else
-			new = pcpu_realloc(chunk->map,
-					   chunk->map_alloc * sizeof(new[0]),
-					   new_alloc * sizeof(new[0]));
+		new = pcpu_mem_alloc(new_alloc * sizeof(new[0]));
 		if (!new)
 			return -ENOMEM;
 
+		size = chunk->map_alloc * sizeof(chunk->map[0]);
+		memcpy(new, chunk->map, size);
+
+		/*
+		 * map_alloc < PCPU_DFL_MAP_ALLOC indicates that the
+		 * chunk is one of the first chunks and still using
+		 * static map.
+		 */
+		if (chunk->map_alloc >= PCPU_DFL_MAP_ALLOC)
+			pcpu_mem_free(chunk->map, size);
+
 		chunk->map_alloc = new_alloc;
 		chunk->map = new;
 	}
@@ -696,7 +696,7 @@ static void free_pcpu_chunk(struct pcpu_chunk *chunk)
 		return;
 	if (chunk->vm)
 		free_vm_area(chunk->vm);
-	pcpu_realloc(chunk->map, chunk->map_alloc * sizeof(chunk->map[0]), 0);
+	pcpu_mem_free(chunk->map, chunk->map_alloc * sizeof(chunk->map[0]));
 	kfree(chunk);
 }
 
@@ -708,8 +708,7 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 	if (!chunk)
 		return NULL;
 
-	chunk->map = pcpu_realloc(NULL, 0,
-				  PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
+	chunk->map = pcpu_mem_alloc(PCPU_DFL_MAP_ALLOC * sizeof(chunk->map[0]));
 	chunk->map_alloc = PCPU_DFL_MAP_ALLOC;
 	chunk->map[chunk->map_used++] = pcpu_unit_size;
 	chunk->page = chunk->page_ar;
-- 
1.6.0.2

