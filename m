Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbZGHWdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbZGHWdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758401AbZGHWbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:31:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47051 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758457AbZGHWbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:45 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200907091231.681564770@firstfloor.org>
In-Reply-To: <200907091231.681564770@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] [7/8] x86: mce: macros to compute banks MSRs
Message-Id: <20090708223144.52D611D035D@basil.firstfloor.org>
Date: Thu,  9 Jul 2009 00:31:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Instead of open coded calculations for bank MSRs hide the indexing of higher 
banks MCE register MSRs in new macros.

No semantic changes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/msr-index.h       |    7 ++++++
 arch/x86/kernel/cpu/mcheck/mce.c       |   34 ++++++++++++++++-----------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   10 ++++-----
 3 files changed, 29 insertions(+), 22 deletions(-)

Index: linux/arch/x86/include/asm/msr-index.h
===================================================================
--- linux.orig/arch/x86/include/asm/msr-index.h
+++ linux/arch/x86/include/asm/msr-index.h
@@ -81,8 +81,15 @@
 #define MSR_IA32_MC0_ADDR		0x00000402
 #define MSR_IA32_MC0_MISC		0x00000403
 
+#define MSR_IA32_MCx_CTL(x)		(MSR_IA32_MC0_CTL + 4*(x))
+#define MSR_IA32_MCx_STATUS(x)		(MSR_IA32_MC0_STATUS + 4*(x))
+#define MSR_IA32_MCx_ADDR(x)		(MSR_IA32_MC0_ADDR + 4*(x))
+#define MSR_IA32_MCx_MISC(x)		(MSR_IA32_MC0_MISC + 4*(x))
+
 /* These are consecutive and not in the normal 4er MCE bank block */
 #define MSR_IA32_MC0_CTL2		0x00000280
+#define MSR_IA32_MCx_CTL2(x)		(MSR_IA32_MC0_CTL2 + (x))
+
 #define CMCI_EN			(1ULL << 30)
 #define CMCI_THRESHOLD_MASK		0xffffULL
 
Index: linux/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce.c
@@ -267,11 +267,11 @@ static int msr_to_offset(u32 msr)
 	unsigned bank = __get_cpu_var(injectm.bank);
 	if (msr == rip_msr)
 		return offsetof(struct mce, ip);
-	if (msr == MSR_IA32_MC0_STATUS + bank*4)
+	if (msr == MSR_IA32_MCx_STATUS(bank))
 		return offsetof(struct mce, status);
-	if (msr == MSR_IA32_MC0_ADDR + bank*4)
+	if (msr == MSR_IA32_MCx_ADDR(bank))
 		return offsetof(struct mce, addr);
-	if (msr == MSR_IA32_MC0_MISC + bank*4)
+	if (msr == MSR_IA32_MCx_MISC(bank))
 		return offsetof(struct mce, misc);
 	if (msr == MSR_IA32_MCG_STATUS)
 		return offsetof(struct mce, mcgstatus);
@@ -485,7 +485,7 @@ void machine_check_poll(enum mcp_flags f
 		m.tsc = 0;
 
 		barrier();
-		m.status = mce_rdmsrl(MSR_IA32_MC0_STATUS + i*4);
+		m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
 		if (!(m.status & MCI_STATUS_VAL))
 			continue;
 
@@ -500,9 +500,9 @@ void machine_check_poll(enum mcp_flags f
 			continue;
 
 		if (m.status & MCI_STATUS_MISCV)
-			m.misc = mce_rdmsrl(MSR_IA32_MC0_MISC + i*4);
+			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
 		if (m.status & MCI_STATUS_ADDRV)
-			m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + i*4);
+			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
@@ -518,7 +518,7 @@ void machine_check_poll(enum mcp_flags f
 		/*
 		 * Clear state for this bank.
 		 */
-		mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+		mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
 	}
 
 	/*
@@ -539,7 +539,7 @@ static int mce_no_way_out(struct mce *m,
 	int i;
 
 	for (i = 0; i < banks; i++) {
-		m->status = mce_rdmsrl(MSR_IA32_MC0_STATUS + i*4);
+		m->status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
 		if (mce_severity(m, tolerant, msg) >= MCE_PANIC_SEVERITY)
 			return 1;
 	}
@@ -823,7 +823,7 @@ static void mce_clear_state(unsigned lon
 
 	for (i = 0; i < banks; i++) {
 		if (test_bit(i, toclear))
-			mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+			mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
 	}
 }
 
@@ -904,7 +904,7 @@ void do_machine_check(struct pt_regs *re
 		m.addr = 0;
 		m.bank = i;
 
-		m.status = mce_rdmsrl(MSR_IA32_MC0_STATUS + i*4);
+		m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
 		if ((m.status & MCI_STATUS_VAL) == 0)
 			continue;
 
@@ -945,9 +945,9 @@ void do_machine_check(struct pt_regs *re
 			kill_it = 1;
 
 		if (m.status & MCI_STATUS_MISCV)
-			m.misc = mce_rdmsrl(MSR_IA32_MC0_MISC + i*4);
+			m.misc = mce_rdmsrl(MSR_IA32_MCx_MISC(i));
 		if (m.status & MCI_STATUS_ADDRV)
-			m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + i*4);
+			m.addr = mce_rdmsrl(MSR_IA32_MCx_ADDR(i));
 
 		/*
 		 * Action optional error. Queue address for later processing.
@@ -1216,8 +1216,8 @@ static void mce_init(void)
 		struct mce_bank *b = &mce_banks[i];
 		if (!b->init)
 			continue;
-		wrmsrl(MSR_IA32_MC0_CTL+4*i, b->ctl);
-		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+		wrmsrl(MSR_IA32_MCx_CTL(i), b->ctl);
+		wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
 	}
 }
 
@@ -1589,7 +1589,7 @@ static int mce_disable(void)
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 		if (b->init)
-			wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
+			wrmsrl(MSR_IA32_MCx_CTL(i), 0);
 	}
 	return 0;
 }
@@ -1876,7 +1876,7 @@ static void mce_disable_cpu(void *h)
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 		if (b->init)
-			wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
+			wrmsrl(MSR_IA32_MCx_CTL(i), 0);
 	}
 }
 
@@ -1893,7 +1893,7 @@ static void mce_reenable_cpu(void *h)
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
 		if (b->init)
-			wrmsrl(MSR_IA32_MC0_CTL + i*4, b->ctl);
+			wrmsrl(MSR_IA32_MCx_CTL(i), b->ctl);
 	}
 }
 
Index: linux/arch/x86/kernel/cpu/mcheck/mce_intel.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -90,7 +90,7 @@ static void cmci_discover(int banks, int
 		if (test_bit(i, owned))
 			continue;
 
-		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 
 		/* Already owned by someone else? */
 		if (val & CMCI_EN) {
@@ -101,8 +101,8 @@ static void cmci_discover(int banks, int
 		}
 
 		val |= CMCI_EN | CMCI_THRESHOLD;
-		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
-		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
+		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 
 		/* Did the enable bit stick? -- the bank supports CMCI */
 		if (val & CMCI_EN) {
@@ -152,9 +152,9 @@ void cmci_clear(void)
 		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
 			continue;
 		/* Disable CMCI */
-		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		rdmsrl(MSR_IA32_MCx_CTL2(i), val);
 		val &= ~(CMCI_EN|CMCI_THRESHOLD_MASK);
-		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		wrmsrl(MSR_IA32_MCx_CTL2(i), val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}
 	spin_unlock_irqrestore(&cmci_discover_lock, flags);
