Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbZJHSY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbZJHSY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932699AbZJHSY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:24:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:58451 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759093AbZJHSY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:24:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+xo81BRmCx/4pUc5A/dmykDigQeouXvuSFElIxk/
	NNVmTsrMHbYoem
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200910081655.37485.elendil@planet.nl>
References: <200910051500.55875.elendil@planet.nl>
	 <1254974743.7797.21.camel@marge.simson.net>
	 <20091008064041.67219b13@infradead.org>
	 <200910081655.37485.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 20:23:37 +0200
Message-Id: <1255026217.6643.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 16:55 +0200, Frans Pop wrote:
> On Thursday 08 October 2009, Arjan van de Ven wrote:
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Thu, 24 Sep 2009 13:24:16 +0200
> > Subject: [PATCH] x86, timers: check for pending timers after (device)
> > interrupts
> >
> > Now that range timers and deferred timers are common, I found a
> > problem with these using the "perf timechart" tool.
> >
> > It turns out that on x86, these two 'opportunistic' timers only
> > get checked when another "real" timer happens.
> > These opportunistic timers have the objective to save power by
> > hitchhiking on other wakeups, as to avoid CPU wakeups by themselves
> > as much as possible.
> 
> This patch makes quite a difference for me. iwlagn and phy0 now 
> consistently show at ~10 ms or lower.
> 
> I do still get occasional high latencies, but those are for things like
> "[rpc_wait_bit_killable]" or "Writing a page to disk", where I guess you'd 
> expect them. Those high latencies are mostly only listed for "Global" and 
> don't translate to individual processes.

I still see very high latencies coming out of idle (last noted was >
300ms, NO_HZ) with this patch, and wonder if the hunk below makes any
difference whatsoever for you.  Here, it definitely does. (shouldn't)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -495,8 +495,10 @@ static void update_curr(struct cfs_rq *c
 	u64 now = rq_of(cfs_rq)->clock;
 	unsigned long delta_exec;
 
-	if (unlikely(!curr))
+	if (unlikely(!curr)) {
+		update_rq_clock(rq_of(cfs_rq));
 		return;
+	}
 
 	/*
 	 * Get the amount of time the current task was running


