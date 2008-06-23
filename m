Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbYFWLsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbYFWLsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYFWLsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:48:07 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:54378 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYFWLsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:48:05 -0400
Date: Mon, 23 Jun 2008 17:19:41 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, paulmck@linux.vnet.ibm.com,
       Dipankar Sarma <dipankar@in.ibm.com>, laijs@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080623114941.GB3160@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080623103700.GA4043@linux.vnet.ibm.com> <20080623105844.GC28192@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623105844.GC28192@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 12:58:44PM +0200, Ingo Molnar wrote:
> 
> * Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> > On running kernel compiles in parallel with cpu hotplug,
> > 
> > ------------[ cut here ]------------
> > WARNING: at arch/x86/kernel/smp.c:118
> > native_smp_send_reschedule+0x21/0x36()
> > Modules linked in:
> > Pid: 27483, comm: cc1 Not tainted 2.6.26-rc7 #1
> >  [<c01217d9>] warn_on_slowpath+0x41/0x5d
> >  [<c01515b7>] ? generic_file_aio_read+0x10f/0x137
> >  [<c0151340>] ? file_read_actor+0x0/0xf7
> >  [<c013ae4c>] ? validate_chain+0xaa/0x29c
> >  [<c013c854>] ? __lock_acquire+0x612/0x666
> >  [<c013c854>] ? __lock_acquire+0x612/0x666
> >  [<c013ae4c>] ? validate_chain+0xaa/0x29c
> >  [<c01715d3>] ? file_kill+0x2d/0x30
> >  [<c013cbd7>] ? __lock_release+0x4b/0x51
> >  [<c01715d3>] ? file_kill+0x2d/0x30
> >  [<c0110355>] native_smp_send_reschedule+0x21/0x36
> >  [<c014fe8f>] force_quiescent_state+0x47/0x57
> >  [<c014fef0>] call_rcu+0x51/0x6d
> >  [<c01713b3>] __fput+0x130/0x158
> >  [<c0171231>] fput+0x17/0x19
> >  [<c016fd99>] filp_close+0x4d/0x57
> >  [<c016fdff>] sys_close+0x5c/0x97
> >  [<c0103861>] sysenter_past_esp+0x6a/0xb1
> >  =======================
> > ---[ end trace aa35f3913ddf2d06 ]---
> > 
> > This is because a reschedule is sent to a CPU which is offline.
> > Just ensure that the CPU we send the smp_send_reschedule is actually
> > online.
> > 
> > Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > ---
> >  kernel/rcuclassic.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.26-rc7/kernel/rcuclassic.c
> > ===================================================================
> > --- linux-2.6.26-rc7.orig/kernel/rcuclassic.c
> > +++ linux-2.6.26-rc7/kernel/rcuclassic.c
> > @@ -93,7 +93,8 @@ static void force_quiescent_state(struct
> >  		cpumask = rcp->cpumask;
> >  		cpu_clear(rdp->cpu, cpumask);
> >  		for_each_cpu_mask(cpu, cpumask)
> > -			smp_send_reschedule(cpu);
> > +			if (cpu_online(cpu))
> > +				smp_send_reschedule(cpu);
> >  	}
> 

Hi Ingo,

> hm, not sure - we might just be fighting the symptom and we might now 
> create a silent resource leak instead. Isnt a full RCU quiescent state 
> forced (on all CPUs) before a CPU is cleared out of cpu_online_map? That 
> way the to-be-offlined CPU should never actually show up in 
> rcp->cpumask.

No, this does not happen currently. The rcp->cpumask is always
initialized to  cpu_online_map&~nohz_cpu_mask when we start a new batch.
Hence, before the batch ends, if a cpu goes offline we _can_ have a
stale rcp->cpumask, till the RCU subsystem has handled it's CPU_DEAD
notification.

Thus for a tiny interval, the rcp->cpumask would contain the offlined
CPU. One of the alternatives is probably to handle this using CPU_DYING
notifier instead of CPU_DEAD where we can call __rcu_offline_cpu().

The warn_on that dhaval was hitting was because of some
cpu-offline that was called just before we did a local_irq_save inside
call_rcu(). But at that time, the rcp->cpumask was still stale, and
hence we ended up sending a smp_reschedule() to an offlined cpu. So the
check may not create any resource leak.

But probably there's a better way to fix this.
> 
> 	Ingo

-- 
Thanks and Regards
gautham
