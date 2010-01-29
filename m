Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187Ab0A2RdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0A2RdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442Ab0A2RdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:33:07 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:50634 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344Ab0A2RdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:33:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AikFAH6lYktGGNtq/2dsb2JhbACBNNknhEIE
Date: Fri, 29 Jan 2010 12:27:57 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH tracing/kprobes] kprobes: Disable booster when
	CONFIG_PREEMPT=y
Message-ID: <20100129172757.GA4281@Krystal>
References: <4B5E476C.9030303@redhat.com> <20100127215531.24775.26807.stgit@dhcp-100-2-132.bos.redhat.com> <20100129092135.GE10878@elte.hu> <4B62F61D.5060203@redhat.com> <20100129170817.GA2283@Krystal> <1264785338.24455.14.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1264785338.24455.14.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:23:43 up 44 days,  1:42,  5 users,  load average: 0.12, 0.23,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2010-01-29 at 12:08 -0500, Mathieu Desnoyers wrote:
> > 
> > If a task is set as stopped, and the preempted before calling schedule,
> > can this result in a preempted task staying in that state for an
> > arbitrary long period of time ? Or is there some mechanism prohibiting
> > that in the scheduler ? 
> 
> PREEMPT_ACTIVE does that:
> 
> preempt_schedule()
>                 add_preempt_count(PREEMPT_ACTIVE);
>                 schedule();
> 
> 
> schedule()
>         if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>                 if (unlikely(signal_pending_state(prev->state, prev)))
>                         prev->state = TASK_RUNNING;
>                 else
>                         deactivate_task(rq, prev, 1);
>                 switch_count = &prev->nvcsw;
>         }

OK, it looks safe for preemption. Is there any unforeseen weird way a
task can be scheduled out and stopped that would permit it to either:

- stall the algorithm forever (DoS)
- appear as quiescent to the algorithm while its stack would hold return
  pointers to incorrect locations

?

I'm concerned about page faults here.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
