Return-Path: <linux-kernel-owner+w=401wt.eu-S1752219AbZLTC5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbZLTC5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 21:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbZLTC5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 21:57:50 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59061 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZLTC5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 21:57:49 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf lock: Implement basic sorting function of perf lock
Date: Sun, 20 Dec 2009 11:56:45 +0900
Message-Id: <1261277805-27023-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now perf lock can sort result based on the attribute
specified by user.

Basic strategy of caliculating and sorting is like this:
1) Gathering stat information of lock instances into hashlist,
   and caliculate attributes with state machine.
2) Popping stat from hash list, pushing it into rbtree
   based on the key which user specified(e.g. wait time total, contended num)
3) Popping left most node of rbtree, print it, and iterate this step
   till rbtree becomes empty

Example of use:
| % perf lock prof                  # default key to sort is how many acquired
|                 ID                 Name   acquired  contended total wait (ns)   max wait (ns)   min wait (ns)
|
| 0xffff8800b93e5348                  key      96300      14384       108261953           11630               0
| 0xffff8800a46b78e8      &sem->wait_lock       6663          0        13123757           12145            1324
| 0xffff8800a46b7d98  &inode->i_data.t...       6312          0        28060235           21045            1379
| 0xffff8800a46b7920  &(&ip->i_lock)->...       3330          0        15588899         3930812            1465
| 0xffff8800a46b7e70  &inode->i_data.p...       3161          0        11336333         1110293            1358
| 0xffff8800bf002858  &parent->list_lo...       1992        117         4344197            8475              19
| ...
|
| % perf lock prof --key wait_total # which lock is most waited totally?
|                 ID                 Name   acquired  contended total wait (ns)   max wait (ns)   min wait (ns)
|
| 0xffff880058d1ee28  &event->child_mu...          1          0      4698426795      4698426795      4698426795
| 0xffff88005b9556f8        &mm->mmap_sem        168          0       210647186        33994947            1432
| 0xffff8800b93e5348                  key      96300      14384       108261953           11630               0
| 0xffff8800a46b7d98  &inode->i_data.t...       6312          0        28060235           21045            1379
| 0xffffffff817bb398          dcache_lock        845          0        26993039         4087405            1337
| 0xffff8800a46b7c98  &sb->s_type->i_m...         61          0        18145694         6341240            2926
| ...

And this patch implements "map" subcommand.
Some names of lock instances are too long,
so I cut off such name (over 16 chars) in output.
(e.g. "&inode->i_data.tree_lock" -> "&inode->i_data.t...")
"map" dumps the table of corresponding between
ID (address of lockdep_map) and name.
User can grep by ID the output of "map"
and can determine the name of ID who focusing on.

I still have a lot of TODOs and FIXMEs,
but it's good timing to push into perf/lock of tip tree.
Could you appli it, Ingo?

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-lock.c |  437 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 358 insertions(+), 79 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index ca898c8..0c36abd 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -15,24 +15,43 @@
 
 #include <sys/types.h>
 #include <sys/prctl.h>
-
 #include <semaphore.h>
 #include <pthread.h>
 #include <math.h>
-
 #include <limits.h>
 
-/*
- * FIXME and TODO:
- * At least, hash table should be used here.
- * Ideally, numeric ID for each lock instance is desired.
- */
+#include <linux/list.h>
+#include <linux/hash.h>
+
+/* based on kernel/lockdep.c */
+#define MAX_LOCKDEP_KEYS_BITS	13
+#define LOCKHASH_BITS		(MAX_LOCKDEP_KEYS_BITS - 1)
+#define LOCKHASH_SIZE		(1UL << LOCKHASH_BITS)
+
+static struct list_head lockhash_table[LOCKHASH_SIZE];
+
+#define __lockhashfn(key)	hash_long((unsigned long)key, LOCKHASH_BITS)
+#define lockhashentry(key)	(lockhash_table + __lockhashfn((key)))
+
+#define LOCK_STATE_UNLOCKED 0	       /* initial state */
+#define LOCK_STATE_LOCKED 1
+
 struct lock_stat {
-	char *name;		       /* for strcpy(), we cannot use const */
+	struct list_head hash_entry;
+	struct rb_node rb;	/* used for sorting */
+
+	/* FIXME: raw_field_value() returns unsigned long long,
+	 * so address of lockdep_map should be dealed as 64bit.
+	 * Is there more better solution? */
+	void *addr;	       /* address of lockdep_map, used as ID */
+	char *name;	       /* for strcpy(), we cannot use const */
+	int state;
+	u64 prev_event_time;	/* timestamp of previous event */
 
 	unsigned int nr_acquired;
+	unsigned int nr_acquire;
 	unsigned int nr_contended;
-	/* nr_contended - nr_acquired == immediate availability */
+	unsigned int nr_release;
 
 	/* these times are in nano sec. */
 	u64 wait_time_total;
@@ -40,46 +59,131 @@ struct lock_stat {
 	u64 wait_time_max;
 };
 
-static struct lock_stat lock_stat_sentinel = {
-	.name = NULL,
+/* build simple key function one is bigger than two */
+#define SINGLE_KEY(member)					\
+	static int lock_stat_key_ ## member(struct lock_stat *one,	\
+					 struct lock_stat *two)		\
+	{								\
+	if (one->member > two->member)					\
+		return 1;						\
+	else								\
+		return 0;						\
+	}
+
+SINGLE_KEY(nr_acquired)
+SINGLE_KEY(nr_contended)
+SINGLE_KEY(wait_time_total)
+SINGLE_KEY(wait_time_min)
+SINGLE_KEY(wait_time_max)
+
+struct lock_key {
+	/*
+	 * name: the value for specify by user
+	 * this should be simpler than raw name of member
+	 * e.g. nr_acquired -> acquired, wait_time_total -> wait_total
+	 */
+	const char *name;
+	int (*key)(struct lock_stat*, struct lock_stat*);
 };
 
-static struct lock_stat **lock_stats;
+static const char *sort_key = "acquired";
+static int (*compare)(struct lock_stat *, struct lock_stat *);
 
-static void lock_stats_init(void)
+#define DEF_KEY_LOCK(name, fn_suffix)	\
+	{ #name, lock_stat_key_ ## fn_suffix }
+struct lock_key keys[] = {
+	DEF_KEY_LOCK(acquired, nr_acquired),
+	DEF_KEY_LOCK(contended, nr_contended),
+	DEF_KEY_LOCK(wait_total, wait_time_total),
+	DEF_KEY_LOCK(wait_min, wait_time_min),
+	DEF_KEY_LOCK(wait_max, wait_time_max),
+
+	/* extra comparisons much complicated should be here */
+
+	{ NULL, NULL }
+};
+
+static void select_key(void)
 {
-	lock_stats = zalloc(sizeof(struct lock_stat *));
-	if (!lock_stats)
-		die("memory allocation failed\n");
-	lock_stats[0] = zalloc(sizeof(struct lock_stat));
-	if (!lock_stats[0])
-		die("memory allocation failed\n");
-	lock_stats[0] = &lock_stat_sentinel;
+	int i;
+
+	for (i = 0; keys[i].name; i++) {
+		if (!strcmp(keys[i].name, sort_key)) {
+			compare = keys[i].key;
+			return;
+		}
+	}
+
+	die("Unknown compare key:%s\n", sort_key);
 }
 
-static struct lock_stat *lock_stat_findnew(const char *name)
+static struct rb_root result;	/* place to store sorted data */
+
+static void insert_to_result(struct lock_stat *st,
+			     int (*bigger)(struct lock_stat *,
+					   struct lock_stat *))
 {
-	int i, new;
+	struct rb_node **rb = &result.rb_node;
+	struct rb_node *parent = NULL;
+	struct lock_stat *p;
+
+	while (*rb) {
+		p = container_of(*rb, struct lock_stat, rb);
+		parent = *rb;
+
+		if (bigger(st, p))
+			rb = &(*rb)->rb_left;
+		else
+			rb = &(*rb)->rb_right;
+	}
 
-	for (i = 0; lock_stats[i]->name; i++) {
-		if (!strcmp(lock_stats[i]->name, name))
-			return lock_stats[i];
+	rb_link_node(&st->rb, parent, rb);
+	rb_insert_color(&st->rb, &result);
+}
+
+/* returns left most element of result, and erase it */
+static struct lock_stat *pop_from_result(void)
+{
+	struct rb_node *node = result.rb_node;
+
+	if (!node)
+		return NULL;
+
+	while (node->rb_left)
+		node = node->rb_left;
+
+	rb_erase(node, &result);
+	return container_of(node, struct lock_stat, rb);
+}
+
+static struct lock_stat *lock_stat_findnew(void *addr, const char *name)
+{
+	struct list_head *entry = lockhashentry(addr);
+	struct lock_stat *ret, *new;
+
+	list_for_each_entry(ret, entry, hash_entry) {
+		if (ret->addr == addr)
+			return ret;
 	}
 
-	new = i;
-	lock_stats = xrealloc(lock_stats,
-			      sizeof(struct lock_stats *) * (i + 2));
-	lock_stats[new] = calloc(sizeof(struct lock_stat), 1);
-	if (!lock_stats[new])
-		die("memory allocation failed\n");
-	lock_stats[new]->name = calloc(sizeof(char), strlen(name) + 1);
-	if (!lock_stats[new]->name)
-		die("memory allocation failed\n");
-	strcpy(lock_stats[new]->name, name);
-	lock_stats[new]->wait_time_min = ULLONG_MAX;
-
-	lock_stats[i + 1] = &lock_stat_sentinel;
-	return lock_stats[new];
+	new = zalloc(sizeof(struct lock_stat));
+	if (!new)
+		goto alloc_failed;
+
+	new->addr = addr;
+	new->name = zalloc(sizeof(char) * strlen(name) + 1);
+	if (!new->name)
+		goto alloc_failed;
+	strcpy(new->name, name);
+	/* LOCK_STATE_UNLOCKED == 0 isn't guaranteed forever */
+	new->state = LOCK_STATE_UNLOCKED;
+	new->wait_time_min = ULLONG_MAX;
+
+	list_add(&new->hash_entry, entry);
+	return new;
+
+alloc_failed:
+	die("memory allocation failed\n");
 }
 
 static char			const *input_name = "perf.data";
@@ -95,19 +199,22 @@ struct raw_event_sample {
 };
 
 struct trace_acquire_event {
+	void *addr;
 	const char *name;
 };
 
 struct trace_acquired_event {
+	void *addr;
 	const char *name;
-	u64 wait_time;		       /* in nano sec. */
 };
 
 struct trace_contended_event {
+	void *addr;
 	const char *name;
 };
 
 struct trace_release_event {
+	void *addr;
 	const char *name;
 };
 
@@ -137,52 +244,116 @@ struct trace_lock_handler {
 			      struct thread *thread);
 };
 
-static void prof_lock_acquire_event(struct trace_acquire_event *acquire_event __used,
+static void prof_lock_acquire_event(struct trace_acquire_event *acquire_event,
 			struct event *__event __used,
 			int cpu __used,
-			u64 timestamp __used,
+			u64 timestamp,
 			struct thread *thread __used)
 {
+	struct lock_stat *st;
+
+	st = lock_stat_findnew(acquire_event->addr, acquire_event->name);
+
+	switch (st->state) {
+	case LOCK_STATE_UNLOCKED:
+		break;
+	case LOCK_STATE_LOCKED:
+		break;
+	default:
+		BUG_ON(1);
+		break;
+	}
+
+	st->prev_event_time = timestamp;
 }
 
 static void prof_lock_acquired_event(struct trace_acquired_event *acquired_event,
 			 struct event *__event __used,
 			 int cpu __used,
-			 u64 timestamp __used,
+			 u64 timestamp,
 			 struct thread *thread __used)
 {
 	struct lock_stat *st;
 
-	st = lock_stat_findnew(acquired_event->name);
-	st->nr_acquired++;
-
-	if (acquired_event->wait_time != 0) {
-		st->wait_time_total += acquired_event->wait_time;
-		if (st->wait_time_max < acquired_event->wait_time)
-			st->wait_time_max = acquired_event->wait_time;
-		else if (st->wait_time_min > acquired_event->wait_time)
-			st->wait_time_min = acquired_event->wait_time;
+	st = lock_stat_findnew(acquired_event->addr, acquired_event->name);
+
+	switch (st->state) {
+	case LOCK_STATE_UNLOCKED:
+		st->state = LOCK_STATE_LOCKED;
+		st->nr_acquired++;
+		break;
+	case LOCK_STATE_LOCKED:
+		break;
+	default:
+		BUG_ON(1);
+		break;
 	}
+
+	st->prev_event_time = timestamp;
 }
 
 static void prof_lock_contended_event(struct trace_contended_event *contended_event,
 			  struct event *__event __used,
 			  int cpu __used,
-			  u64 timestamp __used,
+			  u64 timestamp,
 			  struct thread *thread __used)
 {
 	struct lock_stat *st;
 
-	st = lock_stat_findnew(contended_event->name);
-	st->nr_contended++;
+	st = lock_stat_findnew(contended_event->addr, contended_event->name);
+
+	switch (st->state) {
+	case LOCK_STATE_UNLOCKED:
+		break;
+	case LOCK_STATE_LOCKED:
+		st->nr_contended++;
+		break;
+	default:
+		BUG_ON(1);
+		break;
+	}
+
+	st->prev_event_time = timestamp;
 }
 
-static void prof_lock_release_event(struct trace_release_event *release_event __used,
+static void prof_lock_release_event(struct trace_release_event *release_event,
 			struct event *__event __used,
 			int cpu __used,
-			u64 timestamp __used,
+			u64 timestamp,
 			struct thread *thread __used)
 {
+	struct lock_stat *st;
+	u64 hold_time;
+
+	st = lock_stat_findnew(release_event->addr, release_event->name);
+
+	switch (st->state) {
+	case LOCK_STATE_UNLOCKED:
+		break;
+	case LOCK_STATE_LOCKED:
+		st->state = LOCK_STATE_UNLOCKED;
+		hold_time = timestamp - st->prev_event_time;
+
+		if (timestamp < st->prev_event_time) {
+			/* terribly, this can happen... */
+			goto end;
+		}
+
+		if (st->wait_time_min > hold_time)
+			st->wait_time_min = hold_time;
+		if (st->wait_time_max < hold_time)
+			st->wait_time_max = hold_time;
+		st->wait_time_total += hold_time;
+
+		st->nr_release++;
+		break;
+	default:
+		BUG_ON(1);
+		break;
+	}
+
+end:
+	st->prev_event_time = timestamp;
 }
 
 /* lock oriented handlers */
@@ -203,6 +374,17 @@ process_lock_acquire_event(struct raw_event_sample *raw __used,
 			   u64 timestamp __used,
 			   struct thread *thread __used)
 {
+	struct trace_acquire_event acquire_event;
+	u64 tmp;		/* this is required for casting... */
+
+	tmp = raw_field_value(event, "lockdep_addr", raw->data);
+	acquire_event.addr = (void *)tmp;
+	acquire_event.name = (char *)raw_field_ptr(event, "name", raw->data);
+
+	if (trace_handler->acquire_event) {
+		trace_handler->acquire_event(&acquire_event,
+					     event, cpu, timestamp, thread);
+	}
 }
 
 static void
@@ -213,14 +395,11 @@ process_lock_acquired_event(struct raw_event_sample *raw __used,
 			    struct thread *thread __used)
 {
 	struct trace_acquired_event acquired_event;
+	u64 tmp;		/* this is required for casting... */
 
+	tmp = raw_field_value(event, "lockdep_addr", raw->data);
+	acquired_event.addr = (void *)tmp;
 	acquired_event.name = (char *)raw_field_ptr(event, "name", raw->data);
-	acquired_event.wait_time =
-		(unsigned long)raw_field_value(event, "wait_usec", raw->data)
-		* 1000;
-	acquired_event.wait_time +=
-		(unsigned long)raw_field_value(event,
-					      "wait_nsec_rem", raw->data);
 
 	if (trace_handler->acquire_event) {
 		trace_handler->acquired_event(&acquired_event,
@@ -235,6 +414,17 @@ process_lock_contended_event(struct raw_event_sample *raw __used,
 			     u64 timestamp __used,
 			     struct thread *thread __used)
 {
+	struct trace_contended_event contended_event;
+	u64 tmp;		/* this is required for casting... */
+
+	tmp = raw_field_value(event, "lockdep_addr", raw->data);
+	contended_event.addr = (void *)tmp;
+	contended_event.name = (char *)raw_field_ptr(event, "name", raw->data);
+
+	if (trace_handler->acquire_event) {
+		trace_handler->contended_event(&contended_event,
+					     event, cpu, timestamp, thread);
+	}
 }
 
 static void
@@ -244,6 +434,17 @@ process_lock_release_event(struct raw_event_sample *raw __used,
 			   u64 timestamp __used,
 			   struct thread *thread __used)
 {
+	struct trace_release_event release_event;
+	u64 tmp;		/* this is required for casting... */
+
+	tmp = raw_field_value(event, "lockdep_addr", raw->data);
+	release_event.addr = (void *)tmp;
+	release_event.name = (char *)raw_field_ptr(event, "name", raw->data);
+
+	if (trace_handler->acquire_event) {
+		trace_handler->release_event(&release_event,
+					     event, cpu, timestamp, thread);
+	}
 }
 
 static void
@@ -333,24 +534,61 @@ static int sample_type_check(u64 type)
 	return 0;
 }
 
-/* TODO: various way to print */
+/* TODO: various way to print, coloring, nano or milli sec */
 static void print_result(void)
 {
-	int i;
+	struct lock_stat *st;
+	char cut_name[20];
+
+	printf("%18s ", "ID");
+	printf("%20s ", "Name");
+	printf("%10s ", "acquired");
+	printf("%10s ", "contended");
+
+	printf("%15s ", "total wait (ns)");
+	printf("%15s ", "max wait (ns)");
+	printf("%15s ", "min wait (ns)");
+
+	printf("\n\n");
+
+	while ((st = pop_from_result())) {
+		bzero(cut_name, 20);
+
+		printf("%p ", st->addr);
+
+		if (strlen(st->name) < 16) {
+			/* output raw name */
+			printf("%20s ", st->name);
+		} else {
+			strncpy(cut_name, st->name, 16);
+			cut_name[16] = '.';
+			cut_name[17] = '.';
+			cut_name[18] = '.';
+			cut_name[19] = '\0';
+			/* cut off name for saving output style */
+			printf("%20s ", cut_name);
+		}
+
+		printf("%10u ", st->nr_acquired);
+		printf("%10u ", st->nr_contended);
+
+		printf("%15llu ", st->wait_time_total);
+		printf("%15llu ", st->wait_time_max);
+		printf("%15llu ", st->wait_time_min == ULLONG_MAX ?
+		       0 : st->wait_time_min);
+		printf("\n");
+	}
+}
+
+static void dump_map(void)
+{
+	unsigned int i;
+	struct lock_stat *st;
 
-	/* FIXME: formatting output is very rough */
-	printf("\n ------------------------------------------------------------------------------------------\n");
-	printf("  Lock                           |   Acquired   | Max wait ns | Min wait ns | Total wait ns |\n");
-	printf(" --------------------------------------------------------------------------------------------\n");
-
-	for (i = 0; lock_stats[i]->name; i++) {
-		printf("%32s %13u %13llu %13llu %15llu\n",
-		       lock_stats[i]->name,
-		       lock_stats[i]->nr_acquired,
-		       lock_stats[i]->wait_time_max,
-		       lock_stats[i]->wait_time_min == ULLONG_MAX ?
-		       0 : lock_stats[i]->wait_time_min,
-		       lock_stats[i]->wait_time_total);
+	for (i = 0; i < LOCKHASH_SIZE; i++) {
+		list_for_each_entry(st, &lockhash_table[i], hash_entry) {
+			printf("%p: %s\n", st->addr, st->name);
+		}
 	}
 }
 
@@ -368,14 +606,39 @@ static int read_events(void)
 				       &event__cwdlen, &event__cwd);
 }
 
+static void sort_result(void)
+{
+	unsigned int i;
+	struct lock_stat *st;
+
+	for (i = 0; i < LOCKHASH_SIZE; i++) {
+		list_for_each_entry(st, &lockhash_table[i], hash_entry) {
+			insert_to_result(st, compare);
+		}
+	}
+}
+
 static void __cmd_prof(void)
 {
 	setup_pager();
-	lock_stats_init();
+	select_key();
 	read_events();
+	sort_result();
 	print_result();
 }
 
+static const char * const prof_usage[] = {
+	"perf sched prof [<options>]",
+	NULL
+};
+
+static const struct option prof_options[] = {
+	OPT_STRING('k', "key", &sort_key, "acquired",
+		    "key for sorting"),
+	/* TODO: type */
+	OPT_END()
+};
+
 static const char * const lock_usage[] = {
 	"perf lock [<options>] {record|trace|prof}",
 	NULL
@@ -426,7 +689,11 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_lock(int argc, const char **argv, const char *prefix __used)
 {
+	unsigned int i;
+
 	symbol__init(0);
+	for (i = 0; i < LOCKHASH_SIZE; i++)
+		INIT_LIST_HEAD(lockhash_table + i);
 
 	argc = parse_options(argc, argv, lock_options, lock_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
@@ -437,10 +704,22 @@ int cmd_lock(int argc, const char **argv, const char *prefix __used)
 		return __cmd_record(argc, argv);
 	} else if (!strncmp(argv[0], "prof", 4)) {
 		trace_handler = &prof_lock_ops;
+		if (argc) {
+			argc = parse_options(argc, argv,
+					     prof_options, prof_usage, 0);
+			if (argc)
+				usage_with_options(prof_usage, prof_options);
+		}
 		__cmd_prof();
 	} else if (!strcmp(argv[0], "trace")) {
 		/* Aliased to 'perf trace' */
 		return cmd_trace(argc, argv, prefix);
+	} else if (!strcmp(argv[0], "map")) {
+		/* recycling prof_lock_ops */
+		trace_handler = &prof_lock_ops;
+		setup_pager();
+		read_events();
+		dump_map();
 	} else {
 		usage_with_options(lock_usage, lock_options);
 	}
-- 
1.6.5.2

