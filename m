Return-Path: <linux-kernel-owner+w=401wt.eu-S934883AbZLPQAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883AbZLPQAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbZLPQAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:00:10 -0500
Received: from www.tglx.de ([62.245.132.106]:59016 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255AbZLPQAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:00:07 -0500
Date: Wed, 16 Dec 2009 16:59:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf/timer: 'perf timer' core code
In-Reply-To: <4B287690.4000305@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0912161629460.2755@localhost.localdomain>
References: <4B27702F.1080507@cn.fujitsu.com> <4B2770AD.90005@cn.fujitsu.com> <4B2770FA.7090803@cn.fujitsu.com> <4B277143.9070909@cn.fujitsu.com> <4B277191.6020500@cn.fujitsu.com> <alpine.LFD.2.00.0912151539420.2755@localhost.localdomain>
 <4B287690.4000305@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao,

On Wed, 16 Dec 2009, Xiao Guangrong wrote:
>
> Sorry for many mistakes(typos and bad ideas) in this patch, i'll cook it
> more and be careful later. Thanks very much.

Nothing to be sorry about. That's why we review code.
 
> Thomas Gleixner wrote:
> > The output is confusing in several aspects:
> >
> >   2) Timer description:
> >      
> >      Why do we have hex addresses and process names intermingled ? Why
> >      don't we print the process/thread name which owns the timer
> >      always ? [PROF/VIRTUAL] is not a property of the Timer, it
> >      belongs into type.
> 
> Um, but not every timer has it's owner task, for example, if we start
> a timer in interrupt handle function, this timer in not owns any tasks.
> And itimer is started by userspace task so we can get it's owner, that
> why i print hex address for timer/hrtimer, and print task name for itimer.

Well, lot's of timers have an owner task. At least all user space
related ones. And if the timer is rearmed in interrupt context, then
this does not change the owner at all.

> >> +static LIST_HEAD(sort_list);
> >> +
> >> +static void setup_sorting(void)
> >> +{
> >> +	char *tmp, *tok, *str = strdup(sort_order);
> > 
> >   Please hand sort_order in as an argument.
> > 
> 
> Sorry for my stupid question:
> 'sort_order' is a global variable and setup_sorting() only called
> one time, why need hand sort_order in as an argument?

Fair enough.

> >   How should that work ?
> > 
> 
> We put/get timer in a rb-tree base on the specify order, for example:
> we default use this order:
> 
> sort_dimension__add("timer", &default_cmp);
> sort_dimension__add("itimer-type", &default_cmp);
> 
> if timer_info->timer is bigger, we put it to left child, littler to right
> child, if the timer_info->timer is the same, then we compare
> timer_info->itimer_type.

Hmm, I wonder whether a hash table would be more efficient for the
recording side.

> >> +{
> >> +	struct timer_info *find = NULL;
> >> +	struct timer_info timer_info = {
> >> +			.timer = timer,
> >> +			.itimer_type = itimer_type,
> >> +		};
> >> +
> >> +	find = timer_search(&timer_info);
> >> +	if (find && find->type != type) {
> >> +
> >> +		dprintf("find timer[%p], but type[%s] is not we expect[%s],"
> >> +			"set to initializtion state.\n", find->timer,
> >> +			timer_type_string[find->type], timer_type_string[type]);
> >> +
> >> +		find->type = type;
> >> +		find->bug++;
> >> +		find->state = TIMER_INIT;
> > 
> >   Why does a timer_search fail ? And why is fixing up the type if it
> >   is not matching a good idea ?
> > 

> We search timer base on timer_info->timer and
> timer_info->itimer_type(not timer_info->type), if we find the
> timer's type is changed(for example, the timer is "ITIMER" before,
> and change to "HRTIMER" later), is should a bug. this case is hardly
> to happen but should catch it.

No, it's not a bug at all. You _can_ have a hrtimer and a timer_list
timer at the same address in a trace. There are two ways to make that
happen:

 1) kmalloc'ed memory contains a timer_list. timer operation is done,
    memory is kfreed. Now another kmalloc gets the just freed memory
    and has a hrtimer at the same address which was used by the
    timer_list before.

 2) timer_list and hrtimer are also allocated on stack. There is no
    guarantee that they are at different addresses.
 
> >> +static void *get_timer(enum timer_type type, struct event *event, void *data)
> >> +{
> >> +	if (type == HRTIMER) {
> >> +		void *hrtimer = NULL;
> >> +
> >> +		FILL_RAM_FIELD_PTR(event, hrtimer, data);
> >> +		return hrtimer;
> > 
> >   Shudder.
> > 
> > 	return raw_field_ptr(event, "hrtimer", data);
> > 
> 
> Yeah, it's a clear way.
> 
> >> +static void
> >> +itimer_state_handler(void *data, struct event *event, int this_cpu __used,
> >> +		     u64 timestamp __used, struct thread *thread)
> >> +{
> >> +	u64 value_sec, value_usec, expires;
> >> +	struct timer_info *timer_info;
> >> +	void *timer = NULL;
> >> +	int which;
> >> +
> >> +	FILLL_RAW_FIELD_VALUE(event, value_sec, data);
> >> +	FILLL_RAW_FIELD_VALUE(event, value_usec, data);
> >> +	FILLL_RAW_FIELD_VALUE(event, expires, data);
> >> +	FILLL_RAW_FIELD_VALUE(event, which, data);
> >> +	FILL_RAM_FIELD_PTR(event, timer, data);
> > 
> >   This is complete obfuscated, while
> > 
> >   value_sec = get_value(data, event, "value_sec");
> > 
> >   is obvious.
> > 
> 
> Sorry, i cannot get this. As i understand:
> 
> #define FILL_RAW_FIELD_VALUE(event, field, data)		\
> 	field = (typeof(field))raw_field_value(event, #field, data)
> 
> After FILL_RAW_FIELD_VALUE(event, value_sec, data) expanded, it's:
>   value_sec = raw_field_value(event, "value_sec", data)
> 
> Why it's wrong? :-(

Simply because the macro hides the fact that this is an assignment of
a value to a variable. That makes the code harder to read.

 	FILLL_RAW_FIELD_VALUE(event, value_sec, data);
vs.	
	value_sec = get_value(data, event, "value_sec");

The latter is fast to parse and entirely clear.

Btw, you agreed above that the open coded call of raw_field_value()
is clearer than the macro magic. :)

Thanks,

	tglx
