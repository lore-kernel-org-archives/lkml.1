Return-Path: <linux-kernel-owner+w=401wt.eu-S966249AbXDDBjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966249AbXDDBjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966257AbXDDBfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:35:50 -0400
Received: from 250.sub-75-209-50.myvzw.com ([75.209.50.250]:34562 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966253AbXDDBff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:35:35 -0400
Message-Id: <20070404011453.469210646@goop.org>
References: <20070404010655.400913479@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Apr 2007 18:06:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 3/6] Remove smp_alt_instructions
Content-Disposition: inline; filename=remove-smp_alt_instructions.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The .smp_altinstructions section and its corresponding symbols are
completely unused, so remove them.

Also, remove stray #ifdef __KENREL__ in asm-i386/alternative.h

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/alternative.c |   38 ++------------------------------------
 arch/i386/kernel/vmlinux.lds.S |   11 -----------
 include/asm-i386/alternative.h |    6 +-----
 3 files changed, 3 insertions(+), 52 deletions(-)

===================================================================
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -132,10 +132,7 @@ static void nop_out(void *insns, unsigne
 }
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
-extern struct alt_instr __smp_alt_instructions[], __smp_alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
-
-extern u8 __smp_alt_begin[], __smp_alt_end[];
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
@@ -170,29 +167,6 @@ void apply_alternatives(struct alt_instr
 }
 
 #ifdef CONFIG_SMP
-
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
 
 static void alternatives_smp_lock(u8 **start, u8 **end, u8 *text, u8 *text_end)
 {
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
@@ -384,17 +354,13 @@ void __init alternative_instructions(voi
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
===================================================================
--- a/arch/i386/kernel/vmlinux.lds.S
+++ b/arch/i386/kernel/vmlinux.lds.S
@@ -116,21 +116,10 @@ SECTIONS
 
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
-  }
-  .smp_altinstr_replacement : AT(ADDR(.smp_altinstr_replacement) - LOAD_OFFSET) {
-	*(.smp_altinstr_replacement)
-  	__smp_alt_end = .;
   }
   /* will be freed after init
    * Following ALIGN() is required to make sure no other data falls on the
===================================================================
--- a/include/asm-i386/alternative.h
+++ b/include/asm-i386/alternative.h
@@ -1,7 +1,5 @@
 #ifndef _I386_ALTERNATIVE_H
 #define _I386_ALTERNATIVE_H
-
-#ifdef __KERNEL__
 
 #include <asm/types.h>
 #include <linux/stddef.h>
@@ -31,9 +29,7 @@ static inline void alternatives_smp_modu
 					void *text, void *text_end) {}
 static inline void alternatives_smp_module_del(struct module *mod) {}
 static inline void alternatives_smp_switch(int smp) {}
-#endif
-
-#endif
+#endif	/* CONFIG_SMP */
 
 /*
  * Alternative instructions for different CPU types or capabilities.

-- 

