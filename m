Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZKMJGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZKMJGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZKMJGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:06:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbZKMJGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:06:21 -0500
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
From: Peter Zijlstra <peterz@infradead.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <4AFD2027.5060303@in.ibm.com>
References: <20091112195101.63263490.sfr@canb.auug.org.au>
	 <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop>
	 <4AFBFE3D.80507@in.ibm.com>  <1258028831.4039.152.camel@laptop>
	 <1258045831.4039.736.camel@laptop>  <4AFD2027.5060303@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 10:06:13 +0100
Message-ID: <1258103173.4039.1070.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 14:30 +0530, Sachin Sant wrote:
> Peter Zijlstra wrote:
> > So what we need to do is make the whole of select_task_rq_fair()
> > cpu_online/active_mask aware, or give up and simply punt:
> >
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 1f2e99d..62df61c 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2377,6 +2377,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
> >  	task_rq_unlock(rq, &flags);
> >
> >  	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
> > +	if (!cpu_active(cpu))
> > +		cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
> > +
> >  	if (cpu != orig_cpu) {
> >  		local_irq_save(flags);
> >  		rq = cpu_rq(cpu);
> >
> >
> > Something I think Mike also tried and didn't deadlock for him..
> >
> > Sachin, Mike, could you try the above snippet and verify if it does
> > indeed solve your respective issues?
> >   
> Unfortunately the above patch made things worse. With this patch
> the machine failed to boot with following oops

Ugh, more head scratching for me then..

Thanks for testing.

