Return-Path: <linux-kernel-owner+w=401wt.eu-S1762827AbZFLL0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762827AbZFLL0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbZFLL0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:26:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44920 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbZFLL0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:26:43 -0400
Date: Fri, 12 Jun 2009 13:20:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH] posix-cpu-timers: optimize calling
 thread_group_cputime()
Message-ID: <20090612132008.0c6f3e93@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <1244804986.6691.1224.camel@laptop>
References: <20090612123903.37cfd868@dhcp-lab-109.englab.brq.redhat.com>
	<1244804986.6691.1224.camel@laptop>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 13:09:46 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-06-12 at 12:39 +0200, Stanislaw Gruszka wrote:
> > -               times->utime = cputime_add(times->utime, t->utime);
> > -               times->stime = cputime_add(times->stime, t->stime);
> > -               times->sum_exec_runtime += t->se.sum_exec_runtime;
> > +               if (mask & TG_CPUCLOCK_UTIME)
> > +                       times->utime = cputime_add(times->utime, t->utime);
> > +               if (mask & TG_CPUCLOCK_STIME)
> > +                       times->stime = cputime_add(times->stime, t->stime);
> > +               if (mask & TG_CPUCLOCK_SCHED)
> > +                       times->sum_exec_runtime += t->se.sum_exec_runtime;
> 
> Does adding 3 branches really make it faster? 
Actually I did not any benchmarking yet, so I don't know what is the real
impact of the patch. I hope it make things taster but the result can be
opposite from my expectations.

> Since you're bound to want
> at least one, I would expect the cacheline to be hot (assuming all three
> variables live in the same cacheline -- if not, they should be!), so all
> you're avoiding is the addition.

utime, stime are probable in the same cache line, se.sum_exec_runtime is far away 
from them in struct task_struct so it's in rather separate cache line. 

Stanislaw
