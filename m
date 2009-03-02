Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbZCBNXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbZCBNXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZCBNX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:23:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45490 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZCBNX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:23:27 -0500
Date: Mon, 2 Mar 2009 08:23:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 07/10] tracing: add raw trace point recording
 infrastructure
In-Reply-To: <1235980288.7581.66.camel@charm-linux>
Message-ID: <alpine.DEB.2.00.0903020815530.4771@gandalf.stny.rr.com>
References: <20090228090646.265765024@goodmis.org>  <20090228090938.203450528@goodmis.org> <1235980288.7581.66.camel@charm-linux>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2 Mar 2009, Tom Zanussi wrote:
> >  An example of this would be:
> > 
> >  TRACE_EVENT_FORMAT(sched_wakeup,
> > 	TPPROTO(struct rq *rq, struct task_struct *p, int success),
> > 	TPARGS(rq, p, success),
> > 	TPFMT("task %s:%d %s",
> > 	      p->comm, p->pid, success?"succeeded":"failed"),
> > 	TRACE_STRUCT(
> > 		TRACE_FIELD(pid_t, pid, p->pid)
> > 		TRACE_FIELD(int, success, success)
> > 	),
> > 	TPRAWFMT("task %d success=%d")
> > 	);
> > 
> >  This creates us a unique struct of:
> > 
> >  struct {
> > 	pid_t		pid;
> > 	int		success;
> >  };
> > 
> >  And the way the call back would assign these values would be:
> > 
> > 	entry->pid = p->pid;
> > 	entry->success = success;
> > 
> > The nice part about this is that the creation of the assignent is done
> > via macro magic in the event tracer.  Once the TRACE_EVENT_FORMAT is
> > created, the developer will then have a faster method to record
> > into the ring buffer. They do not need to worry about the tracer itself.
> > 
> 
> Nice improvements - I definitely was unhappy about having things spread
> around in different files unnecessarily.  And I like the fact that your
> macros generate assignments too but am curious about what to do if you
> need to do something more complicated than an assignment e.g. in the
> block tracepoints I had to assign fields differently based on the value
> of blk_pc_request():
> 
>        if (blk_pc_request(rq)) {
>                zed_event->sector = 0;
>                zed_event->bytes = rq->data_len;
>                zed_event->pdu_len = pdu_len;
>                memcpy(zed_event->pdu, rq->cmd, pdu_len);
>        } else {
>                zed_event->sector = rq->hard_sector;
>                zed_event->bytes = rq->hard_nr_sectors << 9;
>                zed_event->pdu_len = 0;
>        }
> 
> Is there a way to define some fields but without the assignments, and do
> them manually somewhere else?  I guess it would be nice to be able to
> define all events using TRACE_EVENT_FORMAT but have a way to special
> case certain events/fields.
> 
> Anyway, sorry if it's already handled in the code - haven't had a chance
> to really peruse it.

Nope, you are right, it is not handled... yet ;-)


I was thinking about adding TRACE_FIELD_SPECIAL() that would allow for a 
different means to copy the field.

	TRACE_FIELD_SPECIAL(char*, pdu, rec,
		TPCMD(memcpy((rec)->pdu, rq->cmd, pdu_len));

Where, rec would have your "zed_event", and the fourth argument would have 
the way to handle that field.

I have not tried that yet, but I think this, or something similar, could 
work.

Thanks,

-- Steve

