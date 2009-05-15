Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbZEOIp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbZEOIp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbZEOInY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:43:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:57171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759493AbZEOInW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:43:22 -0400
Date: Fri, 15 May 2009 08:42:42 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: x86: Fix throttling
Message-ID: <tip-f5a5a2f6e69e88647ae12da39f0ff3a510bcf0a6@git.kernel.org>
Git-Commit-ID: f5a5a2f6e69e88647ae12da39f0ff3a510bcf0a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 08:42:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5a5a2f6e69e88647ae12da39f0ff3a510bcf0a6
Gitweb:     http://git.kernel.org/tip/f5a5a2f6e69e88647ae12da39f0ff3a510bcf0a6
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 13 May 2009 12:54:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 09:46:56 +0200

perf_counter: x86: Fix throttling

If counters are disabled globally when a perfcounter IRQ/NMI hits,
and if we throttle in that case, we'll promote the '0' value to
the next lapic IRQ and disable all perfcounters at that point,
permanently ...

Fix it.

[ Impact: fix hung perfcounters under load ]

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 3a92a2b..88ae8ce 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -765,8 +765,13 @@ out:
 	/*
 	 * Restore - do not reenable when global enable is off or throttled:
 	 */
-	if (++cpuc->interrupts < PERFMON_MAX_INTERRUPTS)
-		intel_pmu_restore_all(cpuc->throttle_ctrl);
+	if (cpuc->throttle_ctrl) {
+		if (++cpuc->interrupts < PERFMON_MAX_INTERRUPTS) {
+			intel_pmu_restore_all(cpuc->throttle_ctrl);
+		} else {
+			pr_info("CPU#%d: perfcounters: max interrupt rate exceeded! Throttle on.\n", smp_processor_id());
+		}
+	}
 
 	return ret;
 }
@@ -817,11 +822,16 @@ void perf_counter_unthrottle(void)
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
 	if (cpuc->interrupts >= PERFMON_MAX_INTERRUPTS) {
-		if (printk_ratelimit())
-			printk(KERN_WARNING "perfcounters: max interrupts exceeded!\n");
+		pr_info("CPU#%d: perfcounters: throttle off.\n", smp_processor_id());
+
+		/*
+		 * Clear them before re-enabling irqs/NMIs again:
+		 */
+		cpuc->interrupts = 0;
 		hw_perf_restore(cpuc->throttle_ctrl);
+	} else {
+		cpuc->interrupts = 0;
 	}
-	cpuc->interrupts = 0;
 }
 
 void smp_perf_counter_interrupt(struct pt_regs *regs)
