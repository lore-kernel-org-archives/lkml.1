Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZDHRHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZDHRHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934853AbZDHRGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:06:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:38277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934849AbZDHRGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:06:47 -0400
Date: Wed, 8 Apr 2009 17:03:42 GMT
From: Christoph Lameter <cl@linux.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
       lethal@linux-sh.org, cl@linux.com, npiggin@suse.de, tj@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com, cl@linux.com,
       lethal@linux-sh.org, npiggin@suse.de, tj@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49D43D58.4050102@kernel.org>
References: <49D43D58.4050102@kernel.org>
Subject: [tip:core/percpu] percpu: remove rbtree and use page->index instead
Message-ID: <tip-e1b9aa3f47242e757c776a3771bb6613e675bf9c@git.kernel.org>
Git-Commit-ID: e1b9aa3f47242e757c776a3771bb6613e675bf9c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 17:03:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1b9aa3f47242e757c776a3771bb6613e675bf9c
Gitweb:     http://git.kernel.org/tip/e1b9aa3f47242e757c776a3771bb6613e675bf9c
Author:     Christoph Lameter <cl@linux.com>
AuthorDate: Thu, 2 Apr 2009 13:21:44 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 18:31:31 +0200

percpu: remove rbtree and use page->index instead

Impact: use page->index for addr to chunk mapping instead of dedicated rbtree

The rbtree is used to determine the chunk from the virtual address.
However, we can already determine the page struct from a virtual
address and there are several unused fields in page struct used by
vmalloc.  Use the index field to store a pointer to the chunk. Then
there is no need anymore for an rbtree.

tj: * s/(set|get)_chunk/pcpu_\1_page_chunk/

    * Drop inline from the above two functions and moved them upwards
      so that they are with other simple helpers.

    * Initial pages might not (actually most of the time don't) live
      in the vmalloc area.  With the previous patch to manually
      reverse-map both first chunks, this is no longer an issue.
      Removed pcpu_set_chunk() call on initial pages.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: rusty@rustcorp.com.au
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: rmk@arm.linux.org.uk
Cc: starvik@axis.com
Cc: ralf@linux-mips.org
Cc: davem@davemloft.net
Cc: cooloney@kernel.org
Cc: kyle@mcmartin.ca
Cc: matthew@wil.cx
Cc: grundler@parisc-linux.org
Cc: takata@linux-m32r.org
Cc: benh@kernel.crashing.org
Cc: rth@twiddle.net
Cc: ink@jurassic.park.msu.ru
Cc: heiko.carstens@de.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
LKML-Reference: <49D43D58.4050102@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 mm/percpu.c |  100 ++++++++++++-----------------------------------------------
 1 files changed, 20 insertions(+), 80 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index bf1bf1f..c0b2c1a 100644
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
@@ -133,7 +131,7 @@ static int pcpu_reserved_chunk_limit;
  * There are two locks - pcpu_alloc_mutex and pcpu_lock.  The former
  * protects allocation/reclaim paths, chunks and chunk->page arrays.
  * The latter is a spinlock and protects the index data structures -
- * chunk slots, rbtree, chunks and area maps in chunks.
+ * chunk slots, chunks and area maps in chunks.
  *
  * During allocation, pcpu_alloc_mutex is kept locked all the time and
  * pcpu_lock is grabbed and released as necessary.  All actual memory
@@ -152,7 +150,6 @@ static DEFINE_MUTEX(pcpu_alloc_mutex);	/* protects whole alloc and reclaim */
 static DEFINE_SPINLOCK(pcpu_lock);	/* protects index data structures */
 
 static struct list_head *pcpu_slot __read_mostly; /* chunk list slots */
-static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */
 
 /* reclaim work to release fully free chunks, scheduled from free path */
 static void pcpu_reclaim(struct work_struct *work);
@@ -203,6 +200,18 @@ static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
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
@@ -269,40 +278,9 @@ static void pcpu_chunk_relocate(struct pcpu_chunk *chunk, int oslot)
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
@@ -310,8 +288,6 @@ static struct rb_node **pcpu_chunk_rb_search(void *addr,
 static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 {
 	void *first_start = pcpu_first_chunk->vm->addr;
-	struct rb_node *n, *parent;
-	struct pcpu_chunk *chunk;
 
 	/* is it in the first chunk? */
 	if (addr >= first_start && addr < first_start + pcpu_chunk_size) {
@@ -321,42 +297,7 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 		return pcpu_first_chunk;
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
@@ -768,6 +709,7 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 						  alloc_mask, 0);
 			if (!*pagep)
 				goto err;
+			pcpu_set_page_chunk(*pagep, chunk);
 		}
 	}
 
@@ -892,7 +834,6 @@ restart:
 
 	spin_lock_irq(&pcpu_lock);
 	pcpu_chunk_relocate(chunk, -1);
-	pcpu_chunk_addr_insert(chunk);
 	goto restart;
 
 area_found:
@@ -981,7 +922,6 @@ static void pcpu_reclaim(struct work_struct *work)
 		if (chunk == list_first_entry(head, struct pcpu_chunk, list))
 			continue;
 
-		rb_erase(&chunk->rb_node, &pcpu_addr_root);
 		list_move(&chunk->list, &todo);
 	}
 
