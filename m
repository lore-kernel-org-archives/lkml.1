Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYAHWUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYAHWUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYAHWUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:20:34 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:42343
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752817AbYAHWUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:20:33 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 02 of 10] x86: avoid name conflict for Voyager leave_mm
X-Mercurial-Node: 2cd20aa5a4797f6d7285de54b4b759e7d6ae5443
Message-Id: <2cd20aa5a4797f6d7285.1199829605@localhost>
In-Reply-To: <patchbomb.1199829603@localhost>
Date: Tue, 08 Jan 2008 14:00:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid a conflict between Voyager's leave_mm and asm-x86/mmu.h's leave_mm.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86/mach-voyager/voyager_smp.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -808,7 +808,7 @@ static DEFINE_SPINLOCK(tlbstate_lock);
  * We need to reload %cr3 since the page tables may be going
  * away from under us..
  */
-static inline void leave_mm(unsigned long cpu)
+static inline void voyager_leave_mm(unsigned long cpu)
 {
 	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_OK)
 		BUG();
@@ -838,7 +838,7 @@ static void smp_invalidate_interrupt(voi
 			else
 				__flush_tlb_one(flush_va);
 		} else
-			leave_mm(cpu);
+			voyager_leave_mm(cpu);
 	}
 	smp_mb__before_clear_bit();
 	clear_bit(cpu, &smp_invalidate_needed);
@@ -919,7 +919,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 		if (current->mm)
 			local_flush_tlb();
 		else
-			leave_mm(smp_processor_id());
+			voyager_leave_mm(smp_processor_id());
 	}
 	if (cpu_mask)
 		voyager_flush_tlb_others(cpu_mask, mm, TLB_FLUSH_ALL);
@@ -939,7 +939,7 @@ void flush_tlb_page(struct vm_area_struc
 		if (current->mm)
 			__flush_tlb_one(va);
 		else
-			leave_mm(smp_processor_id());
+			voyager_leave_mm(smp_processor_id());
 	}
 
 	if (cpu_mask)
@@ -1155,7 +1155,7 @@ static void do_flush_tlb_all(void *info)
 
 	__flush_tlb_all();
 	if (per_cpu(cpu_tlbstate, cpu).state == TLBSTATE_LAZY)
-		leave_mm(cpu);
+		voyager_leave_mm(cpu);
 }
 
 /* flush the TLB of every active CPU in the system */


