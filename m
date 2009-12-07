Return-Path: <linux-kernel-owner+w=401wt.eu-S934491AbZLGEIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491AbZLGEIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 23:08:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933296AbZLGEIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 23:08:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56013 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933154AbZLGEIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 23:08:02 -0500
Message-ID: <4B1C7F45.5080105@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 12:06:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] perf_event: fix for procing raw event
References: <4B1C7EE1.8030906@cn.fujitsu.com>
In-Reply-To: <4B1C7EE1.8030906@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use 'data.raw_data' parameter to call process_raw_event(), but
data.raw_data buffer not include data size. it can make perf tool
crash.

This bug is imported by:

Commit-ID:  180f95e29aa8782c019caa64ede2a28d8ab62564
Gitweb:     http://git.kernel.org/tip/180f95e29aa8782c019caa64ede2a28d8ab62564
Author:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
AuthorDate: Sun, 6 Dec 2009 20:08:24 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 18:15:01 +0100

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-kmem.c  |   11 ++++++++---
 tools/perf/builtin-sched.c |   11 ++++++++---
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index f218990..f84d7a3 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -289,13 +289,17 @@ static void process_free_event(struct raw_event_sample *raw,
 }
 
 static void
-process_raw_event(event_t *raw_event __used, void *more_data,
+process_raw_event(event_t *raw_event __used, u32 size, void *data,
 		  int cpu, u64 timestamp, struct thread *thread)
 {
-	struct raw_event_sample *raw = more_data;
+	struct raw_event_sample *raw;
 	struct event *event;
 	int type;
 
+	raw = malloc_or_die(sizeof(*raw)+size);
+	raw->size = size;
+	memcpy(raw->data, data, size);
+
 	type = trace_parse_common_type(raw->data);
 	event = trace_find_event(type);
 
@@ -345,7 +349,8 @@ static int process_sample_event(event_t *event)
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	process_raw_event(event, data.raw_data, data.cpu, data.time, thread);
+	process_raw_event(event, data.raw_size, data.raw_data, data.cpu,
+			  data.time, thread);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7481ebd..4655e16 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1570,13 +1570,17 @@ process_sched_migrate_task_event(struct raw_event_sample *raw,
 }
 
 static void
-process_raw_event(event_t *raw_event __used, void *more_data,
+process_raw_event(event_t *raw_event __used, u32 size, void *data,
 		  int cpu, u64 timestamp, struct thread *thread)
 {
-	struct raw_event_sample *raw = more_data;
+	struct raw_event_sample *raw;
 	struct event *event;
 	int type;
 
+	raw = malloc_or_die(sizeof(*raw)+size);
+	raw->size = size;
+	memcpy(raw->data, data, size);
+
 	type = trace_parse_common_type(raw->data);
 	event = trace_find_event(type);
 
@@ -1629,7 +1633,8 @@ static int process_sample_event(event_t *event)
 	if (profile_cpu != -1 && profile_cpu != (int)data.cpu)
 		return 0;
 
-	process_raw_event(event, data.raw_data, data.cpu, data.time, thread);
+	process_raw_event(event, data.raw_size, data.raw_data, data.cpu,
+			  data.time, thread);
 
 	return 0;
 }
-- 
1.6.1.2



