Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0CEPnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:43:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57548 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab0CEPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:43:17 -0500
Message-Id: <20100305154129.042271287@chello.nl>
References: <20100305153926.639506880@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 05 Mar 2010 16:39:31 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/5] perf, x86: Robustify PEBS fixup
Content-Disposition: inline; filename=pebs-robustify-fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out the LBR is massively unreliable on certain CPUs, so code
the fixup a little more defensive to avoid crashing the kernel.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -399,10 +399,23 @@ static int intel_pmu_pebs_fixup_ip(struc
 	if (!x86_pmu.intel_cap.pebs_trap)
 		return 1;
 
+	/*
+	 * No LBR entry, no basic block, no rewinding
+	 */
 	if (!cpuc->lbr_stack.nr || !from || !to)
 		return 0;
 
-	if (ip < to)
+	/*
+	 * Basic blocks should never cross user/kernel boundaries
+	 */
+	if (kernel_ip(ip) != kernel_ip(to))
+		return 0;
+
+	/*
+	 * unsigned math, either ip is before the start (impossible) or
+	 * the basic block is larger than 1 page (sanity)
+	 */
+	if ((ip - to) > PAGE_SIZE)
 		return 0;
 
 	/*
@@ -420,7 +433,7 @@ static int intel_pmu_pebs_fixup_ip(struc
 
 		old_to = to;
 		if (!kernel_ip(ip)) {
-			int bytes, size = min_t(int, MAX_INSN_SIZE, ip - to);
+			int bytes, size = MAX_INSN_SIZE;
 
 			bytes = copy_from_user_nmi(buf, (void __user *)to, size);
 			if (bytes != size)
@@ -440,6 +453,10 @@ static int intel_pmu_pebs_fixup_ip(struc
 		return 1;
 	}
 
+	/*
+	 * Even though we decoded the basic block, the instruction stream
+	 * never matched the given IP, either the TO or the IP got corrupted.
+	 */
 	return 0;
 }
 

-- 

