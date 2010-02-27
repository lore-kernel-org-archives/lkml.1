Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968278Ab0B0M5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:57:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:45183 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968255Ab0B0M5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:57:18 -0500
Date: Sat, 27 Feb 2010 12:56:47 GMT
From: tip-bot for Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, rja@sgi.com, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, rja@sgi.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100226164912.GA24439@sgi.com>
References: <20100226164912.GA24439@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pci] x86: Enable NMI on all cpus on UV
Message-ID: <tip-78c06176466cbd1b3f0f67709d3023c40dbebcbd@git.kernel.org>
Git-Commit-ID: 78c06176466cbd1b3f0f67709d3023c40dbebcbd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Feb 2010 12:56:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78c06176466cbd1b3f0f67709d3023c40dbebcbd
Gitweb:     http://git.kernel.org/tip/78c06176466cbd1b3f0f67709d3023c40dbebcbd
Author:     Russ Anderson <rja@sgi.com>
AuthorDate: Fri, 26 Feb 2010 10:49:12 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 27 Feb 2010 12:34:21 +0100

x86: Enable NMI on all cpus on UV

Enable NMI on all cpus in UV system and add an NMI handler
to dump_stack on each cpu.

By default on x86 all the cpus except the boot cpu have NMI
masked off.  This patch enables NMI on all cpus in UV system
and adds an NMI handler to dump_stack on each cpu.  This
way if a system hangs we can NMI the machine and get a
backtrace from all the cpus.

Version 2: Use x86_platform driver mechanism for nmi init, per
           Ingo's suggestion.

Version 3: Clean up Ingo's nits.

Signed-off-by: Russ Anderson <rja@sgi.com>
LKML-Reference: <20100226164912.GA24439@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv.h       |    1 +
 arch/x86/include/asm/x86_init.h    |    2 +
 arch/x86/kernel/apic/x2apic_uv_x.c |   44 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c          |    1 +
 arch/x86/kernel/x86_init.c         |    3 ++
 5 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv.h b/arch/x86/include/asm/uv/uv.h
index c0a01b5..3bb9491 100644
--- a/arch/x86/include/asm/uv/uv.h
+++ b/arch/x86/include/asm/uv/uv.h
@@ -11,6 +11,7 @@ struct mm_struct;
 extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
+extern void uv_nmi_init(void);
 extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index ea0e8ea..60cc352 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -126,6 +126,7 @@ struct x86_cpuinit_ops {
  * @get_wallclock:		get time from HW clock like RTC etc.
  * @set_wallclock:		set time back to HW clock
  * @is_untracked_pat_range	exclude from PAT logic
+ * @nmi_init			enable NMI on cpus
  */
 struct x86_platform_ops {
 	unsigned long (*calibrate_tsc)(void);
@@ -133,6 +134,7 @@ struct x86_platform_ops {
 	int (*set_wallclock)(unsigned long nowtime);
 	void (*iommu_shutdown)(void);
 	bool (*is_untracked_pat_range)(u64 start, u64 end);
+	void (*nmi_init)(void);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 6ef2899..4b8dbb2 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/pci.h>
+#include <linux/kdebug.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -41,6 +42,7 @@ static enum uv_system_type uv_system_type;
 static u64 gru_start_paddr, gru_end_paddr;
 int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
+static DEFINE_SPINLOCK(uv_nmi_lock);
 
 static inline bool is_GRU_range(u64 start, u64 end)
 {
@@ -74,6 +76,7 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	if (!strcmp(oem_id, "SGI")) {
 		nodeid = early_get_nodeid();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
+		x86_platform.nmi_init = uv_nmi_init;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
 		else if (!strcmp(oem_table_id, "UVX"))
@@ -596,6 +599,46 @@ void __cpuinit uv_cpu_init(void)
 		set_x2apic_extra_bits(uv_hub_info->pnode);
 }
 
+/*
+ * When NMI is received, print a stack trace.
+ */
+int uv_handle_nmi(struct notifier_block *self, unsigned long reason, void *data)
+{
+	if (reason != DIE_NMI_IPI)
+		return NOTIFY_OK;
+	/*
+	 * Use a lock so only one cpu prints at a time
+	 * to prevent intermixed output.
+	 */
+	spin_lock(&uv_nmi_lock);
+	pr_info("NMI stack dump cpu %u:\n", smp_processor_id());
+	dump_stack();
+	spin_unlock(&uv_nmi_lock);
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block uv_dump_stack_nmi_nb = {
+	.notifier_call	= uv_handle_nmi
+};
+
+void uv_register_nmi_notifier(void)
+{
+	if (register_die_notifier(&uv_dump_stack_nmi_nb))
+		printk(KERN_WARNING "UV NMI handler failed to register\n");
+}
+
+void uv_nmi_init(void)
+{
+	unsigned int value;
+
+	/*
+	 * Unmask NMI on all cpus
+	 */
+	value = apic_read(APIC_LVT1) | APIC_DM_NMI;
+	value &= ~APIC_LVT_MASKED;
+	apic_write(APIC_LVT1, value);
+}
 
 void __init uv_system_init(void)
 {
@@ -717,6 +760,7 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
+	uv_register_nmi_notifier();
 	proc_mkdir("sgi_uv", NULL);
 
 	/* register Legacy VGA I/O redirection handler */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 678d0b8..838a118 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -320,6 +320,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	unlock_vector_lock();
 	ipi_call_unlock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+	x86_platform.nmi_init();
 
 	/* enable local interrupts */
 	local_irq_enable();
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ccd179d..ee5746c 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -76,10 +76,13 @@ struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
 	.setup_percpu_clockev		= setup_secondary_APIC_clock,
 };
 
+static void default_nmi_init(void) { };
+
 struct x86_platform_ops x86_platform = {
 	.calibrate_tsc			= native_calibrate_tsc,
 	.get_wallclock			= mach_get_cmos_time,
 	.set_wallclock			= mach_set_rtc_mmss,
 	.iommu_shutdown			= iommu_shutdown_noop,
 	.is_untracked_pat_range		= is_ISA_range,
+	.nmi_init			= default_nmi_init
 };
