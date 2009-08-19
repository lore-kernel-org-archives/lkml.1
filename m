Return-Path: <linux-kernel-owner+w=401wt.eu-S1751720AbZHSHky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbZHSHky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbZHSHky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:40:54 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:15485 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZHSHkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:40:53 -0400
Message-Id: <4A8BC8A00200007800010823@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 19 Aug 2009 08:40:48 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: properly annotate alternatives.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the NOPs tables aren't used on 64-bits, quite some code and
data is needed post-init for module loading only, and a couple of
functions aren't used outside that file (i.e. can be static, and don't
need to be exported).

The change to __INITDATA/__INITRODATA is needed to avoid an assembler
warning.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

---
 arch/x86/include/asm/alternative.h |    7 ----
 arch/x86/kernel/alternative.c      |   56 +++++++++++++++++++++----------------
 include/linux/init.h               |   12 ++++++-
 3 files changed, 42 insertions(+), 33 deletions(-)

--- linux-2.6.31-rc6/arch/x86/include/asm/alternative.h	2009-08-18 15:31:15.000000000 +0200
+++ 2.6.31-rc6-x86-alt-insn-no-mod/arch/x86/include/asm/alternative.h	2009-08-06 14:36:26.000000000 +0200
@@ -73,8 +73,6 @@ static inline void alternatives_smp_modu
 static inline void alternatives_smp_switch(int smp) {}
 #endif	/* CONFIG_SMP */
 
-const unsigned char *const *find_nop_table(void);
-
 /* alternative assembly primitive: */
 #define ALTERNATIVE(oldinstr, newinstr, feature)			\
 									\
@@ -144,8 +142,6 @@ static inline void apply_paravirt(struct
 #define __parainstructions_end	NULL
 #endif
 
-extern void add_nops(void *insns, unsigned int len);
-
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
  * Allows the kernel to edit read-only pages.
@@ -161,10 +157,7 @@ extern void add_nops(void *insns, unsign
  * Intel's errata.
  * On the local CPU you need to be protected again NMI or MCE handlers seeing an
  * inconsistent instruction while you patch.
- * The _early version expects the memory to already be RW.
  */
-
 extern void *text_poke(void *addr, const void *opcode, size_t len);
-extern void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
--- linux-2.6.31-rc6/arch/x86/kernel/alternative.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc6-x86-alt-insn-no-mod/arch/x86/kernel/alternative.c	2009-08-06 15:22:07.000000000 +0200
@@ -2,6 +2,7 @@
 #include <linux/sched.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/stringify.h>
 #include <linux/kprobes.h>
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
@@ -32,7 +33,7 @@ __setup("smp-alt-boot", bootonly);
 #define smp_alt_once 1
 #endif
 
-static int debug_alternative;
+static int __initdata_or_module debug_alternative;
 
 static int __init debug_alt(char *str)
 {
@@ -51,7 +52,7 @@ static int __init setup_noreplace_smp(ch
 __setup("noreplace-smp", setup_noreplace_smp);
 
 #ifdef CONFIG_PARAVIRT
-static int noreplace_paravirt = 0;
+static int __initdata_or_module noreplace_paravirt = 0;
 
 static int __init setup_noreplace_paravirt(char *str)
 {
@@ -64,16 +65,17 @@ __setup("noreplace-paravirt", setup_nore
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
 
-#ifdef GENERIC_NOP1
+#if defined(GENERIC_NOP1) && !defined(CONFIG_X86_64)
 /* Use inline assembly to define this because the nops are defined
    as inline assembly strings in the include files and we cannot
    get them easily into strings. */
-asm("\t.section .rodata, \"a\"\nintelnops: "
+asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nintelnops: "
 	GENERIC_NOP1 GENERIC_NOP2 GENERIC_NOP3 GENERIC_NOP4 GENERIC_NOP5 GENERIC_NOP6
 	GENERIC_NOP7 GENERIC_NOP8
     "\t.previous");
 extern const unsigned char intelnops[];
-static const unsigned char *const intel_nops[ASM_NOP_MAX+1] = {
+static const unsigned char *const __initconst_or_module
+intel_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	intelnops,
 	intelnops + 1,
@@ -87,12 +89,13 @@ static const unsigned char *const intel_
 #endif
 
 #ifdef K8_NOP1
-asm("\t.section .rodata, \"a\"\nk8nops: "
+asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nk8nops: "
 	K8_NOP1 K8_NOP2 K8_NOP3 K8_NOP4 K8_NOP5 K8_NOP6
 	K8_NOP7 K8_NOP8
     "\t.previous");
 extern const unsigned char k8nops[];
-static const unsigned char *const k8_nops[ASM_NOP_MAX+1] = {
+static const unsigned char *const __initconst_or_module
+k8_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	k8nops,
 	k8nops + 1,
@@ -105,13 +108,14 @@ static const unsigned char *const k8_nop
 };
 #endif
 
-#ifdef K7_NOP1
-asm("\t.section .rodata, \"a\"\nk7nops: "
+#if defined(K7_NOP1) && !defined(CONFIG_X86_64)
+asm("\t" __stringify(__INITRODATA_OR_MODULE) "\nk7nops: "
 	K7_NOP1 K7_NOP2 K7_NOP3 K7_NOP4 K7_NOP5 K7_NOP6
 	K7_NOP7 K7_NOP8
     "\t.previous");
 extern const unsigned char k7nops[];
-static const unsigned char *const k7_nops[ASM_NOP_MAX+1] = {
+static const unsigned char *const __initconst_or_module
+k7_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	k7nops,
 	k7nops + 1,
@@ -125,12 +129,13 @@ static const unsigned char *const k7_nop
 #endif
 
 #ifdef P6_NOP1
-asm("\t.section .rodata, \"a\"\np6nops: "
+asm("\t" __stringify(__INITRODATA_OR_MODULE) "\np6nops: "
 	P6_NOP1 P6_NOP2 P6_NOP3 P6_NOP4 P6_NOP5 P6_NOP6
 	P6_NOP7 P6_NOP8
     "\t.previous");
 extern const unsigned char p6nops[];
-static const unsigned char *const p6_nops[ASM_NOP_MAX+1] = {
+static const unsigned char *const __initconst_or_module
+p6_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	p6nops,
 	p6nops + 1,
@@ -146,7 +151,7 @@ static const unsigned char *const p6_nop
 #ifdef CONFIG_X86_64
 
 extern char __vsyscall_0;
-const unsigned char *const *find_nop_table(void)
+static const unsigned char *const *__init_or_module find_nop_table(void)
 {
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
 	    boot_cpu_has(X86_FEATURE_NOPL))
@@ -157,7 +162,7 @@ const unsigned char *const *find_nop_tab
 
 #else /* CONFIG_X86_64 */
 
-const unsigned char *const *find_nop_table(void)
+static const unsigned char *const *__init_or_module find_nop_table(void)
 {
 	if (boot_cpu_has(X86_FEATURE_K8))
 		return k8_nops;
@@ -172,7 +177,7 @@ const unsigned char *const *find_nop_tab
 #endif /* CONFIG_X86_64 */
 
 /* Use this to add nops to a buffer, then text_poke the whole buffer. */
-void add_nops(void *insns, unsigned int len)
+static void __init_or_module add_nops(void *insns, unsigned int len)
 {
 	const unsigned char *const *noptable = find_nop_table();
 
@@ -185,10 +190,10 @@ void add_nops(void *insns, unsigned int 
 		len -= noplen;
 	}
 }
-EXPORT_SYMBOL_GPL(add_nops);
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
+static void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
@@ -196,7 +201,8 @@ extern u8 *__smp_locks[], *__smp_locks_e
    APs have less capabilities than the boot processor are not handled.
    Tough. Make sure you disable such features by hand. */
 
-void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
+void __init_or_module apply_alternatives(struct alt_instr *start,
+					 struct alt_instr *end)
 {
 	struct alt_instr *a;
 	char insnbuf[MAX_PATCH_LEN];
@@ -279,9 +285,10 @@ static LIST_HEAD(smp_alt_modules);
 static DEFINE_MUTEX(smp_alt);
 static int smp_mode = 1;	/* protected by smp_alt */
 
-void alternatives_smp_module_add(struct module *mod, char *name,
-				 void *locks, void *locks_end,
-				 void *text,  void *text_end)
+void __init_or_module alternatives_smp_module_add(struct module *mod,
+						  char *name,
+						  void *locks, void *locks_end,
+						  void *text,  void *text_end)
 {
 	struct smp_alt_module *smp;
 
@@ -317,7 +324,7 @@ void alternatives_smp_module_add(struct 
 	mutex_unlock(&smp_alt);
 }
 
-void alternatives_smp_module_del(struct module *mod)
+void __init_or_module alternatives_smp_module_del(struct module *mod)
 {
 	struct smp_alt_module *item;
 
@@ -386,8 +393,8 @@ void alternatives_smp_switch(int smp)
 #endif
 
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch_site *start,
-		    struct paravirt_patch_site *end)
+void __init_or_module apply_paravirt(struct paravirt_patch_site *start,
+				     struct paravirt_patch_site *end)
 {
 	struct paravirt_patch_site *p;
 	char insnbuf[MAX_PATCH_LEN];
@@ -485,7 +492,8 @@ void __init alternative_instructions(voi
  * instructions. And on the local CPU you need to be protected again NMI or MCE
  * handlers seeing an inconsistent instruction while you patch.
  */
-void *text_poke_early(void *addr, const void *opcode, size_t len)
+static void *__init_or_module text_poke_early(void *addr, const void *opcode,
+					      size_t len)
 {
 	unsigned long flags;
 	local_irq_save(flags);
--- linux-2.6.31-rc6/include/linux/init.h	2009-08-18 15:31:55.000000000 +0200
+++ 2.6.31-rc6-x86-alt-insn-no-mod/include/linux/init.h	2009-08-19 09:31:49.000000000 +0200
@@ -103,8 +103,8 @@
 #define __INIT		.section	".init.text","ax"
 #define __FINIT		.previous
 
-#define __INITDATA	.section	".init.data","aw"
-#define __INITRODATA	.section	".init.rodata","a"
+#define __INITDATA	.section	".init.data","aw",%progbits
+#define __INITRODATA	.section	".init.rodata","a",%progbits
 #define __FINITDATA	.previous
 
 #define __DEVINIT        .section	".devinit.text", "ax"
@@ -305,9 +305,17 @@ void __init parse_early_options(char *cm
 #ifdef CONFIG_MODULES
 #define __init_or_module
 #define __initdata_or_module
+#define __initconst_or_module
+#define __INIT_OR_MODULE	.text
+#define __INITDATA_OR_MODULE	.data
+#define __INITRODATA_OR_MODULE	.section ".rodata","a",%progbits
 #else
 #define __init_or_module __init
 #define __initdata_or_module __initdata
+#define __initconst_or_module __initconst
+#define __INIT_OR_MODULE __INIT
+#define __INITDATA_OR_MODULE __INITDATA
+#define __INITRODATA_OR_MODULE __INITRODATA
 #endif /*CONFIG_MODULES*/
 
 /* Functions marked as __devexit may be discarded at kernel link time, depending


