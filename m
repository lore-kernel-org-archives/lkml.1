Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZC3FB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZC3FB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 01:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZC3FBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 01:01:18 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56401 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZC3FBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 01:01:17 -0400
Date: Mon, 30 Mar 2009 10:30:50 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v3 PATCH 4/4] timers: logic to move non pinned timers
Message-ID: <20090330050050.GA7494@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090316111045.GA4686@linux.vnet.ibm.com> <20090316111548.GE4686@linux.vnet.ibm.com> <alpine.LFD.2.00.0903171017590.29264@localhost.localdomain> <20090317114557.GA32233@linux.vnet.ibm.com> <alpine.LFD.2.00.0903171350020.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903171350020.29264@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [2009-03-17 14:01:00]:

> On Tue, 17 Mar 2009, Arun R Bharadwaj wrote:
> > * Thomas Gleixner <tglx@linutronix.de> [2009-03-17 11:22:24]:
> > >   Let's assume we are on CPU0 and try to enqueue the timer on CPU1,
> > >   where the next timer expiry is 5ms away. The timer which we enqueue
> > >   is due in 500us. So you introduce 4.5ms latency.
> > >
> > We are moving timers to the ilb which wakes up every jiffy.
> > So we can move the timer to the ilb only if it's expiry
> > time is greater than 1 jiffy. Else we can fire on the same CPU.
> 
> Please do not start to add some obscure jiffies magic. The correct
> check is whether the new timers expiry time is before the first timers
> expiry time on the target CPU.
>

Hi Thomas,

Currently, there is a function get_next_timer_interrupt() which
returns the next timer's expiry on the CPU. This is used by
tick_nohz_stop_sched_tick() in order to reprogram the timer device
before stopping the tick.

get_next_timer_interrupt() returns the earliest between the
next timer expiry and the next hrtimer expiry.

In case of the hrtimer expiry, the ktime is rounded off to the next
jiffie and returned.

So using the current infrastructure, there is no benefit in finding
out when the next timer is going to fire on the target cpu over just
checking if the current hrtimer which we are migrating is firing
before the next jiffie or not. If it is firing after 1 jiffie, it can
be migrated and the target cpu (idle load balancer) will reprogram
its timer device accordingly.

--arun
> Thanks,
> 
> 	tglx
