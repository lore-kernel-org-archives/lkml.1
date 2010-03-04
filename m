Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0CDOB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:01:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54134 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0CDOBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:01:55 -0500
Message-Id: <20100304140100.847218224@chello.nl>
References: <20100304140046.596569763@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 04 Mar 2010 15:00:58 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 12/14] perf, x86: Expose the full PEBS record using PERF_SAMPLE_RAW
Content-Disposition: inline; filename=perf-pebs-raw.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose the full PEBS record using PERF_SAMPLE_RAW

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -457,6 +457,7 @@ static void intel_pmu_drain_pebs_core(st
 	struct perf_event *event = cpuc->events[0]; /* PMC0 only */
 	struct pebs_record_core *at, *top;
 	struct perf_sample_data data;
+	struct perf_raw_record raw;
 	struct pt_regs regs;
 	int n;
 
@@ -490,6 +491,12 @@ static void intel_pmu_drain_pebs_core(st
 		at += n-1;
 	}
 
+	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
+		raw.size = x86_pmu.pebs_record_size;
+		raw.data = at;
+		data.raw = &raw;
+	}
+
 	/*
 	 * We use the interrupt regs as a base because the PEBS record
 	 * does not contain a full regs set, specifically it seems to
@@ -524,6 +531,7 @@ static void intel_pmu_drain_pebs_nhm(str
 	struct pebs_record_nhm *at, *top;
 	struct perf_sample_data data;
 	struct perf_event *event = NULL;
+	struct perf_raw_record raw;
 	struct pt_regs regs;
 	int bit, n;
 
@@ -572,6 +580,12 @@ static void intel_pmu_drain_pebs_nhm(str
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

-- 

