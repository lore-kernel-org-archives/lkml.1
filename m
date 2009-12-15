Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbZLORpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbZLORpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZLORpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:45:07 -0500
Received: from www.tglx.de ([62.245.132.106]:41375 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZLORpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:45:05 -0500
Date: Tue, 15 Dec 2009 18:44:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf/timer: 'perf timer' core code
In-Reply-To: <4B277191.6020500@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0912151539420.2755@localhost.localdomain>
References: <4B27702F.1080507@cn.fujitsu.com> <4B2770AD.90005@cn.fujitsu.com> <4B2770FA.7090803@cn.fujitsu.com> <4B277143.9070909@cn.fujitsu.com> <4B277191.6020500@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 15 Dec 2009, Xiao Guangrong wrote:

> It's the core code of 'perf timer', we can use it to analyse timer's
> behavior:
> # perf timer record
> # perf timer lat --print-lat --print-handle
> -------------------------------------------------------------------------------------------------------
> |   Timer            |   TYPE   |   Avg-latency  | Max-latency  |  Max-latency-at-TS |Max-lat-at-Task |
> |0xf7ad1f5c          |hrtimer   |996068.500    ns|1607650     ns|10270128658526      |init            |
> |0xf7903f04          |timer     |0.625         HZ|2           HZ|10270344082394      |swapper         |
> |0xf787a05c          |hrtimer   |200239.500    ns|359929      ns|10269316024808      |main            |
> |main      :[   PROF]|itimer    |0.000         HZ|0           HZ|10237021270557      |main            |
> |main      :[VIRTUAL]|itimer    |0.000         HZ|0           HZ|10257314773501      |main            |
> 
> ......
> 
> -------------------------------------------------------------------------------------------------------
> |   Timer            |   TYPE   | Avg-handle (ms)|Max-handle(ms)| Max-handle-at-TS(s)|Max-lat-at-func |
> |0xf7ad1f5c          |hrtimer   |0.025           |0.025         |10270.129           |0xc016b5b0      |
> |0xf7903f04          |timer     |0.009           |0.011         |10260.342           |0xc0159240      |
> |0xf787a05c          |hrtimer   |0.031           |0.062         |10267.018           |0xc014cc40      |

The output is confusing in several aspects:

  1) Different time units:

     Please use consistent time units for everything. micro seconds
     are fine and we definitely do not care about nanosecond
     fractions.

  2) Timer description:
     
     Why do we have hex addresses and process names intermingled ? Why
     don't we print the process/thread name which owns the timer
     always ? [PROF/VIRTUAL] is not a property of the Timer, it
     belongs into type.
     
  3) Max-lat-at-Task:

     What does this field tell ?
   
  4) *handle:

     That should be a more descriptive name, e.g. function runtime

  5) Max-lat-at-func:

     Is this the callback function which ran the longest time ? Why
     is it named latency ? Why is it not decoded into a symbol ?

Btw, fitting the output into 80chars allows to use the tool on a non
graphical terminal as well.

Also there are other metrics of timers which are interesting and
should be retrieved by such a tool:

     number of activated timers
     number of canceled timers
     number of expired timers

in the form of simple statistics.

The canceled timers are interesting also in a list, so we can see
which timers are canceled after which time and how long before the
expiry.

> +#ifdef TDEBUG
> +static char const *timer_state_string[] = {
> +	"TIMER_INIT",
> +	"TIMER_STARE",

  If I _stare_ longer, I might understand it :)

> +#define SORT_KEY \
> +	"timer, type, avg-timer-latency, max-timer-latency,"	\
> +	" avg-handle-time, max-handle-time"

The code has at least two places where these strings are used. They
should be synced.

> +static char const	*input_name = "perf.data";
> +static char		default_sort_order[] = SORT_KEY;
> +
> +static char		*sort_order = default_sort_order;
> +static int		profile_cpu = -1;
> +static int		print_lat;
> +static int		print_handle;
> +static int		bug_nr;
> +static struct perf_session *timer_session;
> +
> +static const struct option timer_options[] = {
> +	OPT_STRING('i', "input", &input_name, "file",
> +		    "input file name"),
> +	OPT_BOOLEAN('v', "verbose", &verbose,
> +		    "be more verbose (show symbol address, etc)"),
> +	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
> +		    "dump raw trace in ASCII"),
> +	OPT_END()
> +};
> +
> +static const char * const timer_usage[] = {
> +	"perf timer [<options>] {record|latency}",
> +	NULL
> +};

Your example above uses "perf timer lat". What's correct ?

> +static const struct option latency_options[] = {
> +	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
> +		   "sort by key(s): "SORT_KEY),

Do we really need a sort order ? A single sort key should be
sufficient.

I'd prefer to have a selector instead which lets me filter timer
types. If I debug hrtimers then I have no interest in itimers or timer
list timers.

> +enum timer_type {
> +	TIMER,
> +	HRTIMER,
> +	ITIMER,
> +};

Hmm. I don't think that's correct. You should split the itimer type
into the various subimplementations.

> +static char const *timer_type_string[] = {
> +	"timer",
> +	"hrtimer",
> +	"itimer",
> +};

Ditto.

> +struct sort_dimension {
> +	const char		*name;
> +	sort_fn_t		cmp;
> +	struct list_head	list;
> +};
> +
> +#define CMP_FUNCTION(value)						\

Please use something like "field". value confused me for a while, as I
expected a real value.

> +static int cmp_##value(struct timer_info *v1, struct timer_info *v2)	\
> +{									\
> +	if (v1->value < v2->value)					\
> +		return -1;						\
> +	if (v1->value > v2->value)					\
> +		return 1;						\
> +	return 0;							\
> +}
> +
> +#define DECLARE_SORT_DIMENSION(sort_name, field)			\

That should be DEFINE_... You are defining the function, not declaring
it.

> +CMP_FUNCTION(field)							\
> +static struct sort_dimension sort_##field = {				\
> +	.name = sort_name,						\
> +	.cmp = cmp_##field,						\
> +}
> +
> +DECLARE_SORT_DIMENSION("timer", timer);
> +DECLARE_SORT_DIMENSION("type", type);
> +DECLARE_SORT_DIMENSION("avg-timer-latency", timer_avg_lat);
> +DECLARE_SORT_DIMENSION("max-timer-latency", timer_max_lat);
> +DECLARE_SORT_DIMENSION("avg-handle-time", handler_avg_time);
> +DECLARE_SORT_DIMENSION("max-handle-time", handler_max_time);
> +
> +static struct sort_dimension *available_sorts[] = {
> +	&sort_timer,
> +	&sort_type,
> +	&sort_timer_avg_lat,
> +	&sort_timer_max_lat,
> +	&sort_handler_avg_time,
> +	&sort_handler_max_time,
> +};

This indirection horrible.

#define SORT(field,_name)	\
{	.func = cmp_##field,	\
	.name = _name, }

static struct sort_key sorts[] = {
       SORT(timer, "timer"),
       ....
};

> +#define NB_AVAILABLE_SORTS	(int)(sizeof(available_sorts) / sizeof(struct sort_dimension *))

Please use NR_ as abbreviation for number. Also the size calculation
for arrays is:

     ARRAY_SIZE(available_sorts)

> +static int sort_dimension__add(const char *tok, struct list_head *list)

  No double underscores please.

> +{
> +	int i;
> +
> +	for (i = 0; i < NB_AVAILABLE_SORTS; i++) {
> +		if (!strcmp(available_sorts[i]->name, tok)) {
> +			list_add_tail(&available_sorts[i]->list, list);
> +
> +			return 0;
> +		}
> +	}
> +
> +	return -1;
> +}
> +
> +static LIST_HEAD(sort_list);
> +
> +static void setup_sorting(void)
> +{
> +	char *tmp, *tok, *str = strdup(sort_order);

  Please hand sort_order in as an argument.

> +	for (tok = strtok_r(str, ", ", &tmp);
> +			tok; tok = strtok_r(NULL, ", ", &tmp)) {
> +		if (sort_dimension__add(tok, &sort_list) < 0) {
> +			error("Unknown --sort key: `%s'", tok);
> +			usage_with_options(latency_usage, latency_options);
> +		}
> +	}
> +
> +	free(str);
> +
> +	sort_dimension__add("timer", &default_cmp);
> +	sort_dimension__add("itimer-type", &default_cmp);

  That obviously does not match any of the sort types.

> +}
> +
> +static struct rb_root timer_root;
> +
> +static int timer_key_cmp(struct list_head *list, struct timer_info *l,
> +			 struct timer_info *r)
> +{
> +	struct sort_dimension *sort;
> +	int ret = 0;
> +
> +	BUG_ON(list_empty(list));
> +
> +	list_for_each_entry(sort, list, list) {
> +		ret = sort->cmp(l, r);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static void timer_traversal(struct rb_root *root,
> +			    void (*fun)(struct timer_info *))
> +{
> +	struct rb_node *next;
> +
> +	next = rb_first(root);
> +
> +	while (next) {
> +		struct timer_info *timer;
> +
> +		timer = rb_entry(next, struct timer_info, node);
> +		fun(timer);
> +		next = rb_next(next);
> +	}
> +}
> +
> +static struct timer_info *
> +__timer_search(struct rb_root *root, struct timer_info *timer,
> +	       struct list_head *_sort_list)
> +{
> +	struct rb_node *node = root->rb_node;
> +
> +	while (node) {
> +		struct timer_info *timer_info;
> +		int cmp;
> +
> +		timer_info = container_of(node, struct timer_info, node);
> +
> +		cmp = timer_key_cmp(_sort_list, timer, timer_info);
> +		if (cmp > 0)
> +			node = node->rb_left;
> +		else if (cmp < 0)
> +			node = node->rb_right;
> +		else
> +			return timer_info;

  This looks more than odd. You search for a timer in the list by
  using the compare functions which are used for sorting ?

  How should that work ?

> +	}
> +	return NULL;
> +}
> +
> +static struct timer_info *
> +timer_search(struct timer_info *timer)
> +{
> +	return __timer_search(&timer_root, timer, &default_cmp);
> +}
> +
> +static void
> +__timer_insert(struct rb_root *root, struct timer_info *data,
> +			 struct list_head *_sort_list)
> +{
> +	struct rb_node **new = &(root->rb_node), *parent = NULL;
> +
> +	while (*new) {
> +		struct timer_info *this;
> +		int cmp;
> +
> +		this = container_of(*new, struct timer_info, node);
> +		parent = *new;
> +
> +		cmp = timer_key_cmp(_sort_list, data, this);
> +
> +		if (cmp > 0)
> +			new = &((*new)->rb_left);
> +		else
> +			new = &((*new)->rb_right);
> +	}
> +
> +	rb_link_node(&data->node, parent, new);
> +	rb_insert_color(&data->node, root);
> +}
> +
> +static void timer_insert(struct timer_info *timer_info)
> +{
> +	dprintf("timer %p insert...\n", timer_info->timer);
> +	__timer_insert(&timer_root, timer_info, &default_cmp);
> +}
> +
> +static struct timer_info
> +*__timer_find(void *timer, enum timer_type type, int itimer_type)

  As I said before, that's wrong. Enumerate the itimer subtypes in the
  timer types and you get rid of all that extra itimer_type business.

> +{
> +	struct timer_info *find = NULL;
> +	struct timer_info timer_info = {
> +			.timer = timer,
> +			.itimer_type = itimer_type,
> +		};
> +
> +	find = timer_search(&timer_info);
> +	if (find && find->type != type) {
> +
> +		dprintf("find timer[%p], but type[%s] is not we expect[%s],"
> +			"set to initializtion state.\n", find->timer,
> +			timer_type_string[find->type], timer_type_string[type]);
> +
> +		find->type = type;
> +		find->bug++;
> +		find->state = TIMER_INIT;

  Why does a timer_search fail ? And why is fixing up the type if it
  is not matching a good idea ?

> +	}
> +
> +	dprintf("find timer[%p] %s\n", timer, find ? "success" : "fail");
> +	return find;
> +}
> +
> +static struct timer_info *
> +timer_findnew(void *timer, enum timer_type type, int itimer_type)
> +{
> +	struct timer_info *find;
> +
> +	find = __timer_find(timer, type, itimer_type);
> +	if (find)
> +		return find;
> +
> +	find = zalloc(sizeof(*find));
> +	if (!find)
> +		die("No memory");
> +
> +	find->type = type;
> +	find->timer = timer;
> +	find->itimer_type = itimer_type;
> +	timer_insert(find);
> +
> +	return find;
> +}
> +
> +static struct rb_root timer_result;
> +
> +static void sort_result(void)
> +{
> +	struct rb_node *node;
> +
> +	for (;;) {
> +		struct timer_info *data;
> +		node = rb_first(&timer_root);
> +		if (!node)
> +			break;
> +
> +		rb_erase(node, &timer_root);
> +		data = rb_entry(node, struct timer_info, node);
> +		data->timer_avg_lat = (double)data->timer_total_lat /
> +					(double)data->expire_nr;
> +		data->handler_avg_time = (double)data->handler_total_time /
> +					(double)data->expire_nr;
> +		if (data->expire_nr)
> +			__timer_insert(&timer_result, data, &sort_list);
> +	}
> +}
> +
> +static int timer_check_set_state(struct timer_info *timer_info,
> +				 enum timer_state new_state)
> +{
> +	enum timer_state current_state = timer_info->state;
> +	int ret = 1;
> +
> +	/*
> +	 * if current state is TIMER_INIT, it means it's the first time we
> +	 * catched, no need check.

  Check whatfor ?

> +	 */
> +	if (current_state == TIMER_INIT) {
> +		dprintf("timer[%p] initialize, set state to %s\n",
> +			timer_info->timer, timer_state_string[new_state]);
> +		ret = 0;
> +	}
> +
> +	timer_info->state = new_state;
> +	return ret;
> +}
> +
> +#define FILL_RAM_FIELD_PTR(event, field, data)				\
> +	field = raw_field_ptr(event, #field, data)
> +#define FILLL_RAW_FIELD_VALUE(event, field, data)			\
> +	field = (typeof(field))raw_field_value(event, #field, data)

  I can neither figure out what FILL_RAM_FIELD means nor why
  FILLL_RAW_FIELD needs 3 L.

> +static void *get_timer(enum timer_type type, struct event *event, void *data)
> +{
> +	if (type == HRTIMER) {
> +		void *hrtimer = NULL;
> +
> +		FILL_RAM_FIELD_PTR(event, hrtimer, data);
> +		return hrtimer;

  Shudder.

	return raw_field_ptr(event, "hrtimer", data);

> +	} else {
> +		void *timer = NULL;
> +
> +		FILL_RAM_FIELD_PTR(event, timer, data);
> +		return timer;
> +	}
> +}
> +
> +static void
> +timer_hrtimer_start(enum timer_type type, void *data, struct event *event)
> +{
> +	void *timer, *function = NULL;
> +	u64 expires;
> +	struct timer_info *timer_info;
> +
> +	timer = get_timer(type, event, data);
> +
> +	FILL_RAM_FIELD_PTR(event, function, data);
> +	FILLL_RAW_FIELD_VALUE(event, expires, data);
> +
> +	dprintf("timer-start: Timer[%p], type:%s, function:%p, expires:%llu\n",
> +		timer, timer_type_string[type], function, expires);
> +
> +	timer_info = timer_findnew(timer, type, MAX_ITIMER_TYPE);
> +	timer_check_set_state(timer_info, TIMER_START);
> +	timer_info->function = function;
> +	timer_info->timer_expire_ts = expires;
> +}
> +
> +static void
> +timer_hrtimer_expires_entry(enum timer_type type, void *data,
> +			    struct event *event, u64 timestamp,
> +			    struct thread *thread)
> +{
> +	void *timer;
> +	int ret;
> +	u64 now;
> +	s64 delta;
> +	struct timer_info *timer_info;
> +
> +	FILLL_RAW_FIELD_VALUE(event, now, data);
> +	timer = get_timer(type, event, data);
> +	timer_info = timer_findnew(timer, type, MAX_ITIMER_TYPE);
> +	timer_info->handler_entry_ts = timestamp;
> +	ret = timer_check_set_state(timer_info, TIMER_EXPIRE_ENTRY);
> +
> +	dprintf("timer-expires-entry: Timer[%p], type:%s, now:%llu, ts:%llu\n",
> +		timer, timer_type_string[type], now, timestamp);
> +	if (ret == 0)
> +		return;
> +
> +	delta = (s64)(now - timer_info->timer_expire_ts);
> +	if (delta < 0) {
> +		timer_info->bug++;
> +		dprintf("timer-expires-entry: Timer[%p], type:%s,"
> +			" timer latency < 0, bug=%d.\n", timer,
> +			timer_type_string[type], timer_info->bug);
> +		return ;
> +	}
> +
> +	timer_info->expire_nr++;
> +	timer_info->timer_last_lat = delta;
> +	timer_info->timer_total_lat += delta;
> +	if (timer_info->timer_max_lat <= (u64)delta) {

  Why can't we just make timer_max_lat s64 so we get rid of those
  silly typecasts ?

> +		timer_info->timer_max_lat = delta;
> +		timer_info->timer_max_lat_at_ts = timestamp;
> +		timer_info->timer_max_lat_at_thread = thread;

  What does us the information in which thread context the latency
  happend show ? Actually nothing. All it tells us that thread X was
  on the CPU at that point. That's useless.

> +static void
> +itimer_state_handler(void *data, struct event *event, int this_cpu __used,
> +		     u64 timestamp __used, struct thread *thread)
> +{
> +	u64 value_sec, value_usec, expires;
> +	struct timer_info *timer_info;
> +	void *timer = NULL;
> +	int which;
> +
> +	FILLL_RAW_FIELD_VALUE(event, value_sec, data);
> +	FILLL_RAW_FIELD_VALUE(event, value_usec, data);
> +	FILLL_RAW_FIELD_VALUE(event, expires, data);
> +	FILLL_RAW_FIELD_VALUE(event, which, data);
> +	FILL_RAM_FIELD_PTR(event, timer, data);

  This is complete obfuscated, while

  value_sec = get_value(data, event, "value_sec");

  is obvious.

> +	timer_info = timer_findnew(thread, ITIMER, which);
> +
> +	/* itimer canceled, we skip this event */
> +	if (!value_sec && !value_usec)
> +		return ;

  You throw away valuable information here about canceled timers.

> +	dprintf("timer-start: Timer[%p], type:%s, task:%s, expires:%llu",
> +		 timer_info->timer, "itimer", thread->comm, expires);
> +
> +	/* itimer started */
> +	timer_info->timer_expire_ts = expires;
> +	timer_check_set_state(timer_info, TIMER_START);
> +	if (which == ITIMER_REAL) {
> +		timer = timer_findnew(timer, HRTIMER, MAX_ITIMER_TYPE);
> +		timer_info->itimer_hrtimer = timer;
> +		dprintf(" hrtimer:%p\n", timer);
> +	} else {
> +		dprintf("\n");
> +	}
> +}
> +
> +static void
> +itimer_expire_handler(void *data, struct event *event, int this_cpu __used,
> +		      u64 timestamp, struct thread *thread)
> +{
> +	int which;
> +	u64 now;
> +	pid_t pid;
> +	struct thread *itimer_thread;
> +	struct timer_info *timer_info;
> +	s64 delta = 0;

  No need to initialize that.

> +	int ret;

  Please group identical types

  int ret, which;

> +struct event_handler_unit {
> +	const char *event_name;
> +	void (*handler) (void *data, struct event *event, int this_cpu,
> +			 u64 timestamp, struct thread *thread);
> +} timer_handler[] = {
> +	/* timer */
> +	{ "timer_start", 	timer_start_handler		},
> +	{ "timer_expire_entry",	timer_expire_entry_handler	},
> +	{ "timer_expire_exit",	timer_expire_exit_handler	},
> +
> +	/* hrtimer */
> +	{ "hrtimer_start",	hrtimer_start_handler		},
> +	{ "hrtimer_expire_entry", hrtimer_expire_entry_handler	},
> +	{ "hrtimer_expire_exit",  hrtimer_expire_exit_handler},
> +
> +	/* itimer */
> +	{ "itimer_state",	itimer_state_handler		},
> +	{ "itimer_expire",	itimer_expire_handler		},
> +};
> +
> +static void
> +process_raw_event(event_t *raw_event __used, struct perf_session *session __used,
> +		  void *data, int cpu, u64 timestamp, struct thread *thread)
> +{
> +	struct event *event;
> +	int type;
> +	int i;
> +	int handler_item = ARRAY_SIZE(timer_handler);

  See above.

> +	type = trace_parse_common_type(data);
> +	event = trace_find_event(type);
> +
> +	for (i = 0; i < handler_item; i++)
> +		if (!strcmp(timer_handler[i].event_name, event->name))
> +			timer_handler[i].handler(data, event, cpu, timestamp, thread);
> +}
> +
> +static int read_events(void)
> +{
> +	int err;

  New line between variables and code.

> +	timer_session = perf_session__new(input_name, O_RDONLY, 0, NULL);
> +
> +	if (timer_session == NULL)

  	if (!timer_session)

> +		return -ENOMEM;
> +
> +	err = perf_session__process_events(timer_session, &event_ops);
> +	perf_session__delete(timer_session);
> +	return err;
> +}
> +

Thanks,

	tglx
