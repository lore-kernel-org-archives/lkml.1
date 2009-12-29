Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZL2FYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZL2FYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZL2FYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:24:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61628 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbZL2FYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:24:07 -0500
Message-ID: <4B399205.2030302@cn.fujitsu.com>
Date: Tue, 29 Dec 2009 13:22:13 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 5/5] perf timer: add 'perf timer' core code
References: <4B27702F.1080507@cn.fujitsu.com> <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com> <4B30C3A0.909@cn.fujitsu.com> <20091228075417.GB20039@elte.hu>
In-Reply-To: <20091228075417.GB20039@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's the core code of 'perf timer', it can report number of
activated/expired/canceled timers, timer latency and timer function
runtime

Sample output:
- Record timer event:

#perf timer record
^C

- Show timer latency:
#perf timer report --print-lat
                          Timer Latency List
[ Abbreviations: Avg = average; lat = latency; ts = timestamp ]
-------------------------------------------------------------------------
     Timer     |     TYPE      | Avg-lat   ms| Max-lat   ms| Max-lat-ts s
-------------------------------------------------------------------------
swapper        |HRTIMER        |0.180        |2.404        |42722.586    
swapper        |TIMER          |2.000        |2.000        |42722.586    
events/0       |TIMER          |2.000        |2.000        |42723.002    
events/0       |TIMER          |0.000        |0.000        |42723.641    
sshd           |TIMER          |0.000        |0.000        |42723.641    

Statistics
==========
Activated timers number:
  HRTIMER: 105 TIMER: 11 ITIMER_PROF: 0 ITIMER_VIRTUAL: 0 ITIMER_REAL: 0 

Expired timers number:
  HRTIMER: 94 TIMER: 12 ITIMER_PROF: 0 ITIMER_VIRTUAL: 0 ITIMER_REAL: 0 

Canceled timers number:
  HRTIMER: 105 TIMER: 12 ITIMER_PROF: 0 ITIMER_VIRTUAL: 0 ITIMER_REAL: 0 
 
- Show timer function runtime:
#perf timer report --print-runtime
                          Timer Function Runtime List
[ Abbreviations: Avg = average; func = function; rt = runtime; ts = timestamp ]
-------------------------------------------------------------------------------
     Timer     | Type  |Avg-rt ms|Max-rt ms|      Max-rt-func      | Max-rt-ts s
-------------------------------------------------------------------------------
swapper        |HRTIMER|0.010    |0.026    |tick_sched_timer       |42722.586
0xc15f2b70     |HRTIMER|0.009    |0.009    |Not - Catch            |42722.000
swapper        |TIMER  |0.058    |0.111    |tcp_write_timer        |42721.930
events/0       |TIMER  |0.007    |0.010    |delayed_work_timer_fn  |42723.002
swapper        |TIMER  |0.037    |0.037    |dev_watchdog           |42723.002
events/0       |TIMER  |0.028    |0.028    |delayed_work_timer_fn  |42723.641
swapper        |TIMER  |0.023    |0.023    |pcnet32_watchdog       |42722.001
events/1       |TIMER  |0.014    |0.014    |Not - Catch            |42723.003
events/0       |TIMER  |0.010    |0.010    |Not - Catch            |42722.001
sshd           |TIMER  |0.009    |0.009    |delayed_work_timer_fn  |42723.641
swapper        |TIMER  |0.004    |0.004    |Not - Catch            |42721.638
events/1       |TIMER  |0.003    |0.003    |Not - Catch            |42723.003

Statistics
==========
Activated timers number:
  HRTIMER: 105 TIMER: 11 ITIMER_PROF: 0 ITIMER_VIRTUAL: 0 ITIMER_REAL: 0 

Expired timers number:
  HRTIMER: 94 TIMER: 12 ITIMER_PROF: 0 ITIMER_VIRTUAL: 0 ITIMER_REAL: 0 

Canceled timers number:
  HRTIMER: 105 TIMER: 12 ITIMER_PROF: 0 ITIMER_VIRTUAL: 0 ITIMER_REAL: 0 

- Specify types which you are interesting and choose one or more of
  "timer, hrtimer, itimer-real, itimer-virtual, itimer-prof"

#perf timer report --print-lat --type timer

                          Timer Latency List
[ Abbreviations: Avg = average; lat = latency; ts = timestamp ]
-------------------------------------------------------------------------
     Timer     |     TYPE      | Avg-lat   ms| Max-lat   ms| Max-lat-ts s
-------------------------------------------------------------------------
swapper        |TIMER          |2.000        |2.000        |42722.586    
events/0       |TIMER          |2.000        |2.000        |42723.002    
events/0       |TIMER          |0.000        |0.000        |42723.641    
sshd           |TIMER          |0.000        |0.000        |42723.641  

Changlog v1->v2:
- rename 'perf timer latency' to 'perf timer report',
  because it not only show timer latency but also show timer
  function runtime, timer activated/canceled/expired statistics
  and canceled timer list(TODO)

Below changes are all from Thomas's suggestion:
- fix a lot of typos and bad ideas

- use hash table instead of RB tree to record timer

- let output information more readable

- report number of activated/canceled/expired timers

- support to filter timer types:
  '--type' can do it

TODO:
- Show canceled timer list that is suggested by Thomas

- Any suggestion are welcome.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/Makefile         |    1 +
 tools/perf/builtin-timer.c  |  996 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h        |    1 +
 tools/perf/command-list.txt |    1 +
 tools/perf/perf.c           |    1 +
 tools/perf/util/event.h     |    7 +
 6 files changed, 1007 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/builtin-timer.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7c84642..b5bbcea 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -449,6 +449,7 @@ BUILTIN_OBJS += builtin-top.o
 BUILTIN_OBJS += builtin-trace.o
 BUILTIN_OBJS += builtin-probe.o
 BUILTIN_OBJS += builtin-kmem.o
+BUILTIN_OBJS += builtin-timer.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-timer.c b/tools/perf/builtin-timer.c
new file mode 100644
index 0000000..17db588
--- /dev/null
+++ b/tools/perf/builtin-timer.c
@@ -0,0 +1,996 @@
+#include "builtin.h"
+#include "perf.h"
+
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/header.h"
+#include "util/parse-options.h"
+#include "util/trace-event.h"
+#include "util/debug.h"
+#include "util/session.h"
+
+#include <sys/prctl.h>
+#include <semaphore.h>
+#include <pthread.h>
+#include <math.h>
+
+#include "../../include/linux/hash.h"
+
+#define SORT_KEY	"type, avg-lat, max-lat, avg-runtime, max-runtime"
+
+extern u32 inject_events;
+
+static char const *input_name = "perf.data";
+static const char *sort_order = SORT_KEY;
+static int print_lat, print_runtime, profile_cpu = -1;
+static struct perf_session *timer_session;
+static int bug_nr;
+
+enum timer_type {
+	REAL_ITIMER,
+	VIRTUAL_ITIMER,
+	PROF_ITIMER,
+	TIMER,
+	HRTIMER,
+
+	MAX_TIMER_TYPE,
+};
+
+static char const *timer_type_str[] = {
+	"ITIMER_REAL",
+	"ITIMER_VIRTUAL",
+	"ITIMER_PROF",
+	"TIMER",
+	"HRTIMER",
+};
+
+enum stat_type {
+	ACTIVATED,
+	EXPIRED,
+	CANCELED,
+
+	MAX_STATS,
+};
+
+static u32 stats[MAX_STATS][MAX_TIMER_TYPE];
+static inline void
+stats_update(enum timer_type timer_type, enum stat_type stat_type)
+{
+	stats[stat_type][timer_type]++;
+}
+
+static u32 hz;
+static inline void update_hz(u64 *nhz)
+{
+	hz = *nhz;
+}
+
+static const struct option timer_options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		   "input file name"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+static const char *const timer_usage[] = {
+	"perf timer [<options>] {record|report}",
+	NULL
+};
+
+static int filter_type;
+static int parse_type_opt(const struct option *opt __used,
+			  const char *arg, int unset __used)
+{
+	char *tok, *str = strdup(arg);
+	int ret = 0;
+
+	if (!str)
+		die("strdup");
+
+	while ((tok = strsep(&str, ",")) != NULL) {
+
+		if (!strcmp(tok, "timer"))
+			filter_type |= 1 << TIMER;
+		else if (!strcmp(tok, "hrtimer"))
+			filter_type |= 1 << HRTIMER;
+		else if (!strcmp(tok, "itimer-real"))
+			filter_type |= 1 << REAL_ITIMER;
+		else if (!strcmp(tok, "itimer-virtual"))
+			filter_type |= 1 << VIRTUAL_ITIMER;
+		else if (!strcmp(tok, "itimer-prof"))
+			filter_type |= 1 << PROF_ITIMER;
+		else {
+			printf("Unknow --type: %s\n", tok);
+			ret = -1;
+			break;
+		}
+	}
+
+	free(str);
+	return ret;
+}
+
+static const struct option report_options[] = {
+	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
+		   "sort by key(s): "SORT_KEY),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_INTEGER('C', "CPU", &profile_cpu,
+		    "CPU to profile on"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN(0, "print-lat", &print_lat, "show timer latency"),
+	OPT_BOOLEAN(0, "print-runtime", &print_runtime,
+		    "show timer function runtime"),
+	OPT_CALLBACK(0, "type", NULL, "timer types",
+		     "timer type selector, specify one or more types(timer, "
+		     "hrtimer, itimer-real, itimer-virtual, itimer-prof)",
+		     parse_type_opt),
+	OPT_END()
+};
+
+static const char *const report_usage[] = {
+	"perf timer report [<options>]",
+	NULL
+};
+
+struct timer_entry {
+	struct timer_entry *next;
+	struct rb_node node;
+
+	void			*timer;
+	enum timer_type		type;
+	u64			function;
+	struct thread		*timer_thread;
+	int expire_nr;
+	int run_func_nr;
+	int bug;
+
+	struct timer_entry	*itimer_hrtimer;
+
+	u64			timer_last_lat;
+	u64			timer_expire_ts;
+	u64			timer_total_lat;
+	double			timer_avg_lat;
+	s64			timer_max_lat;
+	u64			timer_max_lat_at_ts;
+
+	u64			func_entry_ts;
+	u64			func_total_runtime;
+	double			func_avg_runtime;
+	s64			func_max_runtime;
+	u64			func_max_runtime_at_ts;
+	u64			max_runtime_at_func;
+};
+
+typedef int (*sort_func)(struct timer_entry *, struct timer_entry *);
+struct sort_dimension {
+	const char		*name;
+	sort_func		cmp;
+	struct list_head	list;
+};
+
+#define DEFINE_CMP_FUNCTION(field)					\
+static int cmp_##field(struct timer_entry *v1, struct timer_entry *v2)	\
+{									\
+	if (v1->field < v2->field)					\
+		return -1;						\
+	if (v1->field > v2->field)					\
+		return 1;						\
+	return 0;							\
+}
+
+DEFINE_CMP_FUNCTION(type);
+DEFINE_CMP_FUNCTION(timer_avg_lat);
+DEFINE_CMP_FUNCTION(timer_max_lat);
+DEFINE_CMP_FUNCTION(func_avg_runtime);
+DEFINE_CMP_FUNCTION(func_max_runtime);
+
+#define SORT(field, _name)		\
+{	.cmp = cmp_##field,		\
+	.name = _name,			\
+}
+
+static struct sort_dimension sorts[] = {
+	SORT(type, "type"),
+	SORT(timer_avg_lat, "avg-lat"),
+	SORT(timer_max_lat, "max-lat"),
+	SORT(func_avg_runtime, "avg-runtime"),
+	SORT(func_max_runtime, "max-runtime"),
+};
+
+static int sort_dimension_add(const char *tok, struct list_head *list)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(sorts); i++) {
+		if (!strcmp(sorts[i].name, tok)) {
+			list_add_tail(&sorts[i].list, list);
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static LIST_HEAD(sort);
+static void setup_sorting(char const *sort_string)
+{
+	char *tmp, *tok, *str = strdup(sort_string);
+
+	for (tok = strtok_r(str, ",", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		if (sort_dimension_add(tok, &sort) < 0) {
+			error("Unknown --sort key: `%s'", tok);
+			usage_with_options(report_usage, report_options);
+		}
+	}
+
+	free(str);
+}
+
+static int timer_key_cmp(struct list_head *list, struct timer_entry *l,
+			 struct timer_entry *r)
+{
+	struct sort_dimension *sortp;
+	int ret = 0;
+
+	BUG_ON(list_empty(list));
+
+	list_for_each_entry(sortp, list, list) {
+		ret = sortp->cmp(l, r);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+static void timer_rb_insert(struct rb_root *root, struct timer_entry *timer,
+			    struct list_head *sort_list)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	while (*new) {
+		struct timer_entry *this;
+		int cmp;
+
+		this = container_of(*new, struct timer_entry, node);
+		parent = *new;
+
+		cmp = timer_key_cmp(sort_list, timer, this);
+
+		if (cmp > 0)
+			new = &((*new)->rb_left);
+		else
+			new = &((*new)->rb_right);
+	}
+
+	rb_link_node(&timer->node, parent, new);
+	rb_insert_color(&timer->node, root);
+}
+
+static void timer_rb_traversal(struct rb_root *root,
+			       void (*func)(struct timer_entry *))
+{
+	struct rb_node *next;
+
+	next = rb_first(root);
+
+	while (next) {
+		struct timer_entry *timer;
+
+		timer = rb_entry(next, struct timer_entry, node);
+		func(timer);
+		next = rb_next(next);
+	}
+}
+
+#define TIMER_HASH_BITS		10
+#define TIMER_HASH_SIZE		(1UL << TIMER_HASH_BITS)
+
+static struct timer_entry *timer_hash_table[TIMER_HASH_SIZE];
+
+static inline int timer_hash_func(void *timer)
+{
+	return hash_ptr(timer, TIMER_HASH_BITS);
+}
+
+static struct timer_entry *
+timer_hash_findnew(void *timer, enum timer_type type)
+{
+	int hash = timer_hash_func(timer);
+	struct timer_entry **head, *curr, *prev = NULL;
+
+	head = timer_hash_table + hash;
+	curr = *head;
+
+	while (curr) {
+		if (curr->timer == timer && curr->type == type)
+			return curr;
+
+		prev = curr;
+		curr = curr->next;
+	}
+
+	curr = zalloc(sizeof(*curr));
+	if (!curr)
+		die("No memory");
+
+	curr->timer = timer;
+	curr->type = type;
+
+	if (prev)
+		prev->next = curr;
+	else
+		*head = curr;
+
+	return curr;
+}
+
+static inline void *
+get_timer_hrtimer(enum timer_type type, struct event *event, void *data)
+{
+	if (type == HRTIMER)
+		return raw_field_ptr(event, "hrtimer", data);
+
+	return raw_field_ptr(event, "timer", data);
+}
+
+/*
+ * if expiry time is not recorded, it means we not caught the start event,
+ * we can't calculate timer latency
+ */
+static inline bool check_timer_expire_ts(struct timer_entry *timer_entry)
+{
+	return !!timer_entry->timer_expire_ts;
+}
+
+/*
+ * if function entry time is not recorded, it means we not caught the
+ * expire entry event, we can't calculate function runtime
+ */
+static inline bool check_timer_func_entry_ts(struct timer_entry *timer_entry)
+{
+	return !!timer_entry->func_entry_ts;
+}
+
+static void timer_hrtimer_start(enum timer_type type, void *data,
+				struct event *event, struct thread *thread)
+{
+	void *timer;
+	struct timer_entry *timer_entry;
+	u64 expires, function;
+
+	timer = get_timer_hrtimer(type, event, data);
+	function = raw_field_value(event, "function", data);
+	expires = raw_field_value(event, "expires", data);
+
+	stats_update(type, ACTIVATED);
+	timer_entry = timer_hash_findnew(timer, type);
+
+	if (!timer_entry->timer_thread)
+		timer_entry->timer_thread = thread;
+
+	timer_entry->function = function;
+	timer_entry->timer_expire_ts = expires;
+}
+
+static void timer_hrtimer_expires_entry(enum timer_type type, void *data,
+					struct event *event, u64 timestamp)
+{
+	void *timer;
+	struct timer_entry *timer_entry;
+	u64 now;
+	s64 delta;
+
+	timer = get_timer_hrtimer(type, event, data);
+	now = raw_field_value(event, "now", data);
+
+	stats_update(type, EXPIRED);
+	timer_entry = timer_hash_findnew(timer, type);
+	timer_entry->func_entry_ts = timestamp;
+
+	if (!check_timer_expire_ts(timer_entry))
+		return;
+
+	delta = now - timer_entry->timer_expire_ts;
+	if (delta < 0) {
+		timer_entry->bug++;
+		printf("WARNING: timer[%p] type[%s]: latency < 0, expires"
+		       "[%llu] now[%llu]\n", timer_entry->timer,
+		       timer_type_str[timer_entry->type],
+		       timer_entry->timer_expire_ts, now);
+		return ;
+	}
+
+	timer_entry->expire_nr++;
+	timer_entry->timer_last_lat = delta;
+	timer_entry->timer_total_lat += delta;
+	if (timer_entry->timer_max_lat <= delta) {
+		timer_entry->timer_max_lat = delta;
+		timer_entry->timer_max_lat_at_ts = timestamp;
+	}
+	return;
+}
+
+static void timer_hrtimer_expires_exit(enum timer_type type, void *data,
+				       struct event *event, u64 timestamp)
+{
+	void *timer;
+	struct timer_entry *timer_entry;
+	s64 delta;
+
+	timer = get_timer_hrtimer(type, event, data);
+	timer_entry = timer_hash_findnew(timer, type);
+
+	if (!check_timer_func_entry_ts(timer_entry))
+		return;
+
+	delta = timestamp - timer_entry->func_entry_ts;
+	if (delta < 0) {
+		timer_entry->bug++;
+		printf("WARNING: timer[%p] type[%s]: runtime < 0, "
+		       "func_entry_ts[%llu] now[%llu]\n", timer_entry->timer,
+		       timer_type_str[timer_entry->type],
+		       timer_entry->func_entry_ts, timestamp);
+		return;
+	}
+
+	timer_entry->run_func_nr++;
+	timer_entry->func_total_runtime += delta;
+	if (timer_entry->func_max_runtime <= delta) {
+		timer_entry->func_max_runtime = delta;
+		timer_entry->func_max_runtime_at_ts = timestamp;
+		timer_entry->max_runtime_at_func = timer_entry->function;
+	}
+
+	return;
+}
+
+static void timer_hrtimer_cancel(enum timer_type type)
+{
+	stats_update(type, CANCELED);
+}
+
+static void timer_start_handler(void *data, struct event *event,
+				u64 timestamp __used, struct thread *thread)
+{
+	return timer_hrtimer_start(TIMER, data, event, thread);
+}
+
+static void
+timer_expire_entry_handler(void *data, struct event *event, u64 timestamp,
+			   struct thread *thread __used)
+{
+	return timer_hrtimer_expires_entry(TIMER, data, event, timestamp);
+}
+
+static void
+timer_expire_exit_handler(void *data, struct event *event, u64 timestamp,
+			  struct thread *thread __used)
+{
+	return timer_hrtimer_expires_exit(TIMER, data, event, timestamp);
+}
+
+static void timer_cancel(void *data __used, struct event *event __used,
+			 u64 timestamp __used, struct thread *thread __used)
+{
+	return timer_hrtimer_cancel(TIMER);
+}
+
+static void hrtimer_start_handler(void *data, struct event *event,
+				  u64 timestamp __used, struct thread *thread)
+{
+	return timer_hrtimer_start(HRTIMER, data, event, thread);
+}
+
+static void
+hrtimer_expire_entry_handler(void *data, struct event *event, u64 timestamp,
+			     struct thread *thread __used)
+{
+	return timer_hrtimer_expires_entry(HRTIMER, data, event, timestamp);
+}
+
+static void
+hrtimer_expire_exit_handler(void *data, struct event *event, u64 timestamp,
+			    struct thread *thread __used)
+{
+	return timer_hrtimer_expires_exit(HRTIMER, data, event, timestamp);
+}
+
+static void
+hrtimer_cancel(void *data __used, struct event *event __used,
+	       u64 timestamp __used, struct thread *thread __used)
+{
+	return timer_hrtimer_cancel(HRTIMER);
+}
+
+static void itimer_state_handler(void *data, struct event *event,
+				 u64 timestamp __used, struct thread *thread)
+{
+	struct timer_entry *timer_entry;
+	u64 value_sec, value_usec, expires;
+	int which;
+
+	value_sec = raw_field_value(event, "value_sec", data);
+	value_usec = raw_field_value(event, "value_usec", data);
+	expires = raw_field_value(event, "expires", data);
+	which = raw_field_value(event, "which", data);
+
+	timer_entry = timer_hash_findnew(thread, which);
+
+	/* itimer canceled */
+	if (!value_sec && !value_usec) {
+		stats_update(which, CANCELED);
+		return ;
+	}
+
+	/* itimer started */
+	stats_update(which, ACTIVATED);
+
+	if (which == ITIMER_REAL) {
+		void *hrtimer;
+
+		hrtimer = raw_field_ptr(event, "timer", data);
+		timer_entry->itimer_hrtimer = timer_hash_findnew(hrtimer,
+								 HRTIMER);
+	} else
+		timer_entry->timer_expire_ts = expires;
+}
+
+static void
+itimer_expire_handler(void *data, struct event *event, u64 timestamp,
+		      struct thread *thread __used)
+{
+	struct thread *itimer_thread;
+	struct timer_entry *timer_entry;
+	u64 now;
+	s64 delta;
+	pid_t pid;
+	int which;
+
+	which = raw_field_value(event, "which", data);
+	now = raw_field_value(event, "now", data);
+	pid = raw_field_value(event, "pid", data);
+
+	itimer_thread = perf_session__findnew(timer_session, pid);
+	timer_entry = timer_hash_findnew(itimer_thread, which);
+
+	stats_update(which, EXPIRED);
+
+	if (which == ITIMER_REAL) {
+		if (!timer_entry->itimer_hrtimer ||
+		    !check_timer_expire_ts(timer_entry->itimer_hrtimer))
+			return;
+		delta = timer_entry->itimer_hrtimer->timer_last_lat;
+	} else {
+		if (!check_timer_expire_ts(timer_entry))
+			return;
+		delta = now - timer_entry->timer_expire_ts;
+	}
+
+	if (delta < 0) {
+		timer_entry->bug++;
+		printf("WARNING: timer[%p] type[%s]: latency < 0, expires:"
+		       "[%llu] now[%llu]\n", timer_entry->timer,
+		       timer_type_str[timer_entry->type],
+		       timer_entry->timer_expire_ts, now);
+		return;
+	}
+
+	timer_entry->expire_nr++;
+	timer_entry->timer_total_lat += delta;
+	if (timer_entry->timer_max_lat <= delta) {
+		timer_entry->timer_max_lat = delta;
+		timer_entry->timer_max_lat_at_ts = timestamp;
+	}
+
+	return;
+}
+
+struct event_handler {
+	const char *event_name;
+	void (*handler) (void *data, struct event *event, u64 timestamp,
+			 struct thread *thread);
+} timer_handler[] = {
+	/* timer */
+	{ "timer_start", 	timer_start_handler		},
+	{ "timer_expire_entry",	timer_expire_entry_handler	},
+	{ "timer_expire_exit",	timer_expire_exit_handler	},
+	{ "timer_cancel",	timer_cancel			},
+
+	/* hrtimer */
+	{ "hrtimer_start",	hrtimer_start_handler		},
+	{ "hrtimer_expire_entry", hrtimer_expire_entry_handler	},
+	{ "hrtimer_expire_exit",  hrtimer_expire_exit_handler	},
+	{ "hrtimer_cancel",	hrtimer_cancel			},
+
+	/* itimer */
+	{ "itimer_state",	itimer_state_handler		},
+	{ "itimer_expire",	itimer_expire_handler		},
+};
+
+static void process_raw_event(event_t *raw_event __used,
+			      struct perf_session *session __used, void *data,
+			      int cpu __used, u64 timestamp,
+			      struct thread *thread)
+{
+	struct event *event;
+	unsigned int i;
+	int type;
+
+	type = trace_parse_common_type(data);
+	event = trace_find_event(type);
+
+	for (i = 0; i < ARRAY_SIZE(timer_handler); i++)
+		if (!strcmp(timer_handler[i].event_name, event->name))
+			timer_handler[i].handler(data, event,
+						 timestamp, thread);
+}
+
+static int process_sample_event(event_t *event, struct perf_session *session)
+{
+	struct sample_data data;
+	struct thread *thread;
+
+	if (!(session->sample_type & PERF_SAMPLE_RAW))
+		return 0;
+
+	memset(&data, 0, sizeof(data));
+	data.time = -1;
+	data.cpu = -1;
+	data.period = -1;
+
+	event__parse_sample(event, session->sample_type, &data);
+
+	dump_printf("(IP, %d): %d/%d: %p period: %lld\n",
+		event->header.misc,
+		data.pid, data.tid,
+		(void *)(long)data.ip,
+		(long long)data.period);
+
+	thread = perf_session__findnew(session, data.pid);
+	if (thread == NULL) {
+		pr_debug("problem processing %d event, skipping it.\n",
+			 event->header.type);
+		return -1;
+	}
+
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
+	if (profile_cpu != -1 && profile_cpu != (int)data.cpu)
+		return 0;
+
+	process_raw_event(event, session, data.raw_data, data.cpu,
+			  data.time, thread);
+	return 0;
+}
+
+static int
+process_inject_event(event_t *event, struct perf_session *session __used)
+{
+	if (event->inject.inject_event_id == PERF_INJECT_HZ)
+		update_hz(&event->inject.value);
+
+	return 0;
+}
+
+static struct perf_event_ops event_ops = {
+	.sample	= process_sample_event,
+	.comm	= event__process_comm,
+	.inject	= process_inject_event,
+};
+
+static int read_events(void)
+{
+	int err;
+
+	timer_session = perf_session__new(input_name, O_RDONLY, 0);
+	if (!timer_session)
+		return -ENOMEM;
+
+	err = perf_session__process_events(timer_session, &event_ops);
+	return err;
+}
+
+static inline bool timer_hz_unit(struct timer_entry *entry)
+{
+	return entry->type == TIMER || entry->type == VIRTUAL_ITIMER
+		|| entry->type == PROF_ITIMER;
+}
+
+static void timer_adjust(struct timer_entry *entry)
+{
+	if (entry->expire_nr) {
+		entry->timer_avg_lat = (double)entry->timer_total_lat /
+				       (double)entry->expire_nr;
+		if (timer_hz_unit(entry) && hz) {
+			/* change unit to nanosecond */
+			entry->timer_avg_lat  = entry->timer_avg_lat * 1e9 / hz;
+			entry->timer_max_lat = entry->timer_max_lat * 1e9 / hz;
+		}
+	}
+
+	if (entry->run_func_nr)
+		entry->func_avg_runtime = (double)entry->func_total_runtime /
+					  (double)entry->run_func_nr;
+}
+
+static struct rb_root timer_result;
+static void sort_result(void)
+{
+	unsigned int i;
+
+	if (!filter_type)
+		filter_type = 0xFF;
+
+	for (i = 0; i < TIMER_HASH_SIZE; i++) {
+		struct timer_entry *entry;
+
+		for (entry = *(timer_hash_table + i); entry;
+				entry = entry->next) {
+			if (!(filter_type & 1 << entry->type))
+				continue;
+
+			bug_nr += entry->bug;
+			timer_adjust(entry);
+			timer_rb_insert(&timer_result, entry, &sort);
+		}
+	}
+}
+
+static inline void
+print_timer_name(struct timer_entry *timer_entry, char *buf, int buf_len)
+{
+	enum timer_type type;
+
+	type = timer_entry->type;
+	if (type != TIMER && type != HRTIMER) {
+		snprintf(buf, buf_len, "%s",
+			 ((struct thread *)timer_entry->timer)->comm);
+		return;
+	}
+
+	if (timer_entry->timer_thread)
+		snprintf(buf, buf_len, "%s", timer_entry->timer_thread->comm);
+	else
+		snprintf(buf, buf_len, "%p", timer_entry->timer);
+}
+
+static void __print_timer_lat(struct timer_entry *timer_entry)
+{
+	char buf[20];
+
+	if (!timer_entry->expire_nr)
+		return;
+
+	print_timer_name(timer_entry, buf, sizeof(buf));
+	printf("%-15s", buf);
+
+	printf("|%-15s", timer_type_str[timer_entry->type]);
+	if (timer_hz_unit(timer_entry) && !hz) {
+		printf("|%-10.3f %2s", timer_entry->timer_avg_lat, "HZ");
+		printf("|%-10llu %2s", timer_entry->timer_max_lat, "HZ");
+	} else {
+		printf("|%-13.3f", timer_entry->timer_avg_lat / 1e6);
+		printf("|%-13.3f", timer_entry->timer_max_lat / 1e6);
+	}
+
+	printf("|%-13.3f\n", timer_entry->timer_max_lat_at_ts / 1e9);
+}
+
+static void print_timer_lat(void)
+{
+	printf("\n");
+	printf("                          Timer Latency List\n");
+	printf(
+"[ Abbreviations: Avg = average; lat = latency; ts = timestamp ]\n");
+	printf(
+"-------------------------------------------------------------------------\n");
+	printf(
+"     Timer     |     TYPE      | Avg-lat   ms| Max-lat   ms| Max-lat-ts s\n");
+	printf(
+"-------------------------------------------------------------------------\n");
+	timer_rb_traversal(&timer_result, __print_timer_lat);
+}
+
+static void __print_func_runtime(struct timer_entry *timer_entry)
+{
+	u64 function;
+	char buf[20];
+
+	if (!timer_entry->run_func_nr)
+		return;
+
+	print_timer_name(timer_entry, buf, sizeof(buf));
+	printf("%-15s", buf);
+	printf("|%-7s", timer_type_str[timer_entry->type]);
+	printf("|%-9.3f", timer_entry->func_avg_runtime / 1e6);
+	printf("|%-9.3f", timer_entry->func_max_runtime / 1e6);
+	function = timer_entry->max_runtime_at_func;
+	if (function) {
+		struct symbol *sym;
+
+		sym = map_groups__find_function(&timer_session->kmaps,
+						timer_session, function, NULL);
+		if (sym)
+			printf("|%-23.23s", sym->name);
+		else
+			printf("|%-23llx", function);
+	} else
+		printf("|%-23s", "Not - Catch");
+
+	printf("|%-8.3f\n", timer_entry->func_max_runtime_at_ts / 1e9);
+}
+
+static void print_func_runtime(void)
+{
+	printf("\n");
+	printf("                           Timer Function Runtime List\n");
+	printf(
+"[ Abbreviations: Avg = average; func = function; rt = runtime; ts = timestamp ]\n");
+
+	printf(
+"-------------------------------------------------------------------------------\n");
+	printf(
+"     Timer     | Type  |Avg-rt ms|Max-rt ms|      Max-rt-func      | Max-rt-ts s\n");
+	printf(
+"-------------------------------------------------------------------------------\n");
+	timer_rb_traversal(&timer_result, __print_func_runtime);
+}
+
+static void __print_bug_timer(struct timer_entry *timer_entry)
+{
+	char buf[20];
+
+	if (!timer_entry->bug)
+		return;
+
+	print_timer_name(timer_entry, buf, sizeof(buf));
+	printf("%-15s", buf);
+
+	printf("|%-15s", timer_type_str[timer_entry->type]);
+	printf("|%-10d\n", timer_entry->bug);
+}
+
+static void print_bug_timer(void)
+{
+	if (bug_nr) {
+		printf("\nWarning: detect %d bug(s):\n", bug_nr);
+		printf("--------------------------------------------\n");
+		printf("     Timer     |     Type      |    Bug   \n");
+		printf("--------------------------------------------\n");
+		timer_rb_traversal(&timer_result, __print_bug_timer);
+	}
+}
+
+static void
+__print_stats(enum stat_type stat_type, char *buf, int buf_len)
+{
+	int i;
+
+	for (i = MAX_TIMER_TYPE - 1; i >= 0; i--) {
+		int plen;
+
+		if (!(filter_type & 1 << i))
+			continue;
+		plen = snprintf(buf, buf_len, "%s: %d ", timer_type_str[i],
+				stats[stat_type][i]);
+		buf += plen;
+		buf_len -= plen;
+	}
+}
+
+static void print_stats(void)
+{
+	char buf[128];
+
+	printf("\nStatistics\n==========\n");
+	__print_stats(ACTIVATED, buf, sizeof(buf));
+	printf("Activated timers number:\n  %s\n\n", buf);
+	__print_stats(EXPIRED, buf, sizeof(buf));
+	printf("Expired timers number:\n  %s\n\n", buf);
+	__print_stats(CANCELED, buf, sizeof(buf));
+	printf("Canceled timers number:\n  %s\n\n", buf);
+}
+
+static void print_result(void)
+{
+	if (print_lat)
+		print_timer_lat();
+
+	if (print_runtime)
+		print_func_runtime();
+
+	print_bug_timer();
+	print_stats();
+}
+
+static void __cmd_report(void)
+{
+	setup_pager();
+	read_events();
+	setup_sorting(sort_order);
+	sort_result();
+	print_result();
+	perf_session__delete(timer_session);
+}
+
+static const char *record_args[] = {
+	"record",
+	"-a",
+	"-R",
+	"-M",
+	"-f",
+	"-m", "1024",
+	"-c", "1",
+
+	/* timer */
+	"-e", "timer:timer_start",
+	"-e", "timer:timer_expire_entry",
+	"-e", "timer:timer_expire_exit",
+	"-e", "timer:timer_cancel",
+
+	/* hrtimer */
+	"-e", "timer:hrtimer_start",
+	"-e", "timer:hrtimer_expire_entry",
+	"-e", "timer:hrtimer_expire_exit",
+	"-e", "timer:hrtimer_cancel",
+
+	/* itimer **/
+	"-e", "timer:itimer_state",
+	"-e", "timer:itimer_expire",
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+
+	inject_events = PERF_INJECT_HZ;
+	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = strdup(record_args[i]);
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+int cmd_timer(int argc, const char **argv, const char *prefix __used)
+{
+	argc = parse_options(argc, argv, timer_options, timer_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(timer_usage, timer_options);
+
+	symbol__init();
+	if (!strncmp(argv[0], "rec", 3))
+		return __cmd_record(argc, argv);
+
+	if (!strcmp(argv[0], "report")) {
+		if (argc > 1) {
+			argc = parse_options(argc, argv, report_options,
+					     report_usage, 0);
+			if (argc)
+				usage_with_options(report_usage,
+						   report_options);
+		}
+		__cmd_report();
+
+	} else
+		usage_with_options(timer_usage, timer_options);
+
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 18035b1..e294128 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -30,5 +30,6 @@ extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
 extern int cmd_probe(int argc, const char **argv, const char *prefix);
 extern int cmd_kmem(int argc, const char **argv, const char *prefix);
+extern int cmd_timer(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 71dc7c3..e522f5d 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -16,3 +16,4 @@ perf-top			mainporcelain common
 perf-trace			mainporcelain common
 perf-probe			mainporcelain common
 perf-kmem			mainporcelain common
+perf-timer			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index fc89005..dfb2732 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -301,6 +301,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "sched",	cmd_sched,	0 },
 		{ "probe",	cmd_probe,	0 },
 		{ "kmem",	cmd_kmem,	0 },
+		{ "timer",	cmd_timer,	0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 80fb365..6432c75 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -75,6 +75,12 @@ struct sample_data {
 	void *raw_data;
 };
 
+struct inject_event {
+	struct perf_event_header header;
+	u32 inject_event_id;
+	u64 value;
+};
+
 #define BUILD_ID_SIZE 20
 
 struct build_id_event {
@@ -92,6 +98,7 @@ typedef union event_union {
 	struct lost_event		lost;
 	struct read_event		read;
 	struct sample_event		sample;
+	struct inject_event		inject;
 } event_t;
 
 struct events_stats {
-- 
1.6.1.2


