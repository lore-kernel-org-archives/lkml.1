Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZC0Nyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZC0Nyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZC0Nyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:54:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54316 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZC0Nyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:54:45 -0400
Date: Fri, 27 Mar 2009 09:52:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@intellilink.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Subject: Re: [PATCH] IO Controller: Don't store the pid in single queue
	circumstances
Message-ID: <20090327135235.GD30476@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com> <1236823015-4183-3-git-send-email-vgoyal@redhat.com> <49CC8EBA.9040804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC8EBA.9040804@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 04:30:50PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +int elv_init_ioq(struct elevator_queue *eq, struct io_queue *ioq,
> > +			void *sched_queue, int ioprio_class, int ioprio,
> > +			int is_sync)
> > +{
> > +	struct elv_fq_data *efqd = &eq->efqd;
> > +	struct io_group *iog = io_lookup_io_group_current(efqd->queue);
> > +
> > +	RB_CLEAR_NODE(&ioq->entity.rb_node);
> > +	atomic_set(&ioq->ref, 0);
> > +	ioq->efqd = efqd;
> > +	ioq->entity.budget = efqd->elv_slice[is_sync];
> > +	elv_ioq_set_ioprio_class(ioq, ioprio_class);
> > +	elv_ioq_set_ioprio(ioq, ioprio);
> > +	ioq->pid = current->pid;
> 
>   Hi Vivek,
> 
>   Storing a pid in single queue circumstances doesn't make sence.
>   So just store the pid when cfq is used.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>  ---
>  block/elevator-fq.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index df53418..c72f7e6 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -1988,7 +1988,10 @@ int elv_init_ioq(struct elevator_queue *eq, struct io_queue *ioq,
>  	ioq->entity.budget = efqd->elv_slice[is_sync];
>  	elv_ioq_set_ioprio_class(ioq, ioprio_class);
>  	elv_ioq_set_ioprio(ioq, ioprio);
> -	ioq->pid = current->pid;
> +	if (elv_iosched_single_ioq(eq))
> +		ioq->pid = 0;
> +	else
> +		ioq->pid = current->pid;
>  	ioq->sched_queue = sched_queue;

Thanks Gui. Yes, if there is a single ioq, this pid will reflect the
pid of the process who caused the creation of the io queue and later
requests from all the other processess will go into same queue.

In fact cfq also has the same issue for async queues where async queue
will store the pid when it is created later all other processes of same
prio level will use it.

So if you think displaying "0" is better than displaying the the pid of
the process who created the queue, then I will include this patch. Right
now I don't have very strong opinion about it. 

Thanks
Vivek
