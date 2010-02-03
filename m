Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0BCJO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:14:56 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38151 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0BCJOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:14:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JsHZRvCcIR/69/Zte1OCjGuyroGjSt9O2QWn8cLlXy9NV3mpbS1MveiWpO3Gp+zNbU
         l9IVJbxecQz4qChi70OHf4ls+syNgfwCstHclAfVR+oOR/Nra6ZdxhwWRd1oZuOCGwa9
         C4KLbHbfYunaTfEOmaa7cBPrRgwDojf6PlQUU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/11] perf/lock: Add support for lock_class_init events
Date: Wed,  3 Feb 2010 10:14:32 +0100
Message-Id: <1265188475-23509-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the new lock_class_init event from perf lock.
Retrieve the name of the locks from these events and remove
support of the name from other lock events.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 tools/perf/builtin-lock.c |  197 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 163 insertions(+), 34 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index fb9ab2a..e1133b7 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -28,24 +28,38 @@
 #define LOCKHASH_SIZE		(1UL << LOCKHASH_BITS)
 
 static struct list_head lockhash_table[LOCKHASH_SIZE];
+static struct list_head classhash_table[LOCKHASH_SIZE];
 
 #define __lockhashfn(key)	hash_long((unsigned long)key, LOCKHASH_BITS)
 #define lockhashentry(key)	(lockhash_table + __lockhashfn((key)))
+#define classhashentry(key)	(classhash_table + __lockhashfn((key)))
 
 #define LOCK_STATE_UNLOCKED	0	       /* initial state */
 #define LOCK_STATE_LOCKED	1
 
+/*
+ * Can be extended for class scope profiling
+ */
+struct class_stat {
+	struct list_head	hash_entry;
+	void			*addr;
+	char			*name;
+	struct list_head	lock_list;
+};
+
 struct lock_stat {
 	struct list_head	hash_entry;
 	struct rb_node		rb;		/* used for sorting */
 
+	struct list_head	lock_list;	/* list in the class */
+
 	/*
 	 * FIXME: raw_field_value() returns unsigned long long,
 	 * so address of lockdep_map should be dealed as 64bit.
 	 * Is there more better solution?
 	 */
 	void			*addr;		/* address of lockdep_map, used as ID */
-	char			*name;		/* for strcpy(), we cannot use const */
+	struct class_stat	*class;
 
 	int			state;
 	u64			prev_event_time; /* timestamp of previous event */
@@ -155,34 +169,89 @@ static struct lock_stat *pop_from_result(void)
 	return container_of(node, struct lock_stat, rb);
 }
 
-static struct lock_stat *lock_stat_findnew(void *addr, const char *name)
+static void class_add_lock(struct class_stat *class, struct lock_stat *lock)
+{
+	if (!class)
+		return;
+
+	/* NOTE: we may want to handle class changes in the future */
+	list_del(&lock->lock_list);
+	list_add_tail(&lock->lock_list, &class->lock_list);
+	lock->class = class;
+}
+
+static struct lock_stat *lock_stat_findnew(void *addr, struct class_stat *class)
 {
 	struct list_head *entry = lockhashentry(addr);
-	struct lock_stat *ret, *new;
+	struct lock_stat *ret;
+
+	if (class) {
+		list_for_each_entry(ret, &class->lock_list, lock_list) {
+			if (ret->addr == addr)
+				return ret;
+		}
+	}
 
 	list_for_each_entry(ret, entry, hash_entry) {
-		if (ret->addr == addr)
+		if (ret->addr == addr) {
+			class_add_lock(class, ret);
 			return ret;
+		}
 	}
 
-	new = zalloc(sizeof(struct lock_stat));
-	if (!new)
+	ret = zalloc(sizeof(struct lock_stat));
+	if (!ret)
 		goto alloc_failed;
 
-	new->addr = addr;
-	new->name = zalloc(sizeof(char) * strlen(name) + 1);
-	if (!new->name)
-		goto alloc_failed;
-	strcpy(new->name, name);
+	ret->addr = addr;
+	INIT_LIST_HEAD(&ret->lock_list);
+	class_add_lock(class, ret);
 
 	/* LOCK_STATE_UNLOCKED == 0 isn't guaranteed forever */
-	new->state = LOCK_STATE_UNLOCKED;
-	new->wait_time_min = ULLONG_MAX;
+	ret->state = LOCK_STATE_UNLOCKED;
+	ret->wait_time_min = ULLONG_MAX;
+
+	list_add_tail(&ret->hash_entry, entry);
+
+	return ret;
 
-	list_add(&new->hash_entry, entry);
-	return new;
+ alloc_failed:
+	die("memory allocation failed\n");
+}
+
+static struct class_stat *class_stat_findnew(void *addr, const char *name)
+{
+	struct list_head *entry = classhashentry(addr);
+	struct class_stat *ret;
+
+	list_for_each_entry(ret, entry, hash_entry) {
+		if (ret->addr == addr) {
+			if (!ret->name && name) {
+				ret->name = strdup(name);
+				if (!ret->name)
+					goto alloc_failed;
+			}
+			return ret;
+		}
+	}
+
+	ret = zalloc(sizeof(struct class_stat));
+	if (!ret)
+		goto alloc_failed;
+
+	ret->addr = addr;
+	INIT_LIST_HEAD(&ret->lock_list);
+	if (name) {
+		ret->name = strdup(name);
+		if (!ret->name)
+			goto alloc_failed;
+	}
+
+	list_add_tail(&ret->hash_entry, entry);
 
-alloc_failed:
+	return ret;
+
+ alloc_failed:
 	die("memory allocation failed\n");
 }
 
@@ -195,23 +264,29 @@ struct raw_event_sample {
 	char			data[0];
 };
 
+/*
+ * For now we keep the below as is with only one field.
+ * These structures may be filled further
+ */
 struct trace_acquire_event {
 	void			*addr;
-	const char		*name;
+	void			*class_id;
 };
 
 struct trace_acquired_event {
 	void			*addr;
-	const char		*name;
 };
 
 struct trace_contended_event {
 	void			*addr;
-	const char		*name;
 };
 
 struct trace_release_event {
 	void			*addr;
+};
+
+struct trace_init_event {
+	void			*class_id;
 	const char		*name;
 };
 
@@ -239,6 +314,12 @@ struct trace_lock_handler {
 			      int cpu,
 			      u64 timestamp,
 			      struct thread *thread);
+
+	void (*init_event)(struct trace_init_event *,
+			      struct event *,
+			      int cpu,
+			      u64 timestamp,
+			      struct thread *thread);
 };
 
 static void
@@ -248,11 +329,13 @@ report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 			u64 timestamp,
 			struct thread *thread __used)
 {
-	struct lock_stat *st;
+	struct class_stat *class;
+	struct lock_stat *lock;
 
-	st = lock_stat_findnew(acquire_event->addr, acquire_event->name);
+	class = class_stat_findnew(acquire_event->class_id, NULL);
+	lock = lock_stat_findnew(acquire_event->addr, class);
 
-	switch (st->state) {
+	switch (lock->state) {
 	case LOCK_STATE_UNLOCKED:
 		break;
 	case LOCK_STATE_LOCKED:
@@ -262,7 +345,7 @@ report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 		break;
 	}
 
-	st->prev_event_time = timestamp;
+	lock->prev_event_time = timestamp;
 }
 
 static void
@@ -274,7 +357,7 @@ report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 {
 	struct lock_stat *st;
 
-	st = lock_stat_findnew(acquired_event->addr, acquired_event->name);
+	st = lock_stat_findnew(acquired_event->addr, NULL);
 
 	switch (st->state) {
 	case LOCK_STATE_UNLOCKED:
@@ -300,7 +383,7 @@ report_lock_contended_event(struct trace_contended_event *contended_event,
 {
 	struct lock_stat *st;
 
-	st = lock_stat_findnew(contended_event->addr, contended_event->name);
+	st = lock_stat_findnew(contended_event->addr, NULL);
 
 	switch (st->state) {
 	case LOCK_STATE_UNLOCKED:
@@ -326,7 +409,7 @@ report_lock_release_event(struct trace_release_event *release_event,
 	struct lock_stat *st;
 	u64 hold_time;
 
-	st = lock_stat_findnew(release_event->addr, release_event->name);
+	st = lock_stat_findnew(release_event->addr, NULL);
 
 	switch (st->state) {
 	case LOCK_STATE_UNLOCKED:
@@ -357,6 +440,16 @@ end:
 	st->prev_event_time = timestamp;
 }
 
+static void
+report_lock_class_init_event(struct trace_init_event *init_event,
+			struct event *__event __used,
+			int cpu __used,
+			u64 timestamp __used,
+			struct thread *thread __used)
+{
+	class_stat_findnew(init_event->class_id, init_event->name);
+}
+
 /* lock oriented handlers */
 /* TODO: handlers for CPU oriented, thread oriented */
 static struct trace_lock_handler report_lock_ops  = {
@@ -364,6 +457,7 @@ static struct trace_lock_handler report_lock_ops  = {
 	.acquired_event		= report_lock_acquired_event,
 	.contended_event	= report_lock_contended_event,
 	.release_event		= report_lock_release_event,
+	.init_event		= report_lock_class_init_event,
 };
 
 static struct trace_lock_handler *trace_handler;
@@ -380,7 +474,8 @@ process_lock_acquire_event(void *data,
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&acquire_event.addr, &tmp, sizeof(void *));
-	acquire_event.name = (char *)raw_field_ptr(event, "name", data);
+	tmp = raw_field_value(event, "class_id", data);
+	memcpy(&acquire_event.class_id, &tmp, sizeof(void *));
 
 	if (trace_handler->acquire_event)
 		trace_handler->acquire_event(&acquire_event, event, cpu, timestamp, thread);
@@ -398,7 +493,6 @@ process_lock_acquired_event(void *data,
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&acquired_event.addr, &tmp, sizeof(void *));
-	acquired_event.name = (char *)raw_field_ptr(event, "name", data);
 
 	if (trace_handler->acquire_event)
 		trace_handler->acquired_event(&acquired_event, event, cpu, timestamp, thread);
@@ -416,7 +510,6 @@ process_lock_contended_event(void *data,
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&contended_event.addr, &tmp, sizeof(void *));
-	contended_event.name = (char *)raw_field_ptr(event, "name", data);
 
 	if (trace_handler->acquire_event)
 		trace_handler->contended_event(&contended_event, event, cpu, timestamp, thread);
@@ -434,13 +527,30 @@ process_lock_release_event(void *data,
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&release_event.addr, &tmp, sizeof(void *));
-	release_event.name = (char *)raw_field_ptr(event, "name", data);
 
 	if (trace_handler->acquire_event)
 		trace_handler->release_event(&release_event, event, cpu, timestamp, thread);
 }
 
 static void
+process_lock_class_init_event(void *data,
+			struct event *event __used,
+			int cpu __used,
+			u64 timestamp __used,
+			struct thread *thread __used)
+{
+	struct trace_init_event init_event;
+	u64 tmp;
+
+	tmp = raw_field_value(event, "class_id", data);
+	memcpy(&init_event.class_id, &tmp, sizeof(void *));
+	init_event.name = (char *)raw_field_ptr(event, "class_name", data);
+
+	if (trace_handler->init_event)
+		trace_handler->init_event(&init_event, event, cpu, timestamp, thread);
+}
+
+static void
 process_raw_event(void *data, int cpu,
 		  u64 timestamp, struct thread *thread)
 {
@@ -458,6 +568,8 @@ process_raw_event(void *data, int cpu,
 		process_lock_contended_event(data, event, cpu, timestamp, thread);
 	if (!strcmp(event->name, "lock_release"))
 		process_lock_release_event(data, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "lock_class_init"))
+		process_lock_class_init_event(data, event, cpu, timestamp, thread);
 }
 
 static int process_sample_event(event_t *event, struct perf_session *session)
@@ -503,15 +615,23 @@ static void print_result(void)
 	printf("\n\n");
 
 	while ((st = pop_from_result())) {
+		char *name;
 		bzero(cut_name, 20);
 
 		printf("%p ", st->addr);
 
-		if (strlen(st->name) < 16) {
+		if (!st->class)
+			name = (char *)"<unknown>";
+		else if (!st->class->name)
+			name = (char *)"<unknown2>";
+		else
+			name = st->class->name;
+
+		if (strlen(name) < 16) {
 			/* output raw name */
-			printf("%20s ", st->name);
+			printf("%20s ", name);
 		} else {
-			strncpy(cut_name, st->name, 16);
+			strncpy(cut_name, name, 16);
 			cut_name[16] = '.';
 			cut_name[17] = '.';
 			cut_name[18] = '.';
@@ -533,12 +653,18 @@ static void print_result(void)
 
 static void dump_map(void)
 {
+	char *name;
 	unsigned int i;
 	struct lock_stat *st;
 
 	for (i = 0; i < LOCKHASH_SIZE; i++) {
 		list_for_each_entry(st, &lockhash_table[i], hash_entry) {
-			printf("%p: %s\n", st->addr, st->name);
+			if (!st->class || !st->class->name)
+				name = (char *)"<unknown>";
+			else
+				name = st->class->name;
+
+			printf("%p: %s\n", st->addr, name);
 		}
 	}
 }
@@ -612,6 +738,7 @@ static const char *record_args[] = {
 	"-f",
 	"-m", "1024",
 	"-c", "1",
+	"-e", "lock:lock_class_init:r",
 	"-e", "lock:lock_acquire:r",
 	"-e", "lock:lock_acquired:r",
 	"-e", "lock:lock_contended:r",
@@ -644,6 +771,8 @@ int cmd_lock(int argc, const char **argv, const char *prefix __used)
 	symbol__init();
 	for (i = 0; i < LOCKHASH_SIZE; i++)
 		INIT_LIST_HEAD(lockhash_table + i);
+	for (i = 0; i < LOCKHASH_SIZE; i++)
+		INIT_LIST_HEAD(classhash_table + i);
 
 	argc = parse_options(argc, argv, lock_options, lock_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
-- 
1.6.2.3

