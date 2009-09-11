Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZIKQ3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZIKQ3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZIKQ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:29:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbZIKQ3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:29:11 -0400
Message-ID: <4AAA7B90.8010002@redhat.com>
Date: Fri, 11 Sep 2009 12:32:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH tracing/kprobes 5/7] tracing/kprobes: Add argument name
 support
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>	 <20090910235337.22412.77383.stgit@dhcp-100-2-132.bos.redhat.com> <1252678079.18996.665.camel@gandalf.stny.rr.com> <4AAA76B1.3020208@redhat.com>
In-Reply-To: <4AAA76B1.3020208@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Steven Rostedt wrote:
>> On Thu, 2009-09-10 at 19:53 -0400, Masami Hiramatsu wrote:
>>
>>> @@ -870,9 +892,13 @@ print_kprobe_event(struct trace_iterator *iter, int flags)
>>>    {
>>>    	struct kprobe_trace_entry *field;
>>>    	struct trace_seq *s =&iter->seq;
>>> +	struct trace_event *event;
>>> +	struct trace_probe *tp;
>>>    	int i;
>>>
>>>    	field = (struct kprobe_trace_entry *)iter->ent;
>>> +	event = ftrace_find_event(field->ent.type);
>>> +	tp = container_of(event, struct trace_probe, event);
>>
>> Can this function be called the data is in the ring buffer, but the
>> probe has been unregistered? If so, the result of ftrace_find_event be
>> NULL?
> 
> Hmm, it will depend on ftrace implementation. Before releasing
> trace_probe, kprobe tracer tries to unregister event call.
> If it's correctly locking mutex or some rw_lock for both of
> unregistering and printing, it will be safe.
> 
> Unfortunately, it seems not :-(.
> 
> In trace_events.c,
> 1054 static void __trace_remove_event_call(struct ftrace_event_call *call)
> 1055 {
> 1056         ftrace_event_enable_disable(call, 0);
> 1057         if (call->event)
> 1058                 __unregister_ftrace_event(call->event);
> 
> What we need to do is calling unregister_ftrace_event() instead of
> __unregister_ftrace_event.

Aah, NO. the caller of trace_remove_event_call() should have
trace_event_mutex before calling!


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

