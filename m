Return-Path: <linux-kernel-owner+w=401wt.eu-S1760003AbZKZBBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003AbZKZBBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 20:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759462AbZKZBBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 20:01:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:41786 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759349AbZKZBBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 20:01:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1909ecxzPF0kcFjJIbJaUnkFDza4WtZZe0v31QLAt
	y2wuOzmT9DPMaL
Subject: Re: [patch] sched: fix set_task_cpu() and provide an unlocked
 runqueue variant
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259173672.4027.732.camel@laptop>
References: <1258891781.14325.34.camel@marge.simson.net>
	 <1259173672.4027.732.camel@laptop>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 02:01:10 +0100
Message-Id: <1259197270.6186.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 19:27 +0100, Peter Zijlstra wrote:
> On Sun, 2009-11-22 at 13:09 +0100, Mike Galbraith wrote:
> > sched: fix set_task_cpu() and provide an unlocked runqueue variant.
> > 
> > set_task_cpu() falsifies migration stats by unconditionally generating migration
> > stats whether a task's cpu actually changed or not.  As used in copy_process(),
> > the runqueue is unlocked, so we need to provide an unlocked variant which does
> > the locking to provide a write barrier.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <new-submission>
> > 
> > ---
> 
> > +void set_task_cpu_unlocked(struct task_struct *p, unsigned int new_cpu)
> > +{
> > +	unsigned long flags;
> > +	struct rq *rq, *new_rq = cpu_rq(new_cpu);
> > +
> > +	smp_wmb();
> > +	rq = task_rq_lock(p, &flags);
> > +	update_rq_clock(rq);
> > +	if (rq != new_rq)
> > +		update_rq_clock(new_rq);
> > +	set_task_cpu(p, new_cpu);
> > +	task_rq_unlock(rq, &flags);
> > +}
> 
> I've got to ask, what's that barrier for?

It's a leftover from frustrated bug hunting.

	-Mike 

