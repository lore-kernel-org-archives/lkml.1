Return-Path: <linux-kernel-owner+w=401wt.eu-S1030715AbXC2UvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030715AbXC2UvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 16:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030716AbXC2UvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 16:51:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:34254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030715AbXC2UvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 16:51:19 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Mark Langsdorf" <mark.langsdorf@amd.com>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
Date: Thu, 29 Mar 2007 22:49:37 +0200
User-Agent: KMail/1.9.5
Cc: "Len Brown" <lenb@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Morrow, William" <William.Morrow@amd.com>,
       "Crouse, Jordan" <jordan.crouse@ldcmail.amd.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Pavel Machek" <pavel@ucw.cz>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Mingming Cao" <cmm@us.ibm.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Oliver Pinter" <oliver.pntr@gmail.com>,
       "Sid Boyce" <g3vbv@blueyonder.co.uk>, "Nick Piggin" <npiggin@suse.de>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Renninger" <trenn@suse.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <p73d52s2dvi.fsf@bingen.suse.de> <460C1B5B.4090802@amd.com>
In-Reply-To: <460C1B5B.4090802@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703292249.37979.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Reviewed but not tested.  Needs to be wrapped in an AMD specific
> call.

Here's a patch. I don't have a system with C1E, so i only tested that
the apic timer still works on a older AMD box.

Would be good if someone with a Turion laptop, especially the HP nx6325
could test it with CONFIG_NO_HZ enabled.

-Andi

Disable local APIC timer use on AMD systems with C1E

AMD dual core laptops with C1E do not run the APIC timer correctly
when they go idle. Previously the code assumed this only happened
on C2 or deeper.  But not all of these systems report support C2.

Use a AMD supplied snippet to detect C1E being enabled and then disable
local apic timer use.

This supercedes an earlier workaround using DMI detection of specific systems.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -272,32 +272,6 @@ static void __devinit setup_APIC_timer(v
 }
 
 /*
- * Detect systems with known broken BIOS implementations
- */
-static int __init lapic_check_broken_bios(struct dmi_system_id *d)
-{
-	printk(KERN_NOTICE "%s detected: disabling lapic timer.\n",
-		       d->ident);
-	local_apic_timer_disabled = 1;
-	return 0;
-}
-
-static struct dmi_system_id __initdata broken_bios_dmi_table[] = {
-	{
-		/*
-		 * BIOS exports only C1 state, but uses deeper power
-		 * modes behind the kernels back.
-		 */
-		  .callback = lapic_check_broken_bios,
-		  .ident = "HP nx6325",
-		  .matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
-		  },
-	 },
-	 {}
-};
-
-/*
  * In this functions we calibrate APIC bus clocks to the external timer.
  *
  * We want to do the calibration only once since we want to have local timer
@@ -357,6 +331,44 @@ static void __init lapic_cal_handler(str
 	}
 }
 
+#define ENABLE_C1E_MASK         0x18000000
+#define CPUID_PROCESSOR_SIGNATURE       1
+#define CPUID_XFAM              0x0ff00000
+#define CPUID_XFAM_K8           0x00000000
+#define CPUID_XFAM_10H          0x00100000
+#define CPUID_XFAM_11H          0x00200000
+#define CPUID_XMOD              0x000f0000
+#define CPUID_XMOD_REV_F        0x00040000
+
+/* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
+static __init int amd_apic_timer_broken(void)
+{
+	u32 lo, hi;
+	u32 eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
+	switch (eax & CPUID_XFAM) {
+	case CPUID_XFAM_K8:
+		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
+			break;
+	case CPUID_XFAM_10H:
+	case CPUID_XFAM_11H:
+		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
+		if (lo & ENABLE_C1E_MASK)
+			return 1;
+                break;
+        default:
+                /* err on the side of caution */
+		return 1;
+        }
+	return 0;
+}
+
+static __init int apic_timer_broken(void)
+{
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return amd_apic_timer_broken();
+	return 0;
+}
+
 /*
  * Setup the boot APIC
  *
@@ -372,12 +384,12 @@ void __init setup_boot_APIC_clock(void)
 	long delta, deltapm;
 	int pm_referenced = 0;
 
-	/* Detect know broken systems */
-	dmi_check_system(broken_bios_dmi_table);
+	if (apic_timer_broken())
+		local_apic_timer_disabled = 1;
 
 	/*
 	 * The local apic timer can be disabled via the kernel
-	 * commandline or from the dmi quirk above. Register the lapic
+	 * commandline or from the test above. Register the lapic
 	 * timer as a dummy clock event source on SMP systems, so the
 	 * broadcast mechanism is used. On UP systems simply ignore it.
 	 */
Index: linux/include/asm-i386/msr.h
===================================================================
--- linux.orig/include/asm-i386/msr.h
+++ linux/include/asm-i386/msr.h
@@ -275,6 +275,8 @@ static inline void wrmsr_on_cpu(unsigned
 #define MSR_K7_FID_VID_CTL		0xC0010041
 #define MSR_K7_FID_VID_STATUS		0xC0010042
 
+#define MSR_K8_ENABLE_C1E		0xC0010055
+
 /* extended feature register */
 #define MSR_EFER 			0xc0000080
 
