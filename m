Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211Ab0AaIdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0AaIdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 03:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836Ab0AaIdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 03:33:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:51310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab0AaIdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 03:33:09 -0500
Date: Sun, 31 Jan 2010 08:32:16 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264851813-8413-12-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264851813-8413-12-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Clean up various details
Message-ID: <tip-59f411b62c9282891274e721fea29026b0eda3cc@git.kernel.org>
Git-Commit-ID: 59f411b62c9282891274e721fea29026b0eda3cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 31 Jan 2010 08:32:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59f411b62c9282891274e721fea29026b0eda3cc
Gitweb:     http://git.kernel.org/tip/59f411b62c9282891274e721fea29026b0eda3cc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 31 Jan 2010 08:27:58 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 31 Jan 2010 09:08:27 +0100

perf lock: Clean up various details

Fix up a few small stylistic details:

 - use consistent vertical spacing/alignment
 - remove line80 artifacts
 - group some global variables better
 - remove dead code

Plus rename 'prof' to 'report' to make it more in line with other
tools, and remove the line/file keying as we really want to use
IPs like the other tools do.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1264851813-8413-12-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-lock.c |  210 ++++++++++++++++++---------------------------
 1 files changed, 82 insertions(+), 128 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 2b5f887..fb9ab2a 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -32,37 +32,37 @@ static struct list_head lockhash_table[LOCKHASH_SIZE];
 #define __lockhashfn(key)	hash_long((unsigned long)key, LOCKHASH_BITS)
 #define lockhashentry(key)	(lockhash_table + __lockhashfn((key)))
 
-#define LOCK_STATE_UNLOCKED 0	       /* initial state */
-#define LOCK_STATE_LOCKED 1
+#define LOCK_STATE_UNLOCKED	0	       /* initial state */
+#define LOCK_STATE_LOCKED	1
 
 struct lock_stat {
-	struct list_head hash_entry;
-	struct rb_node rb;	/* used for sorting */
+	struct list_head	hash_entry;
+	struct rb_node		rb;		/* used for sorting */
 
-	/* FIXME: raw_field_value() returns unsigned long long,
+	/*
+	 * FIXME: raw_field_value() returns unsigned long long,
 	 * so address of lockdep_map should be dealed as 64bit.
-	 * Is there more better solution? */
-	void *addr;	       /* address of lockdep_map, used as ID */
-	char *name;	       /* for strcpy(), we cannot use const */
-	char *file;
-	unsigned int line;
+	 * Is there more better solution?
+	 */
+	void			*addr;		/* address of lockdep_map, used as ID */
+	char			*name;		/* for strcpy(), we cannot use const */
 
-	int state;
-	u64 prev_event_time;	/* timestamp of previous event */
+	int			state;
+	u64			prev_event_time; /* timestamp of previous event */
 
-	unsigned int nr_acquired;
-	unsigned int nr_acquire;
-	unsigned int nr_contended;
-	unsigned int nr_release;
+	unsigned int		nr_acquired;
+	unsigned int		nr_acquire;
+	unsigned int		nr_contended;
+	unsigned int		nr_release;
 
 	/* these times are in nano sec. */
-	u64 wait_time_total;
-	u64 wait_time_min;
-	u64 wait_time_max;
+	u64			wait_time_total;
+	u64			wait_time_min;
+	u64			wait_time_max;
 };
 
 /* build simple key function one is bigger than two */
-#define SINGLE_KEY(member)					\
+#define SINGLE_KEY(member)						\
 	static int lock_stat_key_ ## member(struct lock_stat *one,	\
 					 struct lock_stat *two)		\
 	{								\
@@ -81,12 +81,15 @@ struct lock_key {
 	 * this should be simpler than raw name of member
 	 * e.g. nr_acquired -> acquired, wait_time_total -> wait_total
 	 */
-	const char *name;
-	int (*key)(struct lock_stat*, struct lock_stat*);
+	const char		*name;
+	int			(*key)(struct lock_stat*, struct lock_stat*);
 };
 
-static const char *sort_key = "acquired";
-static int (*compare)(struct lock_stat *, struct lock_stat *);
+static const char		*sort_key = "acquired";
+
+static int			(*compare)(struct lock_stat *, struct lock_stat *);
+
+static struct rb_root		result;	/* place to store sorted data */
 
 #define DEF_KEY_LOCK(name, fn_suffix)	\
 	{ #name, lock_stat_key_ ## fn_suffix }
@@ -116,11 +119,8 @@ static void select_key(void)
 	die("Unknown compare key:%s\n", sort_key);
 }
 
-static struct rb_root result;	/* place to store sorted data */
-
 static void insert_to_result(struct lock_stat *st,
-			     int (*bigger)(struct lock_stat *,
-					   struct lock_stat *))
+			     int (*bigger)(struct lock_stat *, struct lock_stat *))
 {
 	struct rb_node **rb = &result.rb_node;
 	struct rb_node *parent = NULL;
@@ -155,8 +155,7 @@ static struct lock_stat *pop_from_result(void)
 	return container_of(node, struct lock_stat, rb);
 }
 
-static struct lock_stat *lock_stat_findnew(void *addr, const char *name,
-					   const char *file, unsigned int line)
+static struct lock_stat *lock_stat_findnew(void *addr, const char *name)
 {
 	struct list_head *entry = lockhashentry(addr);
 	struct lock_stat *ret, *new;
@@ -175,11 +174,6 @@ static struct lock_stat *lock_stat_findnew(void *addr, const char *name,
 	if (!new->name)
 		goto alloc_failed;
 	strcpy(new->name, name);
-	new->file = zalloc(sizeof(char) * strlen(file) + 1);
-	if (!new->file)
-		goto alloc_failed;
-	strcpy(new->file, file);
-	new->line = line;
 
 	/* LOCK_STATE_UNLOCKED == 0 isn't guaranteed forever */
 	new->state = LOCK_STATE_UNLOCKED;
@@ -197,36 +191,28 @@ static char			const *input_name = "perf.data";
 static int			profile_cpu = -1;
 
 struct raw_event_sample {
-	u32 size;
-	char data[0];
+	u32			size;
+	char			data[0];
 };
 
 struct trace_acquire_event {
-	void *addr;
-	const char *name;
-	const char *file;
-	unsigned int line;
+	void			*addr;
+	const char		*name;
 };
 
 struct trace_acquired_event {
-	void *addr;
-	const char *name;
-	const char *file;
-	unsigned int line;
+	void			*addr;
+	const char		*name;
 };
 
 struct trace_contended_event {
-	void *addr;
-	const char *name;
-	const char *file;
-	unsigned int line;
+	void			*addr;
+	const char		*name;
 };
 
 struct trace_release_event {
-	void *addr;
-	const char *name;
-	const char *file;
-	unsigned int line;
+	void			*addr;
+	const char		*name;
 };
 
 struct trace_lock_handler {
@@ -255,7 +241,8 @@ struct trace_lock_handler {
 			      struct thread *thread);
 };
 
-static void prof_lock_acquire_event(struct trace_acquire_event *acquire_event,
+static void
+report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 			struct event *__event __used,
 			int cpu __used,
 			u64 timestamp,
@@ -263,8 +250,7 @@ static void prof_lock_acquire_event(struct trace_acquire_event *acquire_event,
 {
 	struct lock_stat *st;
 
-	st = lock_stat_findnew(acquire_event->addr, acquire_event->name,
-			       acquire_event->file, acquire_event->line);
+	st = lock_stat_findnew(acquire_event->addr, acquire_event->name);
 
 	switch (st->state) {
 	case LOCK_STATE_UNLOCKED:
@@ -279,7 +265,8 @@ static void prof_lock_acquire_event(struct trace_acquire_event *acquire_event,
 	st->prev_event_time = timestamp;
 }
 
-static void prof_lock_acquired_event(struct trace_acquired_event *acquired_event,
+static void
+report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 			 struct event *__event __used,
 			 int cpu __used,
 			 u64 timestamp,
@@ -287,8 +274,7 @@ static void prof_lock_acquired_event(struct trace_acquired_event *acquired_event
 {
 	struct lock_stat *st;
 
-	st = lock_stat_findnew(acquired_event->addr, acquired_event->name,
-			       acquired_event->file, acquired_event->line);
+	st = lock_stat_findnew(acquired_event->addr, acquired_event->name);
 
 	switch (st->state) {
 	case LOCK_STATE_UNLOCKED:
@@ -305,7 +291,8 @@ static void prof_lock_acquired_event(struct trace_acquired_event *acquired_event
 	st->prev_event_time = timestamp;
 }
 
-static void prof_lock_contended_event(struct trace_contended_event *contended_event,
+static void
+report_lock_contended_event(struct trace_contended_event *contended_event,
 			  struct event *__event __used,
 			  int cpu __used,
 			  u64 timestamp,
@@ -313,8 +300,7 @@ static void prof_lock_contended_event(struct trace_contended_event *contended_ev
 {
 	struct lock_stat *st;
 
-	st = lock_stat_findnew(contended_event->addr, contended_event->name,
-			       contended_event->file, contended_event->line);
+	st = lock_stat_findnew(contended_event->addr, contended_event->name);
 
 	switch (st->state) {
 	case LOCK_STATE_UNLOCKED:
@@ -330,7 +316,8 @@ static void prof_lock_contended_event(struct trace_contended_event *contended_ev
 	st->prev_event_time = timestamp;
 }
 
-static void prof_lock_release_event(struct trace_release_event *release_event,
+static void
+report_lock_release_event(struct trace_release_event *release_event,
 			struct event *__event __used,
 			int cpu __used,
 			u64 timestamp,
@@ -339,8 +326,7 @@ static void prof_lock_release_event(struct trace_release_event *release_event,
 	struct lock_stat *st;
 	u64 hold_time;
 
-	st = lock_stat_findnew(release_event->addr, release_event->name,
-			       release_event->file, release_event->line);
+	st = lock_stat_findnew(release_event->addr, release_event->name);
 
 	switch (st->state) {
 	case LOCK_STATE_UNLOCKED:
@@ -373,11 +359,11 @@ end:
 
 /* lock oriented handlers */
 /* TODO: handlers for CPU oriented, thread oriented */
-static struct trace_lock_handler prof_lock_ops  = {
-	.acquire_event		= prof_lock_acquire_event,
-	.acquired_event		= prof_lock_acquired_event,
-	.contended_event	= prof_lock_contended_event,
-	.release_event		= prof_lock_release_event,
+static struct trace_lock_handler report_lock_ops  = {
+	.acquire_event		= report_lock_acquire_event,
+	.acquired_event		= report_lock_acquired_event,
+	.contended_event	= report_lock_contended_event,
+	.release_event		= report_lock_release_event,
 };
 
 static struct trace_lock_handler *trace_handler;
@@ -395,14 +381,9 @@ process_lock_acquire_event(void *data,
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&acquire_event.addr, &tmp, sizeof(void *));
 	acquire_event.name = (char *)raw_field_ptr(event, "name", data);
-	acquire_event.file = (char *)raw_field_ptr(event, "file", data);
-	acquire_event.line =
-		(unsigned int)raw_field_value(event, "line", data);
 
-	if (trace_handler->acquire_event) {
-		trace_handler->acquire_event(&acquire_event,
-					     event, cpu, timestamp, thread);
-	}
+	if (trace_handler->acquire_event)
+		trace_handler->acquire_event(&acquire_event, event, cpu, timestamp, thread);
 }
 
 static void
@@ -418,14 +399,9 @@ process_lock_acquired_event(void *data,
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&acquired_event.addr, &tmp, sizeof(void *));
 	acquired_event.name = (char *)raw_field_ptr(event, "name", data);
-	acquired_event.file = (char *)raw_field_ptr(event, "file", data);
-	acquired_event.line =
-		(unsigned int)raw_field_value(event, "line", data);
 
-	if (trace_handler->acquire_event) {
-		trace_handler->acquired_event(&acquired_event,
-					     event, cpu, timestamp, thread);
-	}
+	if (trace_handler->acquire_event)
+		trace_handler->acquired_event(&acquired_event, event, cpu, timestamp, thread);
 }
 
 static void
@@ -441,14 +417,9 @@ process_lock_contended_event(void *data,
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&contended_event.addr, &tmp, sizeof(void *));
 	contended_event.name = (char *)raw_field_ptr(event, "name", data);
-	contended_event.file = (char *)raw_field_ptr(event, "file", data);
-	contended_event.line =
-		(unsigned int)raw_field_value(event, "line", data);
 
-	if (trace_handler->acquire_event) {
-		trace_handler->contended_event(&contended_event,
-					     event, cpu, timestamp, thread);
-	}
+	if (trace_handler->acquire_event)
+		trace_handler->contended_event(&contended_event, event, cpu, timestamp, thread);
 }
 
 static void
@@ -464,14 +435,9 @@ process_lock_release_event(void *data,
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&release_event.addr, &tmp, sizeof(void *));
 	release_event.name = (char *)raw_field_ptr(event, "name", data);
-	release_event.file = (char *)raw_field_ptr(event, "file", data);
-	release_event.line =
-		(unsigned int)raw_field_value(event, "line", data);
 
-	if (trace_handler->acquire_event) {
-		trace_handler->release_event(&release_event,
-					     event, cpu, timestamp, thread);
-	}
+	if (trace_handler->acquire_event)
+		trace_handler->release_event(&release_event, event, cpu, timestamp, thread);
 }
 
 static void
@@ -503,14 +469,6 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	event__parse_sample(event, session->sample_type, &data);
 	thread = perf_session__findnew(session, data.pid);
 
-	/*
-	 * FIXME: this causes warn on 32bit environment
-	 * because of (void *)data.ip (type of data.ip is u64)
-	 */
-/* 	dump_printf("(IP, %d): %d/%d: %p period: %llu\n", */
-/* 		    event->header.misc, */
-/* 		    data.pid, data.tid, (void *)data.ip, data.period); */
-
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -580,15 +538,14 @@ static void dump_map(void)
 
 	for (i = 0; i < LOCKHASH_SIZE; i++) {
 		list_for_each_entry(st, &lockhash_table[i], hash_entry) {
-			printf("%p: %s (src: %s, line: %u)\n",
-			       st->addr, st->name, st->file, st->line);
+			printf("%p: %s\n", st->addr, st->name);
 		}
 	}
 }
 
 static struct perf_event_ops eops = {
-	.sample	= process_sample_event,
-	.comm	= event__process_comm,
+	.sample			= process_sample_event,
+	.comm			= event__process_comm,
 };
 
 static struct perf_session *session;
@@ -614,7 +571,7 @@ static void sort_result(void)
 	}
 }
 
-static void __cmd_prof(void)
+static void __cmd_report(void)
 {
 	setup_pager();
 	select_key();
@@ -623,12 +580,12 @@ static void __cmd_prof(void)
 	print_result();
 }
 
-static const char * const prof_usage[] = {
-	"perf sched prof [<options>]",
+static const char * const report_usage[] = {
+	"perf lock report [<options>]",
 	NULL
 };
 
-static const struct option prof_options[] = {
+static const struct option report_options[] = {
 	OPT_STRING('k', "key", &sort_key, "acquired",
 		    "key for sorting"),
 	/* TODO: type */
@@ -636,17 +593,14 @@ static const struct option prof_options[] = {
 };
 
 static const char * const lock_usage[] = {
-	"perf lock [<options>] {record|trace|prof}",
+	"perf lock [<options>] {record|trace|report}",
 	NULL
 };
 
 static const struct option lock_options[] = {
-	OPT_STRING('i', "input", &input_name, "file",
-		    "input file name"),
-	OPT_BOOLEAN('v', "verbose", &verbose,
-		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
-		    "dump raw trace in ASCII"),
+	OPT_STRING('i', "input", &input_name, "file", "input file name"),
+	OPT_BOOLEAN('v', "verbose", &verbose, "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace, "dump raw trace in ASCII"),
 	OPT_END()
 };
 
@@ -698,21 +652,21 @@ int cmd_lock(int argc, const char **argv, const char *prefix __used)
 
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
-	} else if (!strncmp(argv[0], "prof", 4)) {
-		trace_handler = &prof_lock_ops;
+	} else if (!strncmp(argv[0], "report", 6)) {
+		trace_handler = &report_lock_ops;
 		if (argc) {
 			argc = parse_options(argc, argv,
-					     prof_options, prof_usage, 0);
+					     report_options, report_usage, 0);
 			if (argc)
-				usage_with_options(prof_usage, prof_options);
+				usage_with_options(report_usage, report_options);
 		}
-		__cmd_prof();
+		__cmd_report();
 	} else if (!strcmp(argv[0], "trace")) {
 		/* Aliased to 'perf trace' */
 		return cmd_trace(argc, argv, prefix);
 	} else if (!strcmp(argv[0], "map")) {
-		/* recycling prof_lock_ops */
-		trace_handler = &prof_lock_ops;
+		/* recycling report_lock_ops */
+		trace_handler = &report_lock_ops;
 		setup_pager();
 		read_events();
 		dump_map();
