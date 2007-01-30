Return-Path: <linux-kernel-owner+w=401wt.eu-S965414AbXA3HvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965414AbXA3HvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 02:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965426AbXA3HvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 02:51:09 -0500
Received: from fallback.mail.elte.hu ([157.181.151.13]:42788 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965414AbXA3HvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 02:51:08 -0500
Date: Tue, 30 Jan 2007 08:33:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070130073340.GC30160@elte.hu>
References: <20070126191113.GA14770@in.ibm.com> <20070126112837.059502fc.akpm@osdl.org> <20070126194622.GA17134@in.ibm.com> <20070126121739.be3e072a.akpm@osdl.org> <20070126204406.GB17134@in.ibm.com> <20070126132949.50544e90.akpm@osdl.org> <20070128224756.GA7672@linux.vnet.ibm.com> <20070128153005.f320b834.akpm@osdl.org> <20070129191241.GB14353@elte.hu> <20070130024549.GL1923@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130024549.GL1923@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3728]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > in fact (new) kprobes uses the freezer, and it's far more 
> > performance sensitive than the handling of CPU hotplug events.
> 
> Outside of realtime workloads, I agree that performance should not be 
> a problem.  And I don't know of any reason why realtime systems need 
> to be able to do hotplug CPU.  Yet, anyway.  ;-)

even for -rt it's not really an issue: the hotplug locks are so 
all-encompassing and so unbound at the moment that there's no realistic 
expectation for them to ever become deterministic. So we might as well 
make them encompass "everything" - without any noticeable effect.

> So the thought is to make _cpu_down() and _cpu_up() do something like 
> the following (untested, probably does not even compile), perhaps with 
> suitable adjustments elsewhere as well?
> 
> 	static int _cpu_down(unsigned int cpu)
> 	{
> 		int err;
> 		struct task_struct *p;
> 		cpumask_t old_allowed, tmp;
> 
> 		if (num_online_cpus() == 1)
> 			return -EBUSY;
> 
> 		if (!cpu_online(cpu))
> 			return -EINVAL;
> 
> 		if (freeze_processes()) {
> 			err = -EBUSY;
> 			goto out_freeze_notify_failed;
> 		}
> 		err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
> 							(void *)(long)cpu);

yeah. This all looks so nice that i almost cannot believe it's true :-) 
This would allow us to rip out all the cpu-hotplug locking: wow! If only
someone would volunteer to try to pull this off and then to touch so
many subsystems ;-)

i fully agree that the opposite notifications should be traversed in 
inverse order [but this is an orthogonal improvement]. Too bad the 
notifier list is a single linked list.

	Ingo
