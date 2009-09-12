Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbZILLEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbZILLEN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZILLEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:04:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:43136 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbZILLEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:04:07 -0400
Date: Sat, 12 Sep 2009 13:03:41 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org
Subject: [PATCH 1/8] perf: Add a timestamp to fork events
Message-ID: <20090912130341.51ad2de2@infradead.org>
In-Reply-To: <20090912130306.5d0086ea@infradead.org>
References: <20090912130306.5d0086ea@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 52d6521b9c81230e3a318dfc741274d6601374ca Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 12 Sep 2009 07:52:47 +0200
Subject: [PATCH] perf: Add a timestamp to fork events

timechart needs to know when a process forked, in order to be able
to visualize properly when tasks start.

This patch adds a time field to the event structure, and fills it
in appropriately.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   11 +++++++++--
 tools/perf/util/event.h      |    1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 972f90d..5fe6898 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -332,6 +332,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
+	 *	u64				time;
 	 * };
 	 */
 	PERF_EVENT_EXIT			= 4,
@@ -352,6 +353,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
+	 *	{ u64				time;     } && PERF_SAMPLE_TIME
 	 * };
 	 */
 	PERF_EVENT_FORK			= 7,
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index e0d91fd..25490db 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3071,6 +3071,7 @@ struct perf_task_event {
 		u32				ppid;
 		u32				tid;
 		u32				ptid;
+		u64				time;
 	} event;
 };
 
@@ -3078,9 +3079,12 @@ static void perf_counter_task_output(struct perf_counter *counter,
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
@@ -3091,7 +3095,10 @@ static void perf_counter_task_output(struct perf_counter *counter,
 	task_event->event.tid = perf_counter_tid(counter, task);
 	task_event->event.ptid = perf_counter_tid(counter, current);
 
+	task_event->event.time = sched_clock();
+
 	perf_output_put(&handle, task_event->event);
+
 	perf_output_end(&handle);
 }
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index fa2d4e9..1545349 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -39,6 +39,7 @@ struct fork_event {
 	struct perf_event_header header;
 	u32 pid, ppid;
 	u32 tid, ptid;
+	u64 time;
 };
 
 struct lost_event {
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
