Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbZAVSZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbZAVSZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 13:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758140AbZAVSZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 13:25:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43910 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758088AbZAVSZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 13:25:17 -0500
Date: Thu, 22 Jan 2009 19:22:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
Message-ID: <20090122182212.GA603@redhat.com>
References: <497838F0.7020408@cn.fujitsu.com> <20090122093046.GC5891@nowhere> <20090122172312.GB27250@redhat.com> <c62985530901220947r7cae081bj8660603912769baa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530901220947r7cae081bj8660603912769baa@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Frédéric Weisbecker wrote:
>
> 2009/1/22 Oleg Nesterov <oleg@redhat.com>:
> > On 01/22, Frederic Weisbecker wrote:
> >>
> >> BUG_ON seems perhaps a bit too much for such case. The system
> >> will run in an endless loop because of a mistake that will not have
> >> necessarily a fatal end.
> >
> > Confused. Why do you think the system will run in an endless loop?
> > cwq-thread will exit.
>
> Because a BUG_ON panics and then spin for ever. Yeah I shoud have said "panic",
> sorry... It was just to tell that a BUG_ON is the end...

BUG_ON() only panics when panic_on_oops == T, no?

But let me repeat, this is minor issue. I agree with WARN().

> >> WARN_ON should be enough (plus the warn that lockdep will raise
> >> too in this case).
> >
> > and if cwq-thread proceeds after WARN_ON() it will be "lost" anyway
> > because it will sleep forever.
>
> You want to say spin forever?
> Why would it? cwq->lock is unlocked at this time.

No, it will sleep forever, unless I missed something.

Even if ->worklist is empty, ->current_work != NULL, we are ->current_work.
We insert the barrier work and call wait_for_completion(). But nobody
can do complete() except us.

> If we keep the usual path:
>
> if (cwq->thread == current) {
> 		run_workqueue(cwq);
> 		active = 1;
> 	}
>
> it shouldn't hurt.

If we keep this path then we have the different patch ;) In that
case of course BUG_ON() is overkill.


But again, as Peter says, we already have the warning from lockdep.

Oleg.

