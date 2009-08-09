Return-Path: <linux-kernel-owner+w=401wt.eu-S1753755AbZHIVqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbZHIVqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 17:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZHIVqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 17:46:48 -0400
Received: from mga06.intel.com ([134.134.136.21]:10596 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753606AbZHIVqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 17:46:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,349,1246863600"; 
   d="scan'208";a="437506366"
Message-ID: <4A7F43C9.8070207@linux.intel.com>
Date: Sun, 09 Aug 2009 14:46:49 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: perf: add a timestamp to exit and fork events
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make use of the fork and exit perf events, it's essential that they tell the
user about when these event happened. This patch adds a time field to the end of the structure
(and thus is abi compatible).

I did not make this field conditional on any flag since that both is unpleasant to use,
and I cannot imagine a scenario where you want the event but not the time.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 0a6f320..5e0769a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -315,6 +315,7 @@ enum perf_event_type {
  	 *	struct perf_event_header	header;
  	 *	u32				pid, ppid;
  	 *	u32				tid, ptid;
+	 *	u64				time;
  	 * };
  	 */
  	PERF_EVENT_EXIT			= 4,
@@ -335,6 +336,7 @@ enum perf_event_type {
  	 *	struct perf_event_header	header;
  	 *	u32				pid, ppid;
  	 *	u32				tid, ptid;
+	 *	u64				time;
  	 * };
  	 */
  	PERF_EVENT_FORK			= 7,
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index bf8110b..9382cd0 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2861,6 +2861,7 @@ struct perf_task_event {
  		u32				ppid;
  		u32				tid;
  		u32				ptid;
+		u64				time;
  	} event;
  };

@@ -2881,6 +2885,7 @@ static void perf_counter_task_output(struct perf_counter *counter,
  	task_event->event.tid = perf_counter_tid(counter, task);
  	task_event->event.ptid = perf_counter_tid(counter, task->real_parent);

+	task_event->event.time = sched_clock();
  	perf_output_put(&handle, task_event->event);
  	perf_output_end(&handle);
  }
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 1dba568..c28e2b3 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -72,6 +72,8 @@ struct comm_event {
  struct fork_event {
  	struct perf_event_header header;
  	u32 pid, ppid;
+	u32 tid, ptid;
+	u64 time;
  };

  typedef union event_union {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4163918..1cb2183 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -104,6 +104,7 @@ struct fork_event {
  	struct perf_event_header header;
  	u32 pid, ppid;
  	u32 tid, ptid;
+	u64 time;
  };

  struct lost_event {
