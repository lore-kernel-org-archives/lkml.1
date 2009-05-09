Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZEINdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZEINdk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZEINdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:33:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39096 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbZEINda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:33:30 -0400
Date: Sat, 9 May 2009 15:33:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090509133306.GA20684@elte.hu>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu> <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> > Secondly, we should reuse the information we get in 
> > SYSCALL_DEFINE, to construct the TRACE_EVENT tracepoints 
> > directly - without having to list all syscalls again in a 
> > separate file.
> 
> Indeed, that's not trivial though, but feasible. I'm not sure we 
> can reuse the TRACE_EVENT macro directly inside SYSCALL_DEFINE. 
> The resulting macro tempest effect that would occur confuses me 
> and I have troubles to imagine the result.

Lets take an example. This syscall:

SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
                struct sched_param __user *, param)

Is equivalent to:

SYSCALL_DEFINE3(name, t1, v1, t2, v2, t3, v3)

('t' for type, 'v' for variable/value).

This would transform into the following TRACE_EVENT() construct:

TRACE_EVENT_SYSCALL2():

TRACE_EVENT(sys_##name,
	TP_PROTO(t1 v1, t2 v2),
	TP_ARGS(v1, v2),
	TP_STRUCT__entry(
		__field(t1, v1)
		__field(t2, v2)
	),
	TP_fast_assign(
		__entry->v1 = v1;
		__entry->v2 = v2;
	),
	TP_printk("%016Lx %016Lx", (u64)__entry->v1, (u64)__entry->v2)
);

We need TRACE_EVENT_SYSCALL[123456] definitions, and that's it.

The only place where we lose type information is the printk format - 
but that's not a big issue, as i'd expect the event record to be the 
main user of this.

[ In addition to this, we could extend DEFINE_SYSCALL[1..6] with a 
  (optional) format string definition field, and fill that in for 
  anything that matters. ]

Note, this assumes that all syscall types can be described via 
__field() - i think that's correct. (we dont want to deref strings 
as they are untrusted, and there are no arrays in syscall 
parameters)

Can you see any complication?

	Ingo
