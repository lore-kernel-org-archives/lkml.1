Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZJUOfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZJUOfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZJUOfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:35:43 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64251 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbZJUOfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:35:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KG8qyhi8i1roH8FPuZsCeXBgjoQ115qurRb5MoFbpmis1tRdSyA205KkjvbggpA2v3
         1nSjmfLau8zHoUhFkpc2Q1Z1FKgaSWSBc9Nsgb/n/k/NuhLDEsZUXmKLUibpXhVzjIHO
         UErtAavll+ZDTQnRyNLr1eeY+WjTwhZOKWT74=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Steven Rostedt <rostedt@goodmis.org>, Wu Zhangjin <wuzj@lemote.com>
Subject: [PATCH -v4 7/9] tracing: add dynamic function tracer support for MIPS
Date: Wed, 21 Oct 2009 22:35:01 +0800
Message-Id: <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>
 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1256135456.git.wuzhangjin@gmail.com>
References: <cover.1256135456.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dynamic function tracer need to replace "nop" to "jumps & links" and
something reversely.

in linux-mips64, there will be some local symbols, whose name are
prefixed by $L, which need to be filtered. thanks goes to Steven for
writing the mips64-specific function_regex.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/Kconfig              |    2 +
 arch/mips/include/asm/ftrace.h |   10 ++++
 arch/mips/kernel/Makefile      |    3 +-
 arch/mips/kernel/ftrace.c      |  107 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mcount.S      |   31 ++++++++++++
 scripts/recordmcount.pl        |   22 ++++++++
 6 files changed, 174 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/kernel/ftrace.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index a9bd992..147fbbc 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -6,6 +6,8 @@ config MIPS
 	select HAVE_ARCH_KGDB
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	select HAVE_DYNAMIC_FTRACE
+	select HAVE_FTRACE_MCOUNT_RECORD
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB if !LEMOTE_FULOONG2E
diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
index 5f8ebcf..b4970c9 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -19,6 +19,16 @@
 extern void _mcount(void);
 #define mcount _mcount
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+/* reloction of mcount call site is the same as the address */
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	return addr;
+}
+
+struct dyn_arch_ftrace {
+};
+#endif /*  CONFIG_DYNAMIC_FTRACE */
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 #endif /* _ASM_MIPS_FTRACE_H */
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index 38e704a..3cda3ab 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -10,6 +10,7 @@ obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_trace_clock.o = -pg
+CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
@@ -30,7 +31,7 @@ obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
 
 obj-$(CONFIG_FTRACE)		+= trace_clock.o
-obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
+obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o ftrace.o
 
 obj-$(CONFIG_CPU_LOONGSON2)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_MIPS32)	+= r4k_fpu.o r4k_switch.o
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
new file mode 100644
index 0000000..1e44865
--- /dev/null
+++ b/arch/mips/kernel/ftrace.c
@@ -0,0 +1,107 @@
+/*
+ * Code for replacing ftrace calls with jumps.
+ *
+ * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2009 DSLab, Lanzhou University, China
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ *
+ * Thanks goes to Steven Rostedt for writing the original x86 version.
+ */
+
+#include <linux/uaccess.h>
+#include <linux/init.h>
+#include <linux/ftrace.h>
+
+#include <asm/cacheflush.h>
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+#define JAL 0x0c000000		/* jump & link: ip --> ra, jump to target */
+#define ADDR_MASK 0x03ffffff	/*  op_code|addr : 31...26|25 ....0 */
+
+#ifdef CONFIG_CPU_LOONGSON2
+static unsigned int ftrace_nop = 0x00020021;
+#else
+static unsigned int ftrace_nop = 0x00000000;
+#endif
+
+static unsigned char *ftrace_call_replace(unsigned long op_code,
+					  unsigned long addr)
+{
+	static unsigned int op;
+
+	op = op_code | ((addr >> 2) & ADDR_MASK);
+
+	return (unsigned char *)&op;
+}
+
+static unsigned char *ftrace_nop_replace(void)
+{
+	return (unsigned char *)&ftrace_nop;
+}
+
+static int
+ftrace_modify_code(unsigned long ip, unsigned char *old_code,
+		   unsigned char *new_code)
+{
+	unsigned char replaced[MCOUNT_INSN_SIZE];
+
+	/* read the text we want to modify */
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* Make sure it is what we expect it to be */
+	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
+		return -EINVAL;
+
+	/* replace the text with the new text */
+	if (probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE))
+		return -EPERM;
+
+	flush_icache_range(ip, ip + 8);
+
+	return 0;
+}
+
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char *new, *old;
+
+	old = ftrace_call_replace(JAL, addr);
+	new = ftrace_nop_replace();
+
+	return ftrace_modify_code(rec->ip, old, new);
+}
+
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned char *new, *old;
+
+	old = ftrace_nop_replace();
+	new = ftrace_call_replace(JAL, addr);
+
+	return ftrace_modify_code(rec->ip, old, new);
+}
+
+int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+	unsigned long ip = (unsigned long)(&ftrace_call);
+	unsigned char old[MCOUNT_INSN_SIZE], *new;
+	int ret;
+
+	memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
+	new = ftrace_call_replace(JAL, (unsigned long)func);
+	ret = ftrace_modify_code(ip, old, new);
+
+	return ret;
+}
+
+int __init ftrace_dyn_arch_init(void *data)
+{
+	/* The return code is retured via data */
+	*(unsigned long *)data = 0;
+
+	return 0;
+}
+#endif				/* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index 82e54ab..30637e6 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -67,6 +67,35 @@
 	move ra, AT 
 	.endm
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+LEAF(_mcount)
+	RESTORE_SP_FOR_32BIT
+	RETURN_BACK
+	END(_mcount)
+
+NESTED(ftrace_caller, PT_SIZE, ra)
+	RESTORE_SP_FOR_32BIT
+	lw	t0, function_trace_stop
+	bnez	t0, ftrace_stub
+	nop
+
+	MCOUNT_SAVE_REGS
+
+	MCOUNT_SET_ARGS
+	.globl ftrace_call
+ftrace_call:
+	jal	ftrace_stub
+	nop
+
+	MCOUNT_RESTORE_REGS
+	.globl ftrace_stub
+ftrace_stub:
+	RETURN_BACK
+	END(ftrace_caller)
+
+#else	/* ! CONFIG_DYNAMIC_FTRACE */
+
 NESTED(_mcount, PT_SIZE, ra)
 	RESTORE_SP_FOR_32BIT
 	lw	t0, function_trace_stop
@@ -94,5 +123,7 @@ ftrace_stub:
 	RETURN_BACK
 	END(_mcount)
 
+#endif	/* ! CONFIG_DYNAMIC_FTRACE */
+
 	.set at
 	.set reorder
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index daee038..511c3a2 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -245,6 +245,28 @@ if ($arch eq "x86_64") {
     $ld .= " -m elf64_sparc";
     $cc .= " -m64";
     $objcopy .= " -O elf64-sparc";
+
+} elsif ($arch eq "mips") {
+	$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
+	$objdump .= " -Melf-trad".$endian."mips ";
+
+	if ($endian eq "big") {
+		$endian = " -EB ";
+		$ld .= " -melf".$bits."btsmip";
+	} else {
+		$endian = " -EL ";
+		$ld .= " -melf".$bits."ltsmip";
+	}
+
+	$cc .= " -mno-abicalls -fno-pic -mabi=" . $bits . $endian;
+	$ld .= $endian;
+
+    if ($bits == 64) {
+		$function_regex =
+			"^([0-9a-fA-F]+)\\s+<(.|[^\$]L.*?|\$[^L].*?|[^\$][^L].*?)>:";
+		$type = ".dword";
+    }
+
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
-- 
1.6.2.1

