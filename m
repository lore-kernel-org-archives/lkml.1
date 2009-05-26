Return-Path: <linux-kernel-owner+w=401wt.eu-S1760538AbZEZXWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538AbZEZXWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759440AbZEZXSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53174 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759305AbZEZXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:32 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/17] x86: MCE: Add MSR read wrappers for easier error injection
Date: Wed, 27 May 2009 01:18:15 +0200
Message-Id: <7121e96e33d1ed8d244d06c258897d02ae0980ce.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <6d2add3cbbc275431bb41837f8c256fbbc473a46.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
 <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
 <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
 <b7b15c0ea92409e6641de1e90da9c63664066eba.1243377662.git.ak@linux.intel.com>
 <e2d81decded3202e410a569f8c224986f2e83668.1243377662.git.ak@linux.intel.com>
 <c8c4b619d810eba16e62044a38284761ef69c8f2.1243377662.git.ak@linux.intel.com>
 <91219e907da103fc39dba8d32aaa9f872f0e6cc1.1243377662.git.ak@linux.intel.com>
 <2bc54830cc9e63d090dc461db0bdf99fc3d3cd4a.1243377662.git.ak@linux.intel.com>
 <6dfa191bd595ff969fafb3603ba464254ca895a7.1243377662.git.ak@linux.intel.com>
 <ff5aa0b2473d839010ec97dc3dbae4e198c28db9.1243377662.git.ak@linux.intel.com>
 <17986790ae68ad7f93701894fd130cfd84f6adf5.1243377662.git.ak@linux.intel.com>
 <6d2add3cbbc275431bb41837f8c256fbbc473a46.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This will be used by future patches to allow machine check error injection.
Right now it's a nop, except for adding some wrappers around the MSR reads.

This is early in the sequence to avoid too many conflicts.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   37 +++++++++++++++++++++++++------------
 1 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a3c8bd0..76962ff 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -194,6 +194,19 @@ static void mce_panic(char *msg, struct mce *backup, u64 start)
 	panic(msg);
 }
 
+/* MSR access wrappers used for error injection */
+static u64 mce_rdmsrl(u32 msr)
+{
+	u64 v;
+	rdmsrl(msr, v);
+	return v;
+}
+
+static void mce_wrmsrl(u32 msr, u64 v)
+{
+	wrmsrl(msr, v);
+}
+
 int mce_available(struct cpuinfo_x86 *c)
 {
 	if (mce_disabled)
@@ -213,7 +226,7 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 	if (rip_msr) {
 		/* Assume the RIP in the MSR is exact. Is this true? */
 		m->mcgstatus |= MCG_STATUS_EIPV;
-		rdmsrl(rip_msr, m->ip);
+		m->ip = mce_rdmsrl(rip_msr);
 		m->cs = 0;
 	}
 }
@@ -231,7 +244,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 	mce_setup(&m);
 
-	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
+	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	for (i = 0; i < banks; i++) {
 		if (!bank[i] || !test_bit(i, *b))
 			continue;
@@ -242,7 +255,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		m.tsc = 0;
 
 		barrier();
-		rdmsrl(MSR_IA32_MC0_STATUS + i*4, m.status);
+		m.status = mce_rdmsrl(MSR_IA32_MC0_STATUS + i*4);
 		if (!(m.status & MCI_STATUS_VAL))
 			continue;
 
@@ -257,9 +270,9 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 			continue;
 
 		if (m.status & MCI_STATUS_MISCV)
-			rdmsrl(MSR_IA32_MC0_MISC + i*4, m.misc);
+			m.misc = mce_rdmsrl(MSR_IA32_MC0_MISC + i*4);
 		if (m.status & MCI_STATUS_ADDRV)
-			rdmsrl(MSR_IA32_MC0_ADDR + i*4, m.addr);
+			m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + i*4);
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
@@ -275,7 +288,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		/*
 		 * Clear state for this bank.
 		 */
-		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+		mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
 
 	/*
@@ -320,7 +333,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 
 	mce_setup(&m);
 
-	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
+	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 
 	/* if the restart IP is not valid, we're done for */
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
@@ -338,7 +351,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		m.addr = 0;
 		m.bank = i;
 
-		rdmsrl(MSR_IA32_MC0_STATUS + i*4, m.status);
+		m.status = mce_rdmsrl(MSR_IA32_MC0_STATUS + i*4);
 		if ((m.status & MCI_STATUS_VAL) == 0)
 			continue;
 
@@ -378,9 +391,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		}
 
 		if (m.status & MCI_STATUS_MISCV)
-			rdmsrl(MSR_IA32_MC0_MISC + i*4, m.misc);
+			m.misc = mce_rdmsrl(MSR_IA32_MC0_MISC + i*4);
 		if (m.status & MCI_STATUS_ADDRV)
-			rdmsrl(MSR_IA32_MC0_ADDR + i*4, m.addr);
+			m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + i*4);
 
 		mce_get_rip(&m, regs);
 		mce_log(&m);
@@ -449,9 +462,9 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	/* the last thing we do is clear state */
 	for (i = 0; i < banks; i++) {
 		if (test_bit(i, toclear))
-			wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+			mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
-	wrmsrl(MSR_IA32_MCG_STATUS, 0);
+	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
  out2:
 	atomic_dec(&mce_entry);
 }
-- 
1.6.0.2

