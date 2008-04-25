Return-Path: <linux-kernel-owner+w=401wt.eu-S1764359AbYDYXua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764359AbYDYXua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYDYXuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:50:20 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:13604 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbYDYXuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QubTi+eSnxNLH7Gh+eMBtNn3mRSghC6sqEGwwZOXsygFvBVIbB4GrD9JWfLNg+xThlcIErHWslLVoegjKGk6/bw4BFmni96q3Ji33BujQ39wwpd3oPx+pbzoMBcI5ecd4Akt+1GvZyqPqMY8SlZdpzPd3wltiQkyj5ziAKU68Z8=
Message-ID: <dd18b0c30804251650me69a06fi573418ed48a3261d@mail.gmail.com>
Date: Fri, 25 Apr 2008 23:50:17 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: post-2.6.25 locks up hard without any message
Cc: "Pierre Ossman" <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48125094.9070007@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080425175423.4bfd1c7b@mjolnir.drzeus.cx>
	 <48125094.9070007@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 9:43 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 04/25/2008 05:54 PM, Pierre Ossman wrote:
>
> > Something that was merged this window has made my life a bit difficult.
> > My machine (a Thinkpad R61) locks up hard after a few minutes. There is
> > no output on the console and no blinking keyboard leds, so it doesn't
> > look like it's a panic.
> >
>
>  So, are you able to grab console output, e.g. on netconsole? Does sysrq
> keys work in such a situation?
>
>
>
> > My current HEAD is v2.6.25-3530-g94bc891 but I saw it in
> > v2.6.25-2519-g3925e6f as well.
> >
> > Any ideas or is it time for everyone's favourite git tool?
> >
>
>  Well, if it is easily reproducible, then it's one of options to do a
> bisection.
>
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>

You might have what I was experiencing, a complete lock up, I received
a patch from Peter Zijlstra that resolved the issue for me, I pass it
to you:

 arch/x86/kernel/apm_32.c      |    3 +
 arch/x86/kernel/process.c     |  117 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c  |  118 +---------------------------------------
 arch/x86/kernel/process_64.c  |  123 +-----------------------------------------
 drivers/acpi/processor_idle.c |   19 +++---
 include/asm-x86/processor.h   |    1
 6 files changed, 137 insertions(+), 244 deletions(-)

Index: linux-2.6-2/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/process_32.c
+++ linux-2.6-2/arch/x86/kernel/process_32.c
@@ -111,12 +111,10 @@ void default_idle(void)
                */
               smp_mb();

-               local_irq_disable();
-               if (!need_resched()) {
+               if (!need_resched())
                       safe_halt();    /* enables interrupts racelessly */
-                       local_irq_disable();
-               }
-               local_irq_enable();
+               else
+                       local_irq_enable();
               current_thread_info()->status |= TS_POLLING;
       } else {
               local_irq_enable();
@@ -128,17 +126,6 @@ void default_idle(void)
 EXPORT_SYMBOL(default_idle);
 #endif

-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-       local_irq_enable();
-       cpu_relax();
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 #include <asm/nmi.h>
 /* We don't actually take CPU down, just spin without interrupts. */
@@ -196,6 +183,7 @@ void cpu_idle(void)
                       if (cpu_is_offline(cpu))
                               play_dead();

+                       local_irq_disable();
                       __get_cpu_var(irq_stat).idle_timestamp = jiffies;
                       idle();
               }
@@ -206,104 +194,6 @@ void cpu_idle(void)
       }
 }

-static void do_nothing(void *unused)
-{
-}
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
- * pm_idle and update to new pm_idle value. Required while changing pm_idle
- * handler on SMP systems.
- *
- * Caller must have changed pm_idle to the new value before the call. Old
- * pm_idle value will not be used by any CPU after the return of this function.
- */
-void cpu_idle_wait(void)
-{
-       smp_mb();
-       /* kick all the CPUs so that they exit out of pm_idle */
-       smp_call_function(do_nothing, NULL, 0, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
-/*
- * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
- * which can obviate IPI to trigger checking of need_resched.
- * We execute MONITOR against need_resched and enter optimized wait state
- * through MWAIT. Whenever someone changes need_resched, we would be woken
- * up from MWAIT (without an IPI).
- *
- * New with Core Duo processors, MWAIT can take some hints based on CPU
- * capability.
- */
-void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
-{
-       if (!need_resched()) {
-               __monitor((void *)&current_thread_info()->flags, 0, 0);
-               smp_mb();
-               if (!need_resched())
-                       __sti_mwait(ax, cx);
-               else
-                       local_irq_enable();
-       } else
-               local_irq_enable();
-}
-
-/* Default MONITOR/MWAIT with no hints, used for default C1 state */
-static void mwait_idle(void)
-{
-       local_irq_enable();
-       mwait_idle_with_hints(0, 0);
-}
-
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
-{
-       if (force_mwait)
-               return 1;
-       /* Any C1 states supported? */
-       return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
-}
-
-void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
-{
-       static int selected;
-
-       if (selected)
-               return;
-#ifdef CONFIG_X86_SMP
-       if (pm_idle == poll_idle && smp_num_siblings > 1) {
-               printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
-                       " performance may degrade.\n");
-       }
-#endif
-       if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
-               /*
-                * Skip, if setup has overridden idle.
-                * One CPU supports mwait => All CPUs supports mwait
-                */
-               if (!pm_idle) {
-                       printk(KERN_INFO "using mwait in idle threads.\n");
-                       pm_idle = mwait_idle;
-               }
-       }
-       selected = 1;
-}
-
-static int __init idle_setup(char *str)
-{
-       if (!strcmp(str, "poll")) {
-               printk("using polling idle threads.\n");
-               pm_idle = poll_idle;
-       } else if (!strcmp(str, "mwait"))
-               force_mwait = 1;
-       else
-               return -1;
-
-       boot_option_idle_override = 1;
-       return 0;
-}
-early_param("idle", idle_setup);
-
 void __show_registers(struct pt_regs *regs, int all)
 {
       unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
Index: linux-2.6-2/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-2/arch/x86/kernel/process_64.c
@@ -106,26 +106,13 @@ void default_idle(void)
        * test NEED_RESCHED:
        */
       smp_mb();
-       local_irq_disable();
-       if (!need_resched()) {
+       if (!need_resched())
               safe_halt();    /* enables interrupts racelessly */
-               local_irq_disable();
-       }
-       local_irq_enable();
+       else
+               local_irq_enable();
       current_thread_info()->status |= TS_POLLING;
 }

-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-       local_irq_enable();
-       cpu_relax();
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 DECLARE_PER_CPU(int, cpu_state);

@@ -192,110 +179,6 @@ void cpu_idle(void)
       }
 }

-static void do_nothing(void *unused)
-{
-}
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
- * pm_idle and update to new pm_idle value. Required while changing pm_idle
- * handler on SMP systems.
- *
- * Caller must have changed pm_idle to the new value before the call. Old
- * pm_idle value will not be used by any CPU after the return of this function.
- */
-void cpu_idle_wait(void)
-{
-       smp_mb();
-       /* kick all the CPUs so that they exit out of pm_idle */
-       smp_call_function(do_nothing, NULL, 0, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
-/*
- * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
- * which can obviate IPI to trigger checking of need_resched.
- * We execute MONITOR against need_resched and enter optimized wait state
- * through MWAIT. Whenever someone changes need_resched, we would be woken
- * up from MWAIT (without an IPI).
- *
- * New with Core Duo processors, MWAIT can take some hints based on CPU
- * capability.
- */
-void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
-{
-       if (!need_resched()) {
-               __monitor((void *)&current_thread_info()->flags, 0, 0);
-               smp_mb();
-               if (!need_resched())
-                       __mwait(ax, cx);
-       }
-}
-
-/* Default MONITOR/MWAIT with no hints, used for default C1 state */
-static void mwait_idle(void)
-{
-       if (!need_resched()) {
-               __monitor((void *)&current_thread_info()->flags, 0, 0);
-               smp_mb();
-               if (!need_resched())
-                       __sti_mwait(0, 0);
-               else
-                       local_irq_enable();
-       } else {
-               local_irq_enable();
-       }
-}
-
-
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
-{
-       if (force_mwait)
-               return 1;
-       /* Any C1 states supported? */
-       return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
-}
-
-void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
-{
-       static int selected;
-
-       if (selected)
-               return;
-#ifdef CONFIG_X86_SMP
-       if (pm_idle == poll_idle && smp_num_siblings > 1) {
-               printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
-                       " performance may degrade.\n");
-       }
-#endif
-       if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
-               /*
-                * Skip, if setup has overridden idle.
-                * One CPU supports mwait => All CPUs supports mwait
-                */
-               if (!pm_idle) {
-                       printk(KERN_INFO "using mwait in idle threads.\n");
-                       pm_idle = mwait_idle;
-               }
-       }
-       selected = 1;
-}
-
-static int __init idle_setup(char *str)
-{
-       if (!strcmp(str, "poll")) {
-               printk("using polling idle threads.\n");
-               pm_idle = poll_idle;
-       } else if (!strcmp(str, "mwait"))
-               force_mwait = 1;
-       else
-               return -1;
-
-       boot_option_idle_override = 1;
-       return 0;
-}
-early_param("idle", idle_setup);
-
 /* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs * regs)
 {
Index: linux-2.6-2/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6-2.orig/drivers/acpi/processor_idle.c
+++ linux-2.6-2/drivers/acpi/processor_idle.c
@@ -418,13 +418,12 @@ static void acpi_processor_idle(void)

       cx = pr->power.state;
       if (!cx || acpi_idle_suspend) {
-               if (pm_idle_save)
-                       pm_idle_save();
-               else
+               if (pm_idle_save) {
+                       pm_idle_save(); /* enables IRQs */
+               } else {
                       acpi_safe_halt();
-
-               if (irqs_disabled())
                       local_irq_enable();
+               }

               return;
       }
@@ -520,10 +519,12 @@ static void acpi_processor_idle(void)
                * Use the appropriate idle routine, the one that would
                * be used without acpi C-states.
                */
-               if (pm_idle_save)
-                       pm_idle_save();
-               else
+               if (pm_idle_save) {
+                       pm_idle_save(); /* enables IRQs */
+               } else {
                       acpi_safe_halt();
+                       local_irq_enable();
+               }

               /*
                * TBD: Can't get time duration while in C1, as resumes
@@ -534,8 +535,6 @@ static void acpi_processor_idle(void)
                *       skew otherwise.
                */
               sleep_ticks = 0xFFFFFFFF;
-               if (irqs_disabled())
-                       local_irq_enable();

               break;

Index: linux-2.6-2/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6-2/arch/x86/kernel/apm_32.c
@@ -904,6 +904,7 @@ recalc:
                       original_pm_idle();
               else
                       default_idle();
+               local_irq_disable();
               jiffies_since_last_check = jiffies - last_jiffies;
               if (jiffies_since_last_check > idle_period)
                       goto recalc;
@@ -911,6 +912,8 @@ recalc:

       if (apm_idle_done)
               apm_do_busy();
+
+       local_irq_enable();
 }

 /**
Index: linux-2.6-2/include/asm-x86/processor.h
===================================================================
--- linux-2.6-2.orig/include/asm-x86/processor.h
+++ linux-2.6-2/include/asm-x86/processor.h
@@ -723,6 +723,7 @@ static inline void __mwait(unsigned long

 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
+       trace_hardirqs_on();
       /* "mwait %eax, %ecx;" */
       asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
                    :: "a" (eax), "c" (ecx));
Index: linux-2.6-2/arch/x86/kernel/process.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/process.c
+++ linux-2.6-2/arch/x86/kernel/process.c
@@ -4,6 +4,8 @@
 #include <linux/smp.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/pm.h>

 struct kmem_cache *task_xstate_cachep;

@@ -42,3 +44,118 @@ void arch_task_cache_init(void)
                                 __alignof__(union thread_xstate),
                                 SLAB_PANIC, NULL);
 }
+
+static void do_nothing(void *unused)
+{
+}
+
+/*
+ * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
+ * pm_idle and update to new pm_idle value. Required while changing pm_idle
+ * handler on SMP systems.
+ *
+ * Caller must have changed pm_idle to the new value before the call. Old
+ * pm_idle value will not be used by any CPU after the return of this function.
+ */
+void cpu_idle_wait(void)
+{
+       smp_mb();
+       /* kick all the CPUs so that they exit out of pm_idle */
+       smp_call_function(do_nothing, NULL, 0, 1);
+}
+EXPORT_SYMBOL_GPL(cpu_idle_wait);
+
+/*
+ * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
+ * which can obviate IPI to trigger checking of need_resched.
+ * We execute MONITOR against need_resched and enter optimized wait state
+ * through MWAIT. Whenever someone changes need_resched, we would be woken
+ * up from MWAIT (without an IPI).
+ *
+ * New with Core Duo processors, MWAIT can take some hints based on CPU
+ * capability.
+ */
+void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
+{
+       if (!need_resched()) {
+               __monitor((void *)&current_thread_info()->flags, 0, 0);
+               smp_mb();
+               if (!need_resched())
+                       __mwait(ax, cx);
+       }
+}
+
+/* Default MONITOR/MWAIT with no hints, used for default C1 state */
+static void mwait_idle(void)
+{
+       if (!need_resched()) {
+               __monitor((void *)&current_thread_info()->flags, 0, 0);
+               smp_mb();
+               if (!need_resched())
+                       __sti_mwait(0, 0);
+               else
+                       local_irq_enable();
+       } else
+               local_irq_enable();
+}
+
+
+static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+{
+       if (force_mwait)
+               return 1;
+       /* Any C1 states supported? */
+       return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
+}
+
+/*
+ * On SMP it's slightly faster (but much more power-consuming!)
+ * to poll the ->work.need_resched flag instead of waiting for the
+ * cross-CPU IPI to arrive. Use this option with caution.
+ */
+static void poll_idle(void)
+{
+       local_irq_enable();
+       cpu_relax();
+}
+
+void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
+{
+       static int selected;
+
+       if (selected)
+               return;
+#ifdef CONFIG_X86_SMP
+       if (pm_idle == poll_idle && smp_num_siblings > 1) {
+               printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
+                       " performance may degrade.\n");
+       }
+#endif
+       if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
+               /*
+                * Skip, if setup has overridden idle.
+                * One CPU supports mwait => All CPUs supports mwait
+                */
+               if (!pm_idle) {
+                       printk(KERN_INFO "using mwait in idle threads.\n");
+                       pm_idle = mwait_idle;
+               }
+       }
+       selected = 1;
+}
+
+static int __init idle_setup(char *str)
+{
+       if (!strcmp(str, "poll")) {
+               printk("using polling idle threads.\n");
+               pm_idle = poll_idle;
+       } else if (!strcmp(str, "mwait"))
+               force_mwait = 1;
+       else
+               return -1;
+
+       boot_option_idle_override = 1;
+       return 0;
+}
+early_param("idle", idle_setup);
+

I had a hard time using patch -p1 for some reason, and had to manually
put this in, but so far The system has been up for 2 hrs without a
freeze("knock on wood")
Hope this helps you.
regards;


-- 
Justin P. Mattock
