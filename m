Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZA1GRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZA1GRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZA1GR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:17:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:26979 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZA1GR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:17:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=qvPCq0BMIENtxZBlDABCmbLmA5N8rQVLGE9IfzDslH24NN00+fff5s0SzEeRspfOe
	6JIxZfMzww14e77vKH3Ww==
MIME-Version: 1.0
In-Reply-To: <20090128060140.16117.44772.stgit@hyd-omgvisitor1.hyd.corp.google.com>
References: <20090128060140.16117.44772.stgit@hyd-omgvisitor1.hyd.corp.google.com>
Date: Wed, 28 Jan 2009 11:47:22 +0530
Message-ID: <af41c7c40901272217j4bc8e0devbe5f22ffbd07b692@mail.gmail.com>
Subject: Re: [PATCH v2][RESEND] Allow RT requests to pre-empt ongoing BE 
	timeslice in CFQ.
From: Divyesh Shah <dpshah@google.com>
To: jens.axboe@oracle.com, mikew@google.com, nauman@google.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.143
X-GMailtapped: dpshah
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Jens Axboe

On Wed, Jan 28, 2009 at 11:35 AM, Divyesh Shah <dpshah@google.com> wrote:
> This patch adds the ability to pre-empt an ongoing BE timeslice when a RT
> request is waiting for the current timeslice to complete. This reduces the
> wait time to disk for RT requests from an upper bound of 4 (current value
> of cfq_quantum) to 1 disk request.
>
> Signed-off-by: Divyesh Shah <dpshah@google.com>
> ---
> Applied Jens' suggeested changes to avoid the rb lookup and use !cfq_class_rt()
> and retested.
>
> Latency(secs) for the RT task when doing sequential reads from 10G file.
>                       | only RT | RT + BE | RT + BE + this patch
> small (512 byte) reads | 143     | 163     | 145
> large (1Mb) reads      | 142     | 158     | 146
>
>  block/cfq-iosched.c |   39 ++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 38 insertions(+), 1 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index e8525fa..5fec9e5 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -84,6 +84,11 @@ struct cfq_data {
>         */
>        struct cfq_rb_root service_tree;
>        unsigned int busy_queues;
> +       /*
> +        * Used to track any pending rt requests so we can pre-empt current
> +        * non-RT cfqq in service when this value is non-zero.
> +        */
> +       unsigned int busy_rt_queues;
>
>        int rq_in_driver;
>        int sync_flight;
> @@ -562,6 +567,8 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>        BUG_ON(cfq_cfqq_on_rr(cfqq));
>        cfq_mark_cfqq_on_rr(cfqq);
>        cfqd->busy_queues++;
> +       if (cfq_class_rt(cfqq))
> +               cfqd->busy_rt_queues++;
>
>        cfq_resort_rr_list(cfqd, cfqq);
>  }
> @@ -581,6 +588,8 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>
>        BUG_ON(!cfqd->busy_queues);
>        cfqd->busy_queues--;
> +       if (cfq_class_rt(cfqq))
> +               cfqd->busy_rt_queues--;
>  }
>
>  /*
> @@ -1005,6 +1014,20 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
>                goto expire;
>
>        /*
> +        * If we have a RT cfqq waiting, then we pre-empt the current non-rt
> +        * cfqq.
> +        */
> +       if (!cfq_class_rt(cfqq) && cfqd->busy_rt_queues) {
> +               /*
> +                * We simulate this as cfqq timed out so that it gets to bank
> +                * the remaining of its time slice.
> +                */
> +               cfq_log_cfqq(cfqd, cfqq, "preempt");
> +               cfq_slice_expired(cfqd, 1);
> +               goto new_queue;
> +       }
> +
> +       /*
>         * The active queue has requests and isn't expired, allow it to
>         * dispatch.
>         */
> @@ -1067,6 +1090,13 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>                if (RB_EMPTY_ROOT(&cfqq->sort_list))
>                        break;
>
> +               /*
> +                * If there is a non-empty RT cfqq waiting for current
> +                * cfqq's timeslice to complete, pre-empt this cfqq
> +                */
> +               if (!cfq_class_rt(cfqq) && cfqd->busy_rt_queues)
> +                       break;
> +
>        } while (dispatched < max_dispatch);
>
>        /*
> @@ -1801,6 +1831,12 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>        if (rq_is_meta(rq) && !cfqq->meta_pending)
>                return 1;
>
> +       /*
> +        * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
> +        */
> +       if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
> +               return 1;
> +
>        if (!cfqd->active_cic || !cfq_cfqq_wait_request(cfqq))
>                return 0;
>
> @@ -1870,7 +1906,8 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>                /*
>                 * not the active queue - expire current slice if it is
>                 * idle and has expired it's mean thinktime or this new queue
> -                * has some old slice time left and is of higher priority
> +                * has some old slice time left and is of higher priority or
> +                * this new queue is RT and the current one is BE
>                 */
>                cfq_preempt_queue(cfqd, cfqq);
>                cfq_mark_cfqq_must_dispatch(cfqq);
>
>
