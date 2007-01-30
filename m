Return-Path: <linux-kernel-owner+w=401wt.eu-S965594AbXA3QoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965594AbXA3QoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965601AbXA3QoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:44:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39743 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965596AbXA3QoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:44:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Date: Tue, 30 Jan 2007 17:44:47 +0100
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       dipankar@in.ibm.com, Gautham Shenoy <ego@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
References: <20070126112837.059502fc.akpm@osdl.org> <20070130073340.GC30160@elte.hu> <20070130160244.GB2092@linux.vnet.ibm.com>
In-Reply-To: <20070130160244.GB2092@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701301744.48601.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 30 January 2007 17:02, Paul E. McKenney wrote:
> On Tue, Jan 30, 2007 at 08:33:40AM +0100, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > > in fact (new) kprobes uses the freezer, and it's far more 
> > > > performance sensitive than the handling of CPU hotplug events.
> > > 
> > > Outside of realtime workloads, I agree that performance should not be 
> > > a problem.  And I don't know of any reason why realtime systems need 
> > > to be able to do hotplug CPU.  Yet, anyway.  ;-)
> > 
> > even for -rt it's not really an issue: the hotplug locks are so 
> > all-encompassing and so unbound at the moment that there's no realistic 
> > expectation for them to ever become deterministic. So we might as well 
> > make them encompass "everything" - without any noticeable effect.
> > 
> > > So the thought is to make _cpu_down() and _cpu_up() do something like 
> > > the following (untested, probably does not even compile), perhaps with 
> > > suitable adjustments elsewhere as well?
> > > 
> > > 	static int _cpu_down(unsigned int cpu)
> > > 	{
> > > 		int err;
> > > 		struct task_struct *p;
> > > 		cpumask_t old_allowed, tmp;
> > > 
> > > 		if (num_online_cpus() == 1)
> > > 			return -EBUSY;
> > > 
> > > 		if (!cpu_online(cpu))
> > > 			return -EINVAL;
> > > 
> > > 		if (freeze_processes()) {
> > > 			err = -EBUSY;
> > > 			goto out_freeze_notify_failed;
> > > 		}
> > > 		err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
> > > 							(void *)(long)cpu);
> > 
> > yeah. This all looks so nice that i almost cannot believe it's true :-) 
> 
> Well, it turns out that maybe it is in fact untrue.  :-/
> 
> I need to look at all uses of PF_NOFREEZE -- as I understand the
> code, processes marked PF_NOFREEZE will continue running, potentially
> interfering with the hotplug operation.  :-(
> 
> I will pass my findings on to this list.

Well, I did it some time ago, although not very thoroughly.

AFAICS there are not so many, but one that stands out is the worker threads.
We needed two of them to actually go to sleep, so now it's possible to create
a "freezeable workqueue" the worker thread of which will not set PF_NOFREEZE,
but currently this is only used by XFS.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
