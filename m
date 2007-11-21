Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbXKUF5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbXKUF5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 00:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXKUF4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 00:56:52 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35800 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752579AbXKUF4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 00:56:51 -0500
Date: Tue, 20 Nov 2007 21:56:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Modules: Handle symbols that have a zero value
Message-ID: <Pine.LNX.4.64.0711202154430.31617@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Another issue that I encountered with the cpu_alloc stuff.



The module subsystem cannot handle symbols that are zero. If symbols are
present that have a zero value then the module resolver prints out
a message that these symbols are unresolved.

Use ERR_PTR to return an error code instead of 0. This is a bit awkward
since the addresses are handled as unsigned longs. So we need to convert
them everywhere.

The idea top use ERR_PTR is from Mathieu.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/module.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2007-11-20 21:06:29.856965949 -0800
+++ linux-2.6/kernel/module.c	2007-11-20 21:16:53.001715887 -0800
@@ -285,7 +285,7 @@ static unsigned long __find_symbol(const
 		}
 	}
 	DEBUGP("Failed to find symbol %s\n", name);
-	return 0;
+	return (unsigned long)ERR_PTR(-ENOENT);
 }
 
 /* Search for module by name: must hold module_mutex. */
@@ -648,7 +648,7 @@ void __symbol_put(const char *symbol)
 	const unsigned long *crc;
 
 	preempt_disable();
-	if (!__find_symbol(symbol, &owner, &crc, 1))
+	if (IS_ERR((void *)__find_symbol(symbol, &owner, &crc, 1)))
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -792,7 +792,8 @@ static inline int check_modstruct_versio
 	const unsigned long *crc;
 	struct module *owner;
 
-	if (!__find_symbol("struct_module", &owner, &crc, 1))
+	if (IS_ERR((void *)__find_symbol("struct_module",
+						&owner, &crc, 1)))
 		BUG();
 	return check_version(sechdrs, versindex, "struct_module", mod,
 			     crc);
@@ -845,7 +846,7 @@ static unsigned long resolve_symbol(Elf_
 		/* use_module can fail due to OOM, or module unloading */
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
 		    !use_module(mod, owner))
-			ret = 0;
+			ret = (unsigned long)ERR_PTR(-EINVAL);
 	}
 	return ret;
 }
@@ -1238,14 +1239,16 @@ static int verify_export_symbols(struct 
 	const unsigned long *crc;
 
 	for (i = 0; i < mod->num_syms; i++)
-		if (__find_symbol(mod->syms[i].name, &owner, &crc, 1)) {
+		if (!IS_ERR((void *)__find_symbol(mod->syms[i].name,
+							&owner, &crc, 1))) {
 			name = mod->syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
 		}
 
 	for (i = 0; i < mod->num_gpl_syms; i++)
-		if (__find_symbol(mod->gpl_syms[i].name, &owner, &crc, 1)) {
+		if (!IS_ERR((void *)__find_symbol(mod->gpl_syms[i].name,
+							&owner, &crc, 1))) {
 			name = mod->gpl_syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
@@ -1295,7 +1298,7 @@ static int simplify_symbols(Elf_Shdr *se
 					   strtab + sym[i].st_name, mod);
 
 			/* Ok if resolved.  */
-			if (sym[i].st_value != 0)
+			if (!IS_ERR((void *)sym[i].st_value))
 				break;
 			/* Ok if weak.  */
 			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
