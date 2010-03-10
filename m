Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0CJNWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:22:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:57558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab0CJNWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:22:00 -0500
Date: Wed, 10 Mar 2010 13:21:45 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100305154129.042271287@chello.nl>
References: <20100305154129.042271287@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Robustify PEBS fixup
Message-ID: <tip-a562b1871f7f7d2f3a835c3c1e07fa58d473cfb7@git.kernel.org>
Git-Commit-ID: a562b1871f7f7d2f3a835c3c1e07fa58d473cfb7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:21:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a562b1871f7f7d2f3a835c3c1e07fa58d473cfb7
Gitweb:     http://git.kernel.org/tip/a562b1871f7f7d2f3a835c3c1e07fa58d473cfb7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Mar 2010 16:29:14 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:35 +0100

perf, x86: Robustify PEBS fixup

It turns out the LBR is massively unreliable on certain CPUs, so code the
fixup a little more defensive to avoid crashing the kernel.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <20100305154129.042271287@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index a67fff1..e7ac517 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -399,10 +399,23 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
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
@@ -420,7 +433,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 
 		old_to = to;
 		if (!kernel_ip(ip)) {
-			int bytes, size = min_t(int, MAX_INSN_SIZE, ip - to);
+			int bytes, size = MAX_INSN_SIZE;
 
 			bytes = copy_from_user_nmi(buf, (void __user *)to, size);
 			if (bytes != size)
@@ -440,6 +453,10 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
 		return 1;
 	}
 
+	/*
+	 * Even though we decoded the basic block, the instruction stream
+	 * never matched the given IP, either the TO or the IP got corrupted.
+	 */
 	return 0;
 }
 
