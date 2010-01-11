Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345Ab0AKXqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0AKXqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311Ab0AKXqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:46:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:26017 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab0AKXqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:46:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,258,1262592000"; 
   d="scan'208";a="586291196"
Subject: Re: [PATCH] Revert 2fbd07a5f so machines with BSPs phsyical apic
 id != 0 can boot
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <alpine.LFD.2.00.1001111454060.17145@localhost.localdomain>
References: <20100109101038.GA17555@in.ibm.com>
	 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
	 <20100110023015.GA2253@in.ibm.com>
	 <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>
	 <20100110102638.GA7838@elte.hu>  <20100111045326.GA11725@in.ibm.com>
	 <1263245985.2859.497.camel@sbs-t61.sc.intel.com>
	 <alpine.LFD.2.00.1001111454060.17145@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 11 Jan 2010 15:45:13 -0800
Message-Id: <1263253513.2859.833.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 14:55 -0800, Linus Torvalds wrote:
> 
> On Mon, 11 Jan 2010, Suresh Siddha wrote:
> > 
> > So far, I don't see a need for the revert.
> 
> It's very easy. It breaks. You don't have a fix. We'll revert it.

Linus, We are in -rc3 and thought we have few days atleast to sort it
out and post the correct fix to the problem, rather than do a quick
revert (as we know that the current code is not fundamentally broken).

But if you want to revert, I have appended a patch to revert this, which
has the correct subject, description etc atleast. I can work with Ananth
and re-submit this for the next release.

---
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Revert "x86, apic: Use logical flat on intel with <= 8 logical cpus"

Revert commit 2fbd07a5f5d1295fa9b0c0564ec27da7c276a75a, as this commit breaks
an IBM platform with quad-core Xeon cpu's.

According to Suresh, this might be an IBM platform issue, as on other Intel
platforms with <= 8 logical cpu's, logical flat mode works fine irrespective of
physical apic id values (inline with the xapic architecture).
    
Revert this for now because of an IBM platform breakage.

Another version will be re-submitted after the complete analysis.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org
---

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


