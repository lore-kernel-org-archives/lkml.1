Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbZJAKzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbZJAKzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 06:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbZJAKzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 06:55:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34500 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbZJAKzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 06:55:53 -0400
Date: Thu, 1 Oct 2009 11:55:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jan Beulich <JBeulich@novell.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Fix 4a49622: module: reduce symbol table for loaded modules (v2)
Message-ID: <20091001105531.GA25122@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, the above referenced change results in the following
for the !KALLSYMS case:

kernel/module.c:1995: warning: type defaults to 'int' in declaration of 'Elf_Hdr'
kernel/module.c:1995: error: expected ';', ',' or ')' before '*' token
kernel/module.c: In function 'load_module':
kernel/module.c:2203: error: 'strmap' undeclared (first use in this function)
kernel/module.c:2203: error: (Each undeclared identifier is reported only once
kernel/module.c:2203: error: for each function it appears in.)
kernel/module.c:2239: error: 'symoffs' undeclared (first use in this function)
kernel/module.c:2239: error: implicit declaration of function 'layout_symtab'
kernel/module.c:2240: error: 'stroffs' undeclared (first use in this function)

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
--
 kernel/module.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index fe748a8..e30df34 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1987,28 +1987,6 @@ static void add_kallsyms(struct module *mod,
 		if (test_bit(i, strmap))
 			*++s = mod->strtab[i];
 }
-#else
-static inline unsigned long layout_symtab(struct module *mod,
-					  Elf_Shdr *sechdrs,
-					  unsigned int symindex,
-					  unsigned int strindex,
-					  const Elf_Hdr *hdr,
-					  const char *secstrings,
-					  unsigned long *pstroffs,
-					  unsigned long *strmap)
-{
-}
-static inline void add_kallsyms(struct module *mod,
-				Elf_Shdr *sechdrs,
-				unsigned int shnum,
-				unsigned int symindex,
-				unsigned int strindex,
-				unsigned long symoffs,
-				unsigned long stroffs,
-				const char *secstrings,
-				const unsigned long *strmap)
-{
-}
 #endif /* CONFIG_KALLSYMS */
 
 static void dynamic_debug_setup(struct _ddebug *debug, unsigned int num)
@@ -2200,12 +2178,14 @@ static noinline struct module *load_module(void __user *umod,
 		goto free_hdr;
 	}
 
+#ifdef CONFIG_KALLSYMS
 	strmap = kzalloc(BITS_TO_LONGS(sechdrs[strindex].sh_size)
 			 * sizeof(long), GFP_KERNEL);
 	if (!strmap) {
 		err = -ENOMEM;
 		goto free_mod;
 	}
+#endif
 
 	if (find_module(mod->name)) {
 		err = -EEXIST;
@@ -2236,8 +2216,10 @@ static noinline struct module *load_module(void __user *umod,
 	   this is done generically; there doesn't appear to be any
 	   special cases for the architectures. */
 	layout_sections(mod, hdr, sechdrs, secstrings);
+#ifdef CONFIG_KALLSYMS
 	symoffs = layout_symtab(mod, sechdrs, symindex, strindex, hdr,
 				secstrings, &stroffs, strmap);
+#endif
 
 	/* Do the allocs. */
 	ptr = module_alloc_update_bounds(mod->core_size);
@@ -2442,10 +2424,12 @@ static noinline struct module *load_module(void __user *umod,
 	percpu_modcopy(mod->percpu, (void *)sechdrs[pcpuindex].sh_addr,
 		       sechdrs[pcpuindex].sh_size);
 
+#ifdef CONFIG_KALLSYMS
 	add_kallsyms(mod, sechdrs, hdr->e_shnum, symindex, strindex,
 		     symoffs, stroffs, secstrings, strmap);
 	kfree(strmap);
 	strmap = NULL;
+#endif
 
 	if (!mod->taints) {
 		struct _ddebug *debug;
@@ -2535,7 +2519,9 @@ static noinline struct module *load_module(void __user *umod,
 		percpu_modfree(percpu);
  free_mod:
 	kfree(args);
+#ifdef CONFIG_KALLSYMS
 	kfree(strmap);
+#endif
  free_hdr:
 	vfree(hdr);
 	return ERR_PTR(err);
