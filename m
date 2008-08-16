Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbYHPR12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbYHPR12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 13:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYHPR1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 13:27:20 -0400
Received: from gw.goop.org ([64.81.55.164]:44644 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYHPR1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 13:27:19 -0400
Message-ID: <48A70DF4.5040901@goop.org>
Date: Sat, 16 Aug 2008 10:27:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Gary Shi <garyu.shi@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: freeze other CPUs during sysrq-t
References: <7b97a12b0808151738s7f1a166es51c5f26bd25285c0@mail.gmail.com>
In-Reply-To: <7b97a12b0808151738s7f1a166es51c5f26bd25285c0@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Shi wrote:
> Any comments  about the patches?
>   

Why not use stop_machine()?

    J

> Thanx
> -gys
>
> pls cc me when you reply since I haven't subscribed to the mailing list.
> ---
>
> Signed-off-by: Gary Shi <garyu.shi@xxxxxxxxxxxx>
> ---
> arch/x86/kernel/smp_64.c  |   55 +++++++++++++++++++++++++++++++++++++++
> include/asm-x86/sysrq-t.h |    9 ++++++
> include/linux/smp.h       |    3 ++
> kernel/sched.c            |   62 +++++++++++++++++++++++++++++++++++++++++++-
> 4 files changed, 127 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
> index 03fa6ed..af0fab3 100644
> --- a/arch/x86/kernel/smp_64.c
> +++ b/arch/x86/kernel/smp_64.c
> @@ -300,6 +300,7 @@ void smp_send_reschedule(int cpu)
>   * static memory requirements. It also looks cleaner.
>   */
> static DEFINE_SPINLOCK(call_lock);
> +static int call_lock_locked_by_freezer;
>
> struct call_data_struct {
>      void (*func) (void *info);
> @@ -531,3 +532,57 @@ asmlinkage void smp_call_function_interrupt(void)
>      }
> }
>
> +/*
> + * sysrq_t version of smp_call_function to avoid deadlock in call_lock
> + */
> +void sysrq_t_smp_call_function (void (*func) (void *info), void *info)
> +{
> +    static struct call_data_struct dumpdata;
> +    static int dumping_cpu = -1;
> +    int waitcount = 0;
> +
> +    call_lock_locked_by_freezer = 1;
> +
> +    dumping_cpu = smp_processor_id();
> +
> +    /*
> +    *Enable irq to avoid the deadlock of call_lock
> +    *since the local irq is disabled in __handle_sysrq
> +    */
> +    local_irq_enable();
> +
> +    /*
> +    * Try to get call_lock or wait for 2 second to let ipis settle down.
> +    * If we can't get call_lock, then no one else can get it either;
> +    * so its safe to issue ipi now.
> +    * And at worst if some cpus are locked up, we just go ahead.
> +    */
> +    while (!spin_trylock(&call_lock)) {
> +        if (waitcount++ > 2000) {
> +            call_lock_locked_by_freezer = 0;
> +            break;
> +        }
> +        udelay(1000);
> +        barrier();
> +    }
> +
> +    local_irq_disable();
> +    dumpdata.func = func;
> +    dumpdata.info = info;
> +    dumpdata.wait = 0; /* not used */
> +    atomic_set(&dumpdata.started, 0); /* not used */
> +    atomic_set(&dumpdata.finished, 0); /* not used */
> +
> +    call_data = &dumpdata;
> +    wmb();
> +    send_IPI_allbutself(CALL_FUNCTION_VECTOR);
> +}
> +EXPORT_SYMBOL(sysrq_t_smp_call_function);
> +
> +void sysrq_t_unlock_call_lock(void)
> +{
> +    if (call_lock_locked_by_freezer)
> +        spin_unlock(&call_lock);
> +
> +}
> +EXPORT_SYMBOL(sysrq_t_unlock_call_lock);
> diff --git a/include/asm-x86/sysrq-t.h b/include/asm-x86/sysrq-t.h
> new file mode 100644
> index 0000000..a523023
> --- /dev/null
> +++ b/include/asm-x86/sysrq-t.h
> @@ -0,0 +1,9 @@
> +
> +#define platform_freeze_cpu()     \
> +{        \
> +    local_irq_disable();    \
> +    while (freezer)        \
> +        cpu_relax();    \
> +    local_irq_enable();     \
> +}
> +
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index c25e66b..41aeb54 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -57,6 +57,9 @@ int smp_call_function(void(*func)(void *info), void
> *info, int retry, int wait);
> int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
>                  int retry, int wait);
>
> +extern void sysrq_t_smp_call_function(void(*func)(void *info), void *info);
> +extern void sysrq_t_unlock_call_lock(void);
> +
> /*
>   * Call a function on all processors
>   */
> diff --git a/kernel/sched.c b/kernel/sched.c
> index e76b11c..fe3a963 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -66,6 +66,7 @@
>
> #include <asm/tlb.h>
> #include <asm/irq_regs.h>
> +#include <asm/sysrq-t.h>
>
> /*
>   * Scheduler clock - returns current time in nanosec units.
> @@ -4920,8 +4921,62 @@ static void show_task(struct task_struct *p)
>      printk(KERN_CONT "%5lu %5d %6d\n", free,
>          task_pid_nr(p), task_pid_nr(p->real_parent));
>
> -    if (state != TASK_RUNNING)
> -        show_stack(p, NULL);
> +    show_stack(p, NULL);
> +}
> +
> +static struct task_struct *sysrq_tasks[NR_CPUS];
> +
> +#define sysrq_t_mdelay(n)       \
> +({         \
> +    unsigned long __ms = (n);      \
> +    while (__ms--) {     \
> +    udelay(1000);     \
> +    barrier();    \
> +    touch_nmi_watchdog();    \
> +    }       \
> +})
> +
> +static int freezer;
> +
> +#if CONFIG_SMP
> +static void freeze_cpu(void *dummy)
> +{
> +    unsigned int cpu = smp_processor_id();
> +    sysrq_tasks[cpu] = current;
> +    platform_freeze_cpu();
> +}
> +#else
> +#define freeze_cpu(void *dummy) do { } while (0)
> +#endif
> +
> +
> +static void freeze_other_cpus_temporarily(void)
> +{
> +#if CONFIG_SMP
> +    int i;
> +    freezer = 1;
> +
> +    sysrq_t_smp_call_function(freeze_cpu, NULL);
> +
> +    /* wait for 3 seconds to give more time for other cpus' freezing */
> +    sysrq_t_mdelay(3000);
> +    printk(KERN_INFO "CPUs frozen: ");
> +    for (i = 0; i < NR_CPUS; i++) {
> +        if (sysrq_tasks[i] != NULL)
> +            printk(KERN_INFO "#%d(pid: %d) ",
> +                i, sysrq_tasks[i]->pid);
> +
> +    }
> +    printk("\n");
> +    printk(KERN_INFO "CPU#%d is executing sysrq-t(pid: %d).\n",
> +        smp_processor_id(), current->pid);
> +#endif
> +}
> +
> +static void defreeze_other_cpus(void)
> +{
> +    freezer = 0;
> +    sysrq_t_unlock_call_lock();
> }
>
> void show_state_filter(unsigned long state_filter)
> @@ -4936,6 +4991,7 @@ void show_state_filter(unsigned long state_filter)
>          "  task                        PC stack   pid father\n");
> #endif
>      read_lock(&tasklist_lock);
> +    freeze_other_cpus_temporarily();
>      do_each_thread(g, p) {
>          /*
>           * reset the NMI-timeout, listing all files on a slow
> @@ -4957,8 +5013,10 @@ void show_state_filter(unsigned long state_filter)
>       */
>      if (state_filter == -1)
>          debug_show_all_locks();
> +    defreeze_other_cpus();
> }
>
> +
> void __cpuinit init_idle_bootup_task(struct task_struct *idle)
> {
>      idle->sched_class = &idle_sched_class;
>
> ---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

