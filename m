Return-Path: <linux-kernel-owner+w=401wt.eu-S1764069AbZEHSle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764069AbZEHSle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764035AbZEHSk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:40:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:54703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764041AbZEHSk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:40:57 -0400
Date: Fri, 8 May 2009 18:40:07 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090508170029.008627711@chello.nl>
References: <20090508170029.008627711@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: add PERF_RECORD_CPU
Message-ID: <tip-f370e1e2f195ec1e6420e26fc83e0319595db578@git.kernel.org>
Git-Commit-ID: f370e1e2f195ec1e6420e26fc83e0319595db578
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 18:40:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f370e1e2f195ec1e6420e26fc83e0319595db578
Gitweb:     http://git.kernel.org/tip/f370e1e2f195ec1e6420e26fc83e0319595db578
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 8 May 2009 18:52:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 May 2009 20:36:59 +0200

perf_counter: add PERF_RECORD_CPU

Allow recording the CPU number the event was generated on.

RFC: this leaves a u32 as reserved, should we fill in the
     node_id() there, or leave this open for future extention,
     as userspace can already easily do the cpu->node mapping
     if needed.

[ Impact: extend perfcounter output record format ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090508170029.008627711@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   13 +++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 0e6303d..614f921 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
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
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c615f52..d850a1f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1956,6 +1956,9 @@ static void perf_counter_output(struct perf_counter *counter,
 	struct perf_callchain_entry *callchain = NULL;
 	int callchain_size = 0;
 	u64 time;
+	struct {
+		u32 cpu, reserved;
+	} cpu_entry;
 
 	header.type = 0;
 	header.size = sizeof(header);
@@ -1999,6 +2002,13 @@ static void perf_counter_output(struct perf_counter *counter,
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
@@ -2037,6 +2047,9 @@ static void perf_counter_output(struct perf_counter *counter,
 	if (record_type & PERF_RECORD_CONFIG)
 		perf_output_put(&handle, counter->hw_event.config);
 
+	if (record_type & PERF_RECORD_CPU)
+		perf_output_put(&handle, cpu_entry);
+
 	/*
 	 * XXX PERF_RECORD_GROUP vs inherited counters seems difficult.
 	 */
