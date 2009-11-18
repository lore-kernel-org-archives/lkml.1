Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZKRWoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZKRWoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:44:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZKRWoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:44:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191AbZKRWoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:44:03 -0500
Date: Wed, 18 Nov 2009 17:43:41 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Message-Id: <14acd28665b633909f7e9873861075fd657e9a52.1258580048.git.jbaron@redhat.com>
In-Reply-To: <cover.1258580048.git.jbaron@redhat.com>
References: <cover.1258580048.git.jbaron@redhat.com>
Subject: [RFC PATCH 4/6] jump label v3 - base patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

base patch to implement 'jump labeling'. Based on a new 'asm goto' inline
assembly gcc mechanism, we can now branch to labels from an 'asm goto'
statment. This allows us to create a 'no-op' fastpath, which can subsequently
be patched with a jump to the slowpath code. This is useful for code which 
might be rarely used, but which we'd like to be able to call, if needed.
Tracepoints are the current usecase that these are being implemented for.

Note that this is conditional on gcc >= 4.5. Also there is a !lockdep
condition. This is b/c the die_notifier takes an rcu_read_lock() on the
int3 trap, which then causes another one etc. Since, we aren't going to be
installing removing the handler, the rcu_read_lock() could be avoided for this
case with some code restructuring.

Also, the patch is dependent on CONFIG_KPROBES. This is simply due to a
reliance on the int3 trap handler code that is only enabled with kprobes. This,
could also be modified.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/include/asm/jump_label.h |   35 ++++++++++++++++++++
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/jump_label.c      |   63 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/vmlinux.lds.h |   11 ++++++-
 include/linux/jump_label.h        |   45 ++++++++++++++++++++++++++
 5 files changed, 154 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c
 create mode 100644 include/linux/jump_label.h

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
new file mode 100644
index 0000000..5817a86
--- /dev/null
+++ b/arch/x86/include/asm/jump_label.h
@@ -0,0 +1,35 @@
+#ifndef _ASM_X86_JUMP_LABEL_H
+#define _ASM_X86_JUMP_LABEL_H
+
+#include <asm/nops.h>
+
+#if (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)) && \
+	!defined(CONFIG_LOCKDEP) && defined(CONFIG_KPROBES)
+# define __HAVE_ARCH_JUMP_LABEL
+#endif
+
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
+
+# ifdef CONFIG_X86_64
+#  define JUMP_LABEL_NOP P6_NOP5
+# else
+#  define JUMP_LABEL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+# endif
+
+# define JUMP_LABEL(tag, label, cond)                                       \
+	do {								   \
+		static const char __jlstrtab_##tag[]                       \
+		__used __attribute__((section("__jump_strings")))  = #tag; \
+		asm goto("1:"						   \
+			JUMP_LABEL_NOP					   \
+			".pushsection __jump_table,  \"a\" \n\t"	   \
+			_ASM_PTR "1b, %l[" #label "], %c0 \n\t"		   \
+			".popsection \n\t"				   \
+			: :  "i" (__jlstrtab_##tag) :  : label);	   \
+	} while (0)
+
+# endif
+
+#endif
+
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4f2e66e..df3b341 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -32,7 +32,7 @@ GCOV_PROFILE_paravirt.o		:= n
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
-obj-y			+= setup.o x86_init.o i8259.o irqinit.o
+obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
new file mode 100644
index 0000000..4131bbd
--- /dev/null
+++ b/arch/x86/kernel/jump_label.c
@@ -0,0 +1,63 @@
+#include <linux/jump_label.h>
+#include <linux/memory.h>
+#include <linux/uaccess.h>
+#include <asm/alternative.h>
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
+
+extern struct jump_entry __start___jump_table[];
+extern struct jump_entry __stop___jump_table[];
+
+union jump_code_union {
+	char code[RELATIVEJUMP_SIZE];
+	struct {
+		char jump;
+		int offset;
+	} __attribute__((packed));
+};
+
+void jump_label_transform(struct jump_entry *entry, enum jump_label_type type)
+{
+	union jump_code_union code;
+
+	if (type == JUMP_LABEL_ENABLE) {
+		code.jump = 0xe9;
+		code.offset = entry->target - (entry->code + RELATIVEJUMP_SIZE);
+	} else {
+#ifdef CONFIG_X86_64
+		/* opcode for P6_NOP5 */
+		code.code[0] = 0x0f;
+		code.code[1] = 0x1f;
+		code.code[2] = 0x44;
+		code.code[3] = 0x00;
+		code.code[4] = 0x00;
+#else
+		code.jump = 0xe9;
+		code.offset = 0;
+#endif
+	}
+
+	mutex_lock(&text_mutex);
+	text_poke_fixup((void *)entry->code, &code, RELATIVEJUMP_SIZE,
+			(void *)entry->code + RELATIVEJUMP_SIZE);
+	mutex_unlock(&text_mutex);
+}
+
+int jump_label_update(const char *name, enum jump_label_type type, void *mod)
+{
+	struct jump_entry *iter;
+
+	if (mod)
+		return 0;
+
+	for (iter = __start___jump_table; iter < __stop___jump_table; iter++) {
+		if (!strcmp(name, iter->name)) {
+			if (kernel_text_address(iter->code))
+				jump_label_transform(iter, type);
+			}
+		}
+	}
+	return 0;
+}
+
+#endif
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 5d5def0..8fcbe3b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -171,7 +171,8 @@
 	BRANCH_PROFILE()		       				\
 	TRACE_PRINTKS()							\
 	FTRACE_EVENTS()							\
-	TRACE_SYSCALLS()
+	TRACE_SYSCALLS()						\
+	JUMP_TABLE()							\
 
 /*
  * Data section helpers
@@ -210,6 +211,7 @@
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
+		*(__jump_strings)/* Jump: strings */	\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
@@ -218,6 +220,7 @@
 									\
 	BUG_TABLE							\
 									\
+									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		VMLINUX_SYMBOL(__start_pci_fixups_early) = .;		\
@@ -561,6 +564,12 @@
 #define BUG_TABLE
 #endif
 
+#define JUMP_TABLE()							\
+	. = ALIGN(64);							\
+		VMLINUX_SYMBOL(__start___jump_table) = .;		\
+		*(__jump_table)						\
+		VMLINUX_SYMBOL(__stop___jump_table) = .;		\
+
 #ifdef CONFIG_PM_TRACE
 #define TRACEDATA							\
 	. = ALIGN(4);							\
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
new file mode 100644
index 0000000..2719506
--- /dev/null
+++ b/include/linux/jump_label.h
@@ -0,0 +1,45 @@
+#ifndef _LINUX_JUMP_LABEL_H
+#define _LINUX_JUMP_LABEL_H
+
+#include <asm/jump_label.h>
+
+struct jump_entry {
+	unsigned long code;
+	unsigned long target;
+	char *name;
+};
+
+enum jump_label_type {
+	JUMP_LABEL_ENABLE,
+	JUMP_LABEL_DISABLE
+};
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
+
+extern int jump_label_update(const char *name, enum jump_label_type type, void *mod);
+
+#define enable_jump_label(name, mod) \
+	jump_label_update(name, JUMP_LABEL_ENABLE, mod);
+
+#define disable_jump_label(name, mod) \
+	jump_label_update(name, JUMP_LABEL_DISABLE, mod);
+
+#else
+
+#define JUMP_LABEL(tag, label, cond)		\
+	if (unlikely(cond))			\
+		goto label;
+
+static inline int enable_jump_label(const char *name, void *mod)
+{
+	return 0;
+}
+
+static inline int disable_jump_label(const char *name, void *mod)
+{
+	return 0;
+}
+
+#endif
+
+#endif
-- 
1.6.5.1

