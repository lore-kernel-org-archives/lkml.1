Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZEINu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZEINu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZEINus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:50:48 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:48805 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbZEINur convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:50:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah8GAH8lBUpMQW1W/2dsb2JhbACBT81Pg34F
Date: Sat, 9 May 2009 09:50:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090509135046.GA2344@Krystal>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu> <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com> <20090509133306.GA20684@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090509133306.GA20684@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:48:41 up 70 days, 10:14,  3 users,  load average: 1.06, 0.72,
	0.58
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > Secondly, we should reuse the information we get in 
> > > SYSCALL_DEFINE, to construct the TRACE_EVENT tracepoints 
> > > directly - without having to list all syscalls again in a 
> > > separate file.
> > 
> > Indeed, that's not trivial though, but feasible. I'm not sure we 
> > can reuse the TRACE_EVENT macro directly inside SYSCALL_DEFINE. 
> > The resulting macro tempest effect that would occur confuses me 
> > and I have troubles to imagine the result.
> 
> Lets take an example. This syscall:
> 
> SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
>                 struct sched_param __user *, param)
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
> 	TP_PROTO(t1 v1, t2 v2),
> 	TP_ARGS(v1, v2),
> 	TP_STRUCT__entry(
> 		__field(t1, v1)
> 		__field(t2, v2)
> 	),
> 	TP_fast_assign(
> 		__entry->v1 = v1;
> 		__entry->v2 = v2;
> 	),
> 	TP_printk("%016Lx %016Lx", (u64)__entry->v1, (u64)__entry->v2)
> );
> 
> We need TRACE_EVENT_SYSCALL[123456] definitions, and that's it.
> 
> The only place where we lose type information is the printk format - 
> but that's not a big issue, as i'd expect the event record to be the 
> main user of this.
> 
> [ In addition to this, we could extend DEFINE_SYSCALL[1..6] with a 
>   (optional) format string definition field, and fill that in for 
>   anything that matters. ]
> 
> Note, this assumes that all syscall types can be described via 
> __field() - i think that's correct. (we dont want to deref strings 
> as they are untrusted, and there are no arrays in syscall 
> parameters)
> 

I would expect to use copy_string_from_user (for strings)
and copy_from_user for structures, because without any strings
(especially), the trace information become much less useful.

This should probably be done at the TP_fast_assign level.

Note that ftrace fields do not support variable length strings, AFAIK.

Mathieu

> Can you see any complication?
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
