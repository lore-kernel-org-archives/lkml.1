Return-Path: <linux-kernel-owner+w=401wt.eu-S1756461AbYJMSCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461AbYJMSCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbYJMSCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:02:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:60159 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbYJMSCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:02:06 -0400
Message-ID: <48F38D73.8040804@colorfullife.com>
Date: Mon, 13 Oct 2008 20:03:31 +0200
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
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <48F21D58.3000404@colorfullife.com> <20081012224629.GA7353@linux.vnet.ibm.com>
In-Reply-To: <20081012224629.GA7353@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Do you send a reschedule IPI to CPUs that are not in dyntick idle mode,
> but who have failed to pass through a quiescent state?
>   
Actually, I never send reschedule IPIs.

- For "usual" cpus, rcu_check_callbacks() checks for quiescent states.
There should be a set_need_resched() if a cpu holds up a grace period 
for too long. I just haven't implemented it yet.
IMHO it doesn't make sense to perform a "for_each_cpu() 
smd_send_reschedule()". rcu has a hook in each cpu, thus a 
set_need_resched() by the per-cpu hook is faster/simpler.

- For nohz cpus, a poller function [schedule_work(), enabled interrupts] 
peeks into the per-cpu data of the nohz cpu and checks if it is quiet or 
if it passed through a quiescent state.
If it didn't, then it sets a cpu_data->kick_poller flag and 
rcu_irq_exit() reports the grace period.
No need for an IPI either - rcu has a hook in the irq exit path.

Right now, I cheat if a nohz cpu is in a long-running nmi 
[while(other_cpu_is_in_nmi()) cpu_relax()], but I think I can fix that 
with an set_need_resched() in the rcu_nmi_exit().

--
    Manfred
