Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbZFYTou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbZFYTou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759945AbZFYToW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:44:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:45355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758947AbZFYToU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:44:20 -0400
Date: Thu, 25 Jun 2009 19:43:46 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/urgent] perf_counter: Rework the sample ABI
Message-ID: <tip-e6e18ec79b023d5fe84226cef533cf0e3770ce93@git.kernel.org>
Git-Commit-ID: e6e18ec79b023d5fe84226cef533cf0e3770ce93
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 19:43:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6e18ec79b023d5fe84226cef533cf0e3770ce93
Gitweb:     http://git.kernel.org/tip/e6e18ec79b023d5fe84226cef533cf0e3770ce93
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 25 Jun 2009 11:27:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 21:39:08 +0200

perf_counter: Rework the sample ABI

The PERF_EVENT_READ implementation made me realize we don't
actually need the sample_type int the output sample, since
we already have that in the perf_counter_attr information.

Therefore, remove the PERF_EVENT_MISC_OVERFLOW bit and the
event->type overloading, and imply put counter overflow
samples in a PERF_EVENT_SAMPLE type.

This also fixes the issue that event->type was only 32-bit
and sample_type had 64 usable bits.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h  |   10 +++++-----
 kernel/perf_counter.c         |   36 +++++++++++++++---------------------
 tools/perf/builtin-annotate.c |    8 ++++----
 tools/perf/builtin-report.c   |   32 +++++++++++++++++++-------------
 tools/perf/builtin-top.c      |   11 ++++++-----
 5 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index de70a10..3078e23 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -262,7 +262,6 @@ struct perf_counter_mmap_page {
 #define PERF_EVENT_MISC_KERNEL			(1 << 0)
 #define PERF_EVENT_MISC_USER			(2 << 0)
 #define PERF_EVENT_MISC_HYPERVISOR		(3 << 0)
-#define PERF_EVENT_MISC_OVERFLOW		(1 << 2)
 
 struct perf_event_header {
 	__u32	type;
@@ -348,9 +347,6 @@ enum perf_event_type {
 	PERF_EVENT_READ			= 8,
 
 	/*
-	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
-	 * will be PERF_SAMPLE_*
-	 *
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *
@@ -358,8 +354,9 @@ enum perf_event_type {
 	 *	{ u32			pid, tid; } && PERF_SAMPLE_TID
 	 *	{ u64			time;     } && PERF_SAMPLE_TIME
 	 *	{ u64			addr;     } && PERF_SAMPLE_ADDR
-	 *	{ u64			config;   } && PERF_SAMPLE_CONFIG
+	 *	{ u64			id;	  } && PERF_SAMPLE_ID
 	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
+	 * 	{ u64			period;   } && PERF_SAMPLE_PERIOD
 	 *
 	 *	{ u64			nr;
 	 *	  { u64 id, val; }	cnt[nr];  } && PERF_SAMPLE_GROUP
@@ -368,6 +365,9 @@ enum perf_event_type {
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
 	 * };
 	 */
+	PERF_EVENT_SAMPLE		= 9,
+
+	PERF_EVENT_MAX,			/* non-ABI */
 };
 
 enum perf_callchain_context {
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 385ca51..f2f2326 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2575,15 +2575,14 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		u32 cpu, reserved;
 	} cpu_entry;
 
-	header.type = 0;
+	header.type = PERF_EVENT_SAMPLE;
 	header.size = sizeof(header);
 
-	header.misc = PERF_EVENT_MISC_OVERFLOW;
+	header.misc = 0;
 	header.misc |= perf_misc_flags(data->regs);
 
 	if (sample_type & PERF_SAMPLE_IP) {
 		ip = perf_instruction_pointer(data->regs);
-		header.type |= PERF_SAMPLE_IP;
 		header.size += sizeof(ip);
 	}
 
@@ -2592,7 +2591,6 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		tid_entry.pid = perf_counter_pid(counter, current);
 		tid_entry.tid = perf_counter_tid(counter, current);
 
-		header.type |= PERF_SAMPLE_TID;
 		header.size += sizeof(tid_entry);
 	}
 
@@ -2602,34 +2600,25 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		 */
 		time = sched_clock();
 
-		header.type |= PERF_SAMPLE_TIME;
 		header.size += sizeof(u64);
 	}
 
-	if (sample_type & PERF_SAMPLE_ADDR) {
-		header.type |= PERF_SAMPLE_ADDR;
+	if (sample_type & PERF_SAMPLE_ADDR)
 		header.size += sizeof(u64);
-	}
 
-	if (sample_type & PERF_SAMPLE_ID) {
-		header.type |= PERF_SAMPLE_ID;
+	if (sample_type & PERF_SAMPLE_ID)
 		header.size += sizeof(u64);
-	}
 
 	if (sample_type & PERF_SAMPLE_CPU) {
-		header.type |= PERF_SAMPLE_CPU;
 		header.size += sizeof(cpu_entry);
 
 		cpu_entry.cpu = raw_smp_processor_id();
 	}
 
-	if (sample_type & PERF_SAMPLE_PERIOD) {
-		header.type |= PERF_SAMPLE_PERIOD;
+	if (sample_type & PERF_SAMPLE_PERIOD)
 		header.size += sizeof(u64);
-	}
 
 	if (sample_type & PERF_SAMPLE_GROUP) {
-		header.type |= PERF_SAMPLE_GROUP;
 		header.size += sizeof(u64) +
 			counter->nr_siblings * sizeof(group_entry);
 	}
@@ -2639,10 +2628,9 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 
 		if (callchain) {
 			callchain_size = (1 + callchain->nr) * sizeof(u64);
-
-			header.type |= PERF_SAMPLE_CALLCHAIN;
 			header.size += callchain_size;
-		}
+		} else
+			header.size += sizeof(u64);
 	}
 
 	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
@@ -2693,8 +2681,14 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		}
 	}
 
-	if (callchain)
-		perf_output_copy(&handle, callchain, callchain_size);
+	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
+		if (callchain)
+			perf_output_copy(&handle, callchain, callchain_size);
+		else {
+			u64 nr = 0;
+			perf_output_put(&handle, nr);
+		}
+	}
 
 	perf_output_end(&handle);
 }
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 7e58e3a..722c0f5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -855,7 +855,7 @@ static unsigned long total = 0,
 		     total_unknown = 0;
 
 static int
-process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
+process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	char level;
 	int show = 0;
@@ -1013,10 +1013,10 @@ process_period_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW)
-		return process_overflow_event(event, offset, head);
-
 	switch (event->header.type) {
+	case PERF_EVENT_SAMPLE:
+		return process_sample_event(event, offset, head);
+
 	case PERF_EVENT_MMAP:
 		return process_mmap_event(event, offset, head);
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e575f30..ec5361c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -53,6 +53,8 @@ static regex_t		parent_regex;
 
 static int		exclude_other = 1;
 
+static u64		sample_type;
+
 struct ip_event {
 	struct perf_event_header header;
 	u64 ip;
@@ -1135,7 +1137,7 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 }
 
 static int
-process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
+process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	char level;
 	int show = 0;
@@ -1147,12 +1149,12 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	void *more_data = event->ip.__more_data;
 	struct ip_callchain *chain = NULL;
 
-	if (event->header.type & PERF_SAMPLE_PERIOD) {
+	if (sample_type & PERF_SAMPLE_PERIOD) {
 		period = *(u64 *)more_data;
 		more_data += sizeof(u64);
 	}
 
-	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p period: %Ld\n",
+	dprintf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d: %p period: %Ld\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.misc,
@@ -1160,7 +1162,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 		(void *)(long)ip,
 		(long long)period);
 
-	if (event->header.type & PERF_SAMPLE_CALLCHAIN) {
+	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int i;
 
 		chain = (void *)more_data;
@@ -1352,10 +1354,10 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	trace_event(event);
 
-	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW)
-		return process_overflow_event(event, offset, head);
-
 	switch (event->header.type) {
+	case PERF_EVENT_SAMPLE:
+		return process_sample_event(event, offset, head);
+
 	case PERF_EVENT_MMAP:
 		return process_mmap_event(event, offset, head);
 
@@ -1388,18 +1390,21 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 
 static struct perf_header	*header;
 
-static int perf_header__has_sample(u64 sample_mask)
+static u64 perf_header__sample_type(void)
 {
+	u64 sample_type = 0;
 	int i;
 
 	for (i = 0; i < header->attrs; i++) {
 		struct perf_header_attr *attr = header->attr[i];
 
-		if (!(attr->attr.sample_type & sample_mask))
-			return 0;
+		if (!sample_type)
+			sample_type = attr->attr.sample_type;
+		else if (sample_type != attr->attr.sample_type)
+			die("non matching sample_type");
 	}
 
-	return 1;
+	return sample_type;
 }
 
 static int __cmd_report(void)
@@ -1437,8 +1442,9 @@ static int __cmd_report(void)
 	header = perf_header__read(input);
 	head = header->data_offset;
 
-	if (sort__has_parent &&
-	    !perf_header__has_sample(PERF_SAMPLE_CALLCHAIN)) {
+	sample_type = perf_header__sample_type();
+
+	if (sort__has_parent && !(sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		fprintf(stderr, "selected --sort parent, but no callchain data\n");
 		exit(-1);
 	}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5352b5e..cf0d21f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -392,11 +392,11 @@ static void record_ip(u64 ip, int counter)
 	samples--;
 }
 
-static void process_event(u64 ip, int counter)
+static void process_event(u64 ip, int counter, int user)
 {
 	samples++;
 
-	if (ip < min_ip || ip > max_ip) {
+	if (user) {
 		userspace_samples++;
 		return;
 	}
@@ -509,9 +509,10 @@ static void mmap_read_counter(struct mmap_data *md)
 
 		old += size;
 
-		if (event->header.misc & PERF_EVENT_MISC_OVERFLOW) {
-			if (event->header.type & PERF_SAMPLE_IP)
-				process_event(event->ip.ip, md->counter);
+		if (event->header.type == PERF_EVENT_SAMPLE) {
+			int user =
+	(event->header.misc & PERF_EVENT_MISC_CPUMODE_MASK) == PERF_EVENT_MISC_USER;
+			process_event(event->ip.ip, md->counter, user);
 		}
 	}
 
