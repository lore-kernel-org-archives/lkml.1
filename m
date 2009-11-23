Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbZKWJIi (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 23 Nov 2009 04:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbZKWJIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:08:35 -0500
Received: from gw.wifiinternet.cz ([89.31.42.6]:49967 "EHLO monstr.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756239AbZKWJId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:08:33 -0500
X-Greylist: delayed 1579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 04:08:12 EST
From: y@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: michal.simek@petalogix.com, wuzhangjin@gmail.com, mingo@elte.hu,
        rostedt@goodmis.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 3/5] microblaze: ftrace: Add dynamic trace support
Date: Mon, 23 Nov 2009 09:41:21 +0100
Message-Id: <1258965683-21302-4-git-send-email-y>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1258965683-21302-3-git-send-email-y>
References: <y>
 <1258965683-21302-1-git-send-email-y>
 <1258965683-21302-2-git-send-email-y>
 <1258965683-21302-3-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

With dynamic function tracer, by default, _mcount is defined as an
"empty" function, it returns directly without any more action. When
enabling it in user-space, it will jump to a real tracing
function(ftrace_caller), and do the real job for us.

Differ from the static function tracer, dynamic function tracer provides
two functions ftrace_make_call()/ftrace_make_nop() to enable/disable the
tracing of some indicated kernel functions(set_ftrace_filter).

In the kernel version, there is only one "_mcount" string for every
kernel function, so, we just need to match this one in mcount_regex of
scripts/recordmcount.pl.

For more information please look at code and Documentation/trace folder.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig              |    2 +
 arch/microblaze/include/asm/ftrace.h |   11 +++
 arch/microblaze/kernel/Makefile      |    2 +-
 arch/microblaze/kernel/ftrace.c      |  151 ++++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/mcount.S      |   13 +++
 scripts/recordmcount.pl              |    3 +
 6 files changed, 181 insertions(+), 1 deletions(-)
 create mode 100644 arch/microblaze/kernel/ftrace.c

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index cccf3ad..102d73a 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -8,6 +8,8 @@ config MICROBLAZE
 	select HAVE_LMB
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	select HAVE_DYNAMIC_FTRACE
+	select HAVE_FTRACE_MCOUNT_RECORD
 	select USB_ARCH_HAS_EHCI
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 
diff --git a/arch/microblaze/include/asm/ftrace.h b/arch/microblaze/include/asm/ftrace.h
index 22beec5..fd2fa2e 100644
--- a/arch/microblaze/include/asm/ftrace.h
+++ b/arch/microblaze/include/asm/ftrace.h
@@ -11,5 +11,16 @@ extern void _mcount(void);
 extern void ftrace_call_graph(void);
 #endif
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+/* reloction of mcount call site is the same as the address */
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	return addr;
+}
+
+struct dyn_arch_ftrace {
+};
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
 #endif /* CONFIG_FUNCTION_TRACER */
 #endif /* _ASM_MICROBLAZE_FTRACE */
diff --git a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
index d5ee326..b07594e 100644
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@ -27,6 +27,6 @@ obj-$(CONFIG_HEART_BEAT)	+= heartbeat.o
 obj-$(CONFIG_MODULES)		+= microblaze_ksyms.o module.o
 obj-$(CONFIG_MMU)		+= misc.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
-obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
+obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o mcount.o
 
 obj-y	+= entry$(MMU).o
diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
new file mode 100644
index 0000000..c1889b1
--- /dev/null
+++ b/arch/microblaze/kernel/ftrace.c
@@ -0,0 +1,151 @@
+/*
+ * Ftrace support for Microblaze.
+ *
+ * Copyright (C) 2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2009 PetaLogix
+ *
+ * Based on MIPS and PowerPC ftrace code
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <asm/cacheflush.h>
+#include <linux/ftrace.h>
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+/* save value to addr - it is save to do it in asm */
+static int ftrace_modify_code(unsigned long addr, unsigned int value)
+{
+	int faulted = 0;
+
+	__asm__ __volatile__("	1:	swi	%2, %1, 0;		\
+					addik	%0, r0, 0;		\
+				2:					\
+					.section .fixup, \"ax\";	\
+				3:	brid	2b;			\
+					addik	%0, r0, 1;		\
+					.previous;			\
+					.section __ex_table,\"a\";	\
+					.word	1b,3b;			\
+					.previous;"			\
+				: "=r" (faulted)
+				: "r" (addr), "r" (value)
+	);
+
+	if (unlikely(faulted))
+		return -EFAULT;
+
+	return 0;
+}
+
+#define MICROBLAZE_NOP 0x80000000
+#define MICROBLAZE_BRI 0xb800000C
+
+static unsigned int recorded; /* if save was or not */
+static unsigned int imm; /* saving whole imm instruction */
+
+/* There are two approaches howto solve ftrace_make nop function - look below */
+#undef USE_FTRACE_NOP
+
+#ifdef USE_FTRACE_NOP
+static unsigned int bralid; /* saving whole bralid instruction */
+#endif
+
+int ftrace_make_nop(struct module *mod,
+			struct dyn_ftrace *rec, unsigned long addr)
+{
+	/* we have this part of code which we are working with
+	 * b000c000        imm     -16384
+	 * b9fc8e30        bralid  r15, -29136     // c0008e30 <_mcount>
+	 * 80000000        or      r0, r0, r0
+	 *
+	 * The first solution (!USE_FTRACE_NOP-could be called branch solution)
+	 * b000c000        bri	12 (0xC - jump to any other instruction)
+	 * b9fc8e30        bralid  r15, -29136     // c0008e30 <_mcount>
+	 * 80000000        or      r0, r0, r0
+	 * any other instruction
+	 *
+	 * The second solution (USE_FTRACE_NOP) - no jump just nops
+	 * 80000000        or      r0, r0, r0
+	 * 80000000        or      r0, r0, r0
+	 * 80000000        or      r0, r0, r0
+	 */
+	int ret = 0;
+
+	if (recorded == 0) {
+		recorded = 1;
+		imm = *(unsigned int *)rec->ip;
+		pr_debug("%s: imm:0x%x\n", __func__, imm);
+#ifdef USE_FTRACE_NOP
+		bralid = *(unsigned int *)(rec->ip + 4);
+		pr_debug("%s: bralid 0x%x\n", __func__, bralid);
+#endif /* USE_FTRACE_NOP */
+	}
+
+#ifdef USE_FTRACE_NOP
+	ret = ftrace_modify_code(rec->ip, MICROBLAZE_NOP);
+	ret += ftrace_modify_code(rec->ip + 4, MICROBLAZE_NOP);
+#else /* USE_FTRACE_NOP */
+	ret = ftrace_modify_code(rec->ip, MICROBLAZE_BRI);
+#endif /* USE_FTRACE_NOP */
+	return ret;
+}
+
+static int ret_addr; /* initialized as 0 by default */
+
+/* I believe that first is called ftrace_make_nop before this function */
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	int ret;
+	ret_addr = addr; /* saving where the barrier jump is */
+	pr_debug("%s: addr:0x%x, rec->ip: 0x%x, imm:0x%x\n",
+		__func__, (unsigned int)addr, (unsigned int)rec->ip, imm);
+	ret = ftrace_modify_code(rec->ip, imm);
+#ifdef USE_FTRACE_NOP
+	pr_debug("%s: bralid:0x%x\n", __func__, bralid);
+	ret += ftrace_modify_code(rec->ip + 4, bralid);
+#endif /* USE_FTRACE_NOP */
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
+
+int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+	unsigned long ip = (unsigned long)(&ftrace_call);
+	unsigned int upper = (unsigned int)func;
+	unsigned int lower = (unsigned int)func;
+	int ret = 0;
+
+	/* create proper saving to ftrace_call poll */
+	upper = 0xb0000000 + (upper >> 16); /* imm func_upper */
+	lower = 0x32800000 + (lower & 0xFFFF); /* addik r20, r0, func_lower */
+
+	pr_debug("%s: func=0x%x, ip=0x%x, upper=0x%x, lower=0x%x\n",
+		__func__, (unsigned int)func, (unsigned int)ip, upper, lower);
+
+	/* save upper and lower code */
+	ret = ftrace_modify_code(ip, upper);
+	ret += ftrace_modify_code(ip + 4, lower);
+
+	/* We just need to remove the rtsd r15, 8 by NOP */
+	BUG_ON(!ret_addr);
+	if (ret_addr)
+		ret += ftrace_modify_code(ret_addr, MICROBLAZE_NOP);
+	else
+		ret = 1; /* fault */
+
+	/* All changes are done - lets do caches consistent */
+	flush_icache();
+	return ret;
+}
+
+#endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/microblaze/kernel/mcount.S b/arch/microblaze/kernel/mcount.S
index 97eef3e..30aaf8f 100644
--- a/arch/microblaze/kernel/mcount.S
+++ b/arch/microblaze/kernel/mcount.S
@@ -83,6 +83,12 @@ ENTRY(ftrace_stub)
 	nop;
 
 ENTRY(_mcount)
+#ifdef CONFIG_DYNAMIC_FTRACE
+ENTRY(ftrace_caller)
+	/* MS: It is just barrier which is removed from C code */
+	rtsd	r15, 8
+	nop
+#endif /* CONFIG_DYNAMIC_FTRACE */
 	SAVE_REGS
 	swi	r15, r1, 0;
 	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST begin of checking */
@@ -90,12 +96,19 @@ ENTRY(_mcount)
 	bneid	r5, end;
 	nop;
 	/* MS: HAVE_FUNCTION_TRACE_MCOUNT_TEST end of checking */
+#ifndef CONFIG_DYNAMIC_FTRACE
 	/* MS: test function trace if is taken or not */
 	lwi	r20, r0, ftrace_trace_function;
 	addik	r6, r0, ftrace_stub;
 	cmpu	r5, r20, r6; /* ftrace_trace_function != ftrace_stub */
 	beqid	r5, end; /* MS: not taken -> jump over */
 	nop;
+#else /* CONFIG_DYNAMIC_FTRACE */
+NOALIGN_ENTRY(ftrace_call)
+/* instruction for setup imm FUNC_part1, addik r20, r0, FUNC_part2 */
+	nop
+	nop
+#endif /* CONFIG_DYNAMIC_FTRACE */
 /* static normal trace */
 	lwi	r6, r1, 120; /* MS: load parent addr */
 	addik	r5, r15, 0; /* MS: load current function addr */
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 090d300..b30dabd 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -245,6 +245,9 @@ if ($arch eq "x86_64") {
     $ld .= " -m elf64_sparc";
     $cc .= " -m64";
     $objcopy .= " -O elf64-sparc";
+} elsif ($arch eq "microblaze") {
+    # Microblaze calls '_mcount' instead of plain 'mcount'.
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
-- 
1.5.5.1

