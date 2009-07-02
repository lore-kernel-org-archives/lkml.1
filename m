Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbZGBULo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbZGBULo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbZGBUJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:09:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:29803 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbZGBUJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:09:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=qPL4i39M83MTPYTaU4iVEmkcO6Oc58SEOkwd+RaZ/EO+EzR279uIy5weXT/YeyE9G
	bxf/PkXue4pJC8MuGiU/w==
MIME-Version: 1.0
In-Reply-To: <1246564917-19603-14-git-send-email-vgoyal@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	 <1246564917-19603-14-git-send-email-vgoyal@redhat.com>
Date: Thu, 2 Jul 2009 13:09:14 -0700
Message-ID: <e98e18940907021309u1f784b3at409b55ba46ed108c@mail.gmail.com>
Subject: Re: [PATCH 13/25] io-controller: Wait for requests to complete from 
	last queue before new queue is scheduled
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 1:01 PM, Vivek Goyal<vgoyal@redhat.com> wrote:
> o Currently one can dispatch requests from multiple queues to the disk. This
>  is true for hardware which supports queuing. So if a disk support queue
>  depth of 31 it is possible that 20 requests are dispatched from queue 1
>  and then next queue is scheduled in which dispatches more requests.
>
> o This multiple queue dispatch introduces issues for accurate accounting of
>  disk time consumed by a particular queue. For example, if one async queue
>  is scheduled in, it can dispatch 31 requests to the disk and then it will
>  be expired and a new sync queue might get scheduled in. These 31 requests
>  might take a long time to finish but this time is never accounted to the
>  async queue which dispatched these requests.
>
> o This patch introduces the functionality where we wait for all the requests
>  to finish from previous queue before next queue is scheduled in. That way
>  a queue is more accurately accounted for disk time it has consumed. Note
>  this still does not take care of errors introduced by disk write caching.
>
> o Because above behavior can result in reduced throughput, this behavior will
>  be enabled only if user sets "fairness" tunable to 2 or higher.

Vivek,
Did you collect any numbers for the impact on throughput from this
patch? It seems like with this change, we can even support NCQ.

>
> o This patch helps in achieving more isolation between reads and buffered
>  writes in different cgroups. buffered writes typically utilize full queue
>  depth and then expire the queue. On the contarary, sequential reads
>  typicaly driver queue depth of 1. So despite the fact that writes are
>  using more disk time it is never accounted to write queue because we don't
>  wait for requests to finish after dispatching these. This patch helps
>  do more accurate accounting of disk time, especially for buffered writes
>  hence providing better fairness hence better isolation between two cgroups
>  running read and write workloads.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/elevator-fq.c |   31 ++++++++++++++++++++++++++++++-
>  1 files changed, 30 insertions(+), 1 deletions(-)
>
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 68be1dc..7609579 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2038,7 +2038,7 @@ STORE_FUNCTION(elv_slice_sync_store, &efqd->elv_slice[1], 1, UINT_MAX, 1);
>  EXPORT_SYMBOL(elv_slice_sync_store);
>  STORE_FUNCTION(elv_slice_async_store, &efqd->elv_slice[0], 1, UINT_MAX, 1);
>  EXPORT_SYMBOL(elv_slice_async_store);
> -STORE_FUNCTION(elv_fairness_store, &efqd->fairness, 0, 1, 0);
> +STORE_FUNCTION(elv_fairness_store, &efqd->fairness, 0, 2, 0);
>  EXPORT_SYMBOL(elv_fairness_store);
>  #undef STORE_FUNCTION
>
> @@ -2952,6 +2952,24 @@ void *elv_fq_select_ioq(struct request_queue *q, int force)
>        }
>
>  expire:
> +       if (efqd->fairness >= 2 && !force && ioq && ioq->dispatched) {
> +               /*
> +                * If there are request dispatched from this queue, don't
> +                * dispatch requests from new queue till all the requests from
> +                * this queue have completed.
> +                *
> +                * This helps in attributing right amount of disk time consumed
> +                * by a particular queue when hardware allows queuing.
> +                *
> +                * Set ioq = NULL so that no more requests are dispatched from
> +                * this queue.
> +                */
> +               elv_log_ioq(efqd, ioq, "select: wait for requests to finish"
> +                               " disp=%lu", ioq->dispatched);
> +               ioq = NULL;
> +               goto keep_queue;
> +       }
> +
>        elv_ioq_slice_expired(q);
>  new_queue:
>        ioq = elv_set_active_ioq(q, new_ioq);
> @@ -3109,6 +3127,17 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
>                                 */
>                                elv_ioq_arm_slice_timer(q, 1);
>                        } else {
> +                               /* If fairness >=2 and there are requests
> +                                * dispatched from this queue, don't dispatch
> +                                * new requests from a different queue till
> +                                * all requests from this queue have finished.
> +                                * This helps in attributing right disk time
> +                                * to a queue when hardware supports queuing.
> +                                */
> +
> +                               if (efqd->fairness >= 2 && ioq->dispatched)
> +                                       goto done;
> +
>                                /* Expire the queue */
>                                elv_ioq_slice_expired(q);
>                        }
> --
> 1.6.0.6
>
>
