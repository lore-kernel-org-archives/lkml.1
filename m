Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbXKTB2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbXKTB2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbXKTBOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:25 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49891 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756344AbXKTBNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:42 -0500
Message-Id: <20071120011342.426906810@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:17 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 45/45] Modules: Hack to handle symbols that have a zero value
Content-Disposition: inline; filename=weaky
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The module subsystem cannot handle symbols that are zero. It prints out
a message that these symbols are unresolved. Define a constant

UNRESOLVED

that is used to hold the value used for unresolved symbols. Set it to 1
(its hopefully unlikely that a symbol will have the value 1). This is necessary
so that the pda variable which is placed at offset 0 of the per cpu
segment is handled correctly.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/module.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2007-11-19 17:08:40.563625526 -0800
+++ linux-2.6/kernel/module.c	2007-11-19 17:08:40.855625732 -0800
@@ -62,6 +62,7 @@ extern int module_sysfs_initialized;
 /* If this is set, the section belongs in the init part of the module */
 #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
 
+#define UNRESOLVED 1
 /* List of modules, protected by module_mutex or preempt_disable
  * (add/delete uses stop_machine). */
 static DEFINE_MUTEX(module_mutex);
@@ -285,7 +286,7 @@ static unsigned long __find_symbol(const
 		}
 	}
 	DEBUGP("Failed to find symbol %s\n", name);
-	return 0;
+	return UNRESOLVED;
 }
 
 /* Search for module by name: must hold module_mutex. */
@@ -755,7 +756,7 @@ void __symbol_put(const char *symbol)
 	const unsigned long *crc;
 
 	preempt_disable();
-	if (!__find_symbol(symbol, &owner, &crc, 1))
+	if (__find_symbol(symbol, &owner, &crc, 1) == UNRESOLVED)
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -899,7 +900,7 @@ static inline int check_modstruct_versio
 	const unsigned long *crc;
 	struct module *owner;
 
-	if (!__find_symbol("struct_module", &owner, &crc, 1))
+	if (__find_symbol("struct_module", &owner, &crc, 1) == UNRESOLVED)
 		BUG();
 	return check_version(sechdrs, versindex, "struct_module", mod,
 			     crc);
@@ -952,7 +953,7 @@ static unsigned long resolve_symbol(Elf_
 		/* use_module can fail due to OOM, or module unloading */
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
 		    !use_module(mod, owner))
-			ret = 0;
+			ret = UNRESOLVED;
 	}
 	return ret;
 }
@@ -1345,14 +1346,14 @@ static int verify_export_symbols(struct 
 	const unsigned long *crc;
 
 	for (i = 0; i < mod->num_syms; i++)
-		if (__find_symbol(mod->syms[i].name, &owner, &crc, 1)) {
+		if (__find_symbol(mod->syms[i].name, &owner, &crc, 1) != UNRESOLVED) {
 			name = mod->syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
 		}
 
 	for (i = 0; i < mod->num_gpl_syms; i++)
-		if (__find_symbol(mod->gpl_syms[i].name, &owner, &crc, 1)) {
+		if (__find_symbol(mod->gpl_syms[i].name, &owner, &crc, 1)!= UNRESOLVED) {
 			name = mod->gpl_syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
@@ -1402,7 +1403,7 @@ static int simplify_symbols(Elf_Shdr *se
 					   strtab + sym[i].st_name, mod);
 
 			/* Ok if resolved.  */
-			if (sym[i].st_value != 0)
+			if (sym[i].st_value != UNRESOLVED)
 				break;
 			/* Ok if weak.  */
 			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)

-- 
