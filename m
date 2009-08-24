Return-Path: <linux-kernel-owner+w=401wt.eu-S1751408AbZHXDbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbZHXDbc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 23:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZHXDbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 23:31:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53783 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZHXDbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 23:31:31 -0400
Message-ID: <4A92095A.4070804@cn.fujitsu.com>
Date: Mon, 24 Aug 2009 11:30:34 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com
Subject: Re: [PATCH 12/24] io-controller: Wait for requests to complete from
 last queue before new queue is scheduled
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-13-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1250451046-9966-13-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
>  void elv_schedule_dispatch(struct request_queue *q)
> @@ -2260,6 +2264,17 @@ void *elv_select_ioq(struct request_queue *q, int force)
>  	}
>  
>  expire:
> +	if (efqd->fairness && !force && ioq && ioq->dispatched) {
> +		/*
> +		 * If there are request dispatched from this queue, don't
> +		 * dispatch requests from new queue till all the requests from
> +		 * this queue have completed.
> +		 */
> +		elv_log_ioq(efqd, ioq, "select: wait for requests to finish"
> +				" disp=%lu", ioq->dispatched);
> +		ioq = NULL;
> +		goto keep_queue;
> +	}
>  	elv_slice_expired(q);
>  new_queue:
>  	ioq = elv_set_active_ioq(q, new_ioq);
> @@ -2375,6 +2390,10 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
>  				goto done;
>  			}
>  
> +			/* Wait for requests to finish from this queue */
> +			if (efqd->fairness && ioq->dispatched)

Since we have the routing to access to ioq->dispatched, why not to use it.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/elevator-fq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index d04e925..f1e0de5 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -3120,7 +3120,7 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
 			}
 
 			/* Wait for requests to finish from this queue */
-			if (efqd->fairness && ioq->dispatched)
+			if (efqd->fairness && elv_ioq_nr_dispatched(ioq))
 				goto done;
 
 			/* Expire the queue */
@@ -3135,7 +3135,7 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
 		 * If this is the last queue in the group and we did not
 		 * decide to idle on queue, idle on group.
 		 */
-		if (elv_iog_should_idle(ioq) && !ioq->dispatched
+		if (elv_iog_should_idle(ioq) && !elv_ioq_nr_dispatched(ioq)
 		    && !timer_pending(&efqd->idle_slice_timer)) {
 			/*
 			 * If queue has used up its slice, wait for the
-- 
1.5.4.rc3

