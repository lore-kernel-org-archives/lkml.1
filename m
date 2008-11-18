Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbYKQN2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbYKQN2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:28:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYKQN0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:26:35 -0500
Received: from ozlabs.org ([203.10.76.45]:39442 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYKQN0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:26:32 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon Nov 17 23:48:26 CST 2008
CC: akpm@linux-foundation.org
Subject: [PATCH 3/7] Improve alloc_percpu: expose percpu_modalloc and percpu_modfree
Cc: Christoph Lameter <cl@linux-foundation.org>
Message-Id: <20081117132630.AC29EDDDFF@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This simply moves the percpu allocator functions from the module code
to mm/allocpercpu.c.  percpu_modinit is renamed percpu_alloc_init and
called from init/main.c.

(Note: this allocator will need to be weaned off krealloc for use in
the slab allocator itself as Christoph does in one of his patches).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/percpu.h |   11 +++
 kernel/module.c        |  145 -------------------------------------------------
 mm/allocpercpu.c       |  134 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+), 144 deletions(-)

diff -r 81ce6015186e include/linux/percpu.h
--- a/include/linux/percpu.h	Mon Nov 17 23:19:14 2008 +1030
+++ b/include/linux/percpu.h	Mon Nov 17 23:40:12 2008 +1030
@@ -78,6 +78,8 @@
 extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask);
 extern void percpu_free(void *__pdata);
 
+void *percpu_modalloc(unsigned long size, unsigned long align);
+void percpu_modfree(void *pcpuptr);
 #else /* CONFIG_SMP */
 
 #define percpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
@@ -92,6 +94,15 @@
 	kfree(__pdata);
 }
 
+static inline void *percpu_modalloc(unsigned long size, unsigned long align)
+{
+	return kzalloc(size);
+}
+
+static inline void percpu_modfree(void *pcpuptr)
+{
+	kfree(pcpuptr);
+}
 #endif /* CONFIG_SMP */
 
 #define percpu_alloc_mask(size, gfp, mask) \
@@ -108,4 +119,6 @@
 #define free_percpu(ptr)	percpu_free((ptr))
 #define per_cpu_ptr(ptr, cpu)	percpu_ptr((ptr), (cpu))
 
+void percpu_alloc_init(void);
+
 #endif /* __LINUX_PERCPU_H */
diff -r 81ce6015186e init/main.c
--- a/init/main.c	Mon Nov 17 23:19:14 2008 +1030
+++ b/init/main.c	Mon Nov 17 23:40:12 2008 +1030
@@ -655,6 +655,7 @@
 	enable_debug_pagealloc();
 	cpu_hotplug_init();
 	kmem_cache_init();
+	percpu_alloc_init();
 	debug_objects_mem_init();
 	idr_init_cache();
 	setup_per_cpu_pageset();
diff -r 81ce6015186e kernel/module.c
--- a/kernel/module.c	Mon Nov 17 23:19:14 2008 +1030
+++ b/kernel/module.c	Mon Nov 17 23:40:12 2008 +1030
@@ -51,6 +51,7 @@
 #include <asm/sections.h>
 #include <linux/tracepoint.h>
 #include <linux/ftrace.h>
+#include <linux/percpu.h>
 
 #if 0
 #define DEBUGP printk
@@ -366,123 +367,6 @@
 }
 
 #ifdef CONFIG_SMP
-/* Number of blocks used and allocated. */
-static unsigned int pcpu_num_used, pcpu_num_allocated;
-/* Size of each block.  -ve means used. */
-static int *pcpu_size;
-
-static int split_block(unsigned int i, unsigned short size)
-{
-	/* Reallocation required? */
-	if (pcpu_num_used + 1 > pcpu_num_allocated) {
-		int *new;
-
-		new = krealloc(pcpu_size, sizeof(new[0])*pcpu_num_allocated*2,
-			       GFP_KERNEL);
-		if (!new)
-			return 0;
-
-		pcpu_num_allocated *= 2;
-		pcpu_size = new;
-	}
-
-	/* Insert a new subblock */
-	memmove(&pcpu_size[i+1], &pcpu_size[i],
-		sizeof(pcpu_size[0]) * (pcpu_num_used - i));
-	pcpu_num_used++;
-
-	pcpu_size[i+1] -= size;
-	pcpu_size[i] = size;
-	return 1;
-}
-
-static inline unsigned int block_size(int val)
-{
-	if (val < 0)
-		return -val;
-	return val;
-}
-
-static void *percpu_modalloc(unsigned long size, unsigned long align)
-{
-	unsigned long extra;
-	unsigned int i;
-	void *ptr;
-
-	if (WARN_ON(align > PAGE_SIZE))
-		align = PAGE_SIZE;
-
-	ptr = __per_cpu_start;
-	for (i = 0; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
-		/* Extra for alignment requirement. */
-		extra = ALIGN((unsigned long)ptr, align) - (unsigned long)ptr;
-		BUG_ON(i == 0 && extra != 0);
-
-		if (pcpu_size[i] < 0 || pcpu_size[i] < extra + size)
-			continue;
-
-		/* Transfer extra to previous block. */
-		if (pcpu_size[i-1] < 0)
-			pcpu_size[i-1] -= extra;
-		else
-			pcpu_size[i-1] += extra;
-		pcpu_size[i] -= extra;
-		ptr += extra;
-
-		/* Split block if warranted */
-		if (pcpu_size[i] - size > sizeof(unsigned long))
-			if (!split_block(i, size))
-				return NULL;
-
-		/* Mark allocated */
-		pcpu_size[i] = -pcpu_size[i];
-
-		/* Zero since most callers want it and it's a PITA to do. */
-		for_each_possible_cpu(i)
-			memset(ptr + per_cpu_offset(i), 0, size);
-		return ptr;
-	}
-
-	printk(KERN_WARNING "Could not allocate %lu bytes percpu data\n",
-	       size);
-	return NULL;
-}
-
-static void percpu_modfree(void *freeme)
-{
-	unsigned int i;
-	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
-
-	if (!freeme)
-		return;
-
-	/* First entry is core kernel percpu data. */
-	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
-		if (ptr == freeme) {
-			pcpu_size[i] = -pcpu_size[i];
-			goto free;
-		}
-	}
-	BUG();
-
- free:
-	/* Merge with previous? */
-	if (pcpu_size[i-1] >= 0) {
-		pcpu_size[i-1] += pcpu_size[i];
-		pcpu_num_used--;
-		memmove(&pcpu_size[i], &pcpu_size[i+1],
-			(pcpu_num_used - i) * sizeof(pcpu_size[0]));
-		i--;
-	}
-	/* Merge with next? */
-	if (i+1 < pcpu_num_used && pcpu_size[i+1] >= 0) {
-		pcpu_size[i] += pcpu_size[i+1];
-		pcpu_num_used--;
-		memmove(&pcpu_size[i+1], &pcpu_size[i+2],
-			(pcpu_num_used - (i+1)) * sizeof(pcpu_size[0]));
-	}
-}
-
 static unsigned int find_pcpusec(Elf_Ehdr *hdr,
 				 Elf_Shdr *sechdrs,
 				 const char *secstrings)
@@ -497,34 +381,7 @@
 	for_each_possible_cpu(cpu)
 		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
 }
-
-static int percpu_modinit(void)
-{
-	pcpu_num_used = 2;
-	pcpu_num_allocated = 2;
-	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
-			    GFP_KERNEL);
-	/* Static in-kernel percpu data (used). */
-	pcpu_size[0] = -(__per_cpu_end-__per_cpu_start);
-	/* Free room. */
-	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
-	if (pcpu_size[1] < 0) {
-		printk(KERN_ERR "No per-cpu room for modules.\n");
-		pcpu_num_used = 1;
-	}
-
-	return 0;
-}
-__initcall(percpu_modinit);
 #else /* ... !CONFIG_SMP */
-static inline void *percpu_modalloc(unsigned long size, unsigned long align)
-{
-	return kzalloc(size);
-}
-static inline void percpu_modfree(void *pcpuptr)
-{
-	kfree(pcpuptr);
-}
 static inline unsigned int find_pcpusec(Elf_Ehdr *hdr,
 					Elf_Shdr *sechdrs,
 					const char *secstrings)
diff -r 81ce6015186e mm/allocpercpu.c
--- a/mm/allocpercpu.c	Mon Nov 17 23:19:14 2008 +1030
+++ b/mm/allocpercpu.c	Mon Nov 17 23:40:12 2008 +1030
@@ -5,6 +5,7 @@
  */
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <asm/sections.h>
 
 #ifndef cache_line_size
 #define cache_line_size()	L1_CACHE_BYTES
@@ -142,6 +143,136 @@
 }
 EXPORT_SYMBOL_GPL(percpu_free);
 
+/* Number of blocks used and allocated. */
+static unsigned int pcpu_num_used, pcpu_num_allocated;
+/* Size of each block.  -ve means used. */
+static int *pcpu_size;
+
+static int split_block(unsigned int i, unsigned short size)
+{
+	/* Reallocation required? */
+	if (pcpu_num_used + 1 > pcpu_num_allocated) {
+		int *new;
+
+		new = krealloc(pcpu_size, sizeof(new[0])*pcpu_num_allocated*2,
+			       GFP_KERNEL);
+		if (!new)
+			return 0;
+
+		pcpu_num_allocated *= 2;
+		pcpu_size = new;
+	}
+
+	/* Insert a new subblock */
+	memmove(&pcpu_size[i+1], &pcpu_size[i],
+		sizeof(pcpu_size[0]) * (pcpu_num_used - i));
+	pcpu_num_used++;
+
+	pcpu_size[i+1] -= size;
+	pcpu_size[i] = size;
+	return 1;
+}
+
+static inline unsigned int block_size(int val)
+{
+	if (val < 0)
+		return -val;
+	return val;
+}
+
+void *percpu_modalloc(unsigned long size, unsigned long align)
+{
+	unsigned long extra;
+	unsigned int i;
+	void *ptr;
+
+	if (WARN_ON(align > PAGE_SIZE))
+		align = PAGE_SIZE;
+
+	ptr = __per_cpu_start;
+	for (i = 0; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
+		/* Extra for alignment requirement. */
+		extra = ALIGN((unsigned long)ptr, align) - (unsigned long)ptr;
+		BUG_ON(i == 0 && extra != 0);
+
+		if (pcpu_size[i] < 0 || pcpu_size[i] < extra + size)
+			continue;
+
+		/* Transfer extra to previous block. */
+		if (pcpu_size[i-1] < 0)
+			pcpu_size[i-1] -= extra;
+		else
+			pcpu_size[i-1] += extra;
+		pcpu_size[i] -= extra;
+		ptr += extra;
+
+		/* Split block if warranted */
+		if (pcpu_size[i] - size > sizeof(unsigned long))
+			if (!split_block(i, size))
+				return NULL;
+
+		/* Mark allocated */
+		pcpu_size[i] = -pcpu_size[i];
+
+		/* Zero since most callers want it and it's a PITA to do. */
+		for_each_possible_cpu(i)
+			memset(ptr + per_cpu_offset(i), 0, size);
+		return ptr;
+	}
+
+	printk(KERN_WARNING "Could not allocate %lu bytes percpu data\n",
+	       size);
+	return NULL;
+}
+
+void percpu_modfree(void *freeme)
+{
+	unsigned int i;
+	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
+
+	if (!freeme)
+		return;
+
+	/* First entry is core kernel percpu data. */
+	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
+		if (ptr == freeme) {
+			pcpu_size[i] = -pcpu_size[i];
+			goto free;
+		}
+	}
+	BUG();
+
+ free:
+	/* Merge with previous? */
+	if (pcpu_size[i-1] >= 0) {
+		pcpu_size[i-1] += pcpu_size[i];
+		pcpu_num_used--;
+		memmove(&pcpu_size[i], &pcpu_size[i+1],
+			(pcpu_num_used - i) * sizeof(pcpu_size[0]));
+		i--;
+	}
+	/* Merge with next? */
+	if (i+1 < pcpu_num_used && pcpu_size[i+1] >= 0) {
+		pcpu_size[i] += pcpu_size[i+1];
+		pcpu_num_used--;
+		memmove(&pcpu_size[i+1], &pcpu_size[i+2],
+			(pcpu_num_used - (i+1)) * sizeof(pcpu_size[0]));
+	}
+}
+
+void __init percpu_alloc_init(void)
+{
+	pcpu_num_used = 2;
+	pcpu_num_allocated = 2;
+	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
+			    GFP_KERNEL);
+	/* Static in-kernel percpu data (used). */
+	pcpu_size[0] = -(__per_cpu_end-__per_cpu_start);
+	/* Free room. */
+	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
+	BUG_ON(pcpu_size[1] < 0);
+}
+
 /* A heuristic based on observation.  May need to increase. */
 unsigned int percpu_reserve = (sizeof(unsigned long) * 2500);
 

