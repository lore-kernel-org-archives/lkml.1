Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZBUHzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZBUHzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 02:55:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZBUHzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 02:55:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:58760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbZBUHzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 02:55:32 -0500
Message-ID: <499FB36B.4040502@kernel.org>
Date: Sat, 21 Feb 2009 16:55:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: [PATCH tj-percpu] percpu: clean up size usage
References: <1234958676-27618-1-git-send-email-tj@kernel.org>	<1234958676-27618-10-git-send-email-tj@kernel.org>	<499E5BF9.1060806@kernel.org> <20090220003743.d787107b.akpm@linux-foundation.org> <499F73BD.4030105@kernel.org> <499F7836.5090608@kernel.org> <499FB1D8.1090601@kernel.org>
In-Reply-To: <499FB1D8.1090601@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 21 Feb 2009 07:55:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew was concerned about the unit of variables named or have suffix
size.  Every usage in percpu allocator is in bytes but make it super
clear by adding comments.

While at it, make pcpu_depopulate_chunk() take int @off and @size like
everyone else.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Thanks.

 mm/percpu.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 4617d97..297b31f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -119,7 +119,7 @@ static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */
 
 static int pcpu_size_to_slot(int size)
 {
-	int highbit = fls(size);
+	int highbit = fls(size);	/* size is in bytes */
 	return max(highbit - PCPU_SLOT_BASE_SHIFT + 2, 1);
 }
 
@@ -158,8 +158,8 @@ static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
 /**
  * pcpu_realloc - versatile realloc
  * @p: the current pointer (can be NULL for new allocations)
- * @size: the current size (can be 0 for new allocations)
- * @new_size: the wanted new size (can be 0 for free)
+ * @size: the current size in bytes (can be 0 for new allocations)
+ * @new_size: the wanted new size in bytes (can be 0 for free)
  *
  * More robust realloc which can be used to allocate, resize or free a
  * memory area of arbitrary size.  If the needed size goes over
@@ -290,8 +290,8 @@ static void pcpu_chunk_addr_insert(struct pcpu_chunk *new)
  * pcpu_split_block - split a map block
  * @chunk: chunk of interest
  * @i: index of map block to split
- * @head: head size (can be 0)
- * @tail: tail size (can be 0)
+ * @head: head size in bytes (can be 0)
+ * @tail: tail size in bytes (can be 0)
  *
  * Split the @i'th map block into two or three blocks.  If @head is
  * non-zero, @head bytes block is inserted before block @i moving it
@@ -346,7 +346,7 @@ static int pcpu_split_block(struct pcpu_chunk *chunk, int i, int head, int tail)
 /**
  * pcpu_alloc_area - allocate area from a pcpu_chunk
  * @chunk: chunk of interest
- * @size: wanted size
+ * @size: wanted size in bytes
  * @align: wanted align
  *
  * Try to allocate @size bytes area aligned at @align from @chunk.
@@ -540,15 +540,15 @@ static void pcpu_unmap(struct pcpu_chunk *chunk, int page_start, int page_end,
  * pcpu_depopulate_chunk - depopulate and unmap an area of a pcpu_chunk
  * @chunk: chunk to depopulate
  * @off: offset to the area to depopulate
- * @size: size of the area to depopulate
+ * @size: size of the area to depopulate in bytes
  * @flush: whether to flush cache and tlb or not
  *
  * For each cpu, depopulate and unmap pages [@page_start,@page_end)
  * from @chunk.  If @flush is true, vcache is flushed before unmapping
  * and tlb after.
  */
-static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, size_t off,
-				  size_t size, bool flush)
+static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk, intt off, int size,
+				  bool flush)
 {
 	int page_start = PFN_DOWN(off);
 	int page_end = PFN_UP(off + size);
@@ -617,7 +617,7 @@ static int pcpu_map(struct pcpu_chunk *chunk, int page_start, int page_end)
  * pcpu_populate_chunk - populate and map an area of a pcpu_chunk
  * @chunk: chunk of interest
  * @off: offset to the area to populate
- * @size: size of the area to populate
+ * @size: size of the area to populate in bytes
  *
  * For each cpu, populate and map pages [@page_start,@page_end) into
  * @chunk.  The area is cleared on return.
@@ -707,7 +707,7 @@ static struct pcpu_chunk *alloc_pcpu_chunk(void)
 
 /**
  * __alloc_percpu - allocate percpu area
- * @size: size of area to allocate
+ * @size: size of area to allocate in bytes
  * @align: alignment of area (max PAGE_SIZE)
  *
  * Allocate percpu area of @size bytes aligned at @align.  Might
@@ -819,6 +819,7 @@ EXPORT_SYMBOL_GPL(free_percpu);
  * pcpu_setup_static - initialize kernel static percpu area
  * @populate_pte_fn: callback to allocate pagetable
  * @pages: num_possible_cpus() * PFN_UP(cpu_size) pages
+ * @cpu_size: the size of static percpu area in bytes
  *
  * Initialize kernel static percpu area.  The caller should allocate
  * all the necessary pages and pass them in @pages.
