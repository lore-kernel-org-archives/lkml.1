Return-Path: <linux-kernel-owner+w=401wt.eu-S965565AbXD3Kao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565AbXD3Kao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbXD3K3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:25 -0400
Received: from ns2.suse.de ([195.135.220.15]:43029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965397AbXD3K2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:10 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [34/40] i386: Clean up arch/i386/kernel/cpu/mcheck/p4.c
Message-Id: <20070430102809.25C8A151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>

No, just no.  You do not use goto to skip a code block.  You do not
return an obvious variable from a singly-inlined function and give
the function a return value.  You don't put unexplained comments
about kmalloc in code which doesn't do dynamic allocation.  And
you don't leave stray warnings around for no good reason.

Also, when possible, it is better to use block scoped variables
because gcc can sometime generate better code.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/mcheck/p4.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/cpu/mcheck/p4.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/p4.c
+++ linux/arch/i386/kernel/cpu/mcheck/p4.c
@@ -124,13 +124,10 @@ static void intel_init_thermal(struct cp
 
 
 /* P4/Xeon Extended MCE MSR retrieval, return 0 if unsupported */
-static inline int intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
+static inline void intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
 {
 	u32 h;
 
-	if (mce_num_extended_msrs == 0)
-		goto done;
-
 	rdmsr (MSR_IA32_MCG_EAX, r->eax, h);
 	rdmsr (MSR_IA32_MCG_EBX, r->ebx, h);
 	rdmsr (MSR_IA32_MCG_ECX, r->ecx, h);
@@ -141,12 +138,6 @@ static inline int intel_get_extended_msr
 	rdmsr (MSR_IA32_MCG_ESP, r->esp, h);
 	rdmsr (MSR_IA32_MCG_EFLAGS, r->eflags, h);
 	rdmsr (MSR_IA32_MCG_EIP, r->eip, h);
-
-	/* can we rely on kmalloc to do a dynamic
-	 * allocation for the reserved registers?
-	 */
-done:
-	return mce_num_extended_msrs;
 }
 
 static fastcall void intel_machine_check(struct pt_regs * regs, long error_code)
@@ -155,7 +146,6 @@ static fastcall void intel_machine_check
 	u32 alow, ahigh, high, low;
 	u32 mcgstl, mcgsth;
 	int i;
-	struct intel_mce_extended_msrs dbg;
 
 	rdmsr (MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
 	if (mcgstl & (1<<0))	/* Recoverable ? */
@@ -164,7 +154,9 @@ static fastcall void intel_machine_check
 	printk (KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
 		smp_processor_id(), mcgsth, mcgstl);
 
-	if (intel_get_extended_msrs(&dbg)) {
+	if (mce_num_extended_msrs > 0) {
+		struct intel_mce_extended_msrs dbg;
+		intel_get_extended_msrs(&dbg);
 		printk (KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n",
 			smp_processor_id(), dbg.eip, dbg.eflags);
 		printk (KERN_DEBUG "\teax: %08x ebx: %08x ecx: %08x edx: %08x\n",
