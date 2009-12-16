Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbZLPF6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbZLPF6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761189AbZLPF6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:58:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59993 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761085AbZLPF6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:58:19 -0500
Message-ID: <4B287690.4000305@cn.fujitsu.com>
Date: Wed, 16 Dec 2009 13:56:32 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf/timer: 'perf timer' core code
References: <4B27702F.1080507@cn.fujitsu.com> <4B2770AD.90005@cn.fujitsu.com> <4B2770FA.7090803@cn.fujitsu.com> <4B277143.9070909@cn.fujitsu.com> <4B277191.6020500@cn.fujitsu.com> <alpine.LFD.2.00.0912151539420.2755@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912151539420.2755@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Sorry for many mistakes(typos and bad ideas) in this patch, i'll cook it
more and be careful later. Thanks very much.

Thomas Gleixner wrote:
> The output is confusing in several aspects:
> 
>   1) Different time units:
> 
>      Please use consistent time units for everything. micro seconds
>      are fine and we definitely do not care about nanosecond
>      fractions.

OK, i'll change ns to ms, and for timer, the unit is HZ, do we have the
way to read kernel HZ in userspace? if not, i'll export HZ by proc/debugfs
or other way

> 
>   2) Timer description:
>      
>      Why do we have hex addresses and process names intermingled ? Why
>      don't we print the process/thread name which owns the timer
>      always ? [PROF/VIRTUAL] is not a property of the Timer, it
>      belongs into type.

Um, but not every timer has it's owner task, for example, if we start
a timer in interrupt handle function, this timer in not owns any tasks.
And itimer is started by userspace task so we can get it's owner, that
why i print hex address for timer/hrtimer, and print task name for itimer.

>
>   3) Max-lat-at-Task:
> 
>      What does this field tell ?

It means that which task in running when the maximum latency occurs.
but, as you noticed, this is useless, i'll remove it in next version
patch.

>    
>   4) *handle:
> 
>      That should be a more descriptive name, e.g. function runtime
> 

OK, will fix

>   5) Max-lat-at-func:
> 
>      Is this the callback function which ran the longest time ? Why
>      is it named latency ? Why is it not decoded into a symbol ?

it's my typo, i'll export it using right/better way

> 
> Btw, fitting the output into 80chars allows to use the tool on a non
> graphical terminal as well.
> 

OK, will fix

> Also there are other metrics of timers which are interesting and
> should be retrieved by such a tool:
> 
>      number of activated timers
>      number of canceled timers
>      number of expired timers
> 
> in the form of simple statistics.
> 

OK. will support it

> The canceled timers are interesting also in a list, so we can see
> which timers are canceled after which time and how long before the
> expiry.
> 

Um, i'll cook timer tracepoints to get the time when timer canceled,
and support this function.

>> +static const char * const timer_usage[] = {
>> +	"perf timer [<options>] {record|latency}",
>> +	NULL
>> +};
> 
> Your example above uses "perf timer lat". What's correct ?
> 

Actually, we only compare frontal 3 characters:
	strncmp(argv[0], "lat", 3)

And 'perf sched' and other commands also use this way.

>> +static const struct option latency_options[] = {
>> +	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
>> +		   "sort by key(s): "SORT_KEY),
> 
> Do we really need a sort order ? A single sort key should be
> sufficient.
> 

i think it's necessary.

for example, if we interest in timer's max latency, then we can
use '-s max-timer-latency' to sort it.

And, if it has many timer with the some max latency, then we can
use '-s max-timer-latency,avg-timer-latency' to sort

> I'd prefer to have a selector instead which lets me filter timer
> types. If I debug hrtimers then I have no interest in itimers or timer
> list timers.
> 

OK, will support this filter

>> +static LIST_HEAD(sort_list);
>> +
>> +static void setup_sorting(void)
>> +{
>> +	char *tmp, *tok, *str = strdup(sort_order);
> 
>   Please hand sort_order in as an argument.
> 

Sorry for my stupid question:
'sort_order' is a global variable and setup_sorting() only called
one time, why need hand sort_order in as an argument?

>> +static struct timer_info *
>> +__timer_search(struct rb_root *root, struct timer_info *timer,
>> +	       struct list_head *_sort_list)
>> +{
>> +	struct rb_node *node = root->rb_node;
>> +
>> +	while (node) {
>> +		struct timer_info *timer_info;
>> +		int cmp;
>> +
>> +		timer_info = container_of(node, struct timer_info, node);
>> +
>> +		cmp = timer_key_cmp(_sort_list, timer, timer_info);
>> +		if (cmp > 0)
>> +			node = node->rb_left;
>> +		else if (cmp < 0)
>> +			node = node->rb_right;
>> +		else
>> +			return timer_info;
> 
>   This looks more than odd. You search for a timer in the list by
>   using the compare functions which are used for sorting ?
> 
>   How should that work ?
> 

We put/get timer in a rb-tree base on the specify order, for example:
we default use this order:

sort_dimension__add("timer", &default_cmp);
sort_dimension__add("itimer-type", &default_cmp);

if timer_info->timer is bigger, we put it to left child, littler to right
child, if the timer_info->timer is the same, then we compare
timer_info->itimer_type.

>> +{
>> +	struct timer_info *find = NULL;
>> +	struct timer_info timer_info = {
>> +			.timer = timer,
>> +			.itimer_type = itimer_type,
>> +		};
>> +
>> +	find = timer_search(&timer_info);
>> +	if (find && find->type != type) {
>> +
>> +		dprintf("find timer[%p], but type[%s] is not we expect[%s],"
>> +			"set to initializtion state.\n", find->timer,
>> +			timer_type_string[find->type], timer_type_string[type]);
>> +
>> +		find->type = type;
>> +		find->bug++;
>> +		find->state = TIMER_INIT;
> 
>   Why does a timer_search fail ? And why is fixing up the type if it
>   is not matching a good idea ?
> 

We search timer base on timer_info->timer and timer_info->itimer_type(not timer_info->type),
if we find the timer's type is changed(for example, the timer is "ITIMER" before, and change
to "HRTIMER" later), is should a bug. this case is hardly to happen but should catch it.

>> +static void *get_timer(enum timer_type type, struct event *event, void *data)
>> +{
>> +	if (type == HRTIMER) {
>> +		void *hrtimer = NULL;
>> +
>> +		FILL_RAM_FIELD_PTR(event, hrtimer, data);
>> +		return hrtimer;
> 
>   Shudder.
> 
> 	return raw_field_ptr(event, "hrtimer", data);
> 

Yeah, it's a clear way.

>> +static void
>> +itimer_state_handler(void *data, struct event *event, int this_cpu __used,
>> +		     u64 timestamp __used, struct thread *thread)
>> +{
>> +	u64 value_sec, value_usec, expires;
>> +	struct timer_info *timer_info;
>> +	void *timer = NULL;
>> +	int which;
>> +
>> +	FILLL_RAW_FIELD_VALUE(event, value_sec, data);
>> +	FILLL_RAW_FIELD_VALUE(event, value_usec, data);
>> +	FILLL_RAW_FIELD_VALUE(event, expires, data);
>> +	FILLL_RAW_FIELD_VALUE(event, which, data);
>> +	FILL_RAM_FIELD_PTR(event, timer, data);
> 
>   This is complete obfuscated, while
> 
>   value_sec = get_value(data, event, "value_sec");
> 
>   is obvious.
> 

Sorry, i cannot get this. As i understand:

#define FILL_RAW_FIELD_VALUE(event, field, data)		\
	field = (typeof(field))raw_field_value(event, #field, data)

After FILL_RAW_FIELD_VALUE(event, value_sec, data) expanded, it's:
  value_sec = raw_field_value(event, "value_sec", data)

Why it's wrong? :-(

>> +	timer_info = timer_findnew(thread, ITIMER, which);
>> +
>> +	/* itimer canceled, we skip this event */
>> +	if (!value_sec && !value_usec)
>> +		return ;
> 
>   You throw away valuable information here about canceled timers.
> 

We are not catch *_cancel event in this patch, i'll catch it to support
'number of canceled timers' in the next version.

Thanks,
Xiao
