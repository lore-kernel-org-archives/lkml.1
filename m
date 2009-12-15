Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbZLOLYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbZLOLYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 06:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbZLOLYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 06:24:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64892 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759953AbZLOLYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 06:24:43 -0500
Message-ID: <4B277191.6020500@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 19:22:57 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] perf/timer: 'perf timer' core code
References: <4B27702F.1080507@cn.fujitsu.com> <4B2770AD.90005@cn.fujitsu.com> <4B2770FA.7090803@cn.fujitsu.com> <4B277143.9070909@cn.fujitsu.com>
In-Reply-To: <4B277143.9070909@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's the core code of 'perf timer', we can use it to analyse timer's
behavior:
# perf timer record
# perf timer lat --print-lat --print-handle
-------------------------------------------------------------------------------------------------------
|   Timer            |   TYPE   |   Avg-latency  | Max-latency  |  Max-latency-at-TS |Max-lat-at-Task |
|0xf7ad1f5c          |hrtimer   |996068.500    ns|1607650     ns|10270128658526      |init            |
|0xf7903f04          |timer     |0.625         HZ|2           HZ|10270344082394      |swapper         |
|0xf787a05c          |hrtimer   |200239.500    ns|359929      ns|10269316024808      |main            |
|main      :[   PROF]|itimer    |0.000         HZ|0           HZ|10237021270557      |main            |
|main      :[VIRTUAL]|itimer    |0.000         HZ|0           HZ|10257314773501      |main            |

......

-------------------------------------------------------------------------------------------------------
|   Timer            |   TYPE   | Avg-handle (ms)|Max-handle(ms)| Max-handle-at-TS(s)|Max-lat-at-func |
|0xf7ad1f5c          |hrtimer   |0.025           |0.025         |10270.129           |0xc016b5b0      |
|0xf7903f04          |timer     |0.009           |0.011         |10260.342           |0xc0159240      |
|0xf787a05c          |hrtimer   |0.031           |0.062         |10267.018           |0xc014cc40      |

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/Makefile         |    1 +
 tools/perf/builtin-timer.c  |  954 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h        |    1 +
 tools/perf/command-list.txt |    1 +
 tools/perf/perf.c           |    1 +
 5 files changed, 958 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/builtin-timer.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a4cb792..797ab53 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -439,6 +439,7 @@ BUILTIN_OBJS += builtin-top.o
 BUILTIN_OBJS += builtin-trace.o
 BUILTIN_OBJS += builtin-probe.o
 BUILTIN_OBJS += builtin-kmem.o
+BUILTIN_OBJS += builtin-timer.o
 
 PERFLIBS = $(LIB_FILE)
 
diff --git a/tools/perf/builtin-timer.c b/tools/perf/builtin-timer.c
new file mode 100644
index 0000000..d35315f
--- /dev/null
+++ b/tools/perf/builtin-timer.c
@@ -0,0 +1,954 @@
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
+#ifdef TDEBUG
+static char const *timer_state_string[] = {
+	"TIMER_INIT",
+	"TIMER_STARE",
+	"TIMER_EXPIRE_ENTRY",
+	"TIMER_EXPIRE_EXIT",
+};
+
+#define dprintf(format, args...)	printf(format, ## args)
+#else
+#define dprintf(format, args...)
+#endif
+
+#define SORT_KEY \
+	"timer, type, avg-timer-latency, max-timer-latency,"	\
+	" avg-handle-time, max-handle-time"
+
+static char const	*input_name = "perf.data";
+static char		default_sort_order[] = SORT_KEY;
+
+static char		*sort_order = default_sort_order;
+static int		profile_cpu = -1;
+static int		print_lat;
+static int		print_handle;
+static int		bug_nr;
+static struct perf_session *timer_session;
+
+static const struct option timer_options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+static const char * const timer_usage[] = {
+	"perf timer [<options>] {record|latency}",
+	NULL
+};
+
+static const struct option latency_options[] = {
+	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
+		   "sort by key(s): "SORT_KEY),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_INTEGER('C', "CPU", &profile_cpu,
+		    "CPU to profile on"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN(0, "print-lat", &print_lat, "show timer latency"),
+	OPT_BOOLEAN(0, "print-handle", &print_handle,
+		    "show timer function handle time"),
+	OPT_END()
+};
+
+static const char * const latency_usage[] = {
+	"perf timer latency [<options>]",
+	NULL
+};
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
+
+	/* hrtimer */
+	"-e", "timer:hrtimer_start",
+	"-e", "timer:hrtimer_expire_entry",
+	"-e", "timer:hrtimer_expire_exit",
+
+	/* itimer **/
+	"-e", "timer:itimer_state",
+	"-e", "timer:itimer_expire",
+};
+
+static LIST_HEAD(default_cmp);
+
+enum timer_type {
+	TIMER,
+	HRTIMER,
+	ITIMER,
+};
+
+static char const *timer_type_string[] = {
+	"timer",
+	"hrtimer",
+	"itimer",
+};
+
+enum timer_state {
+	TIMER_INIT,
+	TIMER_START,
+	TIMER_EXPIRE_ENTRY,
+	TIMER_EXPIRE_EXIT,
+};
+
+struct timer_info {
+	struct rb_node node;
+
+	void			*timer;
+	int			itimer_type;
+	void			*function;
+	enum timer_type		type;
+	enum timer_state	state;
+	int expire_nr;
+	int bug;
+
+	struct timer_info 	*itimer_hrtimer;
+
+	u64			 timer_last_lat;
+	u64			timer_expire_ts;
+	u64			timer_total_lat;
+	double			timer_avg_lat;
+	u64			timer_max_lat;
+	u64			timer_max_lat_at_ts;
+	struct			thread *timer_max_lat_at_thread;
+
+	u64			handler_entry_ts;
+	u64			handler_total_time;
+	double			handler_avg_time;
+	u64			handler_max_time;
+	u64		handler_max_time_at_ts;
+	void		*handler_max_time_at_func;
+};
+
+#define MAX_ITIMER_TYPE	(0xFFFF)
+typedef int (*sort_fn_t)(struct timer_info *, struct timer_info *);
+
+struct sort_dimension {
+	const char		*name;
+	sort_fn_t		cmp;
+	struct list_head	list;
+};
+
+#define CMP_FUNCTION(value)						\
+static int cmp_##value(struct timer_info *v1, struct timer_info *v2)	\
+{									\
+	if (v1->value < v2->value)					\
+		return -1;						\
+	if (v1->value > v2->value)					\
+		return 1;						\
+	return 0;							\
+}
+
+#define DECLARE_SORT_DIMENSION(sort_name, field)			\
+CMP_FUNCTION(field)							\
+static struct sort_dimension sort_##field = {				\
+	.name = sort_name,						\
+	.cmp = cmp_##field,						\
+}
+
+DECLARE_SORT_DIMENSION("timer", timer);
+DECLARE_SORT_DIMENSION("type", type);
+DECLARE_SORT_DIMENSION("avg-timer-latency", timer_avg_lat);
+DECLARE_SORT_DIMENSION("max-timer-latency", timer_max_lat);
+DECLARE_SORT_DIMENSION("avg-handle-time", handler_avg_time);
+DECLARE_SORT_DIMENSION("max-handle-time", handler_max_time);
+
+static struct sort_dimension *available_sorts[] = {
+	&sort_timer,
+	&sort_type,
+	&sort_timer_avg_lat,
+	&sort_timer_max_lat,
+	&sort_handler_avg_time,
+	&sort_handler_max_time,
+};
+
+#define NB_AVAILABLE_SORTS	(int)(sizeof(available_sorts) / sizeof(struct sort_dimension *))
+static int sort_dimension__add(const char *tok, struct list_head *list)
+{
+	int i;
+
+	for (i = 0; i < NB_AVAILABLE_SORTS; i++) {
+		if (!strcmp(available_sorts[i]->name, tok)) {
+			list_add_tail(&available_sorts[i]->list, list);
+
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static LIST_HEAD(sort_list);
+
+static void setup_sorting(void)
+{
+	char *tmp, *tok, *str = strdup(sort_order);
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		if (sort_dimension__add(tok, &sort_list) < 0) {
+			error("Unknown --sort key: `%s'", tok);
+			usage_with_options(latency_usage, latency_options);
+		}
+	}
+
+	free(str);
+
+	sort_dimension__add("timer", &default_cmp);
+	sort_dimension__add("itimer-type", &default_cmp);
+}
+
+static struct rb_root timer_root;
+
+static int timer_key_cmp(struct list_head *list, struct timer_info *l,
+			 struct timer_info *r)
+{
+	struct sort_dimension *sort;
+	int ret = 0;
+
+	BUG_ON(list_empty(list));
+
+	list_for_each_entry(sort, list, list) {
+		ret = sort->cmp(l, r);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+static void timer_traversal(struct rb_root *root,
+			    void (*fun)(struct timer_info *))
+{
+	struct rb_node *next;
+
+	next = rb_first(root);
+
+	while (next) {
+		struct timer_info *timer;
+
+		timer = rb_entry(next, struct timer_info, node);
+		fun(timer);
+		next = rb_next(next);
+	}
+}
+
+static struct timer_info *
+__timer_search(struct rb_root *root, struct timer_info *timer,
+	       struct list_head *_sort_list)
+{
+	struct rb_node *node = root->rb_node;
+
+	while (node) {
+		struct timer_info *timer_info;
+		int cmp;
+
+		timer_info = container_of(node, struct timer_info, node);
+
+		cmp = timer_key_cmp(_sort_list, timer, timer_info);
+		if (cmp > 0)
+			node = node->rb_left;
+		else if (cmp < 0)
+			node = node->rb_right;
+		else
+			return timer_info;
+	}
+	return NULL;
+}
+
+static struct timer_info *
+timer_search(struct timer_info *timer)
+{
+	return __timer_search(&timer_root, timer, &default_cmp);
+}
+
+static void
+__timer_insert(struct rb_root *root, struct timer_info *data,
+			 struct list_head *_sort_list)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	while (*new) {
+		struct timer_info *this;
+		int cmp;
+
+		this = container_of(*new, struct timer_info, node);
+		parent = *new;
+
+		cmp = timer_key_cmp(_sort_list, data, this);
+
+		if (cmp > 0)
+			new = &((*new)->rb_left);
+		else
+			new = &((*new)->rb_right);
+	}
+
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
+}
+
+static void timer_insert(struct timer_info *timer_info)
+{
+	dprintf("timer %p insert...\n", timer_info->timer);
+	__timer_insert(&timer_root, timer_info, &default_cmp);
+}
+
+static struct timer_info
+*__timer_find(void *timer, enum timer_type type, int itimer_type)
+{
+	struct timer_info *find = NULL;
+	struct timer_info timer_info = {
+			.timer = timer,
+			.itimer_type = itimer_type,
+		};
+
+	find = timer_search(&timer_info);
+	if (find && find->type != type) {
+
+		dprintf("find timer[%p], but type[%s] is not we expect[%s],"
+			"set to initializtion state.\n", find->timer,
+			timer_type_string[find->type], timer_type_string[type]);
+
+		find->type = type;
+		find->bug++;
+		find->state = TIMER_INIT;
+	}
+
+	dprintf("find timer[%p] %s\n", timer, find ? "success" : "fail");
+	return find;
+}
+
+static struct timer_info *
+timer_findnew(void *timer, enum timer_type type, int itimer_type)
+{
+	struct timer_info *find;
+
+	find = __timer_find(timer, type, itimer_type);
+	if (find)
+		return find;
+
+	find = zalloc(sizeof(*find));
+	if (!find)
+		die("No memory");
+
+	find->type = type;
+	find->timer = timer;
+	find->itimer_type = itimer_type;
+	timer_insert(find);
+
+	return find;
+}
+
+static struct rb_root timer_result;
+
+static void sort_result(void)
+{
+	struct rb_node *node;
+
+	for (;;) {
+		struct timer_info *data;
+		node = rb_first(&timer_root);
+		if (!node)
+			break;
+
+		rb_erase(node, &timer_root);
+		data = rb_entry(node, struct timer_info, node);
+		data->timer_avg_lat = (double)data->timer_total_lat /
+					(double)data->expire_nr;
+		data->handler_avg_time = (double)data->handler_total_time /
+					(double)data->expire_nr;
+		if (data->expire_nr)
+			__timer_insert(&timer_result, data, &sort_list);
+	}
+}
+
+static int timer_check_set_state(struct timer_info *timer_info,
+				 enum timer_state new_state)
+{
+	enum timer_state current_state = timer_info->state;
+	int ret = 1;
+
+	/*
+	 * if current state is TIMER_INIT, it means it's the first time we
+	 * catched, no need check.
+	 */
+	if (current_state == TIMER_INIT) {
+		dprintf("timer[%p] initialize, set state to %s\n",
+			timer_info->timer, timer_state_string[new_state]);
+		ret = 0;
+	}
+
+	timer_info->state = new_state;
+	return ret;
+}
+
+#define FILL_RAM_FIELD_PTR(event, field, data)				\
+	field = raw_field_ptr(event, #field, data)
+#define FILLL_RAW_FIELD_VALUE(event, field, data)			\
+	field = (typeof(field))raw_field_value(event, #field, data)
+
+static void *get_timer(enum timer_type type, struct event *event, void *data)
+{
+	if (type == HRTIMER) {
+		void *hrtimer = NULL;
+
+		FILL_RAM_FIELD_PTR(event, hrtimer, data);
+		return hrtimer;
+	} else {
+		void *timer = NULL;
+
+		FILL_RAM_FIELD_PTR(event, timer, data);
+		return timer;
+	}
+}
+
+static void
+timer_hrtimer_start(enum timer_type type, void *data, struct event *event)
+{
+	void *timer, *function = NULL;
+	u64 expires;
+	struct timer_info *timer_info;
+
+	timer = get_timer(type, event, data);
+
+	FILL_RAM_FIELD_PTR(event, function, data);
+	FILLL_RAW_FIELD_VALUE(event, expires, data);
+
+	dprintf("timer-start: Timer[%p], type:%s, function:%p, expires:%llu\n",
+		timer, timer_type_string[type], function, expires);
+
+	timer_info = timer_findnew(timer, type, MAX_ITIMER_TYPE);
+	timer_check_set_state(timer_info, TIMER_START);
+	timer_info->function = function;
+	timer_info->timer_expire_ts = expires;
+}
+
+static void
+timer_hrtimer_expires_entry(enum timer_type type, void *data,
+			    struct event *event, u64 timestamp,
+			    struct thread *thread)
+{
+	void *timer;
+	int ret;
+	u64 now;
+	s64 delta;
+	struct timer_info *timer_info;
+
+	FILLL_RAW_FIELD_VALUE(event, now, data);
+	timer = get_timer(type, event, data);
+	timer_info = timer_findnew(timer, type, MAX_ITIMER_TYPE);
+	timer_info->handler_entry_ts = timestamp;
+	ret = timer_check_set_state(timer_info, TIMER_EXPIRE_ENTRY);
+
+	dprintf("timer-expires-entry: Timer[%p], type:%s, now:%llu, ts:%llu\n",
+		timer, timer_type_string[type], now, timestamp);
+	if (ret == 0)
+		return;
+
+	delta = (s64)(now - timer_info->timer_expire_ts);
+	if (delta < 0) {
+		timer_info->bug++;
+		dprintf("timer-expires-entry: Timer[%p], type:%s,"
+			" timer latency < 0, bug=%d.\n", timer,
+			timer_type_string[type], timer_info->bug);
+		return ;
+	}
+
+	timer_info->expire_nr++;
+	timer_info->timer_last_lat = delta;
+	timer_info->timer_total_lat += delta;
+	if (timer_info->timer_max_lat <= (u64)delta) {
+		timer_info->timer_max_lat = delta;
+		timer_info->timer_max_lat_at_ts = timestamp;
+		timer_info->timer_max_lat_at_thread = thread;
+	}
+	return;
+}
+
+static void
+timer_hrtimer_expires_exit(enum timer_type type, void *data,
+			   struct event *event, u64 timestamp,
+			   struct thread *thread __used)
+{
+	struct timer_info *timer_info;
+	s64 delta;
+	int ret;
+	void *timer;
+
+	timer = get_timer(type, event, data);
+	timer_info = timer_findnew(timer, type, MAX_ITIMER_TYPE);
+
+	dprintf("timer expires exit: Timer[%p], type:%s, ts:%llu\n",
+		timer, timer_type_string[type], timestamp);
+
+	ret = timer_check_set_state(timer_info, TIMER_EXPIRE_EXIT);
+	if (ret == 0)
+		return;
+
+	delta = timestamp - timer_info->handler_entry_ts;
+	if (delta < 0) {
+		timer_info->bug++;
+		dprintf("timer expires exit: Timer[%p], type:%s, handle time"
+			" < 0, expires-ts:%llu, current-ts:%llu, bug=%d.\n",
+			timer, timer_type_string[type],
+			timer_info->handler_entry_ts, timestamp,
+			timer_info->bug);
+		return;
+	}
+
+	timer_info->handler_total_time += delta;
+	if (timer_info->handler_max_time < (u64)delta) {
+		timer_info->handler_max_time = delta;
+		timer_info->handler_max_time_at_ts = timestamp;
+		timer_info->handler_max_time_at_func = timer_info->function;
+	}
+
+	return;
+}
+
+static void
+timer_start_handler(void *data, struct event *event, int this_cpu __used,
+		    u64 timestamp __used, struct thread *thread __used)
+{
+	return timer_hrtimer_start(TIMER, data, event);
+}
+
+static void
+timer_expire_entry_handler(void *data, struct event *event, int this_cpu __used,
+			   u64 timestamp, struct thread *thread)
+{
+	return timer_hrtimer_expires_entry(TIMER, data, event, timestamp, thread);
+}
+
+static void
+timer_expire_exit_handler(void *data, struct event *event, int this_cpu __used,
+			  u64 timestamp, struct thread *thread)
+{
+	return timer_hrtimer_expires_exit(TIMER, data, event, timestamp, thread);
+}
+
+static void
+hrtimer_start_handler(void *data, struct event *event, int this_cpu __used,
+		      u64 timestamp __used, struct thread *thread __used)
+{
+	return timer_hrtimer_start(HRTIMER, data, event);
+}
+
+static void
+hrtimer_expire_entry_handler(void *data, struct event *event, int this_cpu __used,
+			     u64 timestamp, struct thread *thread)
+{
+	return timer_hrtimer_expires_entry(HRTIMER, data, event, timestamp, thread);
+}
+
+static void
+hrtimer_expire_exit_handler(void *data, struct event *event, int this_cpu __used,
+			    u64 timestamp, struct thread *thread)
+{
+	return timer_hrtimer_expires_exit(HRTIMER, data, event, timestamp, thread);
+}
+
+static void
+itimer_state_handler(void *data, struct event *event, int this_cpu __used,
+		     u64 timestamp __used, struct thread *thread)
+{
+	u64 value_sec, value_usec, expires;
+	struct timer_info *timer_info;
+	void *timer = NULL;
+	int which;
+
+	FILLL_RAW_FIELD_VALUE(event, value_sec, data);
+	FILLL_RAW_FIELD_VALUE(event, value_usec, data);
+	FILLL_RAW_FIELD_VALUE(event, expires, data);
+	FILLL_RAW_FIELD_VALUE(event, which, data);
+	FILL_RAM_FIELD_PTR(event, timer, data);
+
+	timer_info = timer_findnew(thread, ITIMER, which);
+
+	/* itimer canceled, we skip this event */
+	if (!value_sec && !value_usec)
+		return ;
+
+	dprintf("timer-start: Timer[%p], type:%s, task:%s, expires:%llu",
+		 timer_info->timer, "itimer", thread->comm, expires);
+
+	/* itimer started */
+	timer_info->timer_expire_ts = expires;
+	timer_check_set_state(timer_info, TIMER_START);
+	if (which == ITIMER_REAL) {
+		timer = timer_findnew(timer, HRTIMER, MAX_ITIMER_TYPE);
+		timer_info->itimer_hrtimer = timer;
+		dprintf(" hrtimer:%p\n", timer);
+	} else {
+		dprintf("\n");
+	}
+}
+
+static void
+itimer_expire_handler(void *data, struct event *event, int this_cpu __used,
+		      u64 timestamp, struct thread *thread)
+{
+	int which;
+	u64 now;
+	pid_t pid;
+	struct thread *itimer_thread;
+	struct timer_info *timer_info;
+	s64 delta = 0;
+	int ret;
+
+	FILLL_RAW_FIELD_VALUE(event, which, data);
+	FILLL_RAW_FIELD_VALUE(event, now, data);
+	FILLL_RAW_FIELD_VALUE(event, pid, data);
+
+	itimer_thread = perf_session__findnew(timer_session, pid);
+	timer_info = timer_findnew(itimer_thread, ITIMER, which);
+
+	dprintf("timer-expires-entry: Timer[%p], type:%s, ts:%llu\n",
+		timer_info->timer, "itimer", timestamp);
+
+	ret = timer_check_set_state(timer_info, TIMER_EXPIRE_ENTRY);
+	if (ret == 0)
+		return;
+
+	if (which == ITIMER_REAL) {
+		if (timer_info->itimer_hrtimer->state == TIMER_INIT)
+			return;
+		delta = timer_info->itimer_hrtimer->timer_last_lat;
+	} else
+		delta = now - timer_info->timer_expire_ts;
+
+	if (delta < 0) {
+		timer_info->bug++;
+		dprintf("timer-expires-entry: Timer[%p], type:%s, handle time < 0,"
+			"bug=%d.\n",
+			timer_info->timer, "itimer", timer_info->bug);
+		return;
+	}
+
+	timer_info->expire_nr++;
+	timer_info->timer_total_lat += delta;
+	if (timer_info->timer_max_lat <= (u64)delta) {
+		timer_info->timer_max_lat = delta;
+		timer_info->timer_max_lat_at_ts = timestamp;
+		timer_info->timer_max_lat_at_thread = thread;
+	}
+
+	return;
+}
+
+struct event_handler_unit {
+	const char *event_name;
+	void (*handler) (void *data, struct event *event, int this_cpu,
+			 u64 timestamp, struct thread *thread);
+} timer_handler[] = {
+	/* timer */
+	{ "timer_start", 	timer_start_handler		},
+	{ "timer_expire_entry",	timer_expire_entry_handler	},
+	{ "timer_expire_exit",	timer_expire_exit_handler	},
+
+	/* hrtimer */
+	{ "hrtimer_start",	hrtimer_start_handler		},
+	{ "hrtimer_expire_entry", hrtimer_expire_entry_handler	},
+	{ "hrtimer_expire_exit",  hrtimer_expire_exit_handler},
+
+	/* itimer */
+	{ "itimer_state",	itimer_state_handler		},
+	{ "itimer_expire",	itimer_expire_handler		},
+};
+
+static void
+process_raw_event(event_t *raw_event __used, struct perf_session *session __used,
+		  void *data, int cpu, u64 timestamp, struct thread *thread)
+{
+	struct event *event;
+	int type;
+	int i;
+	int handler_item = ARRAY_SIZE(timer_handler);
+
+	type = trace_parse_common_type(data);
+	event = trace_find_event(type);
+
+	for (i = 0; i < handler_item; i++)
+		if (!strcmp(timer_handler[i].event_name, event->name))
+			timer_handler[i].handler(data, event, cpu, timestamp, thread);
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
+	dump_printf("(IP, %d): %d/%d: %p period: %Ld\n",
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
+	process_raw_event(event, session, data.raw_data, data.cpu, data.time, thread);
+	return 0;
+}
+
+static int sample_type_check(struct perf_session *session)
+{
+	if (!(session->sample_type & PERF_SAMPLE_RAW)) {
+		fprintf(stderr,
+			"No trace sample to read. Did you call perf record "
+			"without -R?");
+		return -1;
+	}
+
+	return 0;
+}
+
+static struct perf_event_ops event_ops = {
+	.process_sample_event	= process_sample_event,
+	.process_comm_event	= event__process_comm,
+	.sample_type_check	= sample_type_check,
+};
+
+static int read_events(void)
+{
+	int err;
+	timer_session = perf_session__new(input_name, O_RDONLY, 0, NULL);
+
+	if (timer_session == NULL)
+		return -ENOMEM;
+
+	err = perf_session__process_events(timer_session, &event_ops);
+	perf_session__delete(timer_session);
+	return err;
+}
+
+static inline const char *get_itimer_type(int which)
+{
+	switch (which) {
+	case ITIMER_REAL:
+		return "REAL";
+	case ITIMER_VIRTUAL:
+		return "VIRTUAL";
+	case ITIMER_PROF:
+		return "PROF";
+	default:
+		return "Unknow";
+	}
+}
+
+static inline const char *get_lat_unit(struct timer_info *timer_info)
+{
+	switch (timer_info->type) {
+	case TIMER:
+		return "HZ";
+	case HRTIMER:
+		return "ns";
+	case ITIMER:
+		if (timer_info->itimer_type == ITIMER_REAL)
+			return "ns";
+		return "HZ";
+	default:
+		return "ERR";
+	}
+}
+
+static void __print_timer_lat(struct timer_info *timer_info)
+{
+	bug_nr += timer_info->bug;
+
+	if (timer_info->type == ITIMER) {
+		printf("|%-10.10s:[%7s]", ((struct thread *)(timer_info->timer))->comm,
+						   get_itimer_type(timer_info->itimer_type));
+	} else
+		printf("|%-20p", timer_info->timer);
+
+	printf("|%-10s", timer_type_string[timer_info->type]);
+	printf("|%-12.3f %3s", timer_info->timer_avg_lat, get_lat_unit(timer_info));
+	printf("|%-10llu %3s", timer_info->timer_max_lat, get_lat_unit(timer_info));
+	printf("|%-20llu", timer_info->timer_max_lat_at_ts);
+	printf("|%-16.16s|\n", timer_info->timer_max_lat_at_thread->comm);
+}
+
+static void print_timer_lat(void)
+{
+	printf("\n");
+	printf("-------------------------------------------------------------------------------------------------------\n");
+	printf("|   Timer            |   TYPE   |   Avg-latency  | Max-latency  |  Max-latency-at-TS |Max-lat-at-Task |\n");
+	timer_traversal(&timer_result, __print_timer_lat);
+}
+
+static void __print_handle_time(struct timer_info *timer_info)
+{
+	void *function;
+
+	bug_nr += timer_info->bug;
+
+	if (timer_info->type == ITIMER)
+		return;
+
+	function = timer_info->handler_max_time_at_func;
+
+	printf("|%-20p", timer_info->timer);
+	printf("|%-10s", timer_type_string[timer_info->type]);
+	printf("|%-16.3f", timer_info->handler_avg_time / 1e6);
+	printf("|%-14.3f", (double)timer_info->handler_max_time / 1e6);
+	printf("|%-20.3f", (double)timer_info->handler_max_time_at_ts / 1e9);
+	if (!function) {
+		printf("|%-16s|\n", "Not - Catch");
+		return;
+	}
+
+	printf("|%-16p|\n", function);
+}
+
+static void print_handle_time(void)
+{
+	printf("\n");
+	printf("-------------------------------------------------------------------------------------------------------\n");
+	printf("|   Timer            |   TYPE   | Avg-handle (ms)|Max-handle(ms)| Max-handle-at-TS(s)|Max-lat-at-func |\n");
+	timer_traversal(&timer_result, __print_handle_time);
+}
+
+static void __print_bug_timer(struct timer_info *timer_info)
+{
+	if (!timer_info->bug)
+		return;
+
+	if (timer_info->type == ITIMER) {
+		printf("|%-10.10s:[%7s]", ((struct thread *)(timer_info->timer))->comm,
+						   get_itimer_type(timer_info->itimer_type));
+	} else
+		printf("|%-20p", timer_info->timer);
+
+	printf("|%-10s", timer_type_string[timer_info->type]);
+	printf("|%-10d|\n", timer_info->bug);
+}
+
+static void print_bug_timer(void)
+{
+	if (bug_nr) {
+		printf("\nWarning: detect %d bug(s):\n", bug_nr);
+		printf("--------------------------------------------\n");
+		printf("|   Timer            |   TYPE   |    Bug   |\n");
+		timer_traversal(&timer_result, __print_bug_timer);
+	}
+}
+
+static void print_result(void)
+{
+	if (!print_lat && !print_handle)
+		print_lat = 1;
+
+	if (print_lat)
+		print_timer_lat();
+
+	if (print_handle) {
+		bug_nr = 0;
+		print_handle_time();
+	}
+
+	print_bug_timer();
+}
+
+static void __cmd_lat(void)
+{
+	setup_pager();
+	read_events();
+	sort_result();
+	print_result();
+}
+
+static int __cmd_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+
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
+	symbol__init(0);
+	if (!strncmp(argv[0], "rec", 3)) {
+		return __cmd_record(argc, argv);
+	} else if (!strncmp(argv[0], "lat", 3)) {
+		if (argc > 1) {
+			argc = parse_options(argc, argv, latency_options, latency_usage, 0);
+			if (argc)
+				usage_with_options(latency_usage, latency_options);
+		}
+		setup_sorting();
+		__cmd_lat();
+	} else {
+		usage_with_options(timer_usage, timer_options);
+	}
+
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index a3d8bf6..afbe9b1 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -29,5 +29,6 @@ extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
 extern int cmd_probe(int argc, const char **argv, const char *prefix);
 extern int cmd_kmem(int argc, const char **argv, const char *prefix);
+extern int cmd_timer(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 02b09ea..d49bc55 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -15,3 +15,4 @@ perf-top			mainporcelain common
 perf-trace			mainporcelain common
 perf-probe			mainporcelain common
 perf-kmem			mainporcelain common
+perf-timer			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index cf64049..b43268a 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -300,6 +300,7 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "sched",	cmd_sched,	0 },
 		{ "probe",	cmd_probe,	0 },
 		{ "kmem",	cmd_kmem,	0 },
+		{ "timer",	cmd_timer,	0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
-- 
1.6.1.2


