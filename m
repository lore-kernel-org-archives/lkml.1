Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbZA3OOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbZA3OOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZA3OOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:14:23 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:43999 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZA3OOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=S33TxbeaoZht5rEIWYKIS8HUJmEGckoJ11VCUkBBqEVaMuigGdSvesKVwJ2T1fkwKQ
         PQzUwd69tXZ/CBWuy5oxrtDzAGUx6RvPLnuGNNv0AyQYLNstKxEqicnZ2D6+wyFN9LwH
         WG0N5oCErCZozYVwB6erKDcw9EB6VMuArLxUs=
MIME-Version: 1.0
In-Reply-To: <20090130135411.GT627@ghostprotocols.net>
References: <4982c159.190c660a.7424.ffffabf9@mx.google.com>
	 <20090130123446.GQ627@ghostprotocols.net>
	 <20090130123916.GR627@ghostprotocols.net>
	 <c62985530901300455h55695931nb67936e0e5b54aeb@mail.gmail.com>
	 <20090130132126.GS627@ghostprotocols.net>
	 <20090130135411.GT627@ghostprotocols.net>
Date: Fri, 30 Jan 2009 15:14:19 +0100
Message-ID: <c62985530901300614g5f3e3235q21b03a53c2f6a153@mail.gmail.com>
Subject: Re: [PATCH] tracing/ftrace: better manage the context info for events
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/30 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> Em Fri, Jan 30, 2009 at 11:21:26AM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Fri, Jan 30, 2009 at 01:55:50PM +0100, Frédéric Weisbecker escreveu:
>> > 2009/1/30 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
>> > > Em Fri, Jan 30, 2009 at 10:34:46AM -0200, Arnaldo Carvalho de Melo escreveu:
>> > >> Em Fri, Jan 30, 2009 at 12:59:05AM -0800, Frederic Weisbecker escreveu:
>> > >> > Impact: make trace_event more convenient for tracers
>> > >> >
>> > >> > All tracers (for the moment) that use the struct trace_event want to have
>> > >> > the context info printed before their own output: the pid/cmdline, cpu, and timestamp.
>> > >> >
>> > >> > But some other tracers that want to implement their trace_event callbacks will
>> > >> > not necessary need these information or they may want to format them as they want.
>> > >> >
>> > >> > This patch adds a new default-enabled trace option: TRACE_ITER_CONTEXT_INFO
>> > >> > When disabled through:
>> > >> >
>> > >> > echo nocontext-info > /debugfs/tracing/trace_options
>> > >> >
>> > >> > The pid, cpu and timestamps headers will not be printed.
>> > >> >
>> > >> > IE with the sched_switch tracer with context-info (default):
>> > >> >
>> > >> >             bash-2935  [001]   100.356561:   2935:120:S ==> [001]     0:140:R <idle>
>> > >> >           <idle>-0     [000]   100.412804:      0:140:R   + [000]    11:115:S events/0
>> > >> >           <idle>-0     [000]   100.412816:      0:140:R ==> [000]    11:115:R events/0
>> > >> >         events/0-11    [000]   100.412829:     11:115:S ==> [000]     0:140:R <idle>
>> > >> >
>> > >> > Without context-info:
>> > >> >
>> > >> >   2935:120:S ==> [001]     0:140:R <idle>
>> > >> >      0:140:R   + [000]    11:115:S events/0
>> > >> >      0:140:R ==> [000]    11:115:R events/0
>> > >> >     11:115:S ==> [000]     0:140:R <idle>
>> > >> >
>> > >> > A tracer can disable it at runtime by clearing the bit TRACE_ITER_CONTEXT_INFO in trace_flags.
>> > >> >
>> > >> > Moreover, two callbacks have been added inside trace_event:
>> > >> > _ context_info() which let a tracer override the format of the context info
>> > >> > _ lat_context_info() which do the same with the latency_trace file
>> > >> >
>> > >> > If they are not defined, the usual way of printing the context info will be used.
>> > >>
>> > >> Please wait a bit, I'm trying to use it and the first thing I notice was
>> > >> that I need the trace_iterator in the context callback, to get the
>> > >> timestamp.
>> > >
>> > > Sorry, false alarm, the iterator is there, I was trying to build the
>> > > whole binary trace record in the trace_event->bin(), but its not
>> > > possible, so I'll do it in two function calls context + trace.
>> > >
>> > > - Arnaldo
>> > >
>> >
>> > Do you need the trace_iterator from one of your event print callback?
>> > Such as in bin() ?
>>
>> Yes, I'm finding the callbacks a complicating factor, I think that we
>> should have instead a flag in the struct trace_event and struct tracer
>> telling that we don't need the context printed and the default routine
>> exported to tracers.
>>
>> That way minimise change on the old tracers but allow new ones to use
>> the default context to be called from trace_event->trace() and not from
>> trace_event->bin().
>>
>> So, to summarize, for blktrace I would use:
>>
>> struct trace_event {
>>       .flags  = DONT_PRINT_CONTEXT | OTHER_FUTURE_FLAGS,
>>       .bin    = blktrace_print_bin,
>>       .trace  = blktrace_print_trace,
>> }
>>
>> blktrace_print_bin(iter)
>> {
>>       full control with access to iter to get timestamp, cpu, etc
>> }
>>
>> blktrace_print_trace(iter)
>> {
>>       print_default_context()
>>       print tracer specific stuff
>> }



I prefer that too.
It's makes it perhaps too much complex to have one callback for the
line headers, and one other for the
actual trace line.

IMHO, having all of the current callbacks inside trace_event with the
trace iterator as the only argument seems
sufficient to manage the whole line.

And embeeding this flag inside trace_event is better rather having it
global, zapping questions like "should we restore it when we switch
the tracer, has its value been changed by the user?".
its value changed recently..?)


>> Back to trying to use your patch to show the problems in the form of a
>> working blktrace synthesizer to use with:
>>
>> cat /d/tracing/trace_pipe | blkparse -i -
>
> Definetely, as it is it doesn't caters to the blktrace binary printing
> needs.
>
> The ->context info callback is not called if TRACE_ITER_BIN is selected,
> it should, as doing:
>
>        if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
>                SEQ_PUT_FIELD_RET(s, entry->pid);
>                SEQ_PUT_FIELD_RET(s, entry->cpu);
>                SEQ_PUT_FIELD_RET(s, iter->ts);
>        }
>
> is only the default context info for binary mode, what if I want to
> provide a different context info?
>
> I'll try to rework your patch into something that is useful for my needs
> and post here.


Ok.


> - Arnaldo
>
