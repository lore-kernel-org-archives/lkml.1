Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbZIICUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbZIICUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZIICUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:20:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63705 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZIICUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:20:03 -0400
Message-ID: <4AA71080.7030503@cn.fujitsu.com>
Date: Wed, 09 Sep 2009 10:18:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] perf_counter: Add PERF_COUNTER_IOC_SET_FILTER ioctl
References: <4AA4C04D.1050201@cn.fujitsu.com>	 <4AA4C0B3.3070300@cn.fujitsu.com> <1252341871.7959.37.camel@laptop>	 <20090907164852.GA6485@elte.hu>  <1252342545.7959.42.camel@laptop> <1252393315.10919.4.camel@tropicana>
In-Reply-To: <1252393315.10919.4.camel@tropicana>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> Hrm,.. not at all sure about this.. what are the ABI implications?
>>> I think the ABI should be fine if it's always a sub-set of C syntax. 
>>> That would be C expressions initially. Hm?
>> Right, so I've no clue what filter expressions look like, and the
>> changelog doesn't help us at all. It doesn't mention its a well
>> considered decision to henceforth freeze the expression syntax.
>>
>> Of course, since filters so far only work with tracepoint things, and
>> since you can only come by tracepoint things through debugfs, and since
>> anything debugfs is basically a free-for-all ABI-less world, we might be
>> good, but then this is a very ill-defined ioctl() indeed.
>>
>> So please, consider this well -- there might not be a second chance.
>>
> 
> I've been meaning to write up something about the event filters - here's
> a first stab that hopefully helps explain them...
> 

Great!

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

Could you add your SOB and send it to Ingo?

Some nitpicks below:

> Tom
> 
> diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
> index 2bcc8d4..50fe510 100644
> --- a/Documentation/trace/events.txt
> +++ b/Documentation/trace/events.txt
> @@ -97,3 +97,160 @@ The format of this boot option is the same as described in section 2.1.
>  
>  See The example provided in samples/trace_events
>  
> +4. Event formats
> +================
> +
> +Each trace event has a 'format' file associated with it that contains
> +a description of each field in a logged event.  This information can
> +be used to parse the binary trace stream, and is also the place to
> +find the field names that can be used in event filters (see section 5
> +below).
> +
> +It also displays the format string that will be used to print the
> +event in text mode, along with the event name and ID used for
> +profiling.
> +
> +Every event has a set of 'common' fields associated with it; these are
> +the fields prefixed with 'common_'.  The other fields vary between
> +events and correspond to the fields defined in the TRACE_EVENT
> +definition for that event.
> +
> +Here's the information displayed for the 'sched_wakeup' event:
> +
> +# cat /debug/tracing/events/sched/sched_wakeup/format
> +
> +name: sched_wakeup
> +ID: 60
> +format:
> +	field:unsigned short common_type;	offset:0;	size:2;
> +	field:unsigned char common_flags;	offset:2;	size:1;
> +	field:unsigned char common_preempt_count;	offset:3;	size:1;
> +	field:int common_pid;	offset:4;	size:4;
> +	field:int common_tgid;	offset:8;	size:4;
> +
> +	field:char comm[TASK_COMM_LEN];	offset:12;	size:16;
> +	field:pid_t pid;	offset:28;	size:4;
> +	field:int prio;	offset:32;	size:4;
> +	field:int success;	offset:36;	size:4;
> +	field:int cpu;	offset:40;	size:4;
> +
> +print fmt: "task %s:%d [%d] success=%d [%03d]", REC->comm, REC->pid, REC->prio, REC->success, REC->cpu
> +
> +5. Event filtering
> +==================
> +

How about adding titles 5.1, 5.2, 5.3?

5.1 expression syntax

5.2 set a filter

5.3 clear a filter

5.4 subsystem filter

> +Trace events can be filtered in the kernel by associating boolean
> +'filter expressions' with them.  As soon as an event is logged into
> +the trace buffer, its fields are checked against the filter expression
> +associated with that event type.  An event with field values that
> +'match' the filter will appear in the trace output, and an event whose
> +values don't match will be discarded.  An event with no filter
> +associated with it matches everything, which is the default when no
> +filter has been set for an event.
> +
> +A filter expression consists of one or more 'predicates' that can be
> +combined using the logical operators '&&' and '||'.  A predicate is
> +simply a clause that compares the value of a field contained within a
> +logged event with a constant value and returns either 0 or 1 depending
> +on whether the field value matched (1) or didn't match (0):
> +
> +	  field-name relational-operator value
> +
> +Parentheses can be used to provide arbitrary logical groupings and
> +double-quotes can be used to prevent the shell from interpreting
> +operators as shell metacharacters.
> +
> +The field-names available for use in filters can be found in the
> +'format' files for trace events (see section 4 above).
> +
> +The relational-operators depend on the type of the field being tested:
> +
> +The operators available for numeric fields are:
> +    
> +==, !=, <, <=, >, >=
> +
> +And for string fields they are:
> +    
> +==, !=
> +
> +Currently, only exact string matches are supported.
> +
> +Currently, the maximum number of predicates in a filter is set at 16.
> +
> +A filter for an individual event is set by writing a filter expression
> +to the 'filter' file for the given event.
> +
> +For example:
> +
> +# cd /debug/tracing/events/sched/sched_wakeup
> +# echo "common_preempt_count > 4" > filter
> +
> +A slightly more involved example:
> +
> +# cd /debug/tracing/events/sched/sched_signal_send
> +# echo "((sig >= 10 && sig < 15) || sig == 17) && comm != bash" > filter
> +
> +If there was an error in the expression, you'll get an 'Invalid
> +argument' error when setting it, and the erroneous string along with
> +an error message can be seen by looking at the filter e.g.:
> +
> +# cd /debug/tracing/events/sched/sched_signal_send
> +# echo "((sig >= 10 && sig < 15) || dsig == 17) && comm != bash" > filter
> +-bash: echo: write error: Invalid argument
> +# cat filter
> +((sig >= 10 && sig < 15) || dsig == 17) && comm != bash
> +^
> +parse_error: Field not found
> +
> +Currently the caret for an error always appears at the beginning of
> +the filter string; the error message should be still be useful though

s/should be still be/should still be

> +even without more accurate position info.
> +    
> +To clear a filter, write a '0' to the filter file.
> +
> +For convenience, filters for every event in a subsystem can be set or
> +cleared as a group by writing a filter expression into the filter file
> +at the root of the subsytem.  Note, however, that if a filter for any
> +event within the subsystem lacks a field specified in the subsystem
> +filter, or if the filter can't be applied for any other reason, the
> +filter for that event will retain its previous setting.  This can
> +result in an unintended mixture of filters which could lead to
> +confusing (to the user who might think different filters are in
> +effect) trace output.  Only filters that reference just the common
> +fields can be guaranteed to propagate successfully to all events.
> +
> +To clear the filters for all events in a subsystem, write a '0' to the
> +subsystem's filter file.
> +
> +Here are a few subsystem filter examples that also illustrate the
> +above points:
> +
> +Clear the filters on all events in the sched subsytem:
> +
> +# cd /sys/kernel/debug/tracing/events/sched
> +# echo 0 > filter
> +# cat sched_switch/filter
> +none
> +# cat sched_switch/filter
> +none
> +
> +Set a filter using only common fields for all events in the sched
> +subsytem (all events end up with the same filter):
> +
> +# cd /sys/kernel/debug/tracing/events/sched
> +# echo common_pid == 0 > filter
> +# cat sched_switch/filter
> +common_pid == 0
> +# cat sched_wakeup/filter
> +common_pid == 0
> +
> +Attempt to set a filter using a non-common field for all events in the
> +sched subsytem (all events but those that have a prev_pid field retain
> +their old filters):
> +
> +# cd /sys/kernel/debug/tracing/events/sched
> +# echo prev_pid == 0 > filter
> +# cat sched_switch/filter
> +prev_pid == 0
> +# cat sched_wakeup/filter
> +common_pid == 0
> 
