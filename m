Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbYBEFJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbYBEFJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 00:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbYBEFJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 00:09:38 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46470 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbYBEFJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 00:09:36 -0500
Date: Tue, 5 Feb 2008 10:40:05 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hskinnemoen@atmel.com,
       Masami Hiramatsu <mhiramat@redhat.com>, sam@ravnborg.org
Subject: [PATCH 1/2] Kprobes: Indicate kretprobe support in Kconfig
Message-ID: <20080205051004.GA12223@in.ibm.com>
Reply-To: ananth@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch adds CONFIG_HAVE_KRETPROBES to the arch/<arch>/Kconfig file
for relevant architectures with kprobes support. This facilitates easy
handling of in-kernel modules (like samples/kprobes/kretprobe_example.c)
that depend on kretprobes being present in the kernel.

Updated to apply on 2.6.24-mm1. Thanks to Sam Ravnborg for helping
make the patch more lean.

Per Mathieu's suggestion, added CONFIG_KRETPROBES and fixed up
dependencies.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/Kconfig                  |    7 +++++++
 arch/ia64/Kconfig             |    1 +
 arch/powerpc/Kconfig          |    1 +
 arch/s390/Kconfig             |    1 +
 arch/x86/Kconfig              |    1 +
 include/asm-ia64/kprobes.h    |    1 -
 include/asm-powerpc/kprobes.h |    1 -
 include/asm-x86/kprobes.h     |    1 -
 include/linux/kprobes.h       |    6 +++---
 kernel/kprobes.c              |    9 +++------
 10 files changed, 17 insertions(+), 12 deletions(-)

Index: linux-2.6.24/arch/Kconfig
===================================================================
--- linux-2.6.24.orig/arch/Kconfig
+++ linux-2.6.24/arch/Kconfig
@@ -27,5 +27,12 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config KRETPROBES
+	def_bool y
+	depends on KPROBES && HAVE_KRETPROBES
+
 config HAVE_KPROBES
 	def_bool n
+
+config HAVE_KRETPROBES
+	def_bool n
Index: linux-2.6.24/arch/ia64/Kconfig
===================================================================
--- linux-2.6.24.orig/arch/ia64/Kconfig
+++ linux-2.6.24/arch/ia64/Kconfig
@@ -17,6 +17,7 @@ config IA64
 	select ARCH_SUPPORTS_MSI
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
Index: linux-2.6.24/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.24.orig/arch/powerpc/Kconfig
+++ linux-2.6.24/arch/powerpc/Kconfig
@@ -89,6 +89,7 @@ config PPC
 	default y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 
 config EARLY_PRINTK
 	bool
Index: linux-2.6.24/arch/x86/Kconfig
===================================================================
--- linux-2.6.24.orig/arch/x86/Kconfig
+++ linux-2.6.24/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86
 	def_bool y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 
 config GENERIC_LOCKBREAK
 	def_bool n
Index: linux-2.6.24/include/asm-ia64/kprobes.h
===================================================================
--- linux-2.6.24.orig/include/asm-ia64/kprobes.h
+++ linux-2.6.24/include/asm-ia64/kprobes.h
@@ -82,7 +82,6 @@ struct kprobe_ctlblk {
 	struct prev_kprobe prev_kprobe[ARCH_PREV_KPROBE_SZ];
 };
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define kretprobe_blacklist_size 0
 
 #define SLOT0_OPCODE_SHIFT	(37)
Index: linux-2.6.24/include/asm-powerpc/kprobes.h
===================================================================
--- linux-2.6.24.orig/include/asm-powerpc/kprobes.h
+++ linux-2.6.24/include/asm-powerpc/kprobes.h
@@ -80,7 +80,6 @@ typedef unsigned int kprobe_opcode_t;
 #define is_trap(instr)	(IS_TW(instr) || IS_TWI(instr))
 #endif
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 #define kretprobe_blacklist_size 0
 
Index: linux-2.6.24/include/asm-x86/kprobes.h
===================================================================
--- linux-2.6.24.orig/include/asm-x86/kprobes.h
+++ linux-2.6.24/include/asm-x86/kprobes.h
@@ -42,7 +42,6 @@ typedef u8 kprobe_opcode_t;
 	: (((unsigned long)current_thread_info()) + THREAD_SIZE \
 	   - (unsigned long)(ADDR)))
 
-#define ARCH_SUPPORTS_KRETPROBES
 #define flush_insn_slot(p)	do { } while (0)
 
 extern const int kretprobe_blacklist_size;
Index: linux-2.6.24/include/linux/kprobes.h
===================================================================
--- linux-2.6.24.orig/include/linux/kprobes.h
+++ linux-2.6.24/include/linux/kprobes.h
@@ -125,11 +125,11 @@ struct jprobe {
 DECLARE_PER_CPU(struct kprobe *, current_kprobe);
 DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
+#ifdef CONFIG_KRETPROBES
 extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				   struct pt_regs *regs);
 extern int arch_trampoline_kprobe(struct kprobe *p);
-#else /* ARCH_SUPPORTS_KRETPROBES */
+#else /* CONFIG_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
 {
@@ -138,7 +138,7 @@ static inline int arch_trampoline_kprobe
 {
 	return 0;
 }
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_KRETPROBES */
 /*
  * Function-return probe -
  * Note:
Index: linux-2.6.24/kernel/kprobes.c
===================================================================
--- linux-2.6.24.orig/kernel/kprobes.c
+++ linux-2.6.24/kernel/kprobes.c
@@ -678,8 +678,7 @@ void __kprobes unregister_jprobe(struct 
 	unregister_kprobe(&jp->kp);
 }
 
-#ifdef ARCH_SUPPORTS_KRETPROBES
-
+#ifdef CONFIG_KRETPROBES
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
  * hits it will set up the return probe.
@@ -769,8 +768,7 @@ int __kprobes register_kretprobe(struct 
 	return ret;
 }
 
-#else /* ARCH_SUPPORTS_KRETPROBES */
-
+#else /* CONFIG_KRETPROBES */
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
 	return -ENOSYS;
@@ -781,8 +779,7 @@ static int __kprobes pre_handler_kretpro
 {
 	return 0;
 }
-
-#endif /* ARCH_SUPPORTS_KRETPROBES */
+#endif /* CONFIG_KRETPROBES */
 
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
Index: linux-2.6.24/arch/s390/Kconfig
===================================================================
--- linux-2.6.24.orig/arch/s390/Kconfig
+++ linux-2.6.24/arch/s390/Kconfig
@@ -58,6 +58,7 @@ config S390
 	def_bool y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KRETPROBES
 
 source "init/Kconfig"
 
