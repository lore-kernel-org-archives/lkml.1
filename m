Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZKDQzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZKDQzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbZKDQzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:55:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195AbZKDQzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:55:22 -0500
Date: Wed, 4 Nov 2009 11:54:34 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 07/20] blkio: Provide capablity to enqueue/dequeue
	group entities
Message-ID: <20091104165434.GD2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-8-git-send-email-vgoyal@redhat.com> <x49zl72tiam.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zl72tiam.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 10:34:57AM -0500, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > o This patch embeds cfq_entity object in cfq_group and provides helper routines
> >   so that group entities can be scheduled.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/cfq-iosched.c |  110 +++++++++++++++++++++++++++++++++++++++++++--------
> >  1 files changed, 93 insertions(+), 17 deletions(-)
> >
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index bc99163..8ec8a82 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -79,6 +79,7 @@ struct cfq_service_tree {
> >  #define CFQ_RB_ROOT	(struct cfq_service_tree) { RB_ROOT, NULL, 0, NULL}
> >  
> >  struct cfq_sched_data {
> > +	unsigned int nr_active;
> >  	struct cfq_service_tree service_tree[IO_IOPRIO_CLASSES];
> >  };
> >  
> > @@ -89,6 +90,10 @@ struct cfq_entity {
> >  	struct cfq_service_tree *st;
> >  	unsigned short ioprio_class;
> >  	bool ioprio_class_changed;
> > +	struct cfq_entity *parent;
> > +	bool on_st;
> > +	/* Points to the sched_data of group entity. Null for cfqq */
> > +	struct cfq_sched_data *my_sd;
> 
> Why my_sd?  None of the other members required a my.  ;-)
> 

Because in rest of the code, we have been using "struct cfq_sched_data *sd"
to mean pointer to scheduling data entity/queue/group is queued. 

In this case entity is embedded inside a cfq_group object and it is
hosting a sched_data tree. So "*sd" means the sched_data the entity is
queued on and "*my_sd" means the sched_data entity is hosting.

> > +static inline struct cfq_entity *parent_entity(struct cfq_entity *cfqe)
> > +{
> > +	return cfqe->parent;
> > +}
> 
> Wow, is this really necessary for a pointer dereference?
> 

I guess no. As core scheduling code is inspired from CFS, it is coming
from there. :-). Will get rid of it in next posting.

> > +#ifdef CONFIG_CFQ_GROUP_IOSCHED
> > +/* check for entity->parent so that loop is not executed for root entity. */
> > +#define for_each_entity(entity)	\
> > +	for (; entity && entity->parent; entity = entity->parent)
> 
> See, you don't use it here

:-)

> 
> > @@ -660,7 +723,13 @@ static void enqueue_cfqe(struct cfq_entity *cfqe)
> >  
> >  static void enqueue_cfqq(struct cfq_queue *cfqq)
> >  {
> > -	enqueue_cfqe(&cfqq->entity);
> > +	struct cfq_entity *cfqe = &cfqq->entity;
> > +
> > +	for_each_entity(cfqe) {
> > +		if (cfqe->on_st)
> > +			break;
> > +		enqueue_cfqe(cfqe);
> > +	}
> >  }
> 
> Maybe I'm slow, but I would have benefitted from a comment above that
> function stating that we have to walk up the tree to make sure that the
> parent is also scheduled.

Sure, will put a comment here.

Thanks
Vivek
