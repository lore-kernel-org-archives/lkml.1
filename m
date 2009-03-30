Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbZC3N5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbZC3N5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZC3N5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:57:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:6508 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZC3N5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:57:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,446,1233561600"; 
   d="scan'208";a="443250233"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "Kleen, Andi" <andi.kleen@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@googlemail.com>
Date: Mon, 30 Mar 2009 14:55:38 +0100
Subject: RE: [rfc] x86, bts: fix crash
Thread-Topic: [rfc] x86, bts: fix crash
Thread-Index: AcmxO/5gAA/gu/UeS6e7d6uRbtk03QAAFwaA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E926D46A7@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77E9260843D@irsmsx504.ger.corp.intel.com>
 <20090326015801.GA451@redhat.com>
 <928CFBE8E7CB0040959E56B4EA41A77E9266B699@irsmsx504.ger.corp.intel.com>
 <20090327165038.GA25762@redhat.com> <1238175204.6077.18.camel@raistlin>
 <20090327212933.GA5325@redhat.com>
 <928CFBE8E7CB0040959E56B4EA41A77E9266B8F1@irsmsx504.ger.corp.intel.com>
 <928CFBE8E7CB0040959E56B4EA41A77E9266BB48@irsmsx504.ger.corp.intel.com>
 <20090330132904.GA2822@redhat.com>
In-Reply-To: <20090330132904.GA2822@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Oleg Nesterov [mailto:oleg@redhat.com]
>Sent: Monday, March 30, 2009 3:29 PM
>To: Metzger, Markus T


>> >The benefit would be that I don't need to hook into do_exit() anymore.
>
>Metzger, I got lost ;) And I didn't sleep today, so most probably I missed
>what you mean...

The way I understood you, I should defer the release of the bts tracer.
I can schedule the work in __ptrace_unlink(), so I don't need the changes
that hook into do_exit().
The work will be done at a later time with interrupts enabled.

I'm looking into schedule_work() right now, since I don't need all the other
features of RCU.


>do you mean the helper below will be called under write_lock_irq(tasklist)?
>In that case,
>
>> >This would rid us of the nasty ->ptraced loop.
>> >I will give it a try.
>> >
>> >
>> >I use something like this to wait for the context switch:
>> >  nvcsw = task->nvcsw + 1;
>> >  nivcsw = task->nivcsw + 1;
>> >  for (;;) {
>> >	if (nvcsw < task->nvcsw)
>> >		break;
>> >	if (nivcsw < task->nivcsw)
>> >		break;
>
>Not exactly right, schedule() increments nvcsw/nivcsw before context_switch().
>But this is fixable.

That's why I added +1. There's still the overflow problem. I now use

nvcsw = task->nvcsw;
for (;;) {
	if ((task->nvcsw - nvcsw) > 1)
		break;
	...
	if (!task_is_running(task))
		break;
	schedule();
}

this should work even for overflowing counters. It waits for two
context switches, or - preferably - for task to be currently not running
on any cpu (see below for task_is_running()).


>However. What if this task spins in TASK_RUNNING waiting for tasklist_lock ?
>This is deadlockable even with CONFIG_PREEMPT, we take tasklit for reading
>in interrupt context.

That code is executed with interrupts enabled and tasklist lock not held.
That's why I added the ptrace_bts_exit_tracer() and ptrace_bts_exit_tracee()
calls - to be able to call ds_release_bts() with interrupts enabled.


>Afaics, we can also deadlock if task_cpu(task) sends IPI to us (with wait = 1),
>the sender spins with preemption disabled.
>
>> >	if (task->state != TASK_RUNNING)
>> >		break;
>> >  }
>> >
>>
>> That is not quite right, as well. There's a race on the task state.
>> In my example, I got TASK_DEAD before the dying task could complete its
>> final schedule(), and the cpu continued tracing.
>
>But we still have the same problems.
>
>If the tracee doesn't call a blocking syscall, its ->state is always RUNNING.

Agreed.

I meanwhile added a function task_is_running() to sched.h that checks whether
the parameter task is currently running on any cpu.
I use that instead of checking ->state.

The function is essentially:
int task_is_running(struct task_struct *p)
{
	struct rq *rq;
	unsigned long flags;
	int running;

	rq = task_rq_lock(p, &flags);
	running = task_running(rq, p);
	task_rq_unlock(rq, &flags);

	return running;
}


thanks and regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

