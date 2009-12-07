Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbZLGFdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbZLGFdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZLGFdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:33:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:49349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZLGFc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:32:57 -0500
Date: Mon, 7 Dec 2009 05:31:02 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, penberg@cs.helsinki.fi,
       peterz@infradead.org, eduard.munteanu@linux360.ro,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       lizf@cn.fujitsu.com, peterz@infradead.org, eduard.munteanu@linux360.ro,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com,
       hirofumi@mail.parknet.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B1C7F45.5080105@cn.fujitsu.com>
References: <4B1C7F45.5080105@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Fix raw event processing
Message-ID: <tip-d8bd9e0aedabcb47887712497bc386a06ddcbd12@git.kernel.org>
Git-Commit-ID: d8bd9e0aedabcb47887712497bc386a06ddcbd12
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8bd9e0aedabcb47887712497bc386a06ddcbd12
Gitweb:     http://git.kernel.org/tip/d8bd9e0aedabcb47887712497bc386a06ddcbd12
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Mon, 7 Dec 2009 12:06:29 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 7 Dec 2009 06:26:24 +0100

perf_event: Fix raw event processing

We use 'data.raw_data' parameter to call process_raw_event(),
but data.raw_data buffer not include data size. it can make perf
tool crash.

This bug was introduced by commit 180f95e29a ("perf: Make common
SAMPLE_EVENT parser").

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4B1C7F45.5080105@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
