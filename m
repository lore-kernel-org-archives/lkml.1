Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbZE0ABa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbZE0ABa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbZEZXzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:55:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38630 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389AbZEZXyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:55 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 25/31] x86: MCE: Implement new status bits v2
Date: Wed, 27 May 2009 01:54:27 +0200
Message-Id: <650bd32edc1814f1f792a07de9c5efebefc9c0b3.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <e224e71ae8e2b578d4b4a0a079eea963445eaf91.1243381848.git.ak@linux.intel.com>
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
 <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
 <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
 <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
 <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
 <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com>
 <314f7c278aaaa41854bf4f0837a4ca6126160fc8.1243381848.git.ak@linux.intel.com>
 <ecbed09ba385129558d6341f6a48c64edaa164b4.1243381848.git.ak@linux.intel.com>
 <d9664a5ed1cdbfcd7888c7c7114619494114d4ab.1243381848.git.ak@linux.intel.com>
 <172ffa34ba8bc6a493e26f7e97fb7239f906b4e8.1243381848.git.ak@linux.intel.com>
 <e224e71ae8e2b578d4b4a0a079eea963445eaf91.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
is centralized in one place. This is useful because it has to be evaluated
multiple times.

v2: Some rule fixes; Add AO events
Fix RIPV, RIPV|EIPV order (Ying Huang)
Fix UCNA with AR=1 message (Ying Huang)
Add comment about panicing in m_c_p.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mce.h                |   10 ++++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |    5 ++
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   82 ++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/mcheck/mce.c          |   85 +++++++++++++++--------------
 4 files changed, 137 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 2c4209d..0cc8175 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -15,6 +15,7 @@
 #define MCG_CTL_P		(1ULL << 8)  /* MCG_CAP register available */
 #define MCG_EXT_P		(1ULL << 9)  /* Extended registers available */
 #define MCG_CMCI_P		(1ULL << 10)  /* CMCI supported */
+#define MCG_SER_P	 (1ULL<<24)  /* MCA recovery/new status bits */
 
 #define MCG_STATUS_RIPV  (1ULL<<0)   /* restart ip valid */
 #define MCG_STATUS_EIPV  (1ULL<<1)   /* ip points to correct instruction */
@@ -27,6 +28,15 @@
 #define MCI_STATUS_MISCV (1ULL<<59)  /* misc error reg. valid */
 #define MCI_STATUS_ADDRV (1ULL<<58)  /* addr reg. valid */
 #define MCI_STATUS_PCC   (1ULL<<57)  /* processor context corrupt */
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
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index f126b4a..54dcb8f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
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
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index c189e89..4f4d2ca 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -19,43 +19,117 @@
  * first. Since there are quite a lot of combinations test the bits in a
  * table-driven way. The rules are simply processed in order, first
  * match wins.
+ *
+ * Note this is only used for machine check exceptions, the corrected
+ * errors use much simpler rules. The exceptions still check for the corrected
+ * errors, but only to leave them alone for the CMCI handler (except for
+ * panic situations)
  */
 
+enum context { IN_KERNEL = 1, IN_USER = 2 };
+enum ser { SER_REQUIRED = 1, NO_SER = 2 };
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
+#define SER .ser = SER_REQUIRED
+#define NOSER .ser = NO_SER
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
 	BITCLR(MCI_STATUS_EN, NO, "Not enabled"),
 	BITSET(MCI_STATUS_PCC, PANIC, "Processor context corrupt"),
-	MCGMASK(MCG_STATUS_RIPV, 0, PANIC, "No restart IP"),
+	/* When MCIP is not set something is very confused */
+	MCGMASK(MCG_STATUS_MCIP, 0, PANIC, "MCIP not set in MCA handler"),
+	/* Neither return not error IP -- no chance to recover -> PANIC */
+	MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0, PANIC,
+		"Neither restart nor error IP"),
+	MCGMASK(MCG_STATUS_RIPV, 0, PANIC, "In kernel and no restart IP",
+		KERNEL),
+	BITCLR(MCI_STATUS_UC, KEEP, "Corrected error", NOSER),
+	MASK(MCI_STATUS_OVER|MCI_STATUS_UC|MCI_STATUS_EN, MCI_STATUS_UC, SOME,
+	     "Spurious not enabled", SER),
+
+	/* ignore OVER for UCNA */
+	MASK(MCI_UC_SAR, MCI_STATUS_UC, KEEP,
+	     "Uncorrected no action required", SER),
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_UC|MCI_STATUS_AR, PANIC,
+	     "Illegal combination (UCNA with AR=1)", SER),
+	MASK(MCI_STATUS_S, 0, KEEP, "Non signalled machine check", SER),
+
+	/* AR add known MCACODs here */
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_STATUS_OVER|MCI_UC_SAR, PANIC,
+	     "Action required with lost events", SER),
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_SAR, PANIC,
+	     "Action required; unknown MCACOD", SER),
+
+	/* known AO MCACODs: */
+	MASK(MCI_UC_SAR|MCI_STATUS_OVER|0xfff0, MCI_UC_S|0xc0, AO,
+	     "Action optional: memory scrubbing error", SER),
+	MASK(MCI_UC_SAR|MCI_STATUS_OVER|MCACOD, MCI_UC_S|0x17a, AO,
+	     "Action optional: last level cache writeback error", SER),
+
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S, SOME,
+	     "Action optional unknown MCACOD", SER),
+	MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_S|MCI_STATUS_OVER, SOME,
+	     "Action optional with lost events", SER),
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
+	enum context ctx = error_context(a);
 	struct severity *s;
+
 	for (s = severities;; s++) {
 		if ((a->status & s->mask) != s->result)
 			continue;
 		if ((a->mcgstatus & s->mcgmask) != s->mcgres)
 			continue;
-		if (s->sev > MCE_NO_SEVERITY && (a->status & MCI_STATUS_UC) &&
-			tolerant < 1)
-			return MCE_PANIC_SEVERITY;
+		if (s->ser == SER_REQUIRED && !mce_ser)
+			continue;
+		if (s->ser == NO_SER && mce_ser)
+			continue;
+		if (s->context && ctx != s->context)
+			continue;
 		if (msg)
 			*msg = s->msg;
+		if (s->sev >= MCE_UC_SEVERITY && ctx == IN_KERNEL) {
+			if (panic_on_oops || tolerant < 1)
+				return MCE_PANIC_SEVERITY;
+		}
 		return s->sev;
 	}
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index c511d05..8c55c86 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -83,6 +83,7 @@ static int			rip_msr;
 static int			mce_bootlog = -1;
 static int			monarch_timeout = -1;
 static int			mce_panic_timeout;
+int				mce_ser;
 
 static char			trigger[128];
 static char			*trigger_argv[2] = { trigger, NULL };
@@ -381,6 +382,15 @@ DEFINE_PER_CPU(unsigned, mce_poll_count);
  * Those are just logged through /dev/mcelog.
  *
  * This is executed in standard interrupt context.
+ *
+ * Note: spec recommends to panic for fatal unsignalled
+ * errors here. However this would be quite problematic --
+ * we would need to reimplement the Monarch handling and
+ * it would mess up the exclusion between exception handler
+ * and poll hander -- * so we skip this for now.
+ * These cases should not happen anyways, or only when the CPU
+ * is already totally * confused. In this case it's likely it will
+ * not fully execute the machine check handler either.
  */
 void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 {
@@ -407,13 +417,13 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
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
@@ -780,6 +790,12 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -799,10 +815,11 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -810,17 +827,16 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -828,6 +844,12 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -836,7 +858,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		mce_get_rip(&m, regs);
 		mce_log(&m);
 
-		severity = mce_severity(&m, tolerant, NULL);
 		if (severity > worst) {
 			*final = m;
 			worst = severity;
@@ -869,29 +890,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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
@@ -1041,6 +1041,9 @@ static int mce_cap_init(void)
 	    ((cap >> MCG_EXT_CNT_SHIFT) & MCG_BANKCNT_MASK) >= 9)
 		rip_msr = MSR_IA32_MCG_EIP;
 
+	if (cap & MCG_SER_P)
+		mce_ser = 1;
+
 	return 0;
 }
 
-- 
1.6.0.2

