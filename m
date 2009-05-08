Return-Path: <linux-kernel-owner+w=401wt.eu-S1763126AbZEHSTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763126AbZEHSTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbZEHSSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:18:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37926 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510AbZEHSSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:18:04 -0400
Message-Id: <20090508170029.008627711@chello.nl>
References: <20090508165219.469818319@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 18:52:24 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/5] perf_counter: PERF_RECORD_CPU
Content-Disposition: inline; filename=perf_counter-cpu.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow recording the CPU number the event was generated on.

RFC: this leaves a u32 as reserved, should we fill in the node_id() there,
     or leave this open for future extention, as userspace can already easily
     do the cpu->node mapping if needed.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   13 +++++++++++++
 2 files changed, 15 insertions(+)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -105,6 +105,7 @@ enum perf_counter_record_format {
 	PERF_RECORD_GROUP	= 1U << 4,
 	PERF_RECORD_CALLCHAIN	= 1U << 5,
 	PERF_RECORD_CONFIG	= 1U << 6,
+	PERF_RECORD_CPU		= 1U << 7,
 };
 
 /*
@@ -260,6 +261,7 @@ enum perf_event_type {
 	 * 	{ u64			time;     } && PERF_RECORD_TIME
 	 * 	{ u64			addr;     } && PERF_RECORD_ADDR
 	 * 	{ u64			config;   } && PERF_RECORD_CONFIG
+	 * 	{ u32			cpu, res; } && PERF_RECORD_CPU
 	 *
 	 * 	{ u64			nr;
 	 * 	  { u64 event, val; } 	cnt[nr];  } && PERF_RECORD_GROUP
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1954,6 +1954,9 @@ static void perf_counter_output(struct p
 	struct perf_callchain_entry *callchain = NULL;
 	int callchain_size = 0;
 	u64 time;
+	struct {
+		u32 cpu, reserved;
+	} cpu_entry;
 
 	header.type = 0;
 	header.size = sizeof(header);
@@ -1997,6 +2000,13 @@ static void perf_counter_output(struct p
 		header.size += sizeof(u64);
 	}
 
+	if (record_type & PERF_RECORD_CPU) {
+		header.type |= PERF_RECORD_CPU;
+		header.size += sizeof(cpu_entry);
+
+		cpu_entry.cpu = raw_smp_processor_id();
+	}
+
 	if (record_type & PERF_RECORD_GROUP) {
 		header.type |= PERF_RECORD_GROUP;
 		header.size += sizeof(u64) +
@@ -2035,6 +2045,9 @@ static void perf_counter_output(struct p
 	if (record_type & PERF_RECORD_CONFIG)
 		perf_output_put(&handle, counter->hw_event.config);
 
+	if (record_type & PERF_RECORD_CPU)
+		perf_output_put(&handle, cpu_entry);
+
 	/*
 	 * XXX PERF_RECORD_GROUP vs inherited counters seems difficult.
 	 */

-- 

