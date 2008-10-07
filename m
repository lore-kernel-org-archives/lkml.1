Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYJGAtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYJGAtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbYJGAno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:60487 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbYJGAnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:43 -0400
Date: Mon, 6 Oct 2008 17:38:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 24/71] APIC routing fix
Message-ID: <20081007003829.GY3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="apic-routing-fix.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Yinghai Lu <yhlu.kernel@gmail.com>

commit e0da33646826b66ef933d47ea2fb7a693fd849bf upstream

x86: introduce max_physical_apicid for bigsmp switching

a multi-socket test-system with 3 or 4 ioapics, when 4 dualcore cpus or
2 quadcore cpus installed, needs to switch to bigsmp or physflat.

CPU apic id is [4,11] instead of [0,7], and we need to check max apic
id instead of cpu numbers.

also add check for 32 bit when acpi is not compiled in or acpi=off.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic_32.c      |    5 ++++-
 arch/x86/kernel/apic_64.c      |    3 +++
 arch/x86/kernel/genapic_64.c   |    2 +-
 arch/x86/kernel/mpparse.c      |    5 +++++
 arch/x86/kernel/setup.c        |    1 +
 arch/x86/kernel/setup_32.c     |   11 ++++++-----
 arch/x86/mach-generic/bigsmp.c |    2 +-
 include/asm-x86/mpspec.h       |    1 +
 8 files changed, 22 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1536,6 +1536,9 @@ void __cpuinit generic_processor_info(in
 		 */
 		cpu = 0;
 
+	if (apicid > max_physical_apicid)
+		max_physical_apicid = apicid;
+
 	/*
 	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
 	 * but we need to work other dependencies like SMP_SUSPEND etc
@@ -1543,7 +1546,7 @@ void __cpuinit generic_processor_info(in
 	 * if (CPU_HOTPLUG_ENABLED || num_processors > 8)
 	 *       - Ashok Raj <ashok.raj@intel.com>
 	 */
-	if (num_processors > 8) {
+	if (max_physical_apicid >= 8) {
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_INTEL:
 			if (!APIC_XAPIC(version)) {
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1090,6 +1090,9 @@ void __cpuinit generic_processor_info(in
 		 */
 		cpu = 0;
 	}
+	if (apicid > max_physical_apicid)
+		max_physical_apicid = apicid;
+
 	/* are we being called early in kernel startup? */
 	if (x86_cpu_to_apicid_early_ptr) {
 		u16 *cpu_to_apicid = x86_cpu_to_apicid_early_ptr;
--- a/arch/x86/kernel/genapic_64.c
+++ b/arch/x86/kernel/genapic_64.c
@@ -51,7 +51,7 @@ void __init setup_apic_routing(void)
 	else
 #endif
 
-	if (num_possible_cpus() <= 8)
+	if (max_physical_apicid < 8)
 		genapic = &apic_flat;
 	else
 		genapic = &apic_physflat;
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -402,6 +402,11 @@ static int __init smp_read_mpc(struct mp
 		++mpc_record;
 #endif
 	}
+
+#ifdef CONFIG_X86_GENERICARCH
+       generic_bigsmp_probe();
+#endif
+
 	setup_apic_routing();
 	if (!num_processors)
 		printk(KERN_ERR "MPTABLE: no processors registered!\n");
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -914,6 +914,12 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_ACPI
 	acpi_boot_init();
+#endif
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	if (smp_found_config)
+		get_smp_config();
+#endif
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_PC)
 	if (def_to_bigsmp)
@@ -921,11 +927,6 @@ void __init setup_arch(char **cmdline_p)
 			"CONFIG_X86_PC cannot handle it.\nUse "
 			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
 #endif
-#endif
-#ifdef CONFIG_X86_LOCAL_APIC
-	if (smp_found_config)
-		get_smp_config();
-#endif
 
 	e820_register_memory();
 	e820_mark_nosave_regions();
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -17,6 +17,7 @@ unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
+unsigned int max_physical_apicid;
 EXPORT_SYMBOL(boot_cpu_physical_apicid);
 
 DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -48,7 +48,7 @@ static const struct dmi_system_id bigsmp
 static int probe_bigsmp(void)
 {
 	if (def_to_bigsmp)
-	dmi_bigsmp = 1;
+		dmi_bigsmp = 1;
 	else
 		dmi_check_system(bigsmp_dmi_table);
 	return dmi_bigsmp;
--- a/include/asm-x86/mpspec.h
+++ b/include/asm-x86/mpspec.h
@@ -35,6 +35,7 @@ extern DECLARE_BITMAP(mp_bus_not_pci, MA
 extern int mp_bus_id_to_pci_bus[MAX_MP_BUSSES];
 
 extern unsigned int boot_cpu_physical_apicid;
+extern unsigned int max_physical_apicid;
 extern int smp_found_config;
 extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;

-- 
