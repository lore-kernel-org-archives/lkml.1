Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbZKXOhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbZKXOhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933016AbZKXOhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:37:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007AbZKXOhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:37:03 -0500
Date: Tue, 24 Nov 2009 09:37:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/4] cfq-iosched: fix no-idle preemption logic
Message-ID: <20091124143705.GB9595@redhat.com>
References: <200911241449.02473.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911241449.02473.czoccolo@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 02:49:02PM +0100, Corrado Zoccolo wrote:
> An incoming no-idle queue should preempt the active no-idle queue
> only if the active queue is idling due to service tree empty.
> Previous code was buggy in two ways:
> * it relied on service_tree field to be set on the active queue, while
>   it is not set when the code is idling for a new request
> * it didn't check for the service tree empty condition, so could lead to
>   LIFO behaviour if multiple queues with depth > 1 were preempting each
>   other on an non-NCQ device.
> 
> Reported-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 6925ab9..2a304f4 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2401,8 +2401,9 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>  	if (cfq_class_idle(cfqq))
>  		return true;
>  
> -	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD
> -	    && new_cfqq->service_tree == cfqq->service_tree)
> +	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
> +	    cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD &&
> +	    new_cfqq->service_tree->count == 1)
>  		return true;
>  

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
