Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517Ab0AKPPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0AKPPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 10:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499Ab0AKPPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 10:15:41 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51971 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab0AKPPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 10:15:40 -0500
Date: Mon, 11 Jan 2010 16:15:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Divyesh Shah <dpshah@google.com>
Cc: czoccolo@gmail.com, linux-kernel@vger.kernel.org, nauman@google.com,
       mikew@google.com, ctalbott@google.com
Subject: Re: [PATCH] cfq-iosched: Respect ioprio_class when preempting
Message-ID: <20100111151539.GP4489@kernel.dk>
References: <20100107025413.27610.48801.stgit@austin.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107025413.27610.48801.stgit@austin.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06 2010, Divyesh Shah wrote:
> In cfq_should_preempt(), we currently allow some cases where a non-RT request
> can preempt an ongoing RT cfqq timeslice. This should not happen.
> Examples include:
> 
> o A sync_noidle wl type non-RT request pre-empting a sync_noidle wl type cfqq
>   on which we are idling.
> o Once we have per-cgroup async queues, a non-RT sync request pre-empting a RT
>   async cfqq.
> 
> Signed-off-by: Divyesh Shah<dpshah@google.com>
> ---
> 
>  block/cfq-iosched.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 7d6cef9..e9e6610 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3104,6 +3104,12 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>  		return true;
>  
>  	/*
> +	 * Don't allow a non-RT request to preempt an ongoing RT cfqq timeslice.
> +	 */
> +	if (cfq_class_rt(cfqq) && !cfq_class_rt(new_cfqq))
> +		return false;

It would be nice to just be able to do

        if (new_cfqq->ioprio_class > cfqq->ioprio_class)
                return false;

but that doesn't quite work given IOPRIO_CLASS_NONE < _RT. So I think
your patch is fine, I've added it. Thanks.

-- 
Jens Axboe

