Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbZCXSOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbZCXSOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZCXSOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:14:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46891 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZCXSOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:14:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=fBKYahx/FqDh7vcQJ6itOH2iafJxB7fkgNc4zqP7YrRV8hYnnCOBSPO1Ls2duAPbw
	JxyV2sFEPUicr3Dr0FOVw==
MIME-Version: 1.0
In-Reply-To: <20090324125842.GA21389@redhat.com>
References: <1236823015-4183-1-git-send-email-vgoyal@redhat.com>
	 <1236823015-4183-2-git-send-email-vgoyal@redhat.com>
	 <20090312100054.GA8024@linux.vnet.ibm.com>
	 <20090312140450.GE10919@redhat.com> <49C0A171.8060009@cn.fujitsu.com>
	 <20090318215529.GA3338@redhat.com>
	 <e98e18940903232232i432f62c5r9dfd74268e1b2684@mail.gmail.com>
	 <20090324125842.GA21389@redhat.com>
Date: Tue, 24 Mar 2009 11:14:13 -0700
Message-ID: <e98e18940903241114u1e03ae7dhf654d7d8d0fc0302@mail.gmail.com>
Subject: Re: [PATCH 01/10] Documentation
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp,
       fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       arozansk@redhat.com, jmoyer@redhat.com, oz-kernel@redhat.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       menage@google.com, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 5:58 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Mar 23, 2009 at 10:32:41PM -0700, Nauman Rafique wrote:
>
> [..]
>> > DESC
>> > io-controller: idle for sometime on sync queue before expiring it
>> > EDESC
>> >
>> > o When a sync queue expires, in many cases it might be empty and then
>> > áit will be deleted from the active tree. This will lead to a scenario
>> > áwhere out of two competing queues, only one is on the tree and when a
>> > ánew queue is selected, vtime jump takes place and we don't see services
>> > áprovided in proportion to weight.
>> >
>> > o In general this is a fundamental problem with fairness of sync queues
>> > áwhere queues are not continuously backlogged. Looks like idling is
>> > áonly solution to make sure such kind of queues can get some decent amount
>> > áof disk bandwidth in the face of competion from continusouly backlogged
>> > áqueues. But excessive idling has potential to reduce performance on SSD
>> > áand disks with commnad queuing.
>> >
>> > o This patch experiments with waiting for next request to come before a
>> > áqueue is expired after it has consumed its time slice. This can ensure
>> > ámore accurate fairness numbers in some cases.
>>
>> Vivek, have you introduced this option just to play with it, or you
>> are planning to make it a part of the patch set. Waiting for a new
>> request to come before expiring time slice sounds problematic.
>
> Why are the issues you forsee with it. This is just an extra 8ms idling
> on the sync queue that is also if think time of the queue is not high.
>
> We already do idling on sync queues. In this case we are doing an extra
> idle even if queue has consumed its allocated quota. It helps me get
> fairness numbers and I have put it under a tunable "fairness". So by
> default this code will not kick in.
>
> Other possible option could be that when expiring a sync queue, don't
> remove the queue immediately from the tree and remove it later if there
> is no request from the queue in 8ms or so. I am not sure with BFQ, is it
> feasible to do that without creating issues with current implementation.
> Current implementation was simple, so I stick to it to begin with.

If the maximum wait is bounded by 8ms, then it should be fine. The
comments on the patch did not talk about such limit; it sounded like
unbounded wait to me.

Does keeping the sync queue in ready tree solves the problem too? Is
it because it avoid a virtual time jump?

>
> So yes, I am planning to keep it under tunable, unless there are
> significant issues in doing that.
>
> Thanks
> Vivek
>
>>
>> >
>> > o Introduced a tunable "fairness". If set, io-controller will put more
>> > áfocus on getting fairness right than getting throughput right.
>> >
>> >
>> > ---
>> > áblock/blk-sysfs.c á | á á7 ++++
>> > áblock/elevator-fq.c | á 85 +++++++++++++++++++++++++++++++++++++++++++++-------
>> > áblock/elevator-fq.h | á 12 +++++++
>> > á3 files changed, 94 insertions(+), 10 deletions(-)
>> >
>> > Index: linux1/block/elevator-fq.h
>> > ===================================================================
>> > --- linux1.orig/block/elevator-fq.h á á 2009-03-18 17:34:46.000000000 -0400
>> > +++ linux1/block/elevator-fq.h á2009-03-18 17:34:53.000000000 -0400
>> > @@ -318,6 +318,13 @@ struct elv_fq_data {
>> > á á á áunsigned long long rate_sampling_start; /*sampling window start jifies*/
>> > á á á á/* number of sectors finished io during current sampling window */
>> > á á á áunsigned long rate_sectors_current;
>> > +
>> > + á á á /*
>> > + á á á á* If set to 1, will disable many optimizations done for boost
>> > + á á á á* throughput and focus more on providing fairness for sync
>> > + á á á á* queues.
>> > + á á á á*/
>> > + á á á int fairness;
>> > á};
>> >
>> > áextern int elv_slice_idle;
>> > @@ -340,6 +347,7 @@ enum elv_queue_state_flags {
>> > á á á áELV_QUEUE_FLAG_idle_window, á á á /* elevator slice idling enabled */
>> > á á á áELV_QUEUE_FLAG_wait_request, á á á/* waiting for a request */
>> > á á á áELV_QUEUE_FLAG_slice_new, á á á á /* no requests dispatched in slice */
>> > + á á á ELV_QUEUE_FLAG_wait_busy, á á á á /* wait for this queue to get busy */
>> > á á á áELV_QUEUE_FLAG_NR,
>> > á};
>> >
>> > @@ -362,6 +370,7 @@ ELV_IO_QUEUE_FLAG_FNS(sync)
>> > áELV_IO_QUEUE_FLAG_FNS(wait_request)
>> > áELV_IO_QUEUE_FLAG_FNS(idle_window)
>> > áELV_IO_QUEUE_FLAG_FNS(slice_new)
>> > +ELV_IO_QUEUE_FLAG_FNS(wait_busy)
>> >
>> > ástatic inline struct io_service_tree *
>> > áio_entity_service_tree(struct io_entity *entity)
>> > @@ -554,6 +563,9 @@ static inline struct io_queue *elv_looku
>> > áextern ssize_t elv_slice_idle_show(struct request_queue *q, char *name);
>> > áextern ssize_t elv_slice_idle_store(struct request_queue *q, const char *name,
>> > á á á á á á á á á á á á á á á á á á á á á á á ásize_t count);
>> > +extern ssize_t elv_fairness_show(struct request_queue *q, char *name);
>> > +extern ssize_t elv_fairness_store(struct request_queue *q, const char *name,
>> > + á á á á á á á á á á á á á á á á á á á á á á á size_t count);
>> >
>> > á/* Functions used by elevator.c */
>> > áextern int elv_init_fq_data(struct request_queue *q, struct elevator_queue *e);
>> > Index: linux1/block/elevator-fq.c
>> > ===================================================================
>> > --- linux1.orig/block/elevator-fq.c á á 2009-03-18 17:34:46.000000000 -0400
>> > +++ linux1/block/elevator-fq.c á2009-03-18 17:34:53.000000000 -0400
>> > @@ -1837,6 +1837,44 @@ void elv_ioq_served(struct io_queue *ioq
>> > á á á á á á á á á á á áioq->total_service);
>> > á}
>> >
>> > +/* Functions to show and store fairness value through sysfs */
>> > +ssize_t elv_fairness_show(struct request_queue *q, char *name)
>> > +{
>> > + á á á struct elv_fq_data *efqd;
>> > + á á á unsigned int data;
>> > + á á á unsigned long flags;
>> > +
>> > + á á á spin_lock_irqsave(q->queue_lock, flags);
>> > + á á á efqd = &q->elevator->efqd;
>> > + á á á data = efqd->fairness;
>> > + á á á spin_unlock_irqrestore(q->queue_lock, flags);
>> > + á á á return sprintf(name, "%d\n", data);
>> > +}
>> > +
>> > +ssize_t elv_fairness_store(struct request_queue *q, const char *name,
>> > + á á á á á á á á á á á á size_t count)
>> > +{
>> > + á á á struct elv_fq_data *efqd;
>> > + á á á unsigned int data;
>> > + á á á unsigned long flags;
>> > +
>> > + á á á char *p = (char *)name;
>> > +
>> > + á á á data = simple_strtoul(p, &p, 10);
>> > +
>> > + á á á if (data < 0)
>> > + á á á á á á á data = 0;
>> > + á á á else if (data > INT_MAX)
>> > + á á á á á á á data = INT_MAX;
>> > +
>> > + á á á spin_lock_irqsave(q->queue_lock, flags);
>> > + á á á efqd = &q->elevator->efqd;
>> > + á á á efqd->fairness = data;
>> > + á á á spin_unlock_irqrestore(q->queue_lock, flags);
>> > +
>> > + á á á return count;
>> > +}
>> > +
>> > á/* Functions to show and store elv_idle_slice value through sysfs */
>> > ássize_t elv_slice_idle_show(struct request_queue *q, char *name)
>> > á{
>> > @@ -2263,10 +2301,11 @@ void __elv_ioq_slice_expired(struct requ
>> > á á á áassert_spin_locked(q->queue_lock);
>> > á á á áelv_log_ioq(efqd, ioq, "slice expired upd=%d", budget_update);
>> >
>> > - á á á if (elv_ioq_wait_request(ioq))
>> > + á á á if (elv_ioq_wait_request(ioq) || elv_ioq_wait_busy(ioq))
>> > á á á á á á á ádel_timer(&efqd->idle_slice_timer);
>> >
>> > á á á áelv_clear_ioq_wait_request(ioq);
>> > + á á á elv_clear_ioq_wait_busy(ioq);
>> >
>> > á á á á/*
>> > á á á á * if ioq->slice_end = 0, that means a queue was expired before first
>> > @@ -2482,8 +2521,9 @@ void elv_ioq_request_add(struct request_
>> > á á á á á á á á * immediately and flag that we must not expire this queue
>> > á á á á á á á á * just now
>> > á á á á á á á á */
>> > - á á á á á á á if (elv_ioq_wait_request(ioq)) {
>> > + á á á á á á á if (elv_ioq_wait_request(ioq) || elv_ioq_wait_busy(ioq)) {
>> > á á á á á á á á á á á ádel_timer(&efqd->idle_slice_timer);
>> > + á á á á á á á á á á á elv_clear_ioq_wait_busy(ioq);
>> > á á á á á á á á á á á áblk_start_queueing(q);
>> > á á á á á á á á}
>> > á á á á} else if (elv_should_preempt(q, ioq, rq)) {
>> > @@ -2519,6 +2559,9 @@ void elv_idle_slice_timer(unsigned long
>> >
>> > á á á áif (ioq) {
>> >
>> > + á á á á á á á if (elv_ioq_wait_busy(ioq))
>> > + á á á á á á á á á á á goto expire;
>> > +
>> > á á á á á á á á/*
>> > á á á á á á á á * expired
>> > á á á á á á á á */
>> > @@ -2546,7 +2589,7 @@ out_cont:
>> > á á á áspin_unlock_irqrestore(q->queue_lock, flags);
>> > á}
>> >
>> > -void elv_ioq_arm_slice_timer(struct request_queue *q)
>> > +void elv_ioq_arm_slice_timer(struct request_queue *q, int wait_for_busy)
>> > á{
>> > á á á ástruct elv_fq_data *efqd = &q->elevator->efqd;
>> > á á á ástruct io_queue *ioq = elv_active_ioq(q->elevator);
>> > @@ -2563,15 +2606,27 @@ void elv_ioq_arm_slice_timer(struct requ
>> > á á á á á á á áreturn;
>> >
>> > á á á á/*
>> > - á á á á* still requests with the driver, don't idle
>> > + á á á á* idle is disabled, either manually or by past process history
>> > á á á á */
>> > - á á á if (efqd->rq_in_driver)
>> > + á á á if (!efqd->elv_slice_idle || !elv_ioq_idle_window(ioq))
>> > á á á á á á á áreturn;
>> >
>> > á á á á/*
>> > - á á á á* idle is disabled, either manually or by past process history
>> > + á á á á* This queue has consumed its time slice. We are waiting only for
>> > + á á á á* it to become busy before we select next queue for dispatch.
>> > á á á á */
>> > - á á á if (!efqd->elv_slice_idle || !elv_ioq_idle_window(ioq))
>> > + á á á if (efqd->fairness && wait_for_busy) {
>> > + á á á á á á á elv_mark_ioq_wait_busy(ioq);
>> > + á á á á á á á sl = efqd->elv_slice_idle;
>> > + á á á á á á á mod_timer(&efqd->idle_slice_timer, jiffies + sl);
>> > + á á á á á á á elv_log(efqd, "arm idle: %lu wait busy=1", sl);
>> > + á á á á á á á return;
>> > + á á á }
>> > +
>> > + á á á /*
>> > + á á á á* still requests with the driver, don't idle
>> > + á á á á*/
>> > + á á á if (efqd->rq_in_driver)
>> > á á á á á á á áreturn;
>> >
>> > á á á á/*
>> > @@ -2628,6 +2683,12 @@ void *elv_fq_select_ioq(struct request_q
>> > á á á á á á á á}
>> > á á á á}
>> >
>> > + á á á /* We are waiting for this queue to become busy before it expires.*/
>> > + á á á if (efqd->fairness && elv_ioq_wait_busy(ioq)) {
>> > + á á á á á á á ioq = NULL;
>> > + á á á á á á á goto keep_queue;
>> > + á á á }
>> > +
>> > á á á á/*
>> > á á á á * The active queue has run out of time, expire it and select new.
>> > á á á á */
>> > @@ -2802,10 +2863,14 @@ void elv_ioq_completed_request(struct re
>> > á á á á á á á á á á á áelv_ioq_set_prio_slice(q, ioq);
>> > á á á á á á á á á á á áelv_clear_ioq_slice_new(ioq);
>> > á á á á á á á á}
>> > - á á á á á á á if (elv_ioq_slice_used(ioq) || elv_ioq_class_idle(ioq))
>> > + á á á á á á á if (elv_ioq_class_idle(ioq))
>> > á á á á á á á á á á á áelv_ioq_slice_expired(q, 1);
>> > - á á á á á á á else if (sync && !ioq->nr_queued)
>> > - á á á á á á á á á á á elv_ioq_arm_slice_timer(q);
>> > + á á á á á á á else if (sync && !ioq->nr_queued) {
>> > + á á á á á á á á á á á if (elv_ioq_slice_used(ioq))
>> > + á á á á á á á á á á á á á á á elv_ioq_arm_slice_timer(q, 1);
>> > + á á á á á á á á á á á else
>> > + á á á á á á á á á á á á á á á elv_ioq_arm_slice_timer(q, 0);
>> > + á á á á á á á }
>> > á á á á}
>> >
>> > á á á áif (!efqd->rq_in_driver)
>> > Index: linux1/block/blk-sysfs.c
>> > ===================================================================
>> > --- linux1.orig/block/blk-sysfs.c á á á 2009-03-18 17:34:28.000000000 -0400
>> > +++ linux1/block/blk-sysfs.c á á2009-03-18 17:34:53.000000000 -0400
>> > @@ -282,6 +282,12 @@ static struct queue_sysfs_entry queue_sl
>> > á á á á.show = elv_slice_idle_show,
>> > á á á á.store = elv_slice_idle_store,
>> > á};
>> > +
>> > +static struct queue_sysfs_entry queue_fairness_entry = {
>> > + á á á .attr = {.name = "fairness", .mode = S_IRUGO | S_IWUSR },
>> > + á á á .show = elv_fairness_show,
>> > + á á á .store = elv_fairness_store,
>> > +};
>> > á#endif
>> > ástatic struct attribute *default_attrs[] = {
>> > á á á á&queue_requests_entry.attr,
>> > @@ -296,6 +302,7 @@ static struct attribute *default_attrs[]
>> > á á á á&queue_iostats_entry.attr,
>> > á#ifdef CONFIG_ELV_FAIR_QUEUING
>> > á á á á&queue_slice_idle_entry.attr,
>> > + á á á &queue_fairness_entry.attr,
>> > á#endif
>> > á á á áNULL,
>> > á};
>> >
>
