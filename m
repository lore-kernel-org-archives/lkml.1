Return-Path: <linux-kernel-owner+w=401wt.eu-S1763167AbZC0BrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763167AbZC0BrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbZC0Bq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:46:59 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:39359 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219AbZC0Bq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:46:56 -0400
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 9/13] score - New architecure port to SunplusCT S+CORE
  processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFC61CF3EE.B8C7C9BC-ON48257586.000970FB-48257586.0009B501@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 27 Mar 2009 09:44:17 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/27 ?? 09:44:18,
	Serialize complete at 2009/03/27 ?? 09:44:18
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/score lastest patch place at 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/irq.c 
linux-2.6-git.new/arch/score/kernel/irq.c
--- linux-2.6-git.ori/arch/score/kernel/irq.c   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/irq.c   2009-03-23 
13:43:34.000000000 +0800
@@ -0,0 +1,142 @@
+/*
+ * arch/score/kernel/irq.c
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
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kernel_stat.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+extern void interrupt_exception_vector(void);
+
+/*
+ * handles all normal device IRQs
+ */
+asmlinkage void do_IRQ(int irq)
+{
+       irq_enter();
+       generic_handle_irq(irq);
+       irq_exit();
+}
+
+/*
+ * on-CPU PIC operations
+ */
+void ack_bad_irq(unsigned int irq)
+{
+       printk("unexpected IRQ # %d\n", irq);
+}
+
+static void score_mask(unsigned int irq_nr)
+{
+       unsigned int irq_source = 63 - irq_nr;
+ 
+       if (irq_source < 32)
+               rIMASK_L |= 1 << irq_source;
+       else
+               rIMASK_H |= 1 << (irq_source - 32);
+}
+
+static void score_unmask(unsigned int irq_nr)
+{
+       unsigned int irq_source = 63 - irq_nr;
+ 
+       if (irq_source < 32)
+               rIMASK_L &= ~(1 << irq_source);
+       else
+               rIMASK_H &= ~(1 << (irq_source - 32));
+}
+
+struct irq_chip score_irq_chip = {
+       .name           = "Score7-level",
+       .mask           = score_mask,
+       .mask_ack       = score_mask,
+       .unmask         = score_unmask,
+       .end            = score_mask,
+};
+
+/*
+ * initialise the interrupt system
+ */
+void __init init_IRQ(void)
+{
+       int index;
+       unsigned long target_addr; 
+ 
+       for (index = 0; index < NR_IRQS; ++index)
+               set_irq_chip_and_handler(index, &score_irq_chip,
+                                        handle_level_irq);
+
+       for (target_addr = IRQ_VECTOR_BASE_ADDR;
+               target_addr <= IRQ_VECTOR_END_ADDR;
+               target_addr += 0x10)
+               memcpy((void*)target_addr, interrupt_exception_vector, 
0x10);
+ 
+       rIMASK_L=0xffffffff;
+       rIMASK_H=0xffffffff;
+
+       __asm__ __volatile__(
+               "mtcr   %0,cr3\n\t"
+               :: "r" (EXCEPTION_VECTOR_BASE_ADDR | 1));
+}
+
+/*
+ * Generic, controller-independent functions:
+ */
+int show_interrupts(struct seq_file *p, void *v)
+{
+       int i = *(loff_t *)v, cpu;
+       struct irqaction *action;
+       unsigned long flags;
+
+       if (i == 0) {
+               seq_puts(p, "           ");
+               for_each_online_cpu(cpu)
+                       seq_printf(p, "CPU%d       ", cpu);
+               seq_putc(p, '\n');
+       }
+
+       if (i < NR_IRQS) {
+               spin_lock_irqsave(&irq_desc[i].lock, flags);
+               action = irq_desc[i].action;
+               if (!action)
+                       goto unlock;
+
+               seq_printf(p, "%3d: ", i);
+               for_each_online_cpu(cpu)
+                       seq_printf(p, "%10u ", kstat_cpu(cpu).irqs[i]);
+               seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
+               seq_printf(p, "  %s", action->name);
+               for (action = action->next; action; action = action->next)
+                       seq_printf(p, ", %s", action->name);
+
+               seq_putc(p, '\n');
+       unlock:
+               spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+       }
+
+       return 0;
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/Makefile 
linux-2.6-git.new/arch/score/kernel/Makefile
--- linux-2.6-git.ori/arch/score/kernel/Makefile        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/Makefile        2009-03-26 
14:00:11.000000000 +0800
@@ -0,0 +1,12 @@
+#
+# Makefile for the Linux/SCORE kernel.
+#
+
+extra-y                := head.o init_task.o vmlinux.lds
+
+obj-y          += entry.o irq.o process.o ptrace.o setup.o \
+                   signal.o sys-score.o time.o traps.o syscalls.o
+
+obj-$(CONFIG_MODULES)  += module.o
+
+EXTRA_CFLAGS +=
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/module.c 
linux-2.6-git.new/arch/score/kernel/module.c
--- linux-2.6-git.ori/arch/score/kernel/module.c        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/module.c        2009-03-23 
17:52:46.000000000 +0800
@@ -0,0 +1,172 @@
+/*
+ * arch/score/kernel/module.c
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
+#include <linux/elf.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/module.h>
+
+void *module_alloc(unsigned long size)
+{
+       if(size != 0)
+               return vmalloc(size);
+       else
+               return 0;
+}
+
+/* Free memory returned from module_alloc */
+void module_free(struct module *mod, void *module_region)
+{
+       vfree(module_region);
+}
+
+int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
+                             char *secstrings, struct module *mod)
+{
+       return 0;
+}
+
+int apply_relocate(Elf_Shdr *sechdrs, const char *strtab,
+                  unsigned int symindex, unsigned int relindex,
+                  struct module *me)
+{
+       Elf32_Shdr *symsec = sechdrs + symindex;
+       Elf32_Shdr *relsec = sechdrs + relindex;
+       Elf32_Shdr *dstsec = sechdrs + relsec->sh_info;
+       Elf32_Rel *rel = (void *)relsec->sh_addr;
+       unsigned int i;
+
+       for (i = 0; i < relsec->sh_size / sizeof(Elf32_Rel); i++, rel++) {
+               unsigned long loc;
+               Elf32_Sym *sym;
+               s32 offset;
+
+               offset = ELF32_R_SYM(rel->r_info);
+               if ((offset < 0) ||
+                   (offset > (symsec->sh_size / sizeof(Elf32_Sym)))) {
+                       printk(KERN_ERR "%s: bad relocation, section %d 
reloc %d\n",
+                               me->name, relindex, i);
+                               return -ENOEXEC;
+               }
+
+               sym = ((Elf32_Sym *)symsec->sh_addr) + offset;
+
+               if ((rel->r_offset < 0) ||
+                   (rel->r_offset > dstsec->sh_size - sizeof(u32))) {
+                       printk(KERN_ERR "%s: out of bounds relocation, "
+                               "section %d reloc %d offset %d size %d\n",
+                               me->name, relindex, i, rel->r_offset,
+                               dstsec->sh_size);
+                       return -ENOEXEC;
+               }
+
+               loc = dstsec->sh_addr + rel->r_offset;
+               switch (ELF32_R_TYPE(rel->r_info)) {
+               case R_SCORE_NONE:
+                       break;
+               case R_SCORE_ABS32:
+                       *(unsigned long *)loc += sym->st_value;
+                       break;
+               case R_SCORE_HI16:
+                       break;
+               case R_SCORE_LO16: {
+                       unsigned long hi16_offset, offset;
+                       unsigned long uvalue;
+                       unsigned long temp,temp_hi;
+                       temp_hi=*((unsigned long *)loc-1);
+                       temp = *(unsigned long*)loc;
+
+                       hi16_offset = (((((temp_hi) >> 16) & 0x3) << 15) |
+                                       ((temp_hi) & 0x7fff)) >> 1;
+                       offset = ((temp >> 16 & 0x03) << 15) |
+                                       ((temp & 0x7fff) >> 1);
+                       offset = (hi16_offset << 16) | (offset & 0xffff);
+                       uvalue = sym->st_value + offset;
+                       hi16_offset = (uvalue >> 16) << 1;
+
+                       temp_hi = ((temp_hi) & (~(0x37fff)))|
+                                       (hi16_offset & 0x7fff) |
+                                       ((hi16_offset << 1) & 0x30000);
+                       *((unsigned long *)loc - 1) = temp_hi; 
+
+                       offset = (uvalue & 0xffff) << 1;
+                       temp = (temp & (~(0x37fff)))| (offset & 0x7fff) |
+                               ((offset << 1) & 0x30000);
+                       *(unsigned long *)loc = temp;
+                       break;
+               }
+               case R_SCORE_24:
+               {
+                       unsigned long hi16_offset, offset;
+                       unsigned long uvalue;
+                       unsigned long temp;
+
+                       temp = *(unsigned long *)loc;
+                       offset = (temp & 0x03FF7FFE);
+                       hi16_offset = (offset & 0xFFFF0000);
+                       offset = (hi16_offset | ((offset & 0xFFFF) << 1)) 
>> 2;
+ 
+                       uvalue = (sym->st_value + offset) >> 1;
+                       uvalue = uvalue & 0x00ffffff;
+
+                       temp = (temp & 0xfc008001) |
+                               ((uvalue << 2) & 0x3ff0000) |
+                               ((uvalue & 0x3fff) << 1);
+                       *(unsigned long *)loc = temp;
+                       break;
+               }
+               default:
+                       printk(KERN_ERR "%s: unknown relocation: %u\n",
+                               me->name, ELF32_R_TYPE(rel->r_info));
+                       return -ENOEXEC;
+               }
+       }
+
+       return 0;
+}
+
+int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
+                      unsigned int symindex, unsigned int relsec,
+                      struct module *me)
+{
+       return 0;
+}
+
+/* Given an address, look for it in the module exception tables. */
+const struct exception_table_entry *search_module_dbetables(unsigned long 
addr)
+{
+       return 0;
+}
+
+/* Put in dbe list if necessary. */
+int module_finalize(const Elf_Ehdr *hdr,
+                   const Elf_Shdr *sechdrs,
+                   struct module *me)
+{
+       return 0;
+}
+
+void module_arch_cleanup(struct module *mod)
+{}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/process.c 
linux-2.6-git.new/arch/score/kernel/process.c
--- linux-2.6-git.ori/arch/score/kernel/process.c       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/process.c       2009-03-23 
17:53:11.000000000 +0800
@@ -0,0 +1,181 @@
+/*
+ * arch/score/kernel/process.c
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
+#include <linux/sched.h>
+#include <linux/kallsyms.h>
+#include <linux/pm.h>
+#include <asm/processor.h>
+#include <asm/uaccess.h>
+#include <asm/elf.h>
+
+void (*cpu_wait)() = NULL;
+void (*pm_power_off)(void);
+EXPORT_SYMBOL(pm_power_off);
+
+/* If or when software machine-restart is implemented, add code here. */
+void machine_restart(char *command)
+{}
+
+/* If or when software machine-halt is implemented, add code here. */
+void machine_halt(void)
+{}
+
+/* If or when software machine-power-off is implemented, add code here. 
*/
+void machine_power_off(void)
+{}
+
+/*
+ * The idle thread. There's no useful work to be
+ * done, so just try to conserve power and have a
+ * low exit latency (ie sit in a loop waiting for
+ * somebody to say that they'd like to reschedule)
+ */
+void __noreturn cpu_idle(void)
+{
+       /* endless idle loop with no priority at all */
+       while (1) {
+               while (!need_resched()) {
+                       if (cpu_wait)
+                               (*cpu_wait)();
+               }
+               preempt_enable_no_resched();
+               schedule();
+               preempt_disable();
+       }
+}
+
+asmlinkage void ret_from_fork(void);
+
+void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long 
sp)
+{
+       unsigned long status;
+
+       /* New thread loses kernel privileges. */
+       status = regs->cp0_psr & ~(KU_MASK);
+       status |= KU_USER;
+       regs->cp0_psr = status;
+       regs->cp0_epc = pc;
+       regs->regs[0] = sp;
+}
+
+void exit_thread(void)
+{}
+
+/*
+ * When a process does an "exec", machine state like FPU and debug
+ * registers need to be reset.  This is a hook function for that.
+ * Currently we don't have any such state to reset, so this is empty.
+ */
+void flush_thread(void)
+{}
+
+/*
+ * set up the kernel stack and exception frames for a new process
+ */
+int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+       unsigned long stk_sz, struct task_struct *p, struct pt_regs *regs)
+{
+       struct thread_info *ti = task_thread_info(p);
+       struct pt_regs *childregs = task_pt_regs(p);
+
+       p->set_child_tid = p->clear_child_tid = NULL;
+
+       *childregs = *regs;
+       childregs->regs[7] = 0;                 /* Clear error flag */
+       childregs->regs[4] = 0;                 /* Child gets zero as 
return value */
+       regs->regs[4] = p->pid;
+
+       if (childregs->cp0_psr & 0x8)           /* test kernel fork or 
user fork */
+               childregs->regs[0] = usp;               /* user fork */
+       else {
+               childregs->regs[28] = (unsigned long) ti; /* kernel fork 
*/
+               childregs->regs[0] = (unsigned long) childregs;
+       }
+       p->thread.reg0 = (unsigned long) childregs;
+       p->thread.reg3 = (unsigned long) ret_from_fork;
+       p->thread.cp0_psr = 0;
+
+       return 0;
+}
+
+/* Fill in the fpu structure for a core dump. */
+int dump_fpu(struct pt_regs *regs, elf_fpregset_t *r)
+{
+       return 1;
+}
+
+void elf_dump_regs(elf_greg_t *gp, struct pt_regs *regs)
+{}
+
+int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
+{
+       return 1;
+}
+
+static void __noreturn kernel_thread_helper(void *unused0, int (*fn)(void 
*), void *arg, void *unused1)
+{
+       do_exit(fn(arg));
+}
+
+/*
+ * Create a kernel thread.
+ */
+long kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+       struct pt_regs regs;
+
+       memset(&regs, 0, sizeof(regs));
+
+       regs.regs[6] = (unsigned long) arg;
+       regs.regs[5] = (unsigned long) fn;
+       regs.cp0_epc = (unsigned long) kernel_thread_helper;
+       regs.cp0_psr = (regs.cp0_psr & ~(0x1|0x4|0x8)) | (regs.cp0_psr & 
0x3) <<2;
+
+       return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, 
NULL, NULL);
+}
+
+unsigned long thread_saved_pc(struct task_struct *tsk)
+{
+       return task_pt_regs(tsk)->cp0_epc;
+}
+
+unsigned long get_wchan(struct task_struct *task)
+{
+       unsigned long pc = 0;
+
+       if (!task || task == current || task->state == TASK_RUNNING)
+               goto out;
+       if (!task_stack_page(task))
+               goto out;
+
+       pc = task_pt_regs(task)->cp0_epc;
+out:
+       return pc;
+}
+
+unsigned long arch_align_stack(unsigned long sp)
+{
+       return sp;
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/kernel/ptrace.c 
linux-2.6-git.new/arch/score/kernel/ptrace.c
--- linux-2.6-git.ori/arch/score/kernel/ptrace.c        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/kernel/ptrace.c        2009-03-23 
17:35:37.000000000 +0800
@@ -0,0 +1,459 @@
+/*
+ * arch/score/kernel/ptrace.c
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
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <asm/asm-offsets.h>
+#include <asm/page.h>
+#include <asm/uaccess.h>
+
+static int is_16bitinsn(unsigned long insn)
+{
+       if ((insn & INSN32_MASK) == INSN32_MASK)
+               return 0;
+       else
+               return 1;
+}
+
+int
+read_tsk_long(struct task_struct *child, unsigned long addr, unsigned 
long *res)
+{
+       int copied;
+
+       copied = access_process_vm(child, addr, res, sizeof(*res), 0);
+
+       return copied != sizeof(*res) ? -EIO : 0;
+}
+
+int
+read_tsk_short(struct task_struct *child, unsigned long addr, unsigned 
short *res)
+{
+       int copied;
+
+       copied = access_process_vm(child, addr, res, sizeof(*res), 0);
+
+       return copied != sizeof(*res) ? -EIO : 0;
+}
+
+static int
+write_tsk_short(struct task_struct *child, unsigned long addr, unsigned 
short val)
+{
+       int copied;
+
+       copied = access_process_vm(child, addr, &val, sizeof(val), 1);
+
+       return copied != sizeof(val) ? -EIO : 0;
+}
+
+static int
+write_tsk_long(struct task_struct *child, unsigned long addr, unsigned 
long val)
+{
+       int copied;
+
+       copied = access_process_vm(child, addr, &val, sizeof(val), 1);
+
+       return copied != sizeof(val) ? -EIO : 0;
+}
+
+void set_single_step(struct task_struct *child)
+{
+       unsigned int epc,far_epc = 0;           /* far_epc is the target 
of branch */
+       unsigned long epc_insn,far_epc_insn;
+       int ninsn_type;                         /* next insn type 0=16b, 
1=32b */
+       unsigned int tmp ,tmp2;
+       struct pt_regs *regs =task_pt_regs(child);
+       child->thread.single_step = 1;
+       child->thread.ss_nextcnt= 1;
+       epc = regs->cp0_epc;
+
+       read_tsk_long(child, epc, &epc_insn);
+
+       if (is_16bitinsn(epc_insn)) {
+               if ((epc_insn & J16M) == J16) {
+                       tmp = epc_insn & 0xFFE;
+                       epc = (epc & 0xFFFFF000) | tmp;
+               }
+               else if ((epc_insn & B16M) == B16) {
+                       child->thread.ss_nextcnt = 2;
+                       tmp = (epc_insn & 0xFF) << 1;
+                       tmp = tmp << 23;
+                       tmp = (unsigned int)((int) tmp >> 23);
+                       far_epc = epc + tmp;
+                       epc += 2;
+               } else if ((epc_insn & BR16M) == BR16) {
+                       child->thread.ss_nextcnt = 2;
+                       tmp = (epc_insn >> 4) & 0xF;
+                       far_epc = regs->regs[tmp];
+                       epc += 2;
+               } else
+                       epc += 2;
+       } else {
+               if ((epc_insn & J32M) == J32) {
+                       tmp = epc_insn & 0x03FFFFFE;
+                       tmp2 = tmp & 0x7FFF;
+                       tmp = (((tmp >> 16) & 0x3FF) << 15) | tmp2;
+                       epc = (epc & 0xFFC00000) | tmp;
+               } else if ((epc_insn & B32M) == B32) {
+                       child->thread.ss_nextcnt= 2;
+                       tmp = epc_insn & 0x03FFFFFE;    /* discard LK bit 
*/
+                       tmp2 = tmp & 0x3FF;
+                       tmp = (((tmp >> 16) & 0x3FF) << 10) | tmp2; /* 
20bit */
+                       tmp = tmp << 12;
+                       tmp = (unsigned int)((int) tmp >> 12) ;
+                       far_epc = epc + tmp;
+                       epc += 4;
+               } else if ((epc_insn & BR32M) == BR32) {
+                       child->thread.ss_nextcnt = 2;
+                       tmp = (epc_insn >> 16) & 0x1F;
+                       far_epc = regs->regs[tmp];
+                       epc += 4;
+               } else
+                       epc +=4;
+       }
+
+       if(child->thread.ss_nextcnt == 1) {
+               read_tsk_long(child, epc, &epc_insn);
+
+               if (is_16bitinsn(epc_insn)) {
+                       write_tsk_short(child, epc, SINGLESTEP16_INSN);
+                       ninsn_type = 0;
+               } else {
+                       write_tsk_long(child, epc, SINGLESTEP32_INSN);
+                       ninsn_type = 1;
+               }
+
+               if (ninsn_type == 0) {  /* 16bits */
+                       child->thread.insn1_type = 0;
+                       child->thread.addr1 = epc;
+                        /* the insn may have 32bit data */
+                       child->thread.insn1 = (short)epc_insn;
+               } else {
+                       child->thread.insn1_type = 1;
+                       child->thread.addr1 = epc;
+                       child->thread.insn1 = epc_insn;
+               }
+       } else {
+               /* branch! have two target child->thread.ss_nextcnt=2 */
+               read_tsk_long(child, epc, &epc_insn);
+               read_tsk_long(child, far_epc, &far_epc_insn);
+               if (is_16bitinsn(epc_insn)) {
+                       write_tsk_short(child, epc, SINGLESTEP16_INSN);
+                       ninsn_type = 0;
+               } else {
+                       write_tsk_long(child, epc, SINGLESTEP32_INSN);
+                       ninsn_type = 1;
+               }
+
+               if (ninsn_type == 0) {  /* 16bits */
+                       child->thread.insn1_type = 0;
+                       child->thread.addr1 = epc;
+                        /* the insn may have 32bit data */
+                       child->thread.insn1 = (short)epc_insn;
+               } else {
+                       child->thread.insn1_type = 1;
+                       child->thread.addr1 = epc;
+                       child->thread.insn1 = epc_insn;
+               }
+
+               if (is_16bitinsn(far_epc_insn)) {
+                       write_tsk_short(child, far_epc, 
SINGLESTEP16_INSN);
+                       ninsn_type = 0;
+               } else {
+                       write_tsk_long(child, far_epc, SINGLESTEP32_INSN);
+                       ninsn_type = 1;
+               }
+
+               if (ninsn_type == 0) {  /* 16bits */
+                       child->thread.insn2_type = 0;
+                       child->thread.addr2 = far_epc;
+                        /* the insn may have 32bit data */
+                       child->thread.insn2 = (short)far_epc_insn;
+               } else {
+                       child->thread.insn2_type = 1;
+                       child->thread.addr2 = far_epc;
+                       child->thread.insn2 = far_epc_insn;
+               }
+       }
+}
+
+void clear_single_step(struct task_struct *child)
+{
+       if (child->thread.insn1_type == 0)
+               write_tsk_short(child, child->thread.addr1, 
child->thread.insn1);
+
+       if (child->thread.insn1_type == 1)
+               write_tsk_long(child, child->thread.addr1, 
child->thread.insn1);
+
+       if (child->thread.ss_nextcnt == 2) {    /* branch */
+               if (child->thread.insn1_type == 0)
+                       write_tsk_short(child, child->thread.addr1, 
child->thread.insn1);
+               if (child->thread.insn1_type == 1)
+                       write_tsk_long(child, child->thread.addr1, 
child->thread.insn1);
+               if (child->thread.insn2_type == 0)
+                       write_tsk_short(child, child->thread.addr2, 
child->thread.insn2);
+               if (child->thread.insn2_type == 1)
+                       write_tsk_long(child, child->thread.addr2, 
child->thread.insn2);
+       }
+
+       child->thread.single_step = 0;
+       child->thread.ss_nextcnt = 0;
+}
+
+
+void ptrace_disable(struct task_struct *child)
+{}
+
+long arch_ptrace(struct task_struct *child, long request, long addr, long 
data)
+{
+       int ret;
+
+       if (request == PTRACE_TRACEME) {
+               /* are we already being traced? */
+               if (current->ptrace & PT_PTRACED) {
+                       ret = -EPERM;
+                       goto out;
+               }
+               /* set the ptrace bit in the process flags. */
+               current->ptrace |= PT_PTRACED;
+               ret = 0;
+               goto out;
+       }
+       ret = -ESRCH;
+       if (!child)
+               goto out;
+
+       ret = -EPERM;
+
+       if (request == PTRACE_ATTACH) {
+               ret = ptrace_attach(child);
+               goto out;
+       }
+
+       ret = ptrace_check_attach(child, request == PTRACE_KILL);
+       if (ret < 0)
+               goto out;
+
+       switch (request) {
+       case PTRACE_PEEKTEXT: /* read word at location addr. */
+       case PTRACE_PEEKDATA: {
+               unsigned long tmp;
+               int copied;
+
+               copied = access_process_vm(child, addr, &tmp, sizeof(tmp), 
0);
+               ret = -EIO;
+               if (copied != sizeof(tmp))
+                       break;
+
+               ret = put_user(tmp,(unsigned long *) data);
+               goto out;
+               }
+
+       /* Read the word at location addr in the USER area.  */
+       case PTRACE_PEEKUSR: {
+               struct pt_regs *regs;
+               unsigned long tmp;
+
+               regs =task_pt_regs(child);
+
+               tmp = 0;  /* Default return value. */
+               switch(addr) {
+               case 0 ... 31:
+                       tmp = regs->regs[addr];
+                       break;
+               case PC:
+                       tmp = regs->cp0_epc;
+                       break;
+               case ECR:
+                       tmp = regs->cp0_ecr;
+                       break;
+               case EMA:
+                       tmp = regs->cp0_ema;
+                       break;
+               case CEH:
+                       tmp = regs->ceh;
+                       break;
+               case CEL:
+                       tmp = regs->cel;
+                       break;
+               case CONDITION:
+                       tmp = regs->cp0_condition;
+                       break;
+               case PSR:
+                       tmp = regs->cp0_psr;
+                       break;
+               case COUNTER:
+                       tmp = regs->sr0;
+                       break;
+               case LDCR:
+                       tmp = regs->sr1;
+                       break;
+               case STCR:
+                       tmp = regs->sr2;
+                       break;
+               default:
+                       tmp = 0;
+                       ret = -EIO;
+                       goto out;
+               }
+
+               ret = put_user(tmp, (unsigned long *) data);
+               goto out;
+       }
+
+       case PTRACE_POKETEXT: /* write the word at location addr. */
+       case PTRACE_POKEDATA:
+               ret = 0;
+               if (access_process_vm(child, addr, &data, sizeof(data), 1)
+                       == sizeof(data))
+                       break;
+               ret = -EIO;
+               goto out;
+
+       case PTRACE_POKEUSR: {
+               struct pt_regs *regs;
+               ret = 0;
+               regs =task_pt_regs(child);
+
+               switch (addr) {
+               case 0 ... 31:
+                       regs->regs[addr] = data;
+                       break;
+               case PC:
+                       regs->cp0_epc = data;
+                       break;
+               case CEH:
+                       regs->ceh = data;
+                       break;
+               case CEL:
+                       regs->cel = data;
+                       break;
+               case CONDITION:
+                       regs->cp0_condition = data;
+                       break;
+               case PSR:
+               case COUNTER:
+               case STCR:
+               case LDCR:
+                       break; /* user can't write the reg */
+               default:
+                       /* The rest are not allowed. */
+                       ret = -EIO;
+                       break;
+               }
+               break;
+       }
+
+       case PTRACE_SYSCALL: /* continue and stop at next (return from) 
syscall */
+       case PTRACE_CONT: { /* restart after signal. */
+               ret = -EIO;
+               if (!valid_signal(data))
+                       break;
+               if (request == PTRACE_SYSCALL)
+                       set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+               else
+                       clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+
+               child->exit_code = data;
+               wake_up_process(child);
+               ret = 0;
+               break;
+       }
+
+       /*
+        * make the child exit.  Best I can do is send it a sigkill.
+        * perhaps it should be put in the status that it wants to
+        * exit.
+        */
+       case PTRACE_KILL:
+               ret = 0;
+               if (child->state == EXIT_ZOMBIE)        /* already dead */
+                       break;
+               child->exit_code = SIGKILL;
+               clear_single_step(child);
+               wake_up_process(child);
+               break;
+
+       case PTRACE_SINGLESTEP: {  /* set the trap flag. */
+               ret = -EIO;
+               if ((unsigned long) data > _NSIG)
+                       break;
+               clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+               set_single_step(child);
+               child->exit_code = data;
+               /* give it a chance to run. */
+               wake_up_process(child);
+               ret = 0;
+               break;
+       }
+
+       case PTRACE_DETACH: /* detach a process that was attached. */
+               ret = ptrace_detach(child, data);
+               break;
+
+       case PTRACE_SETOPTIONS:
+               if (data & PTRACE_O_TRACESYSGOOD)
+                       child->ptrace |= PT_TRACESYSGOOD;
+               else
+                       child->ptrace &= ~PT_TRACESYSGOOD;
+               ret = 0;
+               break;
+
+       default:
+               ret = -EIO;
+               goto out;
+       }
+out:
+       return ret;
+}
+
+/*
+ * Notification of system call entry/exit
+ * - triggered by current->work.syscall_trace
+ */
+asmlinkage void do_syscall_trace(struct pt_regs *regs, int entryexit)
+{
+       if (!(current->ptrace & PT_PTRACED))
+               return;
+
+       if (!test_thread_flag(TIF_SYSCALL_TRACE))
+               return;
+
+       /* The 0x80 provides a way for the tracing parent to distinguish
+          between a syscall stop and SIGTRAP delivery */
+       ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD) ?
+                       0x80 : 0));
+
+       /*
+        * this isn't the same as continuing with a signal, but it will do
+        * for normal use.  strace only continues with a signal if the
+        * stopping signal is not SIGTRAP.  -brl
+        */
+       if (current->exit_code) {
+               send_sig(current->exit_code, current, 1);
+               current->exit_code = 0;
+       }
+}

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
