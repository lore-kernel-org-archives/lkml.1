Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYH1KEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYH1KEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 06:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYH1KEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 06:04:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:22047 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYH1KEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 06:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bUviUQHKBNNkbVNs+h4qabZNZwidFPGwM2TJYrh0St7x+GG1pXWxJZEFXWN7u5CMzS
         acKyygE2AwsRzpZz2MLnfE9495yiTP1D3YeK0CmgNk1Dpo38gTCfE/lXUz49Uma4HQ7j
         a1gFQFiVWVvaiv4ChmeUVoNFMm1NIh+P1PURo=
Message-ID: <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com>
Date: Thu, 28 Aug 2008 11:04:36 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080827212130.4b8365a8@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B1D5CA.8000607@gmail.com>
	 <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com>
	 <20080827212130.4b8365a8@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pekka,

2008/8/27 Pekka Paalanen <pq@iki.fi>:
> IMHO we could just make ftrace_printk() work for all tracers. I doubt
> there will be need to be able to record nil bytes. The idea of a marker
> is to be a line of human readable text.
>
>> > +int __ftrace_printk(unsigned long ip, const char *fmt, ...)
>> > +{
>> > +       struct trace_array *tr = &global_trace;
>> > +       static DEFINE_SPINLOCK(trace_buf_lock);
>> > +       static char trace_buf[TRACE_BUF_SIZE];
>> > +       struct trace_array_cpu *data;
>> > +       struct trace_entry tmp_ent;
>> > +       unsigned long flags;
>> > +       long disabled;
>> > +       va_list ap;
>> > +       int cpu, len = 0;
>> > +
>> > +       if (likely(!ftrace_function_enabled))
>> > +               return 0;
>
> And that is the kind of check that makes current ftrace_printk() unusable.
> I think this restriction should be lifted and allow it to work on all
> tracers. I would also like to be able to have e.g. mmiotrace_marker(),
> which would have the same signature as ftrace_printk(), but is a no-op if
> mmiotrace is not active. So, we could have an __ftrace_vprintk() to make
> writing such wrappers easy. And the wrappers could be #ifdef'd away, if
> the corresponding tracer is not built.

I like your idea of a ftrace_vprintk wrapper.
But actually I'm questioning about the fact that the tracing api
itself is not generic enough.

At this time, a tracer has to put a function inside the tracing api
when it wants to add an entry into the list.
See __trace_mmiotrace_rw() for example.

Just imagine if one wants to implement a tracer by using a simple module.
The way seems to be simple at the beginning: you define your struct
tracer, implement your functions and register your tracer.
But the simple, single function that will add your entries has to be
put in tracing api.
It's quite impossible without changing the trace.c file and so
impossible without recompiling your kernel.

And if I make my own tracer and want to implement my handler for the
marker messages, I will have to put my foo_trace_printk in trace.c and
add it on the wrapper.

IMHO the choice of a wrapper is good but it should dynamically
dispatch the message on a handler proposed by the tracer. I think
about a new function pointer which could be called "mark" on the
struct tracer.

And (always IMHO) I think that functions like __trace_mmiotrace_rw()
shouldn't be located on trace.c but implemented on the appropriate
tracer (in this example: trace_mmiotrace.c).
And for this purpose, functions like tracing_generic_entry_update()
(or even more higher level function of entry adding) should be
symbol's exported.

With such a new environment, building personal and quick tracers by
using modules may be more appreciated if one has not to touch the
tracing API or the whole running kernel.

> I recall somewhere mentioning, that one shouldn't leave ftrace_printk's
> lying around in "final" code, so I'm not sure how people feel about this
> wrapping idea, especially when e.g. mmiotrace is hoped to be built-in by
> default. OTOH, I don't think in-tree drivers and stuff want to use them,
> so they would be mostly offered for out-of-tree modules
> (reverse-engineering) and developers (debugging). That makes me wonder
> if they would be accepted (as exported symbols).

Yes I think such a function should really be exported. For example
using mmiotrace on a module and beeing able to signal the fact that we
are entering the "foo" function seems to me very useful. It's
important to know where we are in all these IO for debugging....


>> >  static int print_trace_line(struct trace_iterator *iter)
>> >  {
>> > +       if (iter->ent->type == TRACE_MARK)
>> > +               return print_mark(iter);
>> > +
>
> Please, put this call after the following...
>
>> >        if (iter->trace && iter->trace->print_line)
>> >                return iter->trace->print_line(iter);
>
> ..so that tracers may override it at will. Mmiotrace needs to replace
> newlines and nil characters, before printing it in its own style, i.e.
> prefixed with a tag and a timestamp, which are specified in the mmiotrace
> log format.

Perhaps the idea of an appropriate "mark" handler for each tracer
could solve this...


> I didn't try the patch yet, or read it too carefully, but I should.
> Unfortunately I'm away the next weekend, so I hope to continue working
> on it the weekend after that.

No problem.

Thanks!
