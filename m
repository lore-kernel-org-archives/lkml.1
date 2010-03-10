Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0CJNUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 08:20:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:57480 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab0CJNUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 08:20:51 -0500
Date: Wed, 10 Mar 2010 13:20:20 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       acme@infradead.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, acme@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100304140100.847218224@chello.nl>
References: <20100304140100.847218224@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/pebs] perf, x86: Expose the full PEBS record using PERF_SAMPLE_RAW
Message-ID: <tip-7e1a40dda619b0483fbe0740494ed2c2a1f05289@git.kernel.org>
Git-Commit-ID: 7e1a40dda619b0483fbe0740494ed2c2a1f05289
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Mar 2010 13:20:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e1a40dda619b0483fbe0740494ed2c2a1f05289
Gitweb:     http://git.kernel.org/tip/7e1a40dda619b0483fbe0740494ed2c2a1f05289
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 4 Mar 2010 12:38:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Mar 2010 13:23:33 +0100

perf, x86: Expose the full PEBS record using PERF_SAMPLE_RAW

Expose the full PEBS record using PERF_SAMPLE_RAW

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: paulus@samba.org
Cc: eranian@google.com
Cc: robert.richter@amd.com
Cc: fweisbec@gmail.com
LKML-Reference: <20100304140100.847218224@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 5e40294..ef56f05 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -457,6 +457,7 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	struct perf_event *event = cpuc->events[0]; /* PMC0 only */
 	struct pebs_record_core *at, *top;
 	struct perf_sample_data data;
+	struct perf_raw_record raw;
 	struct pt_regs regs;
 	int n;
 
@@ -479,6 +480,12 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	perf_sample_data_init(&data, 0);
 	data.period = event->hw.last_period;
 
+	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
+		raw.size = x86_pmu.pebs_record_size;
+		raw.data = at;
+		data.raw = &raw;
+	}
+
 	n = top - at;
 
 	/*
@@ -521,6 +528,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	struct pebs_record_nhm *at, *top;
 	struct perf_sample_data data;
 	struct perf_event *event = NULL;
+	struct perf_raw_record raw;
 	struct pt_regs regs;
 	int bit, n;
 
@@ -562,6 +570,12 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 		perf_sample_data_init(&data, 0);
 		data.period = event->hw.last_period;
 
+		if (event->attr.sample_type & PERF_SAMPLE_RAW) {
+			raw.size = x86_pmu.pebs_record_size;
+			raw.data = at;
+			data.raw = &raw;
+		}
+
 		/*
 		 * See the comment in intel_pmu_drain_pebs_core()
 		 */
