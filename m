Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbZEZX6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbZEZX6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZEZXyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38598 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbZEZXyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:44 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/31] x86: MCE: Remove TSC print heuristic
Date: Wed, 27 May 2009 01:54:14 +0200
Message-Id: <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
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
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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

Contains fixes from Ying Huang

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 6219a18..93c3b93 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -152,6 +152,7 @@ void mce_log(struct mce *mce)
 	mcelog.entry[entry].finished = 1;
 	wmb();
 
+	mce->finished = 1;
 	set_bit(0, &notify_user);
 }
 
@@ -181,23 +182,29 @@ static void print_mce(struct mce *m)
 	       "and contact your hardware vendor\n");
 }
 
-static void mce_panic(char *msg, struct mce *backup, u64 start)
+static void mce_panic(char *msg, struct mce *final)
 {
 	int i;
 
 	bust_spinlocks(1);
 	console_verbose();
+	/* First print corrected ones that are still unlogged */
 	for (i = 0; i < MCE_LOG_LEN; i++) {
-		u64 tsc = mcelog.entry[i].tsc;
-
-		if ((s64)(tsc - start) < 0)
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
 
@@ -396,7 +403,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 {
 	struct mce m, panicm;
 	int panicm_found = 0;
-	u64 mcestart = 0;
 	int i;
 	/*
 	 * If no_way_out gets set, there is no safe way to recover from this
@@ -428,7 +434,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
 		no_way_out = 1;
 
-	rdtscll(mcestart);
 	barrier();
 
 	for (i = 0; i < banks; i++) {
@@ -512,7 +517,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * has not set tolerant to an insane level, give up and die.
 	 */
 	if (no_way_out && tolerant < 3)
-		mce_panic("Machine check", &panicm, mcestart);
+		mce_panic("Machine check", &panicm);
 
 	/*
 	 * If the error seems to be unrecoverable, something should be
@@ -540,8 +545,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (user_space && tolerant > 0) {
 			force_sig(SIGBUS, current);
 		} else if (panic_on_oops || tolerant < 2) {
-			mce_panic("Uncorrected machine check",
-				&panicm, mcestart);
+			mce_panic("Uncorrected machine check", &panicm);
 		}
 	}
 
-- 
1.6.0.2

