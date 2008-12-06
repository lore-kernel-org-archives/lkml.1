Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYLFGrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYLFGrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 01:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYLFGqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 01:46:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:37973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbYLFGqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 01:46:50 -0500
Message-ID: <493A1F9E.4010201@kernel.org>
Date: Fri, 05 Dec 2008 22:45:50 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: cleanup get_smp_config
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

reordering exit path in __get_smp_config
also move two print out to acpi_process_madt

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/acpi/boot.c |   11 +++++++++++
 arch/x86/kernel/mpparse.c   |   25 +++++++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -1360,6 +1360,17 @@ static void __init acpi_process_madt(voi
 			disable_acpi();
 		}
 	}
+
+	/*
+	 * ACPI supports both logical (e.g. Hyper-Threading) and physical
+	 * processors, where MPS only supports physical.
+	 */
+	if (acpi_lapic && acpi_ioapic)
+		printk(KERN_INFO "Using ACPI (MADT) for SMP configuration "
+		       "information\n");
+	else if (acpi_lapic)
+		printk(KERN_INFO "Using ACPI for processor (LAPIC) "
+		       "configuration information\n");
 #endif
 	return;
 }
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -586,26 +586,23 @@ static void __init __get_smp_config(unsi
 {
 	struct intel_mp_floating *mpf = mpf_found;
 
-	if (x86_quirks->mach_get_smp_config) {
-		if (x86_quirks->mach_get_smp_config(early))
-			return;
-	}
+	if (!mpf)
+		return;
+
 	if (acpi_lapic && early)
 		return;
+
 	/*
-	 * ACPI supports both logical (e.g. Hyper-Threading) and physical
-	 * processors, where MPS only supports physical.
+	 * MPS doesn't support hyperthreading, aka only have
+	 * thread 0 apic id in MPS table
 	 */
-	if (acpi_lapic && acpi_ioapic) {
-		printk(KERN_INFO "Using ACPI (MADT) for SMP configuration "
-		       "information\n");
+	if (acpi_lapic && acpi_ioapic)
 		return;
-	} else if (acpi_lapic)
-		printk(KERN_INFO "Using ACPI for processor (LAPIC) "
-		       "configuration information\n");
 
-	if (!mpf)
-		return;
+	if (x86_quirks->mach_get_smp_config) {
+		if (x86_quirks->mach_get_smp_config(early))
+			return;
+	}
 
 	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
 	       mpf->mpf_specification);
