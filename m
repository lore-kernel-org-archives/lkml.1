Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZKIPcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZKIPcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbZKIPcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:32:35 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39623 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbZKIPcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:32:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OKlnfcWUUO6NXvY8bQlrQtKjYBktgmaqvVBwXa60Qtn/M2dXJdr9U7Y7aaoShWcO0x
         uKc68ue9JnqiDX3SWHEogkjA869S5K0rfwmaiaKObjGoinKIjMIN/tBcUHr7T0HIXGD8
         6EAvVyWC/QSCORGSBSYKpcfUnucA8/KTVcAKQ=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: zhangfx@lemote.com, zhouqg@gmail.com, Wu Zhangjin <wuzhangjin@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>, Wu Zhangjin <wuzj@lemote.com>
Subject: [PATCH v7 07/17] tracing: add dynamic function tracer support for MIPS
Date: Mon,  9 Nov 2009 23:31:24 +0800
Message-Id: <3a9fc9ca02e8e6e9c3c28797a4c084c1f9d91f69.1257779502.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <58a7558730fbea6cd0417100c8fcd6f45668d1e3.1257779502.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
 <6199d7b3956b544fc65896af1062787a2e1283ce.1257779502.git.wuzhangjin@gmail.com>
 <58a7558730fbea6cd0417100c8fcd6f45668d1e3.1257779502.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1257779502.git.wuzhangjin@gmail.com>
References: <cover.1257779502.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

With dynamic function tracer, by default, _mcount is defined as an
"empty" function, it just return without any more action, just like the
static function tracer does. When enabling it in user-space, it will
jump to a real tracing function(ftrace_caller), and do some real job for
us.

Differ from the static function tracer, dynamic function tracer provides
two functions ftrace_make_call()/ftrace_make_nop() to enable/disable the
tracing of some indicated kernel functions(set_ftrace_filter).

In the -v4 version, the implementation of this support is basically the same as
X86 version does: _mcount is implemented as an empty function and ftrace_caller
is implemented as a real tracing function respectively.

But in this version, to support module tracing with the help of
-mlong-calls. the stuff becomes a little more complex, let's have a look
at the new calling to _mcount with -mlong-calls(result of "objdump -hdr
vmlinux").

	c:	3c030000 	lui	v1,0x0
			c: R_MIPS_HI16	_mcount
			c: R_MIPS_NONE	*ABS*
			c: R_MIPS_NONE	*ABS*
	10:	64630000 	daddiu	v1,v1,0
			10: R_MIPS_LO16	_mcount
			10: R_MIPS_NONE	*ABS*
			10: R_MIPS_NONE	*ABS*
	14:	03e0082d 	move	at,ra
	18:	0060f809 	jalr	v1

and the old version without -mlong-calls looks like this:

	108:   03e0082d        move    at,ra
	10c:   0c000000        jal     0 <fpcsr_pending>
                        10c: R_MIPS_26  _mcount
                        10c: R_MIPS_NONE        *ABS*
                        10c: R_MIPS_NONE        *ABS*
	110:   00020021        nop

In the old version, there is only one "_mcount" string for every kernel
function, so, we just need to match this one in mcount_regex of
scripts/recordmcount.pl, but in the new version, we need to choose one
of the two to match. Herein, I choose the first one with "R_MIPS_HI16
_mcount".

and In the old verion, without module tracing support, we just need to replace
"jal _mcount" by "jal ftrace_caller" to do real tracing, and filter the tracing
of some kernel functions via replacing it by a nop instruction.

but as we have described before, the instruction "jal ftrace_caller" only left
32bit length for the address of ftrace_caller, it will fail when calling from
the module space. so, herein, we must replace something else.

the basic idea is loading the address of ftrace_caller to v1 via changing these
two instructions:

	lui	v1,0x0
	addiu	v1,v1,0

If we want to enable the tracing, we need to replace the above instructions to:

	lui	v1, HI_16BIT_ftrace_caller
	addiu	v1, v1, LOW_16BIT_ftrace_caller

If we want to stop the tracing of the indicated kernel functions, we
just need to replace the "jalr v1" to a nop instruction. but we need to
replace two instructions and encode the above two instructions
oursevles.

Is there a simpler solution, Yes! Here it is, in this version, we put _mcount
and ftrace_caller together, which means the address of _mcount and
ftrace_caller is the same:

_mcount:
ftrace_caller:
	j	ftrace_stub
	 nop

	...(do real tracing here)...

ftrace_stub:
	jr	ra
	 move	ra, at

By default, the kernel functions call _mcount, and then jump to ftrace_stub and
return. and when we want to do real tracing, we just need to remove that "j
ftrace_stub", and it will run through the two "nop" instructions and then do
the real tracing job.

what about filtering job? we just need to do this:

	 lui v1, hi_16bit_of_mcount        <--> b 1f (0x10000004)
	 addiu v1, v1, low_16bit_of_mcount
	 move at, ra
	 jalr v1
	 nop
	 				     1f: (rec->ip + 12)

In linux-mips64, there will be some local symbols, whose name are
prefixed by $L, which need to be filtered. thanks goes to Steven for
writing the mips64-specific function_regex.

In a conclusion, with RISC, things becomes easier with such a "stupid"
trick, RISC is something like K.I.S.S, and also, there are lots of
"simple" tricks in the whole ftrace support, thanks goes to Steven and
the other folks for providing such a wonderful tracing framework!

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/Kconfig              |    2 +
 arch/mips/include/asm/ftrace.h |    9 ++++
 arch/mips/kernel/Makefile      |    3 +-
 arch/mips/kernel/ftrace.c      |   89 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mcount.S      |   29 +++++++++++++
 scripts/recordmcount.pl        |   41 ++++++++++++++++++
 6 files changed, 172 insertions(+), 1 deletions(-)
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
index 5f8ebcf..7094a40 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -19,6 +19,15 @@
 extern void _mcount(void);
 #define mcount _mcount
 
+#ifdef CONFIG_DYNAMIC_FTRACE
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
index 0000000..ac6647e
--- /dev/null
+++ b/arch/mips/kernel/ftrace.c
@@ -0,0 +1,89 @@
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
+#define jump_insn_encode(op_code, addr) \
+	((unsigned int)((op_code) | (((addr) >> 2) & ADDR_MASK)))
+
+#ifdef CONFIG_CPU_LOONGSON2F
+static unsigned int ftrace_nop = 0x00020021;
+#else
+static unsigned int ftrace_nop = 0x00000000;
+#endif
+
+static int ftrace_modify_code(unsigned long ip, unsigned int new_code)
+{
+	*(unsigned int *)ip = new_code;
+
+	flush_icache_range(ip, ip + 8);
+
+	return 0;
+}
+
+static int lui_v1;
+
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
+	/* record it for ftrace_make_call */
+	if (lui_v1 == 0)
+		lui_v1 = *(unsigned int *)rec->ip;
+
+	/* lui v1, hi_16bit_of_mcount        --> b 1f (0x10000004)
+	 * addiu v1, v1, low_16bit_of_mcount
+	 * move at, ra
+	 * jalr v1
+	 * nop
+	 * 				     1f: (rec->ip + 12)
+	 */
+	return ftrace_modify_code(rec->ip, 0x10000004);
+}
+
+static int modified;	/* initialized as 0 by default */
+
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	/* We just need to remove the "b ftrace_stub" at the fist time! */
+	if (modified == 0) {
+		modified = 1;
+		ftrace_modify_code(addr, ftrace_nop);
+	}
+	/* ftrace_make_nop have recorded lui_v1 for us */
+	return ftrace_modify_code(rec->ip, lui_v1);
+}
+
+#define FTRACE_CALL_IP ((unsigned long)(&ftrace_call))
+
+int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+	unsigned int new;
+
+	new = jump_insn_encode(JAL, (unsigned long)func);
+
+	return ftrace_modify_code(FTRACE_CALL_IP, new);
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
index cbb45ed..ffc4259 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -58,6 +58,33 @@
 	 move ra, AT
 	.endm
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+NESTED(ftrace_caller, PT_SIZE, ra)
+	.globl _mcount
+_mcount:
+	b	ftrace_stub
+	 nop
+	lw	t0, function_trace_stop
+	bnez	t0, ftrace_stub
+	 nop
+
+	MCOUNT_SAVE_REGS
+
+	move	a0, ra		/* arg1: next ip, selfaddr */
+	.globl ftrace_call
+ftrace_call:
+	nop	/* a placeholder for the call to a real tracing function */
+	 move	a1, AT		/* arg2: the caller's next ip, parent */
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
 	lw	t0, function_trace_stop
 	bnez	t0, ftrace_stub
@@ -82,5 +109,7 @@ ftrace_stub:
 	RETURN_BACK
 	END(_mcount)
 
+#endif	/* ! CONFIG_DYNAMIC_FTRACE */
+
 	.set at
 	.set reorder
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 62a0001..11ac245 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -287,6 +287,47 @@ if ($arch eq "x86_64") {
     $ld .= " -m elf64_sparc";
     $cc .= " -m64";
     $objcopy .= " -O elf64-sparc";
+
+} elsif ($arch eq "mips") {
+    # To enable module support, we need to enable the -mlong-calls option
+    # of gcc for MIPS, after using this option, we can not get the real
+    # offset of the calling to _mcount, but the offset of the lui
+    # instruction or the addiu one. herein, we record the address of the
+    # first one, and then we can replace this instruction by a branch
+    # instruction to jump over the profiling function to filter the
+    # indicated functions, or swith back to the lui instruction to trace
+    # them, which means dynamic tracing.
+    #
+    #       c:	3c030000 	lui	v1,0x0
+    #			c: R_MIPS_HI16	_mcount
+    #			c: R_MIPS_NONE	*ABS*
+    #			c: R_MIPS_NONE	*ABS*
+    #      10:	64630000 	daddiu	v1,v1,0
+    #			10: R_MIPS_LO16	_mcount
+    #			10: R_MIPS_NONE	*ABS*
+    #			10: R_MIPS_NONE	*ABS*
+    #      14:	03e0082d 	move	at,ra
+    #      18:	0060f809 	jalr	v1
+    $mcount_regex = "^\\s*([0-9a-fA-F]+): R_MIPS_HI16\\s+_mcount\$";
+    $objdump .= " -Melf-trad".$endian."mips ";
+
+    if ($endian eq "big") {
+	    $endian = " -EB ";
+	    $ld .= " -melf".$bits."btsmip";
+    } else {
+	    $endian = " -EL ";
+	    $ld .= " -melf".$bits."ltsmip";
+    }
+
+    $cc .= " -mno-abicalls -fno-pic -mabi=" . $bits . $endian;
+    $ld .= $endian;
+
+    if ($bits == 64) {
+	    $function_regex =
+		"^([0-9a-fA-F]+)\\s+<(.|[^\$]L.*?|\$[^L].*?|[^\$][^L].*?)>:";
+	    $type = ".dword";
+    }
+
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
-- 
1.6.2.1

