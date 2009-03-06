Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZCFX3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZCFX3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 18:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZCFX2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 18:28:51 -0500
Received: from smtp-out.google.com ([216.239.45.13]:48786 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZCFX2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 18:28:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=kWmodv1JpUfKwdy61YEoKaBJm919hDlxOkhB9iiVZwvRa5pkhH73RmnbZsFVQiZ6X
	ccMajnt/8WOwhV9y1d4WA==
MIME-Version: 1.0
In-Reply-To: <20090306191052.GB16067@Krystal>
References: <20090304024921.153061228@goodmis.org>
	 <20090304170015.GB1150@Krystal>
	 <alpine.DEB.2.00.0903061124400.23248@gandalf.stny.rr.com>
	 <20090306191052.GB16067@Krystal>
Date: Fri, 6 Mar 2009 15:28:39 -0800
Message-ID: <5df78e1d0903061528v1db73ab8g1f470c569ea37b70@mail.gmail.com>
Subject: Re: [PATCH 0/5] [RFC] binary reading of ftrace ring buffers
From: Jiaying Zhang <jiayingz@google.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for getting into this discussion late.

I would like to point out that we think it is really important to have
some very efficient probing mechanism in the kernel for tracing in
production environments. The printf and va_arg based probes are
flexible but less efficient when we want to trace high-throughput events.
Even function calls can add noticeable overhead according to our
measurements. So I think we need to provide a way (mostly via
macro definitions) with which a subsystem can enter an event into
a trace buffer through a short code path. I.e., we should limit the
number of callbacks and avoid format string parsing.

As I understand, Steven's latest TRACE_FIELD patch avoids such
overhead, although it does seem to add complexity for adding new
trace points. It would be nice if we can replace the above sched_switch
declaration with just a couple of macros.

Jiaying


On Fri, Mar 6, 2009 at 11:10 AM, Mathieu Desnoyers
<compudj@krystal.dyndns.org> wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
>>
>> On Wed, 4 Mar 2009, Mathieu Desnoyers wrote:
>> > >
>> > > From previous patches, we have in include/trace/sched_event_types.h:
>> > >
>> > > #undef TRACE_SYSTEM
>> > > #define TRACE_SYSTEM sched
>> > >
>> > > TRACE_EVENT_FORMAT(sched_switch,
>> > >   TPPROTO(struct rq *rq, struct task_struct *prev,
>> > >           struct task_struct *next),
>> > >   TPARGS(rq, prev, next),
>> > >   TPFMT("task %s:%d ==> %s:%d",
>> > >         prev->comm, prev->pid, next->comm, next->pid),
>> > >   TRACE_STRUCT(
>> > >           TRACE_FIELD(pid_t, prev_pid, prev->pid)
>> > >           TRACE_FIELD(int, prev_prio, prev->prio)
>> > >           TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
>> > >                               next_comm,
>> > >                               TPCMD(memcpy(TRACE_ENTRY->next_comm,
>> > >                                            next->comm,
>> > >                                            TASK_COMM_LEN)))
>> > >           TRACE_FIELD(pid_t, next_pid, next->pid)
>> > >           TRACE_FIELD(int, next_prio, next->prio)
>> > >   ),
>> > >   TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
>> > >   );
>> > >
>> >
>> > I fear that putting these user-visible format strings in tracepoint
>> > header files will create a big maintainability issue.
>> >
>> > I'll post the LTTng patchset in a jiffy, where the format string
>> > awareness is done in a tracer-specific module. I don't understand why
>> > Peter Z. is not yelling against your tracepoints modifications : they
>> > are actually presenting to userspace an interface that is meant to
>> > eventually change.
>> >
>> > I used a separate layer for format string presentation for this very
>> > purpose : I don't want to tie the kernel code instrumentation
>> > (tracepoints) to any kind of user-visible API.
>> >
>>
>> Hi Mathieu,
>>
>> Sorry for the late reply, I started to reply but was distracted, and sadly
>> forgot about it :-(  (and I rebooted the box that had the reply window
>> open)
>>
>>
>> Just a couple of points to make.
>>
>> 1)  The raw format string is a "hint" for userspace to read the buffers.
>> The offset and sizeof is the real data that userspace should use. The
>> print format can be just a way to help them out. But it is by no means
>> something that is expected to be constant.
>>
>> It is also used internal by ftrace because it needs a way to read the
>> "fast C style recording" records. It is better to print some text than to
>> have a bunch of hex print out in the screen. Say you have the C style
>> recording enabled and you take an oops. With ftrace_dumps_on_oops set, the
>> buffers will be printed to the console.  This lets ftrace have a means to
>> print out the events.
>>
>> 2) The difference between this and markers is that the format string is
>> bound to the declaration in the trace header. Not in the code itself. The
>> maintainer should only see the trace point function call. It should only
>> look like a function call and not some funky printf string that the
>> maintainer might not care about.
>>
>> If the code changes and it breaks the format string, it is up to the
>> tracing maintainers to fix it. If the format string was embedded within
>> the code, then the maintainer would be burdoned with that duty. But here
>> the format string is in the include/trace directory and any breakage there
>> should definitely be fixed by a some tracing maintainer. Not the
>> maintainer of the subsystem. Unless of course that maintainer wants to fix
>> it ;-)
>>
>>
>> 3) TRACE_EVENT_FORMAT is an extension to TRACE_FORMAT. Developers may
>> choose to use the more simple, but a bit more expensive TRACE_FORMAT if
>> they choose to. Perhaps it may be more prudent to anyway. Recently
>> Peter Zijlstra was tracing locks and just wanted to trace the name.
>> There's really no difference in copying the name via a C style (strcpy) or
>> having a printf formatting do the work. Here is a case where just using
>> TRACE_FORMAT is a reasonable solution.
>>
>> 4) I actually avoided moving the format string into the tracing utility.
>> The tracing utility can ignore it if it wants. I orginially had the
>> headers included in the kernel/trace/events.c file and found that was too
>> cumbersome. I did not like the fact that I needed to go into some tracing
>> infrastructure to add an event.  It was a burdon to me to add a new event
>> and I wrote the code!  That's why I moved it all into the include/trace
>> directory. One stop shopping.
>>
>> A developer to add new events only needs to add the trace points in their
>> code and then update the files (perhaps add new ones) in include/trace. No
>> need to dig through the kernel source to find out where else they need to
>> go.
>>
>>
>> I see that you published your patch queue. I've looked at most of the
>> patches already. I'll make my comments shortly.
>>
>
> Hi Steve,
>
> I totally agree that we want something like a format string to identify
> the data we export. My disagreement is on the location where such
> identification belongs. I have the funny feeling that you are currently
> creating no less than full-blown callbacks expressed as a weird, custom,
> macros-based, header definition, and I think it's seriously wrong.
>
> To paraphrase Andrew Morton : we are writing in C. Let's keep it that
> way.
>
> This is why I strongly prefer to use the tracepoint callback -> marker
> format string approach rather that putting any sort of format string in
> the tracepoint header.
>
> If what you really worry about is to have the ability to "quickly" add
> debug-style instrumentation when you write code, then you do not want,
> nor should ever, use a tracepoint, because tracepoint location is not
> meant to be decided without careful consideration. Markers are there
> fore this : you can add a quick-and-dirty one-liner :
>
>  trace_mark(group, event, "field_identifier1 %u  f_ident2 %u", ...);
>
> In your source code and you are all set. I don't see the problem with
> such approach ?
>
> Mathieu
>
>> Thanks,
>>
>> -- Steve
>>
>
> --
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
>
