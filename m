Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZKDPfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZKDPfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbZKDPfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:35:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbZKDPfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:35:34 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 07/20] blkio: Provide capablity to enqueue/dequeue group entities
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com>
	<1257291837-6246-8-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 04 Nov 2009 10:34:57 -0500
In-Reply-To: <1257291837-6246-8-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Tue, 3 Nov 2009 18:43:44 -0500")
Message-ID: <x49zl72tiam.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> o This patch embeds cfq_entity object in cfq_group and provides helper routines
>   so that group entities can be scheduled.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/cfq-iosched.c |  110 +++++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 93 insertions(+), 17 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index bc99163..8ec8a82 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -79,6 +79,7 @@ struct cfq_service_tree {
>  #define CFQ_RB_ROOT	(struct cfq_service_tree) { RB_ROOT, NULL, 0, NULL}
>  
>  struct cfq_sched_data {
> +	unsigned int nr_active;
>  	struct cfq_service_tree service_tree[IO_IOPRIO_CLASSES];
>  };
>  
> @@ -89,6 +90,10 @@ struct cfq_entity {
>  	struct cfq_service_tree *st;
>  	unsigned short ioprio_class;
>  	bool ioprio_class_changed;
> +	struct cfq_entity *parent;
> +	bool on_st;
> +	/* Points to the sched_data of group entity. Null for cfqq */
> +	struct cfq_sched_data *my_sd;

Why my_sd?  None of the other members required a my.  ;-)

> +static inline struct cfq_entity *parent_entity(struct cfq_entity *cfqe)
> +{
> +	return cfqe->parent;
> +}

Wow, is this really necessary for a pointer dereference?

> +#ifdef CONFIG_CFQ_GROUP_IOSCHED
> +/* check for entity->parent so that loop is not executed for root entity. */
> +#define for_each_entity(entity)	\
> +	for (; entity && entity->parent; entity = entity->parent)

See, you don't use it here!

> @@ -660,7 +723,13 @@ static void enqueue_cfqe(struct cfq_entity *cfqe)
>  
>  static void enqueue_cfqq(struct cfq_queue *cfqq)
>  {
> -	enqueue_cfqe(&cfqq->entity);
> +	struct cfq_entity *cfqe = &cfqq->entity;
> +
> +	for_each_entity(cfqe) {
> +		if (cfqe->on_st)
> +			break;
> +		enqueue_cfqe(cfqe);
> +	}
>  }

Maybe I'm slow, but I would have benefitted from a comment above that
function stating that we have to walk up the tree to make sure that the
parent is also scheduled.

Cheers,
Jeff
