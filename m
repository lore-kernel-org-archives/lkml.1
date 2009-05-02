Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZEBW2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZEBW2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 18:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZEBW2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 18:28:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:40228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZEBW2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 18:28:37 -0400
Message-ID: <49FCC8E5.8050202@kernel.org>
Date: Sat, 02 May 2009 15:27:49 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: change apic_version array to bsp apic ver only
References: <20090430084145.GD21699@elte.hu> <49FBD0A2.4030309@kernel.org> <20090502070254.GA4791@lenovo> <49FC85A9.2070702@kernel.org> <20090502184108.GC4791@lenovo> <49FC9BFC.4040904@kernel.org> <20090502192441.GE4791@lenovo> <49FC9F28.2070802@kernel.org> <20090502193203.GG4791@lenovo>
In-Reply-To: <20090502193203.GG4791@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


only need to record boot cpu apic version

[ Impact: save some bytes ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/mpspec.h    |    2 +-
 arch/x86/kernel/acpi/boot.c      |    7 +++----
 arch/x86/kernel/apic/apic.c      |   16 ++++++++--------
 arch/x86/kernel/apic/es7000_32.c |    4 +---
 arch/x86/kernel/apic/io_apic.c   |    2 +-
 arch/x86/kernel/smpboot.c        |   10 +++++-----
 arch/x86/kernel/visws_quirks.c   |    3 ++-
 7 files changed, 21 insertions(+), 23 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -5,7 +5,7 @@
 
 #include <asm/mpspec_def.h>
 
-extern int apic_version[MAX_APICS];
+extern int apic_version;
 extern int pic_mode;
 
 #ifdef CONFIG_X86_32
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -225,7 +225,7 @@ static void __cpuinit acpi_register_lapi
 	}
 
 	if (boot_cpu_physical_apicid != -1U)
-		ver = apic_version[boot_cpu_physical_apicid];
+		ver = apic_version;
 
 	generic_processor_info(id, ver);
 }
@@ -808,8 +808,7 @@ static void __init acpi_register_lapic_a
 	set_fixmap_nocache(FIX_APIC_BASE, address);
 	if (boot_cpu_physical_apicid == -1U) {
 		boot_cpu_physical_apicid  = read_apic_id();
-		apic_version[boot_cpu_physical_apicid] =
-			 GET_APIC_VERSION(apic_read(APIC_LVR));
+		apic_version = GET_APIC_VERSION(apic_read(APIC_LVR));
 	}
 }
 
@@ -937,7 +936,7 @@ static u8 __init uniq_ioapic_id(u8 id)
 {
 #ifdef CONFIG_X86_32
 	if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) &&
-	    !APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+	    !APIC_XAPIC(apic_version))
 		return io_apic_get_unique_id(nr_ioapics, id);
 	else
 		return id;
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1615,8 +1615,7 @@ void __init init_apic_mappings(void)
 	new_apicid  = read_apic_id();
 	if (boot_cpu_physical_apicid != new_apicid) {
 		boot_cpu_physical_apicid  = new_apicid;
-		apic_version[new_apicid] =
-			 GET_APIC_VERSION(apic_read(APIC_LVR));
+		apic_version = GET_APIC_VERSION(apic_read(APIC_LVR));
 	}
 }
 
@@ -1624,7 +1623,7 @@ void __init init_apic_mappings(void)
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
  */
-int apic_version[MAX_APICS];
+int apic_version;
 
 int __init APIC_init_uniprocessor(void)
 {
@@ -1645,8 +1644,7 @@ int __init APIC_init_uniprocessor(void)
 	/*
 	 * Complain if the BIOS pretends there is one.
 	 */
-	if (!cpu_has_apic &&
-	    APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
+	if (!cpu_has_apic && APIC_INTEGRATED(apic_version)) {
 		pr_err("BIOS bug, local APIC 0x%x not detected!...\n",
 			boot_cpu_physical_apicid);
 		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
@@ -1871,7 +1869,9 @@ void __cpuinit generic_processor_info(in
 				version);
 		version = 0x10;
 	}
-	apic_version[apicid] = version;
+
+	if (apicid == boot_cpu_physical_apicid)
+		apic_version = version;
 
 	if (num_processors >= nr_cpu_ids) {
 		int max = nr_cpu_ids;
@@ -1888,10 +1888,10 @@ void __cpuinit generic_processor_info(in
 	num_processors++;
 	cpu = cpumask_next_zero(-1, cpu_present_mask);
 
-	if (version != apic_version[boot_cpu_physical_apicid])
+	if (version != apic_version)
 		WARN_ONCE(1,
 			"ACPI: apic version mismatch, bootcpu: %x cpu %d: %x\n",
-			apic_version[boot_cpu_physical_apicid], cpu, version);
+			apic_version, cpu, version);
 
 	physid_set(apicid, phys_cpu_present_map);
 	if (apicid == boot_cpu_physical_apicid) {
Index: linux-2.6/arch/x86/kernel/apic/es7000_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/es7000_32.c
+++ linux-2.6/arch/x86/kernel/apic/es7000_32.c
@@ -512,11 +512,9 @@ static void es7000_init_apic_ldr(void)
 
 static void es7000_setup_apic_routing(void)
 {
-	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
-
 	printk(KERN_INFO
 	  "Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
-		(apic_version[apic] == 0x14) ?
+		(apic_version == 0x14) ?
 			"Physical Cluster" : "Logical Cluster",
 		nr_ioapics, cpumask_bits(es7000_target_cpus())[0]);
 }
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -2010,7 +2010,7 @@ static void __init setup_ioapic_ids_from
 	 * no meaning without the serial APIC bus.
 	 */
 	if (!(boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
-		|| APIC_XAPIC(apic_version[boot_cpu_physical_apicid]))
+		|| APIC_XAPIC(apic_version))
 		return;
 	/*
 	 * This is broken; anything with a real cpu count has to
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -522,7 +522,7 @@ wakeup_secondary_cpu_via_nmi(int logical
 	 * Give the other CPU some time to accept the IPI.
 	 */
 	udelay(200);
-	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
+	if (APIC_INTEGRATED(apic_version)) {
 		maxlvt = lapic_get_maxlvt();
 		if (maxlvt > 3)			/* Due to the Pentium erratum 3AP.  */
 			apic_write(APIC_ESR, 0);
@@ -549,7 +549,7 @@ wakeup_secondary_cpu_via_init(int phys_a
 	/*
 	 * Be paranoid about clearing APIC errors.
 	 */
-	if (APIC_INTEGRATED(apic_version[phys_apicid])) {
+	if (APIC_INTEGRATED(apic_version)) {
 		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP.  */
 			apic_write(APIC_ESR, 0);
 		apic_read(APIC_ESR);
@@ -589,7 +589,7 @@ wakeup_secondary_cpu_via_init(int phys_a
 	 * Determine this based on the APIC version.
 	 * If we don't have an integrated APIC, don't send the STARTUP IPIs.
 	 */
-	if (APIC_INTEGRATED(apic_version[phys_apicid]))
+	if (APIC_INTEGRATED(apic_version))
 		num_starts = 2;
 	else
 		num_starts = 0;
@@ -753,7 +753,7 @@ do_rest:
 		/*
 		 * Be paranoid about clearing APIC errors.
 		*/
-		if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid])) {
+		if (APIC_INTEGRATED(apic_version)) {
 			apic_write(APIC_ESR, 0);
 			apic_read(APIC_ESR);
 		}
@@ -990,7 +990,7 @@ static int __init smp_sanity_check(unsig
 	/*
 	 * If we couldn't find a local APIC, then get out of here now!
 	 */
-	if (APIC_INTEGRATED(apic_version[boot_cpu_physical_apicid]) &&
+	if (APIC_INTEGRATED(apic_version) &&
 	    !cpu_has_apic) {
 		printk(KERN_ERR "BIOS bug, local APIC #%d not detected!...\n",
 			boot_cpu_physical_apicid);
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -205,7 +205,8 @@ static void __init MP_processor_info(str
 			m->apicid);
 		ver = 0x10;
 	}
-	apic_version[m->apicid] = ver;
+	if (m->cpuflag & CPU_BOOTPROCESSOR)
+		apic_version = ver;
 }
 
 static int __init visws_find_smp_config(unsigned int reserve)
