Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYFZP1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYFZP1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYFZP1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:27:35 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:33472 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYFZP1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:27:34 -0400
Date: Thu, 26 Jun 2008 08:27:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, laijs@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080626152728.GA24972@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080623103700.GA4043@linux.vnet.ibm.com> <20080623105844.GC28192@elte.hu> <20080623114941.GB3160@in.ibm.com> <20080624110144.GA8695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624110144.GA8695@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 01:01:44PM +0200, Ingo Molnar wrote:
> 
> * Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > > hm, not sure - we might just be fighting the symptom and we might 
> > > now create a silent resource leak instead. Isnt a full RCU quiescent 
> > > state forced (on all CPUs) before a CPU is cleared out of 
> > > cpu_online_map? That way the to-be-offlined CPU should never 
> > > actually show up in rcp->cpumask.
> > 
> > No, this does not happen currently. The rcp->cpumask is always 
> > initialized to cpu_online_map&~nohz_cpu_mask when we start a new 
> > batch. Hence, before the batch ends, if a cpu goes offline we _can_ 
> > have a stale rcp->cpumask, till the RCU subsystem has handled it's 
> > CPU_DEAD notification.
> > 
> > Thus for a tiny interval, the rcp->cpumask would contain the offlined 
> > CPU. One of the alternatives is probably to handle this using 
> > CPU_DYING notifier instead of CPU_DEAD where we can call 
> > __rcu_offline_cpu().
> > 
> > The warn_on that dhaval was hitting was because of some cpu-offline 
> > that was called just before we did a local_irq_save inside call_rcu(). 
> > But at that time, the rcp->cpumask was still stale, and hence we ended 
> > up sending a smp_reschedule() to an offlined cpu. So the check may not 
> > create any resource leak.
> 
> the check may not - but the problem it highlights might and with the 
> patch we'd end up hiding potential problems in this area.
> 
> Paul, what do you think about this mixed CPU hotplug plus RCU workload?

RCU most certainly needs to work correctly in face of arbitrary sequences
of CPU-hotplug events, and should therefore be tested with arbitrary
CPU-hotplug tests.  And RCU also most certainly needs to refrain from
issuing spurious warning messages that might over time be ignored,
possibly causing someone to miss a real bug.  My concern with this patch
is in the second spurious-warning area.

Not sure I answered the actual question, though...

							Thanx, Paul
