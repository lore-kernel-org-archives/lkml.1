Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbZA3M4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbZA3M4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 07:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZA3Mzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 07:55:53 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:65349 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZA3Mzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 07:55:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=jmwiGB/uwneRfpIqeiEgpzCEAaEh9sueszwXNusFd4wtTLiYvT7a8zRCMIIwkd0ian
         v3ppgMHSiYvaIDCZsHhaBZlq6Maw43HiyFUw80c/mQEd8PRVax7wTIxX7B/RHWucAck0
         EVzwcPw+C+Utju1TkCe5YOmpHiWj0+cJ1G+Tk=
MIME-Version: 1.0
In-Reply-To: <20090130123916.GR627@ghostprotocols.net>
References: <4982c159.190c660a.7424.ffffabf9@mx.google.com>
	 <20090130123446.GQ627@ghostprotocols.net>
	 <20090130123916.GR627@ghostprotocols.net>
Date: Fri, 30 Jan 2009 13:55:50 +0100
Message-ID: <c62985530901300455h55695931nb67936e0e5b54aeb@mail.gmail.com>
Subject: Re: [PATCH] tracing/ftrace: better manage the context info for events
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/30 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> Em Fri, Jan 30, 2009 at 10:34:46AM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Fri, Jan 30, 2009 at 12:59:05AM -0800, Frederic Weisbecker escreveu:
>> > Impact: make trace_event more convenient for tracers
>> >
>> > All tracers (for the moment) that use the struct trace_event want to have
>> > the context info printed before their own output: the pid/cmdline, cpu, and timestamp.
>> >
>> > But some other tracers that want to implement their trace_event callbacks will
>> > not necessary need these information or they may want to format them as they want.
>> >
>> > This patch adds a new default-enabled trace option: TRACE_ITER_CONTEXT_INFO
>> > When disabled through:
>> >
>> > echo nocontext-info > /debugfs/tracing/trace_options
>> >
>> > The pid, cpu and timestamps headers will not be printed.
>> >
>> > IE with the sched_switch tracer with context-info (default):
>> >
>> >             bash-2935  [001]   100.356561:   2935:120:S ==> [001]     0:140:R <idle>
>> >           <idle>-0     [000]   100.412804:      0:140:R   + [000]    11:115:S events/0
>> >           <idle>-0     [000]   100.412816:      0:140:R ==> [000]    11:115:R events/0
>> >         events/0-11    [000]   100.412829:     11:115:S ==> [000]     0:140:R <idle>
>> >
>> > Without context-info:
>> >
>> >   2935:120:S ==> [001]     0:140:R <idle>
>> >      0:140:R   + [000]    11:115:S events/0
>> >      0:140:R ==> [000]    11:115:R events/0
>> >     11:115:S ==> [000]     0:140:R <idle>
>> >
>> > A tracer can disable it at runtime by clearing the bit TRACE_ITER_CONTEXT_INFO in trace_flags.
>> >
>> > Moreover, two callbacks have been added inside trace_event:
>> > _ context_info() which let a tracer override the format of the context info
>> > _ lat_context_info() which do the same with the latency_trace file
>> >
>> > If they are not defined, the usual way of printing the context info will be used.
>>
>> Please wait a bit, I'm trying to use it and the first thing I notice was
>> that I need the trace_iterator in the context callback, to get the
>> timestamp.
>
> Sorry, false alarm, the iterator is there, I was trying to build the
> whole binary trace record in the trace_event->bin(), but its not
> possible, so I'll do it in two function calls context + trace.
>
> - Arnaldo
>

Do you need the trace_iterator from one of your event print callback?
Such as in bin() ?
