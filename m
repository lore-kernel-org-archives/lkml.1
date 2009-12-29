Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbZL2FXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbZL2FXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZL2FX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:23:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49470 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbZL2FX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:23:28 -0500
Message-ID: <4B3991E0.2020402@cn.fujitsu.com>
Date: Tue, 29 Dec 2009 13:21:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/5] perf tools: fix getting point
References: <4B27702F.1080507@cn.fujitsu.com> <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com> <4B30C3A0.909@cn.fujitsu.com> <20091228075417.GB20039@elte.hu>
In-Reply-To: <20091228075417.GB20039@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The point that got by raw_field_ptr() is point to @data offset not
tracepoint saved.

Introduce raw_field_array() to get array data

Changlog v1->v2:
- fix the typo 'arry' -> 'array' that is pointed out by Frederic Weisbecker

- use '(void *)(unsigned long)value' instead of 'memcpy()' as
  Frederic Weisbecker's suggestion

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-sched.c          |    3 +--
 tools/perf/util/trace-event-parse.c |   23 ++++++++++++++++++++---
 tools/perf/util/trace-event.h       |    3 +++
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 702322f..9b91836 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -630,8 +630,7 @@ static void test_calibrations(void)
 
 #define FILL_ARRAY(ptr, array, event, data)			\
 do {								\
-	void *__array = raw_field_ptr(event, #array, data);	\
-	memcpy(ptr.array, __array, sizeof(ptr.array));	\
+	raw_field_array(event, #array, data, ptr.array, sizeof(ptr.array));\
 } while(0)
 
 #define FILL_COMMON_FIELDS(ptr, event, data)			\
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index c5c32be..037bbe3 100644
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
@@ -1919,13 +1919,30 @@ raw_field_value(struct event *event, const char *name, void *data)
 
 void *raw_field_ptr(struct event *event, const char *name, void *data)
 {
+	unsigned long long value;
+
+	value = raw_field_value(event, name, data);
+
+	if (!value)
+		return NULL;
+
+	return (void *)(unsigned long)value;
+}
+
+unsigned long long
+raw_field_array(struct event *event, const char *name, void *data,
+	       void *array, int array_size)
+{
+	int len;
 	struct format_field *field;
 
 	field = find_any_field(event, name);
 	if (!field)
-		return NULL;
+		return 0ULL;
 
-	return data + field->offset;
+	len = min(array_size, field->size);
+	memcpy(array, data + field->offset, len);
+	return len;
 }
 
 static int get_common_info(const char *type, int *offset, int *size)
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 6ad4056..c3b5c39 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -255,6 +255,9 @@ unsigned long long read_size(void *ptr, int size);
 unsigned long long
 raw_field_value(struct event *event, const char *name, void *data);
 void *raw_field_ptr(struct event *event, const char *name, void *data);
+unsigned long long
+raw_field_array(struct event *event, const char *name, void *data,
+	       void *array, int array_size);
 unsigned long long eval_flag(const char *flag);
 
 int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
-- 
1.6.1.2


