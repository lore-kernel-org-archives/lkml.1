Return-Path: <linux-kernel-owner+w=401wt.eu-S1761796AbZCaQT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761796AbZCaQT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759566AbZCaQTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:19:17 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:40419 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759573AbZCaQTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:19:16 -0400
Date: Tue, 31 Mar 2009 12:14:20 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
In-Reply-To: <alpine.DEB.1.10.0903301049060.13333@qirst.com>
Message-ID: <alpine.DEB.1.10.0903311212360.17960@qirst.com>
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase> <49CA1AC3.9080908@kernel.org> <20090325150035.541e707a@skybase>
 <49CA3C2C.5030702@kernel.org> <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needs additional feedback and review by Tejun I would think. Just compile
tested so far. The removal of the rbtree also relaxes locking restrictions
for pcpu_chunk_address_search (which is not really searching anymore).


Subject: dynamic percpu allocator: Remove rbtree

The rbtree is used to determine the chunk from the virtual address. However,
we can already determine the page struct from a virtual address and there
are several unused fields in page struct used by vmalloc. Use the index
field to store a pointer to the chunk. Then there is no need anymore for
an rbtree.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/percpu.c |  101 +++++++++++-------------------------------------------------
 1 file changed, 19 insertions(+), 82 deletions(-)

Index: linux-2.6/mm/percpu.c
===================================================================
--- linux-2.6.orig/mm/percpu.c	2009-03-31 11:02:01.000000000 -0500
+++ linux-2.6/mm/percpu.c	2009-03-31 11:04:04.000000000 -0500
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
@@ -121,7 +119,7 @@ static int pcpu_reserved_chunk_limit;
  * There are two locks - pcpu_alloc_mutex and pcpu_lock.  The former
  * protects allocation/reclaim paths, chunks and chunk->page arrays.
  * The latter is a spinlock and protects the index data structures -
- * chunk slots, rbtree, chunks and area maps in chunks.
+ * chunk slots, chunks and area maps in chunks.
  *
  * During allocation, pcpu_alloc_mutex is kept locked all the time and
  * pcpu_lock is grabbed and released as necessary.  All actual memory
@@ -140,7 +138,6 @@ static DEFINE_MUTEX(pcpu_alloc_mutex);	/
 static DEFINE_SPINLOCK(pcpu_lock);	/* protects index data structures */

 static struct list_head *pcpu_slot; /* chunk list slots */
-static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */

 /* reclaim work to release fully free chunks, scheduled from free path */
 static void pcpu_reclaim(struct work_struct *work);
@@ -257,49 +254,27 @@ static void pcpu_chunk_relocate(struct p
 	}
 }

-static struct rb_node **pcpu_chunk_rb_search(void *addr,
-					     struct rb_node **parentp)
+/* Set the pointer to a chunk in a page struct */
+static inline void set_chunk(struct page *page, struct pcpu_chunk *pcpu)
 {
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
+	page->index = (unsigned long)pcpu;
+}

-	if (parentp)
-		*parentp = parent;
-	return p;
+/* Obtain pointer to a chunk from a page struct */
+static inline struct pcpu_chunk*get_chunk(struct page *page)
+{
+	return (struct pcpu_chunk *)page->index;
 }

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
-
 	/* is it in the reserved chunk? */
 	if (pcpu_reserved_chunk) {
 		void *start = pcpu_reserved_chunk->vm->addr;
@@ -308,42 +283,7 @@ static struct pcpu_chunk *pcpu_chunk_add
 			return pcpu_reserved_chunk;
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
+	return get_chunk(vmalloc_to_page(addr));
 }

 /**
@@ -755,6 +695,7 @@ static int pcpu_populate_chunk(struct pc
 						  alloc_mask, 0);
 			if (!*pagep)
 				goto err;
+			set_chunk(*pagep, chunk);
 		}
 	}

@@ -879,7 +820,6 @@ restart:

 	spin_lock_irq(&pcpu_lock);
 	pcpu_chunk_relocate(chunk, -1);
-	pcpu_chunk_addr_insert(chunk);
 	goto restart;

 area_found:
@@ -968,7 +908,6 @@ static void pcpu_reclaim(struct work_str
 		if (chunk == list_first_entry(head, struct pcpu_chunk, list))
 			continue;

-		rb_erase(&chunk->rb_node, &pcpu_addr_root);
 		list_move(&chunk->list, &todo);
 	}

@@ -1202,6 +1141,7 @@ size_t __init pcpu_setup_first_chunk(pcp
 			if (!page)
 				break;
 			*pcpu_chunk_pagep(schunk, cpu, i) = page;
+			set_chunk(page, schunk);
 		}

 		BUG_ON(i < PFN_UP(static_size));
@@ -1226,13 +1166,10 @@ size_t __init pcpu_setup_first_chunk(pcp
 	}

 	/* link the first chunk in */
-	if (!dchunk) {
+	if (!dchunk)
 		pcpu_chunk_relocate(schunk, -1);
-		pcpu_chunk_addr_insert(schunk);
-	} else {
+	else
 		pcpu_chunk_relocate(dchunk, -1);
-		pcpu_chunk_addr_insert(dchunk);
-	}

 	/* we're done */
 	pcpu_base_addr = (void *)pcpu_chunk_addr(schunk, 0, 0);

