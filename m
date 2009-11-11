Return-Path: <linux-kernel-owner+w=401wt.eu-S1751393AbZKKItR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbZKKItR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbZKKItR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:49:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:43284 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZKKItQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:49:16 -0500
Message-ID: <4AFA7A83.7080703@kernel.org>
Date: Wed, 11 Nov 2009 17:49:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH percpu#for-linus] percpu: restructure pcpu_extend_area_map()
 to fix bugs and improve readability
References: <4AF90254.40909@kernel.org> <alpine.LFD.2.01.0911100903370.31845@localhost.localdomain> <4AF9B1FD.1010408@kernel.org> <alpine.LFD.2.01.0911101042140.31845@localhost.localdomain> <4AF9BE3A.40409@kernel.org> <20091110193705.GA9011@elte.hu>
In-Reply-To: <20091110193705.GA9011@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcpu_extend_area_map() had the following two bugs.

* It should return 1 if pcpu_lock was dropped and reacquired but it
  returned 0.  This could lead to oops if free_percpu() races with
  area map extension.

* pcpu_mem_free() was called under pcpu_lock.  pcpu_mem_free() might
  end up calling vfree() which isn't IRQ safe.  This could lead to
  deadlock through lock order inversion via IRQ.

In addition, Linus pointed out that the temporary lock dropping and
subtle three-way return value of pcpu_extend_area_map() was very ugly
and suggested to split the function into two - pcpu_need_to_extend()
and pcpu_extend_area_map().

This patch restructures pcpu_extend_area_map() as suggested and fixes
the two bugs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
I've also put this patch on percpu#for-linus but routing this through
tip would be safer.  Went through usual battery of tests and also
verified both bugs are fixed.  Ingo, can you please put this into tip?

Thanks.

 mm/percpu.c |  122 +++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 82 insertions(+), 40 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index d907971..46f037a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -355,62 +355,86 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 }

 /**
- * pcpu_extend_area_map - extend area map for allocation
- * @chunk: target chunk
+ * pcpu_need_to_extend - determine whether chunk area map needs to be extended
+ * @chunk: chunk of interest
  *
- * Extend area map of @chunk so that it can accomodate an allocation.
- * A single allocation can split an area into three areas, so this
- * function makes sure that @chunk->map has at least two extra slots.
+ * Determine whether area map of @chunk needs to be extended to
+ * accomodate a new allocation.
  *
  * CONTEXT:
- * pcpu_alloc_mutex, pcpu_lock.  pcpu_lock is released and reacquired
- * if area map is extended.
+ * pcpu_lock.
  *
  * RETURNS:
- * 0 if noop, 1 if successfully extended, -errno on failure.
+ * New target map allocation length if extension is necessary, 0
+ * otherwise.
  */
-static int pcpu_extend_area_map(struct pcpu_chunk *chunk, unsigned long *flags)
+static int pcpu_need_to_extend(struct pcpu_chunk *chunk)
 {
 	int new_alloc;
-	int *new;
-	size_t size;

-	/* has enough? */
 	if (chunk->map_alloc >= chunk->map_used + 2)
 		return 0;

-	spin_unlock_irqrestore(&pcpu_lock, *flags);
-
 	new_alloc = PCPU_DFL_MAP_ALLOC;
 	while (new_alloc < chunk->map_used + 2)
 		new_alloc *= 2;

-	new = pcpu_mem_alloc(new_alloc * sizeof(new[0]));
-	if (!new) {
-		spin_lock_irqsave(&pcpu_lock, *flags);
+	return new_alloc;	
+}
+
+/**
+ * pcpu_extend_area_map - extend area map of a chunk
+ * @chunk: chunk of interest
+ * @new_alloc: new target allocation length of the area map
+ *
+ * Extend area map of @chunk to have @new_alloc entries.
+ *
+ * CONTEXT:
+ * Does GFP_KERNEL allocation.  Grabs and releases pcpu_lock.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+static int pcpu_extend_area_map(struct pcpu_chunk *chunk, int new_alloc)
+{
+	int *old = NULL, *new = NULL;
+	size_t old_size = 0, new_size = new_alloc * sizeof(new[0]);
+	unsigned long flags;
+
+	new = pcpu_mem_alloc(new_size);
+	if (!new)
 		return -ENOMEM;
-	}

-	/*
-	 * Acquire pcpu_lock and switch to new area map.  Only free
-	 * could have happened inbetween, so map_used couldn't have
-	 * grown.
-	 */
-	spin_lock_irqsave(&pcpu_lock, *flags);
-	BUG_ON(new_alloc < chunk->map_used + 2);
+	/* acquire pcpu_lock and switch to new area map */
+	spin_lock_irqsave(&pcpu_lock, flags);
+
+	if (new_alloc <= chunk->map_alloc)
+		goto out_unlock;

-	size = chunk->map_alloc * sizeof(chunk->map[0]);
-	memcpy(new, chunk->map, size);
+	old_size = chunk->map_alloc * sizeof(chunk->map[0]);
+	memcpy(new, chunk->map, old_size);

 	/*
 	 * map_alloc < PCPU_DFL_MAP_ALLOC indicates that the chunk is
 	 * one of the first chunks and still using static map.
 	 */
 	if (chunk->map_alloc >= PCPU_DFL_MAP_ALLOC)
-		pcpu_mem_free(chunk->map, size);
+		old = chunk->map;

 	chunk->map_alloc = new_alloc;
 	chunk->map = new;
+	new = NULL;
+
+out_unlock:
+	spin_unlock_irqrestore(&pcpu_lock, flags);
+
+	/*
+	 * pcpu_mem_free() might end up calling vfree() which uses
+	 * IRQ-unsafe lock and thus can't be called under pcpu_lock.
+	 */
+	pcpu_mem_free(old, old_size);
+	pcpu_mem_free(new, new_size);
+
 	return 0;
 }

@@ -1049,7 +1073,7 @@ static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 	static int warn_limit = 10;
 	struct pcpu_chunk *chunk;
 	const char *err;
-	int slot, off;
+	int slot, off, new_alloc;
 	unsigned long flags;

 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE)) {
@@ -1064,14 +1088,26 @@ static void *pcpu_alloc(size_t size, size_t align, bool reserved)
 	/* serve reserved allocations from the reserved chunk if available */
 	if (reserved && pcpu_reserved_chunk) {
 		chunk = pcpu_reserved_chunk;
-		if (size > chunk->contig_hint ||
-		    pcpu_extend_area_map(chunk, &flags) < 0) {
-			err = "failed to extend area map of reserved chunk";
+
+		if (size > chunk->contig_hint) {
+			err = "alloc from reserved chunk failed";
 			goto fail_unlock;
 		}
+
+		while ((new_alloc = pcpu_need_to_extend(chunk))) {
+			spin_unlock_irqrestore(&pcpu_lock, flags);
+			if (pcpu_extend_area_map(chunk, new_alloc) < 0) {
+				err = "failed to extend area map of "
+					"reserved chunk";
+				goto fail_unlock_mutex;
+			}
+			spin_lock_irqsave(&pcpu_lock, flags);
+		}
+
 		off = pcpu_alloc_area(chunk, size, align);
 		if (off >= 0)
 			goto area_found;
+
 		err = "alloc from reserved chunk failed";
 		goto fail_unlock;
 	}
@@ -1083,14 +1119,20 @@ restart:
 			if (size > chunk->contig_hint)
 				continue;

-			switch (pcpu_extend_area_map(chunk, &flags)) {
-			case 0:
-				break;
-			case 1:
-				goto restart;	/* pcpu_lock dropped, restart */
-			default:
-				err = "failed to extend area map";
-				goto fail_unlock;
+			new_alloc = pcpu_need_to_extend(chunk);
+			if (new_alloc) {
+				spin_unlock_irqrestore(&pcpu_lock, flags);
+				if (pcpu_extend_area_map(chunk,
+							 new_alloc) < 0) {
+					err = "failed to extend area map";
+					goto fail_unlock_mutex;
+				}
+				spin_lock_irqsave(&pcpu_lock, flags);
+				/*
+				 * pcpu_lock has been dropped, need to
+				 * restart cpu_slot list walking.
+				 */
+				goto restart;
 			}

 			off = pcpu_alloc_area(chunk, size, align);
-- 
1.6.4.2

