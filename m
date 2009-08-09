Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZHILLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZHILLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZHILLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:11:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:43867 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbZHILLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:11:15 -0400
Date: Sun, 9 Aug 2009 11:10:39 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249698400-5441-4-git-send-email-fweisbec@gmail.com>
References: <1249698400-5441-4-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf_counter: Fix tracepoint sampling to be part of generic sampling
Message-ID: <tip-3a43ce68ae1758fa6a839386025ef45acb6baa22@git.kernel.org>
Git-Commit-ID: 3a43ce68ae1758fa6a839386025ef45acb6baa22
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Aug 2009 11:10:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a43ce68ae1758fa6a839386025ef45acb6baa22
Gitweb:     http://git.kernel.org/tip/3a43ce68ae1758fa6a839386025ef45acb6baa22
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 8 Aug 2009 04:26:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 9 Aug 2009 12:54:45 +0200

perf_counter: Fix tracepoint sampling to be part of generic sampling

Based on Peter's comments, make tracepoint sampling generic
just like all the other sampling bits are. This is a rename
with no code changes:

- PERF_SAMPLE_TP_RECORD to PERF_SAMPLE_RAW
- struct perf_tracepoint_record to perf_raw_record

We want the system in place that transport tracepoints raw
samples events into the perf ring buffer to be generalized and
usable by any type of counter.

Reported-by; Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1249698400-5441-4-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   10 +++++-----
 kernel/perf_counter.c        |   20 ++++++++++----------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index a67dd5c..2aabe43 100644
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
index 117622c..0023105 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2646,7 +2646,7 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		u64 counter;
 	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
-	struct perf_tracepoint_record *tp = NULL;
+	struct perf_raw_record *raw = NULL;
 	int callchain_size = 0;
 	u64 time;
 	struct {
@@ -2715,10 +2715,10 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
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
@@ -2784,8 +2784,8 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		}
 	}
 
-	if ((sample_type & PERF_SAMPLE_TP_RECORD) && tp)
-		perf_output_copy(&handle, tp->record, tp->size);
+	if ((sample_type & PERF_SAMPLE_RAW) && raw)
+		perf_output_copy(&handle, raw->data, raw->size);
 
 	perf_output_end(&handle);
 }
@@ -3740,15 +3740,15 @@ static const struct pmu perf_ops_task_clock = {
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
