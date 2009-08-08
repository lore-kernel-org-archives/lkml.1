Return-Path: <linux-kernel-owner+w=401wt.eu-S932395AbZHHC1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbZHHC1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 22:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757662AbZHHC1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 22:27:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:5560 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbZHHC0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 22:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YmIauXK9SRICLoiubqtnr13NFIbNF4+Q3HT0il+zerBXuVwQRklsN++XaSaAGNwoqB
         a77CaaM5sk+2Mpyvt8FcV/+vlYQ5cuhAqA2p9Un8UhAobJnvukZVd/1B9p7en7zuz+cK
         LE/zjsDYDulvURPPsucKNWH7Uzw3rogaCQBRs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/3] perfcounter: Generalize the tracepoint sampling to generic sampling
Date: Sat,  8 Aug 2009 04:26:37 +0200
Message-Id: <1249698400-5441-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename:

- PERF_SAMPLE_TP_RECORD to PERF_SAMPLE_RAW
- struct perf_tracepoint_record to perf_raw_record

We want the system in place that transport tracepoints raw samples
events into the perf ring buffer to be generalized and usable by any
type of counter.

Reported-by; Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/linux/perf_counter.h |   10 +++++-----
 kernel/perf_counter.c        |   20 ++++++++++----------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index c484834..0a6f320 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -121,7 +121,7 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_CPU				= 1U << 7,
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
-	PERF_SAMPLE_TP_RECORD			= 1U << 10,
+	PERF_SAMPLE_RAW				= 1U << 10,
 
 	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
 };
@@ -414,9 +414,9 @@ struct perf_callchain_entry {
 	__u64				ip[PERF_MAX_STACK_DEPTH];
 };
 
-struct perf_tracepoint_record {
-	int				size;
-	char				*record;
+struct perf_raw_record {
+	u32				size;
+	void				*data;
 };
 
 struct task_struct;
@@ -687,7 +687,7 @@ struct perf_sample_data {
 	struct pt_regs			*regs;
 	u64				addr;
 	u64				period;
-	void				*private;
+	struct perf_raw_record		*raw;
 };
 
 extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index a6963e2..22e2839 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2647,7 +2647,7 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
 		u64 counter;
 	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
-	struct perf_tracepoint_record *tp = NULL;
+	struct perf_raw_record *raw = NULL;
 	int callchain_size = 0;
 	u64 time;
 	struct {
@@ -2716,10 +2716,10 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
 			header.size += sizeof(u64);
 	}
 
-	if (sample_type & PERF_SAMPLE_TP_RECORD) {
-		tp = data->private;
-		if (tp)
-			header.size += tp->size;
+	if (sample_type & PERF_SAMPLE_RAW) {
+		raw = data->raw;
+		if (raw)
+			header.size += raw->size;
 	}
 
 	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
@@ -2785,8 +2785,8 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
 		}
 	}
 
-	if ((sample_type & PERF_SAMPLE_TP_RECORD) && tp)
-		perf_output_copy(&handle, tp->record, tp->size);
+	if ((sample_type & PERF_SAMPLE_RAW) && raw)
+		perf_output_copy(&handle, raw->data, raw->size);
 
 	perf_output_end(&handle);
 }
@@ -3741,15 +3741,15 @@ static const struct pmu perf_ops_task_clock = {
 void perf_tpcounter_event(int event_id, u64 addr, u64 count, void *record,
 			  int entry_size)
 {
-	struct perf_tracepoint_record tp = {
+	struct perf_raw_record raw = {
 		.size = entry_size,
-		.record = record,
+		.data = record,
 	};
 
 	struct perf_sample_data data = {
 		.regs = get_irq_regs(),
 		.addr = addr,
-		.private = &tp,
+		.raw = &raw,
 	};
 
 	if (!data.regs)
-- 
1.6.2.3

