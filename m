Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbZE0AC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbZE0AC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbZEZXzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:55:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38642 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbZEZXy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:59 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 16/31] x86: MCE: Implement panic synchronization
Date: Wed, 27 May 2009 01:54:18 +0200
Message-Id: <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
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
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
 arch/x86/kernel/cpu/mcheck/mce.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a61eead..65c62d1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -182,10 +182,32 @@ static void print_mce(struct mce *m)
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
-- 
1.6.0.2

