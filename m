Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbZLBNmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbZLBNmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZLBNmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:42:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbZLBNmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:42:16 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 4/4] cfq-iosched: fix corner cases in idling logic
References: <200911241449.36336.czoccolo@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 02 Dec 2009 08:42:15 -0500
In-Reply-To: <200911241449.36336.czoccolo@gmail.com> (Corrado Zoccolo's
	message of "Tue, 24 Nov 2009 14:49:36 +0100")
Message-ID: <x49zl61lcg8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Idling logic was disabled in some corner cases, leading to unfair share
> for noidle queues.
> * the idle timer was not armed if there were other requests in the
>   driver. unfortunately, those requests could come from other workloads,
>   or queues for which we don't enable idling. So we will check only
>   pending requests from the active queue
> * rq_noidle check on no-idle queue could disable the end of tree idle if
>   the last completed request was rq_noidle. Now, we will disable that
>   idle only if all the queues served in the no-idle tree had rq_noidle
>   requests.
>
> Reported-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>

> @@ -2606,17 +2608,27 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>  			cfq_clear_cfqq_slice_new(cfqq);
>  		}
>  		/*
> -		 * If there are no requests waiting in this queue, and
> -		 * there are other queues ready to issue requests, AND
> -		 * those other queues are issuing requests within our
> -		 * mean seek distance, give them a chance to run instead
> -		 * of idling.
> +		 * Idling is not enabled on:
> +		 * - expired queues
> +		 * - idle-priority queues
> +		 * - async queues
> +		 * - queues with still some requests queued
> +		 * - when there is a close cooperator
>  		 */

I'm not sure this logic is correct.  Is this for the 2.6.33 branch?  If
so, the coop flag now means that multiple processes share the same
cfqq.  Are you sure this is the right thing to do for close cooperators?

Cheers,
Jeff

>  		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
>  			cfq_slice_expired(cfqd, 1);
> -		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq) &&
> -			 sync && !rq_noidle(rq))
> -			cfq_arm_slice_timer(cfqd);
> +		else if (sync && cfqq_empty &&
> +			 !cfq_close_cooperator(cfqd, cfqq)) {
> +			cfqd->noidle_tree_requires_idle |= !rq_noidle(rq);
> +			/*
> +			 * Idling is enabled for SYNC_WORKLOAD.
> +			 * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
> +			 * only if we processed at least one !rq_noidle request
> +			 */
> +			if (cfqd->serving_type == SYNC_WORKLOAD
> +			    || cfqd->noidle_tree_requires_idle)
> +				cfq_arm_slice_timer(cfqd);
> +		}
>  	}
>  
>  	if (!rq_in_driver(cfqd))
