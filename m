Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbZCBPmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbZCBPmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZCBPmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:42:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57938 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbZCBPmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:42:00 -0500
Date: Mon, 2 Mar 2009 10:41:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [ANNOUNCE][PATCH 0 of 4] zedtrace, a general-purpose binary
 tracer
In-Reply-To: <20090228210031.GA8155@infradead.org>
Message-ID: <alpine.DEB.2.00.0903021033500.4771@gandalf.stny.rr.com>
References: <1235725238.8512.86.camel@charm-linux> <20090228210031.GA8155@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 28 Feb 2009, Christoph Hellwig wrote:

> I played with it a bit and I really like the userspace with the
> transport backend and a hakcy script language that many people know
> for post-processing.
> 
> But looking at the kernel portions just shows again that the whole
> tracepoint concept is utterly wrong.  We should not need the
> zed_block.c/zed_sched.c/zed_workqueue.c but instead have those
> tracing points directly annotated in the subsystems like using
> markers, so that's it's self-contained and can be added by modules
> without touching the rest of the kernel.
> 
> I know tracepoints are not your fault, but we really need to sort
> that out for a nice tracing experience.

Christoph,

Have you seen my udpates to the TRACE_EVENT_FORMAT? I based my work off of 
Tom's work here. That is, I liked the way he could do the C style 
recording of events, without the printf parsing.

The difference in my work is that I put all of it into a self contained 
macro called TRACE_EVENT_FORMAT:

For example:

TRACE_EVENT_FORMAT(sched_switch,
        TPPROTO(struct rq *rq, struct task_struct *prev,
                struct task_struct *next),
        TPARGS(rq, prev, next),
        TPFMT("task %s:%d ==> %s:%d",
              prev->comm, prev->pid, next->comm, next->pid),
        TRACE_STRUCT(
                TRACE_FIELD(pid_t, prev_pid, prev->pid)
                TRACE_FIELD(int, prev_prio, prev->prio)
                TRACE_FIELD_SPECIAL(char next_comm[TASK_COMM_LEN],
                                    next_comm,
                                    TPCMD(memcpy(TRACE_ENTRY->next_comm,
                                                 next->comm,
                                                 TASK_COMM_LEN)))
                TRACE_FIELD(pid_t, next_pid, next->pid)
                TRACE_FIELD(int, next_prio, next->prio)
        ),
        TPRAWFMT("prev %d:%d ==> next %s:%d:%d")
        );

I explained all these fields in a prior email, but I added the new 
TRACE_FIELD_SPECIAL here (have not posted it yet).

This one allows you to do something special if a simple assignment is not 
enough.

I used next_comm as an example:

TRACE_FIELD_SPECIAL(type_item, item, cmd)

Where type_item is a full line in a structure (not just the time, but the 
item too). This allows to allocate arrays. The item is the same as the 
item in the type_item, but just the variable name and not the type. The 
cmd is the command to perform to record it. Note, you need to use 
TRACE_ENTRY to access the field.

The last TRPRAWFMT is the trace point raw format that corresponds to the 
structure.

-- Steve

