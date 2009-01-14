Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbZANCnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbZANCnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZANCnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:43:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:7835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbZANCnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:43:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,261,1231142400"; 
   d="scan'208";a="422184333"
Date: Tue, 13 Jan 2009 18:43:03 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: travis@sgi.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [patch] x86: fix broken flush_tlb_others_ipi()
Message-ID: <20090114024303.GB1290@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit broke flush_tlb_others_ipi() causing boot hangs on a
16 logical cpu system.

>	commit 4595f9620cda8a1e973588e743cf5f8436dd20c6
>	Author: Rusty Russell <rusty@rustcorp.com.au>
>	Date:   Sat Jan 10 21:58:09 2009 -0800
>
>	    x86: change flush_tlb_others to take a const struct cpumask

This change resulted in sending the invalidate tlb vector to the
sender itself causing the hang. flush_tlb_others_ipi() should exclude
the sender itself from the destination list.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index 2d971a3..53289e1 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -188,7 +188,7 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 	 * We have to send the IPI only to
 	 * CPUs affected.
 	 */
-	send_IPI_mask(cpumask, INVALIDATE_TLB_VECTOR_START + sender);
+	send_IPI_mask(f->flush_cpumask, INVALIDATE_TLB_VECTOR_START + sender);
 
 	while (!cpumask_empty(to_cpumask(f->flush_cpumask)))
 		cpu_relax();
