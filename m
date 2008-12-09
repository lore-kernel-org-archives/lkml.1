Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYLIPAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYLIPAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 10:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYLIPAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 10:00:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYLIPAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 10:00:04 -0500
Subject: Re: [PATCH 1/1] sched: CPU remove deadlock fix
From: Peter Zijlstra <peterz@infradead.org>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: mingo@elte.hu, efault@gmx.de, vatsa@in.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1228834342.8684.5.camel@twins>
References: <200812091548.mB9Fm0sm011959@d01av04.pok.ibm.com>
	 <1228834342.8684.5.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Dec 2008 15:59:54 +0100
Message-Id: <1228834794.8684.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-09 at 15:52 +0100, Peter Zijlstra wrote:
> On Tue, 2008-12-09 at 08:47 -0600, Brian King wrote:
> > This patch fixes a possible deadlock scenario in the CPU remove path.
> > migration_call grabs rq->lock, then wakes up everything on rq->migration_queue
> > with the lock held. Then one of the tasks on the migration queue ends up
> > calling tg_shares_up which then also tries to acquire the same rq->lock.
> 
> Looks ok, does lockdep agree?

On second thought, I'm not seeing it at all..

why doesn't every wakeup deadlock?

> > Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> > ---
> > 
> >  kernel/sched.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff -puN kernel/sched.c~sched_cpu_down_deadlock_fix kernel/sched.c
> > --- linux-2.6/kernel/sched.c~sched_cpu_down_deadlock_fix	2008-12-09 08:42:09.000000000 -0600
> > +++ linux-2.6-bjking1/kernel/sched.c	2008-12-09 08:42:09.000000000 -0600
> > @@ -6587,7 +6587,9 @@ migration_call(struct notifier_block *nf
> >  			req = list_entry(rq->migration_queue.next,
> >  					 struct migration_req, list);
> >  			list_del_init(&req->list);
> > +			spin_unlock_irq(&rq->lock);
> >  			complete(&req->done);
> > +			spin_lock_irq(&rq->lock);
> >  		}
> >  		spin_unlock_irq(&rq->lock);
> >  		break;
> > _
