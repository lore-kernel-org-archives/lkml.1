Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZIKQA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZIKQA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZIKQA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:00:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZIKQA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:00:26 -0400
Message-ID: <4AAA74D2.9060203@redhat.com>
Date: Fri, 11 Sep 2009 12:03:30 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based	event
 tracer update and perf support
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090911013332.GB16396@nowhere>
In-Reply-To: <20090911013332.GB16396@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Sep 10, 2009 at 07:52:58PM -0400, Masami Hiramatsu wrote:
>> Hi Frederic,
>>
>> This series fixes bugs and upgrades kprobe-based event tracer
>> as a dynamic event tracer on ftrace/perf tools. This also enhances
>> tracer output format to show each argument name and event name on
>> each entry.
>>
>> With this series, users can add trace events dynamically on ftrace
>> and use those events with perf tools as below.
>>
>> (Step.1) Define new events under new group
>>
>> $ echo p:mygroup/myprobe do_sys_open dfd=a0 filename=a1 flags=a2 mode=a3 \
>>   >  /debug/tracing/kprobes_events
>> $ echo r:mygroup/myretprobe do_sys_open rv>>  /debug/tracing/kprobes_events
>> $ cat /debug/tracing/kprobes_events
>> p:myprobe do_sys_open+0 dfd=a0 filename=a1 flags=a2 mode=a3
>> r:myretprobe do_sys_open+0 rv=rv
>>
>> (You can see that each argument has its name.)
>>
>>
>> (Step.2) Perf shows new events
>>
>> $ perf list
>> ...
>>     mygroup:myretprobe                         [Tracepoint event]
>>     mygroup:myprobe                            [Tracepoint event]
>> ...
>>
>>
>> (Step.3) Record events with perf
>>
>> $ perf record -f -e mygroup:myprobe:record -F 1 -a ls
>> ...
>> [ perf record: Captured and wrote 0.081 MB perf.data (~3544 samples) ]
>>
>>
>> (Step.4) Perf trace shows the result
>>
>> $ perf trace
>> version = 0.5
>>              perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=810d3f7 flags=98800 mode=1
>>              perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=bff7650c flags=8000 mode=1b6
>>              perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=bff7650c flags=98800 mode=bff7450c
>>              perf-1405  [000]     0.000000: myprobe: (c04b0a5c) dfd=ffffff9c filename=bff7650c flags=8000 mode=1b6
>
>
> Nice!
>
> May be another step in the todo-list that would be nice: define the format
> for a type. Like it's done from ftrace events.

Thanks!

BTW, I'm not sure what the type means. Each event already has its own
event ID and event_call. Could you tell me which part of ftrace I should
refer to ?


>>
>>
>> (Step.5) You can also use return probes.
>>
>> $ perf record -f -e mygroup:myretprobe:record -F 1 -a ls
>> ...
>> [ perf record: Captured and wrote 0.081 MB perf.data (~3544 samples) ]
>> $ perf trace
>> version = 0.5
>>              perf-1408  [000]     0.000000: myretprobe: (c04b0a5c<- c04b0b7d) rv=b
>>              perf-1408  [000]     0.000000: myretprobe: (c04b0a5c<- c04b0b7d) rv=c
>>              perf-1408  [000]     0.000000: myretprobe: (c04b0a5c<- c04b0b7d) rv=d
>>              perf-1408  [000]     0.000000: myretprobe: (c04b0a5c<- c04b0b7d) rv=c
>>
>>
>> TODO:
>> - Implement perf kprobe command to help defining new probes.
>
>
>
> Yeah!
>
> I wonder what could be the best workflow to use it.
>
> Imagine the following steps:
>
> - perf kprobe = define kprobes using C expression
> - perf record -e our_kprobes
> - perf trace
>
> That's way too much.
> Especially it's sad to be forced to define a kprobe, then
> get back its name, use it with record, and eventually
> unsheathe perf trace.
>
> I guess we should choose between the low level, very granular
> but uninviting method "kprobe + record + trace" and also an all
> in one quick approach.
>
> And that could be chosen from perf kprobe:
>
> Low level:
>
> perf kprobe --define-only [-p|-r] [probe_name] -a1 [arg1] -a2 [arg2] \
> 	    --format="%s %...."
>
> perf record -e kprobes:probe_name
> perf trace
>
> Quick:
>
> perf kprobe -p probe_name -a1 ..... cmdline| -a
>
> And after the profiled task is finished, it could launch perf trace
> by itself (or wait for a Ctrl + C if -a/wide profiling)

Another thought: expand record subcommand.

perf record -E "p|r:probe_name,place,arg1,arg2..."
perf trace

And kprobe accept multiple definitions

perf kprobe -E "p|r:probe_name,place,arg1,arg2..." -E ...



Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

