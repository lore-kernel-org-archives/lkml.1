Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948Ab0A2RQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0A2RQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541Ab0A2RQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:16:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:33031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab0A2RQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:16:42 -0500
Subject: Re: [PATCH tracing/kprobes] kprobes: Disable booster when
 CONFIG_PREEMPT=y
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
In-Reply-To: <20100129170817.GA2283@Krystal>
References: <4B5E476C.9030303@redhat.com>
	 <20100127215531.24775.26807.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20100129092135.GE10878@elte.hu> <4B62F61D.5060203@redhat.com>
	 <20100129170817.GA2283@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 18:15:38 +0100
Message-ID: <1264785338.24455.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 12:08 -0500, Mathieu Desnoyers wrote:
> 
> If a task is set as stopped, and the preempted before calling schedule,
> can this result in a preempted task staying in that state for an
> arbitrary long period of time ? Or is there some mechanism prohibiting
> that in the scheduler ? 

PREEMPT_ACTIVE does that:

preempt_schedule()
                add_preempt_count(PREEMPT_ACTIVE);
                schedule();


schedule()
        if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
                if (unlikely(signal_pending_state(prev->state, prev)))
                        prev->state = TASK_RUNNING;
                else
                        deactivate_task(rq, prev, 1);
                switch_count = &prev->nvcsw;
        }


