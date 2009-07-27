Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbZG0Wmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbZG0Wmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755418AbZG0Wmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:42:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42354 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbZG0Wma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:42:30 -0400
Date: Mon, 27 Jul 2009 18:41:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, ryov@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com,
       agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 03/24] io-controller: bfq support of in-class preemption
Message-ID: <20090727224138.GA3702@redhat.com>
References: <1248467274-32073-1-git-send-email-vgoyal@redhat.com> <1248467274-32073-4-git-send-email-vgoyal@redhat.com> <4A6DDBDE.8020608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6DDBDE.8020608@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 06:54:54PM +0200, Jerome Marchand wrote:
> Vivek Goyal wrote:
> > o Generally preemption is associated with cross class where if an request
> >   from RT class is pending it will preempt the ongoing BE or IDLE class
> >   request.
> > 
> > o CFQ also does in-class preemtions like a sync request queue preempting the
> >   async request queue. In that case it looks like preempting queue gains
> >   share and it is not fair.
> > 
> > o Implement the similar functionality in bfq so that we can retain the
> >   existing CFQ behavior.
> > 
> > o This patch creates a bypass path so that a queue can be put at the
> >   front of the service tree (add_front, similar to CFQ), so that it will
> >   be selected next to run. That's a different thing that in the process
> >   this queue gains share.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/elevator-fq.c |   46 +++++++++++++++++++++++++++++++++++++++++-----
> >  1 files changed, 41 insertions(+), 5 deletions(-)
> > 
> > diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> > index e5f39cf..f1ab0dc 100644
> > --- a/block/elevator-fq.c
> > +++ b/block/elevator-fq.c
> > @@ -267,7 +267,8 @@ static void bfq_get_entity(struct io_entity *entity)
> >  		elv_get_ioq(ioq);
> >  }
> >  
> > -static void bfq_init_entity(struct io_entity *entity, struct io_group *iog)
> > +static inline void
> > +bfq_init_entity(struct io_entity *entity, struct io_group *iog)
> >  {
> >  	entity->sched_data = &iog->sched_data;
> >  }
> > @@ -580,7 +581,7 @@ static struct io_entity *bfq_lookup_next_entity(struct io_sched_data *sd,
> >   * service received if @entity is active) of the queue to calculate its
> >   * timestamps.
> >   */
> > -static void __bfq_activate_entity(struct io_entity *entity)
> > +static void __bfq_activate_entity(struct io_entity *entity, int add_front)
> >  {
> >  	struct io_sched_data *sd = entity->sched_data;
> >  	struct io_service_tree *st = io_entity_service_tree(entity);
> > @@ -625,7 +626,42 @@ static void __bfq_activate_entity(struct io_entity *entity)
> >  	}
> >  
> >  	st = __bfq_entity_update_prio(st, entity);
> > -	bfq_calc_finish(entity, entity->budget);
> > +	/*
> > +	 * This is to emulate cfq like functionality where preemption can
> > +	 * happen with-in same class, like sync queue preempting async queue
> > +	 * May be this is not a very good idea from fairness point of view
> > +	 * as preempting queue gains share. Keeping it for now.
> > +	 */
> > +	if (add_front) {
> > +		struct io_entity *next_entity;
> > +
> > +		/*
> > +		 * Determine the entity which will be dispatched next
> > +		 * Use sd->next_active once hierarchical patch is applied
> > +		 */
> > +		next_entity = bfq_lookup_next_entity(sd, 0);
> > +
> > +		if (next_entity && next_entity != entity) {
> > +			struct io_service_tree *new_st;
> > +			u64 delta;
> > +
> > +			new_st = io_entity_service_tree(next_entity);
> > +
> > +			/*
> > +			 * At this point, both entities should belong to
> > +			 * same service tree as cross service tree preemption
> > +			 * is automatically taken care by algorithm
> > +			 */
> > +			BUG_ON(new_st != st);
> 
> Hi Vivek,
> 
> I don't quite understand how cross service tree preemption is taken care
> by algorithm, but I've hit this bug while doing some RT I/O and then
> killing it.
> 
> $ ionice -c 1 dd if=/dev/zero of=/tmp/foo bs=1M count=1000 &
> $ killall dd
> 

Hi Jerome,

Thanks for testing it out. I could also reproduce the issue.

I had assumed that RT queue will always preempt non-RT queue and hence if
there is an RT ioq/request pending, the sd->next_entity will point to
itself and any queue which is preempting it has to be on same service
tree.

But in your test case it looks like that RT async queue is pending and 
there is some sync BE class IO going on. It looks like that CFQ allows
sync queue preempting async queue irrespective of class, so in this case
sync BE class reader will preempt async RT queue and that's where my
assumption is broken and we see BUG_ON() hitting.

Can you please tryout following patch. It is a quick patch and requires
more testing. It solves the crash but still does not solve the issue of
sync queue always preempting async queues irrespective of class. In
current scheduler we always schedule the RT queue first (whether it be
sync or async). This problem requires little more thought.

In this patch, we just check next entity on same class service tree and
if one is present, stick new queue in front of it. We don't rely on
sd->next_active, which could be pointing to a queue of different class
in same group (scheduling_data).
 
---
 block/elevator-fq.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: linux8/block/elevator-fq.c
===================================================================
--- linux8.orig/block/elevator-fq.c	2009-07-27 18:13:34.000000000 -0400
+++ linux8/block/elevator-fq.c	2009-07-27 18:18:49.000000000 -0400
@@ -946,21 +946,15 @@ static void __bfq_activate_entity(struct
 	if (add_front) {
 		struct io_entity *next_entity;
 
-		/* Determine the entity which will be dispatched next */
-		next_entity = sd->next_active;
+		/*
+		 * Determine the entity which will be dispatched next on
+		 * same service tree.
+		 */
+		next_entity = __bfq_lookup_next_entity(st);
 
 		if (next_entity && next_entity != entity) {
-			struct io_service_tree *new_st;
 			u64 delta;
 
-			new_st = io_entity_service_tree(next_entity);
-
-			/*
-			 * At this point, both entities should belong to
-			 * same service tree as cross service tree preemption
-			 * is automatically taken care by algorithm
-			 */
-			BUG_ON(new_st != st);
 			entity->finish = next_entity->finish - 1;
 			delta = bfq_delta(entity->budget, entity->weight);
 			entity->start = entity->finish - delta;
