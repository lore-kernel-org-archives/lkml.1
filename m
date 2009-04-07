Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZDGPTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZDGPTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbZDGPIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48885 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbZDGPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:14 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [28/28] x86: MCE: Implement new status bits
Message-Id: <20090407150811.DD6DA1D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The x86 architecture recently added some new machine check status bits:
S(ignalled) and AR (Action-Required). Signalled allows to check
if a specific event caused an exception or was just logged through CMCI.
AR allows the kernel to decide if an event needs immediate action
or can be delayed or ignored.

Implement support for these new status bits. mce_severity() uses
the new bits to grade the machine check correctly and decide what
to do. The exception handler uses AR to decide to kill or not.
The S bit is used to separate events between the poll/CMCI handler
and the exception handler.

Classical UC always leads to panic. That was true before anyways
because the existing CPUs always passed a PCC with it.

Also corrects the rules whether to kill in user or kernel context
and how to handle missing RIPV.

The machine check handler largely uses the mce-severity grading
engine now instead of making its own decisions. This means the logic
is centralized in one place.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h                |   10 +++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    5 +
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   63 ++++++++++++++++++++++--
 arch/x86/kernel/cpu/mcheck/mce_64.c       |   76 +++++++++++++-----------------
 4 files changed, 108 insertions(+), 46 deletions(-)

Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/include/asm/mce.h	2009-04-07 16:43:05.000000000 +0200
@@ -15,6 +15,7 @@
 #define MCG_EXT_P	 (1ULL<<9)   /* Extended registers available */
 #define MCG_NUM_EXT(c)	 (((c) >> 16) & 0xff)
 #define MCG_CMCI_P	 (1ULL<<10)  /* CMCI supported */
+#define MCG_SER_P	 (1ULL<<24)  /* MCA recovery/new status bits */
 
 #define MCG_STATUS_RIPV  (1UL<<0)   /* restart ip valid */
 #define MCG_STATUS_EIPV  (1UL<<1)   /* ip points to correct instruction */
@@ -27,6 +28,15 @@
 #define MCI_STATUS_MISCV (1UL<<59)  /* misc error reg. valid */
 #define MCI_STATUS_ADDRV (1UL<<58)  /* addr reg. valid */
 #define MCI_STATUS_PCC   (1UL<<57)  /* processor context corrupt */
+#define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
+#define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
+
+/* MISC register defines */
+#define MCM_ADDR_SEGOFF  0	/* segment offset */
+#define MCM_ADDR_LINEAR  1	/* linear address */
+#define MCM_ADDR_PHYS	 2	/* physical address */
+#define MCM_ADDR_MEM	 3	/* memory address */
+#define MCM_ADDR_GENERIC 7	/* generic */
 
 /* Fields are zero when not available */
 struct mce {
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:05.000000000 +0200
@@ -65,6 +65,7 @@
 static int mce_bootlog = -1;
 static int monarch_timeout = -1;
 static int mce_panic_timeout;
+int mce_ser;
 
 static char trigger[128];
 static char *trigger_argv[2] = { trigger, NULL };
@@ -367,13 +368,13 @@
 			continue;
 
 		/*
-		 * Uncorrected events are handled by the exception handler
-		 * when it is enabled. But when the exception is disabled log
-		 * everything.
+		 * Uncorrected or signalled events are handled by the exception
+		 * handler when it is enabled, so don't process those here.
 		 *
 		 * TBD do the same check for MCI_STATUS_EN here?
 		 */
-		if ((m.status & MCI_STATUS_UC) && !(flags & MCP_UC))
+		if (!(flags & MCP_UC) &&
+		    (m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)))
 			continue;
 
 		if (m.status & MCI_STATUS_MISCV)
@@ -736,6 +737,12 @@
 	barrier();
 
 	/*
+	 * When no restart IP must always kill or panic.
+	 */
+	if (!(m.mcgstatus & MCG_STATUS_RIPV))
+		kill_it = 1;
+
+	/*
 	 * Go through all the banks in exclusion of the other CPUs.
 	 * This way we don't report duplicated events on shared banks
 	 * because the first one to see it will clear it.
@@ -755,10 +762,11 @@
 			continue;
 
 		/*
-		 * Non uncorrected errors are handled by machine_check_poll
-		 * Leave them alone, unless this panics.
+		 * Non uncorrected or non signaled errors are handled by
+		 * machine_check_poll. Leave them alone, unless this panics.
 		 */
-		if ((m.status & MCI_STATUS_UC) == 0 && !no_way_out)
+		if (!(m.status & (mce_ser ? MCI_STATUS_S : MCI_STATUS_UC)) &&
+			!no_way_out)
 			continue;
 
 		/*
@@ -766,17 +774,16 @@
 		 */
 		add_taint(TAINT_MACHINE_CHECK);
 
-		__set_bit(i, toclear);
+		severity = mce_severity(&m, tolerant, NULL);
 
-		if (m.status & MCI_STATUS_EN) {
-			/*
-			 * If this error was uncorrectable and there was
-			 * an overflow, we're in trouble.  If no overflow,
-			 * we might get away with just killing a task.
-			 */
-			if (m.status & MCI_STATUS_UC)
-				kill_it = 1;
-		} else {
+		/*
+		 * When machine check was for corrected handler don't touch,
+		 * unless we're panicing.
+		 */
+		if (severity == MCE_KEEP_SEVERITY && !no_way_out)
+			continue;
+		__set_bit(i, toclear);
+		if (severity == MCE_NO_SEVERITY) {
 			/*
 			 * Machine check event was not enabled. Clear, but
 			 * ignore.
@@ -784,6 +791,12 @@
 			continue;
 		}
 
+		/*
+		 * Kill on action required.
+		 */
+		if (severity == MCE_AR_SEVERITY)
+			kill_it = 1;
+
 		if (m.status & MCI_STATUS_MISCV)
 			m.misc = mce_rdmsrl(MSR_IA32_MC0_MISC + i*4);
 		if (m.status & MCI_STATUS_ADDRV)
@@ -792,7 +805,6 @@
 		mce_get_rip(&m, regs);
 		mce_log(&m);
 
-		severity = mce_severity(&m, tolerant, NULL);
 		if (severity > worst) {
 			*final = m;
 			worst = severity;
@@ -825,29 +837,8 @@
 	 * one task, do that.  If the user has set the tolerance very
 	 * high, don't try to do anything at all.
 	 */
-	if (kill_it && tolerant < 3) {
-		int user_space = 0;
-
-		/*
-		 * If the EIPV bit is set, it means the saved IP is the
-		 * instruction which caused the MCE.
-		 */
-		if (m.mcgstatus & MCG_STATUS_EIPV)
-			user_space = final->ip && (final->cs & 3);
-
-		/*
-		 * If we know that the error was in user space, send a
-		 * SIGBUS.  Otherwise, panic if tolerance is low.
-		 *
-		 * force_sig() takes an awful lot of locks and has a slight
-		 * risk of deadlocking.
-		 */
-		if (user_space && tolerant > 0) {
-			force_sig(SIGBUS, current);
-		} else if (panic_on_oops || tolerant < 2) {
-			mce_panic("Uncorrected machine check", final, msg);
-		}
-	}
+	if (kill_it && tolerant < 3)
+		force_sig(SIGBUS, current);
 
 	/* notify userspace ASAP */
 	set_thread_flag(TIF_MCE_NOTIFY);
@@ -992,6 +983,9 @@
 	if ((cap & MCG_EXT_P) && (MCG_NUM_EXT(cap) >= 9))
 		rip_msr = MSR_IA32_MCG_EIP;
 
+	if (cap & MCG_SER_P)
+		mce_ser = 1;
+
 	return 0;
 }
 
Index: linux/arch/x86/kernel/cpu/mcheck/mce-severity.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce-severity.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce-severity.c	2009-04-07 16:43:04.000000000 +0200
@@ -21,28 +21,78 @@
  * match wins.
  */
 
+enum context { IN_KERNEL, IN_USER };
+
 static struct severity {
 	u64 mask;
 	u64 result;
 	unsigned char sev;
 	unsigned char mcgmask;
 	unsigned char mcgres;
+	unsigned char ser;
+	unsigned char context;
 	char *msg;
 } severities[] = {
+#define KERNEL .context = IN_KERNEL
+#define USER .context = IN_USER
+#define SER .ser = 1
+#define NOSER .ser = -1
 #define SEV(s) .sev = MCE_ ## s ## _SEVERITY
 #define BITCLR(x, s, m, r...) { .mask = x, .result = 0, SEV(s), .msg = m, ## r }
 #define BITSET(x, s, m, r...) { .mask = x, .result = x, SEV(s), .msg = m, ## r }
 #define MCGMASK(x, res, s, m, r...) \
 	{ .mcgmask = x, .mcgres = res, SEV(s), .msg = m, ## r }
+#define MASK(x, y, s, m, r...) \
+	{ .mask = x, .result = y, SEV(s), .msg = m, ## r }
+#define MCI_UC_S (MCI_STATUS_UC|MCI_STATUS_S)
+#define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
+#define MCACOD 0xffff
+
 	BITCLR(MCI_STATUS_VAL, NO, "Invalid"),
-	BITCLR(MCI_STATUS_EN, NO, "Not enabled"),
+	BITCLR(MCI_STATUS_EN, NO, "Not enabled", NOSER),
 	BITSET(MCI_STATUS_PCC, PANIC, "Processor context corrupt"),
-	MCGMASK(MCG_STATUS_RIPV, 0, PANIC, "No restart IP"),
+	/* When MCIP is not set something is very confused */
+	MCGMASK(MCG_STATUS_MCIP, 0, PANIC, "MCIP not set in MCA handler"),
+	MCGMASK(MCG_STATUS_RIPV, 0, PANIC, "In kernel and no restart IP",
+		KERNEL),
+	/* Neither return not error IP -- no chance to recover -> PANIC */
+	MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0, PANIC,
+		"Neither restart nor error IP"),
+	BITCLR(MCI_STATUS_UC, KEEP, "Corrected error"),
+	MASK(MCI_STATUS_OVER|MCI_STATUS_UC|MCI_STATUS_EN, MCI_STATUS_UC, SOME,
+	     "Spurious not enabled", SER),
+	BITCLR(MCI_STATUS_EN, NO, "Not enabled ser", SER),
+	/* AR add known MCACODs here */
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR, PANIC,
+	     "Action required; unknown MCACOD", SER),
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR, PANIC,
+	     "Action required with lost events", SER),
+	/* AO add known MCACODs here */
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S, SOME,
+	     "Action optional unknown MCACOD", SER),
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER, SOME,
+	     "Action optional with lost events", SER),
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC, KEEP,
+	     "Uncorrected no action required", SER),
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC|MCI_STATUS_AR, PANIC,
+	     "Illegal combination (UCNA with S=1)", SER),
 	BITSET(MCI_STATUS_UC|MCI_STATUS_OVER, PANIC, "Overflowed uncorrected"),
 	BITSET(MCI_STATUS_UC, UC, "Uncorrected"),
 	BITSET(0, SOME, "No match")	/* always matches. keep at end */
 };
 
+/*
+ * If the EIPV bit is set, it means the saved IP is the
+ * instruction which caused the MCE.
+ */
+static int error_context(struct mce *m)
+{
+	if (m->mcgstatus & MCG_STATUS_EIPV)
+		return (m->ip && (m->cs & 3) == 3) ? IN_USER : IN_KERNEL;
+	/* Unknown, assume kernel */
+	return IN_KERNEL;
+}
+
 int mce_severity(struct mce *a, int tolerant, char **msg)
 {
 	struct severity *s;
@@ -51,11 +101,14 @@
 			continue;
 		if ((a->mcgstatus & s->mcgmask) != s->mcgres)
 			continue;
-		if (s->sev > MCE_NO_SEVERITY && (a->status & MCI_STATUS_UC) &&
-			tolerant < 1)
-			return MCE_PANIC_SEVERITY;
+		if ((s->ser == 1 && !mce_ser) || (s->ser == -1 && mce_ser))
+			continue;
+		if (s->context && error_context(a) != s->context)
+			continue;
 		if (msg)
 			*msg = s->msg;
+		if (s->context == IN_KERNEL && panic_on_oops)
+			return MCE_PANIC_SEVERITY;
 		return s->sev;
 	}
 }
Index: linux/arch/x86/kernel/cpu/mcheck/mce-internal.h
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce-internal.h	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce-internal.h	2009-04-07 16:39:36.000000000 +0200
@@ -2,9 +2,14 @@
 
 enum severity_level {
 	MCE_NO_SEVERITY,
+	MCE_KEEP_SEVERITY,
 	MCE_SOME_SEVERITY,
+	MCE_AO_SEVERITY,
 	MCE_UC_SEVERITY,
+	MCE_AR_SEVERITY,
 	MCE_PANIC_SEVERITY,
 };
 
 int mce_severity(struct mce *a, int tolerant, char **msg);
+
+extern int mce_ser;
