Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbZFJWQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbZFJWQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbZFJWQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:16:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50968 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZFJWQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:16:43 -0400
Date: Thu, 11 Jun 2009 00:16:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/percpu for v2.6.31
Message-ID: <20090610221635.GA25816@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest percpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git percpu-for-linus

Two leftover straightforward dynamic percpu allocator changes 
(cleanup+speedup) affecting x86.

Tejun is carrying the remaining percpu patches (which affect other 
architectures).

 Thanks,

	Ingo

------------------>
Christoph Lameter (1):
      percpu: remove rbtree and use page->index instead

Tejun Heo (1):
      percpu: don't put the first chunk in reverse-map rbtree


 mm/percpu.c |  141 ++++++++++++++++++----------------------------------------
 1 files changed, 44 insertions(+), 97 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 1aa5d8f..c0b2c1a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -23,7 +23,7 @@
  * Allocation is done in offset-size areas of single unit space.  Ie,
  * an area of 512 bytes at 6k in c1 occupies 512 bytes at 6k of c1:u0,
  * c1:u1, c1:u2 and c1:u3.  Percpu access can be done by configuring
- * percpu base registers UNIT_SIZE apart.
+ * percpu base registers pcpu_unit_size apart.
  *
  * There are usually many small percpu allocations many of them as
  * small as 4 bytes.  The allocator organizes chunks into lists
@@ -38,8 +38,8 @@
  * region and negative allocated.  Allocation inside a chunk is done
  * by scanning this map sequentially and serving the first matching
  * entry.  This is mostly copied from the percpu_modalloc() allocator.
- * Chunks are also linked into a rb tree to ease address to chunk
- * mapping during free.
+ * Chunks can be determined from the address using the index field
+ * in the page struct. The index field contains a pointer to the chunk.
  *
  * To use this allocator, arch code should do the followings.
  *
@@ -61,7 +61,6 @@
 #include <linux/mutex.h>
 #include <linux/percpu.h>
 #include <linux/pfn.h>
-#include <linux/rbtree.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
@@ -88,7 +87,6 @@
 
 struct pcpu_chunk {
 	struct list_head	list;		/* linked to pcpu_slot lists */
-	struct rb_node		rb_node;	/* key is chunk->vm->addr */
 	int			free_size;	/* free bytes in the chunk */
 	int			contig_hint;	/* max contiguous size hint */
 	struct vm_struct	*vm;		/* mapped vmalloc region */
@@ -110,9 +108,21 @@ static size_t pcpu_chunk_struct_size __read_mostly;
 void *pcpu_base_addr __read_mostly;
 EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
-/* optional reserved chunk, only accessible for reserved allocations */
+/*
+ * The first chunk which always exists.  Note that unlike other
+ * chunks, this one can be allocated and mapped in several different
+ * ways and thus often doesn't live in the vmalloc area.
+ */
+static struct pcpu_chunk *pcpu_first_chunk;
+
+/*
+ * Optional reserved chunk.  This chunk reserves part of the first
+ * chunk and serves it for reserved allocations.  The amount of
+ * reserved offset is in pcpu_reserved_chunk_limit.  When reserved
+ * area doesn't exist, the following variables contain NULL and 0
+ * respectively.
+ */
 static struct pcpu_chunk *pcpu_reserved_chunk;
-/* offset limit of the reserved chunk */
 static int pcpu_reserved_chunk_limit;
 
 /*
@@ -121,7 +131,7 @@ static int pcpu_reserved_chunk_limit;
  * There are two locks - pcpu_alloc_mutex and pcpu_lock.  The former
  * protects allocation/reclaim paths, chunks and chunk->page arrays.
  * The latter is a spinlock and protects the index data structures -
- * chunk slots, rbtree, chunks and area maps in chunks.
+ * chunk slots, chunks and area maps in chunks.
  *
  * During allocation, pcpu_alloc_mutex is kept locked all the time and
  * pcpu_lock is grabbed and released as necessary.  All actual memory
@@ -140,7 +150,6 @@ static DEFINE_MUTEX(pcpu_alloc_mutex);	/* protects whole alloc and reclaim */
 static DEFINE_SPINLOCK(pcpu_lock);	/* protects index data structures */
 
 static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
-static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */
 
 /* reclaim work to release fully free chunks, scheduled from free path */
 static void pcpu_reclaim(struct work_struct *work);
@@ -191,6 +200,18 @@ static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
 	return *pcpu_chunk_pagep(chunk, 0, page_idx) != NULL;
 }
 
+/* set the pointer to a chunk in a page struct */
+static void pcpu_set_page_chunk(struct page *page, struct pcpu_chunk *pcpu)
+{
+	page->index = (unsigned long)pcpu;
+}
+
+/* obtain pointer to a chunk from a page struct */
+static struct pcpu_chunk *pcpu_get_page_chunk(struct page *page)
+{
+	return (struct pcpu_chunk *)page->index;
+}
+
 /**
  * pcpu_mem_alloc - allocate memory
  * @size: bytes to allocate
@@ -257,93 +278,26 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
 	}
 }
 
-static struct rb_node **pcpu_chunk_rb_search(void *addr,
-					     struct rb_node **parentp)
-{
-	struct rb_node **p = &pcpu_addr_root.rb_node;
-	struct rb_node *parent = NULL;
-	struct pcpu_chunk *chunk;
-
-	while (*p) {
-		parent = *p;
-		chunk = rb_entry(parent, struct pcpu_chunk, rb_node);
-
-		if (addr < chunk->vm->addr)
-			p = &(*p)->rb_left;
-		else if (addr > chunk->vm->addr)
-			p = &(*p)->rb_right;
-		else
-			break;
-	}
-
-	if (parentp)
-		*parentp = parent;
-	return p;
-}
-
 /**
- * pcpu_chunk_addr_search - search for chunk containing specified address
- * @addr: address to search for
- *
- * Look for chunk which might contain @addr.  More specifically, it
- * searchs for the chunk with the highest start address which isn't
- * beyond @addr.
- *
- * CONTEXT:
- * pcpu_lock.
+ * pcpu_chunk_addr_search - determine chunk containing specified address
+ * @addr: address for which the chunk needs to be determined.
  *
  * RETURNS:
  * The address of the found chunk.
  */
 static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 {
-	struct rb_node *n, *parent;
-	struct pcpu_chunk *chunk;
+	void *first_start = pcpu_first_chunk->vm->addr;
 
-	/* is it in the reserved chunk? */
-	if (pcpu_reserved_chunk) {
-		void *start = pcpu_reserved_chunk->vm->addr;
-
-		if (addr >= start && addr < start + pcpu_reserved_chunk_limit)
+	/* is it in the first chunk? */
+	if (addr >= first_start && addr < first_start + pcpu_chunk_size) {
+		/* is it in the reserved area? */
+		if (addr < first_start + pcpu_reserved_chunk_limit)
 			return pcpu_reserved_chunk;
+		return pcpu_first_chunk;
 	}
 
-	/* nah... search the regular ones */
-	n = *pcpu_chunk_rb_search(addr, &parent);
-	if (!n) {
-		/* no exactly matching chunk, the parent is the closest */
-		n = parent;
-		BUG_ON(!n);
-	}
-	chunk = rb_entry(n, struct pcpu_chunk, rb_node);
-
-	if (addr < chunk->vm->addr) {
-		/* the parent was the next one, look for the previous one */
-		n = rb_prev(n);
-		BUG_ON(!n);
-		chunk = rb_entry(n, struct pcpu_chunk, rb_node);
-	}
-
-	return chunk;
-}
-
-/**
- * pcpu_chunk_addr_insert - insert chunk into address rb tree
- * @new: chunk to insert
- *
- * Insert @new into address rb tree.
- *
- * CONTEXT:
- * pcpu_lock.
- */
-static void pcpu_chunk_addr_insert(struct pcpu_chunk *new)
-{
-	struct rb_node **p, *parent;
-
-	p = pcpu_chunk_rb_search(new->vm->addr, &parent);
-	BUG_ON(*p);
-	rb_link_node(&new->rb_node, parent, p);
-	rb_insert_color(&new->rb_node, &pcpu_addr_root);
+	return pcpu_get_page_chunk(vmalloc_to_page(addr));
 }
 
 /**
@@ -755,6 +709,7 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 						  alloc_mask, 0);
 			if (!*pagep)
 				goto err;
+			pcpu_set_page_chunk(*pagep, chunk);
 		}
 	}
 
@@ -879,7 +834,6 @@ restart:
 
 	spin_lock_irq(&pcpu_lock);
 	pcpu_chunk_relocate(chunk, -1);
-	pcpu_chunk_addr_insert(chunk);
 	goto restart;
 
 area_found:
@@ -968,7 +922,6 @@ static void pcpu_reclaim(struct work_struct *work)
 		if (chunk == list_first_entry(head, struct pcpu_chunk, list))
 			continue;
 
-		rb_erase(&chunk->rb_node, &pcpu_addr_root);
 		list_move(&chunk->list, &todo);
 	}
 
@@ -1147,7 +1100,8 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 
 	if (reserved_size) {
 		schunk->free_size = reserved_size;
-		pcpu_reserved_chunk = schunk;	/* not for dynamic alloc */
+		pcpu_reserved_chunk = schunk;
+		pcpu_reserved_chunk_limit = static_size + reserved_size;
 	} else {
 		schunk->free_size = dyn_size;
 		dyn_size = 0;			/* dynamic area covered */
@@ -1158,8 +1112,6 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	if (schunk->free_size)
 		schunk->map[schunk->map_used++] = schunk->free_size;
 
-	pcpu_reserved_chunk_limit = static_size + schunk->free_size;
-
 	/* init dynamic chunk if necessary */
 	if (dyn_size) {
 		dchunk = alloc_bootmem(sizeof(struct pcpu_chunk));
@@ -1226,13 +1178,8 @@ size_t __init pcpu_setup_first_chunk(pcpu_get_page_fn_t get_page_fn,
 	}
 
 	/* link the first chunk in */
-	if (!dchunk) {
-		pcpu_chunk_relocate(schunk, -1);
-		pcpu_chunk_addr_insert(schunk);
-	} else {
-		pcpu_chunk_relocate(dchunk, -1);
-		pcpu_chunk_addr_insert(dchunk);
-	}
+	pcpu_first_chunk = dchunk ?: schunk;
+	pcpu_chunk_relocate(pcpu_first_chunk, -1);
 
 	/* we're done */
 	pcpu_base_addr = (void *)pcpu_chunk_addr(schunk, 0, 0);
