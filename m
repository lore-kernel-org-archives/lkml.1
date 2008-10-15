Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbYJOIMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYJOIMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 04:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYJOIMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 04:12:12 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:60147 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYJOIML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:12:11 -0400
Message-ID: <48F5A638.8020003@colorfullife.com>
Date: Wed, 15 Oct 2008 10:13:44 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <48F21D58.3000404@colorfullife.com> <20081012224629.GA7353@linux.vnet.ibm.com> <48F38D73.8040804@colorfullife.com> <20081015011143.GE6874@linux.vnet.ibm.com>
In-Reply-To: <20081015011143.GE6874@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>> - For nohz cpus, a poller function [schedule_work(), enabled interrupts] 
>> peeks into the per-cpu data of the nohz cpu and checks if it is quiet or if 
>> it passed through a quiescent state.
>> If it didn't, then it sets a cpu_data->kick_poller flag and rcu_irq_exit() 
>> reports the grace period.
>> No need for an IPI either - rcu has a hook in the irq exit path.
>>     
>
> I considered adding a cpu_quiet() on the irq exit path, but eventually
> decided that I should instead place the added overhead in the infrequently
> invoked force_quiescent_state() function.  Could be argued either way,
> of course.
>   
rcu_irq_exit() is only called on idle cpus.
You are trading time spent by the idle cpu in 'hlt' with "real" cpu time.

>> Right now, I cheat if a nohz cpu is in a long-running nmi 
>> [while(other_cpu_is_in_nmi()) cpu_relax()], but I think I can fix that with 
>> an set_need_resched() in the rcu_nmi_exit().
>>     
>
> Hmmm...  I don't see where the NMI exit path checks the TIF_NEED_RESCHED
> flag, but I could easily be missing something.
>   
Good point.
I haven't looked at the issue yet.
Perhaps a smd_send_reschedule(smp_processor_id()) is necessary.

Btw, I found a bug in my state machine: Right now, the state machine 
will lock up if all cpus are in nohz mode.
I'm not sure if it applies to your code as well.

--
    Manfred
