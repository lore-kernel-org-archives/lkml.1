Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbZISCak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbZISCak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 22:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbZISCaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 22:30:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:14340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757206AbZISCai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 22:30:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,412,1249282800"; 
   d="scan'208";a="449834665"
Subject: Re: [patch] x86, apic: use logical flat on intel with <= 8 logical
 cpus
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "yinghai@kernel.org" <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1253326790.6699.38.camel@desktop>
References: <1253325936.3948.720.camel@sbs-t61.sc.intel.com>
	 <1253326790.6699.38.camel@desktop>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 18 Sep 2009 19:29:59 -0700
Message-Id: <1253327399.3948.747.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 19:19 -0700, Daniel Walker wrote:
> There are a couple of checkpatch issues in this patch .. Could you run
> it through and fix the errors that show up.. One is that you need 1 less
> tab for the code inside the switch statement .. You have another switch
> statement in apic.c that needs similar attention .

Oops. Here it is. Thanks!

---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, apic: use logical flat on intel with <= 8 logical cpus

On Intel platforms, we can use logical flat mode if there are <= 8
logical cpu's (irrespective of physical apic id values). This will
enable simplified and efficient IPI and device interrupt routing on
such platforms.

Fix the relevant comments while we are at it.

We can clean up default_setup_apic_routing() by using apic->probe()
but that is a different item.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a34601f..e3654ec 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -62,7 +62,7 @@ unsigned int boot_cpu_physical_apicid = -1U;
 /*
  * The highest APIC ID seen during enumeration.
  *
- * This determines the messaging protocol we can use: if all APIC IDs
+ * On AMD, this determines the messaging protocol we can use: if all APIC IDs
  * are in the 0 ... 7 range, then we can use logical addressing which
  * has some performance advantages (better broadcasting).
  *
@@ -1917,24 +1917,14 @@ void __cpuinit generic_processor_info(int apicid, int version)
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
index 65edc18..41e8509 100644
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


