Return-Path: <linux-kernel-owner+w=401wt.eu-S1763429AbZC0Ccp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763429AbZC0Ccp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 22:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZC0Ccd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 22:32:33 -0400
Received: from 219-87-157-179.static.tfn.net.tw ([219.87.157.179]:34069 "EHLO
	mswedge1.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbZC0Cca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 22:32:30 -0400
X-Greylist: delayed 2604 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 22:32:29 EDT
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 11/13] score - New architecure port to SunplusCT S+CORE
  processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF7CA377BE.25D639C0-ON48257586.0009A7DE-48257586.0009EF6F@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 27 Mar 2009 09:46:46 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/27 ?? 09:46:48,
	Serialize complete at 2009/03/27 ?? 09:46:48
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2R2Wnqu024921

linux/score lastest patch place at 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/time.c 
linux-2.6-git.new/arch/score/kernel/time.c
--- linux-2.6-git.ori/arch/score/kernel/time.c  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/time.c  2009-03-19 
11:09:46.000000000 +0800
@@ -0,0 +1,55 @@
+/*
+ * arch/score/kernel/time.c
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
+#include <linux/interrupt.h>
+#include <asm/scoreregs.h>
+
+int timer_interrupt(int irq, void *dev_id)
+{
+       rTIMER0CPPR = 1;        /* clear timer interrupt flag */
+       do_timer(1);
+       update_process_times(user_mode(get_irq_regs()));
+       return IRQ_HANDLED;
+}
+
+static struct irqaction timer_irq = {
+       .handler = timer_interrupt,
+       .flags = IRQF_DISABLED | IRQF_TIMER,
+       .mask = CPU_MASK_NONE,
+       .name = "timer",
+};
+
+void __init time_init(void)
+{
+       /* disable timer, timer interrupt enable */
+       rTIMER0C = (1 << 10) | (1 << 1);
+       rTIMER0CPR = 0x000107ac;
+
+       /* start timer */
+       rTIMER0C = rTIMER0C | ( 1 << 0);
+       jiffies_64 = 0;
+       setup_irq(IRQ_TIMER , &timer_irq);
+}
+
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/traps.c 
linux-2.6-git.new/arch/score/kernel/traps.c
--- linux-2.6-git.ori/arch/score/kernel/traps.c 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/traps.c 2009-03-23 
17:59:12.000000000 +0800
@@ -0,0 +1,355 @@
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
+       for(i = -3 ; i < 6 ; i++) {
+               unsigned long insn;
+               if (__get_user(insn, pc + i)) {
+                       printk(" (Bad address in epc)\n");
+                       break;
+               }
+               printk("%c%08lx%c",(i?' ':'<'),insn,(i?' ':'>'));
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
+static spinlock_t die_lock = SPIN_LOCK_UNLOCKED;
+
+void __die(const char *str, struct pt_regs *regs, const char *file,
+          const char *func, unsigned long line)
+{
+       console_verbose();
+       spin_lock_irq(&die_lock);
+       printk("%s", str);
+       if (file && func)
+               printk(" in %s:%s, line %ld", file, func, line);
+       printk(":\n");
+       show_registers(regs);
+       spin_unlock_irq(&die_lock);
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
+       read_tsk_long (current, epc, &epc_insn);
+       if (current->thread.single_step == 1) {
+               if ((epc == current->thread.addr1) ||
+                   (epc == current->thread.addr2)) {
+                       clear_single_step (current);
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
+       while(1);
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
+       memcpy((void *)(EXCEPTION_VECTOR_BASE_ADDR + 0x1fc),
+                       &debug_exception_vector, 0x4);
+       /* NMI EXCEPTION */
+       memcpy((void *)(EXCEPTION_VECTOR_BASE_ADDR + 0x200),
+                       &general_exception_vector, 0x10);
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
+       flush_icache_range(EXCEPTION_VECTOR_BASE_ADDR + 0x1fc,
+                          EXCEPTION_VECTOR_BASE_ADDR + 0x210);
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
+++ linux-2.6-git.new/arch/score/kernel/vmlinux.lds.S   2009-03-24 
19:45:25.000000000 +0800
@@ -0,0 +1,222 @@
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
+       _end = . ;
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
+/*     .mdebug.abi64 : {
+               KEEP(*(.mdebug.abi64))
+       }*/
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
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/lib/ashldi3.c 
linux-2.6-git.new/arch/score/lib/ashldi3.c
--- linux-2.6-git.ori/arch/score/lib/ashldi3.c  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/lib/ashldi3.c  2009-03-23 
14:15:24.000000000 +0800
@@ -0,0 +1,46 @@
+/*
+ * arch/score/lib/ashldi3.c
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
+#include "libgcc.h"
+
+long long __ashldi3(long long u, word_type b)
+{
+       DWunion uu, w;
+       word_type bm;
+
+       if (b == 0)
+               return u;
+
+       uu.ll = u;
+       bm = 32 - b;
+
+       if (bm <= 0) {
+               w.s.low = 0;
+               w.s.high = (unsigned int) uu.s.low << -bm;
+       } else {
+               const unsigned int carries = (unsigned int) uu.s.low >> 
bm;
+
+               w.s.low = (unsigned int) uu.s.low << b;
+               w.s.high = ((unsigned int) uu.s.high << b) | carries;
+       }
+
+       return w.ll;
+}
+EXPORT_SYMBOL(__ashldi3);
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/lib/ashrdi3.c 
linux-2.6-git.new/arch/score/lib/ashrdi3.c
--- linux-2.6-git.ori/arch/score/lib/ashrdi3.c  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/lib/ashrdi3.c  2009-03-23 
14:15:28.000000000 +0800
@@ -0,0 +1,48 @@
+/*
+ * arch/score/lib/ashrdi3.c
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
+#include "libgcc.h"
+
+long long __ashrdi3(long long u, word_type b)
+{
+       DWunion uu, w;
+       word_type bm;
+
+       if (b == 0)
+               return u;
+
+       uu.ll = u;
+       bm = 32 - b;
+
+       if (bm <= 0) {
+               /* w.s.high = 1..1 or 0..0 */
+               w.s.high =
+                   uu.s.high >> 31;
+               w.s.low = uu.s.high >> -bm;
+       } else {
+               const unsigned int carries = (unsigned int) uu.s.high << 
bm;
+
+               w.s.high = uu.s.high >> b;
+               w.s.low = ((unsigned int) uu.s.low >> b) | carries;
+       }
+
+       return w.ll;
+}
+EXPORT_SYMBOL(__ashrdi3);
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/lib/checksum_copy.c 
linux-2.6-git.new/arch/score/lib/checksum_copy.c
--- linux-2.6-git.ori/arch/score/lib/checksum_copy.c    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/lib/checksum_copy.c    2009-03-23 
18:00:08.000000000 +0800
@@ -0,0 +1,51 @@
+/*
+ * arch/score/lib/csum_partial_copy.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
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
+#include <net/checksum.h>
+#include <asm/uaccess.h>
+
+unsigned int csum_partial_copy(const char *src, char *dst,
+                               int len, unsigned int sum)
+{
+       sum = csum_partial(src, len, sum);
+       memcpy(dst, src, len);
+
+       return sum;
+}
+
+unsigned int csum_partial_copy_from_user (const char *src, char *dst,
+                                               int len, unsigned int sum,
+                                               int *err_ptr)
+{
+       int missing;
+
+       missing = copy_from_user(dst, src, len);
+       if (missing) {
+               memset(dst + len - missing, 0, missing);
+               *err_ptr = -EFAULT;
+       }
+
+       return csum_partial(dst, len, sum);
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/lib/checksum.S 
linux-2.6-git.new/arch/score/lib/checksum.S
--- linux-2.6-git.ori/arch/score/lib/checksum.S 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/lib/checksum.S 2009-03-23 
18:01:53.000000000 +0800
@@ -0,0 +1,257 @@
+/*
+ * arch/score/lib/csum_partial.S
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
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
+#define ADDC(sum,reg)                  \
+       add     sum, sum, reg;          \
+       cmp.c   reg, sum;               \
+       bleu    9f;                     \
+       addi    sum, 0x1;               \
+9:
+
+#define CSUM_BIGCHUNK(src, offset, sum)                \
+       lw      r8, [src, offset + 0x00];       \
+       lw      r9, [src, offset + 0x04];       \
+       lw      r10, [src, offset + 0x08];      \
+       lw      r11, [src, offset + 0x0c];      \
+       ADDC(sum, r8);                          \
+       ADDC(sum, r9);                          \
+       ADDC(sum, r10);                         \
+       ADDC(sum, r11);                         \
+       lw      r8, [src, offset + 0x10];       \
+       lw      r9, [src, offset + 0x14];       \
+       lw      r10, [src, offset + 0x18];      \
+       lw      r11, [src, offset + 0x1c];      \
+       ADDC(sum, r8);                          \
+       ADDC(sum, r9);                          \
+       ADDC(sum, r10);                         \
+       ADDC(sum, r11);                         \
+
+#define src r4
+#define dest r5
+#define sum r27
+
+       .text
+/* unknown src alignment and < 8 bytes to go */
+small_csumcpy:
+       mv      r5, r10
+       ldi     r9, 0x0
+       cmpi.c  r25, 0x1
+       beq pass_small_set_t7   /*already set, jump to pass_small_set_t7*/
+       andri.c r25,r4 , 0x1    /*Is src 2 bytes aligned?*/
+ 
+pass_small_set_t7:
+       beq     aligned
+       cmpi.c  r5, 0x0
+       beq     fold
+       lbu     r9, [src]
+       slli    r9,r9, 0x8      /*Little endian*/
+       ADDC(sum, r9)
+       addi    src, 0x1
+       subi.c  r5, 0x1
+ 
+       /*len still a full word */
+aligned:
+       andri.c r8, r5, 0x4     /*Len >= 4?*/
+       beq     len_less_4bytes
+
+       /* Still a full word (4byte) to go,and the src is word aligned.*/
+       andri.c r8, src, 0x3    /*src is 4bytes aligned, so use LW!!*/
+       beq     four_byte_aligned
+       lhu     r9, [src]
+       addi    src, 2
+       ADDC(sum, r9)
+       lhu     r9, [src]
+       addi    src, 2
+       ADDC(sum, r9)
+       b len_less_4bytes
+
+four_byte_aligned:             /* Len >=4 and four byte aligned */
+       lw      r9, [src]
+       addi    src, 4
+       ADDC(sum, r9)
+
+len_less_4bytes:               /* 2 byte aligned aligned and length<4B */
+       andri.c r8, r5, 0x2
+       beq     len_less_2bytes
+       lhu     r9, [src]
+       addi    src, 0x2        /* src+=2 */
+       ADDC(sum, r9)
+
+len_less_2bytes:               /* len = 1 */
+       andri.c r8, r5, 0x1
+       beq     fold            /* less than 2 and not equal 1--> len=0 -> 
fold */
+       lbu     r9, [src]
+
+fold_ADDC:
+       ADDC(sum, r9)
+fold:
+       /* fold checksum */
+       slli    r26, sum, 16
+       add     sum, sum, r26
+       cmp.c   r26, sum
+       srli    sum, sum, 16
+       bleu    1f              /* if r26<=sum */
+       addi    sum, 0x1        /* r26>sum */
+1:
+       /* odd buffer alignment? r25 was set in csum_partial */
+       cmpi.c  r25, 0x0
+       beq     1f
+       slli    r26, sum, 8
+       srli    sum, sum, 8
+       or      sum, sum, r26
+       andi    sum, 0xffff
+1:
+       .set    optimize
+       /* Add the passed partial csum. */
+       ADDC(sum, r6)
+       mv      r4, sum
+       br      r3
+       .set    volatile
+
+       .align  5
+       .globl  csum_partial
+       .type   csum_partial, @function
+       .ent    csum_partial, 0
+csum_partial:  .frame  sp, 0, r3
+       ldi sum, 0
+       ldi r25, 0
+       mv r10, r5
+       cmpi.c  r5, 0x8
+       blt     small_csumcpy           /* < 8(singed) bytes to copy */
+       cmpi.c  r5, 0x0
+       beq     out
+       andri.c r25, src, 0x1           /* odd buffer? */
+
+       beq     word_align
+hword_align:                           /* 1 byte */
+       lbu     r8, [src]
+       subi    r5, 0x1
+       slli    r8, r8, 8
+       ADDC(sum, r8)
+       addi    src, 0x1
+
+word_align:                            /* 2 bytes */
+       andri.c r8, src, 0x2            /* 4bytes(dword)_aligned? */
+       beq     dword_align             /* not, maybe dword_align */
+       lhu     r8, [src]
+       subi    r5, 0x2
+       ADDC(sum, r8)
+       addi    src, 0x2
+
+dword_align:                           /* 4bytes */
+       mv      r26, r5                 /* maybe useless when len >=56 */
+       ldi     r8, 56
+       cmp.c   r8, r5
+       bgtu    do_end_words            /* if a1(len)<t0(56) ,unsigned */
+       andri.c r26, src, 0x4
+       beq     qword_align
+       lw      r8, [src]
+       subi    r5, 0x4
+       ADDC(sum, r8)
+       addi    src, 0x4
+
+qword_align:                           /* 8 bytes */
+       andri.c r26, src, 0x8
+       beq     oword_align
+       lw      r8, [src, 0x0]
+       lw      r9, [src, 0x4]
+       subi    r5, 0x8                 /* len-=0x8 */
+       ADDC(sum, r8)
+       ADDC(sum, r9)
+       addi    src, 0x8
+
+oword_align:                           /* 16bytes */
+       andri.c r26, src, 0x10
+       beq     begin_movement
+       lw      r10, [src, 0x08]
+       lw      r11, [src, 0x0c]
+       lw      r8, [src, 0x00]
+       lw      r9, [src, 0x04]
+       ADDC(sum, r10)
+       ADDC(sum, r11)
+       ADDC(sum, r8)
+       ADDC(sum, r9)
+       subi    r5, 0x10
+       addi    src, 0x10
+
+begin_movement:
+       srli.c  r26, r5, 0x7            /* len>=128? */
+       beq     1f                      /* len<128 */
+
+/* r26 is the result that computed in oword_align */
+move_128bytes:
+       CSUM_BIGCHUNK(src, 0x00, sum)
+       CSUM_BIGCHUNK(src, 0x20, sum)
+       CSUM_BIGCHUNK(src, 0x40, sum)
+       CSUM_BIGCHUNK(src, 0x60, sum)
+       subi.c  r26, 0x01               /* r26 equals len/128 */
+       addi    src, 0x80
+       bne     move_128bytes
+
+1:     /* len<128,we process 64byte here */
+       andri.c r10, r5, 0x40
+       beq     1f
+
+move_64bytes:
+       CSUM_BIGCHUNK(src, 0x00, sum)
+       CSUM_BIGCHUNK(src, 0x20, sum)
+       addi    src, 0x40
+
+1:                                     /* len<64 */
+       andri   r26, r5, 0x1c           /* 0x1c=28 */
+       andri.c r10, r5, 0x20
+       beq     do_end_words            /* decided by andri */
+
+move_32bytes:
+       CSUM_BIGCHUNK(src, 0x00, sum)
+       andri   r26, r5, 0x1c
+       addri   src, src, 0x20
+
+do_end_words:                          /* len<32 */
+       /* r26 was set already in dword_align */
+       cmpi.c  r26, 0x0
+       beq     maybe_end_cruft         /* len<28 or len<56 */
+       srli    r26, r26, 0x2
+
+end_words:
+       lw      r8, [src]
+       subi.c  r26, 0x1                /* unit is 4 byte */
+       ADDC(sum, r8)
+       addi    src, 0x4
+       cmpi.c  r26, 0x0
+       bne     end_words               /* r26!=0 */
+
+maybe_end_cruft:                       /* len<4 */
+       andri   r10, r5, 0x3
+
+small_memcpy:
+       mv      r5, r10
+       j       small_csumcpy
+
+out:
+       mv      r4, sum
+       br      r3
+       .end    csum_partial
+       .size   csum_partial, .-csum_partial
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/lib/cmpdi2.c 
linux-2.6-git.new/arch/score/lib/cmpdi2.c
--- linux-2.6-git.ori/arch/score/lib/cmpdi2.c   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/lib/cmpdi2.c   2009-03-23 
14:15:37.000000000 +0800
@@ -0,0 +1,44 @@
+/*
+ * arch/score/lib/cmpdi2.c
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
+#include "libgcc.h"
+
+word_type __cmpdi2(long long a, long long b)
+{
+       const DWunion au = {
+               .ll = a
+       };
+       const DWunion bu = {
+               .ll = b
+       };
+
+       if (au.s.high < bu.s.high)
+               return 0;
+       else if (au.s.high > bu.s.high)
+               return 2;
+
+       if ((unsigned int) au.s.low < (unsigned int) bu.s.low)
+               return 0;
+       else if ((unsigned int) au.s.low > (unsigned int) bu.s.low)
+               return 2;
+
+       return 1;
+}
+EXPORT_SYMBOL(__cmpdi2);

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
