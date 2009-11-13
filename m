Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZKMKQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZKMKQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZKMKQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:16:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:41198 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbZKMKQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:16:15 -0500
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
From: Peter Zijlstra <peterz@infradead.org>
To: ego@in.ibm.com
Cc: Sachin Sant <sachinp@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20091113095801.GA29977@in.ibm.com>
References: <20091112195101.63263490.sfr@canb.auug.org.au>
	 <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop>
	 <4AFBFE3D.80507@in.ibm.com> <1258028831.4039.152.camel@laptop>
	 <1258045831.4039.736.camel@laptop>  <20091113095801.GA29977@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 11:16:08 +0100
Message-ID: <1258107368.4039.1149.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 15:28 +0530, Gautham R Shenoy wrote:
> On Thu, Nov 12, 2009 at 06:10:31PM +0100, Peter Zijlstra wrote:
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 1f2e99d..62df61c 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2377,6 +2377,9 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
> >  	task_rq_unlock(rq, &flags);
> > 
> 
> How about this ?
> 
> again:
>   	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
>  	if (!cpu_online(cpu))
>  		cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
> 	if (!cpu) {
> 		set_task_affinity(); 
> 		goto again;
> 	}
> > +
> >  	if (cpu != orig_cpu) {
> >  		local_irq_save(flags);
> >  		rq = cpu_rq(cpu);

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2376,7 +2376,15 @@ static int try_to_wake_up(struct task_st
 	p->state = TASK_WAKING;
 	__task_rq_unlock(rq);
 
+again:
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	if (!cpu_online(cpu))
+		cpu = cpumask_any_and(&p->cpus_allowed, cpu_online_mask);
+	if (cpu >= nr_cpu_ids) {
+		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
+		goto again;
+	}
+
 	if (cpu != orig_cpu) {
 		rq = cpu_rq(cpu);
 		update_rq_clock(rq);

is what I stuck in and am compiling now.. we'll see what that does.

