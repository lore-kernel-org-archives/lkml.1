Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab0CJNXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:23:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:57617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411Ab0CJNXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:23:06 -0500
Date: Wed, 10 Mar 2010 13:22:18 GMT
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
Subject: [tip:perf/pebs] perf, x86: Fix pebs drains
Message-ID: <tip-8f4aebd2be9892bf8fb79a2d8576d3f3ee7f00f6@git.kernel.org>
Git-Commit-ID: 8f4aebd2be9892bf8fb79a2d8576d3f3ee7f00f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:22:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f4aebd2be9892bf8fb79a2d8576d3f3ee7f00f6
Gitweb:     http://git.kernel.org/tip/8f4aebd2be9892bf8fb79a2d8576d3f3ee7f00f6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 6 Mar 2010 13:26:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:36 +0100

perf, x86: Fix pebs drains

I overlooked the perf_disable()/perf_enable() calls in
intel_pmu_handle_irq(), (pointed out by Markus) so we should not
explicitly disable_all/enable_all pebs counters in the drain functions,
these are already disabled and enabling them early is confusing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index a7401e4..66c6962 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -476,18 +476,16 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	if (!event || !ds || !x86_pmu.pebs)
 		return;
 
-	intel_pmu_pebs_disable_all();
-
 	at  = (struct pebs_record_core *)(unsigned long)ds->pebs_buffer_base;
 	top = (struct pebs_record_core *)(unsigned long)ds->pebs_index;
 
 	if (top <= at)
-		goto out;
+		return;
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
 	if (!intel_pmu_save_and_restart(event))
-		goto out;
+		return;
 
 	perf_sample_data_init(&data, 0);
 	data.period = event->hw.last_period;
@@ -528,9 +526,6 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 
 	if (perf_event_overflow(event, 1, &data, &regs))
 		x86_pmu_stop(event);
-
-out:
-	intel_pmu_pebs_enable_all();
 }
 
 static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
@@ -547,13 +542,11 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	if (!ds || !x86_pmu.pebs)
 		return;
 
-	intel_pmu_pebs_disable_all();
-
 	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
 	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
 
 	if (top <= at)
-		goto out;
+		return;
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
@@ -604,8 +597,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 		if (perf_event_overflow(event, 1, &data, &regs))
 			x86_pmu_stop(event);
 	}
-out:
-	intel_pmu_pebs_enable_all();
 }
 
 /*
