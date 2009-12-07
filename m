Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbZLGGd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbZLGGd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbZLGGd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:33:26 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:43920 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZLGGdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:33:25 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_event: fix for processing raw event - fix
References: <4B1C7EE1.8030906@cn.fujitsu.com>
	<4B1C7F45.5080105@cn.fujitsu.com> <4B1C8CC4.4050007@cn.fujitsu.com>
Date: Mon, 07 Dec 2009 15:33:28 +0900
In-Reply-To: <4B1C8CC4.4050007@cn.fujitsu.com> (Xiao Guangrong's message of
	"Mon, 07 Dec 2009 13:04:04 +0800")
Message-ID: <87ein747k7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> writes:

> raw->size is not used, this patch just cleanup it

Oops, I didn't notice those. Thanks.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  tools/perf/builtin-kmem.c  |   38 +++++++-----------
>  tools/perf/builtin-sched.c |   94 +++++++++++++++++++------------------------
>  2 files changed, 56 insertions(+), 76 deletions(-)
>
> diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
> index f84d7a3..7551a5f 100644
> --- a/tools/perf/builtin-kmem.c
> +++ b/tools/perf/builtin-kmem.c
> @@ -57,11 +57,6 @@ static struct rb_root root_caller_sorted;
>  static unsigned long total_requested, total_allocated;
>  static unsigned long nr_allocs, nr_cross_allocs;
>  
> -struct raw_event_sample {
> -	u32 size;
> -	char data[0];
> -};
> -
>  #define PATH_SYS_NODE	"/sys/devices/system/node"
>  
>  static void init_cpunode_map(void)
> @@ -201,7 +196,7 @@ static void insert_caller_stat(unsigned long call_site,
>  	}
>  }
>  
> -static void process_alloc_event(struct raw_event_sample *raw,
> +static void process_alloc_event(void *data,
>  				struct event *event,
>  				int cpu,
>  				u64 timestamp __used,

How about the following patch instead of playing with unsafe "void *"?
With this, I guess it does type check, and filed handling functions can
check "size" by passing "struct sample_raw_data" instead of "void *" in
future.

[Sorry, this patch was almost compiled only, and tested slightly.]

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 tools/perf/builtin-kmem.c      |   14 ++++----------
 tools/perf/builtin-sched.c     |   20 +++++++-------------
 tools/perf/builtin-timechart.c |    4 ++--
 tools/perf/builtin-trace.c     |    4 ++--
 tools/perf/util/event.c        |    8 ++------
 tools/perf/util/event.h        |    8 ++++++--
 6 files changed, 23 insertions(+), 35 deletions(-)

diff -puN tools/perf/util/event.h~perf-raw_sample tools/perf/util/event.h
--- linux-2.6/tools/perf/util/event.h~perf-raw_sample	2009-12-07 14:48:09.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/util/event.h	2009-12-07 15:25:51.000000000 +0900
@@ -61,6 +61,11 @@ struct sample_event {
 	u64 array[];
 };
 
+struct sample_raw_data {
+	u32 size;
+	unsigned char data[];
+};
+
 struct sample_data {
 	u64 ip;
 	u32 pid, tid;
@@ -71,8 +76,7 @@ struct sample_data {
 	u32 cpu;
 	u64 period;
 	struct ip_callchain *callchain;
-	u32 raw_size;
-	void *raw_data;
+	struct sample_raw_data *raw;
 };
 
 #define BUILD_ID_SIZE 20
diff -puN tools/perf/builtin-sched.c~perf-raw_sample tools/perf/builtin-sched.c
--- linux-2.6/tools/perf/builtin-sched.c~perf-raw_sample	2009-12-07 14:49:09.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/builtin-sched.c	2009-12-07 14:58:04.000000000 +0900
@@ -628,11 +628,6 @@ static void test_calibrations(void)
 	printf("the sleep test took %Ld nsecs\n", T1-T0);
 }
 
-struct raw_event_sample {
-	u32 size;
-	char data[0];
-};
-
 #define FILL_FIELD(ptr, field, event, data)	\
 	ptr.field = (typeof(ptr.field)) raw_field_value(event, #field, data)
 
@@ -1356,7 +1351,7 @@ static void sort_lat(void)
 static struct trace_sched_handler *trace_handler;
 
 static void
-process_sched_wakeup_event(struct raw_event_sample *raw,
+process_sched_wakeup_event(struct sample_raw_data *raw,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1469,7 +1464,7 @@ map_switch_event(struct trace_switch_eve
 
 
 static void
-process_sched_switch_event(struct raw_event_sample *raw,
+process_sched_switch_event(struct sample_raw_data *raw,
 			   struct event *event,
 			   int this_cpu,
 			   u64 timestamp __used,
@@ -1502,7 +1497,7 @@ process_sched_switch_event(struct raw_ev
 }
 
 static void
-process_sched_runtime_event(struct raw_event_sample *raw,
+process_sched_runtime_event(struct sample_raw_data *raw,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1520,7 +1515,7 @@ process_sched_runtime_event(struct raw_e
 }
 
 static void
-process_sched_fork_event(struct raw_event_sample *raw,
+process_sched_fork_event(struct sample_raw_data *raw,
 			 struct event *event,
 			 int cpu __used,
 			 u64 timestamp __used,
@@ -1550,7 +1545,7 @@ process_sched_exit_event(struct event *e
 }
 
 static void
-process_sched_migrate_task_event(struct raw_event_sample *raw,
+process_sched_migrate_task_event(struct sample_raw_data *raw,
 			   struct event *event,
 			   int cpu __used,
 			   u64 timestamp __used,
@@ -1570,10 +1565,9 @@ process_sched_migrate_task_event(struct 
 }
 
 static void
-process_raw_event(event_t *raw_event __used, void *more_data,
+process_raw_event(event_t *raw_event __used, struct sample_raw_data *raw,
 		  int cpu, u64 timestamp, struct thread *thread)
 {
-	struct raw_event_sample *raw = more_data;
 	struct event *event;
 	int type;
 
@@ -1629,7 +1623,7 @@ static int process_sample_event(event_t 
 	if (profile_cpu != -1 && profile_cpu != (int)data.cpu)
 		return 0;
 
-	process_raw_event(event, data.raw_data, data.cpu, data.time, thread);
+	process_raw_event(event, data.raw, data.cpu, data.time, thread);
 
 	return 0;
 }
diff -puN tools/perf/builtin-trace.c~perf-raw_sample tools/perf/builtin-trace.c
--- linux-2.6/tools/perf/builtin-trace.c~perf-raw_sample	2009-12-07 14:50:25.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/builtin-trace.c	2009-12-07 14:50:53.000000000 +0900
@@ -95,8 +95,8 @@ static int process_sample_event(event_t 
 		 * field, although it should be the same than this perf
 		 * event pid
 		 */
-		scripting_ops->process_event(data.cpu, data.raw_data,
-					     data.raw_size,
+		scripting_ops->process_event(data.cpu, data.raw->data,
+					     data.raw->size,
 					     data.time, thread->comm);
 	}
 	event__stats.total += data.period;
diff -puN tools/perf/builtin-timechart.c~perf-raw_sample tools/perf/builtin-timechart.c
--- linux-2.6/tools/perf/builtin-timechart.c~perf-raw_sample	2009-12-07 14:51:05.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/builtin-timechart.c	2009-12-07 14:51:26.000000000 +0900
@@ -497,8 +497,8 @@ process_sample_event(event_t *event)
 			last_time = data.time;
 	}
 
-	te = (void *)data.raw_data;
-	if (sample_type & PERF_SAMPLE_RAW && data.raw_size > 0) {
+	te = (void *)data.raw->data;
+	if (sample_type & PERF_SAMPLE_RAW && data.raw->size > 0) {
 		char *event_str;
 		struct power_entry *pe;
 
diff -puN tools/perf/builtin-kmem.c~perf-raw_sample tools/perf/builtin-kmem.c
--- linux-2.6/tools/perf/builtin-kmem.c~perf-raw_sample	2009-12-07 14:51:38.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/builtin-kmem.c	2009-12-07 14:53:57.000000000 +0900
@@ -57,11 +57,6 @@ static struct rb_root root_caller_sorted
 static unsigned long total_requested, total_allocated;
 static unsigned long nr_allocs, nr_cross_allocs;
 
-struct raw_event_sample {
-	u32 size;
-	char data[0];
-};
-
 #define PATH_SYS_NODE	"/sys/devices/system/node"
 
 static void init_cpunode_map(void)
@@ -201,7 +196,7 @@ static void insert_caller_stat(unsigned 
 	}
 }
 
-static void process_alloc_event(struct raw_event_sample *raw,
+static void process_alloc_event(struct sample_raw_data *raw,
 				struct event *event,
 				int cpu,
 				u64 timestamp __used,
@@ -262,7 +257,7 @@ static struct alloc_stat *search_alloc_s
 	return NULL;
 }
 
-static void process_free_event(struct raw_event_sample *raw,
+static void process_free_event(struct sample_raw_data *raw,
 			       struct event *event,
 			       int cpu,
 			       u64 timestamp __used,
@@ -289,10 +284,9 @@ static void process_free_event(struct ra
 }
 
 static void
-process_raw_event(event_t *raw_event __used, void *more_data,
+process_raw_event(event_t *raw_event __used, struct sample_raw_data *raw,
 		  int cpu, u64 timestamp, struct thread *thread)
 {
-	struct raw_event_sample *raw = more_data;
 	struct event *event;
 	int type;
 
@@ -345,7 +339,7 @@ static int process_sample_event(event_t 
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	process_raw_event(event, data.raw_data, data.cpu, data.time, thread);
+	process_raw_event(event, data.raw, data.cpu, data.time, thread);
 
 	return 0;
 }
diff -puN tools/perf/util/event.c~perf-raw_sample tools/perf/util/event.c
--- linux-2.6/tools/perf/util/event.c~perf-raw_sample	2009-12-07 14:52:56.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/util/event.c	2009-12-07 14:53:06.000000000 +0900
@@ -368,12 +368,8 @@ int event__parse_sample(event_t *event, 
 		array += 1 + data->callchain->nr;
 	}
 
-	if (type & PERF_SAMPLE_RAW) {
-		u32 *p = (u32 *)array;
-		data->raw_size = *p;
-		p++;
-		data->raw_data = p;
-	}
+	if (type & PERF_SAMPLE_RAW)
+		data->raw = (struct sample_raw_data *)array;
 
 	return 0;
 }
_
