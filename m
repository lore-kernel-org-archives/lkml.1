Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbZFIGkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbZFIGkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbZFIGk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:40:27 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:58699 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514AbZFIGkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:40:20 -0400
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 21/27] score: create kernel files ptrace.c setup.c
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF9E916A44.859476BA-ON482575D0.00243015-482575D0.0024A03A@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:35:45 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:35:46,
	Serialize complete at 2009/06/09 ?? 02:35:46
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a9cf36c1ebacdd02a6d7ccd91920fc5edd65ffcc Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:17 +0800
Subject: [PATCH 21/27] score: create kernel files ptrace.c setup.c


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/kernel/ptrace.c |  465 
++++++++++++++++++++++++++++++++++++++++++++
 arch/score/kernel/setup.c  |  156 +++++++++++++++
 2 files changed, 621 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/kernel/ptrace.c
 create mode 100644 arch/score/kernel/setup.c

diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
new file mode 100644
index 0000000..8fe7209
--- /dev/null
+++ b/arch/score/kernel/ptrace.c
@@ -0,0 +1,465 @@
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
+#include <linux/ptrace.h>
+
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
+read_tsk_long(struct task_struct *child,
+               unsigned long addr, unsigned long *res)
+{
+       int copied;
+
+       copied = access_process_vm(child, addr, res, sizeof(*res), 0);
+
+       return copied != sizeof(*res) ? -EIO : 0;
+}
+
+int
+read_tsk_short(struct task_struct *child,
+               unsigned long addr, unsigned short *res)
+{
+       int copied;
+
+       copied = access_process_vm(child, addr, res, sizeof(*res), 0);
+
+       return copied != sizeof(*res) ? -EIO : 0;
+}
+
+static int
+write_tsk_short(struct task_struct *child,
+               unsigned long addr, unsigned short val)
+{
+       int copied;
+
+       copied = access_process_vm(child, addr, &val, sizeof(val), 1);
+
+       return copied != sizeof(val) ? -EIO : 0;
+}
+
+static int
+write_tsk_long(struct task_struct *child,
+               unsigned long addr, unsigned long val)
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
+       /* far_epc is the target of branch */
+       unsigned int epc, far_epc = 0;
+       unsigned long epc_insn, far_epc_insn;
+       int ninsn_type;                 /* next insn type 0=16b, 1=32b */
+       unsigned int tmp, tmp2;
+       struct pt_regs *regs = task_pt_regs(child);
+       child->thread.single_step = 1;
+       child->thread.ss_nextcnt = 1;
+       epc = regs->cp0_epc;
+
+       read_tsk_long(child, epc, &epc_insn);
+
+       if (is_16bitinsn(epc_insn)) {
+               if ((epc_insn & J16M) == J16) {
+                       tmp = epc_insn & 0xFFE;
+                       epc = (epc & 0xFFFFF000) | tmp;
+               } else if ((epc_insn & B16M) == B16) {
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
+                       child->thread.ss_nextcnt = 2;
+                       tmp = epc_insn & 0x03FFFFFE;    /* discard LK bit 
*/
+                       tmp2 = tmp & 0x3FF;
+                       tmp = (((tmp >> 16) & 0x3FF) << 10) | tmp2; /* 
20bit */
+                       tmp = tmp << 12;
+                       tmp = (unsigned int)((int) tmp >> 12);
+                       far_epc = epc + tmp;
+                       epc += 4;
+               } else if ((epc_insn & BR32M) == BR32) {
+                       child->thread.ss_nextcnt = 2;
+                       tmp = (epc_insn >> 16) & 0x1F;
+                       far_epc = regs->regs[tmp];
+                       epc += 4;
+               } else
+                       epc += 4;
+       }
+
+       if (child->thread.ss_nextcnt == 1) {
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
+                               child->thread.insn1);
+
+       if (child->thread.insn1_type == 1)
+               write_tsk_long(child, child->thread.addr1,
+                               child->thread.insn1);
+
+       if (child->thread.ss_nextcnt == 2) {    /* branch */
+               if (child->thread.insn1_type == 0)
+                       write_tsk_short(child, child->thread.addr1,
+                                       child->thread.insn1);
+               if (child->thread.insn1_type == 1)
+                       write_tsk_long(child, child->thread.addr1,
+                                       child->thread.insn1);
+               if (child->thread.insn2_type == 0)
+                       write_tsk_short(child, child->thread.addr2,
+                                       child->thread.insn2);
+               if (child->thread.insn2_type == 1)
+                       write_tsk_long(child, child->thread.addr2,
+                                       child->thread.insn2);
+       }
+
+       child->thread.single_step = 0;
+       child->thread.ss_nextcnt = 0;
+}
+
+
+void ptrace_disable(struct task_struct *child) {}
+
+long
+arch_ptrace(struct task_struct *child, long request, long addr, long 
data)
+{
+       int ret;
+
+       if (request == PTRACE_TRACEME) {
+               /* are we already being traced? */
+               if (current->ptrace & PT_PTRACED)
+                       return -EPERM;
+
+               /* set the ptrace bit in the process flags. */
+               current->ptrace |= PT_PTRACED;
+               return 0;
+       }
+
+       ret = -ESRCH;
+       if (!child)
+               return ret;
+
+       ret = -EPERM;
+
+       if (request == PTRACE_ATTACH) {
+               ret = ptrace_attach(child);
+               return ret;
+       }
+
+       ret = ptrace_check_attach(child, request == PTRACE_KILL);
+       if (ret < 0)
+               return ret;
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
+               ret = put_user(tmp, (unsigned long *) data);
+               return ret;
+       }
+
+       /* Read the word at location addr in the USER area.  */
+       case PTRACE_PEEKUSR: {
+               struct pt_regs *regs;
+               unsigned long tmp;
+
+               regs = task_pt_regs(child);
+
+               tmp = 0;  /* Default return value. */
+               switch (addr) {
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
+                       return -EIO;
+               }
+
+               ret = put_user(tmp, (unsigned long *) data);
+               return ret;
+       }
+
+       case PTRACE_POKETEXT: /* write the word at location addr. */
+       case PTRACE_POKEDATA:
+               ret = 0;
+               if (access_process_vm(child, addr, &data, sizeof(data), 1)
+                       == sizeof(data))
+                       break;
+               ret = -EIO;
+               return ret;
+
+       case PTRACE_POKEUSR: {
+               struct pt_regs *regs;
+               ret = 0;
+               regs = task_pt_regs(child);
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
+       case PTRACE_SYSCALL: /* continue and stop at next
+                               (return from) syscall. */
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
+               if (child->state == EXIT_ZOMBIE)        /* already dead. 
*/
+                       break;
+               child->exit_code = SIGKILL;
+               clear_single_step(child);
+               wake_up_process(child);
+               break;
+
+       case PTRACE_SINGLESTEP: {               /* set the trap flag. */
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
+               break;
+       }
+
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
+          between a syscall stop and SIGTRAP delivery. */
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
diff --git a/arch/score/kernel/setup.c b/arch/score/kernel/setup.c
new file mode 100644
index 0000000..94cba78
--- /dev/null
+++ b/arch/score/kernel/setup.c
@@ -0,0 +1,156 @@
+/*
+ * arch/score/kernel/setup.c
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
+#include <linux/bootmem.h>
+#include <linux/initrd.h>
+#include <linux/ioport.h>
+#include <linux/seq_file.h>
+#include <linux/screen_info.h>
+#include <asm-generic/sections.h>
+
+struct screen_info screen_info;
+unsigned long kernelsp;
+
+static char command_line[COMMAND_LINE_SIZE];
+static struct resource code_resource = { .name = "Kernel code",};
+static struct resource data_resource = { .name = "Kernel data",};
+
+static void __init bootmem_init(void)
+{
+       unsigned long reserved_end, bootmap_size;
+       unsigned long size = initrd_end - initrd_start;
+
+       reserved_end = (unsigned long)_end;
+
+       min_low_pfn = 0;
+       max_low_pfn = MEM_SIZE / PAGE_SIZE;
+
+       /* Initialize the boot-time allocator with low memory only. */
+       bootmap_size = init_bootmem_node(NODE_DATA(0), reserved_end,
+                                        min_low_pfn, max_low_pfn);
+       add_active_range(0, min_low_pfn, max_low_pfn);
+
+       free_bootmem(PFN_PHYS(reserved_end),
+                    (max_low_pfn - reserved_end) << PAGE_SHIFT);
+       memory_present(0, reserved_end, max_low_pfn);
+
+       /* Reserve space for the bootmem bitmap. */
+       reserve_bootmem(PFN_PHYS(reserved_end), bootmap_size, 
BOOTMEM_DEFAULT);
+
+       if (size == 0) {
+               printk(KERN_INFO "Initrd not found or empty");
+               goto disable;
+       }
+
+       if (__pa(initrd_end) > PFN_PHYS(max_low_pfn)) {
+               printk(KERN_ERR "Initrd extends beyond end of memory");
+               goto disable;
+       }
+
+       /* Reserve space for the initrd bitmap. */
+       reserve_bootmem(__pa(initrd_start), size, BOOTMEM_DEFAULT);
+       initrd_below_start_ok = 1;
+
+       pr_info("Initial ramdisk at: 0x%lx (%lu bytes)\n",
+                initrd_start, size);
+       return;
+disable:
+       printk(KERN_CONT " - disabling initrd\n");
+       initrd_start = 0;
+       initrd_end = 0;
+}
+
+static void __init resource_init(void)
+{
+       struct resource *res;
+
+       code_resource.start = (unsigned long)_text;
+       code_resource.end = (unsigned long)_etext - 1;
+       data_resource.start = (unsigned long)_etext;
+       data_resource.end = (unsigned long)_edata - 1;
+
+       res = alloc_bootmem(sizeof(struct resource));
+       res->name = "System RAM";
+       res->start = 0;
+       res->end = MEM_SIZE - 1;
+       res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+       request_resource(&iomem_resource, res);
+
+       request_resource(res, &code_resource);
+       request_resource(res, &data_resource);
+}
+
+void __init setup_arch(char **cmdline_p)
+{
+       randomize_va_space = 0;
+       *cmdline_p = command_line;
+
+       cpu_cache_init();
+       tlb_init();
+       bootmem_init();
+       paging_init();
+       resource_init();
+}
+
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+       unsigned long n = (unsigned long) v - 1;
+
+       seq_printf(m, "processor\t\t: %ld\n", n);
+       seq_printf(m, "\n");
+
+       return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+       unsigned long i = *pos;
+
+       return i < 1 ? (void *) (i + 1) : NULL;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+       ++*pos;
+       return c_start(m, pos);
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+const struct seq_operations cpuinfo_op = {
+       .start  = c_start,
+       .next   = c_next,
+       .stop   = c_stop,
+       .show   = show_cpuinfo,
+};
+
+static int __init topology_init(void)
+{
+       return 0;
+}
+
+subsys_initcall(topology_init);
-- 
1.6.2

