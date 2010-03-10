Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab0CJNLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:11:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:59033 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab0CJNLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:11:25 -0500
Date: Wed, 10 Mar 2010 13:10:38 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86, Do not user perf_disable from NMI context
Message-ID: <tip-3fb2b8ddcc6a7aa62af6bd2cb939edfd4c460506@git.kernel.org>
Git-Commit-ID: 3fb2b8ddcc6a7aa62af6bd2cb939edfd4c460506
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:10:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fb2b8ddcc6a7aa62af6bd2cb939edfd4c460506
Gitweb:     http://git.kernel.org/tip/3fb2b8ddcc6a7aa62af6bd2cb939edfd4c460506
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 8 Mar 2010 13:51:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:22:26 +0100

perf, x86, Do not user perf_disable from NMI context

Explicitly use intel_pmu_{disable,enable}_all() in intel_pmu_handle_irq()
to avoid the NMI race conditions in perf_{disable,enable}

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 12e811a..c582449 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -745,11 +745,11 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-	perf_disable();
+	intel_pmu_disable_all();
 	intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
 	if (!status) {
-		perf_enable();
+		intel_pmu_enable_all();
 		return 0;
 	}
 
@@ -759,8 +759,7 @@ again:
 		WARN_ONCE(1, "perfevents: irq loop stuck!\n");
 		perf_event_print_debug();
 		intel_pmu_reset();
-		perf_enable();
-		return 1;
+		goto done;
 	}
 
 	inc_irq_stat(apic_perf_irqs);
@@ -790,8 +789,8 @@ again:
 	if (status)
 		goto again;
 
-	perf_enable();
-
+done:
+	intel_pmu_enable_all();
 	return 1;
 }
 
