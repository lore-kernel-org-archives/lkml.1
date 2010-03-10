Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab0CJJ5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:57:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:40283 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317Ab0CJJ5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:57:07 -0500
Message-ID: <4B976CBA.3070305@kernel.org>
Date: Wed, 10 Mar 2010 18:56:10 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/2] module: encapsulate percpu handling better and record
 percpu_size
References: <24605.1268073053@localhost> <1268073831.4997.69.camel@laptop>	 <4B95AA4C.2030303@kernel.org> <4298.1268116039@localhost>	 <4B95EE4C.3020606@kernel.org>  <4B9610E5.4080805@kernel.org> <1268133942.4162.2.camel@twins> <4B963441.40000@kernel.org>
In-Reply-To: <4B963441.40000@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 09:56:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better encapsulate module static percpu area handling so that code
outsidef of CONFIG_SMP ifdef doesn't deal with mod->percpu directly
and add mod->percpu_size and record percpu_size in it.  Both percpu
fields are compiled out on UP.  While at it, mark mod->percpu w/
__percpu.

This is to prepare for is_module_percpu_address().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
Rusty, can you please ack this?  Tested on both SMP and UP.

Thanks.

 include/linux/module.h |    5 ++-
 kernel/module.c        |   66 +++++++++++++++++++++++++------------------------
 2 files changed, 39 insertions(+), 32 deletions(-)

Index: work/kernel/module.c
===================================================================
--- work.orig/kernel/module.c
+++ work/kernel/module.c
@@ -370,27 +370,33 @@ EXPORT_SYMBOL_GPL(find_module);
 
 #ifdef CONFIG_SMP
 
-static void *percpu_modalloc(unsigned long size, unsigned long align,
-			     const char *name)
+static inline void __percpu *mod_percpu(struct module *mod)
 {
-	void *ptr;
+	return mod->percpu;
+}
 
+static int percpu_modalloc(struct module *mod,
+			   unsigned long size, unsigned long align)
+{
 	if (align > PAGE_SIZE) {
 		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
-		       name, align, PAGE_SIZE);
+		       mod->name, align, PAGE_SIZE);
 		align = PAGE_SIZE;
 	}
 
-	ptr = __alloc_reserved_percpu(size, align);
-	if (!ptr)
+	mod->percpu = __alloc_reserved_percpu(size, align);
+	if (!mod->percpu) {
 		printk(KERN_WARNING
 		       "Could not allocate %lu bytes percpu data\n", size);
-	return ptr;
+		return -ENOMEM;
+	}
+	mod->percpu_size = size;
+	return 0;
 }
 
-static void percpu_modfree(void *freeme)
+static void percpu_modfree(struct module *mod)
 {
-	free_percpu(freeme);
+	free_percpu(mod->percpu);
 }
 
 static unsigned int find_pcpusec(Elf_Ehdr *hdr,
@@ -400,24 +406,28 @@ static unsigned int find_pcpusec(Elf_Ehd
 	return find_sec(hdr, sechdrs, secstrings, ".data.percpu");
 }
 
-static void percpu_modcopy(void *pcpudest, const void *from, unsigned long size)
+static void percpu_modcopy(struct module *mod,
+			   const void *from, unsigned long size)
 {
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		memcpy(pcpudest + per_cpu_offset(cpu), from, size);
+		memcpy(per_cpu_ptr(mod->percpu, cpu), from, size);
 }
 
 #else /* ... !CONFIG_SMP */
 
-static inline void *percpu_modalloc(unsigned long size, unsigned long align,
-				    const char *name)
+static inline void __percpu *mod_percpu(struct module *mod)
 {
 	return NULL;
 }
-static inline void percpu_modfree(void *pcpuptr)
+static inline int percpu_modalloc(struct module *mod,
+				  unsigned long size, unsigned long align)
+{
+	return -ENOMEM;
+}
+static inline void percpu_modfree(struct module *mod)
 {
-	BUG();
 }
 static inline unsigned int find_pcpusec(Elf_Ehdr *hdr,
 					Elf_Shdr *sechdrs,
@@ -425,8 +435,8 @@ static inline unsigned int find_pcpusec(
 {
 	return 0;
 }
-static inline void percpu_modcopy(void *pcpudst, const void *src,
-				  unsigned long size)
+static inline void percpu_modcopy(struct module *mod,
+				  const void *from, unsigned long size)
 {
 	/* pcpusec should be 0, and size of that section should be 0. */
 	BUG_ON(size != 0);
@@ -1400,8 +1410,7 @@ static void free_module(struct module *m
 	/* This may be NULL, but that's OK */
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
-	if (mod->percpu)
-		percpu_modfree(mod->percpu);
+	percpu_modfree(mod);
 #if defined(CONFIG_MODULE_UNLOAD)
 	if (mod->refptr)
 		free_percpu(mod->refptr);
@@ -1520,7 +1529,7 @@ static int simplify_symbols(Elf_Shdr *se
 		default:
 			/* Divert to percpu allocation if a percpu var. */
 			if (sym[i].st_shndx == pcpuindex)
-				secbase = (unsigned long)mod->percpu;
+				secbase = (unsigned long)mod_percpu(mod);
 			else
 				secbase = sechdrs[sym[i].st_shndx].sh_addr;
 			sym[i].st_value += secbase;
@@ -1954,7 +1963,7 @@ static noinline struct module *load_modu
 	unsigned int modindex, versindex, infoindex, pcpuindex;
 	struct module *mod;
 	long err = 0;
-	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
+	void *ptr = NULL; /* Stops spurious gcc warning */
 	unsigned long symoffs, stroffs, *strmap;
 
 	mm_segment_t old_fs;
@@ -2094,15 +2103,11 @@ static noinline struct module *load_modu
 
 	if (pcpuindex) {
 		/* We have a special allocation for this section. */
-		percpu = percpu_modalloc(sechdrs[pcpuindex].sh_size,
-					 sechdrs[pcpuindex].sh_addralign,
-					 mod->name);
-		if (!percpu) {
-			err = -ENOMEM;
+		err = percpu_modalloc(mod, sechdrs[pcpuindex].sh_size,
+				      sechdrs[pcpuindex].sh_addralign);
+		if (err)
 			goto free_mod;
-		}
 		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
-		mod->percpu = percpu;
 	}
 
 	/* Determine total sizes, and put offsets in sh_entsize.  For now
@@ -2317,7 +2322,7 @@ static noinline struct module *load_modu
 	sort_extable(mod->extable, mod->extable + mod->num_exentries);
 
 	/* Finally, copy percpu area over. */
-	percpu_modcopy(mod->percpu, (void *)sechdrs[pcpuindex].sh_addr,
+	percpu_modcopy(mod, (void *)sechdrs[pcpuindex].sh_addr,
 		       sechdrs[pcpuindex].sh_size);
 
 	add_kallsyms(mod, sechdrs, hdr->e_shnum, symindex, strindex,
@@ -2409,8 +2414,7 @@ static noinline struct module *load_modu
 	module_free(mod, mod->module_core);
 	/* mod will be freed with core. Don't access it beyond this line! */
  free_percpu:
-	if (percpu)
-		percpu_modfree(percpu);
+	percpu_modfree(mod);
  free_mod:
 	kfree(args);
 	kfree(strmap);
Index: work/include/linux/module.h
===================================================================
--- work.orig/include/linux/module.h
+++ work/include/linux/module.h
@@ -329,8 +329,11 @@ struct module
 	struct module_notes_attrs *notes_attrs;
 #endif
 
+#ifdef CONFIG_SMP
 	/* Per-cpu data. */
-	void *percpu;
+	void __percpu *percpu;
+	unsigned int percpu_size;
+#endif
 
 	/* The command line arguments (may be mangled).  People like
 	   keeping pointers to this stuff */
