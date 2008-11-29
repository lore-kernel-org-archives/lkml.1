Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYK2KqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYK2KqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYK2KoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:44:04 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41393 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756229AbYK2KoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:44:02 -0500
Subject: [PATCH 08/15] kmemleak: Add modules support
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Date: Sat, 29 Nov 2008 10:43:51 +0000
Message-ID: <20081129104351.16726.69169.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.288.gdd3f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Nov 2008 10:43:51.0532 (UTC) FILETIME=[5E357AC0:01C9520F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch handles the kmemleak operations needed for modules loading so
that memory allocations from inside a module are properly tracked.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/module.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1f4cc00..84a21a8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -51,6 +51,7 @@
 #include <asm/sections.h>
 #include <linux/tracepoint.h>
 #include <linux/ftrace.h>
+#include <linux/memleak.h>
 
 #if 0
 #define DEBUGP printk
@@ -409,6 +410,7 @@ static void *percpu_modalloc(unsigned long size, unsigned long align,
 	unsigned long extra;
 	unsigned int i;
 	void *ptr;
+	int cpu;
 
 	if (align > PAGE_SIZE) {
 		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
@@ -438,6 +440,10 @@ static void *percpu_modalloc(unsigned long size, unsigned long align,
 			if (!split_block(i, size))
 				return NULL;
 
+		/* add the per-cpu scanning areas */
+		for_each_possible_cpu(cpu)
+			memleak_alloc(ptr + per_cpu_offset(cpu), size, 0);
+
 		/* Mark allocated */
 		pcpu_size[i] = -pcpu_size[i];
 		return ptr;
@@ -452,6 +458,7 @@ static void percpu_modfree(void *freeme)
 {
 	unsigned int i;
 	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
+	int cpu;
 
 	/* First entry is core kernel percpu data. */
 	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
@@ -463,6 +470,10 @@ static void percpu_modfree(void *freeme)
 	BUG();
 
  free:
+	/* remove the per-cpu scanning areas */
+	for_each_possible_cpu(cpu)
+		memleak_free(freeme + per_cpu_offset(cpu));
+
 	/* Merge with previous? */
 	if (pcpu_size[i-1] >= 0) {
 		pcpu_size[i-1] += pcpu_size[i];
@@ -1833,6 +1844,36 @@ static void *module_alloc_update_bounds(unsigned long size)
 	return ret;
 }
 
+#ifdef CONFIG_DEBUG_MEMLEAK
+static void memleak_load_module(struct module *mod, Elf_Ehdr *hdr,
+				Elf_Shdr *sechdrs, char *secstrings)
+{
+	unsigned int i;
+
+	/* only scan the sections containing data */
+	memleak_scan_area(mod->module_core,
+			  (unsigned long)mod - (unsigned long)mod->module_core,
+			  sizeof(struct module));
+
+	for (i = 1; i < hdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+		if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
+		    && strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
+			continue;
+
+		memleak_scan_area(mod->module_core,
+				  sechdrs[i].sh_addr - (unsigned long)mod->module_core,
+				  sechdrs[i].sh_size);
+	}
+}
+#else
+static inline void memleak_load_module(struct module *mod, Elf_Ehdr *hdr,
+				       Elf_Shdr *sechdrs, char *secstrings)
+{
+}
+#endif
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
@@ -2011,6 +2052,12 @@ static noinline struct module *load_module(void __user *umod,
 
 	/* Do the allocs. */
 	ptr = module_alloc_update_bounds(mod->core_size);
+	/*
+	 * The pointer to this block is stored in the module structure
+	 * which is inside the block. Just mark it as not being a
+	 * leak.
+	 */
+	memleak_not_leak(ptr);
 	if (!ptr) {
 		err = -ENOMEM;
 		goto free_percpu;
@@ -2019,6 +2066,13 @@ static noinline struct module *load_module(void __user *umod,
 	mod->module_core = ptr;
 
 	ptr = module_alloc_update_bounds(mod->init_size);
+	/*
+	 * The pointer to this block is stored in the module structure
+	 * which is inside the block. This block doesn't need to be
+	 * scanned as it contains data and code that will be freed
+	 * after the module is initialized.
+	 */
+	memleak_ignore(ptr);
 	if (!ptr && mod->init_size) {
 		err = -ENOMEM;
 		goto free_core;
@@ -2049,6 +2103,7 @@ static noinline struct module *load_module(void __user *umod,
 	}
 	/* Module has been moved. */
 	mod = (void *)sechdrs[modindex].sh_addr;
+	memleak_load_module(mod, hdr, sechdrs, secstrings);
 
 	/* Now we've moved module, initialize linked lists, etc. */
 	module_unload_init(mod);

