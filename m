Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYJOPgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYJOPgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbYJOPg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:36:27 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55218 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbYJOPg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:36:26 -0400
Date: Wed, 15 Oct 2008 08:26:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
Message-ID: <20081015152637.GA6739@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <48F21D58.3000404@colorfullife.com> <20081012224629.GA7353@linux.vnet.ibm.com> <48F38D73.8040804@colorfullife.com> <20081015011143.GE6874@linux.vnet.ibm.com> <48F5A638.8020003@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F5A638.8020003@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 10:13:44AM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>>> - For nohz cpus, a poller function [schedule_work(), enabled interrupts] 
>>> peeks into the per-cpu data of the nohz cpu and checks if it is quiet or 
>>> if it passed through a quiescent state.
>>> If it didn't, then it sets a cpu_data->kick_poller flag and 
>>> rcu_irq_exit() reports the grace period.
>>> No need for an IPI either - rcu has a hook in the irq exit path.
>>
>> I considered adding a cpu_quiet() on the irq exit path, but eventually
>> decided that I should instead place the added overhead in the infrequently
>> invoked force_quiescent_state() function.  Could be argued either way,
>> of course.
>>   
> rcu_irq_exit() is only called on idle cpus.
> You are trading time spent by the idle cpu in 'hlt' with "real" cpu time.

Only once per such CPU every grace period -- seems in the noise to me.
But I should revisit, as I have changed things quite a bit since I
made that decision many weeks ago.  ;-)

>>> Right now, I cheat if a nohz cpu is in a long-running nmi 
>>> [while(other_cpu_is_in_nmi()) cpu_relax()], but I think I can fix that 
>>> with an set_need_resched() in the rcu_nmi_exit().
>>
>> Hmmm...  I don't see where the NMI exit path checks the TIF_NEED_RESCHED
>> flag, but I could easily be missing something.
>>   
> Good point.
> I haven't looked at the issue yet.
> Perhaps a smd_send_reschedule(smp_processor_id()) is necessary.

Is legal to call that from an NMI handler?  Looks to me that some x86
architectures do sequences of device-register reads and writes to send
an IPI, which does not appear to be NMI-safe to me.

> Btw, I found a bug in my state machine: Right now, the state machine will 
> lock up if all cpus are in nohz mode.
> I'm not sure if it applies to your code as well.

I avoid this problem by forbidding a CPU with an active RCU callback
from entering nohz mode.  Therefore, the only way that all CPUs can be in
nohz mode is if there are no RCU callbacks in the system.  In this case,
RCU grace periods will never complete, but that is OK because there is
no need for RCU grace periods.  One leaves this all-nohz state when some
irq handler either invokes call_rcu() or awakens some task.  In the former
case, rcu_irq_exit() will see the callback and invoke set_need_resched(),
while in the latter case the normal dynticks mechanism will wake up
some CPU.

This is not a problem from NMI handlers, as NMI handlers are not permitted
to invoke call_rcu().  Or much of anything else, for that matter.  ;-)

							Thanx, Paul
