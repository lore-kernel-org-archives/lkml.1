Return-Path: <linux-kernel-owner+w=401wt.eu-S1760321AbZDGPPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbZDGPPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758626AbZDGPIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:07 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48871 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203AbZDGPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:06 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [19/28] x86: MCE: Implement panic synchronization
Message-Id: <20090407150801.EFC881D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: bugfix

In some circumstances multiple CPUs can enter mce_panic() in parallel. This
gives quite confused output because they will all dump the same machine check
buffer. 

The other problem is that they would all panic in parallel, but not process
each other's shutdown IPIs because interrupts are disabled.

Detect this situation early on in mce_panic(). On the first CPU
entering will do the panic, the others will just wait to be killed.

For paranoia reasons in case the other CPU dies during the MCE I added 
a 5 seconds timeout. If it expires each CPU will panic on its own again,

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:11.000000000 +0200
@@ -151,10 +151,32 @@
 	       "and contact your hardware vendor\n");
 }
 
+#define PANIC_TIMEOUT 5 /* 5 seconds */
+
+static atomic_t mce_paniced;
+
+/* Panic in progress. Enable interrupts and wait for final IPI */
+static void wait_for_panic(void)
+{
+	long timeout = PANIC_TIMEOUT*USEC_PER_SEC;
+	preempt_disable();
+	local_irq_enable();
+	while (timeout-- > 0)
+		udelay(1);
+	panic("Panicing machine check CPU died");
+}
+
 static void mce_panic(char *msg, struct mce *final, char *exp)
 {
 	int i;
 
+	/*
+	 * Make sure only one CPU runs in machine check panic
+	 */
+	if (atomic_add_return(1, &mce_paniced) > 1)
+		wait_for_panic();
+	barrier();
+
 	bust_spinlocks(1);
 	console_verbose();
 	/* First print corrected ones that are still unlogged */
