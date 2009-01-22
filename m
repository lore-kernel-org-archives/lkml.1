Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZAVRZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZAVRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZAVRZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:25:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60920 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007AbZAVRZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:25:43 -0500
Date: Thu, 22 Jan 2009 18:23:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Message-ID: <20090122172312.GB27250@redhat.com>
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122093046.GC5891@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Frederic Weisbecker wrote:
>
> On Thu, Jan 22, 2009 at 05:14:24PM +0800, Lai Jiangshan wrote:
> >  static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
> >  {
> > -	int active;
> > +	int active = 0;
> > +	struct wq_barrier barr;
> >
> > -	if (cwq->thread == current) {
> > -		/*
> > -		 * Probably keventd trying to flush its own queue. So simply run
> > -		 * it by hand rather than deadlocking.
> > -		 */
> > -		run_workqueue(cwq);
> > -		active = 1;
> > -	} else {
> > -		struct wq_barrier barr;
> > +	BUG_ON(cwq->thread == current);
>
> Hi Lai,
>
> BUG_ON seems perhaps a bit too much for such case. The system
> will run in an endless loop because of a mistake that will not have
> necessarily a fatal end.

Confused. Why do you think the system will run in an endless loop?
cwq-thread will exit.

> WARN_ON should be enough (plus the warn that lockdep will raise
> too in this case).

and if cwq-thread proceeds after WARN_ON() it will be "lost" anyway
because it will sleep forever.

Not that I think BUG_ON() is much better, except it is more "loud".


As for the patch itself, I completely agree with Peter.

Oleg.

