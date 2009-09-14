Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbZINQv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbZINQv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbZINQvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:51:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbZINQvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:51:20 -0400
Message-ID: <4AAE7540.9090009@redhat.com>
Date: Mon, 14 Sep 2009 12:54:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH tracing/kprobes 4/7] tracing/kprobes: Add event	profiling
 support
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere> <4AAA7938.7070200@redhat.com> <20090914030244.GC14306@nowhere>
In-Reply-To: <20090914030244.GC14306@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:
> On Fri, Sep 11, 2009 at 12:22:16PM -0400, Masami Hiramatsu wrote:
>> Frederic Weisbecker wrote:
>>>> +static int probe_profile_enable(struct ftrace_event_call *call)
>>>> +{
>>>> +	struct trace_probe *tp = (struct trace_probe *)call->data;
>>>> +
>>>> +	if (atomic_inc_return(&call->profile_count))
>>>> +		return 0;
>>>> +
>>>> +	if (probe_is_return(tp)) {
>>>> +		tp->rp.handler = kretprobe_profile_func;
>>>> +		return enable_kretprobe(&tp->rp);
>>>> +	} else {
>>>> +		tp->rp.kp.pre_handler = kprobe_profile_func;
>>>> +		return enable_kprobe(&tp->rp.kp);
>>>> +	}
>>>> +}
>>>
>>>
>>>
>>> May be I misunderstood but it seems that concurrent uses of
>>> ftrace and perf would really mess up the result, as one would
>>> overwrite the handler of the other.
>>>
>>> Even though it's hard to imagine one using both at the same
>>> time on the same probe, but still...
>>
>> Oops, it's my misunderstanding. I thought those are exclusively
>> enabled each other.
>
>
> It's automatically managed with events because ftrace and
> and perf have their individual tracepoint probes, because
> tracepoints support multiple probes.
>
>
>>> Is it possible to have two kprobes having the exact same
>>> properties? (pointing to the same address, having the same
>>> probe handlers, etc...)
>>>
>>> Another solution would be to allow kprobes to have multiple
>>> handlers.
>>
>> It could be to have multiple kprobes on same point, but I think
>> it's waste of the memory and time in this case.
>
>
> Yeah.
>
>
>>
>> I'd like to have a dispatcher function and flags internally :)
>
>
> You mean kprobes that could support multiple probes?
> That would be a nice solution IMHO...

Yeah, actually kprobes could support multiple probes on the
same point. But kprobe structure has many extensions which
kprobe-tracer doesn't need, e.g. post_handler/break_handler,
opcode, arch sprcific instructions.
Kretprobe consumes more memories for storing return points :(.

Thus, if we know there are two functions to be called on the
same probe point, I think it is better to have a dispatcher.
(Especially, in this case, we can call fixed functions, so
it's easier way.)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

