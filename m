Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYKQN1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYKQN1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYKQN0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:26:32 -0500
Received: from ozlabs.org ([203.10.76.45]:39441 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYKQN0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:26:31 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon Nov 17 23:48:26 CST 2008
CC: akpm@linux-foundation.org
Subject: [PATCH 2/7] Cleanup dynamic per-cpu: make percpu_modalloc/modfree more generic
Cc: Christoph Lameter <cl@linux-foundation.org>
Message-Id: <20081117132630.6E302DDDFB@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the "name" arg to percpu_modalloc, and make it zero memory.
Make percpu_modfree take NULL without barfing.
Make non-SMP versions do kzalloc/kfree.

These trivial changes make it suitable for use as a general per-cpu
allocator.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 kernel/module.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -r ac34c790faf4 kernel/module.c
--- a/kernel/module.c	Mon Nov 17 21:33:07 2008 +1030
+++ b/kernel/module.c	Mon Nov 17 21:35:01 2008 +1030
@@ -403,18 +403,14 @@
 	return val;
 }
 
-static void *percpu_modalloc(unsigned long size, unsigned long align,
-			     const char *name)
+static void *percpu_modalloc(unsigned long size, unsigned long align)
 {
 	unsigned long extra;
 	unsigned int i;
 	void *ptr;
 
-	if (align > PAGE_SIZE) {
-		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
-		       name, align, PAGE_SIZE);
+	if (WARN_ON(align > PAGE_SIZE))
 		align = PAGE_SIZE;
-	}
 
 	ptr = __per_cpu_start;
 	for (i = 0; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
@@ -440,6 +436,10 @@
 
 		/* Mark allocated */
 		pcpu_size[i] = -pcpu_size[i];
+
+		/* Zero since most callers want it and it's a PITA to do. */
+		for_each_possible_cpu(i)
+			memset(ptr + per_cpu_offset(i), 0, size);
 		return ptr;
 	}
 
@@ -452,6 +452,9 @@
 {
 	unsigned int i;
 	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
+
+	if (!freeme)
+		return;
 
 	/* First entry is core kernel percpu data. */
 	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
@@ -514,14 +517,13 @@
 }
 __initcall(percpu_modinit);
 #else /* ... !CONFIG_SMP */
-static inline void *percpu_modalloc(unsigned long size, unsigned long align,
-				    const char *name)
+static inline void *percpu_modalloc(unsigned long size, unsigned long align)
 {
-	return NULL;
+	return kzalloc(size);
 }
 static inline void percpu_modfree(void *pcpuptr)
 {
-	BUG();
+	kfree(pcpuptr);
 }
 static inline unsigned int find_pcpusec(Elf_Ehdr *hdr,
 					Elf_Shdr *sechdrs,
@@ -1453,8 +1455,7 @@
 	/* This may be NULL, but that's OK */
 	module_free(mod, mod->module_init);
 	kfree(mod->args);
-	if (mod->percpu)
-		percpu_modfree(mod->percpu);
+	percpu_modfree(mod->percpu);
 
 	/* Free lock-classes: */
 	lockdep_free_key_range(mod->module_core, mod->core_size);
@@ -1994,8 +1995,7 @@
 	if (pcpuindex) {
 		/* We have a special allocation for this section. */
 		percpu = percpu_modalloc(sechdrs[pcpuindex].sh_size,
-					 sechdrs[pcpuindex].sh_addralign,
-					 mod->name);
+					 sechdrs[pcpuindex].sh_addralign);
 		if (!percpu) {
 			err = -ENOMEM;
 			goto free_mod;
@@ -2273,8 +2273,7 @@
  free_core:
 	module_free(mod, mod->module_core);
  free_percpu:
-	if (percpu)
-		percpu_modfree(percpu);
+	percpu_modfree(percpu);
  free_mod:
 	kfree(args);
  free_hdr:

