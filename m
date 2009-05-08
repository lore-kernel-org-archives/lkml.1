Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbZEHSTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbZEHSTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbZEHSSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:18:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37930 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbZEHSSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:18:05 -0400
Message-Id: <20090508170028.923228280@chello.nl>
References: <20090508165219.469818319@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 18:52:23 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/5] perf_counter: PERF_RECORD_CONFIG
Content-Disposition: inline; filename=perf_counter-config.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Much like CONFIG_RECORD_GROUP records the hw_event.config to identify the
values, allow to record this for all counters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |    8 ++++++++
 2 files changed, 10 insertions(+)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -104,6 +104,7 @@ enum perf_counter_record_format {
 	PERF_RECORD_ADDR	= 1U << 3,
 	PERF_RECORD_GROUP	= 1U << 4,
 	PERF_RECORD_CALLCHAIN	= 1U << 5,
+	PERF_RECORD_CONFIG	= 1U << 6,
 };
 
 /*
@@ -258,6 +259,7 @@ enum perf_event_type {
 	 * 	{ u32			pid, tid; } && PERF_RECORD_TID
 	 * 	{ u64			time;     } && PERF_RECORD_TIME
 	 * 	{ u64			addr;     } && PERF_RECORD_ADDR
+	 * 	{ u64			config;   } && PERF_RECORD_CONFIG
 	 *
 	 * 	{ u64			nr;
 	 * 	  { u64 event, val; } 	cnt[nr];  } && PERF_RECORD_GROUP
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1992,6 +1992,11 @@ static void perf_counter_output(struct p
 		header.size += sizeof(u64);
 	}
 
+	if (record_type & PERF_RECORD_CONFIG) {
+		header.type |= PERF_RECORD_CONFIG;
+		header.size += sizeof(u64);
+	}
+
 	if (record_type & PERF_RECORD_GROUP) {
 		header.type |= PERF_RECORD_GROUP;
 		header.size += sizeof(u64) +
@@ -2027,6 +2032,9 @@ static void perf_counter_output(struct p
 	if (record_type & PERF_RECORD_ADDR)
 		perf_output_put(&handle, addr);
 
+	if (record_type & PERF_RECORD_CONFIG)
+		perf_output_put(&handle, counter->hw_event.config);
+
 	/*
 	 * XXX PERF_RECORD_GROUP vs inherited counters seems difficult.
 	 */

-- 

