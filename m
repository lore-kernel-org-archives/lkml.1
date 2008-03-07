Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbYCGTRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbYCGTRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYCGTRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:17:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:61008 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648AbYCGTRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:17:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,464,1199692800"; 
   d="scan'208";a="351515055"
Date: Fri, 7 Mar 2008 11:14:57 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, "Yang, Yi Y" <yi.y.yang@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes aredealocked when cpu is set to offline
Message-ID: <20080307191457.GK28006@linux-os.sc.intel.com>
References: <1204555505.3842.4.camel@yangyi-dev.bj.intel.com> <20080304052613.GA28632@in.ibm.com> <20080304150107.GA564@tv-sign.ru> <20080306134400.GA1915@in.ibm.com> <20080307025451.GA201@tv-sign.ru> <20080307091049.GA8827@in.ibm.com> <20080307105138.GA10576@in.ibm.com> <b647ffbd0803070502m28355751rd526ed8ca4dd90a@mail.gmail.com> <20080307135537.GB10576@in.ibm.com> <20080307155002.GA22664@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307155002.GA22664@in.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 07:50:02AM -0800, Gautham R Shenoy wrote:
> On Fri, Mar 07, 2008 at 07:25:37PM +0530, Gautham R Shenoy wrote:
> > On Fri, Mar 07, 2008 at 02:02:20PM +0100, Dmitry Adamushko wrote:
> > > Hi,
> > >
> > > 'watchdog' is of SCHED_FIFO class. The standard load-balancer doesn't
> > > move RT tasks between cpus anymore and there is a special mechanism in
> > > scher_rt.c instead (I think, it's .25 material).
> > >
> > > So I wonder, whether __migrate_task() is still capable of properly
> > > moving a RT task to another CPU (e.g. for the case when it's in
> > > TASK_RUNNING state) without breaking something in the rt migration
> > > mechanism (or whatever else) that would leave us with a runqueue in
> > > the 'inconsistent' state...
> > > (I've taken a quick look at the relevant code so can't confirm it yet)
> > >
> > > maybe it'd be faster if somebody could do a quick test now with the
> > > following line commented out in kernel/softlockup.c :: watchdog()
> > >
> > > -         sched_setscheduler(current, SCHED_FIFO, &param);
> >
> > Commenting out that like seems to work. Passed 500 iterations of
> > cpu-hotplug without any problems.
> 
> This seems to unearth another problem. After some 850 successful
> cpu-hotplug iterations I got this message.
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ------------[ cut here ]------------
> BUG: spinlock recursion on CPU#2, kstopmachine/32521
> BUG: spinlock lockup on CPU#1, kstopmachine/32517, cc43db80
> Pid: 32517, comm: kstopmachine Not tainted 2.6.25-rc3 #44
>  [<c0284ebb>] <0>BUG: spinlock lockup on CPU#0, kstopmachine/32520,
> cc43db80
> _raw_spin_lock+0xd5/0xf9
>  [<c04e1a33>] <0>BUG: spinlock lockup on CPU#3, kstopmachine/32522,
> cc43db80
> _spin_lock+0x20/0x28
> Pid: 32522, comm: kstopmachine Not tainted 2.6.25-rc3 #44
>  [<c04dfa41>] ?  [<c0284ebb>] schedule+0xb0/0x5ab
>  [<c04dfa41>] schedule+0xb0/0x5ab
> _raw_spin_lock+0xd5/0xf9
>  [<c04e1d58>] ?  [<c04e1a33>] _spin_unlock_irqrestore+0x36/0x3c
>  [<c0119fdc>] ? _spin_lock+0x20/0x28
>  [<c0119806>] ? complete+0x34/0x3e
>  [<c0143646>] double_lock_balance+0x3a/0x57
>  [<c0119806>] do_stop+0xd4/0xfe

Well, there is another

	sched_setscheduler(p, SCHED_FIFO, &param);

in kernel/stop_machine.c

Perhaps we need to remove this aswell and try?

thanks,
suresh
