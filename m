Return-Path: <linux-kernel-owner+w=401wt.eu-S1161126AbXCVWEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161126AbXCVWEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161133AbXCVWEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:04:24 -0400
Received: from mail28.syd.optusnet.com.au ([211.29.133.169]:58929 "EHLO
	mail28.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161126AbXCVWEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:04:23 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: RSDL v0.31
Date: Fri, 23 Mar 2007 09:03:20 +1100
User-Agent: KMail/1.9.5
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <45FEB54A.3040602@rtr.ca> <1174547256.7414.129.camel@Homer.simpson.net> <20070322091824.GD15328@elte.hu>
In-Reply-To: <20070322091824.GD15328@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703230903.21403.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All code reviews are most welcome indeed!

On Thursday 22 March 2007 20:18, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> > Actually, the numbers are an interesting curiosity point, but not as
> > interesting as the fact that the deadline mechanism isn't kicking in.
>
> it's not just the scheduling accounting being off, RSDL also seems to be

I'll look at that when I have time.

> accessing stale data here:
> > >From pull_task():
> >
> > 	/*
> > 	 * If this task has already been running on src_rq this priority
> > 	 * cycle, make the new runqueue think it has been on its cycle
> > 	 */
> > 	if (p->rotation == src_rq->prio_rotation)
> > 		p->rotation = this_rq->prio_rotation;
> >
> > The intent here is clearly that this task continue on the new cpu as
> > if nothing has happened.  However, when the task was dequeued,
> > p->array was left as it was, points to the last place it was queued.
> > Stale data.

I don't think this is a problem because immediately after this in pull_task it 
calls enqueue_task() which always updates p->array in recalc_task_prio(). 
Every enqueue_task always calls recalc_task_prio on non-rt tasks so the array 
should always be set no matter where the entry point to scheduling is from 
unless I have a logic error in setting the p->array in recalc_task_prio() or 
there is another path to schedule() that I've not accounted for by making 
sure recalc_task_prio is done.

> it might point to a hot-unplugged CPU's runqueue as well. Which might
> work accidentally, but we want this fixed nevertheless.

The hot unplugged cpu's prio_rotation will be examined, and then it sets the 
prio_rotation from this runqueue's value. That shouldn't lead to any more 
problems than setting the timestamp based on the hot unplug cpus timestamp 
lower down also in pull_task()

p->timestamp = (p->timestamp - src_rq->most_recent_timestamp) +  
this_rq->most_recent_timestamp;

Thanks for looking!

-- 
-ck
