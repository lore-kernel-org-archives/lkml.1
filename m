Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZDPKRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZDPKRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZDPKR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:17:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55577 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbZDPKRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:17:25 -0400
Subject: Re: GFS2: Tracing support for review
From: Steven Whitehouse <swhiteho@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cluster-devel@redhat.com,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.2.00.0904151159130.31828@gandalf.stny.rr.com>
References: <1239810905.29604.60.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0904151159130.31828@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Thu, 16 Apr 2009 11:18:47 +0100
Message-Id: <1239877127.3344.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-04-15 at 12:12 -0400, Steven Rostedt wrote:
> Hi Steven,
> 
> 
[some comments cut]

> If you look at the latest "tip" code, I have an code in 
> examples/trace_events/ that does it better. If found that using the 
> -I$(PWD)/path and then defining TRACE_INCLUDE_PATH to "." worked well.
> 
> But the way you did it is just fine as well.
> 
> > 
> > Also there seemed to be a symbol which was not exported, which I've added
> > to the patch below.
> 
> Ah, that is because I developed without the perf counters in my branch.
> Could you send that as a separate patch. It should not be tied to
> the rest of your code. Your code can depend on it, but that is something 
> that we want to apply right away.
> 
Looks like Ingo got there first :-)


> > diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
> > new file mode 100644
> > index 0000000..73850fd
> > --- /dev/null
> > +++ b/fs/gfs2/trace_gfs2.h
> > @@ -0,0 +1,395 @@
> > +#if !defined(_TRACE_GFS2_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_GFS2_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM gfs2
> > +#define TRACE_INCLUDE_FILE trace_gfs2
> 
> Nice, you figured that part out. I was afraid the double use of 
> TRACE_SYSTEM and TRACE_INCLUDE_FILE might confuse people.
> 
Yes, that didn't seem too tricky.

> > +
> > +#include <linux/fs.h>
> > +#include <linux/buffer_head.h>
> > +#include <linux/dlmconstants.h>
> > +#include <linux/gfs2_ondisk.h>
> > +#include "incore.h"
> > +#include "glock.h"
> > +
> > +/* Section 1 - Locking
> > + *
> > + * Objectives:
> > + * Latency: Remote demote request to state change
> > + * Latency: Local lock request to state change
> > + * Latency: State change to lock grant
> > + * Correctness: Ordering of local lock state vs. I/O requests
> > + * Correctness: Responses to remote demote requests
> > + */
> > +
> > +/* General glock state change (DLM lock request completes) */
> > +TRACE_EVENT(gfs2_glock_state_change,
> > +
> > +	TP_PROTO(const struct gfs2_glock *gl, unsigned int new_state),
> > +
> > +	TP_ARGS(gl, new_state),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	u64,	glnum			)
> > +		__field(	u32,	gltype			)
> > +		__field(	dev_t,	dev			)
> > +		__field(	u8,	cur_state		)
> > +		__field(	u8,	new_state		)
> > +		__field(	u8,	dmt_state		)
> > +		__field(	u8,	tgt_state		)
> > +		__array(	char,	comm,	TASK_COMM_LEN	)
> > +		__field(	pid_t,	pid			)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->glnum		= gl->gl_name.ln_number;
> > +		__entry->gltype		= gl->gl_name.ln_type;
> > +		__entry->dev		= gl->gl_sbd->sd_vfs->s_dev;
> > +		__entry->cur_state	= glock_trace_state(gl->gl_state);
> > +		__entry->new_state	= glock_trace_state(new_state);
> > +		__entry->tgt_state	= glock_trace_state(gl->gl_target);
> > +		__entry->dmt_state	= DLM_LOCK_IV;
> > +		if (test_bit(GLF_DEMOTE, &gl->gl_flags) ||
> > +		    test_bit(GLF_PENDING_DEMOTE, &gl->gl_flags))
> > +			__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
> > +		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
> 
> I wonder if I should add a comm field. The tracing should cache the last 
> comm, but that has issues too. All ftrace records say the current pid, so 
> the below code pid saving is not needed. And (when it works) the pid comms 
> are cached on schedule switches when tracing is enabled. only 100 or so 
> comms are cached, and if tracing is on for a long time, you may miss some.
> 
> That is how you see the <...> in the traces.
> 
> But the pid here is definitely duplicate.
> 
> 
Ok, I've removed the pid now, but I see traces like:

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-2889  [000]  1211.283008: gfs2_glock_state_change: 253:0 glock 
2:33119 state NL => EX tgt:EX dmt:-- task:glock_workqueue
           <...>-2889  [000]  1211.283201: gfs2_promote: 253:0 glock 2:33119 pro
mote first task:glock_workqueue
           <...>-2941  [000]  1211.283217: gfs2_demote_rq: 253:0 glock 2:33119 d
emote EX to NL task:gfs2_quotad
           <...>-2941  [000]  1211.283218: gfs2_glock_queue: 253:0 glock 2:33119
 dequeue task:gfs2_quotad
           <...>-2889  [000]  1211.283274: gfs2_glock_state_change: 253:0 glock 
2:33119 state EX => NL tgt:NL dmt:NL task:glock_workqueue
           <...>-2889  [000]  1214.527032: gfs2_glock_state_change: 253:0 glock 
2:21 state NL => PR tgt:PR dmt:-- task:glock_workqueue


So I think from what you are telling me, the <...> should be the comm,
but I don't see that here. I think it would be a useful feature to have.
Also I should say that tracing wasn't on for a long time in this case,
and I never get anything other than <...> in the task field. This is on
the latest -tip tree with my patch applied and no other changes.

Many thanks for the review - if I can confirm whether or not I should
keep the comm field, then I can send a revised version of the patch
which I think should be ready for submission to the tracing tree at that
point,

Steve.


