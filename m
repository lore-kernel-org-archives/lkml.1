Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbYGIQzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbYGIQzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbYGIQvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:39 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53197 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751934AbYGIQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:31 -0400
Message-Id: <20080709165130.417042000@polaris-admin.engr.sgi.com>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 09:51:37 -0700
From: Mike Travis <travis@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [RFC 08/15] x86_64: Replace xxx_pda() operations in include_asm-x86_mmu_context_64_h
Content-Disposition: inline; filename=incl_pda_ops_include_asm-x86_mmu_context_64_h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * It is now possible to use percpu operations for pda access
    since the pda is in the percpu area. Drop the pda operations.

    Thus:

	read_pda     --> x86_read_percpu
	write_pda    --> x86_write_percpu
	add_pda (+1) --> x86_inc_percpu
	or_pda       --> x86_or_percpu

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/mmu_context_64.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.tip.orig/include/asm-x86/mmu_context_64.h	2008-07-01 10:41:33.000000000 -0700
+++ linux-2.6.tip/include/asm-x86/mmu_context_64.h	2008-07-01 10:49:14.220312889 -0700
@@ -20,8 +20,8 @@ void destroy_context(struct mm_struct *m
 static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
 {
 #ifdef CONFIG_SMP
-	if (read_pda(mmu_state) == TLBSTATE_OK)
-		write_pda(mmu_state, TLBSTATE_LAZY);
+	if (x86_read_percpu(pda.mmu_state) == TLBSTATE_OK)
+		x86_write_percpu(pda.mmu_state, TLBSTATE_LAZY);
 #endif
 }
 
@@ -33,8 +33,8 @@ static inline void switch_mm(struct mm_s
 		/* stop flush ipis for the previous mm */
 		cpu_clear(cpu, prev->cpu_vm_mask);
 #ifdef CONFIG_SMP
-		write_pda(mmu_state, TLBSTATE_OK);
-		write_pda(active_mm, next);
+		x86_write_percpu(pda.mmu_state, TLBSTATE_OK);
+		x86_write_percpu(pda.active_mm, next);
 #endif
 		cpu_set(cpu, next->cpu_vm_mask);
 		load_cr3(next->pgd);
@@ -44,8 +44,8 @@ static inline void switch_mm(struct mm_s
 	}
 #ifdef CONFIG_SMP
 	else {
-		write_pda(mmu_state, TLBSTATE_OK);
-		if (read_pda(active_mm) != next)
+		x86_write_percpu(pda.mmu_state, TLBSTATE_OK);
+		if (x86_read_percpu(pda.active_mm) != next)
 			BUG();
 		if (!cpu_test_and_set(cpu, next->cpu_vm_mask)) {
 			/* We were in lazy tlb mode and leave_mm disabled

-- 
