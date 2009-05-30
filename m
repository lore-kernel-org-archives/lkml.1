Return-Path: <linux-kernel-owner+w=401wt.eu-S1763235AbZE3NPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763235AbZE3NPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbZE3NPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:15:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49298 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbZE3NPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:15:11 -0400
Message-ID: <4A213181.5080201@redhat.com>
Date: Sat, 30 May 2009 09:15:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip v8 7/7] tracing: add kprobe-based event tracer
References: <20090529000326.17532.70868.stgit@localhost.localdomain> <20090529000353.17532.71995.stgit@localhost.localdomain> <alpine.DEB.2.00.0905300009230.14994@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905300009230.14994@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> 
> On Thu, 28 May 2009, Masami Hiramatsu wrote:
> 
>> +#undef SHOW_FIELD
>> +#define SHOW_FIELD(type, item, name)					\
>> +	do {								\
>> +		ret = trace_seq_printf(s, "\tfield: " #type " %s;\t"	\
>> +				"offset:%u;tsize:%u;\n", name,		\
>> +				(unsigned)offsetof(typeof(field), item),\
>> +				(unsigned)sizeof(type));		\
>> +		if (!ret)						\
>> +			return 0;					\
>> +	} while (0)
>> +
>> +static int __probe_event_show_format(struct ftrace_event_call *event_call,
>> +				     struct trace_seq *s, const char *fmt,
>> +				     const char *arg)
>> +{
>> +	struct kprobe_trace_entry field __attribute__((unused));
> 
> You use kprobe_trace_entry for both kprobe and kretprobe.

Ah, right. I'll fix that.

Thank you for reviewing!

> 
>> +	int ret, i;
>> +	char buf[MAX_ARGSTR_LEN + 1];
>> +	struct trace_probe *tp = container_of(event_call,
>> +					      struct trace_probe, call);
>> +
>> +	/* Show fields */
>> +	for (i = 0; i < tp->nr_args; i++) {
>> +		sprintf(buf, "arg%d", i);
>> +		SHOW_FIELD(unsigned long, args[i], buf);
>> +	}
>> +	trace_seq_puts(s, "\n");
>> +
>> +	/* Show aliases */
>> +	for (i = 0; i < tp->nr_args; i++) {
>> +		if (trace_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]))
>> +			return 0;
>> +		if (!trace_seq_printf(s, "\talias: %s;\toriginal: arg%d;\n",
>> +				      buf, i))
>> +			return 0;
>> +	}
>> +	/* Show format */
>> +	if (!trace_seq_printf(s, "\nprint fmt: \"%s", fmt))
>> +		return 0;
>> +
>> +	for (i = 0; i < tp->nr_args; i++)
>> +		if (!trace_seq_puts(s, " 0x%lx"))
>> +			return 0;
>> +
>> +	if (!trace_seq_printf(s, "\", %s", arg))
>> +		return 0;
>> +
>> +	for (i = 0; i < tp->nr_args; i++)
>> +		if (!trace_seq_printf(s, ", arg%d", i))
>> +			return 0;
>> +
>> +	return trace_seq_puts(s, "\n");
>> +}
>> +
>> +static int kprobe_event_show_format(struct ftrace_event_call *call,
>> +				    struct trace_seq *s)
>> +{
>> +	struct kprobe_trace_entry field __attribute__((unused));
>> +	int ret;
>> +
>> +	SHOW_FIELD(unsigned long, ip, "ip");
>> +	SHOW_FIELD(int, nargs, "nargs");
>> +
>> +	return __probe_event_show_format(call, s, "%lx:", "ip");
>> +}
>> +
>> +static int kretprobe_event_show_format(struct ftrace_event_call *call,
>> +				       struct trace_seq *s)
>> +{
>> +	struct kretprobe_trace_entry field __attribute__((unused));
>> +	int ret;
>> +
>> +	SHOW_FIELD(unsigned long, func, "func");
>> +	SHOW_FIELD(unsigned long, ret_ip, "ret_ip");
>> +	SHOW_FIELD(int, nargs, "nargs");
>> +
>> +	return __probe_event_show_format(call, s, "%lx <- %lx:",
>> +					  "func, ret_ip");
>> +}
> 
> Thus we end up with:
> 
> format:
> 	field:unsigned short common_type;	offset:0;	size:2;
> 	field:unsigned char common_flags;	offset:2;	size:1;
> 	field:unsigned char common_preempt_count;	offset:3;	
> size:1;
> 	field:int common_pid;	offset:4;	size:4;
> 	field:int common_tgid;	offset:8;	size:4;
> 
> 	field: unsigned long func;	offset:16;tsize:8;
> 	field: unsigned long ret_ip;	offset:24;tsize:8;
> 	field: int nargs;	offset:32;tsize:4;
> 	field: unsigned long arg0;	offset:32;tsize:8;
> 	field: unsigned long arg1;	offset:40;tsize:8;
> 	field: unsigned long arg2;	offset:48;tsize:8;
> 	field: unsigned long arg3;	offset:56;tsize:8;
> 
> Notice that nargs and arg0 are both at offest 32.
> 
> -- Steve
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

