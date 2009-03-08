Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZCHTWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZCHTWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 15:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZCHTWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 15:22:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52699 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbZCHTWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 15:22:10 -0400
Date: Sun, 8 Mar 2009 20:21:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiaying Zhang <jiayingz@google.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 0/5] [RFC] binary reading of ftrace ring buffers
Message-ID: <20090308192127.GA5888@elte.hu>
References: <20090304024921.153061228@goodmis.org> <20090304170015.GB1150@Krystal> <alpine.DEB.2.00.0903061124400.23248@gandalf.stny.rr.com> <20090306191052.GB16067@Krystal> <5df78e1d0903061528v1db73ab8g1f470c569ea37b70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5df78e1d0903061528v1db73ab8g1f470c569ea37b70@mail.gmail.com>
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


* Jiaying Zhang <jiayingz@google.com> wrote:

> I would like to point out that we think it is really important 
> to have some very efficient probing mechanism in the kernel 
> for tracing in production environments. The printf and va_arg 
> based probes are flexible but less efficient when we want to 
> trace high-throughput events. Even function calls can add 
> noticeable overhead according to our measurements. So I think 
> we need to provide a way (mostly via macro definitions) with 
> which a subsystem can enter an event into a trace buffer 
> through a short code path. I.e., we should limit the number of 
> callbacks and avoid format string parsing.
> 
> As I understand, Steven's latest TRACE_FIELD patch avoids such 
> overhead, although it does seem to add complexity for adding 
> new trace points. [...]

Yeah - it was motivated by the patches you sent to lkml which 
showed that it's possible to do it quite sanely and that it can 
be done faster.

> [...] It would be nice if we can replace the above 
> sched_switch declaration with just a couple of macros.

Good point - there's ongoing work to simplify the TRACE_FIELD 
approach. The current (not yet pushed out) optimized tracepoint 
format Steve is working on is:

/*
 * Tracepoint for task switches, performed by the scheduler:
 *
 * (NOTE: the 'rq' argument is not used by generic trace events,
 *        but used by the latency tracer plugin. )
 */
TRACE_EVENT(sched_switch,

	TP_PROTO(struct rq *rq, struct task_struct *prev,
		 struct task_struct *next),

	TP_ARGS(rq, prev, next),

	TP_STRUCT__entry(
		__array(	char,	prev_comm,	TASK_COMM_LEN	)
		__field(	pid_t,	prev_pid			)
		__field(	int,	prev_prio			)
		__array(	char,	next_comm,	TASK_COMM_LEN	)
		__field(	pid_t,	next_pid			)
		__field(	int,	next_prio			)
	),

	TP_printk("task %s:%d [%d] ==> %s:%d [%d]",
		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
		__entry->next_comm, __entry->next_pid, __entry->next_prio),

	TP_fast_assign(
		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
		__entry->prev_pid	= prev->pid;
		__entry->prev_prio	= prev->prio;
		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
		__entry->next_pid	= next->pid;
		__entry->next_prio	= next->prio;
	)
);

As you can see it enumerates fields, provides format-based 
tracing and a tracepoint as well. It also looks quite similar to 
C syntax while still being an information-dense macro.

	Ingo
