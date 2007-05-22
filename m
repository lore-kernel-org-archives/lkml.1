Return-Path: <linux-kernel-owner+w=401wt.eu-S934753AbXEVPTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753AbXEVPTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759237AbXEVPTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:07 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4933
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757702AbXEVPTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:06 -0400
Message-Id: <20070522141251.160703868@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:45 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 04/33] xen: paravirt: unstatic leave_mm
Content-Disposition: inline; filename=paravirt-unstatic-leave_mm.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make globally leave_mm visible, specifically so that Xen can use it to
shoot-down lazy uses of cr3.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/smp.c         |    5 +++--
 include/asm-i386/mmu_context.h |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

===================================================================
--- a/include/asm-i386/mmu_context.h
+++ b/include/asm-i386/mmu_context.h
@@ -31,6 +31,8 @@ static inline void enter_lazy_tlb(struct
 		per_cpu(cpu_tlbstate, cpu).state = TLBSTATE_LAZY;
 #endif
 }
+
+void leave_mm (unsigned long cpu);
 
 static inline void switch_mm(struct mm_struct *prev,
 			     struct mm_struct *next,
===================================================================
--- a/arch/i386/kernel/smp.c
+++ b/arch/i386/kernel/smp.c
@@ -22,6 +22,7 @@
 
 #include <asm/mtrr.h>
 #include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
 #include <mach_apic.h>
 
 /*
@@ -249,13 +250,13 @@ static DEFINE_SPINLOCK(tlbstate_lock);
 static DEFINE_SPINLOCK(tlbstate_lock);
 
 /*
- * We cannot call mmdrop() because we are in interrupt context, 
+ * We cannot call mmdrop() because we are in interrupt context,
  * instead update mm->cpu_vm_mask.
  *
  * We need to reload %cr3 since the page tables may be going
  * away from under us..
  */
-static inline void leave_mm (unsigned long cpu)
+void leave_mm (unsigned long cpu)
 {
 	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
 		BUG();

-- 

