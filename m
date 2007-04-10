Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbXDJALx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbXDJALx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932359AbXDJALQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:11:16 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53694 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753675AbXDJAIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:08:34 -0400
Date: Mon, 9 Apr 2007 17:06:08 -0700
Message-Id: <200704100006.l3A068Xk020608@zach-dev.vmware.com>
Subject: [PATCH 3/10] I386 mcheck p4 grotesque and needless warning fix.patch
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
X-OriginalArrivalTime: 10 Apr 2007 00:08:34.0298 (UTC) FILETIME=[6120E5A0:01C77B04]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No, just no.  You do not use goto to skip a code block.  You do not
return an obvious variable from a singly-inlined function and give
the function a return value.  You don't put unexplained comments
about kmalloc in code which doesn't do dynamic allocation.  And
you don't leave stray warnings around for no good reason.

Also, when possible, it is better to use block scoped variables
because gcc can sometime generate better code.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r ed741f57dae8 arch/i386/kernel/cpu/mcheck/p4.c
--- a/arch/i386/kernel/cpu/mcheck/p4.c	Fri Apr 06 14:29:52 2007 -0700
+++ b/arch/i386/kernel/cpu/mcheck/p4.c	Fri Apr 06 14:43:24 2007 -0700
@@ -124,12 +124,9 @@ static void intel_init_thermal(struct cp
 
 
 /* P4/Xeon Extended MCE MSR retrieval, return 0 if unsupported */
-static inline int intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
+static inline void intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
 {
 	u32 h;
-
-	if (mce_num_extended_msrs == 0)
-		goto done;
 
 	rdmsr (MSR_IA32_MCG_EAX, r->eax, h);
 	rdmsr (MSR_IA32_MCG_EBX, r->ebx, h);
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
