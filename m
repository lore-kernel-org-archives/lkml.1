Return-Path: <linux-kernel-owner+w=401wt.eu-S1161626AbXD2Xu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161626AbXD2Xu6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161607AbXD2Xqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:46:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:38490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161606AbXD2Xqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:33 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [22/26] i386: Remove smp_alt_instructions
Message-Id: <20070429234632.2ED1A151C5@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
The .smp_altinstructions section and its corresponding symbols are
completely unused, so remove them.

Also, remove stray #ifdef __KENREL__ in asm-i386/alternative.h

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/alternative.c |   38 ++------------------------------------
 arch/i386/kernel/vmlinux.lds.S |   11 -----------
 include/asm-i386/alternative.h |    6 +-----
 3 files changed, 3 insertions(+), 52 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -132,11 +132,8 @@ static void nop_out(void *insns, unsigne
 }
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
-extern struct alt_instr __smp_alt_instructions[], __smp_alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
 
-extern u8 __smp_alt_begin[], __smp_alt_end[];
-
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
    self modifying code. This implies that assymetric systems where
@@ -171,29 +168,6 @@ void apply_alternatives(struct alt_instr
 
 #ifdef CONFIG_SMP
 
-static void alternatives_smp_save(struct alt_instr *start, struct alt_instr *end)
-{
-	struct alt_instr *a;
-
-	DPRINTK("%s: alt table %p-%p\n", __FUNCTION__, start, end);
-	for (a = start; a < end; a++) {
-		memcpy(a->replacement + a->replacementlen,
-		       a->instr,
-		       a->instrlen);
-	}
-}
-
-static void alternatives_smp_apply(struct alt_instr *start, struct alt_instr *end)
-{
-	struct alt_instr *a;
-
-	for (a = start; a < end; a++) {
-		memcpy(a->instr,
-		       a->replacement + a->replacementlen,
-		       a->instrlen);
-	}
-}
-
 static void alternatives_smp_lock(u8 **start, u8 **end, u8 *text, u8 *text_end)
 {
 	u8 **ptr;
@@ -319,8 +293,6 @@ void alternatives_smp_switch(int smp)
 		printk(KERN_INFO "SMP alternatives: switching to SMP code\n");
 		clear_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
 		clear_bit(X86_FEATURE_UP, cpu_data[0].x86_capability);
-		alternatives_smp_apply(__smp_alt_instructions,
-				       __smp_alt_instructions_end);
 		list_for_each_entry(mod, &smp_alt_modules, next)
 			alternatives_smp_lock(mod->locks, mod->locks_end,
 					      mod->text, mod->text_end);
@@ -328,8 +300,6 @@ void alternatives_smp_switch(int smp)
 		printk(KERN_INFO "SMP alternatives: switching to UP code\n");
 		set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
 		set_bit(X86_FEATURE_UP, cpu_data[0].x86_capability);
-		apply_alternatives(__smp_alt_instructions,
-				   __smp_alt_instructions_end);
 		list_for_each_entry(mod, &smp_alt_modules, next)
 			alternatives_smp_unlock(mod->locks, mod->locks_end,
 						mod->text, mod->text_end);
@@ -396,17 +366,13 @@ void __init alternative_instructions(voi
 			printk(KERN_INFO "SMP alternatives: switching to UP code\n");
 			set_bit(X86_FEATURE_UP, boot_cpu_data.x86_capability);
 			set_bit(X86_FEATURE_UP, cpu_data[0].x86_capability);
-			apply_alternatives(__smp_alt_instructions,
-					   __smp_alt_instructions_end);
 			alternatives_smp_unlock(__smp_locks, __smp_locks_end,
 						_text, _etext);
 		}
 		free_init_pages("SMP alternatives",
-				__pa_symbol(&__smp_alt_begin),
-				__pa_symbol(&__smp_alt_end));
+				__pa_symbol(&__smp_locks),
+				__pa_symbol(&__smp_locks_end));
 	} else {
-		alternatives_smp_save(__smp_alt_instructions,
-				      __smp_alt_instructions_end);
 		alternatives_smp_module_add(NULL, "core kernel",
 					    __smp_locks, __smp_locks_end,
 					    _text, _etext);
Index: linux/arch/i386/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/i386/kernel/vmlinux.lds.S
+++ linux/arch/i386/kernel/vmlinux.lds.S
@@ -117,22 +117,11 @@ SECTIONS
 
   /* might get freed after init */
   . = ALIGN(4096);
-  .smp_altinstructions : AT(ADDR(.smp_altinstructions) - LOAD_OFFSET) {
-	__smp_alt_begin = .;
-	__smp_alt_instructions = .;
-	*(.smp_altinstructions)
-	__smp_alt_instructions_end = .;
-  }
-  . = ALIGN(4);
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
   	__smp_locks = .;
 	*(.smp_locks)
 	__smp_locks_end = .;
   }
-  .smp_altinstr_replacement : AT(ADDR(.smp_altinstr_replacement) - LOAD_OFFSET) {
-	*(.smp_altinstr_replacement)
-  	__smp_alt_end = .;
-  }
   /* will be freed after init
    * Following ALIGN() is required to make sure no other data falls on the
    * same page where __smp_alt_end is pointing as that page might be freed
Index: linux/include/asm-i386/alternative.h
===================================================================
--- linux.orig/include/asm-i386/alternative.h
+++ linux/include/asm-i386/alternative.h
@@ -1,8 +1,6 @@
 #ifndef _I386_ALTERNATIVE_H
 #define _I386_ALTERNATIVE_H
 
-#ifdef __KERNEL__
-
 #include <asm/types.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
@@ -32,9 +30,7 @@ static inline void alternatives_smp_modu
 					void *text, void *text_end) {}
 static inline void alternatives_smp_module_del(struct module *mod) {}
 static inline void alternatives_smp_switch(int smp) {}
-#endif
-
-#endif
+#endif	/* CONFIG_SMP */
 
 /*
  * Alternative instructions for different CPU types or capabilities.
