Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbZDGPPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbZDGPPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbZDGPIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48870 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758578AbZDGPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:04 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [18/28] x86: MCE: Check early in exception handler if panic is needed
Message-Id: <20090407150800.B74101D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Feature

The exception handler should behave differently if the exception is 
fatal versus one that can be returned from.  In the first case it should 
never clear any registers because these need to be preserved
for logging after the next boot. Otherwise it should clear them
on each CPU step by step so that other CPUs sharing the same bank don't
see duplicate events. Otherwise we risk reporting events multiple
times on any CPUs which have shared machine check banks, which
is a common problem on Intel Nehalem which has both SMT (two
CPU threads sharing banks) and shared machine check banks in the uncore.

Determine early in a special pass if any event requires a panic.
This uses the mce_severity() function added earlier.

This is needed for the next patch.

Also fixes a problem together with an earlier patch
that corrected events weren't logged on a fatal MCE.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   38 +++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:11.000000000 +0200
@@ -38,6 +38,7 @@
 #include <asm/ipi.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include "mce-internal.h"
 
 #define MISC_MCELOG_MINOR 227
 
@@ -150,7 +151,7 @@
 	       "and contact your hardware vendor\n");
 }
 
-static void mce_panic(char *msg, struct mce *final)
+static void mce_panic(char *msg, struct mce *final, char *exp)
 {
 	int i;
 
@@ -173,6 +174,8 @@
 	}
 	if (final)
 		print_mce(final);
+	if (exp)
+		printk(KERN_EMERG "Machine check: %s\n", exp);
 	panic(msg);
 }
 
@@ -324,6 +327,22 @@
 }
 
 /*
+ * Do a quick check if any of the events requires a panic.
+ * This decides if we keep the events around or clear them.
+ */
+static int mce_no_way_out(struct mce *m, char **msg)
+{
+	int i;
+
+	for (i = 0; i < banks; i++) {
+		m->status = mce_rdmsrl(MSR_IA32_MC0_STATUS + i*4);
+		if (mce_severity(m, tolerant, msg) >= MCE_PANIC_SEVERITY)
+			return 1;
+	}
+	return 0;
+}
+
+/*
  * The actual machine check handler. This only handles real
  * exceptions when something got corrupted coming in through int 18.
  *
@@ -347,6 +366,7 @@
 	 */
 	int kill_it = 0;
 	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
+	char *msg = "Unknown";
 
 	atomic_inc(&mce_entry);
 
@@ -360,10 +380,7 @@
 
 	mce_setup(&m);
 	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
-
-	/* if the restart IP is not valid, we're done for */
-	if (!(m.mcgstatus & MCG_STATUS_RIPV))
-		no_way_out = 1;
+	no_way_out = mce_no_way_out(&m, &msg);
 
 	barrier();
 
@@ -395,18 +412,13 @@
 		__set_bit(i, toclear);
 
 		if (m.status & MCI_STATUS_EN) {
-			/* if PCC was set, there's no way out */
-			no_way_out |= !!(m.status & MCI_STATUS_PCC);
 			/*
 			 * If this error was uncorrectable and there was
 			 * an overflow, we're in trouble.  If no overflow,
 			 * we might get away with just killing a task.
 			 */
-			if (m.status & MCI_STATUS_UC) {
-				if (tolerant < 1 || m.status & MCI_STATUS_OVER)
-					no_way_out = 1;
+			if (m.status & MCI_STATUS_UC)
 				kill_it = 1;
-			}
 		} else {
 			/*
 			 * Machine check event was not enabled. Clear, but
@@ -442,7 +454,7 @@
 	 *  has not set tolerant to an insane level, give up and die.
 	 */
 	if (no_way_out && tolerant < 3)
-		mce_panic("Machine check", &panicm);
+		mce_panic("Machine check", &panicm, msg);
 
 	/*
 	 * If the error seems to be unrecoverable, something should be
@@ -470,7 +482,7 @@
 		if (user_space && tolerant > 0) {
 			force_sig(SIGBUS, current);
 		} else if (panic_on_oops || tolerant < 2) {
-			mce_panic("Uncorrected machine check", &panicm);
+			mce_panic("Uncorrected machine check", &panicm, msg);
 		}
 	}
 
