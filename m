Return-Path: <linux-kernel-owner+w=401wt.eu-S1752142Ab0AKExf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab0AKExf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 23:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929Ab0AKExd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 23:53:33 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33626 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab0AKExc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 23:53:32 -0500
Date: Mon, 11 Jan 2010 10:23:26 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, suresh.b.siddha@intel.com,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: [PATCH] Revert 2fbd07a5f so machines with BSPs phsyical apic id !=
	0 can boot
Message-ID: <20100111045326.GA11725@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100109101038.GA17555@in.ibm.com> <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com> <20100110023015.GA2253@in.ibm.com> <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com> <20100110102638.GA7838@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110102638.GA7838@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an 8-way machine with quad-core Xeon, booting 2.6.32 or newer kernels
fails:

...
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x0c] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x0d] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x0e] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0f] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x13] enabled)
...

Setting APIC routing to flat
Getting VERSION: 50014
Getting VERSION: 50014
Getting ID: c000000
Getting ID: f3000000
Getting LVT0: 700
Getting LVT1: 400
enabled ExtINT on CPU#0
ESR value before enabling vector: 0x00000040  after: 0x00000000
ENABLING IO-APIC IRQs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz stepping 0b
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1665619
... PM-Timer delta = 357899
... PM-Timer result ok
..... delta 1665619
..... mult: 71548666
..... calibration result: 266499
..... CPU clock speed is 2931.0489 MHz.
..... host bus clock speed is 266.0499 MHz.
Booting Node   0, Processors  #1masked ExtINT on CPU#1
 #2masked ExtINT on CPU#2
 #3masked ExtINT on CPU#3
 #4masked ExtINT on CPU#4
 #5masked ExtINT on CPU#5
 #6masked ExtINT on CPU#6
 #7 Ok.
masked ExtINT on CPU#7
Brought up 8 CPUs
Total of 8 processors activated (46905.61 BogoMIPS).

Per Yinghai Lu, the BSP's physical apic id is 0x0c instead of 0, and is
not sure if that case was tested.

For now, revert this optimization so the machines in question boot
at least.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/x86/kernel/apic/apic.c     |   26 ++++++++++++++++++--------
 arch/x86/kernel/apic/probe_64.c |   15 ++++-----------
 2 files changed, 22 insertions(+), 19 deletions(-)

Index: linux-2.6.33-rc3/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.33-rc3.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.33-rc3/arch/x86/kernel/apic/apic.c
@@ -62,7 +62,7 @@ unsigned int boot_cpu_physical_apicid = 
 /*
  * The highest APIC ID seen during enumeration.
  *
- * On AMD, this determines the messaging protocol we can use: if all APIC IDs
+ * This determines the messaging protocol we can use: if all APIC IDs
  * are in the 0 ... 7 range, then we can use logical addressing which
  * has some performance advantages (better broadcasting).
  *
@@ -1898,14 +1898,24 @@ void __cpuinit generic_processor_info(in
 		max_physical_apicid = apicid;
 
 #ifdef CONFIG_X86_32
-	switch (boot_cpu_data.x86_vendor) {
-	case X86_VENDOR_INTEL:
-		if (num_processors > 8)
-			def_to_bigsmp = 1;
-		break;
-	case X86_VENDOR_AMD:
-		if (max_physical_apicid >= 8)
+	/*
+	 * Would be preferable to switch to bigsmp when CONFIG_HOTPLUG_CPU=y
+	 * but we need to work other dependencies like SMP_SUSPEND etc
+	 * before this can be done without some confusion.
+	 * if (CPU_HOTPLUG_ENABLED || num_processors > 8)
+	 *       - Ashok Raj <ashok.raj@intel.com>
+	 */
+	if (max_physical_apicid >= 8) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			if (!APIC_XAPIC(version)) {
+				def_to_bigsmp = 0;
+				break;
+			}
+			/* If P4 and above fall through */
+		case X86_VENDOR_AMD:
 			def_to_bigsmp = 1;
+		}
 	}
 #endif
 
Index: linux-2.6.33-rc3/arch/x86/kernel/apic/probe_64.c
===================================================================
--- linux-2.6.33-rc3.orig/arch/x86/kernel/apic/probe_64.c
+++ linux-2.6.33-rc3/arch/x86/kernel/apic/probe_64.c
@@ -64,23 +64,16 @@ void __init default_setup_apic_routing(v
 			apic = &apic_x2apic_phys;
 		else
 			apic = &apic_x2apic_cluster;
+		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 #endif
 
 	if (apic == &apic_flat) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (num_processors > 8)
-				apic = &apic_physflat;
-			break;
-		case X86_VENDOR_AMD:
-			if (max_physical_apicid >= 8)
-				apic = &apic_physflat;
-		}
+		if (max_physical_apicid >= 8)
+			apic = &apic_physflat;
+		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 
-	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
-
 	if (is_vsmp_box()) {
 		/* need to update phys_pkg_id */
 		apic->phys_pkg_id = apicid_phys_pkg_id;
