Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbZLOLWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbZLOLWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbZLOLWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:22:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55261 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759907AbZLOLWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:22:13 -0500
Message-ID: <4B2770FA.7090803@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 19:20:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] perf_event: fix getting point
References: <4B27702F.1080507@cn.fujitsu.com> <4B2770AD.90005@cn.fujitsu.com>
In-Reply-To: <4B2770AD.90005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The point that got by raw_field_ptr() is point to @data offset not
tracepoint saved.

Introduce raw_field_arry() to get arry data is tracepoint save
arry to it.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-sched.c          |    3 +--
 tools/perf/util/trace-event-parse.c |   25 ++++++++++++++++++++++---
 tools/perf/util/trace-event.h       |    3 +++
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d67f274..8df982e 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -630,8 +630,7 @@ static void test_calibrations(void)
 
 #define FILL_ARRAY(ptr, array, event, data)			\
 do {								\
-	void *__array = raw_field_ptr(event, #array, data);	\
-	memcpy(ptr.array, __array, sizeof(ptr.array));	\
+	raw_field_arry(event, #array, data, ptr.array, sizeof(ptr.array));\
 } while(0)
 
 #define FILL_COMMON_FIELDS(ptr, event, data)			\
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index c5c32be..b0ee64f 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -840,7 +840,7 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 			field->flags |= FIELD_IS_ARRAY;
 
 			type = read_token(&token);
-		        while (strcmp(token, "]") != 0) {
+			while (strcmp(token, "]") != 0) {
 				if (last_type == EVENT_ITEM &&
 				    type == EVENT_ITEM)
 					len = 2;
@@ -1919,13 +1919,32 @@ raw_field_value(struct event *event, const char *name, void *data)
 
 void *raw_field_ptr(struct event *event, const char *name, void *data)
 {
+	void *ptr;
+	unsigned long long value;
+
+	value = raw_field_value(event, name, data);
+
+	if (!value)
+		return NULL;
+
+	memcpy(&ptr, &value, sizeof(ptr));
+	return ptr;
+}
+
+unsigned long long
+raw_field_arry(struct event *event, const char *name, void *data,
+	       void *arry, int arry_size)
+{
+	int len;
 	struct format_field *field;
 
 	field = find_any_field(event, name);
 	if (!field)
-		return NULL;
+		return 0ULL;
 
-	return data + field->offset;
+	len = min(arry_size, field->size);
+	memcpy(arry, data + field->offset, len);
+	return len;
 }
 
 static int get_common_info(const char *type, int *offset, int *size)
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 81698d5..3f88010 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -255,6 +255,9 @@ unsigned long long read_size(void *ptr, int size);
 unsigned long long
 raw_field_value(struct event *event, const char *name, void *data);
 void *raw_field_ptr(struct event *event, const char *name, void *data);
+unsigned long long
+raw_field_arry(struct event *event, const char *name, void *data,
+	       void *arry, int arry_size);
 unsigned long long eval_flag(const char *flag);
 
 int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
-- 
1.6.1.2


