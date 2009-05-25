Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZEYUIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZEYUIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbZEYUIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:08:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:58645 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbZEYUId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:08:33 -0400
Date: Mon, 25 May 2009 20:06:32 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090525153931.703093461@chello.nl>
References: <20090525153931.703093461@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: fix warning & lockup
Message-ID: <tip-0127c3ea082ee9f1034789b978dfc7fd83254617@git.kernel.org>
Git-Commit-ID: 0127c3ea082ee9f1034789b978dfc7fd83254617
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 20:06:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0127c3ea082ee9f1034789b978dfc7fd83254617
Gitweb:     http://git.kernel.org/tip/0127c3ea082ee9f1034789b978dfc7fd83254617
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 25 May 2009 22:03:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 22:02:23 +0200

perf_counter: fix warning & lockup

 - remove bogus warning
 - fix wakeup from NMI path lockup
 - also fix up whitespace noise in perf_counter.h

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090525153931.703093461@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |   78 +++++++++++++++++++++---------------------
 kernel/perf_counter.c        |    4 +--
 2 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index e3a7585..2b16ed3 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -73,7 +73,7 @@ enum sw_event_ids {
 	PERF_SW_EVENTS_MAX		= 7,
 };
 
-#define __PERF_COUNTER_MASK(name) 			\
+#define __PERF_COUNTER_MASK(name)			\
 	(((1ULL << PERF_COUNTER_##name##_BITS) - 1) <<	\
 	 PERF_COUNTER_##name##_SHIFT)
 
@@ -98,14 +98,14 @@ enum sw_event_ids {
  * in the overflow packets.
  */
 enum perf_counter_record_format {
-	PERF_RECORD_IP		= 1U << 0,
-	PERF_RECORD_TID		= 1U << 1,
-	PERF_RECORD_TIME	= 1U << 2,
-	PERF_RECORD_ADDR	= 1U << 3,
-	PERF_RECORD_GROUP	= 1U << 4,
-	PERF_RECORD_CALLCHAIN	= 1U << 5,
-	PERF_RECORD_CONFIG	= 1U << 6,
-	PERF_RECORD_CPU		= 1U << 7,
+	PERF_RECORD_IP			= 1U << 0,
+	PERF_RECORD_TID			= 1U << 1,
+	PERF_RECORD_TIME		= 1U << 2,
+	PERF_RECORD_ADDR		= 1U << 3,
+	PERF_RECORD_GROUP		= 1U << 4,
+	PERF_RECORD_CALLCHAIN		= 1U << 5,
+	PERF_RECORD_CONFIG		= 1U << 6,
+	PERF_RECORD_CPU			= 1U << 7,
 };
 
 /*
@@ -235,13 +235,13 @@ enum perf_event_type {
 	 * correlate userspace IPs to code. They have the following structure:
 	 *
 	 * struct {
-	 * 	struct perf_event_header	header;
+	 *	struct perf_event_header	header;
 	 *
-	 * 	u32				pid, tid;
-	 * 	u64				addr;
-	 * 	u64				len;
-	 * 	u64				pgoff;
-	 * 	char				filename[];
+	 *	u32				pid, tid;
+	 *	u64				addr;
+	 *	u64				len;
+	 *	u64				pgoff;
+	 *	char				filename[];
 	 * };
 	 */
 	PERF_EVENT_MMAP			= 1,
@@ -249,27 +249,27 @@ enum perf_event_type {
 
 	/*
 	 * struct {
-	 * 	struct perf_event_header	header;
+	 *	struct perf_event_header	header;
 	 *
-	 * 	u32				pid, tid;
-	 * 	char				comm[];
+	 *	u32				pid, tid;
+	 *	char				comm[];
 	 * };
 	 */
 	PERF_EVENT_COMM			= 3,
 
 	/*
 	 * struct {
-	 * 	struct perf_event_header	header;
-	 * 	u64				time;
-	 * 	u64				irq_period;
+	 *	struct perf_event_header	header;
+	 *	u64				time;
+	 *	u64				irq_period;
 	 * };
 	 */
 	PERF_EVENT_PERIOD		= 4,
 
 	/*
 	 * struct {
-	 * 	struct perf_event_header	header;
-	 * 	u64				time;
+	 *	struct perf_event_header	header;
+	 *	u64				time;
 	 * };
 	 */
 	PERF_EVENT_THROTTLE		= 5,
@@ -280,23 +280,23 @@ enum perf_event_type {
 	 * will be PERF_RECORD_*
 	 *
 	 * struct {
-	 * 	struct perf_event_header	header;
+	 *	struct perf_event_header	header;
 	 *
-	 * 	{ u64			ip;	  } && PERF_RECORD_IP
-	 * 	{ u32			pid, tid; } && PERF_RECORD_TID
-	 * 	{ u64			time;     } && PERF_RECORD_TIME
-	 * 	{ u64			addr;     } && PERF_RECORD_ADDR
-	 * 	{ u64			config;   } && PERF_RECORD_CONFIG
-	 * 	{ u32			cpu, res; } && PERF_RECORD_CPU
+	 *	{ u64			ip;	  } && PERF_RECORD_IP
+	 *	{ u32			pid, tid; } && PERF_RECORD_TID
+	 *	{ u64			time;     } && PERF_RECORD_TIME
+	 *	{ u64			addr;     } && PERF_RECORD_ADDR
+	 *	{ u64			config;   } && PERF_RECORD_CONFIG
+	 *	{ u32			cpu, res; } && PERF_RECORD_CPU
 	 *
-	 * 	{ u64			nr;
-	 * 	  { u64 event, val; } 	cnt[nr];  } && PERF_RECORD_GROUP
+	 *	{ u64			nr;
+	 *	  { u64 event, val; }	cnt[nr];  } && PERF_RECORD_GROUP
 	 *
-	 * 	{ u16			nr,
-	 * 				hv,
-	 * 				kernel,
-	 * 				user;
-	 * 	  u64			ips[nr];  } && PERF_RECORD_CALLCHAIN
+	 *	{ u16			nr,
+	 *				hv,
+	 *				kernel,
+	 *				user;
+	 *	  u64			ips[nr];  } && PERF_RECORD_CALLCHAIN
 	 * };
 	 */
 };
@@ -406,7 +406,7 @@ struct perf_mmap_data {
 	atomic_t			wakeup;		/* needs a wakeup    */
 
 	struct perf_counter_mmap_page   *user_page;
-	void 				*data_pages[0];
+	void				*data_pages[0];
 };
 
 struct perf_pending_entry {
@@ -422,7 +422,7 @@ struct perf_counter {
 	struct list_head		list_entry;
 	struct list_head		event_entry;
 	struct list_head		sibling_list;
-	int 				nr_siblings;
+	int				nr_siblings;
 	struct perf_counter		*group_leader;
 	const struct pmu		*pmu;
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ec9c400..070f92d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2576,7 +2576,7 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
 		.time = sched_clock(),
 	};
 
-	ret = perf_output_begin(&handle, counter, sizeof(throttle_event), 0, 0);
+	ret = perf_output_begin(&handle, counter, sizeof(throttle_event), 1, 0);
 	if (ret)
 		return;
 
@@ -3449,8 +3449,6 @@ void perf_counter_exit_task(struct task_struct *child)
 	struct perf_counter_context *child_ctx;
 	unsigned long flags;
 
-	WARN_ON_ONCE(child != current);
-
 	child_ctx = child->perf_counter_ctxp;
 
 	if (likely(!child_ctx))
