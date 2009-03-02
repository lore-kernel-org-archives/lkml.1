Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZCBHvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZCBHvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 02:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZCBHvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 02:51:37 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:17866 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbZCBHvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 02:51:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=arQ+u8oPD2dwIJ4WR3R4Y/IEErvFOWeAonD3itLbxCG/cRhKI5NZ/iETZVybOvO4Vi
         iorKtWGF5f4iebM3EVO3MuNv1zQQMjJbuozfwfWZegAd4oLFkT7OwV5qA+HqtnE5FDNK
         gBm3CRedCeW9UxE0U6QrTim82RRF5Kjh1KNFk=
Subject: Re: [PATCH 07/10] tracing: add raw trace point recording
	infrastructure
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       acme@ghostprotocols.net, Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090228090938.203450528@goodmis.org>
References: <20090228090646.265765024@goodmis.org>
	 <20090228090938.203450528@goodmis.org>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 01:51:28 -0600
Message-Id: <1235980288.7581.66.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2009-02-28 at 04:06 -0500, Steven Rostedt wrote:
> plain text document attachment
> (0007-tracing-add-raw-trace-point-recording-infrastructur.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: lower overhead tracing
> 
> The current event tracer can automatically pick up trace points
> that are registered with the TRACE_FORMAT macro. But it required
> a printf format string and parsing. Although, this adds the ability
> to get guaranteed information like task names and such, it took
> a hit in overhead processing. This processing can add about 500-1000
> nanoseconds overhead, but in some cases that too is considered
> too much and we want to shave off as much from this overhead as
> possible.
> 
> Tom Zanussi recently posted tracing patches to lkml that are based
> on a nice idea about capturing the data via C structs using
> STRUCT_ENTER, STRUCT_EXIT type of macros.
> 
> I liked that method very much, but did not like the implementation
> that required a developer to add data/code in several disjoint
> locations.
> 
> This patch extends the event_tracer macros to do a similar "raw C"
> approach that Tom Zanussi did. But instead of having the developers
> needing to tweak a bunch of code all over the place, they can do it
> all in one macro - preferably placed near the code that it is
> tracing. That makes it much more likely that tracepoints will be
> maintained on an ongoing basis by the code they modify.
> 
> The new macro TRACE_EVENT_FORMAT is created for this approach. (Note,
> a developer may still utilize the more low level DECLARE_TRACE macros
> if they don't care about getting their traces automatically in the event
> tracer.)
> 
> They can also use the existing TRACE_FORMAT if they don't need to code
> the tracepoint in C, but just want to use the convenience of printf.
> 
> So if the developer wants to "hardwire" a tracepoint in the fastest
> possible way, and wants to acquire their data via a user space utility
> in a raw binary format, or wants to see it in the trace output but not
> sacrifice any performance, then they can implement the faster but
> more complex TRACE_EVENT_FORMAT macro.
> 
> Here's what usage looks like:
> 
>   TRACE_EVENT_FORMAT(name,
> 	TPPROTO(proto),
> 	TPARGS(args),
> 	TPFMT(fmt, fmt_args),
> 	TRACE_STUCT(
> 		TRACE_FIELD(type1, item1, assign1)
> 		TRACE_FIELD(type2, item2, assign2)
> 			[...]
> 	),
> 	TPRAWFMT(raw_fmt)
> 	);
> 
> Note name, proto, args, and fmt, are all identical to what TRACE_FORMAT
> uses.
> 
>  name: is the unique identifier of the trace point
>  proto: The proto type that the trace point uses
>  args: the args in the proto type
>  fmt: printf format to use with the event printf tracer
>  fmt_args: the printf argments to match fmt
> 
>  TRACE_STRUCT starts the ability to create a structure.
>  Each item in the structure is defined with a TRACE_FIELD
> 
>   TRACE_FIELD(type, item, assign)
> 
>  type: the C type of item.
>  item: the name of the item in the stucture
>  assign: what to assign the item in the trace point callback
> 
>  raw_fmt is a way to pretty print the struct. It must match
>   the order of the items are added in TRACE_STUCT
> 
>  An example of this would be:
> 
>  TRACE_EVENT_FORMAT(sched_wakeup,
> 	TPPROTO(struct rq *rq, struct task_struct *p, int success),
> 	TPARGS(rq, p, success),
> 	TPFMT("task %s:%d %s",
> 	      p->comm, p->pid, success?"succeeded":"failed"),
> 	TRACE_STRUCT(
> 		TRACE_FIELD(pid_t, pid, p->pid)
> 		TRACE_FIELD(int, success, success)
> 	),
> 	TPRAWFMT("task %d success=%d")
> 	);
> 
>  This creates us a unique struct of:
> 
>  struct {
> 	pid_t		pid;
> 	int		success;
>  };
> 
>  And the way the call back would assign these values would be:
> 
> 	entry->pid = p->pid;
> 	entry->success = success;
> 
> The nice part about this is that the creation of the assignent is done
> via macro magic in the event tracer.  Once the TRACE_EVENT_FORMAT is
> created, the developer will then have a faster method to record
> into the ring buffer. They do not need to worry about the tracer itself.
> 

Nice improvements - I definitely was unhappy about having things spread
around in different files unnecessarily.  And I like the fact that your
macros generate assignments too but am curious about what to do if you
need to do something more complicated than an assignment e.g. in the
block tracepoints I had to assign fields differently based on the value
of blk_pc_request():

       if (blk_pc_request(rq)) {
               zed_event->sector = 0;
               zed_event->bytes = rq->data_len;
               zed_event->pdu_len = pdu_len;
               memcpy(zed_event->pdu, rq->cmd, pdu_len);
       } else {
               zed_event->sector = rq->hard_sector;
               zed_event->bytes = rq->hard_nr_sectors << 9;
               zed_event->pdu_len = 0;
       }

Is there a way to define some fields but without the assignments, and do
them manually somewhere else?  I guess it would be nice to be able to
define all events using TRACE_EVENT_FORMAT but have a way to special
case certain events/fields.

Anyway, sorry if it's already handled in the code - haven't had a chance
to really peruse it.

Tom



