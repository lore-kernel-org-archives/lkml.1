Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbYE3EDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbYE3EDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYE3EA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40484 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbYE3EAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:14 -0400
Message-Id: <20080530040011.451400376@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:23 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 03/41] cpu alloc: Use cpu allocator instead of the builtin modules per cpu allocator
Content-Disposition: inline; filename=cpu_alloc_replace_modules_per_cpu_allocator
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the builtin per cpu allocator from modules.c and use cpu_alloc instead.

The patch also removes PERCPU_ENOUGH_ROOM. The size of the cpu_alloc area is
determined by CONFIG_CPU_AREA_SIZE. PERCPU_ENOUGH_ROOMs default was 8k.
CONFIG_CPU_AREA_SIZE defaults to 30k. Thus we have more space to load modules.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/powerpc/kernel/setup_64.c |    5 -
 arch/sparc64/kernel/smp.c      |    2 
 arch/x86/kernel/setup.c        |   11 +-
 include/asm-ia64/percpu.h      |    2 
 include/linux/module.h         |    1 
 include/linux/percpu.h         |   11 --
 init/main.c                    |    9 --
 kernel/lockdep.c               |    2 
 kernel/module.c                |  178 +++--------------------------------------
 9 files changed, 28 insertions(+), 193 deletions(-)

Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2008-05-29 17:57:39.825214766 -0700
+++ linux-2.6/kernel/module.c	2008-05-29 18:00:50.496815514 -0700
@@ -314,121 +314,6 @@ static struct module *find_module(const 
 	return NULL;
 }
 
-#ifdef CONFIG_SMP
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
-static void *percpu_modalloc(unsigned long size, unsigned long align,
-			     const char *name)
-{
-	unsigned long extra;
-	unsigned int i;
-	void *ptr;
-
-	if (align > PAGE_SIZE) {
-		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
-		       name, align, PAGE_SIZE);
-		align = PAGE_SIZE;
-	}
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
@@ -444,48 +329,6 @@ static void percpu_modcopy(void *pcpudes
 		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
 }
 
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
-#else /* ... !CONFIG_SMP */
-static inline void *percpu_modalloc(unsigned long size, unsigned long align,
-				    const char *name)
-{
-	return NULL;
-}
-static inline void percpu_modfree(void *pcpuptr)
-{
-	BUG();
-}
-static inline unsigned int find_pcpusec(Elf_Ehdr *hdr,
-					Elf_Shdr *sechdrs,
-					const char *secstrings)
-{
-	return 0;
-}
-static inline void percpu_modcopy(void *pcpudst, const void *src,
-				  unsigned long size)
-{
-	/* pcpusec should be 0, and size of that section should be 0. */
-	BUG_ON(size != 0);
-}
-#endif /* CONFIG_SMP */
-
 #define MODINFO_ATTR(field)	\
 static void setup_modinfo_##field(struct module *mod, const char *s)  \
 {                                                                     \
@@ -1403,7 +1246,7 @@ static void free_module(struct module *m
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
 	if (mod->percpu)
-		percpu_modfree(mod->percpu);
+		cpu_free(mod->percpu, mod->percpu_size);
 
 	/* Free lock-classes: */
 	lockdep_free_key_range(mod->module_core, mod->core_size);
@@ -1772,6 +1615,7 @@ static struct module *load_module(void _
 	unsigned int markersstringsindex;
 	struct module *mod;
 	long err = 0;
+	unsigned long percpu_size = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
 	struct exception_table_entry *extable;
 	mm_segment_t old_fs;
@@ -1918,15 +1762,25 @@ static struct module *load_module(void _
 
 	if (pcpuindex) {
 		/* We have a special allocation for this section. */
-		percpu = percpu_modalloc(sechdrs[pcpuindex].sh_size,
-					 sechdrs[pcpuindex].sh_addralign,
-					 mod->name);
+		unsigned long align = sechdrs[pcpuindex].sh_addralign;
+		unsigned long size = sechdrs[pcpuindex].sh_size;
+
+		if (align > PAGE_SIZE) {
+			printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
+			mod->name, align, PAGE_SIZE);
+			align = PAGE_SIZE;
+		}
+		percpu = cpu_alloc(size, GFP_KERNEL|__GFP_ZERO, align);
+		if (!percpu)
+			printk(KERN_WARNING "Could not allocate %lu bytes percpu data\n",
+										size);
 		if (!percpu) {
 			err = -ENOMEM;
 			goto free_mod;
 		}
 		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 		mod->percpu = percpu;
+		mod->percpu_size = percpu_size;
 	}
 
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
@@ -2175,7 +2029,7 @@ static struct module *load_module(void _
 	module_free(mod, mod->module_core);
  free_percpu:
 	if (percpu)
-		percpu_modfree(percpu);
+		cpu_free(percpu, percpu_size);
  free_mod:
 	kfree(args);
  free_hdr:
Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2008-05-29 17:58:32.328714051 -0700
+++ linux-2.6/include/linux/percpu.h	2008-05-29 17:58:53.652714198 -0700
@@ -34,17 +34,6 @@
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 
-/* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
-#ifndef PERCPU_ENOUGH_ROOM
-#ifdef CONFIG_MODULES
-#define PERCPU_MODULE_RESERVE	8192
-#else
-#define PERCPU_MODULE_RESERVE	0
-#endif
-
-#define PERCPU_ENOUGH_ROOM						\
-	(__per_cpu_end - __per_cpu_start + PERCPU_MODULE_RESERVE)
-#endif	/* PERCPU_ENOUGH_ROOM */
 
 /*
  * Must be an lvalue. Since @var must be a simple identifier,
Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h	2008-05-29 17:57:38.341214464 -0700
+++ linux-2.6/include/linux/module.h	2008-05-29 17:58:53.652714198 -0700
@@ -334,6 +334,7 @@ struct module
 
 	/* Per-cpu data. */
 	void *percpu;
+	int percpu_size;
 
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
Index: linux-2.6/arch/powerpc/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/setup_64.c	2008-05-29 17:57:38.357214432 -0700
+++ linux-2.6/arch/powerpc/kernel/setup_64.c	2008-05-29 17:58:53.652714198 -0700
@@ -596,11 +596,6 @@ void __init setup_per_cpu_areas(void)
 
 	/* Copy section for each CPU (we discard the original) */
 	size = ALIGN(__per_cpu_end - __per_cpu_start, PAGE_SIZE);
-#ifdef CONFIG_MODULES
-	if (size < PERCPU_ENOUGH_ROOM)
-		size = PERCPU_ENOUGH_ROOM;
-#endif
-
 	for_each_possible_cpu(i) {
 		ptr = alloc_bootmem_pages_node(NODE_DATA(cpu_to_node(i)), size);
 		if (!ptr)
Index: linux-2.6/arch/sparc64/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/sparc64/kernel/smp.c	2008-05-29 17:57:38.364714166 -0700
+++ linux-2.6/arch/sparc64/kernel/smp.c	2008-05-29 17:58:53.652714198 -0700
@@ -1454,7 +1454,7 @@ void __init real_setup_per_cpu_areas(voi
 	char *ptr;
 
 	/* Copy section for each CPU (we discard the original) */
-	goal = PERCPU_ENOUGH_ROOM;
+	goal = __per_cpu_size;
 
 	__per_cpu_shift = PAGE_SHIFT;
 	for (size = PAGE_SIZE; size < goal; size <<= 1UL)
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c	2008-05-29 17:57:39.592714425 -0700
+++ linux-2.6/arch/x86/kernel/setup.c	2008-05-29 17:58:53.652714198 -0700
@@ -89,30 +89,29 @@ EXPORT_SYMBOL(__per_cpu_offset);
 void __init setup_per_cpu_areas(void)
 {
 	int i, highest_cpu = 0;
-	unsigned long size;
 
 #ifdef CONFIG_HOTPLUG_CPU
 	prefill_possible_map();
 #endif
 
 	/* Copy section for each CPU (we discard the original) */
-	size = PERCPU_ENOUGH_ROOM;
 	printk(KERN_INFO "PERCPU: Allocating %lu bytes of per cpu data\n",
-			  size);
+			  __per_cpu_size);
 
 	for_each_possible_cpu(i) {
 		char *ptr;
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-		ptr = alloc_bootmem_pages(size);
+		ptr = alloc_bootmem_pages(__per_cpu_size);
 #else
 		int node = early_cpu_to_node(i);
 		if (!node_online(node) || !NODE_DATA(node)) {
-			ptr = alloc_bootmem_pages(size);
+			ptr = alloc_bootmem_pages(__per_cpu_size);
 			printk(KERN_INFO
 			       "cpu %d has no node or node-local memory\n", i);
 		}
 		else
-			ptr = alloc_bootmem_pages_node(NODE_DATA(node), size);
+			ptr = alloc_bootmem_pages_node(NODE_DATA(node),
+								__per_cpu_size);
 #endif
 		if (!ptr)
 			panic("Cannot allocate cpu data for CPU %d\n", i);
Index: linux-2.6/include/asm-ia64/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/percpu.h	2008-05-29 17:57:38.349214528 -0700
+++ linux-2.6/include/asm-ia64/percpu.h	2008-05-29 17:58:53.652714198 -0700
@@ -6,8 +6,6 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
 
-#define PERCPU_ENOUGH_ROOM PERCPU_PAGE_SIZE
-
 #ifdef __ASSEMBLY__
 # define THIS_CPU(var)	(per_cpu__##var)  /* use this to mark accesses to per-CPU variables... */
 #else /* !__ASSEMBLY__ */
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c	2008-05-29 17:57:38.380714353 -0700
+++ linux-2.6/init/main.c	2008-05-29 17:58:53.652714198 -0700
@@ -393,18 +393,17 @@ EXPORT_SYMBOL(__per_cpu_offset);
 
 static void __init setup_per_cpu_areas(void)
 {
-	unsigned long size, i;
+	unsigned long i;
 	char *ptr;
 	unsigned long nr_possible_cpus = num_possible_cpus();
 
 	/* Copy section for each CPU (we discard the original) */
-	size = ALIGN(PERCPU_ENOUGH_ROOM, PAGE_SIZE);
-	ptr = alloc_bootmem_pages(size * nr_possible_cpus);
+	ptr = alloc_bootmem_pages(__per_cpu_size * nr_possible_cpus);
 
 	for_each_possible_cpu(i) {
 		__per_cpu_offset[i] = ptr - __per_cpu_start;
-		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
-		ptr += size;
+		memcpy(ptr, __per_cpu_start, __per_cpu_size);
+		ptr += __per_cpu_size;
 	}
 }
 #endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c	2008-05-29 17:57:39.816713970 -0700
+++ linux-2.6/kernel/lockdep.c	2008-05-29 17:59:22.697422432 -0700
@@ -610,7 +610,7 @@ static int static_obj(void *obj)
 	 */
 	for_each_possible_cpu(i) {
 		start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
-		end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
+		end   = (unsigned long) &__per_cpu_start + __per_cpu_size
 					+ per_cpu_offset(i);
 
 		if ((addr >= start) && (addr < end))

-- 
