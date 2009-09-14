Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbZINDCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbZINDCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 23:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZINDCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 23:02:46 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:42586 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbZINDCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 23:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V67ASTXmVdXbG9oHEFnVJq7uV5NxwVuPoz5T7Z5VVKmiB2yuP+YOgVaYQG3m8G0PTS
         KWtuEIbmz/H0YQxQXcd1f2SIwOwbYYe0ZFbAoO/G1KsqhGzjaIXo0OKOR0xgM0ZVakSW
         gTJClYNRzEJtyl6KlxWlQkCDeLgyw7trHY3jI=
Date: Mon, 14 Sep 2009 05:02:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH tracing/kprobes 4/7] tracing/kprobes: Add event
	profiling support
Message-ID: <20090914030244.GC14306@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere> <4AAA7938.7070200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAA7938.7070200@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 12:22:16PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>>> +static int probe_profile_enable(struct ftrace_event_call *call)
>>> +{
>>> +	struct trace_probe *tp = (struct trace_probe *)call->data;
>>> +
>>> +	if (atomic_inc_return(&call->profile_count))
>>> +		return 0;
>>> +
>>> +	if (probe_is_return(tp)) {
>>> +		tp->rp.handler = kretprobe_profile_func;
>>> +		return enable_kretprobe(&tp->rp);
>>> +	} else {
>>> +		tp->rp.kp.pre_handler = kprobe_profile_func;
>>> +		return enable_kprobe(&tp->rp.kp);
>>> +	}
>>> +}
>>
>>
>>
>> May be I misunderstood but it seems that concurrent uses of
>> ftrace and perf would really mess up the result, as one would
>> overwrite the handler of the other.
>>
>> Even though it's hard to imagine one using both at the same
>> time on the same probe, but still...
>
> Oops, it's my misunderstanding. I thought those are exclusively
> enabled each other.


It's automatically managed with events because ftrace and
and perf have their individual tracepoint probes, because
tracepoints support multiple probes.


>> Is it possible to have two kprobes having the exact same
>> properties? (pointing to the same address, having the same
>> probe handlers, etc...)
>>
>> Another solution would be to allow kprobes to have multiple
>> handlers.
>
> It could be to have multiple kprobes on same point, but I think
> it's waste of the memory and time in this case.


Yeah.


>
> I'd like to have a dispatcher function and flags internally :)


You mean kprobes that could support multiple probes?
That would be a nice solution IMHO...

