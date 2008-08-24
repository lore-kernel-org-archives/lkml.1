Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbYHXJGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbYHXJGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYHXJDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbYHXJDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Jq1KgWLtv1/2E/NiImH2t2K74poIXVLDU0iO7BfFpup2tnMGK+SHivV+hrtT6MUbOl
         XlI5IUOyxnJkNQlV8DBhwhEGlpFwR5k3AWeBtcZFz5pjacG6LM+zXlvsLPWOYCIW5AW/
         9UlRcEbuegVMY609fu+a4jHmrwTHhxg0D8nbY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 11/18] x86: make apic_32/64.c more like
Date: Sun, 24 Aug 2008 02:01:49 -0700
Message-Id: <1219568516-681-12-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

except x2apic, detec_init_APIC, and calibrating_APIC_clock

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/apic_32.c |  125 ++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kernel/apic_64.c |   10 +++-
 2 files changed, 122 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 6fb2b45..294256f 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -66,6 +66,9 @@ static int __init parse_lapic(char *arg)
 	return 0;
 }
 early_param("lapic", parse_lapic);
+/* Local APIC was disabled by the BIOS and enabled by the kernel */
+static int enabled_via_apicbase;
+
 #endif
 
 #ifdef CONFIG_X86_64
@@ -131,9 +134,6 @@ static struct clock_event_device lapic_clockevent = {
 };
 static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
 
-/* Local APIC was disabled by the BIOS and enabled by the kernel */
-static int enabled_via_apicbase;
-
 static unsigned long apic_phys;
 
 /*
@@ -240,6 +240,7 @@ void __cpuinit enable_NMI_through_LVT0(void)
 	apic_write(APIC_LVT0, v);
 }
 
+#ifdef CONFIG_X86_32
 /**
  * get_physical_broadcast - Get number of physical broadcast IDs
  */
@@ -247,6 +248,7 @@ int get_physical_broadcast(void)
 {
 	return modern_apic() ? 0xff : 0xf;
 }
+#endif
 
 /**
  * lapic_get_maxlvt - get the maximum number of local vector table entries
@@ -1291,6 +1293,32 @@ no_apic:
 	return -1;
 }
 
+#ifdef CONFIG_X86_64
+void __init early_init_lapic_mapping(void)
+{
+	unsigned long phys_addr;
+
+	/*
+	 * If no local APIC can be found then go out
+	 * : it means there is no mpatable and MADT
+	 */
+	if (!smp_found_config)
+		return;
+
+	phys_addr = mp_lapic_addr;
+
+	set_fixmap_nocache(FIX_APIC_BASE, phys_addr);
+	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+		    APIC_BASE, phys_addr);
+
+	/*
+	 * Fetch the APIC ID of the BSP in case we have a
+	 * default configuration (or the MP table is broken).
+	 */
+	boot_cpu_physical_apicid = read_apic_id();
+}
+#endif
+
 /**
  * init_apic_mappings - initialize APIC mappings
  */
@@ -1308,8 +1336,8 @@ void __init init_apic_mappings(void)
 		apic_phys = mp_lapic_addr;
 
 	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-	printk(KERN_DEBUG "mapped APIC to %08lx (%08lx)\n", APIC_BASE,
-	       apic_phys);
+	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
+				APIC_BASE, apic_phys);
 
 	/*
 	 * Fetch the APIC ID of the BSP in case we have a
@@ -1317,14 +1345,12 @@ void __init init_apic_mappings(void)
 	 */
 	if (boot_cpu_physical_apicid == -1U)
 		boot_cpu_physical_apicid = read_apic_id();
-
 }
 
 /*
  * This initializes the IO-APIC and APIC hardware if this is
  * a UP kernel.
  */
-
 int apic_version[MAX_APICS];
 
 int __init APIC_init_uniprocessor(void)
@@ -1682,11 +1708,6 @@ static int lapic_resume(struct sys_device *dev)
 
 	local_irq_save(flags);
 
-#ifdef CONFIG_X86_64
-	if (x2apic)
-		enable_x2apic();
-	else
-#endif
 	{
 		/*
 		 * Make sure the APICBASE points to the right address
@@ -1770,7 +1791,87 @@ static void apic_pm_activate(void) { }
 
 #endif	/* CONFIG_PM */
 
+#ifdef CONFIG_X86_64
+/*
+ * apic_is_clustered_box() -- Check if we can expect good TSC
+ *
+ * Thus far, the major user of this is IBM's Summit2 series:
+ *
+ * Clustered boxes may have unsynced TSC problems if they are
+ * multi-chassis. Use available data to take a good guess.
+ * If in doubt, go HPET.
+ */
+__cpuinit int apic_is_clustered_box(void)
+{
+	int i, clusters, zeros;
+	unsigned id;
+	u16 *bios_cpu_apicid;
+	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
+
+	/*
+	 * there is not this kind of box with AMD CPU yet.
+	 * Some AMD box with quadcore cpu and 8 sockets apicid
+	 * will be [4, 0x23] or [8, 0x27] could be thought to
+	 * vsmp box still need checking...
+	 */
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) && !is_vsmp_box())
+		return 0;
+
+	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
+	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
+
+	for (i = 0; i < NR_CPUS; i++) {
+		/* are we being called early in kernel startup? */
+		if (bios_cpu_apicid) {
+			id = bios_cpu_apicid[i];
+		}
+		else if (i < nr_cpu_ids) {
+			if (cpu_present(i))
+				id = per_cpu(x86_bios_cpu_apicid, i);
+			else
+				continue;
+		}
+		else
+			break;
 
+		if (id != BAD_APICID)
+			__set_bit(APIC_CLUSTERID(id), clustermap);
+	}
+
+	/* Problem:  Partially populated chassis may not have CPUs in some of
+	 * the APIC clusters they have been allocated.  Only present CPUs have
+	 * x86_bios_cpu_apicid entries, thus causing zeroes in the bitmap.
+	 * Since clusters are allocated sequentially, count zeros only if
+	 * they are bounded by ones.
+	 */
+	clusters = 0;
+	zeros = 0;
+	for (i = 0; i < NUM_APIC_CLUSTERS; i++) {
+		if (test_bit(i, clustermap)) {
+			clusters += 1 + zeros;
+			zeros = 0;
+		} else
+			++zeros;
+	}
+
+	/* ScaleMP vSMPowered boxes have one cluster per board and TSCs are
+	 * not guaranteed to be synced between boards
+	 */
+	if (is_vsmp_box() && clusters > 1)
+		return 1;
+
+	/*
+	 * If clusters > 2, then should be multi-chassis.
+	 * May have to revisit this when multi-core + hyperthreaded CPUs come
+	 * out, but AFAIK this will work even for them.
+	 */
+	return (clusters > 2);
+}
+#endif
+
+/*
+ * APIC command line parameters
+ */
 static int __init setup_disableapic(char *arg)
 {
 	disable_apic = 1;
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index eeb6983..dca6c24 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -69,6 +69,9 @@ static int __init parse_lapic(char *arg)
 	return 0;
 }
 early_param("lapic", parse_lapic);
+/* Local APIC was disabled by the BIOS and enabled by the kernel */
+static int enabled_via_apicbase;
+
 #endif
 
 #ifdef CONFIG_X86_64
@@ -1279,6 +1282,7 @@ static int __init detect_init_APIC(void)
 	return 0;
 }
 
+#ifdef CONFIG_X86_64
 void __init early_init_lapic_mapping(void)
 {
 	unsigned long phys_addr;
@@ -1302,6 +1306,7 @@ void __init early_init_lapic_mapping(void)
 	 */
 	boot_cpu_physical_apicid = read_apic_id();
 }
+#endif
 
 /**
  * init_apic_mappings - initialize APIC mappings
@@ -1334,7 +1339,8 @@ void __init init_apic_mappings(void)
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
 	 */
-	boot_cpu_physical_apicid = read_apic_id();
+	if (boot_cpu_physical_apicid == -1U)
+		boot_cpu_physical_apicid = read_apic_id();
 }
 
 /*
@@ -1782,6 +1788,7 @@ static void apic_pm_activate(void) { }
 
 #endif	/* CONFIG_PM */
 
+#ifdef CONFIG_X86_64
 /*
  * apic_is_clustered_box() -- Check if we can expect good TSC
  *
@@ -1857,6 +1864,7 @@ __cpuinit int apic_is_clustered_box(void)
 	 */
 	return (clusters > 2);
 }
+#endif
 
 /*
  * APIC command line parameters
-- 
1.5.4.5

