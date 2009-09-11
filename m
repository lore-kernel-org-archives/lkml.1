Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZIKT1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZIKT1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZIKT1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:27:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926AbZIKT1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:27:11 -0400
Message-ID: <4AAAA550.9010203@redhat.com>
Date: Fri, 11 Sep 2009 15:30:24 -0400
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
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere>
In-Reply-To: <20090911031253.GD16396@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Sep 10, 2009 at 07:53:30PM -0400, Masami Hiramatsu wrote:
>> +#ifdef CONFIG_EVENT_PROFILE
>> +
>> +/* Kprobe profile handler */
>> +static __kprobes int kprobe_profile_func(struct kprobe *kp,
>> +					 struct pt_regs *regs)
>> +{
>> +	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
>> +	struct ftrace_event_call *call =&tp->call;
>> +	struct kprobe_trace_entry *entry;
>> +	int size, i, pc;
>> +	unsigned long irq_flags;
>> +
>> +	local_save_flags(irq_flags);
>> +	pc = preempt_count();
>> +
>> +	size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
>
>
>
> Note that the end-result must be u64 aligned for perf ring buffer.
> And this is a bit tricky.
> What is inserted in the perf ring buffer is:
>
> raw_trace + (u32)raw_trace_size
>
> So we must ensure that sizeof(raw_trace) + sizeof(u32)
> is well u64 aligned.
>
> We don't insert the trace_size ourself though, this is done
> from kernel/perf_counter.c
>
> But we need to handle the size of the size (sorry) in the final
> alignment.
> To sum-up: sizeof(raw_trace) doesn't need (shouldn't) to be u64
> aligned but sizeof(raw_trace) + sizeof(u32) must be.
>
> Given this aligned size, we then substract it by sizeof(u32)
> to have the needed size of the raw entry.
>
> This result gives you the size of char raw_data[], which
> is also the same size passed in perf_tpcounter_event().
>
> See?

Ah, I see. So the size to write to perf_tpcounter_event must be
'(a multiple number of sizeof(u64)) - sizeof(u32)', right?

(Hmm, why would not perf_counter align data by itself? :)

>
> That's why we have this in trace/ftrace.h:
>
> __data_size = "the real entry data size"
> __entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32), sizeof(u64));
> __entry_size -= sizeof(u32);
>
> do {
> 		char raw_data[__entry_size];
> 		...
> 		perf_tpcounter_event(event_call->id, __addr, __count, entry,
> 			     __entry_size);
> 		...
> } while (0);

Ok, I'll do that.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

