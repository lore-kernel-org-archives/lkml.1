Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYCSUdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYCSUdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757387AbYCSTjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757326AbYCSTjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:19 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 64/79] [PATCH] integrate do_boot_cpu
Date: Wed, 19 Mar 2008 14:25:59 -0300
Message-Id: <1205947862872-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478583657-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This is a very large patch, because it depends on a lot
of auxiliary static functions. But they all have been modified
to the point that they're sufficiently close now. So they're just
merged in smpboot.c

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |  588 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |  532 +-------------------------------------
 arch/x86/kernel/smpboot_64.c |  515 +------------------------------------
 include/asm-x86/smp.h        |    3 +
 4 files changed, 594 insertions(+), 1044 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5bff87e..69c1796 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -4,14 +4,42 @@
 #include <linux/sched.h>
 #include <linux/percpu.h>
 #include <linux/bootmem.h>
+#include <linux/err.h>
+#include <linux/nmi.h>
 
+#include <asm/desc.h>
 #include <asm/nmi.h>
 #include <asm/irq.h>
 #include <asm/smp.h>
 #include <asm/cpu.h>
 #include <asm/numa.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/mtrr.h>
+#include <asm/nmi.h>
+#include <linux/mc146818rtc.h>
 
 #include <mach_apic.h>
+#include <mach_wakecpu.h>
+#include <smpboot_hooks.h>
+
+/* Store all idle threads, this can be reused instead of creating
+* a new thread. Also avoids complicated thread destroy functionality
+* for idle threads.
+*/
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
+ * removed after init for !CONFIG_HOTPLUG_CPU.
+ */
+static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
+#define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
+#define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
+#else
+struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
+#define get_idle_for_cpu(x)      (idle_thread_array[(x)])
+#define set_idle_for_cpu(x, p)   (idle_thread_array[(x)] = (p))
+#endif
 
 /* Number of siblings per CPU package */
 int smp_num_siblings = 1;
@@ -41,6 +69,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
+static atomic_t init_deasserted;
+
 /* ready for x86_64, no harm for x86, since it will overwrite after alloc */
 unsigned char *trampoline_base = __va(SMP_TRAMPOLINE_BASE);
 
@@ -110,6 +140,96 @@ void unmap_cpu_to_logical_apicid(int cpu)
 #define map_cpu_to_logical_apicid()  do {} while (0)
 #endif
 
+/*
+ * Report back to the Boot Processor.
+ * Running on AP.
+ */
+void __cpuinit smp_callin(void)
+{
+	int cpuid, phys_id;
+	unsigned long timeout;
+
+	/*
+	 * If waken up by an INIT in an 82489DX configuration
+	 * we may get here before an INIT-deassert IPI reaches
+	 * our local APIC.  We have to wait for the IPI or we'll
+	 * lock up on an APIC access.
+	 */
+	wait_for_init_deassert(&init_deasserted);
+
+	/*
+	 * (This works even if the APIC is not enabled.)
+	 */
+	phys_id = GET_APIC_ID(apic_read(APIC_ID));
+	cpuid = smp_processor_id();
+	if (cpu_isset(cpuid, cpu_callin_map)) {
+		panic("%s: phys CPU#%d, CPU#%d already present??\n", __func__,
+					phys_id, cpuid);
+	}
+	Dprintk("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
+
+	/*
+	 * STARTUP IPIs are fragile beasts as they might sometimes
+	 * trigger some glue motherboard logic. Complete APIC bus
+	 * silence for 1 second, this overestimates the time the
+	 * boot CPU is spending to send the up to 2 STARTUP IPIs
+	 * by a factor of two. This should be enough.
+	 */
+
+	/*
+	 * Waiting 2s total for startup (udelay is not yet working)
+	 */
+	timeout = jiffies + 2*HZ;
+	while (time_before(jiffies, timeout)) {
+		/*
+		 * Has the boot CPU finished it's STARTUP sequence?
+		 */
+		if (cpu_isset(cpuid, cpu_callout_map))
+			break;
+		cpu_relax();
+	}
+
+	if (!time_before(jiffies, timeout)) {
+		panic("%s: CPU%d started up but did not get a callout!\n",
+		      __func__, cpuid);
+	}
+
+	/*
+	 * the boot CPU has finished the init stage and is spinning
+	 * on callin_map until we finish. We are free to set up this
+	 * CPU, first the APIC. (this is probably redundant on most
+	 * boards)
+	 */
+
+	Dprintk("CALLIN, before setup_local_APIC().\n");
+	smp_callin_clear_local_apic();
+	setup_local_APIC();
+	end_local_APIC_setup();
+	map_cpu_to_logical_apicid();
+
+	/*
+	 * Get our bogomips.
+	 *
+	 * Need to enable IRQs because it can take longer and then
+	 * the NMI watchdog might kill us.
+	 */
+	local_irq_enable();
+	calibrate_delay();
+	local_irq_disable();
+	Dprintk("Stack at about %p\n", &cpuid);
+
+	/*
+	 * Save our processor parameters
+	 */
+	smp_store_cpu_info(cpuid);
+
+	/*
+	 * Allow the master to continue.
+	 */
+	cpu_set(cpuid, cpu_callin_map);
+}
+
+
 static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_32
@@ -327,6 +447,474 @@ void impress_friends(void)
 	Dprintk("Before bogocount - setting activated=1.\n");
 }
 
+static inline void __inquire_remote_apic(int apicid)
+{
+	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
+	char *names[] = { "ID", "VERSION", "SPIV" };
+	int timeout;
+	u32 status;
+
+	printk(KERN_INFO "Inquiring remote APIC #%d...\n", apicid);
+
+	for (i = 0; i < ARRAY_SIZE(regs); i++) {
+		printk(KERN_INFO "... APIC #%d %s: ", apicid, names[i]);
+
+		/*
+		 * Wait for idle.
+		 */
+		status = safe_apic_wait_icr_idle();
+		if (status)
+			printk(KERN_CONT
+			       "a previous APIC delivery may have failed\n");
+
+		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
+		apic_write_around(APIC_ICR, APIC_DM_REMRD | regs[i]);
+
+		timeout = 0;
+		do {
+			udelay(100);
+			status = apic_read(APIC_ICR) & APIC_ICR_RR_MASK;
+		} while (status == APIC_ICR_RR_INPROG && timeout++ < 1000);
+
+		switch (status) {
+		case APIC_ICR_RR_VALID:
+			status = apic_read(APIC_RRR);
+			printk(KERN_CONT "%08x\n", status);
+			break;
+		default:
+			printk(KERN_CONT "failed\n");
+		}
+	}
+}
+
+#ifdef WAKE_SECONDARY_VIA_NMI
+/*
+ * Poke the other CPU in the eye via NMI to wake it up. Remember that the normal
+ * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
+ * won't ... remember to clear down the APIC, etc later.
+ */
+static int __devinit
+wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
+{
+	unsigned long send_status, accept_status = 0;
+	int maxlvt;
+
+	/* Target chip */
+	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(logical_apicid));
+
+	/* Boot on the stack */
+	/* Kick the second */
+	apic_write_around(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);
+
+	Dprintk("Waiting for send to finish...\n");
+	send_status = safe_apic_wait_icr_idle();
+
+	/*
+	 * Give the other CPU some time to accept the IPI.
+	 */
+	udelay(200);
+	/*
+	 * Due to the Pentium erratum 3AP.
+	 */
+	maxlvt = lapic_get_maxlvt();
+	if (maxlvt > 3) {
+		apic_read_around(APIC_SPIV);
+		apic_write(APIC_ESR, 0);
+	}
+	accept_status = (apic_read(APIC_ESR) & 0xEF);
+	Dprintk("NMI sent.\n");
+
+	if (send_status)
+		printk(KERN_ERR "APIC never delivered???\n");
+	if (accept_status)
+		printk(KERN_ERR "APIC delivery error (%lx).\n", accept_status);
+
+	return (send_status | accept_status);
+}
+#endif	/* WAKE_SECONDARY_VIA_NMI */
+
+extern void start_secondary(void *unused);
+#ifdef WAKE_SECONDARY_VIA_INIT
+static int __devinit
+wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
+{
+	unsigned long send_status, accept_status = 0;
+	int maxlvt, num_starts, j;
+
+	/*
+	 * Be paranoid about clearing APIC errors.
+	 */
+	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+		apic_read_around(APIC_SPIV);
+		apic_write(APIC_ESR, 0);
+		apic_read(APIC_ESR);
+	}
+
+	Dprintk("Asserting INIT.\n");
+
+	/*
+	 * Turn INIT on target chip
+	 */
+	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
+
+	/*
+	 * Send IPI
+	 */
+	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_INT_ASSERT
+				| APIC_DM_INIT);
+
+	Dprintk("Waiting for send to finish...\n");
+	send_status = safe_apic_wait_icr_idle();
+
+	mdelay(10);
+
+	Dprintk("Deasserting INIT.\n");
+
+	/* Target chip */
+	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
+
+	/* Send IPI */
+	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
+
+	Dprintk("Waiting for send to finish...\n");
+	send_status = safe_apic_wait_icr_idle();
+
+	mb();
+	atomic_set(&init_deasserted, 1);
+
+	/*
+	 * Should we send STARTUP IPIs ?
+	 *
+	 * Determine this based on the APIC version.
+	 * If we don't have an integrated APIC, don't send the STARTUP IPIs.
+	 */
+	if (APIC_INTEGRATED(apic_version[phys_apicid]))
+		num_starts = 2;
+	else
+		num_starts = 0;
+
+	/*
+	 * Paravirt / VMI wants a startup IPI hook here to set up the
+	 * target processor state.
+	 */
+	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
+#ifdef CONFIG_X86_64
+			 (unsigned long)init_rsp);
+#else
+			 (unsigned long)stack_start.sp);
+#endif
+
+	/*
+	 * Run STARTUP IPI loop.
+	 */
+	Dprintk("#startup loops: %d.\n", num_starts);
+
+	maxlvt = lapic_get_maxlvt();
+
+	for (j = 1; j <= num_starts; j++) {
+		Dprintk("Sending STARTUP #%d.\n", j);
+		apic_read_around(APIC_SPIV);
+		apic_write(APIC_ESR, 0);
+		apic_read(APIC_ESR);
+		Dprintk("After apic_write.\n");
+
+		/*
+		 * STARTUP IPI
+		 */
+
+		/* Target chip */
+		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
+
+		/* Boot on the stack */
+		/* Kick the second */
+		apic_write_around(APIC_ICR, APIC_DM_STARTUP
+					| (start_eip >> 12));
+
+		/*
+		 * Give the other CPU some time to accept the IPI.
+		 */
+		udelay(300);
+
+		Dprintk("Startup point 1.\n");
+
+		Dprintk("Waiting for send to finish...\n");
+		send_status = safe_apic_wait_icr_idle();
+
+		/*
+		 * Give the other CPU some time to accept the IPI.
+		 */
+		udelay(200);
+		/*
+		 * Due to the Pentium erratum 3AP.
+		 */
+		if (maxlvt > 3) {
+			apic_read_around(APIC_SPIV);
+			apic_write(APIC_ESR, 0);
+		}
+		accept_status = (apic_read(APIC_ESR) & 0xEF);
+		if (send_status || accept_status)
+			break;
+	}
+	Dprintk("After Startup.\n");
+
+	if (send_status)
+		printk(KERN_ERR "APIC never delivered???\n");
+	if (accept_status)
+		printk(KERN_ERR "APIC delivery error (%lx).\n", accept_status);
+
+	return (send_status | accept_status);
+}
+#endif	/* WAKE_SECONDARY_VIA_INIT */
+
+struct create_idle {
+	struct work_struct work;
+	struct task_struct *idle;
+	struct completion done;
+	int cpu;
+};
+
+static void __cpuinit do_fork_idle(struct work_struct *work)
+{
+	struct create_idle *c_idle =
+		container_of(work, struct create_idle, work);
+
+	c_idle->idle = fork_idle(c_idle->cpu);
+	complete(&c_idle->done);
+}
+
+static int __cpuinit do_boot_cpu(int apicid, int cpu)
+/*
+ * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
+ * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
+ * Returns zero if CPU booted OK, else error code from wakeup_secondary_cpu.
+ */
+{
+	unsigned long boot_error = 0;
+	int timeout;
+	unsigned long start_ip;
+	unsigned short nmi_high = 0, nmi_low = 0;
+	struct create_idle c_idle = {
+		.cpu = cpu,
+		.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
+	};
+	INIT_WORK(&c_idle.work, do_fork_idle);
+#ifdef CONFIG_X86_64
+	/* allocate memory for gdts of secondary cpus. Hotplug is considered */
+	if (!cpu_gdt_descr[cpu].address &&
+		!(cpu_gdt_descr[cpu].address = get_zeroed_page(GFP_KERNEL))) {
+		printk(KERN_ERR "Failed to allocate GDT for CPU %d\n", cpu);
+		return -1;
+	}
+
+	/* Allocate node local memory for AP pdas */
+	if (cpu_pda(cpu) == &boot_cpu_pda[cpu]) {
+		struct x8664_pda *newpda, *pda;
+		int node = cpu_to_node(cpu);
+		pda = cpu_pda(cpu);
+		newpda = kmalloc_node(sizeof(struct x8664_pda), GFP_ATOMIC,
+				      node);
+		if (newpda) {
+			memcpy(newpda, pda, sizeof(struct x8664_pda));
+			cpu_pda(cpu) = newpda;
+		} else
+			printk(KERN_ERR
+		"Could not allocate node local PDA for CPU %d on node %d\n",
+				cpu, node);
+	}
+#endif
+
+	alternatives_smp_switch(1);
+
+	c_idle.idle = get_idle_for_cpu(cpu);
+
+	/*
+	 * We can't use kernel_thread since we must avoid to
+	 * reschedule the child.
+	 */
+	if (c_idle.idle) {
+		c_idle.idle->thread.sp = (unsigned long) (((struct pt_regs *)
+			(THREAD_SIZE +  task_stack_page(c_idle.idle))) - 1);
+		init_idle(c_idle.idle, cpu);
+		goto do_rest;
+	}
+
+	if (!keventd_up() || current_is_keventd())
+		c_idle.work.func(&c_idle.work);
+	else {
+		schedule_work(&c_idle.work);
+		wait_for_completion(&c_idle.done);
+	}
+
+	if (IS_ERR(c_idle.idle)) {
+		printk("failed fork for CPU %d\n", cpu);
+		return PTR_ERR(c_idle.idle);
+	}
+
+	set_idle_for_cpu(cpu, c_idle.idle);
+do_rest:
+#ifdef CONFIG_X86_32
+	per_cpu(current_task, cpu) = c_idle.idle;
+	init_gdt(cpu);
+	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
+	c_idle.idle->thread.ip = (unsigned long) start_secondary;
+	/* Stack for startup_32 can be just as for start_secondary onwards */
+	stack_start.sp = (void *) c_idle.idle->thread.sp;
+	irq_ctx_init(cpu);
+#else
+	cpu_pda(cpu)->pcurrent = c_idle.idle;
+	init_rsp = c_idle.idle->thread.sp;
+	load_sp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
+	initial_code = (unsigned long)start_secondary;
+	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
+#endif
+
+	/* start_ip had better be page-aligned! */
+	start_ip = setup_trampoline();
+
+	/* So we see what's up   */
+	printk(KERN_INFO "Booting processor %d/%d ip %lx\n",
+			  cpu, apicid, start_ip);
+
+	/*
+	 * This grunge runs the startup process for
+	 * the targeted processor.
+	 */
+
+	atomic_set(&init_deasserted, 0);
+
+	Dprintk("Setting warm reset code and vector.\n");
+
+	store_NMI_vector(&nmi_high, &nmi_low);
+
+	smpboot_setup_warm_reset_vector(start_ip);
+	/*
+	 * Be paranoid about clearing APIC errors.
+	 */
+	apic_write(APIC_ESR, 0);
+	apic_read(APIC_ESR);
+
+
+	/*
+	 * Starting actual IPI sequence...
+	 */
+	boot_error = wakeup_secondary_cpu(apicid, start_ip);
+
+	if (!boot_error) {
+		/*
+		 * allow APs to start initializing.
+		 */
+		Dprintk("Before Callout %d.\n", cpu);
+		cpu_set(cpu, cpu_callout_map);
+		Dprintk("After Callout %d.\n", cpu);
+
+		/*
+		 * Wait 5s total for a response
+		 */
+		for (timeout = 0; timeout < 50000; timeout++) {
+			if (cpu_isset(cpu, cpu_callin_map))
+				break;	/* It has booted */
+			udelay(100);
+		}
+
+		if (cpu_isset(cpu, cpu_callin_map)) {
+			/* number CPUs logically, starting from 1 (BSP is 0) */
+			Dprintk("OK.\n");
+			printk(KERN_INFO "CPU%d: ", cpu);
+			print_cpu_info(&cpu_data(cpu));
+			Dprintk("CPU has booted.\n");
+		} else {
+			boot_error = 1;
+			if (*((volatile unsigned char *)trampoline_base)
+					== 0xA5)
+				/* trampoline started but...? */
+				printk(KERN_ERR "Stuck ??\n");
+			else
+				/* trampoline code not run */
+				printk(KERN_ERR "Not responding.\n");
+			inquire_remote_apic(apicid);
+		}
+	}
+
+	if (boot_error) {
+		/* Try to put things back the way they were before ... */
+		unmap_cpu_to_logical_apicid(cpu);
+#ifdef CONFIG_X86_64
+		clear_node_cpumask(cpu); /* was set by numa_add_cpu */
+#endif
+		cpu_clear(cpu, cpu_callout_map); /* was set by do_boot_cpu() */
+		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
+		cpu_clear(cpu, cpu_possible_map);
+		cpu_clear(cpu, cpu_present_map);
+		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
+	}
+
+	/* mark "stuck" area as not stuck */
+	*((volatile unsigned long *)trampoline_base) = 0;
+
+	return boot_error;
+}
+
+int __cpuinit native_cpu_up(unsigned int cpu)
+{
+	int apicid = cpu_present_to_apicid(cpu);
+	unsigned long flags;
+	int err;
+
+	WARN_ON(irqs_disabled());
+
+	Dprintk("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
+
+	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
+	    !physid_isset(apicid, phys_cpu_present_map)) {
+		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
+		return -EINVAL;
+	}
+
+	/*
+	 * Already booted CPU?
+	 */
+	if (cpu_isset(cpu, cpu_callin_map)) {
+		Dprintk("do_boot_cpu %d Already started\n", cpu);
+		return -ENOSYS;
+	}
+
+	/*
+	 * Save current MTRR state in case it was changed since early boot
+	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
+	 */
+	mtrr_save_state();
+
+	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
+
+#ifdef CONFIG_X86_32
+	/* init low mem mapping */
+	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
+			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
+	flush_tlb_all();
+#endif
+
+	err = do_boot_cpu(apicid, cpu);
+	if (err < 0) {
+		Dprintk("do_boot_cpu failed %d\n", err);
+		return err;
+	}
+
+	/*
+	 * Check TSC synchronization with the AP (keep irqs disabled
+	 * while doing so):
+	 */
+	local_irq_save(flags);
+	check_tsc_sync_source(cpu);
+	local_irq_restore(flags);
+
+	while (!cpu_isset(cpu, cpu_online_map)) {
+		cpu_relax();
+		touch_nmi_watchdog();
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 void remove_siblinginfo(int cpu)
 {
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index ae25927..e82eeb2 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -80,114 +80,12 @@ extern void unmap_cpu_to_logical_apicid(int cpu);
 /* State of each CPU. */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-/* Store all idle threads, this can be reused instead of creating
-* a new thread. Also avoids complicated thread destroy functionality
-* for idle threads.
-*/
-#ifdef CONFIG_HOTPLUG_CPU
-/*
- * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
- * removed after init for !CONFIG_HOTPLUG_CPU.
- */
-static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
-#define get_idle_for_cpu(x)      (per_cpu(idle_thread_array, x))
-#define set_idle_for_cpu(x, p)   (per_cpu(idle_thread_array, x) = (p))
-#else
-struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
-#define get_idle_for_cpu(x)      (idle_thread_array[(x)])
-#define set_idle_for_cpu(x, p)   (idle_thread_array[(x)] = (p))
-#endif
-
-static atomic_t init_deasserted;
-
-static void __cpuinit smp_callin(void)
-{
-	int cpuid, phys_id;
-	unsigned long timeout;
-
-	/*
-	 * If waken up by an INIT in an 82489DX configuration
-	 * we may get here before an INIT-deassert IPI reaches
-	 * our local APIC.  We have to wait for the IPI or we'll
-	 * lock up on an APIC access.
-	 */
-	wait_for_init_deassert(&init_deasserted);
-
-	/*
-	 * (This works even if the APIC is not enabled.)
-	 */
-	phys_id = GET_APIC_ID(apic_read(APIC_ID));
-	cpuid = smp_processor_id();
-	if (cpu_isset(cpuid, cpu_callin_map)) {
-		printk("huh, phys CPU#%d, CPU#%d already present??\n",
-					phys_id, cpuid);
-		BUG();
-	}
-	Dprintk("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
-
-	/*
-	 * STARTUP IPIs are fragile beasts as they might sometimes
-	 * trigger some glue motherboard logic. Complete APIC bus
-	 * silence for 1 second, this overestimates the time the
-	 * boot CPU is spending to send the up to 2 STARTUP IPIs
-	 * by a factor of two. This should be enough.
-	 */
-
-	/*
-	 * Waiting 2s total for startup (udelay is not yet working)
-	 */
-	timeout = jiffies + 2*HZ;
-	while (time_before(jiffies, timeout)) {
-		/*
-		 * Has the boot CPU finished it's STARTUP sequence?
-		 */
-		if (cpu_isset(cpuid, cpu_callout_map))
-			break;
-		cpu_relax();
-	}
-
-	if (!time_before(jiffies, timeout)) {
-		printk("BUG: CPU%d started up but did not get a callout!\n",
-			cpuid);
-		BUG();
-	}
-
-	/*
-	 * the boot CPU has finished the init stage and is spinning
-	 * on callin_map until we finish. We are free to set up this
-	 * CPU, first the APIC. (this is probably redundant on most
-	 * boards)
-	 */
-
-	Dprintk("CALLIN, before setup_local_APIC().\n");
-	smp_callin_clear_local_apic();
-	setup_local_APIC();
-	end_local_APIC_setup();
-	map_cpu_to_logical_apicid();
-
-	/*
-	 * Get our bogomips.
-	 */
-	local_irq_enable();
-	calibrate_delay();
-	local_irq_disable();
-	Dprintk("Stack at about %p\n",&cpuid);
-
-	/*
-	 * Save our processor parameters
-	 */
-	smp_store_cpu_info(cpuid);
-
-	/*
-	 * Allow the master to continue.
-	 */
-	cpu_set(cpuid, cpu_callin_map);
-}
+extern void smp_callin(void);
 
 /*
  * Activate a secondary processor.
  */
-static void __cpuinit start_secondary(void *unused)
+void __cpuinit start_secondary(void *unused)
 {
 	/*
 	 * Don't put *anything* before cpu_init(), SMP booting is too
@@ -257,373 +155,6 @@ void __devinit initialize_secondary(void)
 		:"m" (current->thread.sp),"m" (current->thread.ip));
 }
 
-static inline void __inquire_remote_apic(int apicid)
-{
-	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
-	char *names[] = { "ID", "VERSION", "SPIV" };
-	int timeout;
-	u32 status;
-
-	printk(KERN_INFO "Inquiring remote APIC #%d...\n", apicid);
-
-	for (i = 0; i < ARRAY_SIZE(regs); i++) {
-		printk(KERN_INFO "... APIC #%d %s: ", apicid, names[i]);
-
-		/*
-		 * Wait for idle.
-		 */
-		status = safe_apic_wait_icr_idle();
-		if (status)
-			printk(KERN_CONT
-			       "a previous APIC delivery may have failed\n");
-
-		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
-		apic_write_around(APIC_ICR, APIC_DM_REMRD | regs[i]);
-
-		timeout = 0;
-		do {
-			udelay(100);
-			status = apic_read(APIC_ICR) & APIC_ICR_RR_MASK;
-		} while (status == APIC_ICR_RR_INPROG && timeout++ < 1000);
-
-		switch (status) {
-		case APIC_ICR_RR_VALID:
-			status = apic_read(APIC_RRR);
-			printk(KERN_CONT "%08x\n", status);
-			break;
-		default:
-			printk(KERN_CONT "failed\n");
-		}
-	}
-}
-
-#ifdef WAKE_SECONDARY_VIA_NMI
-/* 
- * Poke the other CPU in the eye via NMI to wake it up. Remember that the normal
- * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
- * won't ... remember to clear down the APIC, etc later.
- */
-static int __devinit
-wakeup_secondary_cpu(int logical_apicid, unsigned long start_eip)
-{
-	unsigned long send_status, accept_status = 0;
-	int maxlvt;
-
-	/* Target chip */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(logical_apicid));
-
-	/* Boot on the stack */
-	/* Kick the second */
-	apic_write_around(APIC_ICR, APIC_DM_NMI | APIC_DEST_LOGICAL);
-
-	Dprintk("Waiting for send to finish...\n");
-	send_status = safe_apic_wait_icr_idle();
-
-	/*
-	 * Give the other CPU some time to accept the IPI.
-	 */
-	udelay(200);
-	/*
-	 * Due to the Pentium erratum 3AP.
-	 */
-	maxlvt = lapic_get_maxlvt();
-	if (maxlvt > 3) {
-		apic_read_around(APIC_SPIV);
-		apic_write(APIC_ESR, 0);
-	}
-	accept_status = (apic_read(APIC_ESR) & 0xEF);
-	Dprintk("NMI sent.\n");
-
-	if (send_status)
-		printk("APIC never delivered???\n");
-	if (accept_status)
-		printk("APIC delivery error (%lx).\n", accept_status);
-
-	return (send_status | accept_status);
-}
-#endif	/* WAKE_SECONDARY_VIA_NMI */
-
-#ifdef WAKE_SECONDARY_VIA_INIT
-static int __devinit
-wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
-{
-	unsigned long send_status, accept_status = 0;
-	int maxlvt, num_starts, j;
-
-	/*
-	 * Be paranoid about clearing APIC errors.
-	 */
-	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
-		apic_read_around(APIC_SPIV);
-		apic_write(APIC_ESR, 0);
-		apic_read(APIC_ESR);
-	}
-
-	Dprintk("Asserting INIT.\n");
-
-	/*
-	 * Turn INIT on target chip
-	 */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
-	/*
-	 * Send IPI
-	 */
-	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_INT_ASSERT
-				| APIC_DM_INIT);
-
-	Dprintk("Waiting for send to finish...\n");
-	send_status = safe_apic_wait_icr_idle();
-
-	mdelay(10);
-
-	Dprintk("Deasserting INIT.\n");
-
-	/* Target chip */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
-	/* Send IPI */
-	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
-
-	Dprintk("Waiting for send to finish...\n");
-	send_status = safe_apic_wait_icr_idle();
-
-	mb();
-	atomic_set(&init_deasserted, 1);
-
-	/*
-	 * Should we send STARTUP IPIs ?
-	 *
-	 * Determine this based on the APIC version.
-	 * If we don't have an integrated APIC, don't send the STARTUP IPIs.
-	 */
-	if (APIC_INTEGRATED(apic_version[phys_apicid]))
-		num_starts = 2;
-	else
-		num_starts = 0;
-
-	/*
-	 * Paravirt / VMI wants a startup IPI hook here to set up the
-	 * target processor state.
-	 */
-	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
-		         (unsigned long) stack_start.sp);
-
-	/*
-	 * Run STARTUP IPI loop.
-	 */
-	Dprintk("#startup loops: %d.\n", num_starts);
-
-	maxlvt = lapic_get_maxlvt();
-
-	for (j = 1; j <= num_starts; j++) {
-		Dprintk("Sending STARTUP #%d.\n",j);
-		apic_read_around(APIC_SPIV);
-		apic_write(APIC_ESR, 0);
-		apic_read(APIC_ESR);
-		Dprintk("After apic_write.\n");
-
-		/*
-		 * STARTUP IPI
-		 */
-
-		/* Target chip */
-		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
-		/* Boot on the stack */
-		/* Kick the second */
-		apic_write_around(APIC_ICR, APIC_DM_STARTUP
-					| (start_eip >> 12));
-
-		/*
-		 * Give the other CPU some time to accept the IPI.
-		 */
-		udelay(300);
-
-		Dprintk("Startup point 1.\n");
-
-		Dprintk("Waiting for send to finish...\n");
-		send_status = safe_apic_wait_icr_idle();
-
-		/*
-		 * Give the other CPU some time to accept the IPI.
-		 */
-		udelay(200);
-		/*
-		 * Due to the Pentium erratum 3AP.
-		 */
-		if (maxlvt > 3) {
-			apic_read_around(APIC_SPIV);
-			apic_write(APIC_ESR, 0);
-		}
-		accept_status = (apic_read(APIC_ESR) & 0xEF);
-		if (send_status || accept_status)
-			break;
-	}
-	Dprintk("After Startup.\n");
-
-	if (send_status)
-		printk("APIC never delivered???\n");
-	if (accept_status)
-		printk("APIC delivery error (%lx).\n", accept_status);
-
-	return (send_status | accept_status);
-}
-#endif	/* WAKE_SECONDARY_VIA_INIT */
-
-extern cpumask_t cpu_initialized;
-
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-static void __cpuinit do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle =
-		container_of(work, struct create_idle, work);
-
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-static int __cpuinit do_boot_cpu(int apicid, int cpu)
-/*
- * NOTE - on most systems this is a PHYSICAL apic ID, but on multiquad
- * (ie clustered apic addressing mode), this is a LOGICAL apic ID.
- * Returns zero if CPU booted OK, else error code from wakeup_secondary_cpu.
- */
-{
-	unsigned long boot_error = 0;
-	int timeout;
-	unsigned long start_eip;
-	unsigned short nmi_high = 0, nmi_low = 0;
-	struct create_idle c_idle = {
-		.cpu = cpu,
-		.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-	};
-	INIT_WORK(&c_idle.work, do_fork_idle);
-
-	alternatives_smp_switch(1);
-
-	c_idle.idle = get_idle_for_cpu(cpu);
-
-	/*
-	 * We can't use kernel_thread since we must avoid to
-	 * reschedule the child.
-	 */
-	if (c_idle.idle) {
-		c_idle.idle->thread.sp = (unsigned long) (((struct pt_regs *)
-			(THREAD_SIZE +  task_stack_page(c_idle.idle))) - 1);
-		init_idle(c_idle.idle, cpu);
-		goto do_rest;
-	}
-
-	if (!keventd_up() || current_is_keventd())
-		c_idle.work.func(&c_idle.work);
-	else {
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-	}
-
-	if (IS_ERR(c_idle.idle)) {
-		printk(KERN_ERR "failed fork for CPU %d\n", cpu);
-		return PTR_ERR(c_idle.idle);
-	}
-
-	set_idle_for_cpu(cpu, c_idle.idle);
-do_rest:
-	per_cpu(current_task, cpu) = c_idle.idle;
-	init_gdt(cpu);
-	early_gdt_descr.address = (unsigned long)get_cpu_gdt_table(cpu);
-
-	c_idle.idle->thread.ip = (unsigned long) start_secondary;
-	/* start_eip had better be page-aligned! */
-	start_eip = setup_trampoline();
-
-	/* So we see what's up   */
-	printk("Booting processor %d/%d ip %lx\n", cpu, apicid, start_eip);
-	/* Stack for startup_32 can be just as for start_secondary onwards */
-	stack_start.sp = (void *) c_idle.idle->thread.sp;
-
-	irq_ctx_init(cpu);
-
-	/*
-	 * This grunge runs the startup process for
-	 * the targeted processor.
-	 */
-
-	atomic_set(&init_deasserted, 0);
-
-	Dprintk("Setting warm reset code and vector.\n");
-
-	store_NMI_vector(&nmi_high, &nmi_low);
-
-	smpboot_setup_warm_reset_vector(start_eip);
-	/*
-	 * Be paranoid about clearing APIC errors.
-	 */
-	apic_write(APIC_ESR, 0);
-	apic_read(APIC_ESR);
-
-
-	/*
-	 * Starting actual IPI sequence...
-	 */
-	boot_error = wakeup_secondary_cpu(apicid, start_eip);
-
-	if (!boot_error) {
-		/*
-		 * allow APs to start initializing.
-		 */
-		Dprintk("Before Callout %d.\n", cpu);
-		cpu_set(cpu, cpu_callout_map);
-		Dprintk("After Callout %d.\n", cpu);
-
-		/*
-		 * Wait 5s total for a response
-		 */
-		for (timeout = 0; timeout < 50000; timeout++) {
-			if (cpu_isset(cpu, cpu_callin_map))
-				break;	/* It has booted */
-			udelay(100);
-		}
-
-		if (cpu_isset(cpu, cpu_callin_map)) {
-			/* number CPUs logically, starting from 1 (BSP is 0) */
-			Dprintk("OK.\n");
-			printk("CPU%d: ", cpu);
-			print_cpu_info(&cpu_data(cpu));
-			Dprintk("CPU has booted.\n");
-		} else {
-			boot_error= 1;
-			if (*((volatile unsigned char *)trampoline_base)
-					== 0xA5)
-				/* trampoline started but...? */
-				printk("Stuck ??\n");
-			else
-				/* trampoline code not run */
-				printk("Not responding.\n");
-			inquire_remote_apic(apicid);
-		}
-	}
-
-	if (boot_error) {
-		/* Try to put things back the way they were before ... */
-		unmap_cpu_to_logical_apicid(cpu);
-		cpu_clear(cpu, cpu_callout_map); /* was set here (do_boot_cpu()) */
-		cpu_clear(cpu, cpu_initialized); /* was set by cpu_init() */
-		cpu_clear(cpu, cpu_possible_map);
-		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
-	}
-
-	/* mark "stuck" area as not stuck */
-	*((volatile unsigned long *)trampoline_base) = 0;
-
-	return boot_error;
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 void cpu_exit_clear(void)
 {
@@ -774,65 +305,6 @@ void __init native_smp_prepare_boot_cpu(void)
 	__get_cpu_var(cpu_state) = CPU_ONLINE;
 }
 
-int __cpuinit native_cpu_up(unsigned int cpu)
-{
-	int apicid = cpu_present_to_apicid(cpu);
-	unsigned long flags;
-	int err;
-
-	WARN_ON(irqs_disabled());
-
-	Dprintk("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
-
-	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
-	    !physid_isset(apicid, phys_cpu_present_map)) {
-		printk(KERN_ERR "%s: bad cpu %d\n", __func__, cpu);
-		return -EINVAL;
-	}
-
-	/*
-	 * Already booted CPU?
-	 */
-	if (cpu_isset(cpu, cpu_callin_map)) {
-		Dprintk("do_boot_cpu %d Already started\n", cpu);
-		return -ENOSYS;
-	}
-
-	/*
-	 * Save current MTRR state in case it was changed since early boot
-	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
-	 */
-	mtrr_save_state();
-
-	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
-
-	/* init low mem mapping */
-	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + USER_PGD_PTRS,
-			min_t(unsigned long, KERNEL_PGD_PTRS, USER_PGD_PTRS));
-	flush_tlb_all();
-
-	err = do_boot_cpu(apicid, cpu);
-	if (err < 0) {
-		Dprintk("do_boot_cpu failed %d\n", err);
-		return err;
-	}
-
-	/*
-	 * Check TSC synchronization with the AP (keep irqs disabled
-	 * while doing so):
-	 */
-	local_irq_save(flags);
-	check_tsc_sync_source(cpu);
-	local_irq_restore(flags);
-
-	while (!cpu_isset(cpu, cpu_online_map)) {
-		cpu_relax();
-		touch_nmi_watchdog();
-	}
-
-	return 0;
-}
-
 extern void impress_friends(void);
 extern void smp_checks(void);
 
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 420ae4a..71f13b1 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -71,119 +71,7 @@ int smp_threads_ready;
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
-/*
- * Store all idle threads, this can be reused instead of creating
- * a new thread. Also avoids complicated thread destroy functionality
- * for idle threads.
- */
-#ifdef CONFIG_HOTPLUG_CPU
-/*
- * Needed only for CONFIG_HOTPLUG_CPU because __cpuinitdata is
- * removed after init for !CONFIG_HOTPLUG_CPU.
- */
-static DEFINE_PER_CPU(struct task_struct *, idle_thread_array);
-#define get_idle_for_cpu(x)     (per_cpu(idle_thread_array, x))
-#define set_idle_for_cpu(x,p)   (per_cpu(idle_thread_array, x) = (p))
-#else
-struct task_struct *idle_thread_array[NR_CPUS] __cpuinitdata ;
-#define get_idle_for_cpu(x)     (idle_thread_array[(x)])
-#define set_idle_for_cpu(x,p)   (idle_thread_array[(x)] = (p))
-#endif
-
-static atomic_t init_deasserted __cpuinitdata;
-
-#define smp_callin_clear_local_apic() do {} while (0)
-#define map_cpu_to_logical_apicid() do {} while (0)
-
-/*
- * Report back to the Boot Processor.
- * Running on AP.
- */
-void __cpuinit smp_callin(void)
-{
-	int cpuid, phys_id;
-	unsigned long timeout;
-
-	/*
-	 * If waken up by an INIT in an 82489DX configuration
-	 * we may get here before an INIT-deassert IPI reaches
-	 * our local APIC.  We have to wait for the IPI or we'll
-	 * lock up on an APIC access.
-	 */
-	wait_for_init_deassert(&init_deasserted);
-
-	/*
-	 * (This works even if the APIC is not enabled.)
-	 */
-	phys_id = GET_APIC_ID(apic_read(APIC_ID));
-	cpuid = smp_processor_id();
-	if (cpu_isset(cpuid, cpu_callin_map)) {
-		panic("smp_callin: phys CPU#%d, CPU#%d already present??\n",
-					phys_id, cpuid);
-	}
-	Dprintk("CPU#%d (phys ID: %d) waiting for CALLOUT\n", cpuid, phys_id);
-
-	/*
-	 * STARTUP IPIs are fragile beasts as they might sometimes
-	 * trigger some glue motherboard logic. Complete APIC bus
-	 * silence for 1 second, this overestimates the time the
-	 * boot CPU is spending to send the up to 2 STARTUP IPIs
-	 * by a factor of two. This should be enough.
-	 */
-
-	/*
-	 * Waiting 2s total for startup (udelay is not yet working)
-	 */
-	timeout = jiffies + 2*HZ;
-	while (time_before(jiffies, timeout)) {
-		/*
-		 * Has the boot CPU finished it's STARTUP sequence?
-		 */
-		if (cpu_isset(cpuid, cpu_callout_map))
-			break;
-		cpu_relax();
-	}
-
-	if (!time_before(jiffies, timeout)) {
-		panic("smp_callin: CPU%d started up but did not get a callout!\n",
-			cpuid);
-	}
-
-	/*
-	 * the boot CPU has finished the init stage and is spinning
-	 * on callin_map until we finish. We are free to set up this
-	 * CPU, first the APIC. (this is probably redundant on most
-	 * boards)
-	 */
-
-	Dprintk("CALLIN, before setup_local_APIC().\n");
-	smp_callin_clear_local_apic();
-	setup_local_APIC();
-	end_local_APIC_setup();
-	map_cpu_to_logical_apicid();
-
-	/*
-	 * Get our bogomips.
- 	 *
- 	 * Need to enable IRQs because it can take longer and then
-	 * the NMI watchdog might kill us.
-	 */
-	local_irq_enable();
-	calibrate_delay();
-	local_irq_disable();
-	Dprintk("Stack at about %p\n",&cpuid);
-
-	/*
-	 * Save our processor parameters
-	 */
- 	smp_store_cpu_info(cpuid);
-
-	/*
-	 * Allow the master to continue.
-	 */
-	cpu_set(cpuid, cpu_callin_map);
-}
-
+extern void smp_callin(void);
 /*
  * Setup code on secondary processor (after comming out of the trampoline)
  */
@@ -246,349 +134,6 @@ void __cpuinit start_secondary(void)
 	cpu_idle();
 }
 
-extern volatile unsigned long init_rsp;
-extern void (*initial_code)(void);
-
-#ifdef APIC_DEBUG
-static void __inquire_remote_apic(int apicid)
-{
-	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
-	char *names[] = { "ID", "VERSION", "SPIV" };
-	int timeout;
-	u32 status;
-
-	printk(KERN_INFO "Inquiring remote APIC #%d...\n", apicid);
-
-	for (i = 0; i < ARRAY_SIZE(regs); i++) {
-		printk(KERN_INFO "... APIC #%d %s: ", apicid, names[i]);
-
-		/*
-		 * Wait for idle.
-		 */
-		status = safe_apic_wait_icr_idle();
-		if (status)
-			printk(KERN_CONT
-			       "a previous APIC delivery may have failed\n");
-
-		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
-		apic_write_around(APIC_ICR, APIC_DM_REMRD | regs[i]);
-
-		timeout = 0;
-		do {
-			udelay(100);
-			status = apic_read(APIC_ICR) & APIC_ICR_RR_MASK;
-		} while (status == APIC_ICR_RR_INPROG && timeout++ < 1000);
-
-		switch (status) {
-		case APIC_ICR_RR_VALID:
-			status = apic_read(APIC_RRR);
-			printk(KERN_CONT "%08x\n", status);
-			break;
-		default:
-			printk(KERN_CONT "failed\n");
-		}
-	}
-}
-#endif
-
-/*
- * Kick the secondary to wake up.
- */
-static int __cpuinit wakeup_secondary_cpu(int phys_apicid,
-					  unsigned int start_rip)
-{
-	unsigned long send_status, accept_status = 0;
-	int maxlvt, num_starts, j;
-
-	/*
-	 * Be paranoid about clearing APIC errors.
-	 */
-	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
-		apic_read_around(APIC_SPIV);
-		apic_write(APIC_ESR, 0);
-		apic_read(APIC_ESR);
-	}
-
-	Dprintk("Asserting INIT.\n");
-
-	/*
-	 * Turn INIT on target chip
-	 */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
-	/*
-	 * Send IPI
-	 */
-	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_INT_ASSERT
-				| APIC_DM_INIT);
-
-	Dprintk("Waiting for send to finish...\n");
-	send_status = safe_apic_wait_icr_idle();
-
-	mdelay(10);
-
-	Dprintk("Deasserting INIT.\n");
-
-	/* Target chip */
-	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
-	/* Send IPI */
-	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
-
-	Dprintk("Waiting for send to finish...\n");
-	send_status = safe_apic_wait_icr_idle();
-
-	mb();
-	atomic_set(&init_deasserted, 1);
-
-	if (APIC_INTEGRATED(apic_version[phys_apicid]))
-		num_starts = 2;
-	else
-		num_starts = 0;
-
-	/*
-	 * Paravirt / VMI wants a startup IPI hook here to set up the
-	 * target processor state.
-	 */
-	startup_ipi_hook(phys_apicid, (unsigned long) start_secondary,
-			(unsigned long) init_rsp);
-
-
-	/*
-	 * Run STARTUP IPI loop.
-	 */
-	Dprintk("#startup loops: %d.\n", num_starts);
-
-	maxlvt = lapic_get_maxlvt();
-
-	for (j = 1; j <= num_starts; j++) {
-		Dprintk("Sending STARTUP #%d.\n",j);
-		apic_read_around(APIC_SPIV);
-		apic_write(APIC_ESR, 0);
-		apic_read(APIC_ESR);
-		Dprintk("After apic_write.\n");
-
-		/*
-		 * STARTUP IPI
-		 */
-
-		/* Target chip */
-		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
-
-		/* Boot on the stack */
-		/* Kick the second */
-		apic_write_around(APIC_ICR, APIC_DM_STARTUP | (start_rip>>12));
-
-		/*
-		 * Give the other CPU some time to accept the IPI.
-		 */
-		udelay(300);
-
-		Dprintk("Startup point 1.\n");
-
-		Dprintk("Waiting for send to finish...\n");
-		send_status = safe_apic_wait_icr_idle();
-
-		/*
-		 * Give the other CPU some time to accept the IPI.
-		 */
-		udelay(200);
-		/*
-		 * Due to the Pentium erratum 3AP.
-		 */
-		if (maxlvt > 3) {
-			apic_read_around(APIC_SPIV);
-			apic_write(APIC_ESR, 0);
-		}
-		accept_status = (apic_read(APIC_ESR) & 0xEF);
-		if (send_status || accept_status)
-			break;
-	}
-	Dprintk("After Startup.\n");
-
-	if (send_status)
-		printk(KERN_ERR "APIC never delivered???\n");
-	if (accept_status)
-		printk(KERN_ERR "APIC delivery error (%lx).\n", accept_status);
-
-	return (send_status | accept_status);
-}
-
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-static void __cpuinit do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle =
-		container_of(work, struct create_idle, work);
-
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
-/*
- * Boot one CPU.
- */
-static int __cpuinit do_boot_cpu(int cpu, int apicid)
-{
-	unsigned long boot_error = 0;
-	int timeout;
-	unsigned long start_rip;
-	struct create_idle c_idle = {
-		.cpu = cpu,
-		.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-	};
-	INIT_WORK(&c_idle.work, do_fork_idle);
-
-	/* allocate memory for gdts of secondary cpus. Hotplug is considered */
-	if (!cpu_gdt_descr[cpu].address &&
-		!(cpu_gdt_descr[cpu].address = get_zeroed_page(GFP_KERNEL))) {
-		printk(KERN_ERR "Failed to allocate GDT for CPU %d\n", cpu);
-		return -1;
-	}
-
-	/* Allocate node local memory for AP pdas */
-	if (cpu_pda(cpu) == &boot_cpu_pda[cpu]) {
-		struct x8664_pda *newpda, *pda;
-		int node = cpu_to_node(cpu);
-		pda = cpu_pda(cpu);
-		newpda = kmalloc_node(sizeof (struct x8664_pda), GFP_ATOMIC,
-				      node);
-		if (newpda) {
-			memcpy(newpda, pda, sizeof (struct x8664_pda));
-			cpu_pda(cpu) = newpda;
-		} else
-			printk(KERN_ERR
-		"Could not allocate node local PDA for CPU %d on node %d\n",
-				cpu, node);
-	}
-
-	alternatives_smp_switch(1);
-
-	c_idle.idle = get_idle_for_cpu(cpu);
-
-	if (c_idle.idle) {
-		c_idle.idle->thread.sp = (unsigned long) (((struct pt_regs *)
-			(THREAD_SIZE +  task_stack_page(c_idle.idle))) - 1);
-		init_idle(c_idle.idle, cpu);
-		goto do_rest;
-	}
-
-	/*
-	 * During cold boot process, keventd thread is not spun up yet.
-	 * When we do cpu hot-add, we create idle threads on the fly, we should
-	 * not acquire any attributes from the calling context. Hence the clean
-	 * way to create kernel_threads() is to do that from keventd().
-	 * We do the current_is_keventd() due to the fact that ACPI notifier
-	 * was also queuing to keventd() and when the caller is already running
-	 * in context of keventd(), we would end up with locking up the keventd
-	 * thread.
-	 */
-	if (!keventd_up() || current_is_keventd())
-		c_idle.work.func(&c_idle.work);
-	else {
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-	}
-
-	if (IS_ERR(c_idle.idle)) {
-		printk("failed fork for CPU %d\n", cpu);
-		return PTR_ERR(c_idle.idle);
-	}
-
-	set_idle_for_cpu(cpu, c_idle.idle);
-
-do_rest:
-
-	cpu_pda(cpu)->pcurrent = c_idle.idle;
-
-	start_rip = setup_trampoline();
-
-	init_rsp = c_idle.idle->thread.sp;
-	load_sp0(&per_cpu(init_tss, cpu), &c_idle.idle->thread);
-	initial_code = start_secondary;
-	clear_tsk_thread_flag(c_idle.idle, TIF_FORK);
-
-	printk(KERN_INFO "Booting processor %d/%d APIC 0x%x\n", cpu,
-		cpus_weight(cpu_present_map),
-		apicid);
-
-	/*
-	 * This grunge runs the startup process for
-	 * the targeted processor.
-	 */
-
-	atomic_set(&init_deasserted, 0);
-
-	Dprintk("Setting warm reset code and vector.\n");
-
-	smpboot_setup_warm_reset_vector(start_rip);
-	/*
-	 * Be paranoid about clearing APIC errors.
-	 */
-	apic_write(APIC_ESR, 0);
-	apic_read(APIC_ESR);
-
-	/*
-	 * Starting actual IPI sequence...
-	 */
-	boot_error = wakeup_secondary_cpu(apicid, start_rip);
-
-	if (!boot_error) {
-		/*
-		 * allow APs to start initializing.
-		 */
-		Dprintk("Before Callout %d.\n", cpu);
-		cpu_set(cpu, cpu_callout_map);
-		Dprintk("After Callout %d.\n", cpu);
-
-		/*
-		 * Wait 5s total for a response
-		 */
-		for (timeout = 0; timeout < 50000; timeout++) {
-			if (cpu_isset(cpu, cpu_callin_map))
-				break;	/* It has booted */
-			udelay(100);
-		}
-
-		if (cpu_isset(cpu, cpu_callin_map)) {
-			/* number CPUs logically, starting from 1 (BSP is 0) */
-			Dprintk("CPU has booted.\n");
-			printk(KERN_INFO "CPU%d: ", cpu);
-			print_cpu_info(&cpu_data(cpu));
-		} else {
-			boot_error = 1;
-			if (*((volatile unsigned char *)trampoline_base)
-					== 0xA5)
-				/* trampoline started but...? */
-				printk("Stuck ??\n");
-			else
-				/* trampoline code not run */
-				printk("Not responding.\n");
-#ifdef APIC_DEBUG
-			inquire_remote_apic(apicid);
-#endif
-		}
-	}
-	if (boot_error) {
-		cpu_clear(cpu, cpu_callout_map); /* was set here (do_boot_cpu()) */
-		clear_bit(cpu, (unsigned long *)&cpu_initialized); /* was set by cpu_init() */
-		clear_node_cpumask(cpu); /* was set by numa_add_cpu */
-		cpu_clear(cpu, cpu_present_map);
-		cpu_clear(cpu, cpu_possible_map);
-		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
-	}
-
-	/* mark "stuck" area as not stuck */
-	*((volatile unsigned long *)trampoline_base) = 0;
-
-	return boot_error;
-}
-
 cycles_t cacheflush_time;
 unsigned long cache_decay_ticks;
 
@@ -745,64 +290,6 @@ void __init native_smp_prepare_boot_cpu(void)
 	per_cpu(cpu_state, me) = CPU_ONLINE;
 }
 
-/*
- * Entry point to boot a CPU.
- */
-int __cpuinit native_cpu_up(unsigned int cpu)
-{
-	int apicid = cpu_present_to_apicid(cpu);
-	unsigned long flags;
-	int err;
-
-	WARN_ON(irqs_disabled());
-
-	Dprintk("++++++++++++++++++++=_---CPU UP  %u\n", cpu);
-
-	if (apicid == BAD_APICID || apicid == boot_cpu_physical_apicid ||
-	    !physid_isset(apicid, phys_cpu_present_map)) {
-		printk("__cpu_up: bad cpu %d\n", cpu);
-		return -EINVAL;
-	}
-
-	/*
-	 * Already booted CPU?
-	 */
- 	if (cpu_isset(cpu, cpu_callin_map)) {
-		Dprintk("do_boot_cpu %d Already started\n", cpu);
- 		return -ENOSYS;
-	}
-
-	/*
-	 * Save current MTRR state in case it was changed since early boot
-	 * (e.g. by the ACPI SMI) to initialize new CPUs with MTRRs in sync:
-	 */
-	mtrr_save_state();
-
-	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
-	/* Boot it! */
-	err = do_boot_cpu(cpu, apicid);
-	if (err < 0) {
-		Dprintk("do_boot_cpu failed %d\n", err);
-		return err;
-	}
-
-	/* Unleash the CPU! */
-	Dprintk("waiting for cpu %d\n", cpu);
-
-	/*
-  	 * Make sure and check TSC sync:
- 	 */
-	local_irq_save(flags);
-	check_tsc_sync_source(cpu);
-	local_irq_restore(flags);
-
-	while (!cpu_isset(cpu, cpu_online_map))
-		cpu_relax();
-	err = 0;
-
-	return err;
-}
-
 extern void impress_friends(void);
 extern void smp_checks(void);
 
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 2ad2f4f..ef26911 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -9,6 +9,7 @@ extern cpumask_t cpu_callout_map;
 
 extern int smp_num_siblings;
 extern unsigned int num_processors;
+extern cpumask_t cpu_initialized;
 
 extern u16 x86_cpu_to_apicid_init[];
 extern u16 x86_bios_cpu_apicid_init[];
@@ -34,6 +35,8 @@ extern struct {
 	unsigned short ss;
 } stack_start;
 
+extern unsigned long init_rsp;
+extern unsigned long initial_code;
 
 struct smp_ops {
 	void (*smp_prepare_boot_cpu)(void);
-- 
1.5.0.6

