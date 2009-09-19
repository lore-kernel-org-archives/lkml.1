Return-Path: <linux-kernel-owner+w=401wt.eu-S932166AbZISJwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbZISJwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbZISJwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:52:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:57073 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbZISJwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:52:12 -0400
Date: Sat, 19 Sep 2009 09:51:37 GMT
From: tip-bot for Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, arjan@linux.intel.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090912130341.51ad2de2@infradead.org>
References: <20090912130341.51ad2de2@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf: Add a timestamp to fork events
Message-ID: <tip-393b2ad8c757ba3ccd2a99ca5bbcd6db4d3fa53d@git.kernel.org>
Git-Commit-ID: 393b2ad8c757ba3ccd2a99ca5bbcd6db4d3fa53d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 09:51:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  393b2ad8c757ba3ccd2a99ca5bbcd6db4d3fa53d
Gitweb:     http://git.kernel.org/tip/393b2ad8c757ba3ccd2a99ca5bbcd6db4d3fa53d
Author:     Arjan van de Ven <arjan@linux.intel.com>
AuthorDate: Sat, 12 Sep 2009 07:52:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 11:42:10 +0200

perf: Add a timestamp to fork events

perf timechart needs to know when a process forked, in order to be
able to visualize properly when tasks start.

This patch adds a time field to the event structure, and fills it
in appropriately.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090912130341.51ad2de2@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   11 +++++++++--
 tools/perf/util/event.h      |    1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index c7375f9..bd34100 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -336,6 +336,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
+	 *	u64				time;
 	 * };
 	 */
 	PERF_EVENT_EXIT			= 4,
@@ -356,6 +357,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
+	 *	{ u64				time;     } && PERF_SAMPLE_TIME
 	 * };
 	 */
 	PERF_EVENT_FORK			= 7,
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d013f4e..d5899b6 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3083,6 +3083,7 @@ struct perf_task_event {
 		u32				ppid;
 		u32				tid;
 		u32				ptid;
+		u64				time;
 	} event;
 };
 
@@ -3090,9 +3091,12 @@ static void perf_counter_task_output(struct perf_counter *counter,
 				     struct perf_task_event *task_event)
 {
 	struct perf_output_handle handle;
-	int size = task_event->event.header.size;
+	int size;
 	struct task_struct *task = task_event->task;
-	int ret = perf_output_begin(&handle, counter, size, 0, 0);
+	int ret;
+
+	size  = task_event->event.header.size;
+	ret = perf_output_begin(&handle, counter, size, 0, 0);
 
 	if (ret)
 		return;
@@ -3103,7 +3107,10 @@ static void perf_counter_task_output(struct perf_counter *counter,
 	task_event->event.tid = perf_counter_tid(counter, task);
 	task_event->event.ptid = perf_counter_tid(counter, current);
 
+	task_event->event.time = perf_clock();
+
 	perf_output_put(&handle, task_event->event);
+
 	perf_output_end(&handle);
 }
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 2495529..28a579f 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -39,6 +39,7 @@ struct fork_event {
 	struct perf_event_header header;
 	u32 pid, ppid;
 	u32 tid, ptid;
+	u64 time;
 };
 
 struct lost_event {
