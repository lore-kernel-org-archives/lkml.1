Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbXCUOHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbXCUOHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXCUOHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:07:32 -0400
Received: from www.osadl.org ([213.239.205.134]:47742 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752865AbXCUOHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:07:31 -0400
Subject: [PATCH] i386: disable local apic timer via command line or dmi
	quirk
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stefan Prechtel <stefan.prechtel@googlemail.com>
Cc: Andi Kleen <ak@suse.de>,
       Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Len Brown <lenb@kernel.org>, john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <b93822910703210604w6bcc2e1dt4cac7f9f9295edf8@mail.gmail.com>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <200703211137.10884.ak@suse.de>
	 <1174475666.10840.44.camel@localhost.localdomain>
	 <200703211342.59093.ak@suse.de>
	 <b93822910703210604w6bcc2e1dt4cac7f9f9295edf8@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 15:14:43 +0100
Message-Id: <1174486483.10840.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The local APIC timer stops to work in deeper C-States. This is handled
by the ACPI code and a broadcast mechanism in the clockevents / tick
managment code.

Some systems do not expose the deeper C-States to the kernel, but switch
into deeper C-States behind the kernels back. This delays the local apic
timer interrupts for ever and makes the systems unusable.

Add a command line option to disable the local apic timer and a dmi
quirk for known broken systems.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 856c8b1..06377c7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1117,6 +1117,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nolapic		[IA-32,APIC] Do not enable or use the local APIC.
 
+	nolapic_timer	[IA-32,APIC] Do not use the local APIC timer.
+
 	noltlbs		[PPC] Do not use large page/tlb entries for kernel
 			lowmem mapping on PPC40x.
 
diff --git a/arch/i386/kernel/apic.c b/arch/i386/kernel/apic.c
index 5cff797..3682511 100644
--- a/arch/i386/kernel/apic.c
+++ b/arch/i386/kernel/apic.c
@@ -28,6 +28,7 @@
 #include <linux/clockchips.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
+#include <linux/dmi.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -61,6 +62,8 @@ static int enable_local_apic __initdata = 0;
 
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
+/* Disable local APIC timer from the kernel commandline or via dmi quirk */
+static int local_apic_timer_disabled;
 
 /*
  * Debug level, exported for io_apic.c
@@ -266,6 +269,32 @@ static void __devinit setup_APIC_timer(void)
 }
 
 /*
+ * Detect systems with known broken BIOS implementations
+ */
+static int __init lapic_check_broken_bios(struct dmi_system_id *d)
+{
+	printk(KERN_NOTICE "%s detected: disabling lapic timer.\n",
+		       d->ident);
+	local_apic_timer_disabled = 1;
+	return 0;
+}
+
+static struct dmi_system_id __initdata broken_bios_dmi_table[] = {
+	{
+		/*
+		 * BIOS exports only C1 state, but uses deeper power
+		 * modes behind the kernels back.
+		 */
+		  .callback = lapic_check_broken_bios,
+		  .ident = "HP nx6325",
+		  .matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
+		  },
+	 },
+	 {}
+};
+
+/*
  * In this functions we calibrate APIC bus clocks to the external timer.
  *
  * We want to do the calibration only once since we want to have local timer
@@ -340,6 +369,22 @@ void __init setup_boot_APIC_clock(void)
 	long delta, deltapm;
 	int pm_referenced = 0;
 
+	/* Detect know broken systems */
+	dmi_check_system(broken_bios_dmi_table);
+
+	/*
+	 * The local apic timer can be disabled via the kernel
+	 * commandline or from the dmi quirk above. Register the lapic
+	 * timer as a dummy clock event source on SMP systems, so the
+	 * broadcast mechanism is used. On UP systems simply ignore it.
+	 */
+	if (local_apic_timer_disabled) {
+		/* No broadcast on UP ! */
+		if (num_possible_cpus() > 1)
+			setup_APIC_timer();
+		return;
+	}
+
 	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
 		    "calibrating APIC timer ...\n");
 
@@ -1179,6 +1224,13 @@ static int __init parse_nolapic(char *arg)
 }
 early_param("nolapic", parse_nolapic);
 
+static int __init parse_disable_lapic_timer(char *arg)
+{
+	local_apic_timer_disabled = 1;
+	return 0;
+}
+early_param("nolapic_timer", parse_disable_lapic_timer);
+
 static int __init apic_set_verbosity(char *str)
 {
 	if (strcmp("debug", str) == 0)


