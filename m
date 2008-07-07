Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYGGXKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYGGXKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbYGGXKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:10:10 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:20250 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbYGGXKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:10:08 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080708110.487722491@firstfloor.org>
In-Reply-To: <20080708110.487722491@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/10] MCE: Implement the PPro bank 0 quirk in the 64bit machine check code
Message-Id: <20080707231004.8C6AE1B4315@basil.firstfloor.org>
Date: Tue,  8 Jul 2008 01:10:04 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 23:02:40.0448 (UTC) FILETIME=[8E678400:01C8E085]
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
 
