Return-Path: <linux-kernel-owner+w=401wt.eu-S933380AbYCSU3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbYCSU3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYCSTjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbYCSTjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:39:16 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 76/79] [PATCH] merge native_smp_prepare_cpus
Date: Wed, 19 Mar 2008 14:26:11 -0300
Message-Id: <12059479154173-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059479112131-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

With the previous changes, code for native_smp_prepare_cpus()
in i386 and x86_64 now look very similar. merge them into
smpboot.c. Minor differences are inside ifdef

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |  170 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_32.c |  137 ---------------------------------
 arch/x86/kernel/smpboot_64.c |  141 ----------------------------------
 3 files changed, 170 insertions(+), 278 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 26118b4..45119d3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -7,6 +7,7 @@
 #include <linux/err.h>
 #include <linux/nmi.h>
 
+#include <asm/acpi.h>
 #include <asm/desc.h>
 #include <asm/nmi.h>
 #include <asm/irq.h>
@@ -75,6 +76,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 static atomic_t init_deasserted;
 
+static int boot_cpu_logical_apicid;
+
 /* ready for x86_64, no harm for x86, since it will overwrite after alloc */
 unsigned char *trampoline_base = __va(SMP_TRAMPOLINE_BASE);
 
@@ -1002,6 +1005,173 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 }
 
 /*
+ * Fall back to non SMP mode after errors.
+ *
+ * RED-PEN audit/test this more. I bet there is more state messed up here.
+ */
+static __init void disable_smp(void)
+{
+	cpu_present_map = cpumask_of_cpu(0);
+	cpu_possible_map = cpumask_of_cpu(0);
+#ifdef CONFIG_X86_32
+	smpboot_clear_io_apic_irqs();
+#endif
+	if (smp_found_config)
+		phys_cpu_present_map =
+				physid_mask_of_physid(boot_cpu_physical_apicid);
+	else
+		phys_cpu_present_map = physid_mask_of_physid(0);
+	map_cpu_to_logical_apicid();
+	cpu_set(0, per_cpu(cpu_sibling_map, 0));
+	cpu_set(0, per_cpu(cpu_core_map, 0));
+}
+
+/*
+ * Various sanity checks.
+ */
+static int __init smp_sanity_check(unsigned max_cpus)
+{
+	if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
+		printk(KERN_WARNING "weird, boot CPU (#%d) not listed"
+				    "by the BIOS.\n", hard_smp_processor_id());
+		physid_set(hard_smp_processor_id(), phys_cpu_present_map);
+	}
+
+	/*
+	 * If we couldn't find an SMP configuration at boot time,
+	 * get out of here now!
+	 */
+	if (!smp_found_config && !acpi_lapic) {
+		printk(KERN_NOTICE "SMP motherboard not detected.\n");
+		disable_smp();
+		if (APIC_init_uniprocessor())
+			printk(KERN_NOTICE "Local APIC not detected."
+					   " Using dummy APIC emulation.\n");
+		return -1;
+	}
+
+	/*
+	 * Should not be necessary because the MP table should list the boot
+	 * CPU too, but we do it for the sake of robustness anyway.
+	 */
+	if (!check_phys_apicid_present(boot_cpu_physical_apicid)) {
+		printk(KERN_NOTICE
+			"weird, boot CPU (#%d) not listed by the BIOS.\n",
+			boot_cpu_physical_apicid);
+		physid_set(hard_smp_processor_id(), phys_cpu_present_map);
+	}
+
+	/*
+	 * If we couldn't find a local APIC, then get out of here now!
+	 */
+	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
+	    !cpu_has_apic) {
+		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
+			boot_cpu_physical_apicid);
+		printk(KERN_ERR "... forcing use of dummy APIC emulation."
+				"(tell your hw vendor)\n");
+		smpboot_clear_io_apic();
+		return -1;
+	}
+
+	verify_local_APIC();
+
+	/*
+	 * If SMP should be disabled, then really disable it!
+	 */
+	if (!max_cpus) {
+		printk(KERN_INFO "SMP mode deactivated,"
+				 "forcing use of dummy APIC emulation.\n");
+		smpboot_clear_io_apic();
+#ifdef CONFIG_X86_32
+		if (nmi_watchdog == NMI_LOCAL_APIC) {
+			printk(KERN_INFO "activating minimal APIC for"
+					 "NMI watchdog use.\n");
+			connect_bsp_APIC();
+			setup_local_APIC();
+			end_local_APIC_setup();
+		}
+#endif
+		return -1;
+	}
+
+	return 0;
+}
+
+static void __init smp_cpu_index_default(void)
+{
+	int i;
+	struct cpuinfo_x86 *c;
+
+	for_each_cpu_mask(i, cpu_possible_map) {
+		c = &cpu_data(i);
+		/* mark all to hotplug */
+		c->cpu_index = NR_CPUS;
+	}
+}
+
+/*
+ * Prepare for SMP bootup.  The MP table or ACPI has been read
+ * earlier.  Just do some sanity checking here and enable APIC mode.
+ */
+void __init native_smp_prepare_cpus(unsigned int max_cpus)
+{
+	nmi_watchdog_default();
+	smp_cpu_index_default();
+	current_cpu_data = boot_cpu_data;
+	cpu_callin_map = cpumask_of_cpu(0);
+	mb();
+	/*
+	 * Setup boot CPU information
+	 */
+	smp_store_cpu_info(0); /* Final full version of the data */
+	boot_cpu_logical_apicid = logical_smp_processor_id();
+	current_thread_info()->cpu = 0;  /* needed? */
+	set_cpu_sibling_map(0);
+
+	if (smp_sanity_check(max_cpus) < 0) {
+		printk(KERN_INFO "SMP disabled\n");
+		disable_smp();
+		return;
+	}
+
+	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_physical_apicid) {
+		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
+		     GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_physical_apicid);
+		/* Or can we switch back to PIC here? */
+	}
+
+#ifdef CONFIG_X86_32
+	connect_bsp_APIC();
+#endif
+	/*
+	 * Switch from PIC to APIC mode.
+	 */
+	setup_local_APIC();
+
+#ifdef CONFIG_X86_64
+	/*
+	 * Enable IO APIC before setting up error vector
+	 */
+	if (!skip_ioapic_setup && nr_ioapics)
+		enable_IO_APIC();
+#endif
+	end_local_APIC_setup();
+
+	map_cpu_to_logical_apicid();
+
+	setup_portio_remap();
+
+	smpboot_setup_io_apic();
+	/*
+	 * Set up local APIC timer on boot CPU.
+	 */
+
+	printk(KERN_INFO "CPU%d: ", 0);
+	print_cpu_info(&cpu_data(0));
+	setup_boot_clock();
+}
+/*
  * Early setup to make printk work.
  */
 void __init native_smp_prepare_boot_cpu(void)
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 5a0f57f..3a1b9e4 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -74,7 +74,6 @@ EXPORT_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 u8 apicid_2_node[MAX_APICID];
 
-extern void map_cpu_to_logical_apicid(void);
 extern void unmap_cpu_to_logical_apicid(int cpu);
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -94,144 +93,8 @@ void cpu_exit_clear(void)
 }
 #endif
 
-static int boot_cpu_logical_apicid;
 /* Where the IO area was mapped on multiquad, always 0 otherwise */
 void *xquad_portio;
 #ifdef CONFIG_X86_NUMAQ
 EXPORT_SYMBOL(xquad_portio);
 #endif
-
-static void __init disable_smp(void)
-{
-	cpu_possible_map = cpumask_of_cpu(0);
-	cpu_present_map = cpumask_of_cpu(0);
-	smpboot_clear_io_apic_irqs();
-	if (smp_found_config)
-		phys_cpu_present_map =
-				physid_mask_of_physid(boot_cpu_physical_apicid);
-	else
-		phys_cpu_present_map = physid_mask_of_physid(0);
-	map_cpu_to_logical_apicid();
-	cpu_set(0, per_cpu(cpu_sibling_map, 0));
-	cpu_set(0, per_cpu(cpu_core_map, 0));
-}
-
-static int __init smp_sanity_check(unsigned max_cpus)
-{
-	if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
-		printk(KERN_WARNING "weird, boot CPU (#%d) not listed"
-				    "by the BIOS.\n", hard_smp_processor_id());
-		physid_set(hard_smp_processor_id(), phys_cpu_present_map);
-	}
-
-	/*
-	 * If we couldn't find an SMP configuration at boot time,
-	 * get out of here now!
-	 */
-	if (!smp_found_config && !acpi_lapic) {
-		printk(KERN_NOTICE "SMP motherboard not detected.\n");
-		disable_smp();
-		if (APIC_init_uniprocessor())
-			printk(KERN_NOTICE "Local APIC not detected."
-					   " Using dummy APIC emulation.\n");
-		return -1;
-	}
-
-	/*
-	 * Should not be necessary because the MP table should list the boot
-	 * CPU too, but we do it for the sake of robustness anyway.
-	 * Makes no sense to do this check in clustered apic mode, so skip it
-	 */
-	if (!check_phys_apicid_present(boot_cpu_physical_apicid)) {
-		printk("weird, boot CPU (#%d) not listed by the BIOS.\n",
-				boot_cpu_physical_apicid);
-		physid_set(hard_smp_processor_id(), phys_cpu_present_map);
-	}
-
-	/*
-	 * If we couldn't find a local APIC, then get out of here now!
-	 */
-	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) && !cpu_has_apic) {
-		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
-			boot_cpu_physical_apicid);
-		printk(KERN_ERR "... forcing use of dummy APIC emulation. (tell your hw vendor)\n");
-		smpboot_clear_io_apic();
-		return -1;
-	}
-
-	verify_local_APIC();
-
-	/*
-	 * If SMP should be disabled, then really disable it!
-	 */
-	if (!max_cpus) {
-		smp_found_config = 0;
-		printk(KERN_INFO "SMP mode deactivated, forcing use of dummy APIC emulation.\n");
-
-		if (nmi_watchdog == NMI_LOCAL_APIC) {
-			printk(KERN_INFO "activating minimal APIC for NMI watchdog use.\n");
-			connect_bsp_APIC();
-			setup_local_APIC();
-			end_local_APIC_setup();
-		}
-		smpboot_clear_io_apic();
-		return -1;
-	}
-	return 0;
-}
-
-static void __init smp_cpu_index_default(void)
-{
-	int i;
-	struct cpuinfo_x86 *c;
-
-	for_each_cpu_mask(i, cpu_possible_map) {
-		c = &cpu_data(i);
-		/* mark all to hotplug */
-		c->cpu_index = NR_CPUS;
-	}
-}
-
-void __init native_smp_prepare_cpus(unsigned int max_cpus)
-{
- 	nmi_watchdog_default();
- 	smp_cpu_index_default();
- 	current_cpu_data = boot_cpu_data;
- 	cpu_callin_map = cpumask_of_cpu(0);
- 	mb();
-
-	/*
-	 * Setup boot CPU information
-	 */
-	smp_store_cpu_info(0); /* Final full version of the data */
-	boot_cpu_logical_apicid = logical_smp_processor_id();
-	current_thread_info()->cpu = 0;
-
-	set_cpu_sibling_map(0);
-
-	if (smp_sanity_check(max_cpus) < 0) {
-		printk(KERN_INFO "SMP disabled\n");
-		disable_smp();
-		return;
-	}
-
-	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_physical_apicid) {
-		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
-		     GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_physical_apicid);
-		/* Or can we switch back to PIC here? */
-	}
-
-	connect_bsp_APIC();
-	setup_local_APIC();
-	end_local_APIC_setup();
-	map_cpu_to_logical_apicid();
-
-	setup_portio_remap();
-
-	smpboot_setup_io_apic();
-
-	printk(KERN_INFO "CPU%d: ", 0);
-	print_cpu_info(&cpu_data(0));
-	setup_boot_clock();
-}
-
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 7752445..66b5562 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -71,144 +71,3 @@ int smp_threads_ready;
 
 cycles_t cacheflush_time;
 unsigned long cache_decay_ticks;
-
-static int boot_cpu_logical_apicid;
-/*
- * Fall back to non SMP mode after errors.
- *
- * RED-PEN audit/test this more. I bet there is more state messed up here.
- */
-static __init void disable_smp(void)
-{
-	cpu_present_map = cpumask_of_cpu(0);
-	cpu_possible_map = cpumask_of_cpu(0);
-	if (smp_found_config)
-		phys_cpu_present_map =
-				physid_mask_of_physid(boot_cpu_physical_apicid);
-	else
-		phys_cpu_present_map = physid_mask_of_physid(0);
-	cpu_set(0, per_cpu(cpu_sibling_map, 0));
-	cpu_set(0, per_cpu(cpu_core_map, 0));
-}
-
-/*
- * Various sanity checks.
- */
-static int __init smp_sanity_check(unsigned max_cpus)
-{
-	if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
-		printk("weird, boot CPU (#%d) not listed by the BIOS.\n",
-		       hard_smp_processor_id());
-		physid_set(hard_smp_processor_id(), phys_cpu_present_map);
-	}
-
-	/*
-	 * If we couldn't find an SMP configuration at boot time,
-	 * get out of here now!
-	 */
-	if (!smp_found_config && !acpi_lapic) {
-		printk(KERN_NOTICE "SMP motherboard not detected.\n");
-		disable_smp();
-		if (APIC_init_uniprocessor())
-			printk(KERN_NOTICE "Local APIC not detected."
-					   " Using dummy APIC emulation.\n");
-		return -1;
-	}
-
-	/*
-	 * Should not be necessary because the MP table should list the boot
-	 * CPU too, but we do it for the sake of robustness anyway.
-	 */
-	if (!check_phys_apicid_present(boot_cpu_physical_apicid)) {
-		printk(KERN_NOTICE
-			"weird, boot CPU (#%d) not listed by the BIOS.\n",
-			boot_cpu_physical_apicid);
-		physid_set(hard_smp_processor_id(), phys_cpu_present_map);
-	}
-
-	/*
-	 * If we couldn't find a local APIC, then get out of here now!
-	 */
-	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
-	    !cpu_has_apic) {
-		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
-			boot_cpu_physical_apicid);
-		printk(KERN_ERR "... forcing use of dummy APIC emulation. (tell your hw vendor)\n");
-		smpboot_clear_io_apic();
-		return -1;
-	}
-
-	verify_local_APIC();
-
-	/*
-	 * If SMP should be disabled, then really disable it!
-	 */
-	if (!max_cpus) {
-		printk(KERN_INFO "SMP mode deactivated, forcing use of dummy APIC emulation.\n");
-		smpboot_clear_io_apic();
-		return -1;
-	}
-
-	return 0;
-}
-
-static void __init smp_cpu_index_default(void)
-{
-	int i;
-	struct cpuinfo_x86 *c;
-
-	for_each_cpu_mask(i, cpu_possible_map) {
-		c = &cpu_data(i);
-		/* mark all to hotplug */
-		c->cpu_index = NR_CPUS;
-	}
-}
-
-/*
- * Prepare for SMP bootup.  The MP table or ACPI has been read
- * earlier.  Just do some sanity checking here and enable APIC mode.
- */
-void __init native_smp_prepare_cpus(unsigned int max_cpus)
-{
-	nmi_watchdog_default();
-	smp_cpu_index_default();
-	cpu_callin_map = cpumask_of_cpu(0);
-	mb();
-
-	current_cpu_data = boot_cpu_data;
-	boot_cpu_logical_apicid = logical_smp_processor_id();
-	current_thread_info()->cpu = 0;  /* needed? */
-	set_cpu_sibling_map(0);
-
-	if (smp_sanity_check(max_cpus) < 0) {
-		printk(KERN_INFO "SMP disabled\n");
-		disable_smp();
-		return;
-	}
-
-	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_physical_apicid) {
-		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
-		     GET_APIC_ID(apic_read(APIC_ID)), boot_cpu_physical_apicid);
-		/* Or can we switch back to PIC here? */
-	}
-
-	/*
-	 * Switch from PIC to APIC mode.
-	 */
-	setup_local_APIC();
-
-	/*
-	 * Enable IO APIC before setting up error vector
-	 */
-	if (!skip_ioapic_setup && nr_ioapics)
-		enable_IO_APIC();
-	end_local_APIC_setup();
-
-	/*
-	 * Set up local APIC timer on boot CPU.
-	 */
-
-	setup_boot_clock();
-	printk(KERN_INFO "CPU%d: ", 0);
-	print_cpu_info(&cpu_data(0));
-}
-- 
1.5.0.6

