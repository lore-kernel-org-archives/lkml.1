Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbZIKDM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbZIKDM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 23:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZIKDM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 23:12:56 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:26969 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZIKDM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 23:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZoI5q58GjRwz1dheEhYOF+2hfakzKrHartt7yZ+D/Va/9Tde75p+fseKw/iUYtdcMP
         Z8VO6p18xILn7247wMZf9UPhO2bBLl0T7Eu+VSELYzQTa63/nvO8VRuyzwHQZIvEBi1q
         dwPgnf/y3dtjqPCCHCKbYvnwGChgquEzRUlqs=
Date: Fri, 11 Sep 2009 05:12:54 +0200
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
Message-ID: <20090911031253.GD16396@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 07:53:30PM -0400, Masami Hiramatsu wrote:
> +#ifdef CONFIG_EVENT_PROFILE
> +
> +/* Kprobe profile handler */
> +static __kprobes int kprobe_profile_func(struct kprobe *kp,
> +					 struct pt_regs *regs)
> +{
> +	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
> +	struct ftrace_event_call *call = &tp->call;
> +	struct kprobe_trace_entry *entry;
> +	int size, i, pc;
> +	unsigned long irq_flags;
> +
> +	local_save_flags(irq_flags);
> +	pc = preempt_count();
> +
> +	size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);



Note that the end-result must be u64 aligned for perf ring buffer.
And this is a bit tricky.
What is inserted in the perf ring buffer is:

raw_trace + (u32)raw_trace_size

So we must ensure that sizeof(raw_trace) + sizeof(u32)
is well u64 aligned.

We don't insert the trace_size ourself though, this is done
from kernel/perf_counter.c

But we need to handle the size of the size (sorry) in the final
alignment.
To sum-up: sizeof(raw_trace) doesn't need (shouldn't) to be u64
aligned but sizeof(raw_trace) + sizeof(u32) must be.

Given this aligned size, we then substract it by sizeof(u32)
to have the needed size of the raw entry.

This result gives you the size of char raw_data[], which
is also the same size passed in perf_tpcounter_event().

See?

That's why we have this in trace/ftrace.h:

__data_size = "the real entry data size"
__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32), sizeof(u64));
__entry_size -= sizeof(u32);

do {
		char raw_data[__entry_size];
		...
		perf_tpcounter_event(event_call->id, __addr, __count, entry,
			     __entry_size);
		...
} while (0);


> +static int probe_profile_enable(struct ftrace_event_call *call)
> +{
> +	struct trace_probe *tp = (struct trace_probe *)call->data;
> +
> +	if (atomic_inc_return(&call->profile_count))
> +		return 0;
> +
> +	if (probe_is_return(tp)) {
> +		tp->rp.handler = kretprobe_profile_func;
> +		return enable_kretprobe(&tp->rp);
> +	} else {
> +		tp->rp.kp.pre_handler = kprobe_profile_func;
> +		return enable_kprobe(&tp->rp.kp);
> +	}
> +}



May be I misunderstood but it seems that concurrent uses of
ftrace and perf would really mess up the result, as one would
overwrite the handler of the other.

Even though it's hard to imagine one using both at the same
time on the same probe, but still...

Is it possible to have two kprobes having the exact same
properties? (pointing to the same address, having the same
probe handlers, etc...)

Another solution would be to allow kprobes to have multiple
handlers.

