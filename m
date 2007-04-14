Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbXDNVYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbXDNVYG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbXDNVVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:50 -0400
Received: from gw.goop.org ([64.81.55.164]:59547 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbXDNVUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:18 -0400
Message-Id: <20070414204924.649790791@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
Subject: [PATCH 17/28] x86: cleanup arch/i386/kernel/cpu/mcheck/p4.c
Content-Disposition: inline; filename=i386-mcheck-p4-grotesque-and-needless-warning-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No, just no.  You do not use goto to skip a code block.  You do not
return an obvious variable from a singly-inlined function and give
the function a return value.  You don't put unexplained comments
about kmalloc in code which doesn't do dynamic allocation.  And
you don't leave stray warnings around for no good reason.

Also, when possible, it is better to use block scoped variables
because gcc can sometime generate better code.

From: Zachary Amsden <zach@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/cpu/mcheck/p4.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

===================================================================
--- a/arch/i386/kernel/cpu/mcheck/p4.c
+++ b/arch/i386/kernel/cpu/mcheck/p4.c
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

-- 

