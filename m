Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbZEGTwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbZEGTwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZEGTwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:52:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45798 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZEGTwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:52:04 -0400
Date: Thu, 7 May 2009 12:51:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Alok Kataria <akataria@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, anton@samba.org
Subject: Re: [PATCH] x86: Reduce the default HZ value
Message-ID: <20090507195142.GH6693@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1241462661.412.8.camel@alok-dev1> <4A00ADDE.9000908@zytor.com> <1241560625.8665.17.camel@alok-dev1> <alpine.DEB.1.10.0905071010170.24528@qirst.com> <1241716053.6311.1514.camel@laptop> <1241716422.6311.1524.camel@laptop> <1241716718.6311.1531.camel@laptop> <alpine.DEB.1.10.0905071320010.22107@qirst.com> <20090507175441.GD6693@linux.vnet.ibm.com> <alpine.DEB.1.10.0905071350550.22107@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905071350550.22107@qirst.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 01:51:58PM -0400, Christoph Lameter wrote:
> On Thu, 7 May 2009, Paul E. McKenney wrote:
> 
> > On Thu, May 07, 2009 at 01:20:29PM -0400, Christoph Lameter wrote:
> > > On Thu, 7 May 2009, Peter Zijlstra wrote:
> > >
> > > > Another user is RCU, the grace period is tick driven, growing these
> > > > ticks by a factor 50 or so might require some tinkering with forced
> > > > grace periods when we notice our batch queues getting too long.
> > >
> > > One could also schedule RCU via hrtimers with a large fuzz period?
> >
> > You could, but then you would still have a periodic interrupt introducing
> > jitter into your HPC workload.  The approach I suggested allows RCU to be
> > happy with no periodic interrupts on any CPU that has only one runnable
> > task that is a CPU-bound user-level task (in addition to the idle task,
> > of course).
> 
> Sounds good.
> 
> An HPC workload typically has minimal kernel interaction. RCU would
> only need to run once and then the system would be quiet.

Peter Z's post leads me to believe that there might be dragons in
this approach that I am blissfully unaware of.  However, here is what
would have to happen from an RCU perspective, in case it helps:

o	This new mode needs to imply CONFIG_NO_HZ.

o	When a given CPU is transitioning into tickless mode, invoke
	rcu_enter_nohz().  This already happens for dynticks-idle,
	this would be a dynticks-CPU-bound-usermode-task.
	Note that CONFIG_NO_HZ kernels already invokes rcu_enter_nohz()
	from tick_nohz_stop_sched_tick(), and many of the things in
	tick_nohz_stop_sched_tick() would need to be done in this case
	as well.

o	When a given CPU is transitioning out of tickless mode, invoke
	rcu_exit_nohz().  Again, this already happens for dynticks-idle.
	Note that CONFIG_NO_HZ kernels already invoke rcu_exit_nohz() 
	from tick_nohz_restart_sched_tick(), which does other stuff that
	would be required in your case as well.

o	When a given CPU in tickless mode transitions into the kernel
	via a system call or trap, invoke rcu_irq_enter().  Note that
	rcu_irq_enter() is already invoked on irq entry if CONFIG_NO_HZ.
	NMIs are also already handled via rcu_nmi_enter().

o	When a given CPU in tickless mode transitions out of the kernel
	from a system call or trap, invoke rcu_irq_exit().  Note that
	rcu_irq_exit() is already invoked on irq exit if CONFIG_NO_HZ.
	NMIs are also already handled via rcu_nmi_exit().

Then RCU would know that any CPU running a CPU-bound user-mode task
need not be consulted when working out when a grace period ends, since
user-mode code cannot contain kernel-mode RCU read-side critical sections.

							Thanx, Paul
