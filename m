Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbYFXLCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbYFXLCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 07:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbYFXLCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 07:02:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34632 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbYFXLCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 07:02:12 -0400
Date: Tue, 24 Jun 2008 13:01:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, paulmck@linux.vnet.ibm.com,
       Dipankar Sarma <dipankar@in.ibm.com>, laijs@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH] fix rcu vs hotplug race
Message-ID: <20080624110144.GA8695@elte.hu>
References: <20080623103700.GA4043@linux.vnet.ibm.com> <20080623105844.GC28192@elte.hu> <20080623114941.GB3160@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623114941.GB3160@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> > hm, not sure - we might just be fighting the symptom and we might 
> > now create a silent resource leak instead. Isnt a full RCU quiescent 
> > state forced (on all CPUs) before a CPU is cleared out of 
> > cpu_online_map? That way the to-be-offlined CPU should never 
> > actually show up in rcp->cpumask.
> 
> No, this does not happen currently. The rcp->cpumask is always 
> initialized to cpu_online_map&~nohz_cpu_mask when we start a new 
> batch. Hence, before the batch ends, if a cpu goes offline we _can_ 
> have a stale rcp->cpumask, till the RCU subsystem has handled it's 
> CPU_DEAD notification.
> 
> Thus for a tiny interval, the rcp->cpumask would contain the offlined 
> CPU. One of the alternatives is probably to handle this using 
> CPU_DYING notifier instead of CPU_DEAD where we can call 
> __rcu_offline_cpu().
> 
> The warn_on that dhaval was hitting was because of some cpu-offline 
> that was called just before we did a local_irq_save inside call_rcu(). 
> But at that time, the rcp->cpumask was still stale, and hence we ended 
> up sending a smp_reschedule() to an offlined cpu. So the check may not 
> create any resource leak.

the check may not - but the problem it highlights might and with the 
patch we'd end up hiding potential problems in this area.

Paul, what do you think about this mixed CPU hotplug plus RCU workload?

	Ingo
