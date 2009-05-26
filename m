Return-Path: <linux-kernel-owner+w=401wt.eu-S1759110AbZEZXSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110AbZEZXSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756661AbZEZXSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53141 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbZEZXSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:22 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/17] x86: MCE: Implement the PPro bank 0 quirk in the 64bit machine check code
Date: Wed, 27 May 2009 01:18:01 +0200
Message-Id: <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Quoting the comment:

* SDM documents that on family 6 bank 0 should not be written
* because it aliases to another special BIOS controlled
* register.
* But it's not aliased anymore on model 0x1a+
* Don't ignore bank 0 completely because there could be a valid
* event later, merely don't write CTL0.

This is mostly a port on the 32bit code, except that 32bit
always didn't write it and didn't have the 0x1a heuristic. I checked
with the CPU designers that the quirk is not required starting with
this model.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   40 ++++++++++++++++++++++++++++++++-----
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08ffe55..89c9d6b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -65,6 +65,8 @@ static atomic_t			mce_events;
 static char			trigger[128];
 static char			*trigger_argv[2] = { trigger, NULL };
 
+static unsigned long		dont_init_banks;
+
 static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 
 /* MCA banks polled by the period polling timer for corrected events */
@@ -72,6 +74,11 @@ DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
 	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
 };
 
+static inline int skip_bank_init(int i)
+{
+	return i < BITS_PER_LONG && test_bit(i, &dont_init_banks);
+}
+
 /* Do initial initialization of a struct mce */
 void mce_setup(struct mce *m)
 {
@@ -617,6 +624,8 @@ static void mce_init(void *dummy)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 
 	for (i = 0; i < banks; i++) {
+		if (skip_bank_init(i))
+			continue;
 		wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
@@ -644,6 +653,19 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 		}
 	}
 
+	if (c->x86_vendor == X86_VENDOR_INTEL) {
+		/*
+		 * SDM documents that on family 6 bank 0 should not be written
+		 * because it aliases to another special BIOS controlled
+		 * register.
+		 * But it's not aliased anymore on model 0x1a+
+		 * Don't ignore bank 0 completely because there could be a
+		 * valid event later, merely don't write CTL0.
+		 */
+
+		if (c->x86 == 6 && c->x86_model < 0x1A)
+			__set_bit(0, &dont_init_banks);
+	}
 }
 
 static void mce_cpu_features(struct cpuinfo_x86 *c)
@@ -912,8 +934,10 @@ static int mce_disable(void)
 {
 	int i;
 
-	for (i = 0; i < banks; i++)
-		wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
+	for (i = 0; i < banks; i++) {
+		if (!skip_bank_init(i))
+			wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
+	}
 	return 0;
 }
 
@@ -1124,8 +1148,10 @@ static void mce_disable_cpu(void *h)
 		return;
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_clear();
-	for (i = 0; i < banks; i++)
-		wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
+	for (i = 0; i < banks; i++) {
+		if (!skip_bank_init(i))
+			wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
+	}
 }
 
 static void mce_reenable_cpu(void *h)
@@ -1138,8 +1164,10 @@ static void mce_reenable_cpu(void *h)
 
 	if (!(action & CPU_TASKS_FROZEN))
 		cmci_reenable();
-	for (i = 0; i < banks; i++)
-		wrmsrl(MSR_IA32_MC0_CTL + i*4, bank[i]);
+	for (i = 0; i < banks; i++) {
+		if (!skip_bank_init(i))
+			wrmsrl(MSR_IA32_MC0_CTL + i*4, bank[i]);
+	}
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
-- 
1.6.0.2

