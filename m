Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYGOVPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYGOVPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYGOVOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:14:33 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33412 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755192AbYGOVOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:14:30 -0400
Message-Id: <20080715211429.899795000@polaris-admin.engr.sgi.com>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 14:14:32 -0700
From: Mike Travis <travis@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] cpumask: Optimize cpumask_of_cpu in arch/x86/kernel/ldt.c
Content-Disposition: inline; filename=optimize-cpu_mask_of_cpu-in-arch_x86_kernel_ldt_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Optimize various places where a pointer to the cpumask_of_cpu value
    will result in reducing stack pressure.

Based on linux-2.6.tip/master at the following commit:

    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
    Merge: 9a635fa... 724dce0...
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Tue Jul 15 14:55:17 2008 +0200

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/ldt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/ldt.c
+++ linux-2.6.tip/arch/x86/kernel/ldt.c
@@ -62,12 +62,12 @@ static int alloc_ldt(mm_context_t *pc, i
 
 	if (reload) {
 #ifdef CONFIG_SMP
-		cpumask_t mask;
+		cpumask_of_cpu_ptr_declare(mask);
 
 		preempt_disable();
 		load_LDT(pc);
-		mask = cpumask_of_cpu(smp_processor_id());
-		if (!cpus_equal(current->mm->cpu_vm_mask, mask))
+		cpumask_of_cpu_ptr_next(mask, smp_processor_id());
+		if (!cpus_equal(current->mm->cpu_vm_mask, *mask))
 			smp_call_function(flush_ldt, current->mm, 1);
 		preempt_enable();
 #else

-- 
