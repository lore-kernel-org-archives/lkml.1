Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0BJG2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 01:28:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:44428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab0BJG2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 01:28:22 -0500
Date: Wed, 10 Feb 2010 06:27:44 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, stable@kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, shaohui.zheng@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, stable@kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, shaohui.zheng@intel.com
In-Reply-To: <1265767304.2833.19.camel@sbs-t61.sc.intel.com>
References: <1265767304.2833.19.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic: Don't use logical-flat mode when CPU hotplug may exceed 8 CPUs
Message-ID: <tip-681ee44d40d7c93b42118320e4620d07d8704fd6@git.kernel.org>
Git-Commit-ID: 681ee44d40d7c93b42118320e4620d07d8704fd6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 06:27:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  681ee44d40d7c93b42118320e4620d07d8704fd6
Gitweb:     http://git.kernel.org/tip/681ee44d40d7c93b42118320e4620d07d8704fd6
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 9 Feb 2010 18:01:44 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 9 Feb 2010 20:51:11 -0800

x86, apic: Don't use logical-flat mode when CPU hotplug may exceed 8 CPUs

We need to fall back from logical-flat APIC mode to physical-flat mode
when we have more than 8 CPUs.  However, in the presence of CPU
hotplug(with bios listing not enabled but possible cpus as disabled cpus in
MADT), we have to consider the number of possible CPUs rather than
the number of current CPUs; otherwise we may cross the 8-CPU boundary
when CPUs are added later.

32bit apic code can use more cleanups (like the removal of vendor checks in
32bit default_setup_apic_routing()) and more unifications with 64bit code.
Yinghai has some patches in works already. This patch addresses the boot issue
that is reported in the virtualization guest context.

[ hpa: incorporated function annotation feedback from Yinghai Lu ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1265767304.2833.19.camel@sbs-t61.sc.intel.com>
Acked-by: Shaohui Zheng <shaohui.zheng@intel.com>
Reviewed-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/acpi/boot.c     |    5 -----
 arch/x86/kernel/apic/apic.c     |   17 -----------------
 arch/x86/kernel/apic/probe_32.c |   29 +++++++++++++++++++++++++++--
 arch/x86/kernel/apic/probe_64.c |    2 +-
 arch/x86/kernel/mpparse.c       |    7 -------
 arch/x86/kernel/smpboot.c       |    2 --
 6 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 036d28a..0acbcdf 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1185,9 +1185,6 @@ static void __init acpi_process_madt(void)
 		if (!error) {
 			acpi_lapic = 1;
 
-#ifdef CONFIG_X86_BIGSMP
-			generic_bigsmp_probe();
-#endif
 			/*
 			 * Parse MADT IO-APIC entries
 			 */
@@ -1197,8 +1194,6 @@ static void __init acpi_process_madt(void)
 				acpi_ioapic = 1;
 
 				smp_found_config = 1;
-				if (apic->setup_apic_routing)
-					apic->setup_apic_routing();
 			}
 		}
 		if (error == -EINVAL) {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3987e44..dfca210 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1641,9 +1641,7 @@ int __init APIC_init_uniprocessor(void)
 #endif
 
 	enable_IR_x2apic();
-#ifdef CONFIG_X86_64
 	default_setup_apic_routing();
-#endif
 
 	verify_local_APIC();
 	connect_bsp_APIC();
@@ -1891,21 +1889,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	if (apicid > max_physical_apicid)
 		max_physical_apicid = apicid;
 
-#ifdef CONFIG_X86_32
-	if (num_processors > 8) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (!APIC_XAPIC(version)) {
-				def_to_bigsmp = 0;
-				break;
-			}
-			/* If P4 and above fall through */
-		case X86_VENDOR_AMD:
-			def_to_bigsmp = 1;
-		}
-	}
-#endif
-
 #if defined(CONFIG_SMP) || defined(CONFIG_X86_64)
 	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 1a6559f..99d2fe0 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -52,7 +52,32 @@ static int __init print_ipi_mode(void)
 }
 late_initcall(print_ipi_mode);
 
-void default_setup_apic_routing(void)
+void __init default_setup_apic_routing(void)
+{
+	int version = apic_version[boot_cpu_physical_apicid];
+
+	if (num_possible_cpus() > 8) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			if (!APIC_XAPIC(version)) {
+				def_to_bigsmp = 0;
+				break;
+			}
+			/* If P4 and above fall through */
+		case X86_VENDOR_AMD:
+			def_to_bigsmp = 1;
+		}
+	}
+
+#ifdef CONFIG_X86_BIGSMP
+	generic_bigsmp_probe();
+#endif
+
+	if (apic->setup_apic_routing)
+		apic->setup_apic_routing();
+}
+
+static void setup_apic_flat_routing(void)
 {
 #ifdef CONFIG_X86_IO_APIC
 	printk(KERN_INFO
@@ -103,7 +128,7 @@ struct apic apic_default = {
 	.init_apic_ldr			= default_init_apic_ldr,
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
-	.setup_apic_routing		= default_setup_apic_routing,
+	.setup_apic_routing		= setup_apic_flat_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 450fe20..83e9be4 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -67,7 +67,7 @@ void __init default_setup_apic_routing(void)
 	}
 #endif
 
-	if (apic == &apic_flat && num_processors > 8)
+	if (apic == &apic_flat && num_possible_cpus() > 8)
 			apic = &apic_physflat;
 
 	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 40b54ce..a2c1edd 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -359,13 +359,6 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 		x86_init.mpparse.mpc_record(1);
 	}
 
-#ifdef CONFIG_X86_BIGSMP
-	generic_bigsmp_probe();
-#endif
-
-	if (apic->setup_apic_routing)
-		apic->setup_apic_routing();
-
 	if (!num_processors)
 		printk(KERN_ERR "MPTABLE: no processors registered!\n");
 	return num_processors;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 678d0b8..b4e870c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1083,9 +1083,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	set_cpu_sibling_map(0);
 
 	enable_IR_x2apic();
-#ifdef CONFIG_X86_64
 	default_setup_apic_routing();
-#endif
 
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
