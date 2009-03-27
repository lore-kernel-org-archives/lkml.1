Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZC0K0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZC0K0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 06:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZC0K0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 06:26:23 -0400
Received: from www.tglx.de ([62.245.132.106]:42823 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZC0K0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 06:26:22 -0400
Date: Fri, 27 Mar 2009 11:25:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: liqin.chen@sunplusct.com
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 9/13] score - New architecure port to SunplusCT S+CORE
 processor
In-Reply-To: <OFC61CF3EE.B8C7C9BC-ON48257586.000970FB-48257586.0009B501@sunplusct.com>
Message-ID: <alpine.LFD.2.00.0903271051240.3397@localhost.localdomain>
References: <OFC61CF3EE.B8C7C9BC-ON48257586.000970FB-48257586.0009B501@sunplusct.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, liqin.chen@sunplusct.com wrote:
> +
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/kernel_stat.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
> +
> +extern void interrupt_exception_vector(void);

  Move this to a header file please.

> +/*
> + * handles all normal device IRQs
> + */
> +asmlinkage void do_IRQ(int irq)
> +{
> +       irq_enter();
> +       generic_handle_irq(irq);
> +       irq_exit();
> +}
> +
> +/*
> + * on-CPU PIC operations
> + */
> +void ack_bad_irq(unsigned int irq)
> +{
> +       printk("unexpected IRQ # %d\n", irq);
> +}
> +
> +static void score_mask(unsigned int irq_nr)
> +{
> +       unsigned int irq_source = 63 - irq_nr;
> + 
> +       if (irq_source < 32)
> +               rIMASK_L |= 1 << irq_source;
> +       else
> +               rIMASK_H |= 1 << (irq_source - 32);
> +}
> +
> +static void score_unmask(unsigned int irq_nr)
> +{
> +       unsigned int irq_source = 63 - irq_nr;
> + 
> +       if (irq_source < 32)
> +               rIMASK_L &= ~(1 << irq_source);
> +       else
> +               rIMASK_H &= ~(1 << (irq_source - 32));
> +}
> +
> +struct irq_chip score_irq_chip = {
> +       .name           = "Score7-level",
> +       .mask           = score_mask,
> +       .mask_ack       = score_mask,
> +       .unmask         = score_unmask,
> +       .end            = score_mask,

  .end is not needed.

> +};
> +
> +/*
> + * initialise the interrupt system
> + */
> +void __init init_IRQ(void)
> +{
> +       int index;
> +       unsigned long target_addr; 
> + 
> +       for (index = 0; index < NR_IRQS; ++index)
> +               set_irq_chip_and_handler(index, &score_irq_chip,
> +                                        handle_level_irq);
> +
> +       for (target_addr = IRQ_VECTOR_BASE_ADDR;
> +               target_addr <= IRQ_VECTOR_END_ADDR;
> +               target_addr += 0x10)
> +               memcpy((void*)target_addr, interrupt_exception_vector, 
> 0x10);

  Magic number 0x10 ?

> + 
> +       rIMASK_L=0xffffffff;
> +       rIMASK_H=0xffffffff;

  lower case variable names please. What's this magic 0xfffffff
  initialization ?

> +
> +       __asm__ __volatile__(
> +               "mtcr   %0,cr3\n\t"
> +               :: "r" (EXCEPTION_VECTOR_BASE_ADDR | 1));

  Please explain what such asm constructs are doing either by adding a
  comment or by moving it into an inline function with a self
  explanatory function name.
> +
> +void *module_alloc(unsigned long size)
> +{
> +       if(size != 0)

  missing blank: if (). Please run your patches through checkpatch.pl

> +               return vmalloc(size);
> +       else
> +               return 0;

  		  return NULL;

Please simplify to:

       return size ? vmalloc(size) : NULL;

> +
> +void module_arch_cleanup(struct module *mod)
> +{}

either
void func(arg) { }
or
void func(arg)
{
}

Also those empty functions can be implemented as static inline. That
avoids the call to the empty function and gets optimized out by the
compiler.

> +
> +/* If or when software machine-restart is implemented, add code here. */
> +void machine_restart(char *command)
> +{}

See above.

> +/* If or when software machine-halt is implemented, add code here. */
> +void machine_halt(void)
> +{}
> +
> +/* If or when software machine-power-off is implemented, add code here. 
> */
> +void machine_power_off(void)
> +{}
> +
> +/*
> + * The idle thread. There's no useful work to be
> + * done, so just try to conserve power and have a
> + * low exit latency (ie sit in a loop waiting for
> + * somebody to say that they'd like to reschedule)
> + */
> +void __noreturn cpu_idle(void)
> +{
> +       /* endless idle loop with no priority at all */
> +       while (1) {
> +               while (!need_resched()) {
> +                       if (cpu_wait)
> +                               (*cpu_wait)();

  Please initialize cpu_wait with a default function and just call

       cpu_wait();

> +               }
> +               preempt_enable_no_resched();
> +               schedule();
> +               preempt_disable();
> +       }
> +}
> +
> +asmlinkage void ret_from_fork(void);

  Declarations in header files please

> +void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long 
> sp)
> +{
> +       unsigned long status;
> +
> +       /* New thread loses kernel privileges. */
> +       status = regs->cp0_psr & ~(KU_MASK);
> +       status |= KU_USER;
> +       regs->cp0_psr = status;
> +       regs->cp0_epc = pc;
> +       regs->regs[0] = sp;
> +}
> +
> +void exit_thread(void)
> +{}
> +
> +/*
> + * When a process does an "exec", machine state like FPU and debug
> + * registers need to be reset.  This is a hook function for that.
> + * Currently we don't have any such state to reset, so this is empty.
> + */
> +void flush_thread(void)
> +{}
> +
> +/*
> + * set up the kernel stack and exception frames for a new process
> + */
> +int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
> +       unsigned long stk_sz, struct task_struct *p, struct pt_regs *regs)
> +{
> +       struct thread_info *ti = task_thread_info(p);
> +       struct pt_regs *childregs = task_pt_regs(p);
> +
> +       p->set_child_tid = p->clear_child_tid = NULL;
> +
> +       *childregs = *regs;
> +       childregs->regs[7] = 0;                 /* Clear error flag */
> +       childregs->regs[4] = 0;                 /* Child gets zero as 
> return value */
> +       regs->regs[4] = p->pid;
> +
> +       if (childregs->cp0_psr & 0x8)           /* test kernel fork or 
> user fork */
> +               childregs->regs[0] = usp;               /* user fork */
> +       else {
> +               childregs->regs[28] = (unsigned long) ti; /* kernel fork 
> */
> +               childregs->regs[0] = (unsigned long) childregs;
> +       }
> +       p->thread.reg0 = (unsigned long) childregs;
> +       p->thread.reg3 = (unsigned long) ret_from_fork;
> +       p->thread.cp0_psr = 0;
> +
> +       return 0;
> +}
> +
> +/* Fill in the fpu structure for a core dump. */
> +int dump_fpu(struct pt_regs *regs, elf_fpregset_t *r)
> +{
> +       return 1;
> +}
> +
> +void elf_dump_regs(elf_greg_t *gp, struct pt_regs *regs)
> +{}
> +
> +int dump_task_regs(struct task_struct *tsk, elf_gregset_t *regs)
> +{
> +       return 1;
> +}
> +
> +static void __noreturn kernel_thread_helper(void *unused0, int (*fn)(void 
> *), void *arg, void *unused1)
> +{
> +       do_exit(fn(arg));
> +}
> +
> +/*
> + * Create a kernel thread.
> + */
> +long kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
> +{
> +       struct pt_regs regs;
> +
> +       memset(&regs, 0, sizeof(regs));
> +
> +       regs.regs[6] = (unsigned long) arg;
> +       regs.regs[5] = (unsigned long) fn;
> +       regs.cp0_epc = (unsigned long) kernel_thread_helper;
> +       regs.cp0_psr = (regs.cp0_psr & ~(0x1|0x4|0x8)) | (regs.cp0_psr & 
> 0x3) <<2;
> +
> +       return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, 
> NULL, NULL);
> +}
> +
> +unsigned long thread_saved_pc(struct task_struct *tsk)
> +{
> +       return task_pt_regs(tsk)->cp0_epc;
> +}
> +
> +unsigned long get_wchan(struct task_struct *task)
> +{
> +       unsigned long pc = 0;
> +
> +       if (!task || task == current || task->state == TASK_RUNNING)
> +               goto out;

  No goto needed. A simple return 0 is sufficient.

> +       if (!task_stack_page(task))
> +               goto out;

  Ditto

> +       pc = task_pt_regs(task)->cp0_epc;

  Then this becomes

  return task_pt_regs....;

> +out:
> +       return pc;
> +}
> +

Thanks,

	tglx
