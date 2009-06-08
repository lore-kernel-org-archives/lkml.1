Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZFHNyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZFHNyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZFHNyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:54:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54090 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbZFHNyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:54:13 -0400
Date: Mon, 8 Jun 2009 09:53:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 16/20] io-controller: IO group refcounting support
Message-ID: <20090608135311.GD3652@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com> <1243377729-2176-17-git-send-email-vgoyal@redhat.com> <4A2C716C.8070808@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2C716C.8070808@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 10:03:24AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> >  
> >  /**
> > @@ -436,7 +443,6 @@ static void bfq_idle_insert(struct io_service_tree *st,
> >  {
> >  	struct io_entity *first_idle = st->first_idle;
> >  	struct io_entity *last_idle = st->last_idle;
> > -	struct io_queue *ioq = io_entity_to_ioq(entity);
> >  
> >  	if (first_idle == NULL || bfq_gt(first_idle->finish, entity->finish))
> >  		st->first_idle = entity;
> > @@ -444,10 +450,6 @@ static void bfq_idle_insert(struct io_service_tree *st,
> >  		st->last_idle = entity;
> >  
> >  	bfq_insert(&st->idle, entity);
> > -
> > -	/* Add this queue to idle list */
> > -	if (ioq)
> > -		list_add(&ioq->queue_list, &ioq->efqd->idle_list);
> >  }
> >  
> >  /**
> > @@ -723,8 +725,26 @@ int __bfq_deactivate_entity(struct io_entity *entity, int requeue)
> >  void bfq_deactivate_entity(struct io_entity *entity, int requeue)
> >  {
> >  	struct io_sched_data *sd;
> > +	struct io_group *iog;
> >  	struct io_entity *parent;
> >  
> > +	iog = container_of(entity->sched_data, struct io_group, sched_data);
> > +
> > +	/*
> > +	 * Hold a reference to entity's iog until we are done. This function
> > +	 * travels the hierarchy and we don't want to free up the group yet
> > +	 * while we are traversing the hiearchy. It is possible that this
> > +	 * group's cgroup has been removed hence cgroup reference is gone.
> > +	 * If this entity was active entity, then its group will not be on
> > +	 * any of the trees and it will be freed up the moment queue is
> > +	 * freed up in __bfq_deactivate_entity().
> > +	 *
> > +	 * Hence, hold a reference, deactivate the hierarhcy of entities and
> > +	 * then drop the reference which should free up the whole chain of
> > +	 * groups.
> > +	 */
> > +	elv_get_iog(iog);
> > +
> >  	for_each_entity_safe(entity, parent) {
> >  		sd = entity->sched_data;
> >  
> > @@ -736,21 +756,28 @@ void bfq_deactivate_entity(struct io_entity *entity, int requeue)
> >  			 */
> >  			break;
> >  
> > -		if (sd->next_active != NULL)
> > +		if (sd->next_active != NULL) {
> >  			/*
> >  			 * The parent entity is still backlogged and
> >  			 * the budgets on the path towards the root
> >  			 * need to be updated.
> >  			 */
> > +			elv_put_iog(iog);
> >  			goto update;
> > +		}
> >  
> >  		/*
> >  		 * If we reach there the parent is no more backlogged and
> >  		 * we want to propagate the dequeue upwards.
> > +		 *
> > +		 * If entity's group has been marked for deletion, don't
> > +		 * requeue the group in idle tree so that it can be freed.
> >  		 */
> > -		requeue = 1;
> > +		if (!iog_deleting(iog))
> > +			requeue = 1;
> 
>   Hi Vivek,
> 
>   IIUC, if the iog is marked deleting, all iogs in the hierarchy don't have a chance 
>   to be requeued into idle trees. So, I wonder why do it like this? Why the upper iogs 
>   can't be requeued to the idle tree?
> 

I think this is a bug Gui. Good catch. I think following should fix it.

Thanks
Vivek



Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/elevator-fq.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux16/block/elevator-fq.c
===================================================================
--- linux16.orig/block/elevator-fq.c	2009-06-06 14:21:11.000000000 -0400
+++ linux16/block/elevator-fq.c	2009-06-08 09:40:59.000000000 -0400
@@ -863,7 +863,7 @@ int __bfq_deactivate_entity(struct io_en
 void bfq_deactivate_entity(struct io_entity *entity, int requeue)
 {
 	struct io_sched_data *sd;
-	struct io_group *iog;
+	struct io_group *iog, *__iog;
 	struct io_entity *parent;
 
 	iog = container_of(entity->sched_data, struct io_group, sched_data);
@@ -911,8 +911,11 @@ void bfq_deactivate_entity(struct io_ent
 		 * If entity's group has been marked for deletion, don't
 		 * requeue the group in idle tree so that it can be freed.
 		 */
-		if (!iog_deleting(iog))
-			requeue = 1;
+		if (parent) {
+			__iog = container_of(parent, struct io_group, entity);
+			if (!iog_deleting(__iog))
+				requeue = 1;
+		}
 	}
 
 	elv_put_iog(iog);
