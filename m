Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYJOBL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYJOBL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 21:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJOBLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 21:11:47 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50903 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbYJOBLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 21:11:45 -0400
Date: Tue, 14 Oct 2008 18:11:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
Message-ID: <20081015011143.GE6874@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <48F21D58.3000404@colorfullife.com> <20081012224629.GA7353@linux.vnet.ibm.com> <48F38D73.8040804@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F38D73.8040804@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 08:03:31PM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>> Do you send a reschedule IPI to CPUs that are not in dyntick idle mode,
>> but who have failed to pass through a quiescent state?
>>   
> Actually, I never send reschedule IPIs.
>
> - For "usual" cpus, rcu_check_callbacks() checks for quiescent states.
> There should be a set_need_resched() if a cpu holds up a grace period for 
> too long. I just haven't implemented it yet.
> IMHO it doesn't make sense to perform a "for_each_cpu() 
> smd_send_reschedule()". rcu has a hook in each cpu, thus a 
> set_need_resched() by the per-cpu hook is faster/simpler.

One indeed only sends resched IPIs to CPUs that are not responding on
their own.  And in the case of rcutree.c, the loop is not over the CPUs
themselves, but rather over the leaf rcu_node structures (one per 64
CPUs) -- the per-CPU rcu_data structure is touched only for CPUs that
have not yet responded.

> - For nohz cpus, a poller function [schedule_work(), enabled interrupts] 
> peeks into the per-cpu data of the nohz cpu and checks if it is quiet or if 
> it passed through a quiescent state.
> If it didn't, then it sets a cpu_data->kick_poller flag and rcu_irq_exit() 
> reports the grace period.
> No need for an IPI either - rcu has a hook in the irq exit path.

I considered adding a cpu_quiet() on the irq exit path, but eventually
decided that I should instead place the added overhead in the infrequently
invoked force_quiescent_state() function.  Could be argued either way,
of course.

> Right now, I cheat if a nohz cpu is in a long-running nmi 
> [while(other_cpu_is_in_nmi()) cpu_relax()], but I think I can fix that with 
> an set_need_resched() in the rcu_nmi_exit().

Hmmm...  I don't see where the NMI exit path checks the TIF_NEED_RESCHED
flag, but I could easily be missing something.

I instead maintain separate counters for the NMI and irq entry/exit code,
which are checked in the force_quiescent_state() path.

							Thanx, Paul
