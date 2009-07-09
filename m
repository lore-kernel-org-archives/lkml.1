Return-Path: <linux-kernel-owner+w=401wt.eu-S1759062AbZGIME0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062AbZGIME0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbZGIMEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:04:16 -0400
Received: from www.tglx.de ([62.245.132.106]:55471 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756544AbZGIMEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:04:15 -0400
Date: Thu, 9 Jul 2009 14:03:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jarek Poplawski <jarkao2@gmail.com>
cc: Andres Freund <andres@anarazel.de>,
       Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( possibly?caused
 by netem)
In-Reply-To: <20090709104412.GA3651@ami.dom.local>
Message-ID: <alpine.LFD.2.00.0907091401040.24704@localhost.localdomain>
References: <200907031326.21822.andres@anarazel.de> <200907071811.27570.andres@anarazel.de> <20090708080852.GC3148@ami.dom.local> <200907090023.18040.andres@anarazel.de> <20090708224828.GD3666@ami.dom.local> <alpine.LFD.2.00.0907090956490.24704@localhost.localdomain>
 <20090709104412.GA3651@ami.dom.local>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, Jarek Poplawski wrote:
> > 
> > I have the feeling that the code relies on some implicit cpu
> > boundness, which is not longer guaranteed with the timer migration
> > changes, but that's a question for the network experts.
> 
> As a matter of fact, I've just looked at this __netif_schedule(),
> which really is cpu bound, so you might be 100% right.

So the watchdog is the one which causes the trouble. The patch below
should fix this.

Thanks,

	tglx
---

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 24d17ce..fbe554f 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -485,7 +485,7 @@ void qdisc_watchdog_schedule(struct qdisc_watchdog *wd, psched_time_t expires)
 	wd->qdisc->flags |= TCQ_F_THROTTLED;
 	time = ktime_set(0, 0);
 	time = ktime_add_ns(time, PSCHED_TICKS2NS(expires));
-	hrtimer_start(&wd->timer, time, HRTIMER_MODE_ABS);
+	hrtimer_start(&wd->timer, time, HRTIMER_MODE_ABS_PINNED);
 }
 EXPORT_SYMBOL(qdisc_watchdog_schedule);
 
