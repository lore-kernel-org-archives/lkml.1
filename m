Return-Path: <linux-kernel-owner+w=401wt.eu-S1760518AbZDXQoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbZDXQoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760065AbZDXQma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:42:30 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41597 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759243AbZDXQm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:42:28 -0400
Subject: [PATCH 08/14] kmemleak: Add modules support
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Apr 2009 17:41:43 +0100
Message-ID: <20090424164143.4476.89090.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:42:27.0611 (UTC) FILETIME=[A71A16B0:01C9C4FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch handles the kmemleak operations needed for modules loading so
that memory allocations from inside a module are properly tracked.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 kernel/module.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index e797812..81b32f9 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -52,6 +52,7 @@
 #include <linux/ftrace.h>
 #include <linux/async.h>
 #include <linux/percpu.h>
+#include <linux/kmemleak.h>
 
 #if 0
 #define DEBUGP printk
@@ -429,6 +430,7 @@ static void *percpu_modalloc(unsigned long size, unsigned long align,
 	unsigned long extra;
 	unsigned int i;
 	void *ptr;
+	int cpu;
 
 	if (align > PAGE_SIZE) {
 		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
@@ -458,6 +460,11 @@ static void *percpu_modalloc(unsigned long size, unsigned long align,
 			if (!split_block(i, size))
 				return NULL;
 
+		/* add the per-cpu scanning areas */
+		for_each_possible_cpu(cpu)
+			kmemleak_alloc(ptr + per_cpu_offset(cpu), size, 0,
+				       GFP_KERNEL);
+
 		/* Mark allocated */
 		pcpu_size[i] = -pcpu_size[i];
 		return ptr;
@@ -472,6 +479,7 @@ static void percpu_modfree(void *freeme)
 {
 	unsigned int i;
 	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
+	int cpu;
 
 	/* First entry is core kernel percpu data. */
 	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
@@ -483,6 +491,10 @@ static void percpu_modfree(void *freeme)
 	BUG();
 
  free:
+	/* remove the per-cpu scanning areas */
+	for_each_possible_cpu(cpu)
+		kmemleak_free(freeme + per_cpu_offset(cpu));
+
 	/* Merge with previous? */
 	if (pcpu_size[i-1] >= 0) {
 		pcpu_size[i-1] += pcpu_size[i];
@@ -1878,6 +1890,36 @@ static void *module_alloc_update_bounds(unsigned long size)
 	return ret;
 }
 
+#ifdef CONFIG_DEBUG_KMEMLEAK
+static void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
+				 Elf_Shdr *sechdrs, char *secstrings)
+{
+	unsigned int i;
+
+	/* only scan the sections containing data */
+	kmemleak_scan_area(mod->module_core, (unsigned long)mod -
+			   (unsigned long)mod->module_core,
+			   sizeof(struct module), GFP_KERNEL);
+
+	for (i = 1; i < hdr->e_shnum; i++) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+		if (strncmp(secstrings + sechdrs[i].sh_name, ".data", 5) != 0
+		    && strncmp(secstrings + sechdrs[i].sh_name, ".bss", 4) != 0)
+			continue;
+
+		kmemleak_scan_area(mod->module_core, sechdrs[i].sh_addr -
+				   (unsigned long)mod->module_core,
+				   sechdrs[i].sh_size, GFP_KERNEL);
+	}
+}
+#else
+static inline void kmemleak_load_module(struct module *mod, Elf_Ehdr *hdr,
+					Elf_Shdr *sechdrs, char *secstrings)
+{
+}
+#endif
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static noinline struct module *load_module(void __user *umod,
@@ -2050,6 +2092,12 @@ static noinline struct module *load_module(void __user *umod,
 
 	/* Do the allocs. */
 	ptr = module_alloc_update_bounds(mod->core_size);
+	/*
+	 * The pointer to this block is stored in the module structure
+	 * which is inside the block. Just mark it as not being a
+	 * leak.
+	 */
+	kmemleak_not_leak(ptr);
 	if (!ptr) {
 		err = -ENOMEM;
 		goto free_percpu;
@@ -2058,6 +2106,13 @@ static noinline struct module *load_module(void __user *umod,
 	mod->module_core = ptr;
 
 	ptr = module_alloc_update_bounds(mod->init_size);
+	/*
+	 * The pointer to this block is stored in the module structure
+	 * which is inside the block. This block doesn't need to be
+	 * scanned as it contains data and code that will be freed
+	 * after the module is initialized.
+	 */
+	kmemleak_ignore(ptr);
 	if (!ptr && mod->init_size) {
 		err = -ENOMEM;
 		goto free_core;
@@ -2088,6 +2143,7 @@ static noinline struct module *load_module(void __user *umod,
 	}
 	/* Module has been moved. */
 	mod = (void *)sechdrs[modindex].sh_addr;
+	kmemleak_load_module(mod, hdr, sechdrs, secstrings);
 
 #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
 	mod->refptr = percpu_modalloc(sizeof(local_t), __alignof__(local_t),

