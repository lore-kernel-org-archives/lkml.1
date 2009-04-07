Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbZDGPOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbZDGPOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbZDGPH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48855 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575AbZDGPH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:58 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [14/28] x86: MCE: Add MSR read wrappers for easier error injection
Message-Id: <20090407150756.23F221D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This will be used by future patches to allow machine check error injection.
Right now it's a nop, except for adding some wrappers around the MSR reads.

This is early in the sequence to avoid too many conflicts.

Andi Kleen <ak@linux.intel.com>


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   37 ++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:12.000000000 +0200
@@ -171,6 +171,19 @@
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
 	if (mce_dont_init)
@@ -188,7 +201,7 @@
 		m->cs = 0;
 	}
 	if (rip_msr)
-		rdmsrl(rip_msr, m->ip);
+		m->ip = mce_rdmsrl(rip_msr);
 }
 
 /*
@@ -250,7 +263,7 @@
 
 	mce_setup(&m);
 
-	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
+	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 	for (i = 0; i < banks; i++) {
 		if (!bank[i] || !test_bit(i, *b))
 			continue;
@@ -261,7 +274,7 @@
 		m.tsc = 0;
 
 		barrier();
-		rdmsrl(MSR_IA32_MC0_STATUS + i*4, m.status);
+		m.status = mce_rdmsrl(MSR_IA32_MC0_STATUS + i*4);
 		if (!(m.status & MCI_STATUS_VAL))
 			continue;
 
@@ -276,9 +289,9 @@
 			continue;
 
 		if (m.status & MCI_STATUS_MISCV)
-			rdmsrl(MSR_IA32_MC0_MISC + i*4, m.misc);
+			m.misc = mce_rdmsrl(MSR_IA32_MC0_MISC + i*4);
 		if (m.status & MCI_STATUS_ADDRV)
-			rdmsrl(MSR_IA32_MC0_ADDR + i*4, m.addr);
+			m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + i*4);
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
@@ -294,7 +307,7 @@
 		/*
 		 * Clear state for this bank.
 		 */
-		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+		mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
 
 	/*
@@ -342,8 +355,8 @@
 		goto out;
 
 	mce_setup(&m);
+	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 
-	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
 	/* if the restart IP is not valid, we're done for */
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
 		no_way_out = 1;
@@ -360,7 +373,7 @@
 		m.addr = 0;
 		m.bank = i;
 
-		rdmsrl(MSR_IA32_MC0_STATUS + i*4, m.status);
+		m.status = mce_rdmsrl(MSR_IA32_MC0_STATUS + i*4);
 		if ((m.status & MCI_STATUS_VAL) == 0)
 			continue;
 
@@ -400,9 +413,9 @@
 		}
 
 		if (m.status & MCI_STATUS_MISCV)
-			rdmsrl(MSR_IA32_MC0_MISC + i*4, m.misc);
+			m.misc = mce_rdmsrl(MSR_IA32_MC0_MISC + i*4);
 		if (m.status & MCI_STATUS_ADDRV)
-			rdmsrl(MSR_IA32_MC0_ADDR + i*4, m.addr);
+			m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + i*4);
 
 		mce_get_rip(&m, regs);
 		mce_log(&m);
@@ -467,9 +480,9 @@
 	/* the last thing we do is clear state */
 	for (i = 0; i < banks; i++) {
 		if (test_bit(i, toclear))
-			wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
+			mce_wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
-	wrmsrl(MSR_IA32_MCG_STATUS, 0);
+	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
 out:
 	atomic_dec(&mce_entry);
 	sync_core();
