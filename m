Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbZDGPO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbZDGPO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbZDGPIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48854 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648AbZDGPH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:59 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [15/28] x86: MCE: Remove TSC print heuristic
Message-Id: <20090407150757.5B7CC1D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: bug fix, cleanup

Previously mce_panic used a simple heuristic to avoid printing
old so far unreported machine check events on a mce panic. This worked
by comparing the TSC value at the start of the machine check handler 
with the event time stamp and only printing newer ones.

This has a couple of issues, in particular on systems where the TSC
is not fully synchronized between CPUs it could lose events or print
old ones.

It is also problematic with full system synchronization as it is
added by the next patch.

Remove the TSC heuristic and instead replace it with a simple heuristic
to print corrected errors first and after that uncorrected errors
and finally the worst machine check as determined by the machine 
check handler.

This simplifies the code because there is no need to pass the
original TSC value around.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:12.000000000 +0200
@@ -151,23 +151,29 @@
 	       "and contact your hardware vendor\n");
 }
 
-static void mce_panic(char *msg, struct mce *backup, unsigned long start)
+static void mce_panic(char *msg, struct mce *final)
 {
 	int i;
 
 	bust_spinlocks(1);
 	console_verbose();
+	/* First print corrected ones that are still unlogged */
 	for (i = 0; i < MCE_LOG_LEN; i++) {
-		unsigned long tsc = mcelog.entry[i].tsc;
-
-		if (time_before(tsc, start))
+		struct mce *m = &mcelog.entry[i];
+		if ((m->status & MCI_STATUS_VAL) &&
+			!(m->status & MCI_STATUS_UC))
+			print_mce(m);
+	}
+	/* Now print uncorrected but with the final one last */
+	for (i = 0; i < MCE_LOG_LEN; i++) {
+		struct mce *m = &mcelog.entry[i];
+		if (!(m->status & MCI_STATUS_VAL))
 			continue;
-		print_mce(&mcelog.entry[i]);
-		if (backup && mcelog.entry[i].tsc == backup->tsc)
-			backup = NULL;
+		if (!final || memcmp(m, final, sizeof(struct mce)))
+			print_mce(m);
 	}
-	if (backup)
-		print_mce(backup);
+	if (final)
+		print_mce(final);
 	panic(msg);
 }
 
@@ -329,7 +335,6 @@
 void do_machine_check(struct pt_regs * regs, long error_code)
 {
 	struct mce m, panicm;
-	u64 mcestart = 0;
 	int i;
 	int panicm_found = 0;
 	/*
@@ -361,7 +366,6 @@
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
 		no_way_out = 1;
 
-	rdtscll(mcestart);
 	barrier();
 
 	for (i = 0; i < banks; i++) {
@@ -439,7 +443,7 @@
 	 *  has not set tolerant to an insane level, give up and die.
 	 */
 	if (no_way_out && tolerant < 3)
-		mce_panic("Machine check", &panicm, mcestart);
+		mce_panic("Machine check", &panicm);
 
 	/*
 	 * If the error seems to be unrecoverable, something should be
@@ -467,8 +471,7 @@
 		if (user_space && tolerant > 0) {
 			force_sig(SIGBUS, current);
 		} else if (panic_on_oops || tolerant < 2) {
-			mce_panic("Uncorrected machine check",
-				&panicm, mcestart);
+			mce_panic("Uncorrected machine check", &panicm);
 		}
 	}
 
