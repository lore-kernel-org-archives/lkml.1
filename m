Return-Path: <linux-kernel-owner+w=401wt.eu-S1750741AbXBDAbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750741AbXBDAbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXBDAbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:31:48 -0500
Received: from pool-71-111-65-226.ptldor.dsl-w.verizon.net ([71.111.65.226]:19892
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750741AbXBDAbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:31:48 -0500
Date: Sat, 3 Feb 2007 16:31:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, dipankar@in.ibm.com,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070204003122.GD5647@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070126112837.059502fc.akpm@osdl.org> <200701301744.48601.rjw@sisk.pl> <20070203000153.GA1712@elf.ucw.cz> <200702032327.25163.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702032327.25163.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 11:27:24PM +0100, Rafael J. Wysocki wrote:
> On Saturday, 3 February 2007 01:01, Pavel Machek wrote:
> > Hi!
> > 
> > > > > > 	static int _cpu_down(unsigned int cpu)
> > > > > > 	{
> > > > > > 		int err;
> > > > > > 		struct task_struct *p;
> > > > > > 		cpumask_t old_allowed, tmp;
> > > > > > 
> > > > > > 		if (num_online_cpus() == 1)
> > > > > > 			return -EBUSY;
> > > > > > 
> > > > > > 		if (!cpu_online(cpu))
> > > > > > 			return -EINVAL;
> > > > > > 
> > > > > > 		if (freeze_processes()) {
> > > > > > 			err = -EBUSY;
> > > > > > 			goto out_freeze_notify_failed;
> > > > > > 		}
> > > > > > 		err = raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE,
> > > > > > 							(void *)(long)cpu);
> > > > > 
> > > > > yeah. This all looks so nice that i almost cannot believe it's true :-) 
> > > > 
> > > > Well, it turns out that maybe it is in fact untrue.  :-/
> > > > 
> > > > I need to look at all uses of PF_NOFREEZE -- as I understand the
> > > > code, processes marked PF_NOFREEZE will continue running, potentially
> > > > interfering with the hotplug operation.  :-(
> > > > 
> > > > I will pass my findings on to this list.
> > > 
> > > Well, I did it some time ago, although not very thoroughly.
> > > 
> > > AFAICS there are not so many, but one that stands out is the worker threads.
> > > We needed two of them to actually go to sleep, so now it's possible to create
> > > a "freezeable workqueue" the worker thread of which will not set PF_NOFREEZE,
> > > but currently this is only used by XFS.
> > 
> > We should slowly move as workqueues to freezeable ones... Having too
> > much stuff NOFREEZE is evil, even for swsusp.
> 
> On the other hand, some of the workqueues may be necessary for saving the image
> (still, I have no examples ;-)).

In any case, getting CPU hotplug working is probably first priority.

That said, I am testing a patch that (hopefully) gets rid of the
RCU-boost and rcutorture NOFREEZE tasks.  Every little bit will help.

							Thanx, Paul
