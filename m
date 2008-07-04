Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbYGDVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbYGDVVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYGDVV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:21:29 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:6050 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbYGDVV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:21:28 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200807041120.678642023@firstfloor.org>
In-Reply-To: <200807041120.678642023@firstfloor.org>
To: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/9] MCE: Implement the PPro bank 0 quirk in the 64bit machine check code
Message-Id: <20080704212026.B31F31B431F@basil.firstfloor.org>
Date: Fri,  4 Jul 2008 23:20:26 +0200 (CEST)
X-OriginalArrivalTime: 04 Jul 2008 21:13:04.0126 (UTC) FILETIME=[BF5F29E0:01C8DE1A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
 arch/x86/kernel/cpu/mcheck/mce_64.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -433,6 +433,7 @@ static __init int periodic_mcheck_init(v
 }
 __initcall(periodic_mcheck_init);
 
+static int dont_init_bank0;
 
 /*
  * Initialize Machine Checks for a CPU.
@@ -462,7 +463,8 @@ static void mce_init(void *dummy)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 
 	for (i = 0; i < banks; i++) {
-		wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
+		if (!(i == 0 && dont_init_bank0))
+			wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
 }
@@ -481,6 +483,18 @@ static void __cpuinit mce_cpu_quirks(str
 			   by default and leave crap in there. Don't log. */
 			mce_bootlog = 0;
 	}
+	if (c->x86_vendor == X86_VENDOR_INTEL) {
+		/*
+		 * SDM documents that on family 6 bank 0 should not be written
+		 * because it aliases to another special BIOS controlled
+		 * register.
+		 * But it's not aliased anymore on model 0x1a+
+		 * Don't ignore bank 0 completely because there could be a valid
+		 * event later, merely don't write CTL0.
+		 */
+		if (c->x86 == 6 && c->x86_model < 0x1A)
+			dont_init_bank0 = 1;
+	}
 
 }
 
