Return-Path: <linux-kernel-owner+w=401wt.eu-S1163296AbXD1SPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163296AbXD1SPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163298AbXD1SOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:14:49 -0400
Received: from ns2.suse.de ([195.135.220.15]:38611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163297AbXD1Rwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:41 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <ak@suse.de>, "Li, Shaohua" <shaohua.li@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [4/35] x86_64: optimize & fix APIC mode setup
Message-Id: <20070428175228.1759F151F2@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ingo Molnar <mingo@elte.hu>

Fix a couple of inconsistencies/problems I found while reviewing the x86_64
genapic code (when I was chasing mysterious eth0 timeouts that would only
trigger if CPU_HOTPLUG is enabled):

 - AMD systems defaulted to the slower flat-physical mode instead
   of the flat-logical mode. The only restriction on AMD systems
   is that they should not use clustered APIC mode.

 - removed the CPU hotplug hacks, switching the default for small
   systems back from phys-flat to logical-flat. The switching to logical
   flat mode on small systems fixed sporadic ethernet driver timeouts i
   was getting on a dual-core Athlon64 system:

    NETDEV WATCHDOG: eth0: transmit timed out
    eth0: Transmit timeout, status 0c 0005 c07f media 80.
    eth0: Tx queue start entry 32  dirty entry 28.
    eth0:  Tx descriptor 0 is 0008a04a. (queue head)
    eth0:  Tx descriptor 1 is 0008a04a.
    eth0:  Tx descriptor 2 is 0008a04a.
    eth0:  Tx descriptor 3 is 0008a04a.
    eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1

 - The use of '<= 8' was a bug by itself (the valid APIC ids
   for logical flat mode go from 0 to 7, not 0 to 8). The new logic
   is to use logical flat mode on both AMD and Intel systems, and
   to only switch to physical mode when logical mode cannot be used.
   If CPU hotplug is racy wrt. APIC shutdown then CPU hotplug needs
   fixing, not the whole IRQ system be made inconsistent and slowed
   down.

 - minor cleanups: simplified some code constructs

build & booted on a couple of AMD and Intel SMP systems.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Li, Shaohua" <shaohua.li@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/genapic.c |   39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

Index: linux/arch/x86_64/kernel/genapic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/genapic.c
+++ linux/arch/x86_64/kernel/genapic.c
@@ -32,21 +32,20 @@ extern struct genapic apic_cluster;
 extern struct genapic apic_flat;
 extern struct genapic apic_physflat;
 
-struct genapic *genapic = &apic_flat;
-
+struct genapic __read_mostly *genapic = &apic_flat;
 
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
 void __init clustered_apic_check(void)
 {
-	long i;
+	int i;
 	u8 clusters, max_cluster;
 	u8 id;
 	u8 cluster_cnt[NUM_APIC_CLUSTERS];
 	int max_apic = 0;
 
-#if defined(CONFIG_ACPI)
+#ifdef CONFIG_ACPI
 	/*
 	 * Some x86_64 machines use physical APIC mode regardless of how many
 	 * procs/clusters are present (x86_64 ES7000 is an example).
@@ -68,20 +67,17 @@ void __init clustered_apic_check(void)
 		cluster_cnt[APIC_CLUSTERID(id)]++;
 	}
 
-	/* Don't use clustered mode on AMD platforms. */
+	/*
+	 * Don't use clustered mode on AMD platforms, default
+	 * to flat logical mode.
+	 */
  	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
-		genapic = &apic_physflat;
-#ifndef CONFIG_HOTPLUG_CPU
-		/* In the CPU hotplug case we cannot use broadcast mode
-		   because that opens a race when a CPU is removed.
-		   Stay at physflat mode in this case.
-		   It is bad to do this unconditionally though. Once
-		   we have ACPI platform support for CPU hotplug
-		   we should detect hotplug capablity from ACPI tables and
-		   only do this when really needed. -AK */
-		if (max_apic <= 8)
-			genapic = &apic_flat;
-#endif
+		/*
+		 * Switch to physical flat mode if more than 8 APICs
+		 * (In the case of 8 CPUs APIC ID goes from 0 to 7):
+		 */
+		if (max_apic >= 8)
+			genapic = &apic_physflat;
  		goto print;
  	}
 
@@ -103,14 +99,9 @@ void __init clustered_apic_check(void)
 	 * (We don't use lowest priority delivery + HW APIC IRQ steering, so
 	 * can ignore the clustered logical case and go straight to physical.)
 	 */
-	if (clusters <= 1 && max_cluster <= 8 && cluster_cnt[0] == max_cluster) {
-#ifdef CONFIG_HOTPLUG_CPU
-		/* Don't use APIC shortcuts in CPU hotplug to avoid races */
-		genapic = &apic_physflat;
-#else
+	if (clusters <= 1 && max_cluster <= 8 && cluster_cnt[0] == max_cluster)
 		genapic = &apic_flat;
-#endif
-	} else
+	else
 		genapic = &apic_cluster;
 
 print:
