Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbYCEPjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbYCEPjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbYCEPjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:39:15 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57595 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbYCEPjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:39:13 -0500
Date: Wed, 5 Mar 2008 21:08:53 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: discuss@LessWatts.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de,
       suresh.b.siddha@intel.com, Gautham R Shenoy <ego@in.ibm.com>,
       Chanda Sethia <chanda.sethia@in.ibm.com>
Subject: Re: Too many timer interrupts in NO_HZ
Message-ID: <20080305153853.GK10028@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	discuss@LessWatts.org,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
	venkatesh.pallipadi@intel.com, tglx@linutronix.de,
	suresh.b.siddha@intel.com, Gautham R Shenoy <ego@in.ibm.com>,
	Chanda Sethia <chanda.sethia@in.ibm.com>
References: <20080302194812.GD10028@dirshya.in.ibm.com> <20080302115709.30403490@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080302115709.30403490@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2008-03-02 11:57:09]:

> On Mon, 3 Mar 2008 01:18:13 +0530
> Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > Hi,
> > 
> > I am trying to play around with the tickless kernel and
> > sched_mc_power_savings tunables to increase the idle duration of the
> > CPU in an SMP server.  sched_mc_power_savings provides good
> > consolidation of long running jobs when the system is lightly loaded.
> > However I am interested to see CPU idle times for couple minutes on
> > atleast few CPUs in an completely idle SMP system.
> > 
> > I have posted related instrumentation results at
> > http://lkml.org/lkml/2008/1/8/243
> > 
> > The experimental setup is identical.  Just that I have tried to
> > collect more data and also bias the wakeup logic.
> > 
> > The kernel is 2.6.25-rc3 with NO_HZ, SCHED_MC, HIGH_RES_TIMERS, and
> > HPET turned on.
> > 
> > I have tried to collect interesting data from tick-sched.c, sched.c
> > and softirq.c.
> > 
> > As suggested by Ingo in the previous thread, I have hacked the sched.c
> > try_to_wake_up logic so that I can force all wake-ups to happen on
> > CPU0.  This is just and experiment, in reality we will have to
> > carefully choose a domain and CPU to bias all wakeups on an idle
> > system.
> 
> 
> please show us powertop -d output; that way we can at least see sort of what
> is going on...

I have some more information on the timer interrupt activities in the
system.  I have obtained the following trace from irq_exit and local
timer is the only interrupt on CPUs 1, 2 & 3.

Trace       CPU/function                    Timestamp
number

U2336208    C1 irq_exit             EXIT  4452403.687322 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336212    C3 irq_exit             EXIT  4452403.722253 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336214    C2 irq_exit             EXIT  4452403.722668 ms in_intr 0 in_idle 1 need_resched 0 pid 0


U2336236    C1 irq_exit             EXIT  4452807.345543 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336241    C3 irq_exit             EXIT  4452807.381894 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336242    C2 irq_exit             EXIT  4452807.382144 ms in_intr 0 in_idle 1 need_resched 0 pid 0


U2336248    C1 irq_exit             EXIT  4453211.003638 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336253    C3 irq_exit             EXIT  4453211.041529 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336254    C2 irq_exit             EXIT  4453211.041703 ms in_intr 0 in_idle 1 need_resched 0 pid 0


U2336260    C1 irq_exit             EXIT  4453614.662043 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336265    C3 irq_exit             EXIT  4453614.701429 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336266    C2 irq_exit             EXIT  4453614.701474 ms in_intr 0 in_idle 1 need_resched 0 pid 0


U2336293    C1 irq_exit             EXIT  4454018.320078 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336298    C3 irq_exit             EXIT  4454018.361100 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336299    C2 irq_exit             EXIT  4454018.361142 ms in_intr 0 in_idle 1 need_resched 0 pid 0


U2336313    C1 irq_exit             EXIT  4454421.978047 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336318    C2 irq_exit             EXIT  4454422.020756 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336319    C3 irq_exit             EXIT  4454422.020807 ms in_intr 0 in_idle 1 need_resched 0 pid 0


U2336357    C1 irq_exit             EXIT  4454825.636341 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336369    C2 irq_exit             EXIT  4454825.681058 ms in_intr 0 in_idle 1 need_resched 0 pid 0
U2336370    C3 irq_exit             EXIT  4454825.681191 ms in_intr 0 in_idle 1 need_resched 0 pid 0

This is over a short interval where I complain that the tick is not
really getting stopped.  Actually there is a pattern of 400ms timer
being programmed.

Apart from these there are 4ms pattern on one of the CPU that is used
to drive tick_sched_timer.  Most of the missing trace entries are CPU0
which takes care of all the idle daemon process.

There are wakeups due to kondemand and other kernel threads on CPUs 1,
2 & 3, but the time is in seconds.

Please help me find the source for this timer.

Thanks,
Vaidy

