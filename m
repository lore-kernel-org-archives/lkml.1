Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbYKGRzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbYKGRzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 12:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYKGRzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 12:55:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:43133 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbYKGRzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 12:55:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=G/ef/+w8B0Iy620Yc8x4CvAtOiTfZLQEqGRPSuO66A0O2suvyjLxn3Dx4Tm400nSuy
         ds+liCFvr9t+sgk18kLgYs1UeI7MXBFRKOfrJS8valJ/puurS/vDikmS2sg4OCLyWYbK
         BI/ATT/M1itDQKNTMGC9ui1YBhJ7UGtQs1oIw=
Message-ID: <49148114.9040203@gmail.com>
Date: Fri, 07 Nov 2008 18:55:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC v2][PATCH 1/2] Add low level support for ftrace return tracing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add low level support for ftrace return tracing.
This plug-in hooks the function call on enter an then overwrite
their return address to a trampoline. A return handler will then
be able to catch some information such as the time the function returned.
Nmis are currently not supported and then the tracing is ignored when 
the watchdog is activated.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index fb62078..d21d708 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -15,6 +15,16 @@ CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
+ifdef CONFIG_FTRACE_RETURN
+CFLAGS_REMOVE_tsc.o = -pg
+CFLAGS_REMOVE_rtc.o = -pg
+CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_ftrace.o = -pg
+CFLAGS_REMOVE_early_printk.o = -pg
+endif
+
+
+
 #
 # vsyscalls (which work on the user stack) should have
 # no stack-protector checks:
@@ -67,6 +77,7 @@ obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_FTRACE_RETURN)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 9134de8..c2eb2c5 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1188,7 +1188,13 @@ ENTRY(mcount)
 
 	cmpl $ftrace_stub, ftrace_trace_function
 	jnz trace
+#ifdef CONFIG_FTRACE_RETURN
+	cmpl $ftrace_return_stub, ftrace_function_return
+	jnz trace_return
+#endif
 .globl ftrace_stub
+.globl ftrace_return_stub
+ftrace_return_stub:
 ftrace_stub:
 	ret
 
@@ -1206,7 +1212,23 @@ trace:
 	popl %edx
 	popl %ecx
 	popl %eax
+	jmp ftrace_stub
 
+#ifdef CONFIG_FTRACE_RETURN
+trace_return:
+	pushl %eax
+	pushl %ecx
+	pushl %edx
+	movl 0xc(%esp), %eax
+	pushl %eax
+	lea 0x4(%ebp), %eax
+	pushl %eax
+	call prepare_ftrace_return
+	addl $8, %esp
+	popl %edx
+	popl %ecx
+	popl %eax
+#endif
 	jmp ftrace_stub
 END(mcount)
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 6914933..2bdd11d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -18,29 +18,236 @@
 #include <linux/list.h>
 
 #include <asm/ftrace.h>
+#include <linux/ftrace.h>
 #include <asm/nops.h>
+#include <asm/nmi.h>
 
 
-static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
+static int ftrace_calc_offset(long ip, long addr)
+{
+	return (int)(addr - ip);
+}
 
-union ftrace_code_union {
-	char code[MCOUNT_INSN_SIZE];
+#ifdef CONFIG_FTRACE_RETURN
+#define FTRACE_TRAMPOLINE_SIZE 32
+
+struct ftrace_return_data {
+	/* Bitmap which defines free slots in func table */
+	unsigned long bitmap;
+	raw_spinlock_t bitmap_lock;
+	union ftrace_return_code_union *trampoline;
+	struct ftrace_retfunc *func_table;
+	unsigned long overrun;
+};
+
+static struct ftrace_return_data ftrace_return_state;
+
+/*
+ * On each slot of this trampoline we have
+ * push $index
+ * call ftrace_return_to_handler
+ * Index is the place in the func table where
+ * are stored the information for the current
+ * call frame.
+ */
+union ftrace_return_code_union {
+	char code[MCOUNT_INSN_SIZE + 2];
 	struct {
-		char e8;
+		char push; /* push imm8 */
+		char index; /* index on the trampoline/func table */
+		char e8; /* call to the return handler */
 		int offset;
 	} __attribute__((packed));
 };
 
 
-static int ftrace_calc_offset(long ip, long addr)
+void ftrace_call_replace(char index, unsigned long ip, unsigned long addr,
+			 union ftrace_return_code_union *calc)
 {
-	return (int)(addr - ip);
+	calc->push		= 0x6a;
+	calc->index		= index;
+	calc->e8		= 0xe8;
+	calc->offset	= ftrace_calc_offset(ip + 2 + MCOUNT_INSN_SIZE, addr);
+
 }
 
-unsigned char *ftrace_nop_replace(void)
+asmlinkage
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 {
-	return ftrace_nop;
+	unsigned long flags;
+	int index;
+	unsigned long old, trampoline;
+	int faulted;
+
+	/* Nmi's are currently unsupported */
+	if (atomic_read(&nmi_active))
+		return;
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&ftrace_return_state.bitmap_lock);
+	if (!ftrace_return_state.bitmap) {
+		__raw_spin_unlock(&ftrace_return_state.bitmap_lock);
+		raw_local_irq_restore(flags);
+		return;
+	}
+	/* Find next free slot and reserve */
+	index = ffs(ftrace_return_state.bitmap) - 1;
+	clear_bit(index, &ftrace_return_state.bitmap);
+
+	__raw_spin_unlock(&ftrace_return_state.bitmap_lock);
+	raw_local_irq_restore(flags);
+	ftrace_return_state.func_table[index].func = self_addr;
+
+	trampoline = (unsigned long)&ftrace_return_state.trampoline[index];
+
+	/*
+	 * Protect against fault, even if it shouldn't
+	 * happen. This tool is too much intrusive to
+	 * ignore such a protection.
+	 */
+	asm volatile(
+		"1: movl (%3), %1\n"
+		"2: movl %4, (%0)\n"
+		"   movl $0, %2\n"
+
+		".section .fixup, \"ax\"\n"
+		"3: movl $1, %2\n"
+		".previous\n"
+
+		".section __ex_table, \"a\"\n"
+		"   .long 1b, 3b\n"
+		"   .long 2b, 3b\n"
+		".previous\n"
+
+		: "=rm" (parent), "=r" (old), "=r" (faulted)
+		: "0" (parent), "r" (trampoline)
+		: "memory"
+	);
+
+	if (faulted) {
+		set_bit(index, &ftrace_return_state.bitmap);
+		return;
+	}
+
+	if (!__kernel_text_address(old)) {
+		set_bit(index, &ftrace_return_state.bitmap);
+		*parent = old;
+		return;
+	}
+
+
+	ftrace_return_state.func_table[index].ret = old;
+	ftrace_return_state.func_table[index].calltime =
+				cpu_clock(raw_smp_processor_id());
+}
+
+/*
+ * No caller of this function is really aware it is calling it since
+ * it is a hooker called through a trampoline which passes the offset
+ * of the function in the func table through the stack. So we have to
+ * clean the stack ourself. Hence the stdcall.
+ * We want to be sure our offset pushed on the stack will not be assumed
+ * to be transmitted through a register => asmlinkage.
+ */
+__attribute__((stdcall)) asmlinkage static
+unsigned long ftrace_return_to_handler(int index)
+{
+	struct ftrace_retfunc *table;
+	unsigned long ret;
+	unsigned long eax, edx;
+
+	/*
+	 * The function we are hooking on return could have
+	 * a return value. Just keep the value of eax and return
+	 * it in the end. We keep edx too for 64 bits return
+	 * values.
+	 */
+
+	asm volatile(
+		"movl %%eax, %0\n"
+		"movl %%edx, %1\n"
+		: "=r" (eax), "=r" (edx)
+		: : "memory"
+	);
+
+	table = &ftrace_return_state.func_table[index];
+	ret = table->ret;
+	table->rettime = cpu_clock(raw_smp_processor_id());
+	ftrace_function_return(table);
+
+	set_bit(index, &ftrace_return_state.bitmap);
+
+	/* Put the original return address of the hooked function as our
+	 * return address and restore the return values.
+	 */
+	asm volatile (
+		"movl %0, 4(%%ebp)\n"
+		"movl %1, %%edx\n"
+		: : "r" (ret), "r" (edx)
+		: "memory"
+	);
+
+	return eax;
+}
+
+/*
+ * Set the trampoline.
+ * See union ftrace_return_code_union.
+ */
+static void __init fill_trampoline(void)
+{
+	union ftrace_return_code_union tramp_code;
+	int i;
+	unsigned long ip;
+
+	for (i = 0; i < FTRACE_TRAMPOLINE_SIZE; i++) {
+		ip = (unsigned long)&ftrace_return_state.trampoline[i];
+		ftrace_call_replace((char)i, ip,
+				    (unsigned long)&ftrace_return_to_handler,
+				    &tramp_code);
+		memcpy(&ftrace_return_state.trampoline[i],
+		       &tramp_code, sizeof(union ftrace_return_code_union));
+	}
+}
+
+static int __init init_ftrace_function_return(void)
+{
+	ftrace_return_state.bitmap_lock =
+				(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	ftrace_return_state.trampoline = kmalloc(
+				 sizeof(union ftrace_return_code_union)	*
+				 FTRACE_TRAMPOLINE_SIZE,
+				 GFP_KERNEL);
+	if (!ftrace_return_state.trampoline)
+		return -ENOMEM;
+
+	fill_trampoline();
+	/* Allocate 32 slots */
+	ftrace_return_state.bitmap = ~0;
+	ftrace_return_state.func_table = kmalloc(FTRACE_TRAMPOLINE_SIZE *
+					 sizeof(struct ftrace_retfunc),
+					 GFP_KERNEL);
+	if (!ftrace_return_state.func_table) {
+		kfree(ftrace_return_state.trampoline);
+		return -ENOMEM;
+	}
+	ftrace_return_state.overrun = 0;
+	return 0;
 }
+device_initcall(init_ftrace_function_return);
+
+
+#endif
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+union ftrace_code_union {
+	char code[MCOUNT_INSN_SIZE];
+	struct {
+		char e8;
+		int offset;
+	} __attribute__((packed));
+};
 
 unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
@@ -183,6 +390,15 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 }
 
 
+
+
+static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
+
+unsigned char *ftrace_nop_replace(void)
+{
+	return ftrace_nop;
+}
+
 int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
@@ -292,3 +508,4 @@ int __init ftrace_dyn_arch_init(void *data)
 
 	return 0;
 }
+#endif
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 1f5608c..41760d9 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -267,6 +267,22 @@ ftrace_init_module(unsigned long *start, unsigned long *end) { }
 #endif
 
 
+#ifdef CONFIG_FTRACE_RETURN
+struct ftrace_retfunc {
+	unsigned long ret;
+	unsigned long func;
+	unsigned long long calltime;
+	unsigned long long rettime;
+};
+
+extern atomic_t disable_return;
+
+extern void ftrace_return_stub(struct ftrace_retfunc *);
+extern void register_ftrace_return(void (*func)(struct ftrace_retfunc *));
+extern void (*ftrace_function_return)(struct ftrace_retfunc *);
+extern void unregister_ftrace_return(void);
+#endif
+
 /*
  * Structure which defines the trace of an initcall.
  * You don't have to fill the func field since it is
diff --git a/kernel/extable.c b/kernel/extable.c
index adf0cc9..5caa856 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -40,7 +40,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 	return e;
 }
 
-int core_kernel_text(unsigned long addr)
+notrace int core_kernel_text(unsigned long addr)
 {
 	if (addr >= (unsigned long)_stext &&
 	    addr <= (unsigned long)_etext)
@@ -53,7 +53,7 @@ int core_kernel_text(unsigned long addr)
 	return 0;
 }
 
-int __kernel_text_address(unsigned long addr)
+notrace int __kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
 		return 1;
diff --git a/kernel/module.c b/kernel/module.c
index 48c323c..23bedc5 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2714,7 +2714,7 @@ int is_module_address(unsigned long addr)
 
 
 /* Is this a valid kernel address? */
-struct module *__module_text_address(unsigned long addr)
+notrace struct module *__module_text_address(unsigned long addr)
 {
 	struct module *mod;
 
