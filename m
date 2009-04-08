Return-Path: <linux-kernel-owner+w=401wt.eu-S1763479AbZDHHch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763479AbZDHHch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762790AbZDHHcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:32:08 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:38483 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761105AbZDHHcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:32:04 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Arnd Bergmann <arnd@arndb.de>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Kyle McMartin <kyle@mcmartin.ca>
MIME-Version: 1.0
Subject: [PATCH 11/14] score - New architecure port to SunplusCT S+CORE
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF59471ADD.3D343341-ON48257592.002912F7-48257592.00295402@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 8 Apr 2009 15:29:18 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/04/08 ?? 03:29:17,
	Serialize complete at 2009/04/08 ?? 03:29:17
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n387Xvqu027120

From: Chen Liqin <liqin.chen@sunplusct.com>

kernel/traps.c and kernel/vmlinux.lds.S
for the score architecture.

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
Signed off by: Lennox Wu <lennox.wu@sunplusct.com>
--

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/traps.c 
linux-2.6-git.new/arch/score/kernel/traps.c
--- linux-2.6-git.ori/arch/score/kernel/traps.c 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/traps.c 2009-04-07 
21:48:34.000000000 +0800
@@ -0,0 +1,349 @@
+/*
+ * arch/score/kernel/traps.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <asm/cacheflush.h>
+#include <asm/ptrace.h>
+#include <asm/setup.h>
+#include <asm/irq.h>
+#include <asm/irq_regs.h>
+
+unsigned long exception_handlers[32];
+
+/*
+ * The architecture-independent show_stack generator
+ */
+void show_stack(struct task_struct *task, unsigned long *sp)
+{
+       int i;
+       long stackdata;
+
+       sp = sp ? sp : (unsigned long *)&sp;
+
+       printk("Stack:   ");
+       i = 1;
+       while ((long) sp & (PAGE_SIZE - 1)) {
+               if (i && ((i % 8) == 0))
+                       printk("\n");
+               if (i > 40) {
+                       printk(" ...");
+                       break;
+               }
+
+               if (__get_user(stackdata, sp++)) {
+                       printk(" (Bad stack address)");
+                       break;
+               }
+
+               printk(" %08lx", stackdata);
+               i++;
+       }
+       printk("\n");
+}
+
+static void show_trace(long *sp)
+{
+       int i;
+       long addr;
+
+       sp = sp ? sp : (long *) &sp;
+
+       printk("Call Trace:  ");
+       i = 1;
+       while ((long) sp & (PAGE_SIZE - 1)) {
+               if (__get_user(addr, sp++)) {
+                       if (i && ((i % 6) == 0))
+                               printk("\n");
+                       printk(" (Bad stack address)\n");
+                       break;
+               }
+
+               if (kernel_text_address(addr)) {
+                       if (i && ((i % 6) == 0))
+                               printk("\n");
+                       if (i > 40) {
+                               printk(" ...");
+                               break;
+                       }
+
+                       printk(" [<%08lx>]", addr);
+                       i++;
+               }
+       }
+       printk("\n");
+}
+
+static void show_code(unsigned int *pc)
+{
+       long i;
+
+       printk("\nCode:");
+
+       for (i = -3; i < 6; i++) {
+               unsigned long insn;
+               if (__get_user(insn, pc + i)) {
+                       printk(" (Bad address in epc)\n");
+                       break;
+               }
+               printk("%c%08lx%c", (i ? ' ' : '<'), insn, (i ? ' ' : 
'>'));
+       }
+}
+
+/*
+ * FIXME: really the generic show_regs should take a const pointer 
argument.
+ */
+void show_regs(struct pt_regs *regs)
+{
+       printk("r0 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
+               regs->regs[0], regs->regs[1], regs->regs[2], 
regs->regs[3],
+               regs->regs[4], regs->regs[5], regs->regs[6], 
regs->regs[7]);
+       printk("r8 : %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
+               regs->regs[8], regs->regs[9], regs->regs[10], 
regs->regs[11],
+               regs->regs[12], regs->regs[13], regs->regs[14], 
regs->regs[15]);
+       printk("r16: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
+               regs->regs[16], regs->regs[17], regs->regs[18], 
regs->regs[19],
+               regs->regs[20], regs->regs[21], regs->regs[22], 
regs->regs[23]);
+       printk("r24: %08lx %08lx %08lx %08lx %08lx %08lx %08lx %08lx\n",
+               regs->regs[24], regs->regs[25], regs->regs[26], 
regs->regs[27],
+               regs->regs[28], regs->regs[29], regs->regs[30], 
regs->regs[31]);
+
+       printk("CEH : %08lx\n", regs->ceh);
+       printk("CEL : %08lx\n", regs->cel);
+
+       printk("EMA:%08lx, epc:%08lx  %s\nPSR: %08lx\nECR:%08lx\nCondition 
: %08lx\n",
+               regs->cp0_ema, regs->cp0_epc, print_tainted(), 
regs->cp0_psr,
+               regs->cp0_ecr, regs->cp0_condition);
+}
+
+static void show_registers(struct pt_regs *regs)
+{
+       show_regs(regs);
+       printk("Process %s (pid: %d, stackpage=%08lx)\n",
+               current->comm, current->pid, (unsigned long) current);
+       show_stack(current_thread_info()->task, (long *) regs->regs[0]);
+       show_trace((long *) regs->regs[0]);
+       show_code((unsigned int *) regs->cp0_epc);
+       printk("\n");
+}
+
+/*
+ * The architecture-independent dump_stack generator
+ */
+void dump_stack(void)
+{
+       show_stack(current_thread_info()->task,
+                  (long *) get_irq_regs()->regs[0]);
+}
+EXPORT_SYMBOL(dump_stack);
+
+void __die(const char *str, struct pt_regs *regs, const char *file,
+          const char *func, unsigned long line)
+{
+       console_verbose();
+       printk("%s", str);
+       if (file && func)
+               printk(" in %s:%s, line %ld", file, func, line);
+       printk(":\n");
+       show_registers(regs);
+       do_exit(SIGSEGV);
+}
+
+void __die_if_kernel(const char *str, struct pt_regs *regs,
+                    const char *file, const char *func, unsigned long 
line)
+{
+       if (!user_mode(regs))
+               __die(str, regs, file, func, line);
+}
+
+asmlinkage void do_adelinsn(struct pt_regs *regs)
+{
+       printk("do_ADE-linsn:ema:0x%08lx:epc:0x%08lx\n",
+                regs->cp0_ema, regs->cp0_epc);
+       die_if_kernel("do_ade execution Exception\n", regs);
+       force_sig(SIGBUS, current);
+}
+
+asmlinkage void do_adedata(struct pt_regs *regs)
+{
+       const struct exception_table_entry *fixup;
+       fixup = search_exception_tables(regs->cp0_epc);
+       if (fixup) {
+               regs->cp0_epc = fixup->nextinsn;
+               return;
+       }
+       printk("do_ADE-data:ema:0x%08lx:epc:0x%08lx\n",
+                regs->cp0_ema, regs->cp0_epc);
+       die_if_kernel("do_ade execution Exception\n", regs);
+       force_sig(SIGBUS, current);
+}
+
+asmlinkage void do_pel(struct pt_regs *regs)
+{
+       die_if_kernel("do_pel execution Exception", regs);
+       force_sig(SIGFPE, current);
+}
+
+asmlinkage void do_cee(struct pt_regs *regs)
+{
+       die_if_kernel("do_cee execution Exception", regs);
+       force_sig(SIGFPE, current);
+}
+
+asmlinkage void do_cpe(struct pt_regs *regs)
+{
+       die_if_kernel("do_cpe execution Exception", regs);
+       force_sig(SIGFPE, current);
+}
+
+asmlinkage void do_be(struct pt_regs *regs)
+{
+       die_if_kernel("do_be execution Exception", regs);
+       force_sig(SIGBUS, current);
+}
+
+asmlinkage void do_ov(struct pt_regs *regs)
+{
+       siginfo_t info;
+
+       die_if_kernel("do_ov execution Exception", regs);
+
+       info.si_code = FPE_INTOVF;
+       info.si_signo = SIGFPE;
+       info.si_errno = 0;
+       info.si_addr = (void *)regs->cp0_epc;
+       force_sig_info(SIGFPE, &info, current);
+}
+
+asmlinkage void do_tr(struct pt_regs *regs)
+{
+       die_if_kernel("do_tr execution Exception", regs);
+       force_sig(SIGTRAP, current);
+}
+
+asmlinkage void do_ri(struct pt_regs *regs)
+{
+       unsigned long epc_insn;
+       unsigned long epc = regs->cp0_epc;
+
+       read_tsk_long(current, epc, &epc_insn);
+       if (current->thread.single_step == 1) {
+               if ((epc == current->thread.addr1) ||
+                   (epc == current->thread.addr2)) {
+                       clear_single_step(current);
+                       force_sig(SIGTRAP, current);
+                       return;
+               } else
+                       BUG();
+       } else if ((epc_insn == BREAKPOINT32_INSN) ||
+                  ((epc_insn & 0x0000FFFF) == 0x7002) ||
+                  ((epc_insn & 0xFFFF0000) == 0x70020000)) {
+                       force_sig(SIGTRAP, current);
+                       return;
+       } else {
+               die_if_kernel("do_ri execution Exception", regs);
+               force_sig(SIGILL, current);
+       }
+}
+
+asmlinkage void do_ccu(struct pt_regs *regs)
+{
+       die_if_kernel("do_ccu execution Exception", regs);
+       force_sig(SIGILL, current);
+}
+
+asmlinkage void do_reserved(struct pt_regs *regs)
+{
+       /*
+        * Game over - no way to handle this if it ever occurs.  Most 
probably
+        * caused by a new unknown cpu type or after another deadly
+        * hard/software error.
+        */
+       die_if_kernel("do_reserved execution Exception", regs);
+       show_regs(regs);
+       panic("Caught reserved exception - should not happen.");
+}
+
+/*
+ * NMI exception handler.
+ */
+void nmi_exception_handler(struct pt_regs *regs)
+{
+       die_if_kernel("nmi_exception_handler execution Exception", regs);
+       die("NMI", regs);
+}
+
+/* Install CPU exception handler */
+void *set_except_vector(int n, void *addr)
+{
+       unsigned long handler = (unsigned long) addr;
+       unsigned long old_handler = exception_handlers[n];
+
+       exception_handlers[n] = handler;
+       return (void *)old_handler;
+}
+
+void __init trap_init(void)
+{
+       int i;
+
+       pgd_current = (unsigned long)init_mm.pgd;
+       /* DEBUG EXCEPTION */
+       memcpy((void *) DEBUG_VECTOR_BASE_ADDR,
+                       &debug_exception_vector, DEBUG_VECTOR_SIZE);
+       /* NMI EXCEPTION */
+       memcpy((void *) GENERAL_VECTOR_BASE_ADDR,
+                       &general_exception_vector, GENERAL_VECTOR_SIZE);
+
+       /*
+        * Initialise exception handlers
+        */
+       for (i = 0; i <= 31; i++)
+               set_except_vector(i, handle_reserved);
+
+       set_except_vector(1, handle_nmi);
+       set_except_vector(2, handle_adelinsn);
+       set_except_vector(3, handle_tlb_refill);
+       set_except_vector(4, handle_tlb_invaild);
+       set_except_vector(5, handle_ibe);
+       set_except_vector(6, handle_pel);
+       set_except_vector(7, handle_sys);
+       set_except_vector(8, handle_ccu);
+       set_except_vector(9, handle_ri);
+       set_except_vector(10, handle_tr);
+       set_except_vector(11, handle_adedata);
+       set_except_vector(12, handle_adedata);
+       set_except_vector(13, handle_tlb_refill);
+       set_except_vector(14, handle_tlb_invaild);
+       set_except_vector(15, handle_mod);
+       set_except_vector(16, handle_cee);
+       set_except_vector(17, handle_cpe);
+       set_except_vector(18, handle_dbe);
+       flush_icache_range(DEBUG_VECTOR_BASE_ADDR, IRQ_VECTOR_BASE_ADDR);
+
+       atomic_inc(&init_mm.mm_count);
+       current->active_mm = &init_mm;
+       cpu_cache_init();
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/vmlinux.lds.S 
linux-2.6-git.new/arch/score/kernel/vmlinux.lds.S
--- linux-2.6-git.ori/arch/score/kernel/vmlinux.lds.S   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/vmlinux.lds.S   2009-04-01 
16:35:01.000000000 +0800
@@ -0,0 +1,219 @@
+/*
+ * arch/score/kernel/vmlinux.lds.S
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <asm/asm-offsets.h>
+#include <asm-generic/vmlinux.lds.h>
+
+OUTPUT_ARCH(score)
+ENTRY(_stext)
+PHDRS {
+       text PT_LOAD FLAGS(7);  /* RWX */
+       note PT_NOTE FLAGS(4);  /* R__ */
+}
+jiffies = jiffies_64;
+
+SECTIONS
+{
+       . = CONFIG_MEMORY_START + 0x2000;
+       /* read-only */
+       _text = .;      /* Text and read-only data */
+       .text : {
+               TEXT_TEXT
+               SCHED_TEXT
+               LOCK_TEXT
+               KPROBES_TEXT
+               *(.text.*)
+               *(.fixup)
+               *(.gnu.warning)
+       } :text = 0
+       _etext = .;     /* End of text section */
+
+       /* Exception table */
+       . = ALIGN(16);
+       __ex_table : {
+               __start___ex_table = .;
+               *(__ex_table)
+               __stop___ex_table = .;
+       }
+
+       /* Exception table for data bus errors */
+       __dbe_table : {
+               __start___dbe_table = .;
+               *(__dbe_table)
+               __stop___dbe_table = .;
+       }
+
+       NOTES :text :note
+       .dummy : { *(.dummy) } :text
+
+       RODATA
+
+       /* writeable */
+       .data : {       /* Data */
+               /*
+                * This ALIGN is needed as a workaround for a bug a
+                * gcc bug upto 4.1 which limits the maximum alignment
+                * to at most 32kB and results in the following
+                * warning:
+                *
+                *  CC      arch/score/kernel/init_task.o
+                * arch/score/kernel/init_task.c:30: warning: alignment
+                * of ‚Äòinit_thread_union‚Ä°ˆis greater than maximum
+                * object file alignment.  Using 32768
+                */
+               . = ALIGN(_PAGE_SIZE);
+               *(.data.init_task)
+
+               DATA_DATA
+               CONSTRUCTORS
+       }
+       _gp = . + 0x8000;
+       .lit8 : {
+               *(.lit8)
+       }
+       .lit4 : {
+               *(.lit4)
+       }
+       /* We want the small data sections together, so single-instruction 
offsets
+          can access them all, and initialized data all before 
uninitialized, so
+          we can shorten the on-disk segment size.  */
+       .sdata : {
+               *(.sdata)
+       }
+
+       . = ALIGN(_PAGE_SIZE);
+       .data_nosave : {
+               __nosave_begin = .;
+               *(.data.nosave)
+       }
+       . = ALIGN(_PAGE_SIZE);
+       __nosave_end = .;
+
+       . = ALIGN(32);
+       .data.cacheline_aligned : {
+               *(.data.cacheline_aligned)
+       }
+       _edata =  .;                    /* End of data section */
+
+       /* will be freed after init */
+       . = ALIGN(_PAGE_SIZE);          /* Init code and data */
+       __init_begin = .;
+       .init.text : {
+               _sinittext = .;
+               INIT_TEXT
+               _einittext = .;
+       }
+       .init.data : {
+               INIT_DATA
+       }
+       . = ALIGN(16);
+       .init.setup : {
+               __setup_start = .;
+               *(.init.setup)
+               __setup_end = .;
+       }
+
+       .initcall.init : {
+               __initcall_start = .;
+               INITCALLS
+               __initcall_end = .;
+       }
+
+       .con_initcall.init : {
+               __con_initcall_start = .;
+               *(.con_initcall.init)
+               __con_initcall_end = .;
+       }
+       SECURITY_INIT
+
+       /* .exit.text is discarded at runtime, not link time, to deal with
+        * references from .rodata
+        */
+       .exit.text : {
+               EXIT_TEXT
+       }
+       .exit.data : {
+               EXIT_DATA
+       }
+#if defined(CONFIG_BLK_DEV_INITRD)
+       . = ALIGN(_PAGE_SIZE);
+       .init.ramfs : {
+               __initramfs_start = .;
+               *(.init.ramfs)
+               __initramfs_end = .;
+       }
+#endif
+       PERCPU(_PAGE_SIZE)
+       . = ALIGN(_PAGE_SIZE);
+       __init_end = .;
+       /* freed after init ends here */
+
+       __bss_start = .;        /* BSS */
+       .sbss  : {
+               *(.sbss)
+               *(.scommon)
+       }
+       .bss : {
+               *(.bss)
+               *(COMMON)
+       }
+       __bss_stop = .;
+
+       _end = .;
+
+       /* Sections to be discarded */
+       /DISCARD/ : {
+               *(.exitcall.exit)
+
+               /* ABI crap starts here */
+               *(.SCORE.options)
+               *(.options)
+               *(.pdr)
+               *(.reginfo)
+       }
+
+       /* These mark the ABI of the kernel for debuggers.  */
+       .mdebug.abi32 : {
+               KEEP(*(.mdebug.abi32))
+       }
+
+       /* This is the score specific mdebug section.  */
+       .mdebug : {
+               *(.mdebug)
+       }
+
+       STABS_DEBUG
+       DWARF_DEBUG
+
+       /* These must appear regardless of  .  */
+       .gptab.sdata : {
+               *(.gptab.data)
+               *(.gptab.sdata)
+       }
+       .gptab.sbss : {
+               *(.gptab.bss)
+               *(.gptab.sbss)
+       }
+}
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
