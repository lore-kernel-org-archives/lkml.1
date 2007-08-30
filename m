Return-Path: <linux-kernel-owner+w=401wt.eu-S1760400AbXH3J5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400AbXH3J5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 05:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759960AbXH3J5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 05:57:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50676 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759897AbXH3J5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 05:57:04 -0400
Subject: Re: [PATCH 2.6.21] Return available first timeslice to the
	creator, not parent
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@openvz.org>
In-Reply-To: <20070830094931.GB316@tv-sign.ru>
References: <m3fy21qx4p.fsf@dhcp-lab-143.englab.brq.redhat.com>
	 <1188465056.6112.30.camel@twins>  <20070830094931.GB316@tv-sign.ru>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 11:56:56 +0200
Message-Id: <1188467816.6112.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 13:49 +0400, Oleg Nesterov wrote:
> On 08/30, Peter Zijlstra wrote:
> >
> > On Thu, 2007-08-30 at 09:50 +0200, Vitaly Mayatskikh wrote:
> > > Short-living process returns its timeslice to the parent, this affects
> > > process that creates a lot of such short-living threads, because its
> > > not a parent for new threads. Patch fixes this issue and doesn't break
> > > kabi as does the patch from reporter: http://lkml.org/lkml/2007/4/7/21
> > 
> > > plain text document attachment (2.6.21-timeslice.patch), "proposed
> > > patch"
> > > diff -up -bB ./include/linux/sched.h.orig ./include/linux/sched.h
> > > --- ./include/linux/sched.h.orig	2007-08-21 09:20:22.000000000 +0200
> > > +++ ./include/linux/sched.h	2007-08-27 10:14:06.000000000 +0200
> > > @@ -827,7 +827,9 @@ struct task_struct {
> > >  
> > >  	unsigned long policy;
> > >  	cpumask_t cpus_allowed;
> > > -	unsigned int time_slice, first_time_slice;
> > > +	unsigned int time_slice;
> > > +	/* Pid of creator */
> > > +	unsigned int cpid;
> > 
> > might as well make that pid_t, or maybe even a struct pid* and keep a
> > reference on it - the struct pid police might have an opinion.
> 
> I agree, "struct pid*" is better, because
> 
> 	1. we don't need a costly find_pid() in sched_exit()
> 	2. we don't suffer from pid re-use problem

Ah, good arguments indeed.

> > >  void fastcall sched_exit(struct task_struct *p)
> > >  {
> > >  	unsigned long flags;
> > >  	struct rq *rq;
> > > -
> > > +	struct task_struct* creator = NULL;
> > >  	/*
> > >  	 * If the child was a (relative-) CPU hog then decrease
> > > -	 * the sleep_avg of the parent as well.
> > > +	 * the sleep_avg of the creator as well.
> > >  	 */
> > > -	rq = task_rq_lock(p->parent, &flags);
> > > -	if (p->first_time_slice && task_cpu(p) == task_cpu(p->parent)) {
> > > -		p->parent->time_slice += p->time_slice;
> > > -		if (unlikely(p->parent->time_slice > task_timeslice(p)))
> > > -			p->parent->time_slice = task_timeslice(p);
> > > +	if (p->cpid) {
> > > +		struct pid *pid = find_get_pid((pid_t)p->cpid);
> > > +		if (pid) {
> > > +			creator = get_pid_task(pid, PIDTYPE_PID);
> > > +			put_pid(pid);
> 
> sched_exit() was removed in 2.6.23-rc.
> 
> If you are going to re-introduce this logic, please don't do sched_exit()
> from release_task(). It was done this way just because we can't access
> ->parent after release_task(). But release_task() is called either too
> early, or too late for timeslice accounting, depending on ->exit_signal == -1.
> 
> I'd suggest to do this in do_exit(), before the last schedule(). Without
> write_unlock_irq() the code above needs a couple of rcu_read_lock()'s.
> 
> I am not sure Ingo will like this change though...

This is not intended as re-introduction of the feature, this stems from
fixing this issue in older (read distro) kernels.

