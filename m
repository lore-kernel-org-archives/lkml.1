Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbYDVPat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbYDVPat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYDVPag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:30:36 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16318 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbYDVPaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:30:35 -0400
Message-Id: <480E20C4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Tue, 22 Apr 2008 16:30:44 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: avoid re-loading LDT in unrelated address spaces
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/ldt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.25/arch/x86/kernel/ldt.c	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.25-x86-filter-load-ldt/arch/x86/kernel/ldt.c	2008-03-04 10:31:12.000000000 +0100
@@ -20,9 +20,9 @@
 #include <asm/mmu_context.h>
 
 #ifdef CONFIG_SMP
-static void flush_ldt(void *null)
+static void flush_ldt(void *current_mm)
 {
-	if (current->active_mm)
+	if (current->active_mm == current_mm)
 		load_LDT(&current->active_mm->context);
 }
 #endif
@@ -68,7 +68,7 @@ static int alloc_ldt(mm_context_t *pc, i
 		load_LDT(pc);
 		mask = cpumask_of_cpu(smp_processor_id());
 		if (!cpus_equal(current->mm->cpu_vm_mask, mask))
-			smp_call_function(flush_ldt, NULL, 1, 1);
+			smp_call_function(flush_ldt, current->mm, 1, 1);
 		preempt_enable();
 #else
 		load_LDT(pc);



