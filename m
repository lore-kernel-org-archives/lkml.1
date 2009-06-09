Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZFIGk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZFIGk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbZFIGkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:40:12 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58626 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbZFIGkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:40:09 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 20/27] score: create kernel files init_task.c irq.S Makefile
 module.c process.c
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFBFF783E0.D5EFC759-ON482575D0.00242208-482575D0.0024937F@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:35:13 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:35:13,
	Serialize complete at 2009/06/09 ?? 02:35:13
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e534326db685127dc3effbb4def45d586f4e9062 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:16 +0800
Subject: [PATCH 20/27] score: create kernel files init_task.c irq.S 
Makefile module.c process.c


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/kernel/Makefile    |   10 +++
 arch/score/kernel/init_task.c |   49 ++++++++++++
 arch/score/kernel/irq.c       |  143 +++++++++++++++++++++++++++++++++++
 arch/score/kernel/module.c    |  165 
+++++++++++++++++++++++++++++++++++++++++
 arch/score/kernel/process.c   |  165 
+++++++++++++++++++++++++++++++++++++++++
 5 files changed, 532 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/kernel/Makefile
 create mode 100644 arch/score/kernel/init_task.c
 create mode 100644 arch/score/kernel/irq.c
 create mode 100644 arch/score/kernel/module.c
 create mode 100644 arch/score/kernel/process.c

diff --git a/arch/score/kernel/Makefile b/arch/score/kernel/Makefile
new file mode 100644
index 0000000..1e5de89
--- /dev/null
+++ b/arch/score/kernel/Makefile
@@ -0,0 +1,10 @@
+#
+# Makefile for the Linux/SCORE kernel.
+#
+
+extra-y        := head.o vmlinux.lds
+
+obj-y += entry.o init_task.o irq.o process.o ptrace.o \
+       setup.o signal.o sys_score.o time.o traps.o
+
+obj-$(CONFIG_MODULES) += module.o
diff --git a/arch/score/kernel/init_task.c b/arch/score/kernel/init_task.c
new file mode 100644
index 0000000..9eecde0
--- /dev/null
+++ b/arch/score/kernel/init_task.c
@@ -0,0 +1,49 @@
+/*
+ * arch/score/kernel/init_task.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
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
+#include <linux/init_task.h>
+#include <linux/mqueue.h>
+
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+struct mm_struct init_mm = INIT_MM(init_mm);
+EXPORT_SYMBOL(init_mm);
+
+/*
+ * Initial thread structure.
+ *
+ * We need to make sure that this is THREAD_SIZE aligned due to the
+ * way process stacks are handled. This is done by having a special
+ * "init_task" linker map entry..
+ */
+union thread_union init_thread_union
+       __attribute__((__section__(".data.init_task"))) =
+               { INIT_THREAD_INFO(init_task) };
+
+/*
+ * Initial task structure.
+ *
+ * All other task structs will be allocated on slabs in fork.c
+ */
+struct task_struct init_task = INIT_TASK(init_task);
+EXPORT_SYMBOL(init_task);
diff --git a/arch/score/kernel/irq.c b/arch/score/kernel/irq.c
new file mode 100644
index 0000000..07de7c9
--- /dev/null
+++ b/arch/score/kernel/irq.c
@@ -0,0 +1,143 @@
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
+#include <linux/interrupt.h>
+#include <linux/kernel_stat.h>
+#include <linux/seq_file.h>
+
+#include <asm/io.h>
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
+       printk(KERN_ERR "unexpected IRQ # %d\n", irq);
+}
+
+static void score_mask(unsigned int irq_nr)
+{
+       unsigned int irq_source = 63 - irq_nr;
+
+       if (irq_source < 32)
+               __raw_writel((__raw_readl((void *)P_INT_MASKL) | \
+                       (1 << irq_source)), (void *)P_INT_MASKL);
+       else
+               __raw_writel((__raw_readl((void *)P_INT_MASKH) | \
+                       (1 << (irq_source - 32))), (void *)P_INT_MASKH);
+}
+
+static void score_unmask(unsigned int irq_nr)
+{
+       unsigned int irq_source = 63 - irq_nr;
+
+       if (irq_source < 32)
+               __raw_writel((__raw_readl((void *)P_INT_MASKL) & \
+                       ~(1 << irq_source)), (void *)P_INT_MASKL);
+       else
+               __raw_writel((__raw_readl((void *)P_INT_MASKH) & \
+                       ~(1 << (irq_source - 32))), (void *)P_INT_MASKH);
+}
+
+struct irq_chip score_irq_chip = {
+       .name           = "Score7-level",
+       .mask           = score_mask,
+       .mask_ack       = score_mask,
+       .unmask         = score_unmask,
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
+               target_addr += IRQ_VECTOR_SIZE)
+               memcpy((void *)target_addr, \
+                       interrupt_exception_vector, IRQ_VECTOR_SIZE);
+
+       __raw_writel(0xffffffff, (void *)P_INT_MASKL);
+       __raw_writel(0xffffffff, (void *)P_INT_MASKH);
+
+       __asm__ __volatile__(
+               "mtcr   %0, cr3\n\t"
+               : : "r" (EXCEPTION_VECTOR_BASE_ADDR | \
+                       VECTOR_ADDRESS_OFFSET_MODE16));
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
+               seq_printf(p, "%10u ", kstat_irqs(i));
+               seq_printf(p, " %8s", irq_desc[i].chip->name ? : "-");
+               seq_printf(p, "  %s", action->name);
+               for (action = action->next; action; action = action->next)
+                       seq_printf(p, ", %s", action->name);
+
+               seq_putc(p, '\n');
+unlock:
+               spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+       }
+
+       return 0;
+}
diff --git a/arch/score/kernel/module.c b/arch/score/kernel/module.c
new file mode 100644
index 0000000..c83a647
--- /dev/null
+++ b/arch/score/kernel/module.c
@@ -0,0 +1,165 @@
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
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+
+void *module_alloc(unsigned long size)
+{
+       return size ? vmalloc(size) : NULL;
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
+                       unsigned long temp, temp_hi;
+                       temp_hi = *((unsigned long *)loc - 1);
+                       temp = *(unsigned long *)loc;
+
+                       hi16_offset = (((((temp_hi) >> 16) & 0x3) << 15) |
+                                       ((temp_hi) & 0x7fff)) >> 1;
+                       offset = ((temp >> 16 & 0x03) << 15) |
+                                       ((temp & 0x7fff) >> 1);
+                       offset = (hi16_offset << 16) | (offset & 0xffff);
+                       uvalue = sym->st_value + offset;
+                       hi16_offset = (uvalue >> 16) << 1;
+
+                       temp_hi = ((temp_hi) & (~(0x37fff))) |
+                                       (hi16_offset & 0x7fff) |
+                                       ((hi16_offset << 1) & 0x30000);
+                       *((unsigned long *)loc - 1) = temp_hi;
+
+                       offset = (uvalue & 0xffff) << 1;
+                       temp = (temp & (~(0x37fff))) | (offset & 0x7fff) |
+                               ((offset << 1) & 0x30000);
+                       *(unsigned long *)loc = temp;
+                       break;
+               }
+               case R_SCORE_24: {
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
+void module_arch_cleanup(struct module *mod) {}
diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
new file mode 100644
index 0000000..aaa3085
--- /dev/null
+++ b/arch/score/kernel/process.c
@@ -0,0 +1,165 @@
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
+#include <linux/module.h>
+
+void (*pm_power_off)(void);
+EXPORT_SYMBOL(pm_power_off);
+
+/* If or when software machine-restart is implemented, add code here. */
+void machine_restart(char *command) {}
+
+/* If or when software machine-halt is implemented, add code here. */
+void machine_halt(void) {}
+
+/* If or when software machine-power-off is implemented, add code here. 
*/
+void machine_power_off(void) {}
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
+               while (!need_resched())
+                       barrier();
+
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
+void exit_thread(void) {}
+
+/*
+ * When a process does an "exec", machine state like FPU and debug
+ * registers need to be reset.  This is a hook function for that.
+ * Currently we don't have any such state to reset, so this is empty.
+ */
+void flush_thread(void) {}
+
+/*
+ * set up the kernel stack and exception frames for a new process
+ */
+int copy_thread(unsigned long clone_flags, unsigned long usp,
+               unsigned long unused,
+               struct task_struct *p, struct pt_regs *regs)
+{
+       struct thread_info *ti = task_thread_info(p);
+       struct pt_regs *childregs = task_pt_regs(p);
+
+       p->set_child_tid = NULL;
+       p->clear_child_tid = NULL;
+
+       *childregs = *regs;
+       childregs->regs[7] = 0;         /* Clear error flag */
+       childregs->regs[4] = 0;         /* Child gets zero as return value 
*/
+       regs->regs[4] = p->pid;
+
+       if (childregs->cp0_psr & 0x8) { /* test kernel fork or user fork 
*/
+               childregs->regs[0] = usp;               /* user fork */
+       } else {
+               childregs->regs[28] = (unsigned long) ti; /* kernel fork 
*/
+               childregs->regs[0] = (unsigned long) childregs;
+       }
+
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
+static void __noreturn
+kernel_thread_helper(void *unused0, int (*fn)(void *),
+                void *arg, void *unused1)
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
+       regs.cp0_psr = (regs.cp0_psr & ~(0x1|0x4|0x8)) | \
+                       ((regs.cp0_psr & 0x3) << 2);
+
+       return do_fork(flags | CLONE_VM | CLONE_UNTRACED, \
+                       0, &regs, 0, NULL, NULL);
+}
+
+unsigned long thread_saved_pc(struct task_struct *tsk)
+{
+       return task_pt_regs(tsk)->cp0_epc;
+}
+
+unsigned long get_wchan(struct task_struct *task)
+{
+       if (!task || task == current || task->state == TASK_RUNNING)
+               return 0;
+
+       if (!task_stack_page(task))
+               return 0;
+
+       return task_pt_regs(task)->cp0_epc;
+}
+
+unsigned long arch_align_stack(unsigned long sp)
+{
+       return sp;
+}
-- 
1.6.2

