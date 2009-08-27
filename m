Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbZH0JOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbZH0JOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZH0JOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:14:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39047 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbZH0JOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:14:08 -0400
Date: Thu, 27 Aug 2009 11:14:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: tj@kernel.org, alan@lxorguk.ukuu.org.uk, jeff@garzik.org,
       dhowells@redhat.com
Subject: Re: [PATCH 2/3] slow-work: add support for cancellation of slow
	work
Message-ID: <20090827091409.GF12579@kernel.dk>
References: <1251364122-9592-1-git-send-email-jens.axboe@oracle.com> <1251364122-9592-2-git-send-email-jens.axboe@oracle.com> <1251364122-9592-3-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251364122-9592-3-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27 2009, Jens Axboe wrote:
> @@ -194,12 +194,21 @@ static bool slow_work_execute(void)
>  	if (!test_and_clear_bit(SLOW_WORK_PENDING, &work->flags))
>  		BUG();
>  
> -	work->ops->execute(work);
> +	/*
> +	 * Don't execute if the work was cancelled after being added
> +	 */
> +	if (!test_bit(SLOW_WORK_CANCEL, &work->flags))
> +		work->ops->execute(work);
>  
>  	if (very_slow)
>  		atomic_dec(&vslow_work_executing_count);
>  	clear_bit_unlock(SLOW_WORK_EXECUTING, &work->flags);
>  
> +	/*
> +	 * Wake anyone waiting for this work to be done
> +	 */
> +	wake_up_bit(&work->flags, SLOW_WORK_EXECUTING);
> +
>  	/* if someone tried to enqueue the item whilst we were executing it,
>  	 * then it'll be left unenqueued to avoid multiple threads trying to
>  	 * execute it simultaneously

> +void cancel_slow_work(struct slow_work *work)
> +{
> +	set_bit(SLOW_WORK_CANCEL, &work->flags);
> +	wait_on_bit(&work->flags, SLOW_WORK_EXECUTING, slow_work_wait,
> +				TASK_UNINTERRUPTIBLE);
> +	clear_bit(SLOW_WORK_CANCEL, &work->flags);
> +}
> +EXPORT_SYMBOL(cancel_slow_work);

We want to use SLOW_WORK_PENDING for this logic, not SLOW_WORK_EXECUTING.
I'll update it.

-- 
Jens Axboe

