Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbXKUVCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbXKUVCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 16:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXKUVCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 16:02:11 -0500
Received: from relay1.sgi.com ([192.48.171.29]:48116 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751096AbXKUVCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 16:02:10 -0500
Date: Wed, 21 Nov 2007 13:02:09 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Modules: Handle symbols that have a zero value
In-Reply-To: <20071121133821.GA26686@Krystal>
Message-ID: <Pine.LNX.4.64.0711211300590.3625@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711202154430.31617@schroedinger.engr.sgi.com>
 <20071121133821.GA26686@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007, Mathieu Desnoyers wrote:

> return -ENOENT;
> 
> directly ?
> 
> (ERR_PTR() in linux/err.h is a simple cast from long to void*).

Right and there is also IS_ERR_VALUE. Thanks for the feedback. New 
version:


Modules: Handle symbols that have a zero value

The module subsystem cannot handle symbols that are zero. If symbols are
present that have a zero value then the module resolver prints out
a message that these symbols are unresolved.

Use ERR_PTR to return an error code instead of 0. This is a bit awkward
since the addresses are handled as unsigned longs. So we need to convert
them everywhere.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 kernel/module.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2007-11-21 12:58:33.095608448 -0800
+++ linux-2.6/kernel/module.c	2007-11-21 13:00:30.199108674 -0800
@@ -285,7 +285,7 @@ static unsigned long __find_symbol(const
 		}
 	}
 	DEBUGP("Failed to find symbol %s\n", name);
-	return 0;
+	return -ENOENT;
 }
 
 /* Search for module by name: must hold module_mutex. */
@@ -756,7 +756,7 @@ void __symbol_put(const char *symbol)
 	const unsigned long *crc;
 
 	preempt_disable();
-	if (!__find_symbol(symbol, &owner, &crc, 1))
+	if (IS_ERR_VALUE(__find_symbol(symbol, &owner, &crc, 1)))
 		BUG();
 	module_put(owner);
 	preempt_enable();
@@ -902,7 +902,8 @@ static inline int check_modstruct_versio
 	const unsigned long *crc;
 	struct module *owner;
 
-	if (!__find_symbol("struct_module", &owner, &crc, 1))
+	if (IS_ERR_VALUE(__find_symbol("struct_module",
+						&owner, &crc, 1)))
 		BUG();
 	return check_version(sechdrs, versindex, "struct_module", mod,
 			     crc);
@@ -955,7 +956,7 @@ static unsigned long resolve_symbol(Elf_
 		/* use_module can fail due to OOM, or module unloading */
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
 		    !use_module(mod, owner))
-			ret = 0;
+			ret = -EINVAL;
 	}
 	return ret;
 }
@@ -1348,14 +1349,16 @@ static int verify_export_symbols(struct 
 	const unsigned long *crc;
 
 	for (i = 0; i < mod->num_syms; i++)
-		if (__find_symbol(mod->syms[i].name, &owner, &crc, 1)) {
+		if (!IS_ERR_VALUE(__find_symbol(mod->syms[i].name,
+							&owner, &crc, 1))) {
 			name = mod->syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
 		}
 
 	for (i = 0; i < mod->num_gpl_syms; i++)
-		if (__find_symbol(mod->gpl_syms[i].name, &owner, &crc, 1)) {
+		if (!IS_ERR_VALUE(__find_symbol(mod->gpl_syms[i].name,
+							&owner, &crc, 1))) {
 			name = mod->gpl_syms[i].name;
 			ret = -ENOEXEC;
 			goto dup;
@@ -1405,7 +1408,7 @@ static int simplify_symbols(Elf_Shdr *se
 					   strtab + sym[i].st_name, mod);
 
 			/* Ok if resolved.  */
-			if (sym[i].st_value != 0)
+			if (!IS_ERR_VALUE(sym[i].st_value))
 				break;
 			/* Ok if weak.  */
 			if (ELF_ST_BIND(sym[i].st_info) == STB_WEAK)
