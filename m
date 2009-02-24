Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbZBXDOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbZBXDOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbZBXDNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:13:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:58439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757436AbZBXDNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:13:01 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] percpu: remove unit_size power-of-2 restriction
Date: Tue, 24 Feb 2009 12:11:37 +0900
Message-Id: <1235445101-7882-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1235445101-7882-1-git-send-email-tj@kernel.org>
References: <1235445101-7882-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 03:11:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: allow unit_size to be arbitrary multiple of PAGE_SIZE

In dynamic percpu allocator, there is no reason the unit size should
be power of two.  Remove the restriction.

As non-power-of-two unit size means that empty chunks fall into the
same slot index as lightly occupied chunks which is bad for reclaming.
Reserve an extra slot for empty chunks.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/percpu.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 41e7a5f..d9e6e5d 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -67,7 +67,7 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-#define PCPU_MIN_UNIT_PAGES_SHIFT	4	/* also max alloc size */
+#define PCPU_MIN_UNIT_PAGES		16	/* max alloc size in pages */
 #define PCPU_SLOT_BASE_SHIFT		5	/* 1-31 shares the same slot */
 #define PCPU_DFL_MAP_ALLOC		16	/* start a map with 16 ents */
 
@@ -83,9 +83,7 @@ struct pcpu_chunk {
 	struct page		*page[];	/* #cpus * UNIT_PAGES */
 };
 
-static int pcpu_unit_pages_shift;
 static int pcpu_unit_pages;
-static int pcpu_unit_shift;
 static int pcpu_unit_size;
 static int pcpu_chunk_size;
 static int pcpu_nr_slots;
@@ -117,12 +115,19 @@ static DEFINE_MUTEX(pcpu_mutex);
 static struct list_head *pcpu_slot;		/* chunk list slots */
 static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */
 
-static int pcpu_size_to_slot(int size)
+static int __pcpu_size_to_slot(int size)
 {
 	int highbit = fls(size);	/* size is in bytes */
 	return max(highbit - PCPU_SLOT_BASE_SHIFT + 2, 1);
 }
 
+static int pcpu_size_to_slot(int size)
+{
+	if (size == pcpu_unit_size)
+		return pcpu_nr_slots - 1;
+	return __pcpu_size_to_slot(size);
+}
+
 static int pcpu_chunk_slot(const struct pcpu_chunk *chunk)
 {
 	if (chunk->free_size < sizeof(int) || chunk->contig_hint < sizeof(int))
@@ -133,7 +138,7 @@ static int pcpu_chunk_slot(const struct pcpu_chunk *chunk)
 
 static int pcpu_page_idx(unsigned int cpu, int page_idx)
 {
-	return (cpu << pcpu_unit_pages_shift) + page_idx;
+	return cpu * pcpu_unit_pages + page_idx;
 }
 
 static struct page **pcpu_chunk_pagep(struct pcpu_chunk *chunk,
@@ -659,7 +664,7 @@ static int pcpu_populate_chunk(struct pcpu_chunk *chunk, int off, int size)
 		goto err;
 
 	for_each_possible_cpu(cpu)
-		memset(chunk->vm->addr + (cpu << pcpu_unit_shift) + off, 0,
+		memset(chunk->vm->addr + cpu * pcpu_unit_size + off, 0,
 		       size);
 
 	return 0;
@@ -722,7 +727,7 @@ void *__alloc_percpu(size_t size, size_t align)
 	struct pcpu_chunk *chunk;
 	int slot, off;
 
-	if (unlikely(!size || size > PAGE_SIZE << PCPU_MIN_UNIT_PAGES_SHIFT ||
+	if (unlikely(!size || size > PCPU_MIN_UNIT_PAGES * PAGE_SIZE ||
 		     align > PAGE_SIZE)) {
 		WARN(true, "illegal size (%zu) or align (%zu) for "
 		     "percpu allocation\n", size, align);
@@ -840,19 +845,19 @@ size_t __init pcpu_setup_static(pcpu_populate_pte_fn_t populate_pte_fn,
 	unsigned int cpu;
 	int err, i;
 
-	pcpu_unit_pages_shift = max_t(int, PCPU_MIN_UNIT_PAGES_SHIFT,
-				      order_base_2(cpu_size) - PAGE_SHIFT);
+	pcpu_unit_pages = max_t(int, PCPU_MIN_UNIT_PAGES, PFN_UP(cpu_size));
 
 	pcpu_static_size = cpu_size;
-	pcpu_unit_pages = 1 << pcpu_unit_pages_shift;
-	pcpu_unit_shift = PAGE_SHIFT + pcpu_unit_pages_shift;
-	pcpu_unit_size = 1 << pcpu_unit_shift;
+	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
 	pcpu_chunk_size = num_possible_cpus() * pcpu_unit_size;
-	pcpu_nr_slots = pcpu_size_to_slot(pcpu_unit_size) + 1;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk)
 		+ num_possible_cpus() * pcpu_unit_pages * sizeof(struct page *);
 
-	/* allocate chunk slots */
+	/*
+	 * Allocate chunk slots.  The additional last slot is for
+	 * empty chunks.
+	 */
+	pcpu_nr_slots = __pcpu_size_to_slot(pcpu_unit_size) + 2;
 	pcpu_slot = alloc_bootmem(pcpu_nr_slots * sizeof(pcpu_slot[0]));
 	for (i = 0; i < pcpu_nr_slots; i++)
 		INIT_LIST_HEAD(&pcpu_slot[i]);
-- 
1.6.0.2

