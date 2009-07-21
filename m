Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZGUKba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZGUKba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZGUKbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:31:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:37075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbZGUK2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:04 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/20] percpu: add chunk->base_addr
Date: Tue, 21 Jul 2009 19:26:11 +0900
Message-Id: <1248171979-29166-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only thing percpu allocator wants to know about a vmalloc area is
the base address.  Instead of requiring chunk->vm, add
chunk->base_addr which contains the necessary value.  This simplifies
the code a bit and makes the dummy first_vm unnecessary.  This change
will ease allowing a chunk to be mapped by multiple vms.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 8167fb8..7b5e194 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -94,10 +94,11 @@ struct pcpu_chunk {
 	struct list_head	list;		/* linked to pcpu_slot lists */
 	int			free_size;	/* free bytes in the chunk */
 	int			contig_hint;	/* max contiguous size hint */
-	struct vm_struct	*vm;		/* mapped vmalloc region */
+	void			*base_addr;	/* base address of this chunk */
 	int			map_used;	/* # of map entries used */
 	int			map_alloc;	/* # of map entries allocated */
 	int			*map;		/* allocation map */
+	struct vm_struct	*vm;		/* mapped vmalloc region */
 	bool			immutable;	/* no [de]population allowed */
 	unsigned long		populated[];	/* populated bitmap */
 };
@@ -196,7 +197,7 @@ static int pcpu_page_idx(unsigned int cpu, int page_idx)
 static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
 				     unsigned int cpu, int page_idx)
 {
-	return (unsigned long)chunk->vm->addr + pcpu_unit_offsets[cpu] +
+	return (unsigned long)chunk->base_addr + pcpu_unit_offsets[cpu] +
 		(page_idx << PAGE_SHIFT);
 }
 
@@ -324,7 +325,7 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
  */
 static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 {
-	void *first_start = pcpu_first_chunk->vm->addr;
+	void *first_start = pcpu_first_chunk->base_addr;
 
 	/* is it in the first chunk? */
 	if (addr >= first_start && addr < first_start + pcpu_unit_size) {
@@ -1014,6 +1015,7 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 	INIT_LIST_HEAD(&chunk->list);
 	chunk->free_size = pcpu_unit_size;
 	chunk->contig_hint = pcpu_unit_size;
+	chunk->base_addr = chunk->vm->addr;
 
 	return chunk;
 }
@@ -1103,8 +1105,8 @@ area_found:
 
 	mutex_unlock(&pcpu_alloc_mutex);
 
-	/* return address relative to unit0 */
-	return __addr_to_pcpu_ptr(chunk->vm->addr + off);
+	/* return address relative to base address */
+	return __addr_to_pcpu_ptr(chunk->base_addr + off);
 
 fail_unlock:
 	spin_unlock_irq(&pcpu_lock);
@@ -1213,7 +1215,7 @@ void free_percpu(void *ptr)
 	spin_lock_irqsave(&pcpu_lock, flags);
 
 	chunk = pcpu_chunk_addr_search(addr);
-	off = addr - chunk->vm->addr;
+	off = addr - chunk->base_addr;
 
 	pcpu_free_area(chunk, off);
 
@@ -1565,7 +1567,6 @@ static void pcpu_dump_alloc_info(const char *lvl,
 int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 				  void *base_addr)
 {
-	static struct vm_struct first_vm;
 	static int smap[2], dmap[2];
 	size_t dyn_size = ai->dyn_size;
 	size_t size_sum = ai->static_size + ai->reserved_size + dyn_size;
@@ -1629,10 +1630,6 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
 		BITS_TO_LONGS(pcpu_unit_pages) * sizeof(unsigned long);
 
-	first_vm.flags = VM_ALLOC;
-	first_vm.size = pcpu_chunk_size;
-	first_vm.addr = base_addr;
-
 	/*
 	 * Allocate chunk slots.  The additional last slot is for
 	 * empty chunks.
@@ -1651,7 +1648,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	 */
 	schunk = alloc_bootmem(pcpu_chunk_struct_size);
 	INIT_LIST_HEAD(&schunk->list);
-	schunk->vm = &first_vm;
+	schunk->base_addr = base_addr;
 	schunk->map = smap;
 	schunk->map_alloc = ARRAY_SIZE(smap);
 	schunk->immutable = true;
@@ -1675,7 +1672,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	if (dyn_size) {
 		dchunk = alloc_bootmem(pcpu_chunk_struct_size);
 		INIT_LIST_HEAD(&dchunk->list);
-		dchunk->vm = &first_vm;
+		dchunk->base_addr = base_addr;
 		dchunk->map = dmap;
 		dchunk->map_alloc = ARRAY_SIZE(dmap);
 		dchunk->immutable = true;
@@ -1691,7 +1688,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	pcpu_chunk_relocate(pcpu_first_chunk, -1);
 
 	/* we're done */
-	pcpu_base_addr = schunk->vm->addr;
+	pcpu_base_addr = base_addr;
 	return 0;
 }
 
-- 
1.6.0.2

