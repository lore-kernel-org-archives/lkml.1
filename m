Return-Path: <linux-kernel-owner+w=401wt.eu-S933766AbZHGU0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbZHGU0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933750AbZHGU0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:26:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:41030 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933702AbZHGU0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QzZXNkcHEK/Iw9+vsUPP206Li6jVx1pnSf3PKKcx+GtDMfuHVxLYq7bqEzgtVi1kHl
         IzC6rJdJ91N7MAMEpxDN071PA7lb6UuTXBK4Zdi9+MnQ5w+KcQ65ZHEBngiB3qDSaPae
         Ry08J4S8gniZ+KGUL9mGMc0AHZWYglltxUa00=
Date: Fri, 7 Aug 2009 22:26:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Mackerras <paulus@samba.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] perfcounters: Support for ftrace event records sampling
Message-ID: <20090807202630.GE4999@nowhere>
References: <1249601154-5597-1-git-send-email-fweisbec@gmail.com> <1249641477.32113.664.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249641477.32113.664.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 12:37:57PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-08-07 at 01:25 +0200, Frederic Weisbecker wrote:
> > This patch brings the kernel side support for ftrace event record
> > sampling.
> > 
> > A new counter attribute is added: PERF_SAMPLE_TP_RECORD which requests
> > ftrace events record sampling.
> > 
> 
> > +	PERF_SAMPLE_TP_RECORD			= 1U << 10,
> 
> I'd really want this thing called PERF_SAMPLE_RAW
> 
> > -	PERF_SAMPLE_MAX = 1U << 10,		/* non-ABI */
> > +	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
> >  };
> >  
> >  /*
> > @@ -413,6 +414,11 @@ struct perf_callchain_entry {
> >  	__u64				ip[PERF_MAX_STACK_DEPTH];
> >  };
> >  
> > +struct perf_tracepoint_record {
> > +	int				size;
> > +	char				*record;
> > +};
> 
> Which would make this:
> 
> struct perf_raw_record {
> 	u32	size;
> 	void 	*data;
> };
> 
> >  struct task_struct;
> >  
> >  /**
> > @@ -681,6 +687,7 @@ struct perf_sample_data {
> >  	struct pt_regs			*regs;
> >  	u64				addr;
> >  	u64				period;
> > +	void				*private;
> >  };
> 
> might as well make that struct perf_raw_record *raw;



Ok. Yeah that's far more generic (and typed).


> 
> > @@ -649,5 +617,99 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
> >  
> >  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> >  
> > +/*
> > + * Define the insertion callback to profile events
> > + *
> > + * The job is very similar to ftrace_raw_event_<call> except that we don't
> > + * insert in the ring buffer but in a perf counter.
> > + *
> > + * static void ftrace_profile_<call>(proto)
> > + * {
> > + *	struct ftrace_data_offsets_<call> __maybe_unused __data_offsets;
> > + *	struct ftrace_event_call *event_call = &event_<call>;
> > + *	extern void perf_tpcounter_event(int, u64, u64, void *, int);
> > + *	struct ftrace_raw_##call *entry;
> > + *	u64 __addr = 0, __count = 1;
> > + *	unsigned long irq_flags;
> > + *	int __entry_size;
> > + *	int __data_size;
> > + *	int pc;
> > + *
> > + *	local_save_flags(irq_flags);
> > + *	pc = preempt_count();
> > + *
> > + *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
> > + *	__entry_size = __data_size + sizeof(*entry);
> > + *
> > + *	do {
> > + *		char raw_data[__entry_size]; <- allocate our sample in the stack
> > + *		struct trace_entry *ent;
> > + *
> > + *		entry = (struct ftrace_raw_<call> *)raw_data;
> > + *		ent = &entry->ent;
> > + *		tracing_generic_entry_update(ent, irq_flags, pc);
> > + *		ent->type = event_call->id;
> > + *
> > + *		<tstruct> <- do some jobs with dynamic arrays
> > + *
> > + *		<assign>  <- affect our values
> > + *
> > + *		perf_tpcounter_event(event_call->id, __addr, __count, entry,
> > + *			     __entry_size);  <- submit them to perf counter
> > + *	} while (0);
> > + *
> > + * }
> > + */
> > +
> > +#ifdef CONFIG_EVENT_PROFILE
> > +
> > +#undef __perf_addr
> > +#define __perf_addr(a) __addr = (a)
> > +
> > +#undef __perf_count
> > +#define __perf_count(c) __count = (c)
> > +
> > +#undef TRACE_EVENT
> > +#define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> > +static void ftrace_profile_##call(proto)				\
> > +{									\
> > +	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
> > +	struct ftrace_event_call *event_call = &event_##call;		\
> > +	extern void perf_tpcounter_event(int, u64, u64, void *, int);	\
> > +	struct ftrace_raw_##call *entry;				\
> > +	u64 __addr = 0, __count = 1;					\
> > +	unsigned long irq_flags;					\
> > +	int __entry_size;						\
> > +	int __data_size;						\
> > +	int pc;								\
> > +									\
> > +	local_save_flags(irq_flags);					\
> > +	pc = preempt_count();						\
> > +									\
> > +	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> > +	__entry_size = __data_size + sizeof(*entry);			\
> > +									\
> > +	do {								\
> > +		char raw_data[__entry_size];				\
> > +		struct trace_entry *ent;				\
> > +									\
> > +		entry = (struct ftrace_raw_##call *)raw_data;		\
> > +		ent = &entry->ent;					\
> > +		tracing_generic_entry_update(ent, irq_flags, pc);	\
> > +		ent->type = event_call->id;				\
> > +									\
> > +		tstruct							\
> > +									\
> > +		{ assign; }						\
> > +									\
> > +		perf_tpcounter_event(event_call->id, __addr, __count, entry,\
> > +			     __entry_size);				\
> > +	} while (0);							\
> > +									\
> > +}
> 
> ok, so the one concern I have here is that the data needs to fit on the
> stack. What if someone puts a large string in the data?



Yeah, I'll try to fix this by storing strings as pointers and copy
them in perf counter output only.

TODO-listed, with all the above.



> > +
> > +#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
> > +#endif /* CONFIG_EVENT_PROFILE */
> > +
> >  #undef _TRACE_PROFILE_INIT
> >  
> > diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> > index 06d210c..93f4312 100644
> > --- a/kernel/perf_counter.c
> > +++ b/kernel/perf_counter.c
> > @@ -2646,6 +2646,7 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
> >  		u64 counter;
> >  	} group_entry;
> >  	struct perf_callchain_entry *callchain = NULL;
> > +	struct perf_tracepoint_record *tp;
> >  	int callchain_size = 0;
> >  	u64 time;
> >  	struct {
> > @@ -2714,6 +2715,11 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
> >  			header.size += sizeof(u64);
> >  	}
> >  
> > +	if (sample_type & PERF_SAMPLE_TP_RECORD) {
> > +		tp = data->private;
> > +		header.size += tp->size;
> > +	}
> > +
> >  	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
> >  	if (ret)
> >  		return;
> > @@ -2777,6 +2783,9 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
> >  		}
> >  	}
> >  
> > +	if (sample_type & PERF_SAMPLE_TP_RECORD)
> > +		perf_output_copy(&handle, tp->record, tp->size);
> > +
> >  	perf_output_end(&handle);
> >  }
> 
> You seem to fail to round up to a multiple of u64 somewhere along the
> line, that'll mess things up as events are supposed to be u64 aligned.


Indeed.



> 
> > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > index 6da0992..90c9808 100644
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -412,6 +412,7 @@ static void create_counter(int counter, int cpu, pid_t pid)
> >  	if (call_graph)
> >  		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
> >  
> > +
> >  	attr->mmap		= track;
> >  	attr->comm		= track;
> >  	attr->inherit		= (cpu < 0) && inherit;
> 
> Do we really need that extra whitespace?


Sorry, I added the explicit PERF_SAMPLE_TP_RECORD here to test this patch
and forgot the newline when I removed it :-s

