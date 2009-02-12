Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbZBLMsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbZBLMsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759773AbZBLMoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:44:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34518 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759330AbZBLMo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:44:28 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212143.515129156@firstfloor.org>
In-Reply-To: <20090212143.515129156@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/4] x86: MCE: Separate correct machine check poller and fatal exception handler v2
Message-Id: <20090212124323.945953E666D@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:43:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

The machine check poller is diverging more and more from the fatal
exception handler. Instead of adding more special cases separate the code
paths completely. The corrected poll path is actually quite simple,
and this doesn't result in much code duplication.

This makes both handlers much easier to read and results in
cleaner code flow.  The exception handler now only needs to care
about uncorrected errors, which also simplifies the handling of multiple
errors. The corrected poller also now always runs in standard interrupt
context and does not need to do anything special to handle NMI context.

Minor behaviour changes:
- MCG status is now not cleared on polling.
- Only the banks which had corrected errors get cleared on polling
- The exception handler only clears banks with errors now

v2: Forward port to new patch order. Add "uc" argument.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h              |    7 +
 arch/x86/kernel/cpu/mcheck/mce_64.c     |  129 ++++++++++++++++++++++++++------
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    2 
 3 files changed, 116 insertions(+), 22 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:18.000000000 +0100
@@ -3,6 +3,8 @@
  * K8 parts Copyright 2002,2003 Andi Kleen, SuSE Labs.
  * Rest from unknown author(s).
  * 2004 Andi Kleen. Rewrote most of it.
+ * Copyright 2008 Intel Corporation
+ * Author: Andi Kleen
  */
 
 #include <linux/init.h>
@@ -189,7 +191,77 @@
 }
 
 /*
- * The actual machine check handler
+ * Poll for corrected events or events that happened before reset.
+ * Those are just logged through /dev/mcelog.
+ *
+ * This is executed in standard interrupt context.
+ */
+void machine_check_poll(enum mcp_flags flags)
+{
+	struct mce m;
+	int i;
+
+	mce_setup(&m);
+
+	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
+	for (i = 0; i < banks; i++) {
+		if (!bank[i])
+			continue;
+
+		m.misc = 0;
+		m.addr = 0;
+		m.bank = i;
+		m.tsc = 0;
+
+		barrier();
+		rdmsrl(MSR_IA32_MC0_STATUS + i*4, m.status);
+		if (!(m.status & MCI_STATUS_VAL))
+			continue;
+
+		/*
+		 * Uncorrected events are handled by the exception handler
+		 * when it is enabled. But when the exception is disabled log
+		 * everything.
+		 *
+		 * TBD do the same check for MCI_STATUS_EN here?
+		 */
+		if ((m.status & MCI_STATUS_UC) && !(flags & MCP_UC))
+			continue;
+
+		if (m.status & MCI_STATUS_MISCV)
+			rdmsrl(MSR_IA32_MC0_MISC + i*4, m.misc);
+		if (m.status & MCI_STATUS_ADDRV)
+			rdmsrl(MSR_IA32_MC0_ADDR + i*4, m.addr);
+
+		if (!(flags & MCP_TIMESTAMP))
+			m.tsc = 0;
+		/*
+		 * Don't get the IP here because it's unlikely to
+		 * have anything to do with the actual error location.
+		 */
+
+		mce_log(&m);
+		add_taint(TAINT_MACHINE_CHECK);
+
+		/*
+		 * Clear state for this bank.
+		 */
+		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+	}
+
+	/*
+	 * Don't clear MCG_STATUS here because it's only defined for
+	 * exceptions.
+	 */
+}
+
+/*
+ * The actual machine check handler. This only handles real
+ * exceptions when something got corrupted coming in through int 18.
+ *
+ * This is executed in NMI context not subject to normal locking rules. This
+ * implies that most kernel services cannot be safely used. Don't even
+ * think about putting a printk in there!
  */
 void do_machine_check(struct pt_regs * regs, long error_code)
 {
@@ -207,13 +279,14 @@
 	 * error.
 	 */
 	int kill_it = 0;
+	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
 
 	atomic_inc(&mce_entry);
 
-	if ((regs
-	     && notify_die(DIE_NMI, "machine check", regs, error_code,
+	if (notify_die(DIE_NMI, "machine check", regs, error_code,
 			   18, SIGKILL) == NOTIFY_STOP)
-	    || !banks)
+		goto out2;
+	if (!banks)
 		goto out2;
 
 	mce_setup(&m);
@@ -227,6 +300,7 @@
 	barrier();
 
 	for (i = 0; i < banks; i++) {
+		__clear_bit(i, toclear);
 		if (!bank[i])
 			continue;
 
@@ -238,6 +312,20 @@
 		if ((m.status & MCI_STATUS_VAL) == 0)
 			continue;
 
+		/*
+		 * Non uncorrected errors are handled by machine_check_poll
+		 * Leave them alone.
+		 */
+		if ((m.status & MCI_STATUS_UC) == 0)
+			continue;
+
+		/*
+		 * Set taint even when machine check was not enabled.
+		 */
+		add_taint(TAINT_MACHINE_CHECK);
+
+		__set_bit(i, toclear);
+
 		if (m.status & MCI_STATUS_EN) {
 			/* if PCC was set, there's no way out */
 			no_way_out |= !!(m.status & MCI_STATUS_PCC);
@@ -251,6 +339,12 @@
 					no_way_out = 1;
 				kill_it = 1;
 			}
+		} else {
+			/*
+			 * Machine check event was not enabled. Clear, but
+			 * ignore.
+			 */
+			continue;
 		}
 
 		if (m.status & MCI_STATUS_MISCV)
@@ -259,10 +353,7 @@
 			rdmsrl(MSR_IA32_MC0_ADDR + i*4, m.addr);
 
 		mce_get_rip(&m, regs);
-		if (error_code < 0)
-			m.tsc = 0;
-		if (error_code != -2)
-			mce_log(&m);
+		mce_log(&m);
 
 		/* Did this bank cause the exception? */
 		/* Assume that the bank with uncorrectable errors did it,
@@ -271,14 +362,8 @@
 			panicm = m;
 			panicm_found = 1;
 		}
-
-		add_taint(TAINT_MACHINE_CHECK);
 	}
 
-	/* Never do anything final in the polling timer */
-	if (!regs)
-		goto out;
-
 	/* If we didn't find an uncorrectable error, pick
 	   the last one (shouldn't happen, just being safe). */
 	if (!panicm_found)
@@ -325,10 +410,11 @@
 	/* notify userspace ASAP */
 	set_thread_flag(TIF_MCE_NOTIFY);
 
- out:
 	/* the last thing we do is clear state */
-	for (i = 0; i < banks; i++)
-		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+	for (i = 0; i < banks; i++) {
+		if (test_bit(i, toclear))
+			wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+	}
 	wrmsrl(MSR_IA32_MCG_STATUS, 0);
  out2:
 	atomic_dec(&mce_entry);
@@ -377,7 +463,7 @@
 	WARN_ON(smp_processor_id() != data);
 
 	if (mce_available(&current_cpu_data))
-		do_machine_check(NULL, 0);
+		machine_check_poll(MCP_TIMESTAMP);
 
 	/*
 	 * Alert userspace if needed.  If we logged an MCE, reduce the
@@ -489,9 +575,10 @@
 	u64 cap;
 	int i;
 
-	/* Log the machine checks left over from the previous reset.
-	   This also clears all registers */
-	do_machine_check(NULL, mce_bootlog ? -1 : -2);
+	/*
+	 * Log the machine checks left over from the previous reset.
+	 */
+	machine_check_poll(MCP_UC);
 
 	set_in_cr4(X86_CR4_MCE);
 
Index: linux/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2009-02-12 12:10:18.000000000 +0100
@@ -231,7 +231,7 @@
 
 			/* Log the machine check that caused the threshold
 			   event. */
-			do_machine_check(NULL, 0);
+			machine_check_poll(MCP_TIMESTAMP);
 
 			if (high & MASK_OVERFLOW_HI) {
 				rdmsrl(address, m.misc);
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/include/asm/mce.h	2009-02-12 12:10:18.000000000 +0100
@@ -112,6 +112,13 @@
 extern atomic_t mce_entry;
 
 extern void do_machine_check(struct pt_regs *, long);
+
+enum mcp_flags {
+	MCP_TIMESTAMP = (1 << 0),	/* log time stamp */
+	MCP_UC = (1 << 1),		/* log uncorrected errors */
+};
+extern void machine_check_poll(enum mcp_flags flags);
+
 extern int mce_notify_user(void);
 
 #endif /* !CONFIG_X86_32 */
