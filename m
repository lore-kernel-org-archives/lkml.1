Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0CJNZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:25:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:53668 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab0CJNZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:25:19 -0500
Date: Wed, 10 Mar 2010 13:24:32 GMT
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
Subject: [tip:perf/pebs] perf, x86: Fixup the PEBS handler for Core2 cpus
Message-ID: <tip-d80c7502ff63aa0d99d8c0c5803d28bbef67a74e@git.kernel.org>
Git-Commit-ID: d80c7502ff63aa0d99d8c0c5803d28bbef67a74e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:24:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d80c7502ff63aa0d99d8c0c5803d28bbef67a74e
Gitweb:     http://git.kernel.org/tip/d80c7502ff63aa0d99d8c0c5803d28bbef67a74e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 9 Mar 2010 11:41:02 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:39 +0100

perf, x86: Fixup the PEBS handler for Core2 cpus

Pull the core handler in line with the nhm one, also make sure we always
drain the buffer.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   38 ++++++++++++++++++----------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 2423694..1bfd59b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -472,20 +472,39 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	struct pt_regs regs;
 	int n;
 
-	if (!event || !ds || !x86_pmu.pebs)
+	if (!ds || !x86_pmu.pebs)
 		return;
 
 	at  = (struct pebs_record_core *)(unsigned long)ds->pebs_buffer_base;
 	top = (struct pebs_record_core *)(unsigned long)ds->pebs_index;
 
-	if (top <= at)
+	/*
+	 * Whatever else happens, drain the thing
+	 */
+	ds->pebs_index = ds->pebs_buffer_base;
+
+	if (!test_bit(0, cpuc->active_mask))
 		return;
 
-	ds->pebs_index = ds->pebs_buffer_base;
+	WARN_ON_ONCE(!event);
+
+	if (!event->attr.precise)
+		return;
+
+	n = top - at;
+	if (n <= 0)
+		return;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
 
+	/*
+	 * Should not happen, we program the threshold at 1 and do not
+	 * set a reset value.
+	 */
+	WARN_ON_ONCE(n > 1);
+	at += n - 1;
+
 	perf_sample_data_init(&data, 0);
 	data.period = event->hw.last_period;
 
@@ -495,14 +514,6 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 		data.raw = &raw;
 	}
 
-	n = top - at;
-
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ON_ONCE(n > 1);
-
 	/*
 	 * We use the interrupt regs as a base because the PEBS record
 	 * does not contain a full regs set, specifically it seems to
@@ -545,12 +556,11 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
 	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
 
-	if (top <= at)
-		return;
-
 	ds->pebs_index = ds->pebs_buffer_base;
 
 	n = top - at;
+	if (n <= 0)
+		return;
 
 	/*
 	 * Should not happen, we program the threshold at 1 and do not
