Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab0APDKR (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876Ab0APDKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:10:06 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33978 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859Ab0APDIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:08:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 19:07:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 32/37] x86, apic: Use logical flat on intel with <= 8 logical
 cpus
In-reply-to: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
Message-id: <1263611228-6751-33-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

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
index e80f291..aa57c07 100644
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
@@ -1898,24 +1898,14 @@ void __cpuinit generic_processor_info(int apicid, int version)
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
-- 
1.6.4.2

