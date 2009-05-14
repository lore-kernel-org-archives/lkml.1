Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZENWO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZENWO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZENWOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:14:47 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:37020 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZENWOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:14:47 -0400
Date: Thu, 14 May 2009 17:55:16 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Janne Kulmala <janne.t.kulmala@tut.fi>, Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       johnstul@us.ibm.com
Subject: [PATCH] ACPI: idle: fix init-time TSC check regression
In-reply-to: <alpine.LFD.2.00.0905142217340.3561@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0905141750100.24833@localhost.localdomain>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com>
 <200905110226.50115.elendil@planet.nl>
 <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
 <4A0855A5.8040109@tut.fi>
 <alpine.LFD.2.00.0905141545280.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905141608070.24833@localhost.localdomain>
 <alpine.LFD.2.00.0905142217340.3561@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

A previous 2.6.30 patch, a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2,
(ACPI: idle: mark_tsc_unstable() at init-time, not run-time)
erroneously disabled the TSC on systems that did not actually
have valid deep C-states.

Move the check after the deep-C-states are validated,
via new helper, tsc_check_state(), hich replaces tsc_halts_in_c().

Signed-off-by: Len Brown <len.brown@intel.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
Thomas,
I decided to use a tsc-specific helper
rather than piggyback on acpi_timer_check_state(),
since that is not general, but rather LAPIC timer specific.
(and I'll re-name that to reflect its specific function
 in a cosmetic follow-up patch)

 drivers/acpi/processor_idle.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f7ca8c5..421cc5c 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -216,7 +216,7 @@ int acpi_processor_resume(struct acpi_device * device)
 }
 
 #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
-static int tsc_halts_in_c(int state)
+static void tsc_check_state(int state)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
@@ -226,13 +226,17 @@ static int tsc_halts_in_c(int state)
 		 * C/P/S0/S1 states when this bit is set.
 		 */
 		if (boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
-			return 0;
+			return;
 
 		/*FALL THROUGH*/
 	default:
-		return state > ACPI_STATE_C1;
+		/* TSC could halt in idle, so notify users */
+		if (state > ACPI_STATE_C1)
+			mark_tsc_unstable("TSC halts in idle");
 	}
 }
+#else
+static void tsc_check_state(int state) { return; }
 #endif
 
 static int acpi_processor_get_power_info_fadt(struct acpi_processor *pr)
@@ -581,11 +585,6 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER; i++) {
 		struct acpi_processor_cx *cx = &pr->power.states[i];
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
-		/* TSC could halt in idle, so notify users */
-		if (tsc_halts_in_c(cx->type))
-			mark_tsc_unstable("TSC halts in idle");;
-#endif
 		switch (cx->type) {
 		case ACPI_STATE_C1:
 			cx->valid = 1;
@@ -603,6 +602,8 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 				acpi_timer_check_state(i, pr, cx);
 			break;
 		}
+		if (cx->valid)
+			tsc_check_state(cx->type);
 
 		if (cx->valid)
 			working++;
-- 
1.6.3.1.9.g95405b

