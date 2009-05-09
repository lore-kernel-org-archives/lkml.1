Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZEIMxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZEIMxU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 08:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZEIMxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 08:53:10 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:59019 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZEIMxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 08:53:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QizlGK8ZNotFA/mp+OsBxeeVpU0+LdEYoCOabug7NaidknxdGvzFoi9e+/3fyIWWkI
         4Hco4X8745kG7IGE0+MEp8nN9wuOnmlDRy1NhLPT5C1uDrHkY+W1I5ZPzBwJjvBOyox2
         /+X+JfC8cKGOV4wuq8XezXeLF8eSIyJDKmQmc=
MIME-Version: 1.0
In-Reply-To: <20090509083737.GE3656@elte.hu>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu>
Date: Sat, 9 May 2009 14:53:06 +0200
Message-ID: <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com>
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/9 Ingo Molnar <mingo@elte.hu>:
>
> * Jason Baron <jbaron@redhat.com> wrote:
>
>> Hi,
>>
>> I've been thinking about converting the current ftrace syscall
>> tracer to the TRACE_EVENT() macros. There are a few issues with
>> the current syscall tracer approach:
>>
>> 1) It has to be enabled for all processes and all syscalls. By
>> moving to TRACE_EVENT(), it can be enabled/disabled per tracepoint
>> and can also make use of the generic tracing filters, such as
>> "trace all process for pid x"
>>
>> 2) Other tracers can not tie into it, since its not tracepoint
>> based. TRACE_EVENT() fixes this.
>>
>> 3) data formatting. The syscall tracer I don't believe understands
>> all the various types for output formatting. By moving to
>> TRACE_EVENT(), we can print out a more readible syscall trace.
>>
>> 4) The ftrace syscall tracer needs a new arch specific code for
>> each architecture. By converting to TRACE_EVENT() we don't need
>> any architecutre specific code.
>>
>> Other issues to consider:
>>
>> * Maintainence. The current syscall tracer automatically picks up
>> new syscalls. The TRACE_EVENT() will be harder to initially set
>> up. But once its done, syscalls are obviously not added often. So
>> I don't think this will be too bad.
>>
>> * Performance. The current syscall tracer adds a
>> 'test_thread_flag()' to syscall entry/exit. The TRACE_EVENT()
>> would add a per-syscall global to check. So they are going to have
>> different cache profiles...however, the tracepoint infrastructure
>> is hopefully moving to the 'immediate' value work, which will make
>> this more highly optimized.
>>
>> I've also tested the patch shown below (which uses,
>> DECLARE_TRACE(), as a preliminary proof of concept), using
>> getpid() in a loop, and tbench, and saw very small performance
>> differences. Obviously we would have to do more extensive testing
>> before deciding.
>>
>> Patch is pretty rough, but should give a rough sense of what the
>> DECLARE_TRACE() type patch might look like...
>
> Yeah, i very much agree with the direction. (I've Cc:-ed Tom Zanussi
> who also has expressed interest in this.)
>
> I'm not sure about the implementation as you've posted it though:
>
> Firstly, it adds two new tracepoints to every system call. That is
> unnecessary - we already have the TIF flag based callbacks, and we
> can use the existing syscall attributes table to get to tracepoints
> - without slow down (or impacting) the fast path in any way.



Agreed, that's unnecessary because we already hook in ptrace without
impacting the off-case.



> Secondly, we should reuse the information we get in SYSCALL_DEFINE,
> to construct the TRACE_EVENT tracepoints directly - without having
> to list all syscalls again in a separate file.


Indeed, that's not trivial though, but feasible.
I'm not sure we can reuse the TRACE_EVENT macro directly inside SYSCALL_DEFINE.
The resulting macro tempest effect that would occur confuses me and I
have troubles to imagine the result.
