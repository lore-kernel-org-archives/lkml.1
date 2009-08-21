Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbZHUXNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbZHUXNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932499AbZHUXNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:13:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:43280 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbZHUXNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:13:30 -0400
Date: Fri, 21 Aug 2009 23:13:02 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, sam@ravnborg.org, JBeulich@novell.com,
       tglx@linutronix.de
In-Reply-To: <4A8BC8A00200007800010823@vpn.id2.novell.com>
References: <4A8BC8A00200007800010823@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: properly annotate alternatives.c
Message-ID: <tip-8b5a10fc6fd02289ea03480f93382b1a99006142@git.kernel.org>
Git-Commit-ID: 8b5a10fc6fd02289ea03480f93382b1a99006142
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 21 Aug 2009 23:13:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b5a10fc6fd02289ea03480f93382b1a99006142
Gitweb:     http://git.kernel.org/tip/8b5a10fc6fd02289ea03480f93382b1a99006142
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Wed, 19 Aug 2009 08:40:48 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 21 Aug 2009 15:30:12 -0700

x86: properly annotate alternatives.c

Some of the NOPs tables aren't used on 64-bits, quite some code and
data is needed post-init for module loading only, and a couple of
functions aren't used outside that file (i.e. can be static, and don't
need to be exported).

The change to __INITDATA/__INITRODATA is needed to avoid an assembler
warning.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4A8BC8A00200007800010823@vpn.id2.novell.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/include/asm/alternative.h |    7 ----
 arch/x86/kernel/alternative.c      |   56 ++++++++++++++++++++---------------
 include/linux/init.h               |   12 ++++++-
 3 files changed, 42 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 1a37bcd..c240efc 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -73,8 +73,6 @@ static inline void alternatives_smp_module_del(struct module *mod) {}
 static inline void alternatives_smp_switch(int smp) {}
 #endif	/* CONFIG_SMP */
 
-const unsigned char *const *find_nop_table(void);
-
 /* alternative assembly primitive: */
 #define ALTERNATIVE(oldinstr, newinstr, feature)			\
 									\
@@ -144,8 +142,6 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_end	NULL
 #endif
 
-extern void add_nops(void *insns, unsigned int len);
-
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
  * Allows the kernel to edit read-only pages.
@@ -161,10 +157,7 @@ extern void add_nops(void *insns, unsigned int len);
  * Intel's errata.
  * On the local CPU you need to be protected again NMI or MCE handlers seeing an
  * inconsistent instruction while you patch.
- * The _early version expects the memory to already be RW.
  */
-
 extern void *text_poke(void *addr, const void *opcode, size_t len);
-extern void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f576587..4869351 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
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
@@ -51,7 +52,7 @@ static int __init setup_noreplace_smp(char *str)
 __setup("noreplace-smp", setup_noreplace_smp);
 
 #ifdef CONFIG_PARAVIRT
-static int noreplace_paravirt = 0;
+static int __initdata_or_module noreplace_paravirt = 0;
 
 static int __init setup_noreplace_paravirt(char *str)
 {
@@ -64,16 +65,17 @@ __setup("noreplace-paravirt", setup_noreplace_paravirt);
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
@@ -87,12 +89,13 @@ static const unsigned char *const intel_nops[ASM_NOP_MAX+1] = {
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
@@ -105,13 +108,14 @@ static const unsigned char *const k8_nops[ASM_NOP_MAX+1] = {
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
@@ -125,12 +129,13 @@ static const unsigned char *const k7_nops[ASM_NOP_MAX+1] = {
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
@@ -146,7 +151,7 @@ static const unsigned char *const p6_nops[ASM_NOP_MAX+1] = {
 #ifdef CONFIG_X86_64
 
 extern char __vsyscall_0;
-const unsigned char *const *find_nop_table(void)
+static const unsigned char *const *__init_or_module find_nop_table(void)
 {
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
 	    boot_cpu_has(X86_FEATURE_NOPL))
@@ -157,7 +162,7 @@ const unsigned char *const *find_nop_table(void)
 
 #else /* CONFIG_X86_64 */
 
-const unsigned char *const *find_nop_table(void)
+static const unsigned char *const *__init_or_module find_nop_table(void)
 {
 	if (boot_cpu_has(X86_FEATURE_K8))
 		return k8_nops;
@@ -172,7 +177,7 @@ const unsigned char *const *find_nop_table(void)
 #endif /* CONFIG_X86_64 */
 
 /* Use this to add nops to a buffer, then text_poke the whole buffer. */
-void add_nops(void *insns, unsigned int len)
+static void __init_or_module add_nops(void *insns, unsigned int len)
 {
 	const unsigned char *const *noptable = find_nop_table();
 
@@ -185,10 +190,10 @@ void add_nops(void *insns, unsigned int len)
 		len -= noplen;
 	}
 }
-EXPORT_SYMBOL_GPL(add_nops);
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
+static void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
@@ -196,7 +201,8 @@ extern u8 *__smp_locks[], *__smp_locks_end[];
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
 
@@ -317,7 +324,7 @@ void alternatives_smp_module_add(struct module *mod, char *name,
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
@@ -485,7 +492,8 @@ void __init alternative_instructions(void)
  * instructions. And on the local CPU you need to be protected again NMI or MCE
  * handlers seeing an inconsistent instruction while you patch.
  */
-void *text_poke_early(void *addr, const void *opcode, size_t len)
+static void *__init_or_module text_poke_early(void *addr, const void *opcode,
+					      size_t len)
 {
 	unsigned long flags;
 	local_irq_save(flags);
diff --git a/include/linux/init.h b/include/linux/init.h
index 13b633e..400adbb 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -103,8 +103,8 @@
 #define __INIT		.section	".init.text","ax"
 #define __FINIT		.previous
 
-#define __INITDATA	.section	".init.data","aw"
-#define __INITRODATA	.section	".init.rodata","a"
+#define __INITDATA	.section	".init.data","aw",%progbits
+#define __INITRODATA	.section	".init.rodata","a",%progbits
 #define __FINITDATA	.previous
 
 #define __DEVINIT        .section	".devinit.text", "ax"
@@ -305,9 +305,17 @@ void __init parse_early_options(char *cmdline);
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
