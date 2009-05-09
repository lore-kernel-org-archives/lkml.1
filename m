Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZEIOCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZEIOCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbZEIOCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:02:46 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:13544 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZEIOCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UwMLZO+kUcvB3alS4JxeQSG0AEJuQiSsnihrlGjo/YpcgWj4bjC4zEpI90Lg/mlkKB
         Q7hOiNbmSStBi50hi1sqqP4fLxiXiwnN6EeyGdtxWv1Bpkh+mP4NxLoDV53NlJSX8ch3
         9S2g8B5i+hVjXbg1BMSM5Hol5gIxXFlophys8=
MIME-Version: 1.0
In-Reply-To: <20090509133306.GA20684@elte.hu>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu>
	 <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com>
	 <20090509133306.GA20684@elte.hu>
Date: Sat, 9 May 2009 16:02:45 +0200
Message-ID: <c62985530905090702o536c8787m1910540d560a0a22@mail.gmail.com>
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 9 mai 2009 15:33, Ingo Molnar <mingo@elte.hu> a écrit :
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> > Secondly, we should reuse the information we get in
>> > SYSCALL_DEFINE, to construct the TRACE_EVENT tracepoints
>> > directly - without having to list all syscalls again in a
>> > separate file.
>>
>> Indeed, that's not trivial though, but feasible. I'm not sure we
>> can reuse the TRACE_EVENT macro directly inside SYSCALL_DEFINE.
>> The resulting macro tempest effect that would occur confuses me
>> and I have troubles to imagine the result.
>
> Lets take an example. This syscall:
>
> SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
>                struct sched_param __user *, param)
>
> Is equivalent to:
>
> SYSCALL_DEFINE3(name, t1, v1, t2, v2, t3, v3)
>
> ('t' for type, 'v' for variable/value).
>
> This would transform into the following TRACE_EVENT() construct:
>
> TRACE_EVENT_SYSCALL2():
>
> TRACE_EVENT(sys_##name,
>        TP_PROTO(t1 v1, t2 v2),
>        TP_ARGS(v1, v2),
>        TP_STRUCT__entry(
>                __field(t1, v1)
>                __field(t2, v2)
>        ),
>        TP_fast_assign(
>                __entry->v1 = v1;
>                __entry->v2 = v2;
>        ),
>        TP_printk("%016Lx %016Lx", (u64)__entry->v1, (u64)__entry->v2)
> );
>
> We need TRACE_EVENT_SYSCALL[123456] definitions, and that's it.



Yeah, no problem with that.
This is more about the headers dependency layer that I'm worrying.
I guess we should just try and see what happens :)


> The only place where we lose type information is the printk format -
> but that's not a big issue, as i'd expect the event record to be the
> main user of this.


Indeed, that's not a big issue.
We can also define the custom printer callback we are using in the syscall
tracer, and assign it without using tp_printk.


> [ In addition to this, we could extend DEFINE_SYSCALL[1..6] with a
>  (optional) format string definition field, and fill that in for
>  anything that matters. ]


Yeah,


> Note, this assumes that all syscall types can be described via
> __field() - i think that's correct. (we dont want to deref strings
> as they are untrusted, and there are no arrays in syscall
> parameters)


Yeah, but we can also define a __string_from_user(), should be trivial.


> Can you see any complication?


Just about the order of headers to include and headers dependencies....


>        Ingo
>
