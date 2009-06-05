Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbZFEQ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbZFEQ6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZFEQ6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:58:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:60887 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbZFEQ63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:58:29 -0400
Date: Fri, 5 Jun 2009 16:57:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Add PERF_SAMPLE_PERIOD
Message-ID: <tip-689802b2d0536e72281dc959ab9cb34fb3c304cf@git.kernel.org>
Git-Commit-ID: 689802b2d0536e72281dc959ab9cb34fb3c304cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 16:57:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  689802b2d0536e72281dc959ab9cb34fb3c304cf
Gitweb:     http://git.kernel.org/tip/689802b2d0536e72281dc959ab9cb34fb3c304cf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Jun 2009 15:05:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 18:07:47 +0200

perf_counter: Add PERF_SAMPLE_PERIOD

In order to allow easy tracking of the period, also provide means of
adding it to the sample data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   10 ++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 9cea32a..6bc2500 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -106,6 +106,7 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_CALLCHAIN		= 1U << 5,
 	PERF_SAMPLE_ID			= 1U << 6,
 	PERF_SAMPLE_CPU			= 1U << 7,
+	PERF_SAMPLE_PERIOD		= 1U << 8,
 };
 
 /*
@@ -260,6 +261,7 @@ enum perf_event_type {
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *	u64				time;
+	 *	u64				id;
 	 *	u64				sample_period;
 	 * };
 	 */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index e75b91a..f839066 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2404,6 +2404,11 @@ static void perf_counter_output(struct perf_counter *counter,
 		cpu_entry.cpu = raw_smp_processor_id();
 	}
 
+	if (sample_type & PERF_SAMPLE_PERIOD) {
+		header.type |= PERF_SAMPLE_PERIOD;
+		header.size += sizeof(u64);
+	}
+
 	if (sample_type & PERF_SAMPLE_GROUP) {
 		header.type |= PERF_SAMPLE_GROUP;
 		header.size += sizeof(u64) +
@@ -2445,6 +2450,9 @@ static void perf_counter_output(struct perf_counter *counter,
 	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(&handle, cpu_entry);
 
+	if (sample_type & PERF_SAMPLE_PERIOD)
+		perf_output_put(&handle, counter->hw.sample_period);
+
 	/*
 	 * XXX PERF_SAMPLE_GROUP vs inherited counters seems difficult.
 	 */
@@ -2835,6 +2843,7 @@ static void perf_log_period(struct perf_counter *counter, u64 period)
 	struct {
 		struct perf_event_header	header;
 		u64				time;
+		u64				id;
 		u64				period;
 	} freq_event = {
 		.header = {
@@ -2843,6 +2852,7 @@ static void perf_log_period(struct perf_counter *counter, u64 period)
 			.size = sizeof(freq_event),
 		},
 		.time = sched_clock(),
+		.id = counter->id,
 		.period = period,
 	};
 
