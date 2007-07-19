Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbXGSDIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbXGSDIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763538AbXGSDHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:07:49 -0400
Received: from ozlabs.org ([203.10.76.45]:48840 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763443AbXGSDHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:07:45 -0400
Subject: [PATCH] Clean up on_each_cpu: should not fail, should not have
	"retry" arg
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: arlied@linux.ie, Paul Mackerras <paulus@samba.org>, rth@twiddle.net,
       Russell King <rmk@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@muc.de>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 13:07:14 +1000
Message-Id: <1184814434.10380.193.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Summary: on_each_cpu() should return void, since callers can't do
anything useful with an error.  It should not have the "retry" arg
since it's of questionable utility and simply adds to Kernel Trivial
Persuit.

Only Alpha and PA-RISC use the "retry" arg to smp_call_function (it
makes them return -EBUSY if another smp_call_function is in progress).
This option seems useless outside arch-specific code, and is set
fairly randomly by callers.

Otherwise, the return value can be non-zero when a cpu is stuck, but
only for ARM and CRIS (-ETIMEDOUT), ppc and powerpc (-1).  Sparc64 and
PA-RISC also check for timeouts, but still return 0.

No arch-indep code checks the return from on_each_cpu() other than AGP
(which panics: what else can you do?).  Kudos to IA64 and Alpha for
checking the return value when it can never be non-zero!  Powerpc does
actually check in one place where a timeout could happen, but it looks
like the machine is borked at that point anyway since some CPUs are
likely spinning in rtas_percpu_suspend_me.

Finally, either slub.c's flush_all() can be called with interrupts
disabled on UP, or the #ifdef is gratuitous.  I assumed the latter.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/Documentation/local_ops.txt working-2.6.22-git11-on_each_cpu/Documentation/local_ops.txt
--- linux-2.6.22-git11/Documentation/local_ops.txt	2007-04-26 20:04:13.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/Documentation/local_ops.txt	2007-07-19 12:38:07.000000000 +1000
@@ -126,7 +126,7 @@ static void do_test_timer(unsigned long 
 	int cpu;
 
 	/* Increment the counters */
-	on_each_cpu(test_each, NULL, 0, 1);
+	on_each_cpu(test_each, NULL, 1);
 	/* Read all the counters */
 	printk("Counters read from CPU %d\n", smp_processor_id());
 	for_each_online_cpu(cpu) {
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/alpha/kernel/process.c working-2.6.22-git11-on_each_cpu/arch/alpha/kernel/process.c
--- linux-2.6.22-git11/arch/alpha/kernel/process.c	2007-07-10 14:31:57.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/alpha/kernel/process.c	2007-07-19 12:38:07.000000000 +1000
@@ -161,7 +161,7 @@ common_shutdown(int mode, char *restart_
 	struct halt_info args;
 	args.mode = mode;
 	args.restart_cmd = restart_cmd;
-	on_each_cpu(common_shutdown_1, &args, 1, 0);
+	on_each_cpu(common_shutdown_1, &args, 0);
 }
 
 void
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/alpha/kernel/smp.c working-2.6.22-git11-on_each_cpu/arch/alpha/kernel/smp.c
--- linux-2.6.22-git11/arch/alpha/kernel/smp.c	2007-07-19 11:56:15.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/alpha/kernel/smp.c	2007-07-19 12:38:07.000000000 +1000
@@ -811,8 +811,7 @@ void
 smp_imb(void)
 {
 	/* Must wait other processors to flush their icache before continue. */
-	if (on_each_cpu(ipi_imb, NULL, 1, 1))
-		printk(KERN_CRIT "smp_imb: timed out\n");
+	on_each_cpu(ipi_imb, NULL, 1);
 }
 EXPORT_SYMBOL(smp_imb);
 
@@ -827,9 +826,7 @@ flush_tlb_all(void)
 {
 	/* Although we don't have any data to pass, we do want to
 	   synchronize with the other processors.  */
-	if (on_each_cpu(ipi_flush_tlb_all, NULL, 1, 1)) {
-		printk(KERN_CRIT "flush_tlb_all: timed out\n");
-	}
+	on_each_cpu(ipi_flush_tlb_all, NULL, 1);
 }
 
 #define asn_locked() (cpu_data[smp_processor_id()].asn_lock)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/arm/kernel/smp.c working-2.6.22-git11-on_each_cpu/arch/arm/kernel/smp.c
--- linux-2.6.22-git11/arch/arm/kernel/smp.c	2007-07-10 14:31:57.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/arm/kernel/smp.c	2007-07-19 12:38:07.000000000 +1000
@@ -705,7 +705,7 @@ static inline void ipi_flush_tlb_kernel_
 
 void flush_tlb_all(void)
 {
-	on_each_cpu(ipi_flush_tlb_all, NULL, 1, 1);
+	on_each_cpu(ipi_flush_tlb_all, NULL, 1);
 }
 
 void flush_tlb_mm(struct mm_struct *mm)
@@ -732,7 +732,7 @@ void flush_tlb_kernel_page(unsigned long
 
 	ta.ta_start = kaddr;
 
-	on_each_cpu(ipi_flush_tlb_kernel_page, &ta, 1, 1);
+	on_each_cpu(ipi_flush_tlb_kernel_page, &ta, 1);
 }
 
 void flush_tlb_range(struct vm_area_struct *vma,
@@ -755,5 +755,5 @@ void flush_tlb_kernel_range(unsigned lon
 	ta.ta_start = start;
 	ta.ta_end = end;
 
-	on_each_cpu(ipi_flush_tlb_kernel_range, &ta, 1, 1);
+	on_each_cpu(ipi_flush_tlb_kernel_range, &ta, 1);
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/i386/kernel/cpu/mcheck/non-fatal.c working-2.6.22-git11-on_each_cpu/arch/i386/kernel/cpu/mcheck/non-fatal.c
--- linux-2.6.22-git11/arch/i386/kernel/cpu/mcheck/non-fatal.c	2007-04-23 15:28:35.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/i386/kernel/cpu/mcheck/non-fatal.c	2007-07-19 12:38:07.000000000 +1000
@@ -56,7 +56,7 @@ static DECLARE_DELAYED_WORK(mce_work, mc
 
 static void mce_work_fn(struct work_struct *work)
 { 
-	on_each_cpu(mce_checkregs, NULL, 1, 1);
+	on_each_cpu(mce_checkregs, NULL, 1);
 	schedule_delayed_work(&mce_work, MCE_RATE);
 } 
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/i386/kernel/cpu/perfctr-watchdog.c working-2.6.22-git11-on_each_cpu/arch/i386/kernel/cpu/perfctr-watchdog.c
--- linux-2.6.22-git11/arch/i386/kernel/cpu/perfctr-watchdog.c	2007-07-10 14:32:02.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/i386/kernel/cpu/perfctr-watchdog.c	2007-07-19 12:38:07.000000000 +1000
@@ -173,7 +173,7 @@ void disable_lapic_nmi_watchdog(void)
 	if (atomic_read(&nmi_active) <= 0)
 		return;
 
-	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
+	on_each_cpu(stop_apic_nmi_watchdog, NULL, 1);
 	wd_ops->unreserve();
 
 	BUG_ON(atomic_read(&nmi_active) != 0);
@@ -195,7 +195,7 @@ void enable_lapic_nmi_watchdog(void)
 		return;
 	}
 
-	on_each_cpu(setup_apic_nmi_watchdog, NULL, 0, 1);
+	on_each_cpu(setup_apic_nmi_watchdog, NULL, 1);
 	touch_nmi_watchdog();
 }
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/i386/kernel/io_apic.c working-2.6.22-git11-on_each_cpu/arch/i386/kernel/io_apic.c
--- linux-2.6.22-git11/arch/i386/kernel/io_apic.c	2007-07-19 11:56:20.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/i386/kernel/io_apic.c	2007-07-19 12:38:07.000000000 +1000
@@ -1624,7 +1624,7 @@ void /*__init*/ print_local_APIC(void * 
 
 void print_all_local_APICs (void)
 {
-	on_each_cpu(print_local_APIC, NULL, 1, 1);
+	on_each_cpu(print_local_APIC, NULL, 1);
 }
 
 void /*__init*/ print_PIC(void)
@@ -2113,7 +2113,7 @@ static void setup_nmi (void)
 	 */ 
 	apic_printk(APIC_VERBOSE, KERN_INFO "activating NMI Watchdog ...");
 
-	on_each_cpu(enable_NMI_through_LVT0, NULL, 1, 1);
+	on_each_cpu(enable_NMI_through_LVT0, NULL, 1);
 
 	apic_printk(APIC_VERBOSE, " done.\n");
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/i386/kernel/nmi.c working-2.6.22-git11-on_each_cpu/arch/i386/kernel/nmi.c
--- linux-2.6.22-git11/arch/i386/kernel/nmi.c	2007-07-19 11:56:20.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/i386/kernel/nmi.c	2007-07-19 12:38:07.000000000 +1000
@@ -221,7 +221,7 @@ static void __acpi_nmi_enable(void *__un
 void acpi_nmi_enable(void)
 {
 	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+		on_each_cpu(__acpi_nmi_enable, NULL, 1);
 }
 
 static void __acpi_nmi_disable(void *__unused)
@@ -235,7 +235,7 @@ static void __acpi_nmi_disable(void *__u
 void acpi_nmi_disable(void)
 {
 	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+		on_each_cpu(__acpi_nmi_disable, NULL, 1);
 }
 
 void setup_apic_nmi_watchdog (void *unused)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/i386/kernel/smp.c working-2.6.22-git11-on_each_cpu/arch/i386/kernel/smp.c
--- linux-2.6.22-git11/arch/i386/kernel/smp.c	2007-07-19 11:56:20.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/i386/kernel/smp.c	2007-07-19 12:38:07.000000000 +1000
@@ -460,7 +460,7 @@ static void do_flush_tlb_all(void* info)
 
 void flush_tlb_all(void)
 {
-	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
+	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
 /*
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/i386/mach-voyager/voyager_smp.c working-2.6.22-git11-on_each_cpu/arch/i386/mach-voyager/voyager_smp.c
--- linux-2.6.22-git11/arch/i386/mach-voyager/voyager_smp.c	2007-07-10 14:32:02.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/i386/mach-voyager/voyager_smp.c	2007-07-19 12:38:07.000000000 +1000
@@ -1185,7 +1185,7 @@ do_flush_tlb_all(void* info)
 void
 flush_tlb_all(void)
 {
-	on_each_cpu(do_flush_tlb_all, 0, 1, 1);
+	on_each_cpu(do_flush_tlb_all, 0, 1);
 }
 
 /* used to set up the trampoline for other CPUs when the memory manager
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/i386/mm/pageattr.c working-2.6.22-git11-on_each_cpu/arch/i386/mm/pageattr.c
--- linux-2.6.22-git11/arch/i386/mm/pageattr.c	2007-07-19 11:56:20.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/i386/mm/pageattr.c	2007-07-19 12:38:07.000000000 +1000
@@ -192,7 +192,7 @@ __change_page_attr(struct page *page, pg
 
 static inline void flush_map(struct list_head *l)
 {
-	on_each_cpu(flush_kernel_map, l, 1, 1);
+	on_each_cpu(flush_kernel_map, l, 1);
 }
 
 /*
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/i386/oprofile/nmi_int.c working-2.6.22-git11-on_each_cpu/arch/i386/oprofile/nmi_int.c
--- linux-2.6.22-git11/arch/i386/oprofile/nmi_int.c	2007-07-10 14:32:02.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/i386/oprofile/nmi_int.c	2007-07-19 12:38:07.000000000 +1000
@@ -220,8 +220,8 @@ static int nmi_setup(void)
 		}
 
 	}
-	on_each_cpu(nmi_save_registers, NULL, 0, 1);
-	on_each_cpu(nmi_cpu_setup, NULL, 0, 1);
+	on_each_cpu(nmi_save_registers, NULL, 1);
+	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
 	return 0;
 }
@@ -276,7 +276,7 @@ static void nmi_cpu_shutdown(void * dumm
 static void nmi_shutdown(void)
 {
 	nmi_enabled = 0;
-	on_each_cpu(nmi_cpu_shutdown, NULL, 0, 1);
+	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
 	free_msrs();
 }
@@ -291,7 +291,7 @@ static void nmi_cpu_start(void * dummy)
 
 static int nmi_start(void)
 {
-	on_each_cpu(nmi_cpu_start, NULL, 0, 1);
+	on_each_cpu(nmi_cpu_start, NULL, 1);
 	return 0;
 }
  
@@ -305,7 +305,7 @@ static void nmi_cpu_stop(void * dummy)
  
 static void nmi_stop(void)
 {
-	on_each_cpu(nmi_cpu_stop, NULL, 0, 1);
+	on_each_cpu(nmi_cpu_stop, NULL, 1);
 }
 
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/ia64/kernel/mca.c working-2.6.22-git11-on_each_cpu/arch/ia64/kernel/mca.c
--- linux-2.6.22-git11/arch/ia64/kernel/mca.c	2007-07-19 11:56:21.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/ia64/kernel/mca.c	2007-07-19 12:38:07.000000000 +1000
@@ -683,7 +683,7 @@ ia64_mca_cmc_vector_enable (void *dummy)
 static void
 ia64_mca_cmc_vector_disable_keventd(struct work_struct *unused)
 {
-	on_each_cpu(ia64_mca_cmc_vector_disable, NULL, 1, 0);
+	on_each_cpu(ia64_mca_cmc_vector_disable, NULL, 0);
 }
 
 /*
@@ -695,7 +695,7 @@ ia64_mca_cmc_vector_disable_keventd(stru
 static void
 ia64_mca_cmc_vector_enable_keventd(struct work_struct *unused)
 {
-	on_each_cpu(ia64_mca_cmc_vector_enable, NULL, 1, 0);
+	on_each_cpu(ia64_mca_cmc_vector_enable, NULL, 0);
 }
 
 /*
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/ia64/kernel/perfmon.c working-2.6.22-git11-on_each_cpu/arch/ia64/kernel/perfmon.c
--- linux-2.6.22-git11/arch/ia64/kernel/perfmon.c	2007-07-10 14:32:03.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/ia64/kernel/perfmon.c	2007-07-19 12:38:07.000000000 +1000
@@ -6548,11 +6548,7 @@ pfm_install_alt_pmu_interrupt(pfm_intr_h
 	}
 
 	/* save the current system wide pmu states */
-	ret = on_each_cpu(pfm_alt_save_pmu_state, NULL, 0, 1);
-	if (ret) {
-		DPRINT(("on_each_cpu() failed: %d\n", ret));
-		goto cleanup_reserve;
-	}
+	on_each_cpu(pfm_alt_save_pmu_state, NULL, 1);
 
 	/* officially change to the alternate interrupt handler */
 	pfm_alt_intr_handler = hdl;
@@ -6579,7 +6575,6 @@ int
 pfm_remove_alt_pmu_interrupt(pfm_intr_handler_desc_t *hdl)
 {
 	int i;
-	int ret;
 
 	if (hdl == NULL) return -EINVAL;
 
@@ -6593,10 +6588,7 @@ pfm_remove_alt_pmu_interrupt(pfm_intr_ha
 
 	pfm_alt_intr_handler = NULL;
 
-	ret = on_each_cpu(pfm_alt_restore_pmu_state, NULL, 0, 1);
-	if (ret) {
-		DPRINT(("on_each_cpu() failed: %d\n", ret));
-	}
+	on_each_cpu(pfm_alt_restore_pmu_state, NULL, 1);
 
 	for_each_online_cpu(i) {
 		pfm_unreserve_session(NULL, 1, i);
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/ia64/kernel/smp.c working-2.6.22-git11-on_each_cpu/arch/ia64/kernel/smp.c
--- linux-2.6.22-git11/arch/ia64/kernel/smp.c	2007-07-10 14:32:03.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/ia64/kernel/smp.c	2007-07-19 12:38:07.000000000 +1000
@@ -319,7 +319,7 @@ smp_flush_tlb_cpumask(cpumask_t xcpumask
 void
 smp_flush_tlb_all (void)
 {
-	on_each_cpu((void (*)(void *))local_flush_tlb_all, NULL, 1, 1);
+	on_each_cpu((void (*)(void *))local_flush_tlb_all, NULL, 1);
 }
 
 void
@@ -342,7 +342,7 @@ smp_flush_tlb_mm (struct mm_struct *mm)
 	 * anyhow, and once a CPU is interrupted, the cost of local_flush_tlb_all() is
 	 * rather trivial.
 	 */
-	on_each_cpu((void (*)(void *))local_finish_flush_tlb_mm, mm, 1, 1);
+	on_each_cpu((void (*)(void *))local_finish_flush_tlb_mm, mm, 1);
 }
 
 /*
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/mips/kernel/irq-rm9000.c working-2.6.22-git11-on_each_cpu/arch/mips/kernel/irq-rm9000.c
--- linux-2.6.22-git11/arch/mips/kernel/irq-rm9000.c	2007-04-26 20:04:33.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/mips/kernel/irq-rm9000.c	2007-07-19 12:38:07.000000000 +1000
@@ -49,7 +49,7 @@ static void local_rm9k_perfcounter_irq_s
 
 static unsigned int rm9k_perfcounter_irq_startup(unsigned int irq)
 {
-	on_each_cpu(local_rm9k_perfcounter_irq_startup, (void *) irq, 0, 1);
+	on_each_cpu(local_rm9k_perfcounter_irq_startup, (void *) irq, 1);
 
 	return 0;
 }
@@ -66,7 +66,7 @@ static void local_rm9k_perfcounter_irq_s
 
 static void rm9k_perfcounter_irq_shutdown(unsigned int irq)
 {
-	on_each_cpu(local_rm9k_perfcounter_irq_shutdown, (void *) irq, 0, 1);
+	on_each_cpu(local_rm9k_perfcounter_irq_shutdown, (void *) irq, 1);
 }
 
 static struct irq_chip rm9k_irq_controller = {
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/mips/kernel/smp.c working-2.6.22-git11-on_each_cpu/arch/mips/kernel/smp.c
--- linux-2.6.22-git11/arch/mips/kernel/smp.c	2007-07-19 11:56:22.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/mips/kernel/smp.c	2007-07-19 12:38:07.000000000 +1000
@@ -282,7 +282,7 @@ static void flush_tlb_all_ipi(void *info
 
 void flush_tlb_all(void)
 {
-	on_each_cpu(flush_tlb_all_ipi, NULL, 1, 1);
+	on_each_cpu(flush_tlb_all_ipi, NULL, 1);
 }
 
 static void flush_tlb_mm_ipi(void *mm)
@@ -394,7 +394,7 @@ void flush_tlb_kernel_range(unsigned lon
 
 	fd.addr1 = start;
 	fd.addr2 = end;
-	on_each_cpu(flush_tlb_kernel_range_ipi, (void *)&fd, 1, 1);
+	on_each_cpu(flush_tlb_kernel_range_ipi, (void *)&fd, 1);
 }
 
 static void flush_tlb_page_ipi(void *info)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/mips/mm/c-sb1.c working-2.6.22-git11-on_each_cpu/arch/mips/mm/c-sb1.c
--- linux-2.6.22-git11/arch/mips/mm/c-sb1.c	2007-07-19 11:56:23.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/mips/mm/c-sb1.c	2007-07-19 12:38:08.000000000 +1000
@@ -256,7 +256,7 @@ static void sb1_flush_cache_data_page(un
 	if (in_atomic())
 		__sb1_writeback_inv_dcache_range(addr, addr + PAGE_SIZE);
 	else
-		on_each_cpu(sb1_flush_cache_data_page_ipi, (void *) addr, 1, 1);
+		on_each_cpu(sb1_flush_cache_data_page_ipi, (void *) addr, 1);
 }
 #else
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/mips/oprofile/common.c working-2.6.22-git11-on_each_cpu/arch/mips/oprofile/common.c
--- linux-2.6.22-git11/arch/mips/oprofile/common.c	2007-04-23 15:28:54.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/mips/oprofile/common.c	2007-07-19 12:38:08.000000000 +1000
@@ -27,7 +27,7 @@ static int op_mips_setup(void)
 	model->reg_setup(ctr);
 
 	/* Configure the registers on all cpus.  */
-	on_each_cpu(model->cpu_setup, NULL, 0, 1);
+	on_each_cpu(model->cpu_setup, NULL, 1);
 
         return 0;
 }
@@ -58,7 +58,7 @@ static int op_mips_create_files(struct s
 
 static int op_mips_start(void)
 {
-	on_each_cpu(model->cpu_start, NULL, 0, 1);
+	on_each_cpu(model->cpu_start, NULL, 1);
 
 	return 0;
 }
@@ -66,7 +66,7 @@ static int op_mips_start(void)
 static void op_mips_stop(void)
 {
 	/* Disable performance monitoring for all counters.  */
-	on_each_cpu(model->cpu_stop, NULL, 0, 1);
+	on_each_cpu(model->cpu_stop, NULL, 1);
 }
 
 int __init oprofile_arch_init(struct oprofile_operations *ops)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/parisc/kernel/cache.c working-2.6.22-git11-on_each_cpu/arch/parisc/kernel/cache.c
--- linux-2.6.22-git11/arch/parisc/kernel/cache.c	2007-07-10 14:32:09.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/parisc/kernel/cache.c	2007-07-19 12:38:08.000000000 +1000
@@ -51,12 +51,12 @@ static struct pdc_btlb_info btlb_info __
 void
 flush_data_cache(void)
 {
-	on_each_cpu(flush_data_cache_local, NULL, 1, 1);
+	on_each_cpu(flush_data_cache_local, NULL, 1);
 }
 void 
 flush_instruction_cache(void)
 {
-	on_each_cpu(flush_instruction_cache_local, NULL, 1, 1);
+	on_each_cpu(flush_instruction_cache_local, NULL, 1);
 }
 #endif
 
@@ -515,7 +515,7 @@ static void cacheflush_h_tmp_function(vo
 
 void flush_cache_all(void)
 {
-	on_each_cpu(cacheflush_h_tmp_function, NULL, 1, 1);
+	on_each_cpu(cacheflush_h_tmp_function, NULL, 1);
 }
 
 void flush_cache_mm(struct mm_struct *mm)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/parisc/kernel/smp.c working-2.6.22-git11-on_each_cpu/arch/parisc/kernel/smp.c
--- linux-2.6.22-git11/arch/parisc/kernel/smp.c	2007-07-10 14:32:09.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/parisc/kernel/smp.c	2007-07-19 12:38:08.000000000 +1000
@@ -383,7 +383,7 @@ EXPORT_SYMBOL(smp_call_function);
 void
 smp_flush_tlb_all(void)
 {
-	on_each_cpu(flush_tlb_all_local, NULL, 1, 1);
+	on_each_cpu(flush_tlb_all_local, NULL, 1);
 }
 
 /*
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/parisc/mm/init.c working-2.6.22-git11-on_each_cpu/arch/parisc/mm/init.c
--- linux-2.6.22-git11/arch/parisc/mm/init.c	2007-07-10 14:32:10.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/parisc/mm/init.c	2007-07-19 12:38:08.000000000 +1000
@@ -1047,7 +1047,7 @@ void flush_tlb_all(void)
 	    do_recycle++;
 	}
 	spin_unlock(&sid_lock);
-	on_each_cpu(flush_tlb_all_local, NULL, 1, 1);
+	on_each_cpu(flush_tlb_all_local, NULL, 1);
 	if (do_recycle) {
 	    spin_lock(&sid_lock);
 	    recycle_sids(recycle_ndirty,recycle_dirty_array);
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/powerpc/kernel/rtas.c working-2.6.22-git11-on_each_cpu/arch/powerpc/kernel/rtas.c
--- linux-2.6.22-git11/arch/powerpc/kernel/rtas.c	2007-07-10 14:32:14.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/powerpc/kernel/rtas.c	2007-07-19 12:38:08.000000000 +1000
@@ -727,8 +727,7 @@ static int rtas_ibm_suspend_me(struct rt
 	/* Call function on all CPUs.  One of us will make the
 	 * rtas call
 	 */
-	if (on_each_cpu(rtas_percpu_suspend_me, &data, 1, 0))
-		data.waiting = -EINVAL;
+	on_each_cpu(rtas_percpu_suspend_me, &data, 0);
 
 	if (data.waiting != 0)
 		printk(KERN_ERR "Error doing global join\n");
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/powerpc/kernel/tau_6xx.c working-2.6.22-git11-on_each_cpu/arch/powerpc/kernel/tau_6xx.c
--- linux-2.6.22-git11/arch/powerpc/kernel/tau_6xx.c	2007-04-23 15:21:04.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/powerpc/kernel/tau_6xx.c	2007-07-19 12:38:08.000000000 +1000
@@ -192,7 +192,7 @@ static void tau_timeout_smp(unsigned lon
 
 	/* schedule ourselves to be run again */
 	mod_timer(&tau_timer, jiffies + shrink_timer) ;
-	on_each_cpu(tau_timeout, NULL, 1, 0);
+	on_each_cpu(tau_timeout, NULL, 0);
 }
 
 /*
@@ -234,7 +234,7 @@ int __init TAU_init(void)
 	tau_timer.expires = jiffies + shrink_timer;
 	add_timer(&tau_timer);
 
-	on_each_cpu(TAU_init_smp, NULL, 1, 0);
+	on_each_cpu(TAU_init_smp, NULL, 0);
 
 	printk("Thermal assist unit ");
 #ifdef CONFIG_TAU_INT
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/powerpc/kernel/time.c working-2.6.22-git11-on_each_cpu/arch/powerpc/kernel/time.c
--- linux-2.6.22-git11/arch/powerpc/kernel/time.c	2007-07-19 11:56:27.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/powerpc/kernel/time.c	2007-07-19 12:40:31.000000000 +1000
@@ -252,7 +252,7 @@ void snapshot_timebases(void)
 {
 	if (!cpu_has_feature(CPU_FTR_PURR))
 		return;
-	on_each_cpu(snapshot_tb_and_purr, NULL, 0, 1);
+	on_each_cpu(snapshot_tb_and_purr, NULL, 1);
 }
 
 /*
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/powerpc/mm/slice.c working-2.6.22-git11-on_each_cpu/arch/powerpc/mm/slice.c
--- linux-2.6.22-git11/arch/powerpc/mm/slice.c	2007-07-10 14:32:15.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/powerpc/mm/slice.c	2007-07-19 12:38:08.000000000 +1000
@@ -218,7 +218,7 @@ static void slice_convert(struct mm_stru
 	mb();
 
 	/* XXX this is sub-optimal but will do for now */
-	on_each_cpu(slice_flush_segments, mm, 0, 1);
+	on_each_cpu(slice_flush_segments, mm, 1);
 #ifdef CONFIG_SPU_BASE
 	spu_flush_all_slbs(mm);
 #endif
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/powerpc/oprofile/common.c working-2.6.22-git11-on_each_cpu/arch/powerpc/oprofile/common.c
--- linux-2.6.22-git11/arch/powerpc/oprofile/common.c	2007-07-10 14:32:15.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/powerpc/oprofile/common.c	2007-07-19 12:38:08.000000000 +1000
@@ -52,7 +52,7 @@ static int op_powerpc_setup(void)
 	model->reg_setup(ctr, &sys, model->num_counters);
 
 	/* Configure the registers on all cpus.  */
-	on_each_cpu(op_powerpc_cpu_setup, NULL, 0, 1);
+	on_each_cpu(op_powerpc_cpu_setup, NULL, 1);
 
 	return 0;
 }
@@ -72,7 +72,7 @@ static int op_powerpc_start(void)
 	if (model->global_start)
 		model->global_start(ctr);
 	if (model->start)
-		on_each_cpu(op_powerpc_cpu_start, NULL, 0, 1);
+		on_each_cpu(op_powerpc_cpu_start, NULL, 1);
 	return 0;
 }
 
@@ -84,7 +84,7 @@ static inline void op_powerpc_cpu_stop(v
 static void op_powerpc_stop(void)
 {
 	if (model->stop)
-		on_each_cpu(op_powerpc_cpu_stop, NULL, 0, 1);
+		on_each_cpu(op_powerpc_cpu_stop, NULL, 1);
         if (model->global_stop)
                 model->global_stop();
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/s390/kernel/smp.c working-2.6.22-git11-on_each_cpu/arch/s390/kernel/smp.c
--- linux-2.6.22-git11/arch/s390/kernel/smp.c	2007-07-19 11:56:32.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/s390/kernel/smp.c	2007-07-19 12:38:08.000000000 +1000
@@ -333,7 +333,7 @@ void smp_ptlb_callback(void *info)
 
 void smp_ptlb_all(void)
 {
-	on_each_cpu(smp_ptlb_callback, NULL, 0, 1);
+	on_each_cpu(smp_ptlb_callback, NULL, 1);
 }
 EXPORT_SYMBOL(smp_ptlb_all);
 #endif /* ! CONFIG_64BIT */
@@ -381,7 +381,7 @@ void smp_ctl_set_bit(int cr, int bit)
 	memset(&parms.orvals, 0, sizeof(parms.orvals));
 	memset(&parms.andvals, 0xff, sizeof(parms.andvals));
 	parms.orvals[cr] = 1 << bit;
-	on_each_cpu(smp_ctl_bit_callback, &parms, 0, 1);
+	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
 }
 EXPORT_SYMBOL(smp_ctl_set_bit);
 
@@ -395,7 +395,7 @@ void smp_ctl_clear_bit(int cr, int bit)
 	memset(&parms.orvals, 0, sizeof(parms.orvals));
 	memset(&parms.andvals, 0xff, sizeof(parms.andvals));
 	parms.andvals[cr] = ~(1L << bit);
-	on_each_cpu(smp_ctl_bit_callback, &parms, 0, 1);
+	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
 }
 EXPORT_SYMBOL(smp_ctl_clear_bit);
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/s390/kernel/time.c working-2.6.22-git11-on_each_cpu/arch/s390/kernel/time.c
--- linux-2.6.22-git11/arch/s390/kernel/time.c	2007-07-19 11:56:32.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/s390/kernel/time.c	2007-07-19 12:38:08.000000000 +1000
@@ -1026,7 +1026,7 @@ static void etr_work_fn(struct work_stru
 	if (!eacr.ea) {
 		/* Both ports offline. Reset everything. */
 		eacr.dp = eacr.es = eacr.sl = 0;
-		on_each_cpu(etr_disable_sync_clock, NULL, 0, 1);
+		on_each_cpu(etr_disable_sync_clock, NULL, 1);
 		del_timer_sync(&etr_timer);
 		etr_update_eacr(eacr);
 		set_bit(ETR_FLAG_EACCES, &etr_flags);
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/sparc64/mm/hugetlbpage.c working-2.6.22-git11-on_each_cpu/arch/sparc64/mm/hugetlbpage.c
--- linux-2.6.22-git11/arch/sparc64/mm/hugetlbpage.c	2007-07-10 14:32:25.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/sparc64/mm/hugetlbpage.c	2007-07-19 12:38:08.000000000 +1000
@@ -344,7 +344,7 @@ void hugetlb_prefault_arch_hook(struct m
 			 * also executing in this address space.
 			 */
 			mm->context.sparc64_ctx_val = ctx;
-			on_each_cpu(context_reload, mm, 0, 0);
+			on_each_cpu(context_reload, mm, 0);
 		}
 		spin_unlock(&ctx_alloc_lock);
 	}
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/x86_64/kernel/io_apic.c working-2.6.22-git11-on_each_cpu/arch/x86_64/kernel/io_apic.c
--- linux-2.6.22-git11/arch/x86_64/kernel/io_apic.c	2007-07-10 14:32:27.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/x86_64/kernel/io_apic.c	2007-07-19 12:38:08.000000000 +1000
@@ -1102,7 +1102,7 @@ void __apicdebuginit print_local_APIC(vo
 
 void print_all_local_APICs (void)
 {
-	on_each_cpu(print_local_APIC, NULL, 1, 1);
+	on_each_cpu(print_local_APIC, NULL, 1);
 }
 
 void __apicdebuginit print_PIC(void)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/x86_64/kernel/mce.c working-2.6.22-git11-on_each_cpu/arch/x86_64/kernel/mce.c
--- linux-2.6.22-git11/arch/x86_64/kernel/mce.c	2007-07-19 11:56:38.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/x86_64/kernel/mce.c	2007-07-19 12:38:08.000000000 +1000
@@ -341,7 +341,7 @@ static void mcheck_check_cpu(void *info)
 
 static void mcheck_timer(struct work_struct *work)
 {
-	on_each_cpu(mcheck_check_cpu, NULL, 1, 1);
+	on_each_cpu(mcheck_check_cpu, NULL, 1);
 
 	/*
 	 * It's ok to read stale data here for notify_user and
@@ -517,7 +517,7 @@ static ssize_t mce_read(struct file *fil
 
 	/* Collect entries that were still getting written before the synchronize. */
 
-	on_each_cpu(collect_tscs, cpu_tsc, 1, 1);
+	on_each_cpu(collect_tscs, cpu_tsc, 1);
 	for (i = next; i < MCE_LOG_LEN; i++) { 
 		if (mcelog.entry[i].finished && 
 		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {  
@@ -617,7 +617,7 @@ static void mce_restart(void) 
 	if (next_interval)
 		cancel_delayed_work(&mcheck_work);
 	/* Timer race is harmless here */
-	on_each_cpu(mce_init, NULL, 1, 1);       
+	on_each_cpu(mce_init, NULL, 1);
 	next_interval = check_interval * HZ;
 	if (next_interval)
 		schedule_delayed_work(&mcheck_work, next_interval);
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/x86_64/kernel/nmi.c working-2.6.22-git11-on_each_cpu/arch/x86_64/kernel/nmi.c
--- linux-2.6.22-git11/arch/x86_64/kernel/nmi.c	2007-07-19 11:56:38.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/x86_64/kernel/nmi.c	2007-07-19 12:38:08.000000000 +1000
@@ -172,7 +172,7 @@ static void __acpi_nmi_disable(void *__u
 void acpi_nmi_disable(void)
 {
 	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
+		on_each_cpu(__acpi_nmi_disable, NULL, 1);
 }
 
 static void __acpi_nmi_enable(void *__unused)
@@ -186,7 +186,7 @@ static void __acpi_nmi_enable(void *__un
 void acpi_nmi_enable(void)
 {
 	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
-		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
+		on_each_cpu(__acpi_nmi_enable, NULL, 1);
 }
 #ifdef CONFIG_PM
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/x86_64/kernel/smp.c working-2.6.22-git11-on_each_cpu/arch/x86_64/kernel/smp.c
--- linux-2.6.22-git11/arch/x86_64/kernel/smp.c	2007-07-19 11:56:38.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/x86_64/kernel/smp.c	2007-07-19 12:38:08.000000000 +1000
@@ -280,7 +280,7 @@ static void do_flush_tlb_all(void* info)
 
 void flush_tlb_all(void)
 {
-	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
+	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
 /*
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/x86_64/kernel/vsyscall.c working-2.6.22-git11-on_each_cpu/arch/x86_64/kernel/vsyscall.c
--- linux-2.6.22-git11/arch/x86_64/kernel/vsyscall.c	2007-07-10 14:32:28.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/x86_64/kernel/vsyscall.c	2007-07-19 12:38:08.000000000 +1000
@@ -355,7 +355,7 @@ static int __init vsyscall_init(void)
 #ifdef CONFIG_SYSCTL
 	register_sysctl_table(kernel_root_table2);
 #endif
-	on_each_cpu(cpu_vsyscall_init, NULL, 0, 1);
+	on_each_cpu(cpu_vsyscall_init, NULL, 1);
 	hotcpu_notifier(cpu_vsyscall_notifier, 0);
 	return 0;
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/arch/x86_64/mm/pageattr.c working-2.6.22-git11-on_each_cpu/arch/x86_64/mm/pageattr.c
--- linux-2.6.22-git11/arch/x86_64/mm/pageattr.c	2007-07-10 14:32:28.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/arch/x86_64/mm/pageattr.c	2007-07-19 12:38:08.000000000 +1000
@@ -88,7 +88,7 @@ static void flush_kernel_map(void *arg)
 
 static inline void flush_map(struct list_head *l)
 {	
-	on_each_cpu(flush_kernel_map, l, 1, 1);
+	on_each_cpu(flush_kernel_map, l, 1);
 }
 
 static LIST_HEAD(deferred_pages); /* protected by init_mm.mmap_sem */
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/block/blktrace.c working-2.6.22-git11-on_each_cpu/block/blktrace.c
--- linux-2.6.22-git11/block/blktrace.c	2007-04-26 20:04:53.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/block/blktrace.c	2007-07-19 12:38:08.000000000 +1000
@@ -552,7 +552,7 @@ static void blk_trace_set_ht_offsets(voi
 static __init int blk_trace_init(void)
 {
 	mutex_init(&blk_tree_mutex);
-	on_each_cpu(blk_trace_check_cpu_time, NULL, 1, 1);
+	on_each_cpu(blk_trace_check_cpu_time, NULL, 1);
 	blk_trace_set_ht_offsets();
 
 	return 0;
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/drivers/acpi/processor_idle.c working-2.6.22-git11-on_each_cpu/drivers/acpi/processor_idle.c
--- linux-2.6.22-git11/drivers/acpi/processor_idle.c	2007-07-10 14:32:30.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/drivers/acpi/processor_idle.c	2007-07-19 12:38:08.000000000 +1000
@@ -286,9 +286,9 @@ static void acpi_propagate_timer_broadca
 	cpumask_t mask = cpumask_of_cpu(pr->id);
 
 	if (pr->power.timer_broadcast_on_state < INT_MAX)
-		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
+		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1);
 	else
-		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
+		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1);
 #endif
 }
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/drivers/char/agp/generic.c working-2.6.22-git11-on_each_cpu/drivers/char/agp/generic.c
--- linux-2.6.22-git11/drivers/char/agp/generic.c	2007-07-10 14:32:32.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/drivers/char/agp/generic.c	2007-07-19 12:38:08.000000000 +1000
@@ -1228,8 +1228,7 @@ static void ipi_handler(void *null)
 
 void global_cache_flush(void)
 {
-	if (on_each_cpu(ipi_handler, NULL, 1, 1) != 0)
-		panic(PFX "timed out waiting for the other CPUs!\n");
+	on_each_cpu(ipi_handler, NULL, 1);
 }
 EXPORT_SYMBOL(global_cache_flush);
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/drivers/kvm/kvm_main.c working-2.6.22-git11-on_each_cpu/drivers/kvm/kvm_main.c
--- linux-2.6.22-git11/drivers/kvm/kvm_main.c	2007-07-19 11:56:49.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/drivers/kvm/kvm_main.c	2007-07-19 12:38:08.000000000 +1000
@@ -2934,7 +2934,7 @@ static int kvm_reboot(struct notifier_bl
 		 * in vmx root mode.
 		 */
 		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
-		on_each_cpu(hardware_disable, NULL, 0, 1);
+		on_each_cpu(hardware_disable, NULL, 1);
 	}
 	return NOTIFY_OK;
 }
@@ -3157,7 +3157,7 @@ int kvm_init_arch(struct kvm_arch_ops *o
 	if (r < 0)
 		goto out;
 
-	on_each_cpu(hardware_enable, NULL, 0, 1);
+	on_each_cpu(hardware_enable, NULL, 1);
 	r = register_cpu_notifier(&kvm_cpu_notifier);
 	if (r)
 		goto out_free_1;
@@ -3189,7 +3189,7 @@ out_free_2:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 out_free_1:
-	on_each_cpu(hardware_disable, NULL, 0, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	kvm_arch_ops->hardware_unsetup();
 out:
 	kvm_arch_ops = NULL;
@@ -3203,7 +3203,7 @@ void kvm_exit_arch(void)
 	sysdev_class_unregister(&kvm_sysdev_class);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	unregister_cpu_notifier(&kvm_cpu_notifier);
-	on_each_cpu(hardware_disable, NULL, 0, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	kvm_arch_ops->hardware_unsetup();
 	kvm_arch_ops = NULL;
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/drivers/kvm/vmx.c working-2.6.22-git11-on_each_cpu/drivers/kvm/vmx.c
--- linux-2.6.22-git11/drivers/kvm/vmx.c	2007-07-19 11:56:49.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/drivers/kvm/vmx.c	2007-07-19 12:58:39.000000000 +1000
@@ -2226,7 +2226,7 @@ static void vmx_inject_page_fault(struct
 static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->vmcs) {
-		on_each_cpu(__vcpu_clear, vcpu, 0, 1);
+		on_each_cpu(__vcpu_clear, vcpu, 1);
 		free_vmcs(vcpu->vmcs);
 		vcpu->vmcs = NULL;
 	}
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/fs/buffer.c working-2.6.22-git11-on_each_cpu/fs/buffer.c
--- linux-2.6.22-git11/fs/buffer.c	2007-07-19 11:57:44.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/fs/buffer.c	2007-07-19 12:38:08.000000000 +1000
@@ -1419,7 +1419,7 @@ static void invalidate_bh_lru(void *arg)
 	
 void invalidate_bh_lrus(void)
 {
-	on_each_cpu(invalidate_bh_lru, NULL, 1, 1);
+	on_each_cpu(invalidate_bh_lru, NULL, 1);
 }
 
 void set_bh_page(struct buffer_head *bh,
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/include/linux/smp.h working-2.6.22-git11-on_each_cpu/include/linux/smp.h
--- linux-2.6.22-git11/include/linux/smp.h	2007-07-19 11:58:16.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/include/linux/smp.h	2007-07-19 12:39:28.000000000 +1000
@@ -60,7 +60,7 @@ int smp_call_function_single(int cpuid, 
 /*
  * Call a function on all processors
  */
-int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait);
+void on_each_cpu(void (*func) (void *info), void *info, int wait);
 
 #define MSG_ALL_BUT_SELF	0x8000	/* Assume <32768 CPU's */
 #define MSG_ALL			0x8001
@@ -89,13 +89,12 @@ static inline int up_smp_call_function(v
 	return 0;
 }
 #define smp_call_function(func,info,retry,wait)	(up_smp_call_function())
-#define on_each_cpu(func,info,retry,wait)	\
-	({					\
+#define on_each_cpu(func,info,wait)		\
+	do {					\
 		local_irq_disable();		\
 		func(info);			\
 		local_irq_enable();		\
-		0;				\
-	})
+	} while(0)
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/kernel/hrtimer.c working-2.6.22-git11-on_each_cpu/kernel/hrtimer.c
--- linux-2.6.22-git11/kernel/hrtimer.c	2007-07-19 11:58:20.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/kernel/hrtimer.c	2007-07-19 12:38:08.000000000 +1000
@@ -458,7 +458,7 @@ static void retrigger_next_event(void *a
 void clock_was_set(void)
 {
 	/* Retrigger the CPU local events everywhere */
-	on_each_cpu(retrigger_next_event, NULL, 0, 1);
+	on_each_cpu(retrigger_next_event, NULL, 1);
 }
 
 /*
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/kernel/profile.c working-2.6.22-git11-on_each_cpu/kernel/profile.c
--- linux-2.6.22-git11/kernel/profile.c	2007-07-10 14:34:06.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/kernel/profile.c	2007-07-19 12:38:08.000000000 +1000
@@ -251,7 +251,7 @@ static void profile_flip_buffers(void)
 	mutex_lock(&profile_flip_mutex);
 	j = per_cpu(cpu_profile_flip, get_cpu());
 	put_cpu();
-	on_each_cpu(__profile_flip_buffers, NULL, 0, 1);
+	on_each_cpu(__profile_flip_buffers, NULL, 1);
 	for_each_online_cpu(cpu) {
 		struct profile_hit *hits = per_cpu(cpu_profile_hits, cpu)[j];
 		for (i = 0; i < NR_PROFILE_HIT; ++i) {
@@ -274,7 +274,7 @@ static void profile_discard_flip_buffers
 	mutex_lock(&profile_flip_mutex);
 	i = per_cpu(cpu_profile_flip, get_cpu());
 	put_cpu();
-	on_each_cpu(__profile_flip_buffers, NULL, 0, 1);
+	on_each_cpu(__profile_flip_buffers, NULL, 1);
 	for_each_online_cpu(cpu) {
 		struct profile_hit *hits = per_cpu(cpu_profile_hits, cpu)[i];
 		memset(hits, 0, NR_PROFILE_HIT*sizeof(struct profile_hit));
@@ -557,7 +557,7 @@ static int __init create_hash_tables(voi
 out_cleanup:
 	prof_on = 0;
 	smp_mb();
-	on_each_cpu(profile_nop, NULL, 0, 1);
+	on_each_cpu(profile_nop, NULL, 1);
 	for_each_online_cpu(cpu) {
 		struct page *page;
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/kernel/rcupdate.c working-2.6.22-git11-on_each_cpu/kernel/rcupdate.c
--- linux-2.6.22-git11/kernel/rcupdate.c	2007-07-10 14:34:06.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/kernel/rcupdate.c	2007-07-19 12:38:08.000000000 +1000
@@ -218,7 +218,7 @@ void rcu_barrier(void)
 	mutex_lock(&rcu_barrier_mutex);
 	init_completion(&rcu_barrier_completion);
 	atomic_set(&rcu_barrier_cpu_count, 0);
-	on_each_cpu(rcu_barrier_func, NULL, 0, 1);
+	on_each_cpu(rcu_barrier_func, NULL, 1);
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
 }
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/kernel/softirq.c working-2.6.22-git11-on_each_cpu/kernel/softirq.c
--- linux-2.6.22-git11/kernel/softirq.c	2007-07-19 11:58:20.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/kernel/softirq.c	2007-07-19 12:38:08.000000000 +1000
@@ -647,17 +647,14 @@ __init int spawn_ksoftirqd(void)
 /*
  * Call a function on all processors
  */
-int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait)
+void on_each_cpu(void (*func) (void *info), void *info, int wait)
 {
-	int ret = 0;
-
 	preempt_disable();
-	ret = smp_call_function(func, info, retry, wait);
+	smp_call_function(func, info, 1, wait);
 	local_irq_disable();
 	func(info);
 	local_irq_enable();
 	preempt_enable();
-	return ret;
 }
 EXPORT_SYMBOL(on_each_cpu);
 #endif
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/mm/slab.c working-2.6.22-git11-on_each_cpu/mm/slab.c
--- linux-2.6.22-git11/mm/slab.c	2007-07-19 11:58:21.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/mm/slab.c	2007-07-19 12:38:08.000000000 +1000
@@ -2433,7 +2433,7 @@ static void drain_cpu_caches(struct kmem
 	struct kmem_list3 *l3;
 	int node;
 
-	on_each_cpu(do_drain, cachep, 1, 1);
+	on_each_cpu(do_drain, cachep, 1);
 	check_irq_on();
 	for_each_online_node(node) {
 		l3 = cachep->nodelists[node];
@@ -3903,7 +3903,7 @@ static int do_tune_cpucache(struct kmem_
 	}
 	new->cachep = cachep;
 
-	on_each_cpu(do_ccupdate_local, (void *)new, 1, 1);
+	on_each_cpu(do_ccupdate_local, (void *)new, 1);
 
 	check_irq_on();
 	cachep->batchcount = batchcount;
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/mm/slub.c working-2.6.22-git11-on_each_cpu/mm/slub.c
--- linux-2.6.22-git11/mm/slub.c	2007-07-19 11:58:21.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/mm/slub.c	2007-07-19 12:38:08.000000000 +1000
@@ -1424,15 +1424,7 @@ static void flush_cpu_slab(void *d)
 
 static void flush_all(struct kmem_cache *s)
 {
-#ifdef CONFIG_SMP
-	on_each_cpu(flush_cpu_slab, s, 1, 1);
-#else
-	unsigned long flags;
-
-	local_irq_save(flags);
-	flush_cpu_slab(s);
-	local_irq_restore(flags);
-#endif
+	on_each_cpu(flush_cpu_slab, s, 1);
 }
 
 /*
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/mm/vmstat.c working-2.6.22-git11-on_each_cpu/mm/vmstat.c
--- linux-2.6.22-git11/mm/vmstat.c	2007-07-19 11:58:21.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/mm/vmstat.c	2007-07-19 12:38:08.000000000 +1000
@@ -365,7 +365,7 @@ static void __refresh_cpu_vm_stats(void 
  */
 void refresh_vm_stats(void)
 {
-	on_each_cpu(__refresh_cpu_vm_stats, NULL, 0, 1);
+	on_each_cpu(__refresh_cpu_vm_stats, NULL, 1);
 }
 EXPORT_SYMBOL(refresh_vm_stats);
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/dontdiff --minimal linux-2.6.22-git11/net/iucv/iucv.c working-2.6.22-git11-on_each_cpu/net/iucv/iucv.c
--- linux-2.6.22-git11/net/iucv/iucv.c	2007-07-19 11:58:26.000000000 +1000
+++ working-2.6.22-git11-on_each_cpu/net/iucv/iucv.c	2007-07-19 12:38:08.000000000 +1000
@@ -544,7 +544,7 @@ out:
  */
 static void iucv_disable(void)
 {
-	on_each_cpu(iucv_retrieve_cpu, NULL, 0, 1);
+	on_each_cpu(iucv_retrieve_cpu, NULL, 1);
 	kfree(iucv_path_table);
 }
 


