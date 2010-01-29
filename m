Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990Ab0A2Rdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab0A2Rdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151Ab0A2Rdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:33:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab0A2Rdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:33:49 -0500
Message-ID: <4B631BCA.9010304@redhat.com>
Date: Fri, 29 Jan 2010 12:32:58 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH tracing/kprobes] kprobes: Disable booster when	CONFIG_PREEMPT=y
References: <4B5E476C.9030303@redhat.com> <20100127215531.24775.26807.stgit@dhcp-100-2-132.bos.redhat.com> <20100129092135.GE10878@elte.hu> <4B62F61D.5060203@redhat.com> <20100129170817.GA2283@Krystal> <1264785338.24455.14.camel@laptop> <20100129172757.GA4281@Krystal>
In-Reply-To: <20100129172757.GA4281@Krystal>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
>> On Fri, 2010-01-29 at 12:08 -0500, Mathieu Desnoyers wrote:
>>>
>>> If a task is set as stopped, and the preempted before calling schedule,
>>> can this result in a preempted task staying in that state for an
>>> arbitrary long period of time ? Or is there some mechanism prohibiting
>>> that in the scheduler ? 
>>
>> PREEMPT_ACTIVE does that:
>>
>> preempt_schedule()
>>                 add_preempt_count(PREEMPT_ACTIVE);
>>                 schedule();
>>
>>
>> schedule()
>>         if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
>>                 if (unlikely(signal_pending_state(prev->state, prev)))
>>                         prev->state = TASK_RUNNING;
>>                 else
>>                         deactivate_task(rq, prev, 1);
>>                 switch_count = &prev->nvcsw;
>>         }
> 
> OK, it looks safe for preemption. Is there any unforeseen weird way a
> task can be scheduled out and stopped that would permit it to either:
> 
> - stall the algorithm forever (DoS)
> - appear as quiescent to the algorithm while its stack would hold return
>   pointers to incorrect locations
> 
> ?
> 
> I'm concerned about page faults here.

booster also checks whether the instruction can cause page-fault,
if it will cause it, kprobes doesn't boost it.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

