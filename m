Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0CCQtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:49:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0CCQpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:45:23 -0500
Message-Id: <20100303164306.375353163@chello.nl>
References: <20100303163936.906011640@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 03 Mar 2010 17:39:43 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: paulus@samba.org, eranian@google.com, robert.richter@amd.com,
       fweisbec@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
Content-Disposition: inline; filename=perf-sample-regs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply copy out the provided pt_regs in a u64 aligned fashion.

XXX: do task_pt_regs() and get_irq_regs() always clear everything or
     are we now leaking data?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    5 ++++-
 kernel/perf_event.c        |   17 +++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -125,8 +125,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_RAW				= 1U << 10,
+	PERF_SAMPLE_REGS			= 1U << 11,
 
-	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
 };
 
 /*
@@ -392,6 +393,7 @@ enum perf_event_type {
 	 *	{ u64			period;   } && PERF_SAMPLE_PERIOD
 	 *
 	 *	{ struct read_format	values;	  } && PERF_SAMPLE_READ
+	 * 	{ struct pt_regs	regs;	  } && PERF_SAMPLE_REGS
 	 *
 	 *	{ u64			nr,
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
@@ -800,6 +802,7 @@ struct perf_sample_data {
 	u64				period;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
+	struct pt_regs			*regs;
 };
 
 static inline
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -3176,6 +3176,17 @@ void perf_output_sample(struct perf_outp
 	if (sample_type & PERF_SAMPLE_READ)
 		perf_output_read(handle, event);
 
+	if (sample_type & PERF_SAMPLE_REGS) {
+		int size = DIV_ROUND_UP(sizeof(struct pt_regs), sizeof(u64)) -
+			   sizeof(struct pt_regs);
+
+		perf_output_put(handle, *data->regs);
+		if (size) {
+			u64 zero = 0;
+			perf_output_copy(handle, &zero, size);
+		}
+	}
+
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		if (data->callchain) {
 			int size = 1;
@@ -3273,6 +3284,12 @@ void perf_prepare_sample(struct perf_eve
 	if (sample_type & PERF_SAMPLE_READ)
 		header->size += perf_event_read_size(event);
 
+	if (sample_type & PERF_SAMPLE_REGS) {
+		data->regs = regs;
+		header->size += DIV_ROUND_UP(sizeof(struct pt_regs),
+					     sizeof(u64));
+	}
+
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int size = 1;
 

-- 

