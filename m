Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbZCHSkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbZCHSkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbZCHSjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:39:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:50019 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753203AbZCHSjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:39:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19tvnJcrpdtxukLrsyAgC3BUBXLJSybpF3soe90I1
	LIq/hXl8OuDDRk
Subject: Re: scheduler oddity [bug?]
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090308175255.GA22802@elte.hu>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 19:39:40 +0100
Message-Id: <1236537580.7094.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 18:52 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Sun, 2009-03-08 at 16:39 +0100, Ingo Molnar wrote:
> > > * Mike Galbraith <efault@gmx.de> wrote:
> > > 
> > > > The problem with your particular testcase is that while one 
> > > > half has an avg_overlap (what we use as affinity hint for 
> > > > synchronous wakeups) which triggers the affinity hint, the 
> > > > other half has avg_overlap of zero, what it was born with, so 
> > > > despite significant execution overlap, the scheduler treats 
> > > > them as if they were truly synchronous tasks.
> > > 
> > > hm, why does it stay on zero?
> > 
> > Wakeup preemption.  Presuming here: heavy task wakes light 
> > task, is preempted, light task stuffs data into pipe, heavy 
> > task doesn't block, so no avg_overlap is ever computed.  The 
> > heavy task uses 100% CPU.
> > 
> > Running as SCHED_BATCH (virgin source), it becomes sane.
> 
> ah.
> 
> I'd argue then that time spent on the rq preempted _should_ 
> count in avg_overlap statistics. I.e. couldnt we do something 
> like ... your patch? :)
> 
> > >     if (sleep && p->se.last_wakeup) {
> > >             update_avg(&p->se.avg_overlap,
> > >                        p->se.sum_exec_runtime - p->se.last_wakeup);
> > >             p->se.last_wakeup = 0;
> > > -   }
> > > +   } else if (p->se.avg_overlap < limit && runtime >= limit)
> > > +           update_avg(&p->se.avg_overlap, runtime);
> 
> Just done unconditionally, i.e. something like:
> 
> 	if (sleep) {
> 		runtime = p->se.sum_exec_runtime - p->se.last_wakeup;
> 		p->se.last_wakeup = 0;
> 	} else {
> 		runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
> 	}
> 
> 	update_avg(&p->se.avg_overlap, runtime);
> 
> ?

That'll do it for this load.  I'll resume in the a.m., give that some
testing, and try to remember all the things I was paranoid about.
(getting interrupted a _lot_.. i give up on today;)

	-Mike

