Return-Path: <linux-kernel-owner+w=401wt.eu-S1760755AbYEUTVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755AbYEUTVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYEUTVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:21:45 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:18354 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbYEUTVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=wmevyj4kH16N/hPe4ke4hGuFuj+XwVOOp2aI0MDut1G9GAkMuAw17U1UJ2jUtNUDeHVlB1uQIHGe0+O6NYW6vefnWoKNQjLa8K2cGLrxINQnN/6VnUrWnTvnthE5bN5ODGn+ro+nWcdDERn6bGWKUck7YJ3p1UNkZeaKSdcva9E=
Date: Wed, 21 May 2008 23:21:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jirislaby@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86: merging nmi 32/64 to nmi.c v2
Message-ID: <20080521192129.GE6932@cvg>
References: <20080521163051.GB6932@cvg> <483467E1.6090808@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483467E1.6090808@ct.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hiroshi Shimamoto - Wed, May 21, 2008 at 11:20:17AM -0700]
| Cyrill Gorcunov wrote:
| > This is a second attempt to merge nmi-32/64 to nmi.c
| 
| Hi Cyrill,
| 
| cool work!
| 
| > Summary changes:
| > 
| ...
| > - last_irq_sums and alert_counter was defined as static arrays in 32bit
| >   mode, so they were changed to per_cpu variables
| 
| This was already done, see http://lkml.org/lkml/2008/5/2/525.
| But it doesn't affect the unified file.
| 
| > +#ifdef CONFIG_X86_64
| > +static unsigned ignore_nmis;
| > +
| > +asmlinkage notrace __kprobes void
| > +do_nmi(struct pt_regs *regs, long error_code)
| > +{
| > +	nmi_enter();
| > +	add_pda(__nmi_count,1);
| > +	if (!ignore_nmis)
| > +		default_do_nmi(regs);
| > +	nmi_exit();
| > +}
| > +
| > +void stop_nmi(void)
| > +{
| > +	acpi_nmi_disable();
| > +	ignore_nmis++;
| > +}
| > +
| > +void restart_nmi(void)
| > +{
| > +	ignore_nmis--;
| > +	acpi_nmi_enable();
| > +}
| > +#endif /* CONFIG_X86_64 */
| 
| I'm guessing we can move these functions to traps_64.c.
| I've tried to move these functions from traps_32.c to nmi_32.c,
| but it caused build error on some 32bit configs.
| 
| thanks,
| Hiroshi Shimamoto
| 

Here is updated version (thanks Hiroshi) - I've moved these funcs
to traps_64.c and it's compiled just fine (so we are going closer
to merge someday even traps-32/64 ;)

---

 arch/x86/kernel/Makefile   |    2 +-
 arch/x86/kernel/nmi.c      |  551 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/nmi_32.c   |  472 -------------------------------------
 arch/x86/kernel/nmi_64.c   |  482 --------------------------------------
 arch/x86/kernel/traps_32.c |    8 +-
 arch/x86/kernel/traps_64.c |   28 +++-
 include/asm-x86/nmi.h      |    6 +-
 7 files changed, 586 insertions(+), 963 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5e618c3..d5dd666 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -53,7 +53,7 @@ obj-$(CONFIG_X86_32_SMP)	+= smpcommon.o
 obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_$(BITS).o nmi_$(BITS).o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic_$(BITS).o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic_$(BITS).o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
new file mode 100644
index 0000000..c025c79
--- /dev/null
+++ b/arch/x86/kernel/nmi.c
@@ -0,0 +1,551 @@
+/*
+ *  NMI watchdog support on APIC systems
+ *
+ *  Started by Ingo Molnar <mingo@redhat.com>
+ *
+ *  Fixes:
+ *  Mikael Pettersson	: AMD K7 support for local APIC NMI watchdog.
+ *  Mikael Pettersson	: Power Management for local APIC NMI watchdog.
+ *  Mikael Pettersson	: Pentium 4 support for local APIC NMI watchdog.
+ *  Pavel Machek and
+ *  Mikael Pettersson	: PM converted to driver model. Disable/enable API.
+ */
+
+#include <linux/nmi.h>
+#include <linux/mm.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/sysdev.h>
+#include <linux/sysctl.h>
+#include <linux/kprobes.h>
+#include <linux/cpumask.h>
+#include <linux/kdebug.h>
+#include <linux/kernel_stat.h>
+
+#include <asm/smp.h>
+#include <asm/nmi.h>
+#include <asm/proto.h>
+#include <asm/mce.h>
+#include <asm/timer.h>
+
+#include <mach_traps.h>
+
+int unknown_nmi_panic;
+int nmi_watchdog_enabled;
+
+static int panic_on_timeout;
+
+static cpumask_t backtrace_mask = CPU_MASK_NONE;
+
+/*
+ * nmi_active
+ * >0: the lapic NMI watchdog is active, but can be disabled
+ * <0: the lapic NMI watchdog has not been set up, and cannot
+ *     be enabled
+ *  0: the lapic NMI watchdog is disabled, but can be enabled
+ */
+atomic_t nmi_active = ATOMIC_INIT(0);	/* oprofile uses this */
+unsigned int nmi_watchdog = NMI_DEFAULT;
+
+static DEFINE_PER_CPU(short, wd_enabled);
+static unsigned int nmi_hz = HZ;
+static int endflag __initdata = 0;
+
+static inline unsigned int get_nmi_count(int cpu)
+{
+#ifdef CONFIG_X86_64
+	return cpu_pda(cpu)->__nmi_count;
+#else
+	return nmi_count(cpu);
+#endif
+}
+
+static inline int mce_in_progress(void)
+{
+#if defined(CONFIX_X86_64) && defined(CONFIG_X86_MCE)
+	return atomic_read(&mce_entry) > 0;
+#endif
+	return 0;
+}
+
+/*
+ * Take the local apic timer and PIT/HPET into account. We don't
+ * know which one is active, when we have highres/dyntick on
+ */
+static inline unsigned int get_timer_irqs(int cpu)
+{
+#ifdef CONFIG_X86_64
+	return read_pda(apic_timer_irqs) + read_pda(irq0_irqs);
+#else
+	return per_cpu(irq_stat, cpu).apic_timer_irqs +
+		per_cpu(irq_stat, cpu).irq0_irqs;
+#endif
+}
+
+/* Run after command line and cpu_init init, but before all other checks */
+void nmi_watchdog_default(void)
+{
+	if (nmi_watchdog != NMI_DEFAULT)
+		return;
+#ifdef CONFIG_X86_64
+	nmi_watchdog = NMI_NONE;
+#else
+	if (lapic_watchdog_ok())
+		nmi_watchdog = NMI_LOCAL_APIC;
+	else
+		nmi_watchdog = NMI_IO_APIC;
+#endif
+}
+
+#ifdef CONFIG_SMP
+/*
+ * The performance counters used by NMI_LOCAL_APIC don't trigger when
+ * the CPU is idle. To make sure the NMI watchdog really ticks on all
+ * CPUs during the test make them busy.
+ */
+static __init void nmi_cpu_busy(void *data)
+{
+	local_irq_enable_in_hardirq();
+	/*
+	 * Intentionally don't use cpu_relax here. This is
+	 * to make sure that the performance counter really ticks,
+	 * even if there is a simulator or similar that catches the
+	 * pause instruction. On a real HT machine this is fine because
+	 * all other CPUs are busy with "useless" delay loops and don't
+	 * care if they get somewhat less cycles.
+	 */
+	while (endflag == 0)
+		mb();
+}
+#endif /* CONFIG_SMP */
+
+int __init check_nmi_watchdog(void)
+{
+	unsigned int *prev_nmi_count;
+	int cpu;
+
+	if (nmi_watchdog == NMI_NONE || nmi_watchdog == NMI_DISABLED)
+		return 0;
+
+	if (!atomic_read(&nmi_active))
+		return 0;
+
+	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
+	if (!prev_nmi_count)
+		goto error;
+
+	printk(KERN_INFO "Testing NMI watchdog ... ");
+
+#ifdef CONFIG_SMP
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
+#endif
+
+	for_each_possible_cpu(cpu)
+		prev_nmi_count[cpu] = get_nmi_count(cpu);
+
+	local_irq_enable();
+	mdelay((20 * 1000) / nmi_hz); /* wait for 20 ticks */
+
+	for_each_online_cpu(cpu) {
+		if (!per_cpu(wd_enabled, cpu))
+			continue;
+		if (get_nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
+			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
+				"appears to be stuck (%d->%d)!\n",
+				cpu,
+				prev_nmi_count[cpu],
+				get_nmi_count(cpu));
+			per_cpu(wd_enabled, cpu) = 0;
+			atomic_dec(&nmi_active);
+		}
+	}
+	endflag = 1;
+	if (!atomic_read(&nmi_active)) {
+		kfree(prev_nmi_count);
+		atomic_set(&nmi_active, -1);
+		goto error;
+	}
+	printk("OK.\n");
+
+	/*
+	 * now that we know it works we can reduce NMI frequency to
+	 * something more reasonable; makes a difference in some configs
+	 */
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		nmi_hz = lapic_adjust_nmi_hz(1);
+
+	kfree(prev_nmi_count);
+	return 0;
+
+error:
+#ifdef CONFIG_X86_32
+	timer_ack = !cpu_has_tsc;
+#endif
+	return -1;
+}
+
+static int __init setup_nmi_watchdog(char *str)
+{
+	int nmi;
+
+	if (!strncmp(str, "panic", 5)) {
+		panic_on_timeout = 1;
+		str = strchr(str, ',');
+		if (!str)
+			return 1;
+		++str;
+	}
+
+	get_option(&str, &nmi);
+	if (nmi >= NMI_INVALID || nmi < NMI_NONE)
+		return 0;
+
+	nmi_watchdog = nmi;
+
+	return 1;
+}
+__setup("nmi_watchdog=", setup_nmi_watchdog);
+
+/* Suspend/resume support */
+#ifdef CONFIG_PM
+
+static int nmi_pm_active; /* nmi_active before suspend */
+
+static int lapic_nmi_suspend(struct sys_device *dev, pm_message_t state)
+{
+	/* only CPU0 goes here, other CPUs should be offline */
+	nmi_pm_active = atomic_read(&nmi_active);
+	stop_apic_nmi_watchdog(NULL);
+	BUG_ON(atomic_read(&nmi_active) != 0);
+	return 0;
+}
+
+static int lapic_nmi_resume(struct sys_device *dev)
+{
+	/* only CPU0 goes here, other CPUs should be offline */
+	if (nmi_pm_active > 0) {
+		setup_apic_nmi_watchdog(NULL);
+		touch_nmi_watchdog();
+	}
+	return 0;
+}
+
+static struct sysdev_class nmi_sysclass = {
+	.name		= "lapic_nmi",
+	.resume		= lapic_nmi_resume,
+	.suspend	= lapic_nmi_suspend,
+};
+
+static struct sys_device device_lapic_nmi = {
+	.id	= 0,
+	.cls	= &nmi_sysclass,
+};
+
+static int __init init_lapic_nmi_sysfs(void)
+{
+	int error;
+
+	/*
+	 * should really be a BUG_ON but b/c this is an
+	 * init call, it just doesn't work.  -dcz
+	 */
+	if (nmi_watchdog != NMI_LOCAL_APIC)
+		return 0;
+
+	if (atomic_read(&nmi_active) < 0)
+		return 0;
+
+	error = sysdev_class_register(&nmi_sysclass);
+	if (!error)
+		error = sysdev_register(&device_lapic_nmi);
+
+	return error;
+}
+/* must come after the local APIC's device_initcall() */
+late_initcall(init_lapic_nmi_sysfs);
+
+#endif	/* CONFIG_PM */
+
+static void __acpi_nmi_enable(void *__unused)
+{
+	apic_write_around(APIC_LVT0, APIC_DM_NMI);
+}
+
+/* Enable timer based NMIs on all CPUs */
+void acpi_nmi_enable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+}
+
+static void __acpi_nmi_disable(void *__unused)
+{
+	apic_write_around(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
+}
+
+/* Disable timer based NMIs on all CPUs */
+void acpi_nmi_disable(void)
+{
+	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
+		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+}
+
+void setup_apic_nmi_watchdog(void *unused)
+{
+	if (__get_cpu_var(wd_enabled))
+		return;
+
+	/* cheap hack to support suspend/resume */
+	/* if cpu0 is not active neither should the other cpus */
+	if (smp_processor_id() != 0 && atomic_read(&nmi_active) <= 0)
+		return;
+
+	switch (nmi_watchdog) {
+	case NMI_LOCAL_APIC:
+		__get_cpu_var(wd_enabled) = 1;
+		if (lapic_watchdog_init(nmi_hz) < 0) {
+			__get_cpu_var(wd_enabled) = 0;
+			return;
+		}
+		/* FALL THROUGH */
+	case NMI_IO_APIC:
+		__get_cpu_var(wd_enabled) = 1;
+		atomic_inc(&nmi_active);
+	}
+}
+
+void stop_apic_nmi_watchdog(void *unused)
+{
+	/* only support LOCAL and IO APICs for now */
+	if (nmi_watchdog != NMI_LOCAL_APIC &&
+	    nmi_watchdog != NMI_IO_APIC)
+	    	return;
+	if (__get_cpu_var(wd_enabled) == 0)
+		return;
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		lapic_watchdog_stop();
+	__get_cpu_var(wd_enabled) = 0;
+	atomic_dec(&nmi_active);
+}
+
+/*
+ * the best way to detect whether a CPU has a 'hard lockup' problem
+ * is to check it's local APIC timer IRQ counts. If they are not
+ * changing then that CPU has some problem.
+ *
+ * as these watchdog NMI IRQs are generated on every CPU, we only
+ * have to check the current processor.
+ *
+ * since NMIs don't listen to _any_ locks, we have to be extremely
+ * careful not to rely on unsafe variables. The printk might lock
+ * up though, so we have to break up any console locks first ...
+ * [when there will be more tty-related locks, break them up here too!]
+ */
+
+static DEFINE_PER_CPU(unsigned, last_irq_sum);
+static DEFINE_PER_CPU(local_t, alert_counter);
+static DEFINE_PER_CPU(int, nmi_touch);
+
+void touch_nmi_watchdog(void)
+{
+	if (nmi_watchdog > 0) {
+		unsigned cpu;
+
+		/*
+ 		 * Tell other CPUs to reset their alert counters. We cannot
+		 * do it ourselves because the alert count increase is not
+		 * atomic
+		 */
+		for_each_present_cpu(cpu) {
+			if (per_cpu(nmi_touch, cpu) != 1)
+				per_cpu(nmi_touch, cpu) = 1;
+		}
+	}
+
+	/* Tickle the softlockup detector too */
+	touch_softlockup_watchdog();
+}
+EXPORT_SYMBOL(touch_nmi_watchdog);
+
+notrace __kprobes int
+nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
+{
+	/*
+	 * Since current_thread_info()-> is always on the stack, and we
+	 * always switch the stack NMI-atomically, it's safe to use
+	 * smp_processor_id()
+	 */
+	unsigned int sum;
+	int touched = 0;
+	int cpu = smp_processor_id();
+	int rc = 0;
+
+	/* check for other users first */
+	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
+			== NOTIFY_STOP) {
+		rc = 1;
+		touched = 1;
+	}
+
+	sum = get_timer_irqs(cpu);
+
+	if (__get_cpu_var(nmi_touch)) {
+		__get_cpu_var(nmi_touch) = 0;
+		touched = 1;
+	}
+
+	if (cpu_isset(cpu, backtrace_mask)) {
+		static DEFINE_SPINLOCK(lock);
+		spin_lock(&lock);
+		printk("NMI backtrace for cpu %d\n", cpu);
+		dump_stack();
+		spin_unlock(&lock);
+		cpu_clear(cpu, backtrace_mask);
+	}
+
+	/*
+	 * Could check oops_in_progress here too,
+	 * but it's safer not to do
+	 */
+	if (mce_in_progress())
+		touched = 1;
+
+	/* if the none of the timers isn't firing, this cpu isn't doing much */
+	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
+		/*
+		 * Ayiee, looks like this CPU is stuck ...
+		 * wait a few IRQs (5 seconds) before doing the oops ...
+		 */
+		local_inc(&__get_cpu_var(alert_counter));
+		if (local_read(&__get_cpu_var(alert_counter)) == 5 * nmi_hz)
+			die_nmi("NMI Watchdog detected LOCKUP\n",
+				regs, panic_on_timeout);
+	} else {
+		__get_cpu_var(last_irq_sum) = sum;
+		local_set(&__get_cpu_var(alert_counter), 0);
+	}
+
+	/* see if the nmi watchdog went off */
+	if (!__get_cpu_var(wd_enabled))
+		return rc;
+
+	switch (nmi_watchdog) {
+	case NMI_LOCAL_APIC:
+		rc |= lapic_wd_event(nmi_hz);
+		break;
+	case NMI_IO_APIC:
+		/*
+		 * don't know how to accurately check for this.
+		 * just assume it was a watchdog timer interrupt
+		 * This matches the old behaviour.
+		 */
+		rc = 1;
+		break;
+	}
+
+	return rc;
+}
+
+#ifdef CONFIG_X86_64
+static unsigned ignore_nmis;
+
+asmlinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
+{
+	nmi_enter();
+	add_pda(__nmi_count,1);
+	if (!ignore_nmis)
+		default_do_nmi(regs);
+	nmi_exit();
+}
+
+void stop_nmi(void)
+{
+	acpi_nmi_disable();
+	ignore_nmis++;
+}
+
+void restart_nmi(void)
+{
+	ignore_nmis--;
+	acpi_nmi_enable();
+}
+#endif /* CONFIG_X86_64 */
+
+#ifdef CONFIG_SYSCTL
+
+static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
+{
+	unsigned char reason = get_nmi_reason();
+	char buf[64];
+
+	sprintf(buf, "NMI received for unknown reason %02x\n", reason);
+	die_nmi(buf, regs, 1);
+	return 0;
+}
+
+/*
+ * proc handler for /proc/sys/kernel/nmi
+ */
+int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
+			void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int old_state;
+
+	nmi_watchdog_enabled = (atomic_read(&nmi_active) > 0) ? 1 : 0;
+	old_state = nmi_watchdog_enabled;
+	proc_dointvec(table, write, file, buffer, length, ppos);
+	if (!!old_state == !!nmi_watchdog_enabled)
+		return 0;
+
+	if (atomic_read(&nmi_active) < 0 || nmi_watchdog == NMI_DISABLED) {
+		printk(KERN_WARNING
+			"NMI watchdog is permanently disabled\n");
+		return -EIO;
+	}
+
+	/* if nmi_watchdog is not set yet, then set it */
+	nmi_watchdog_default();
+
+	if (nmi_watchdog == NMI_LOCAL_APIC) {
+		if (nmi_watchdog_enabled)
+			enable_lapic_nmi_watchdog();
+		else
+			disable_lapic_nmi_watchdog();
+	} else {
+		printk(KERN_WARNING
+			"NMI watchdog doesn't know what hardware to touch\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+#endif /* CONFIG_SYSCTL */
+
+int do_nmi_callback(struct pt_regs *regs, int cpu)
+{
+#ifdef CONFIG_SYSCTL
+	if (unknown_nmi_panic)
+		return unknown_nmi_panic_callback(regs, cpu);
+#endif
+	return 0;
+}
+
+void __trigger_all_cpu_backtrace(void)
+{
+	int i;
+
+	backtrace_mask = cpu_online_map;
+	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
+	for (i = 0; i < 10 * 1000; i++) {
+		if (cpus_empty(backtrace_mask))
+			break;
+		mdelay(1);
+	}
+}
+
+EXPORT_SYMBOL(nmi_active);
+EXPORT_SYMBOL(nmi_watchdog);
+
diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
deleted file mode 100644
index 11b14bb..0000000
--- a/arch/x86/kernel/nmi_32.c
+++ /dev/null
@@ -1,472 +0,0 @@
-/*
- *  NMI watchdog support on APIC systems
- *
- *  Started by Ingo Molnar <mingo@redhat.com>
- *
- *  Fixes:
- *  Mikael Pettersson	: AMD K7 support for local APIC NMI watchdog.
- *  Mikael Pettersson	: Power Management for local APIC NMI watchdog.
- *  Mikael Pettersson	: Pentium 4 support for local APIC NMI watchdog.
- *  Pavel Machek and
- *  Mikael Pettersson	: PM converted to driver model. Disable/enable API.
- */
-
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/nmi.h>
-#include <linux/sysdev.h>
-#include <linux/sysctl.h>
-#include <linux/percpu.h>
-#include <linux/kprobes.h>
-#include <linux/cpumask.h>
-#include <linux/kernel_stat.h>
-#include <linux/kdebug.h>
-#include <linux/slab.h>
-
-#include <asm/smp.h>
-#include <asm/nmi.h>
-#include <asm/timer.h>
-
-#include "mach_traps.h"
-
-int unknown_nmi_panic;
-int nmi_watchdog_enabled;
-
-static cpumask_t backtrace_mask = CPU_MASK_NONE;
-
-/* nmi_active:
- * >0: the lapic NMI watchdog is active, but can be disabled
- * <0: the lapic NMI watchdog has not been set up, and cannot
- *     be enabled
- *  0: the lapic NMI watchdog is disabled, but can be enabled
- */
-atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
-
-unsigned int nmi_watchdog = NMI_DEFAULT;
-static unsigned int nmi_hz = HZ;
-
-static DEFINE_PER_CPU(short, wd_enabled);
-
-static int endflag __initdata = 0;
-
-#ifdef CONFIG_SMP
-/* The performance counters used by NMI_LOCAL_APIC don't trigger when
- * the CPU is idle. To make sure the NMI watchdog really ticks on all
- * CPUs during the test make them busy.
- */
-static __init void nmi_cpu_busy(void *data)
-{
-	local_irq_enable_in_hardirq();
-	/* Intentionally don't use cpu_relax here. This is
-	   to make sure that the performance counter really ticks,
-	   even if there is a simulator or similar that catches the
-	   pause instruction. On a real HT machine this is fine because
-	   all other CPUs are busy with "useless" delay loops and don't
-	   care if they get somewhat less cycles. */
-	while (endflag == 0)
-		mb();
-}
-#endif
-
-int __init check_nmi_watchdog(void)
-{
-	unsigned int *prev_nmi_count;
-	int cpu;
-
-	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DISABLED))
-		return 0;
-
-	if (!atomic_read(&nmi_active))
-		return 0;
-
-	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
-	if (!prev_nmi_count)
-		goto error;
-
-	printk(KERN_INFO "Testing NMI watchdog ... ");
-
-#ifdef CONFIG_SMP
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
-#endif
-
-	for_each_possible_cpu(cpu)
-		prev_nmi_count[cpu] = nmi_count(cpu);
-	local_irq_enable();
-	mdelay((20*1000)/nmi_hz); // wait 20 ticks
-
-	for_each_possible_cpu(cpu) {
-#ifdef CONFIG_SMP
-		/* Check cpu_callin_map here because that is set
-		   after the timer is started. */
-		if (!cpu_isset(cpu, cpu_callin_map))
-			continue;
-#endif
-		if (!per_cpu(wd_enabled, cpu))
-			continue;
-		if (nmi_count(cpu) - prev_nmi_count[cpu] <= 5) {
-			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
-				"appears to be stuck (%d->%d)!\n",
-				cpu,
-				prev_nmi_count[cpu],
-				nmi_count(cpu));
-			per_cpu(wd_enabled, cpu) = 0;
-			atomic_dec(&nmi_active);
-		}
-	}
-	endflag = 1;
-	if (!atomic_read(&nmi_active)) {
-		kfree(prev_nmi_count);
-		atomic_set(&nmi_active, -1);
-		goto error;
-	}
-	printk("OK.\n");
-
-	/* now that we know it works we can reduce NMI frequency to
-	   something more reasonable; makes a difference in some configs */
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		nmi_hz = lapic_adjust_nmi_hz(1);
-
-	kfree(prev_nmi_count);
-	return 0;
-error:
-	timer_ack = !cpu_has_tsc;
-
-	return -1;
-}
-
-static int __init setup_nmi_watchdog(char *str)
-{
-	int nmi;
-
-	get_option(&str, &nmi);
-
-	if ((nmi >= NMI_INVALID) || (nmi < NMI_NONE))
-		return 0;
-
-	nmi_watchdog = nmi;
-	return 1;
-}
-
-__setup("nmi_watchdog=", setup_nmi_watchdog);
-
-
-/* Suspend/resume support */
-
-#ifdef CONFIG_PM
-
-static int nmi_pm_active; /* nmi_active before suspend */
-
-static int lapic_nmi_suspend(struct sys_device *dev, pm_message_t state)
-{
-	/* only CPU0 goes here, other CPUs should be offline */
-	nmi_pm_active = atomic_read(&nmi_active);
-	stop_apic_nmi_watchdog(NULL);
-	BUG_ON(atomic_read(&nmi_active) != 0);
-	return 0;
-}
-
-static int lapic_nmi_resume(struct sys_device *dev)
-{
-	/* only CPU0 goes here, other CPUs should be offline */
-	if (nmi_pm_active > 0) {
-		setup_apic_nmi_watchdog(NULL);
-		touch_nmi_watchdog();
-	}
-	return 0;
-}
-
-
-static struct sysdev_class nmi_sysclass = {
-	.name		= "lapic_nmi",
-	.resume		= lapic_nmi_resume,
-	.suspend	= lapic_nmi_suspend,
-};
-
-static struct sys_device device_lapic_nmi = {
-	.id	= 0,
-	.cls	= &nmi_sysclass,
-};
-
-static int __init init_lapic_nmi_sysfs(void)
-{
-	int error;
-
-	/* should really be a BUG_ON but b/c this is an
-	 * init call, it just doesn't work.  -dcz
-	 */
-	if (nmi_watchdog != NMI_LOCAL_APIC)
-		return 0;
-
-	if (atomic_read(&nmi_active) < 0)
-		return 0;
-
-	error = sysdev_class_register(&nmi_sysclass);
-	if (!error)
-		error = sysdev_register(&device_lapic_nmi);
-	return error;
-}
-/* must come after the local APIC's device_initcall() */
-late_initcall(init_lapic_nmi_sysfs);
-
-#endif	/* CONFIG_PM */
-
-static void __acpi_nmi_enable(void *__unused)
-{
-	apic_write_around(APIC_LVT0, APIC_DM_NMI);
-}
-
-/*
- * Enable timer based NMIs on all CPUs:
- */
-void acpi_nmi_enable(void)
-{
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
-}
-
-static void __acpi_nmi_disable(void *__unused)
-{
-	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
-}
-
-/*
- * Disable timer based NMIs on all CPUs:
- */
-void acpi_nmi_disable(void)
-{
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
-}
-
-void setup_apic_nmi_watchdog(void *unused)
-{
-	if (__get_cpu_var(wd_enabled))
-		return;
-
-	/* cheap hack to support suspend/resume */
-	/* if cpu0 is not active neither should the other cpus */
-	if ((smp_processor_id() != 0) && (atomic_read(&nmi_active) <= 0))
-		return;
-
-	switch (nmi_watchdog) {
-	case NMI_LOCAL_APIC:
-		__get_cpu_var(wd_enabled) = 1; /* enable it before to avoid race with handler */
-		if (lapic_watchdog_init(nmi_hz) < 0) {
-			__get_cpu_var(wd_enabled) = 0;
-			return;
-		}
-		/* FALL THROUGH */
-	case NMI_IO_APIC:
-		__get_cpu_var(wd_enabled) = 1;
-		atomic_inc(&nmi_active);
-	}
-}
-
-void stop_apic_nmi_watchdog(void *unused)
-{
-	/* only support LOCAL and IO APICs for now */
-	if ((nmi_watchdog != NMI_LOCAL_APIC) &&
-	    (nmi_watchdog != NMI_IO_APIC))
-	    	return;
-	if (__get_cpu_var(wd_enabled) == 0)
-		return;
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		lapic_watchdog_stop();
-	__get_cpu_var(wd_enabled) = 0;
-	atomic_dec(&nmi_active);
-}
-
-/*
- * the best way to detect whether a CPU has a 'hard lockup' problem
- * is to check it's local APIC timer IRQ counts. If they are not
- * changing then that CPU has some problem.
- *
- * as these watchdog NMI IRQs are generated on every CPU, we only
- * have to check the current processor.
- *
- * since NMIs don't listen to _any_ locks, we have to be extremely
- * careful not to rely on unsafe variables. The printk might lock
- * up though, so we have to break up any console locks first ...
- * [when there will be more tty-related locks, break them up
- *  here too!]
- */
-
-static unsigned int
-	last_irq_sums [NR_CPUS],
-	alert_counter [NR_CPUS];
-
-void touch_nmi_watchdog(void)
-{
-	if (nmi_watchdog > 0) {
-		unsigned cpu;
-
-		/*
-		 * Just reset the alert counters, (other CPUs might be
-		 * spinning on locks we hold):
-		 */
-		for_each_present_cpu(cpu) {
-			if (alert_counter[cpu])
-				alert_counter[cpu] = 0;
-		}
-	}
-
-	/*
-	 * Tickle the softlockup detector too:
-	 */
-	touch_softlockup_watchdog();
-}
-EXPORT_SYMBOL(touch_nmi_watchdog);
-
-extern void die_nmi(struct pt_regs *, const char *msg);
-
-notrace __kprobes int
-nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
-{
-
-	/*
-	 * Since current_thread_info()-> is always on the stack, and we
-	 * always switch the stack NMI-atomically, it's safe to use
-	 * smp_processor_id().
-	 */
-	unsigned int sum;
-	int touched = 0;
-	int cpu = smp_processor_id();
-	int rc = 0;
-
-	/* check for other users first */
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-			== NOTIFY_STOP) {
-		rc = 1;
-		touched = 1;
-	}
-
-	if (cpu_isset(cpu, backtrace_mask)) {
-		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
-
-		spin_lock(&lock);
-		printk("NMI backtrace for cpu %d\n", cpu);
-		dump_stack();
-		spin_unlock(&lock);
-		cpu_clear(cpu, backtrace_mask);
-	}
-
-	/*
-	 * Take the local apic timer and PIT/HPET into account. We don't
-	 * know which one is active, when we have highres/dyntick on
-	 */
-	sum = per_cpu(irq_stat, cpu).apic_timer_irqs +
-		per_cpu(irq_stat, cpu).irq0_irqs;
-
-	/* if the none of the timers isn't firing, this cpu isn't doing much */
-	if (!touched && last_irq_sums[cpu] == sum) {
-		/*
-		 * Ayiee, looks like this CPU is stuck ...
-		 * wait a few IRQs (5 seconds) before doing the oops ...
-		 */
-		alert_counter[cpu]++;
-		if (alert_counter[cpu] == 5*nmi_hz)
-			/*
-			 * die_nmi will return ONLY if NOTIFY_STOP happens..
-			 */
-			die_nmi(regs, "BUG: NMI Watchdog detected LOCKUP");
-	} else {
-		last_irq_sums[cpu] = sum;
-		alert_counter[cpu] = 0;
-	}
-	/* see if the nmi watchdog went off */
-	if (!__get_cpu_var(wd_enabled))
-		return rc;
-	switch (nmi_watchdog) {
-	case NMI_LOCAL_APIC:
-		rc |= lapic_wd_event(nmi_hz);
-		break;
-	case NMI_IO_APIC:
-		/* don't know how to accurately check for this.
-		 * just assume it was a watchdog timer interrupt
-		 * This matches the old behaviour.
-		 */
-		rc = 1;
-		break;
-	}
-	return rc;
-}
-
-#ifdef CONFIG_SYSCTL
-
-static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
-{
-	unsigned char reason = get_nmi_reason();
-	char buf[64];
-
-	sprintf(buf, "NMI received for unknown reason %02x\n", reason);
-	die_nmi(regs, buf);
-	return 0;
-}
-
-/*
- * proc handler for /proc/sys/kernel/nmi
- */
-int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
-			void __user *buffer, size_t *length, loff_t *ppos)
-{
-	int old_state;
-
-	nmi_watchdog_enabled = (atomic_read(&nmi_active) > 0) ? 1 : 0;
-	old_state = nmi_watchdog_enabled;
-	proc_dointvec(table, write, file, buffer, length, ppos);
-	if (!!old_state == !!nmi_watchdog_enabled)
-		return 0;
-
-	if (atomic_read(&nmi_active) < 0 || nmi_watchdog == NMI_DISABLED) {
-		printk( KERN_WARNING "NMI watchdog is permanently disabled\n");
-		return -EIO;
-	}
-
-	if (nmi_watchdog == NMI_DEFAULT) {
-		if (lapic_watchdog_ok())
-			nmi_watchdog = NMI_LOCAL_APIC;
-		else
-			nmi_watchdog = NMI_IO_APIC;
-	}
-
-	if (nmi_watchdog == NMI_LOCAL_APIC) {
-		if (nmi_watchdog_enabled)
-			enable_lapic_nmi_watchdog();
-		else
-			disable_lapic_nmi_watchdog();
-	} else {
-		printk( KERN_WARNING
-			"NMI watchdog doesn't know what hardware to touch\n");
-		return -EIO;
-	}
-	return 0;
-}
-
-#endif
-
-int do_nmi_callback(struct pt_regs *regs, int cpu)
-{
-#ifdef CONFIG_SYSCTL
-	if (unknown_nmi_panic)
-		return unknown_nmi_panic_callback(regs, cpu);
-#endif
-	return 0;
-}
-
-void __trigger_all_cpu_backtrace(void)
-{
-	int i;
-
-	backtrace_mask = cpu_online_map;
-	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
-	for (i = 0; i < 10 * 1000; i++) {
-		if (cpus_empty(backtrace_mask))
-			break;
-		mdelay(1);
-	}
-}
-
-EXPORT_SYMBOL(nmi_active);
-EXPORT_SYMBOL(nmi_watchdog);
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
deleted file mode 100644
index 5a29ded..0000000
--- a/arch/x86/kernel/nmi_64.c
+++ /dev/null
@@ -1,482 +0,0 @@
-/*
- *  NMI watchdog support on APIC systems
- *
- *  Started by Ingo Molnar <mingo@redhat.com>
- *
- *  Fixes:
- *  Mikael Pettersson	: AMD K7 support for local APIC NMI watchdog.
- *  Mikael Pettersson	: Power Management for local APIC NMI watchdog.
- *  Pavel Machek and
- *  Mikael Pettersson	: PM converted to driver model. Disable/enable API.
- */
-
-#include <linux/nmi.h>
-#include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/sysdev.h>
-#include <linux/sysctl.h>
-#include <linux/kprobes.h>
-#include <linux/cpumask.h>
-#include <linux/kdebug.h>
-
-#include <asm/smp.h>
-#include <asm/nmi.h>
-#include <asm/proto.h>
-#include <asm/mce.h>
-
-#include <mach_traps.h>
-
-int unknown_nmi_panic;
-int nmi_watchdog_enabled;
-int panic_on_unrecovered_nmi;
-
-static cpumask_t backtrace_mask = CPU_MASK_NONE;
-
-/* nmi_active:
- * >0: the lapic NMI watchdog is active, but can be disabled
- * <0: the lapic NMI watchdog has not been set up, and cannot
- *     be enabled
- *  0: the lapic NMI watchdog is disabled, but can be enabled
- */
-atomic_t nmi_active = ATOMIC_INIT(0);		/* oprofile uses this */
-static int panic_on_timeout;
-
-unsigned int nmi_watchdog = NMI_DEFAULT;
-static unsigned int nmi_hz = HZ;
-
-static DEFINE_PER_CPU(short, wd_enabled);
-
-/* Run after command line and cpu_init init, but before all other checks */
-void nmi_watchdog_default(void)
-{
-	if (nmi_watchdog != NMI_DEFAULT)
-		return;
-	nmi_watchdog = NMI_NONE;
-}
-
-static int endflag __initdata = 0;
-
-#ifdef CONFIG_SMP
-/* The performance counters used by NMI_LOCAL_APIC don't trigger when
- * the CPU is idle. To make sure the NMI watchdog really ticks on all
- * CPUs during the test make them busy.
- */
-static __init void nmi_cpu_busy(void *data)
-{
-	local_irq_enable_in_hardirq();
-	/* Intentionally don't use cpu_relax here. This is
-	   to make sure that the performance counter really ticks,
-	   even if there is a simulator or similar that catches the
-	   pause instruction. On a real HT machine this is fine because
-	   all other CPUs are busy with "useless" delay loops and don't
-	   care if they get somewhat less cycles. */
-	while (endflag == 0)
-		mb();
-}
-#endif
-
-int __init check_nmi_watchdog(void)
-{
-	int *prev_nmi_count;
-	int cpu;
-
-	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DISABLED))
-		return 0;
-
-	if (!atomic_read(&nmi_active))
-		return 0;
-
-	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
-	if (!prev_nmi_count)
-		return -1;
-
-	printk(KERN_INFO "Testing NMI watchdog ... ");
-
-#ifdef CONFIG_SMP
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
-#endif
-
-	for (cpu = 0; cpu < NR_CPUS; cpu++)
-		prev_nmi_count[cpu] = cpu_pda(cpu)->__nmi_count;
-	local_irq_enable();
-	mdelay((20*1000)/nmi_hz); // wait 20 ticks
-
-	for_each_online_cpu(cpu) {
-		if (!per_cpu(wd_enabled, cpu))
-			continue;
-		if (cpu_pda(cpu)->__nmi_count - prev_nmi_count[cpu] <= 5) {
-			printk(KERN_WARNING "WARNING: CPU#%d: NMI "
-			       "appears to be stuck (%d->%d)!\n",
-				cpu,
-				prev_nmi_count[cpu],
-				cpu_pda(cpu)->__nmi_count);
-			per_cpu(wd_enabled, cpu) = 0;
-			atomic_dec(&nmi_active);
-		}
-	}
-	endflag = 1;
-	if (!atomic_read(&nmi_active)) {
-		kfree(prev_nmi_count);
-		atomic_set(&nmi_active, -1);
-		return -1;
-	}
-	printk("OK.\n");
-
-	/* now that we know it works we can reduce NMI frequency to
-	   something more reasonable; makes a difference in some configs */
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		nmi_hz = lapic_adjust_nmi_hz(1);
-
-	kfree(prev_nmi_count);
-	return 0;
-}
-
-static int __init setup_nmi_watchdog(char *str)
-{
-	int nmi;
-
-	if (!strncmp(str,"panic",5)) {
-		panic_on_timeout = 1;
-		str = strchr(str, ',');
-		if (!str)
-			return 1;
-		++str;
-	}
-
-	get_option(&str, &nmi);
-
-	if ((nmi >= NMI_INVALID) || (nmi < NMI_NONE))
-		return 0;
-
-	nmi_watchdog = nmi;
-	return 1;
-}
-
-__setup("nmi_watchdog=", setup_nmi_watchdog);
-
-#ifdef CONFIG_PM
-
-static int nmi_pm_active; /* nmi_active before suspend */
-
-static int lapic_nmi_suspend(struct sys_device *dev, pm_message_t state)
-{
-	/* only CPU0 goes here, other CPUs should be offline */
-	nmi_pm_active = atomic_read(&nmi_active);
-	stop_apic_nmi_watchdog(NULL);
-	BUG_ON(atomic_read(&nmi_active) != 0);
-	return 0;
-}
-
-static int lapic_nmi_resume(struct sys_device *dev)
-{
-	/* only CPU0 goes here, other CPUs should be offline */
-	if (nmi_pm_active > 0) {
-		setup_apic_nmi_watchdog(NULL);
-		touch_nmi_watchdog();
-	}
-	return 0;
-}
-
-static struct sysdev_class nmi_sysclass = {
-	.name		= "lapic_nmi",
-	.resume		= lapic_nmi_resume,
-	.suspend	= lapic_nmi_suspend,
-};
-
-static struct sys_device device_lapic_nmi = {
-	.id	= 0,
-	.cls	= &nmi_sysclass,
-};
-
-static int __init init_lapic_nmi_sysfs(void)
-{
-	int error;
-
-	/* should really be a BUG_ON but b/c this is an
-	 * init call, it just doesn't work.  -dcz
-	 */
-	if (nmi_watchdog != NMI_LOCAL_APIC)
-		return 0;
-
-	if (atomic_read(&nmi_active) < 0)
-		return 0;
-
-	error = sysdev_class_register(&nmi_sysclass);
-	if (!error)
-		error = sysdev_register(&device_lapic_nmi);
-	return error;
-}
-/* must come after the local APIC's device_initcall() */
-late_initcall(init_lapic_nmi_sysfs);
-
-#endif	/* CONFIG_PM */
-
-static void __acpi_nmi_enable(void *__unused)
-{
-	apic_write(APIC_LVT0, APIC_DM_NMI);
-}
-
-/*
- * Enable timer based NMIs on all CPUs:
- */
-void acpi_nmi_enable(void)
-{
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
-}
-
-static void __acpi_nmi_disable(void *__unused)
-{
-	apic_write(APIC_LVT0, APIC_DM_NMI | APIC_LVT_MASKED);
-}
-
-/*
- * Disable timer based NMIs on all CPUs:
- */
-void acpi_nmi_disable(void)
-{
-	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
-}
-
-void setup_apic_nmi_watchdog(void *unused)
-{
-	if (__get_cpu_var(wd_enabled))
-		return;
-
-	/* cheap hack to support suspend/resume */
-	/* if cpu0 is not active neither should the other cpus */
-	if ((smp_processor_id() != 0) && (atomic_read(&nmi_active) <= 0))
-		return;
-
-	switch (nmi_watchdog) {
-	case NMI_LOCAL_APIC:
-		__get_cpu_var(wd_enabled) = 1;
-		if (lapic_watchdog_init(nmi_hz) < 0) {
-			__get_cpu_var(wd_enabled) = 0;
-			return;
-		}
-		/* FALL THROUGH */
-	case NMI_IO_APIC:
-		__get_cpu_var(wd_enabled) = 1;
-		atomic_inc(&nmi_active);
-	}
-}
-
-void stop_apic_nmi_watchdog(void *unused)
-{
-	/* only support LOCAL and IO APICs for now */
-	if ((nmi_watchdog != NMI_LOCAL_APIC) &&
-	    (nmi_watchdog != NMI_IO_APIC))
-	    	return;
-	if (__get_cpu_var(wd_enabled) == 0)
-		return;
-	if (nmi_watchdog == NMI_LOCAL_APIC)
-		lapic_watchdog_stop();
-	__get_cpu_var(wd_enabled) = 0;
-	atomic_dec(&nmi_active);
-}
-
-/*
- * the best way to detect whether a CPU has a 'hard lockup' problem
- * is to check it's local APIC timer IRQ counts. If they are not
- * changing then that CPU has some problem.
- *
- * as these watchdog NMI IRQs are generated on every CPU, we only
- * have to check the current processor.
- */
-
-static DEFINE_PER_CPU(unsigned, last_irq_sum);
-static DEFINE_PER_CPU(local_t, alert_counter);
-static DEFINE_PER_CPU(int, nmi_touch);
-
-void touch_nmi_watchdog(void)
-{
-	if (nmi_watchdog > 0) {
-		unsigned cpu;
-
-		/*
- 		 * Tell other CPUs to reset their alert counters. We cannot
-		 * do it ourselves because the alert count increase is not
-		 * atomic.
-		 */
-		for_each_present_cpu(cpu) {
-			if (per_cpu(nmi_touch, cpu) != 1)
-				per_cpu(nmi_touch, cpu) = 1;
-		}
-	}
-
-	touch_softlockup_watchdog();
-}
-EXPORT_SYMBOL(touch_nmi_watchdog);
-
-notrace __kprobes int
-nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
-{
-	int sum;
-	int touched = 0;
-	int cpu = smp_processor_id();
-	int rc = 0;
-
-	/* check for other users first */
-	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-			== NOTIFY_STOP) {
-		rc = 1;
-		touched = 1;
-	}
-
-	sum = read_pda(apic_timer_irqs) + read_pda(irq0_irqs);
-	if (__get_cpu_var(nmi_touch)) {
-		__get_cpu_var(nmi_touch) = 0;
-		touched = 1;
-	}
-
-	if (cpu_isset(cpu, backtrace_mask)) {
-		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
-
-		spin_lock(&lock);
-		printk("NMI backtrace for cpu %d\n", cpu);
-		dump_stack();
-		spin_unlock(&lock);
-		cpu_clear(cpu, backtrace_mask);
-	}
-
-#ifdef CONFIG_X86_MCE
-	/* Could check oops_in_progress here too, but it's safer
-	   not too */
-	if (atomic_read(&mce_entry) > 0)
-		touched = 1;
-#endif
-	/* if the apic timer isn't firing, this cpu isn't doing much */
-	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
-		/*
-		 * Ayiee, looks like this CPU is stuck ...
-		 * wait a few IRQs (5 seconds) before doing the oops ...
-		 */
-		local_inc(&__get_cpu_var(alert_counter));
-		if (local_read(&__get_cpu_var(alert_counter)) == 5*nmi_hz)
-			die_nmi("NMI Watchdog detected LOCKUP on CPU %d\n", regs,
-				panic_on_timeout);
-	} else {
-		__get_cpu_var(last_irq_sum) = sum;
-		local_set(&__get_cpu_var(alert_counter), 0);
-	}
-
-	/* see if the nmi watchdog went off */
-	if (!__get_cpu_var(wd_enabled))
-		return rc;
-	switch (nmi_watchdog) {
-	case NMI_LOCAL_APIC:
-		rc |= lapic_wd_event(nmi_hz);
-		break;
-	case NMI_IO_APIC:
-		/* don't know how to accurately check for this.
-		 * just assume it was a watchdog timer interrupt
-		 * This matches the old behaviour.
-		 */
-		rc = 1;
-		break;
-	}
-	return rc;
-}
-
-static unsigned ignore_nmis;
-
-asmlinkage notrace __kprobes void
-do_nmi(struct pt_regs *regs, long error_code)
-{
-	nmi_enter();
-	add_pda(__nmi_count,1);
-	if (!ignore_nmis)
-		default_do_nmi(regs);
-	nmi_exit();
-}
-
-void stop_nmi(void)
-{
-	acpi_nmi_disable();
-	ignore_nmis++;
-}
-
-void restart_nmi(void)
-{
-	ignore_nmis--;
-	acpi_nmi_enable();
-}
-
-#ifdef CONFIG_SYSCTL
-
-static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
-{
-	unsigned char reason = get_nmi_reason();
-	char buf[64];
-
-	sprintf(buf, "NMI received for unknown reason %02x\n", reason);
-	die_nmi(buf, regs, 1);	/* Always panic here */
-	return 0;
-}
-
-/*
- * proc handler for /proc/sys/kernel/nmi
- */
-int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
-			void __user *buffer, size_t *length, loff_t *ppos)
-{
-	int old_state;
-
-	nmi_watchdog_enabled = (atomic_read(&nmi_active) > 0) ? 1 : 0;
-	old_state = nmi_watchdog_enabled;
-	proc_dointvec(table, write, file, buffer, length, ppos);
-	if (!!old_state == !!nmi_watchdog_enabled)
-		return 0;
-
-	if (atomic_read(&nmi_active) < 0 || nmi_watchdog == NMI_DISABLED) {
-		printk( KERN_WARNING "NMI watchdog is permanently disabled\n");
-		return -EIO;
-	}
-
-	/* if nmi_watchdog is not set yet, then set it */
-	nmi_watchdog_default();
-
-	if (nmi_watchdog == NMI_LOCAL_APIC) {
-		if (nmi_watchdog_enabled)
-			enable_lapic_nmi_watchdog();
-		else
-			disable_lapic_nmi_watchdog();
-	} else {
-		printk( KERN_WARNING
-			"NMI watchdog doesn't know what hardware to touch\n");
-		return -EIO;
-	}
-	return 0;
-}
-
-#endif
-
-int do_nmi_callback(struct pt_regs *regs, int cpu)
-{
-#ifdef CONFIG_SYSCTL
-	if (unknown_nmi_panic)
-		return unknown_nmi_panic_callback(regs, cpu);
-#endif
-	return 0;
-}
-
-void __trigger_all_cpu_backtrace(void)
-{
-	int i;
-
-	backtrace_mask = cpu_online_map;
-	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
-	for (i = 0; i < 10 * 1000; i++) {
-		if (cpus_empty(backtrace_mask))
-			break;
-		mdelay(1);
-	}
-}
-
-EXPORT_SYMBOL(nmi_active);
-EXPORT_SYMBOL(nmi_watchdog);
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index bde6f63..f31e665 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -755,9 +755,9 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 
 static DEFINE_SPINLOCK(nmi_print_lock);
 
-void notrace __kprobes die_nmi(struct pt_regs *regs, const char *msg)
+void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
 {
-	if (notify_die(DIE_NMIWATCHDOG, msg, regs, 0, 2, SIGINT) == NOTIFY_STOP)
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
 		return;
 
 	spin_lock(&nmi_print_lock);
@@ -766,10 +766,12 @@ void notrace __kprobes die_nmi(struct pt_regs *regs, const char *msg)
 	* to get a message out:
 	*/
 	bust_spinlocks(1);
-	printk(KERN_EMERG "%s", msg);
+	printk(KERN_EMERG "%s", str);
 	printk(" on CPU%d, ip %08lx, registers:\n",
 		smp_processor_id(), regs->ip);
 	show_registers(regs);
+	if (do_panic)
+		panic("Non maskable interrupt");
 	console_silent();
 	spin_unlock(&nmi_print_lock);
 	bust_spinlocks(0);
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index adff76e..e4a3807 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -76,7 +76,9 @@ asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 asmlinkage void spurious_interrupt_bug(void);
 
+int panic_on_unrecovered_nmi;
 static unsigned int code_bytes = 64;
+static unsigned ignore_nmis;
 
 static inline void conditional_sti(struct pt_regs *regs)
 {
@@ -614,7 +616,9 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
 	 * We are in trouble anyway, lets at least try
 	 * to get a message out.
 	 */
-	printk(str, smp_processor_id());
+	printk(KERN_EMERG "%s", str);
+	printk(" on CPU%d, ip %08lx, registers:\n",
+		smp_processor_id(), regs->ip);
 	show_registers(regs);
 	if (kexec_should_crash(current))
 		crash_kexec(regs);
@@ -865,6 +869,28 @@ asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
 		io_check_error(reason, regs);
 }
 
+asmlinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
+{
+	nmi_enter();
+	add_pda(__nmi_count, 1);
+	if (!ignore_nmis)
+		default_do_nmi(regs);
+	nmi_exit();
+}
+
+void stop_nmi(void)
+{
+	acpi_nmi_disable();
+	ignore_nmis++;
+}
+
+void restart_nmi(void)
+{
+	ignore_nmis--;
+	acpi_nmi_enable();
+}
+
 /* runs on IST stack. */
 asmlinkage void __kprobes do_int3(struct pt_regs * regs, long error_code)
 {
diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
index 1e36302..2c5c4be 100644
--- a/include/asm-x86/nmi.h
+++ b/include/asm-x86/nmi.h
@@ -38,12 +38,10 @@ static inline void unset_nmi_pm_callback(struct pm_dev *dev)
 
 #ifdef CONFIG_X86_64
 extern void default_do_nmi(struct pt_regs *);
-extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
-extern void nmi_watchdog_default(void);
-#else
-#define nmi_watchdog_default() do {} while (0)
 #endif
 
+extern void nmi_watchdog_default(void);
+extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
 extern int unknown_nmi_panic;

