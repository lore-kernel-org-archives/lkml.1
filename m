Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618Ab0ALQ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0ALQ20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520Ab0ALQ1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:27:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab0ALQ1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:27:20 -0500
Date: Tue, 12 Jan 2010 11:26:41 -0500
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Message-Id: <f380f42ecb703d9b036266497751d4fcad6323fe.1263247114.git.jbaron@redhat.com>
In-Reply-To: <cover.1263247113.git.jbaron@redhat.com>
References: <cover.1263247113.git.jbaron@redhat.com>
Subject: [RFC PATCH 6/8] jump label v4 - x86 support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add x86 support for jump label. I'm keeping this patch separate so its clear to arch maintainers what was required for x86 support this new feature. hopefully, it wouldn't be too painful for other arches.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/include/asm/jump_label.h |   32 ++++++++++++++++++++++
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/jump_label.c      |   52 +++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/jump_label.h
 create mode 100644 arch/x86/kernel/jump_label.c

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
new file mode 100644
index 0000000..ac09c1c
--- /dev/null
+++ b/arch/x86/include/asm/jump_label.h
@@ -0,0 +1,32 @@
+#ifndef _ASM_X86_JUMP_LABEL_H
+#define _ASM_X86_JUMP_LABEL_H
+
+#include <asm/nops.h>
+
+#if (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4)) && \
+	defined(CONFIG_KPROBES)
+# define __HAVE_ARCH_JUMP_LABEL
+#endif
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
+
+# ifdef CONFIG_X86_64
+#  define JUMP_LABEL_NOP P6_NOP5
+# else
+#  define JUMP_LABEL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+# endif
+
+# define JUMP_LABEL(tag, label, cond)				\
+	do {							\
+		extern const char __jlstrtab_##tag[];		\
+		asm goto("1:"					\
+			JUMP_LABEL_NOP				\
+			".pushsection __jump_table,  \"a\" \n\t"\
+			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
+			".popsection \n\t"			\
+			: :  "i" (__jlstrtab_##tag) :  : label);\
+	} while (0)
+
+# endif
+
+#endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index d87f09b..6c6fc98 100644
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
index 0000000..6cb5bea
--- /dev/null
+++ b/arch/x86/kernel/jump_label.c
@@ -0,0 +1,52 @@
+/*
+ * jump label x86 support
+ *
+ * Copyright (C) 2009 Jason Baron <jbaron@redhat.com>
+ *
+ */
+#include <linux/jump_label.h>
+#include <linux/memory.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/jhash.h>
+#include <asm/alternative.h>
+
+#ifdef __HAVE_ARCH_JUMP_LABEL
+
+union jump_code_union {
+	char code[RELATIVEJUMP_SIZE];
+	struct {
+		char jump;
+		int offset;
+	} __attribute__((packed));
+};
+
+void arch_jump_label_transform(struct jump_entry *entry, enum jump_label_type type)
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
+#endif
-- 
1.6.5.1

