Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbZEZX6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbZEZX6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbZEZXy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38608 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbZEZXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:47 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 15/31] x86: MCE: Check early in exception handler if panic is needed
Date: Wed, 27 May 2009 01:54:17 +0200
Message-Id: <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
 <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
 arch/x86/kernel/cpu/mcheck/mce.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index f617c9b..a61eead 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -39,6 +39,7 @@
 #include <asm/ipi.h>
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include "mce-internal.h"
 
 #include "mce.h"
 
@@ -181,7 +182,7 @@ static void print_mce(struct mce *m)
 	       "and contact your hardware vendor\n");
 }
 
-static void mce_panic(char *msg, struct mce *final)
+static void mce_panic(char *msg, struct mce *final, char *exp)
 {
 	int i;
 
@@ -204,6 +205,8 @@ static void mce_panic(char *msg, struct mce *final)
 	}
 	if (final)
 		print_mce(final);
+	if (exp)
+		printk(KERN_EMERG "Machine check: %s\n", exp);
 	panic(msg);
 }
 
@@ -391,6 +394,22 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 EXPORT_SYMBOL_GPL(machine_check_poll);
 
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
@@ -414,6 +433,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 */
 	int kill_it = 0;
 	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
+	char *msg = "Unknown";
 
 	atomic_inc(&mce_entry);
 
@@ -428,10 +448,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	mce_setup(&m);
 
 	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
-
-	/* if the restart IP is not valid, we're done for */
-	if (!(m.mcgstatus & MCG_STATUS_RIPV))
-		no_way_out = 1;
+	no_way_out = mce_no_way_out(&m, &msg);
 
 	barrier();
 
@@ -463,18 +480,13 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -516,7 +528,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * has not set tolerant to an insane level, give up and die.
 	 */
 	if (no_way_out && tolerant < 3)
-		mce_panic("Machine check", &panicm);
+		mce_panic("Machine check", &panicm, msg);
 
 	/*
 	 * If the error seems to be unrecoverable, something should be
@@ -544,7 +556,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (user_space && tolerant > 0) {
 			force_sig(SIGBUS, current);
 		} else if (panic_on_oops || tolerant < 2) {
-			mce_panic("Uncorrected machine check", &panicm);
+			mce_panic("Uncorrected machine check", &panicm, msg);
 		}
 	}
 
-- 
1.6.0.2

