Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZISIAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZISIAQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZISIAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:00:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:42913 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374AbZISIAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:00:04 -0400
Date: Sat, 19 Sep 2009 07:59:33 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1253327399.3948.747.camel@sbs-t61.sc.intel.com>
References: <1253327399.3948.747.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic: Use logical flat on intel with <= 8 logical cpus
Message-ID: <tip-2fbd07a5f5d1295fa9b0c0564ec27da7c276a75a@git.kernel.org>
Git-Commit-ID: 2fbd07a5f5d1295fa9b0c0564ec27da7c276a75a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 07:59:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fbd07a5f5d1295fa9b0c0564ec27da7c276a75a
Gitweb:     http://git.kernel.org/tip/2fbd07a5f5d1295fa9b0c0564ec27da7c276a75a
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 18 Sep 2009 19:29:59 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 09:20:05 +0200

x86, apic: Use logical flat on intel with <= 8 logical cpus

On Intel platforms, we can use logical flat mode if there are <= 8
logical cpu's (irrespective of physical apic id values). This will
enable simplified and efficient IPI and device interrupt routing on
such platforms.

Fix the relevant comments while we are at it.

We can clean up default_setup_apic_routing() by using apic->probe()
but that is a different item.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "yinghai@kernel.org" <yinghai@kernel.org>
LKML-Reference: <1253327399.3948.747.camel@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c     |   26 ++++++++------------------
 arch/x86/kernel/apic/probe_64.c |   15 +++++++++++----
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 79e5b92..072aea6 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -61,7 +61,7 @@ unsigned int boot_cpu_physical_apicid = -1U;
 /*
  * The highest APIC ID seen during enumeration.
  *
- * This determines the messaging protocol we can use: if all APIC IDs
+ * On AMD, this determines the messaging protocol we can use: if all APIC IDs
  * are in the 0 ... 7 range, then we can use logical addressing which
  * has some performance advantages (better broadcasting).
  *
@@ -1915,24 +1915,14 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		max_physical_apicid = apicid;
 
 #ifdef CONFIG_X86_32
-	/*
-	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
-	 * but we need to work other dependencies like SMP_SUSPEND etc
-	 * before this can be done without some confusion.
-	 * if (CPU_HOTPLUG_ENABLED || num_processors > 8)
-	 *       - Ashok Raj <ashok.raj@intel.com>
-	 */
-	if (max_physical_apicid >= 8) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (!APIC_XAPIC(version)) {
-				def_to_bigsmp = 0;
-				break;
-			}
-			/* If P4 and above fall through */
-		case X86_VENDOR_AMD:
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_INTEL:
+		if (num_processors > 8)
+			def_to_bigsmp = 1;
+		break;
+	case X86_VENDOR_AMD:
+		if (max_physical_apicid >= 8)
 			def_to_bigsmp = 1;
-		}
 	}
 #endif
 
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 65edc18..c4cbd30 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -64,16 +64,23 @@ void __init default_setup_apic_routing(void)
 			apic = &apic_x2apic_phys;
 		else
 			apic = &apic_x2apic_cluster;
-		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 #endif
 
 	if (apic == &apic_flat) {
-		if (max_physical_apicid >= 8)
-			apic = &apic_physflat;
-		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			if (num_processors > 8)
+				apic = &apic_physflat;
+			break;
+		case X86_VENDOR_AMD:
+			if (max_physical_apicid >= 8)
+				apic = &apic_physflat;
+		}
 	}
 
+	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
+
 	if (is_vsmp_box()) {
 		/* need to update phys_pkg_id */
 		apic->phys_pkg_id = apicid_phys_pkg_id;
