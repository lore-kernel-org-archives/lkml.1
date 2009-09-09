Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZIIPTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZIIPTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZIIPTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:19:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62797 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbZIIPTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:19:10 -0400
Subject: Re: [PATCH 2/2] tracing/events: Add kexec tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Daniel Walker <dwalker@fifo99.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
In-Reply-To: <1252505528.14793.93.camel@desktop>
References: <4AA70198.9070500@cn.fujitsu.com>  <4AA701B3.704@cn.fujitsu.com>
	 <1252459241.14793.40.camel@desktop>  <4AA70451.6050307@cn.fujitsu.com>
	 <1252472376.14793.85.camel@desktop>
	 <1252496788.27001.0.camel@gandalf.stny.rr.com>
	 <1252505528.14793.93.camel@desktop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 09 Sep 2009 11:19:11 -0400
Message-Id: <1252509551.27001.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 07:12 -0700, Daniel Walker wrote:
> On Wed, 2009-09-09 at 07:46 -0400, Steven Rostedt wrote:
> > On Tue, 2009-09-08 at 21:59 -0700, Daniel Walker wrote:
> > > On Wed, 2009-09-09 at 09:26 +0800, Li Zefan wrote:
> > > > Daniel Walker wrote:
> > > > > On Wed, 2009-09-09 at 09:15 +0800, Li Zefan wrote:
> > > > >> +       TP_STRUCT__entry(
> > > > >> +               __string(       msg,    msg     )
> > > > >> +       ),
> > > > > 
> > > > > Why the funny spacing here?
> > > > > 
> > > > 
> > > > To make the code better-looking.
> > > > 
> > > > This is the coding-style we use for the code in
> > > > include/trace/events/*.
> > > 
> > > It's part of Linux right? We already have a coding style ..
> > 
> > It's a special macro. What are you now, part of the style police?
> 
> I'm just like everyone else, someone who asks questions and makes
> comments .. By using a different style than what the rest of Linux uses
> your putting yourself at a disadvantage since you can't easily use
> checkpatch on that code (even the stuff that is compliant) ..

I'm fine with questions, but yours sounded a bit more cynical
 
> 
> Not to mention people might start sending you clean ups that you maybe
> won't accept. You could always modify checkpatch to recognize your
> style.

Not sure this is worthy of modifying checkpatch. I haven't looked at
what that would take.

Here's an example of what the code currently looks like:

TRACE_EVENT(sched_wait_task,

	TP_PROTO(struct rq *rq, struct task_struct *p),

	TP_ARGS(rq, p),

	TP_STRUCT__entry(
		__array(	char,	comm,	TASK_COMM_LEN	)
		__field(	pid_t,	pid			)
		__field(	int,	prio			)
	),

	TP_fast_assign(
		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
		__entry->pid	= p->pid;
		__entry->prio	= p->prio;
	),

	TP_printk("task %s:%d [%d]",
		  __entry->comm, __entry->pid, __entry->prio)
);

And here's that same code with normal Linux style:

TRACE_EVENT(sched_wait_task,
	TP_PROTO(struct rq *rq, struct task_struct *p),
	TP_ARGS(rq, p),
	TP_STRUCT__entry(__array(char, comm, TASK_COMM_LEN)
		__field(pid_t, pid)
		__field(int, prio)),
	TP_fast_assign(memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
		__entry->pid	= p->pid;
		__entry->prio	= p->prio;
	),
	TP_printk("task %s:%d [%d]",
		  __entry->comm, __entry->pid, __entry->prio));

Not as nice to work with. The include/trace/events/ directory is quite
different than the rest of the kernel code. If checkpatch fails on it,
that's fine. Any changes here really need to be examined by eye anyway.
Having the extra spaces actually helps to see what is there.

Note, most changes in include/trace/ftrace.h failed checkpatch
horribly. ;-)  checkpatch does not handle crazy macros well.

-- Steve


