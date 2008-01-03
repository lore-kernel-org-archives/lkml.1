Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbYACAz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbYACAz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYACAuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759892AbYACAuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:15 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [18/20] x86: Don't disable TSC in any C states on AMD Fam10h
Message-Id: <20080103005014.2F86314D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The ACPI code currently disables TSC use in any C2 and C3 
states. But the AMD Fam10h BKDG documents that the TSC
will never stop in any C states when the CONSTANT_TSC bit is 
set. Make this disabling conditional on CONSTANT_TSC
not set on AMD.

I actually think this is true on Intel too for C2 states
on CPUs with p-state invariant TSC, but this needs
further discussions with Len to really confirm :-) 

So far it is only enabled on AMD.

Cc: lenb@kernel.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/acpi/processor_idle.c |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

Index: linux/drivers/acpi/processor_idle.c
===================================================================
--- linux.orig/drivers/acpi/processor_idle.c
+++ linux/drivers/acpi/processor_idle.c
@@ -353,6 +353,26 @@ int acpi_processor_resume(struct acpi_de
 	return 0;
 }
 
+#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+static int tsc_halts_in_c(int state)
+{
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		/*
+		 * AMD Fam10h TSC will tick in all
+		 * C/P/S0/S1 states when this bit is set.
+		 */
+		if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+			return 0;
+		/*FALL THROUGH*/
+	case X86_VENDOR_INTEL:
+		/* Several cases known where TSC halts in C2 too */
+	default:
+		return state > ACPI_STATE_C1;
+	}
+}
+#endif
+
 #ifndef CONFIG_CPU_IDLE
 static void acpi_processor_idle(void)
 {
@@ -512,7 +532,8 @@ static void acpi_processor_idle(void)
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
 		/* TSC halts in C2, so notify users */
-		mark_tsc_unstable("possible TSC halt in C2");
+		if (tsc_halts_in_c(ACPI_STATE_C2))
+			mark_tsc_unstable("possible TSC halt in C2");
 #endif
 		/* Compute time (ticks) that we were actually asleep */
 		sleep_ticks = ticks_elapsed(t1, t2);
@@ -576,7 +597,8 @@ static void acpi_processor_idle(void)
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
 		/* TSC halts in C3, so notify users */
-		mark_tsc_unstable("TSC halts in C3");
+		if (tsc_halts_in_c(ACPI_STATE_C3))
+			mark_tsc_unstable("TSC halts in C3");
 #endif
 		/* Compute time (ticks) that we were actually asleep */
 		sleep_ticks = ticks_elapsed(t1, t2);
@@ -1441,7 +1463,8 @@ static int acpi_idle_enter_simple(struct
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
 	/* TSC could halt in idle, so notify users */
-	mark_tsc_unstable("TSC halts in idle");;
+	if (tsc_halts_in_c(cx->type))
+		mark_tsc_unstable("TSC halts in idle");;
 #endif
 	sleep_ticks = ticks_elapsed(t1, t2);
 
@@ -1552,7 +1575,8 @@ static int acpi_idle_enter_bm(struct cpu
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
 	/* TSC could halt in idle, so notify users */
-	mark_tsc_unstable("TSC halts in idle");
+	if (tsc_halts_in_c(ACPI_STATE_C3))
+		mark_tsc_unstable("TSC halts in idle");
 #endif
 	sleep_ticks = ticks_elapsed(t1, t2);
 	/* Tell the scheduler how much we idled: */
