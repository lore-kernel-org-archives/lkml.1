Return-Path: <linux-kernel-owner+w=401wt.eu-S1762322AbZFNPw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762322AbZFNPw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762311AbZFNPws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:52:48 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:46382 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbZFNPwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HS1HnZVzAGtFErExdcs4x9QhnLc7JgEfrTWeUfiUR/0qco1RgQ1vuIliSfUiz7bp+F
         vpL0MxpmvYhczaYrIyhueN7hqMVuTYxupS9xg4w65XSlIB4A0UvT1Rird1krGoOInMC3
         AO7F8o6B4C+2J3c923kIusN9RWj4NESVjyiBo=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wang Liming <liming.wang@windriver.com>, Wu Zhangjin <wuzj@lemote.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v3] mips dynamic function tracer support
Date: Sun, 14 Jun 2009 23:52:39 +0800
Message-Id: <46cdb2d6a53dc89e4f0587593961f48e3496f147.1244994151.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1244994151.git.wuzj@lemote.com>
References: <cover.1244994151.git.wuzj@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

dynamic function tracer need to replace "nop" to "jumps & links" and
something reversely.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/Kconfig              |    3 +
 arch/mips/include/asm/ftrace.h |   10 ++
 arch/mips/kernel/Makefile      |    2 +
 arch/mips/kernel/ftrace.c      |  207 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mcount.S      |   31 ++++++
 scripts/recordmcount.pl        |   20 ++++
 6 files changed, 273 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/kernel/ftrace.c

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 2e2fdbe..0857239 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -6,6 +6,9 @@ config MIPS
 	select HAVE_ARCH_KGDB
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	select HAVE_DYNAMIC_FTRACE
+	select HAVE_FTRACE_MCOUNT_RECORD
+	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
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
index 559a820..8dabcc6 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -10,6 +10,7 @@ obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 
 ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
+CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
@@ -30,6 +31,7 @@ obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
 
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
+obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o
 
 obj-$(CONFIG_CPU_LOONGSON2)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_MIPS32)	+= r4k_fpu.o r4k_switch.o
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
new file mode 100644
index 0000000..ad490cc
--- /dev/null
+++ b/arch/mips/kernel/ftrace.c
@@ -0,0 +1,207 @@
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
+#include <linux/spinlock.h>
+#include <linux/hardirq.h>
+#include <linux/uaccess.h>
+#include <linux/percpu.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/ftrace.h>
+
+#include <asm/cacheflush.h>
+#include <asm/ftrace.h>
+#include <asm/asm.h>
+#include <asm/unistd.h>
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+#define JAL 0x0c000000	/* jump & link: ip --> ra, jump to target */
+#define ADDR_MASK 0x03ffffff	/*  op_code|addr : 31...26|25 ....0 */
+
+static unsigned int ftrace_nop = 0x00000000;
+
+static unsigned char *ftrace_call_replace(unsigned long op_code,
+					  unsigned long addr)
+{
+    static unsigned int op;
+
+    op = op_code | ((addr >> 2) & ADDR_MASK);
+
+    return (unsigned char *) &op;
+}
+
+static atomic_t nmi_running = ATOMIC_INIT(0);
+static int mod_code_status;	/* holds return value of text write */
+static int mod_code_write;	/* set when NMI should do the write */
+static void *mod_code_ip;	/* holds the IP to write to */
+static void *mod_code_newcode;	/* holds the text to write to the IP */
+
+static unsigned nmi_wait_count;
+static atomic_t nmi_update_count = ATOMIC_INIT(0);
+
+int ftrace_arch_read_dyn_info(char *buf, int size)
+{
+    int r;
+
+    r = snprintf(buf, size, "%u %u",
+		 nmi_wait_count, atomic_read(&nmi_update_count));
+    return r;
+}
+
+static void ftrace_mod_code(void)
+{
+    /*
+     * Yes, more than one CPU process can be writing to mod_code_status.
+     *    (and the code itself)
+     * But if one were to fail, then they all should, and if one were
+     * to succeed, then they all should.
+     */
+    mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
+					 MCOUNT_INSN_SIZE);
+
+    /* if we fail, then kill any new writers */
+    if (mod_code_status)
+		mod_code_write = 0;
+}
+
+void ftrace_nmi_enter(void)
+{
+    atomic_inc(&nmi_running);
+    /* Must have nmi_running seen before reading write flag */
+    smp_mb();
+    if (mod_code_write) {
+		ftrace_mod_code();
+		atomic_inc(&nmi_update_count);
+    }
+}
+
+void ftrace_nmi_exit(void)
+{
+    /* Finish all executions before clearing nmi_running */
+    smp_wmb();
+    atomic_dec(&nmi_running);
+}
+
+static void wait_for_nmi(void)
+{
+    int waited = 0;
+
+    while (atomic_read(&nmi_running)) {
+		waited = 1;
+		cpu_relax();
+    }
+
+    if (waited)
+		nmi_wait_count++;
+}
+
+static int do_ftrace_mod_code(unsigned long ip, void *new_code)
+{
+    mod_code_ip = (void *) ip;
+    mod_code_newcode = new_code;
+
+    /* The buffers need to be visible before we let NMIs write them */
+    smp_wmb();
+
+    mod_code_write = 1;
+
+    /* Make sure write bit is visible before we wait on NMIs */
+    smp_mb();
+
+    wait_for_nmi();
+
+    /* Make sure all running NMIs have finished before we write the code */
+    smp_mb();
+
+    ftrace_mod_code();
+
+    /* Make sure the write happens before clearing the bit */
+    smp_wmb();
+
+    mod_code_write = 0;
+
+    /* make sure NMIs see the cleared bit */
+    smp_mb();
+
+    wait_for_nmi();
+
+    return mod_code_status;
+}
+
+static unsigned char *ftrace_nop_replace(void)
+{
+    return (unsigned char *) &ftrace_nop;
+}
+
+static int
+ftrace_modify_code(unsigned long ip, unsigned char *old_code,
+		   unsigned char *new_code)
+{
+    unsigned char replaced[MCOUNT_INSN_SIZE];
+
+    /* read the text we want to modify */
+    if (probe_kernel_read(replaced, (void *) ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+    /* Make sure it is what we expect it to be */
+    if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
+		return -EINVAL;
+
+    /* replace the text with the new text */
+    if (do_ftrace_mod_code(ip, new_code))
+		return -EPERM;
+
+    return 0;
+}
+
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
+    unsigned char *new, *old;
+
+    old = ftrace_call_replace(JAL, addr);
+    new = ftrace_nop_replace();
+
+    return ftrace_modify_code(rec->ip, old, new);
+}
+
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+    unsigned char *new, *old;
+
+    old = ftrace_nop_replace();
+    new = ftrace_call_replace(JAL, addr);
+
+    return ftrace_modify_code(rec->ip, old, new);
+}
+
+int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+    unsigned long ip = (unsigned long) (&ftrace_call);
+    unsigned char old[MCOUNT_INSN_SIZE], *new;
+    int ret;
+
+    memcpy(old, &ftrace_call, MCOUNT_INSN_SIZE);
+    new = ftrace_call_replace(JAL, (unsigned long) func);
+    ret = ftrace_modify_code(ip, old, new);
+
+    return ret;
+}
+
+int __init ftrace_dyn_arch_init(void *data)
+{
+    /* The return code is retured via data */
+    *(unsigned long *) data = 0;
+
+    return 0;
+}
+#endif				/* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index 268724e..723ace2 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -67,6 +67,35 @@
 	move ra, $1
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
 	PTR_L	t0, function_trace_stop
@@ -94,5 +123,7 @@ ftrace_stub:
 	RETURN_BACK
 	END(_mcount)
 
+#endif	/* ! CONFIG_DYNAMIC_FTRACE */
+
 	.set at
 	.set reorder
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index f1e3e9c..533d3bf 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -213,6 +213,26 @@ if ($arch eq "x86_64") {
     if ($is_module eq "0") {
         $cc .= " -mconstant-gp";
     }
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
+		$type = ".dword";
+    }
+
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
-- 
1.6.0.4

