Return-Path: <linux-kernel-owner+w=401wt.eu-S934299AbZJGRvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299AbZJGRvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759581AbZJGRvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:51:49 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33699 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757582AbZJGRvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:51:49 -0400
Date: Wed, 7 Oct 2009 19:51:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: avoid slice overrun when idling
Message-ID: <20091007175112.GI8703@kernel.dk>
References: <200910071059.01146.czoccolo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910071059.01146.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07 2009, Corrado Zoccolo wrote:
> Idle window for a queue is reduced when the queue is about to finish
> its slice.
> 
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 4ab33d8..55bb8ca 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1105,8 +1105,10 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>  	 * we don't want to idle for seeks, but we do want to allow
>  	 * fair distribution of slice time for a process doing back-to-back
>  	 * seeks. so allow a little bit of time for him to submit a new rq
> +	 * but avoid overrunning its timeslice
>  	 */
> -	sl = cfqd->cfq_slice_idle;
> +	sl = min_t(unsigned long, cfqd->cfq_slice_idle,
> +		cfqq->slice_end - jiffies);
>  	if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
>  		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));

This was actually done this way on purpose, since shorter idling more
often don't suceed. So the logic was rather overrun the slice slightly
than wait shortly and just miss the incoming IO.

Of course this will overrun the slice even more, which the above will
also do since it wants to do IO within that time frame too.

So I think we should either leave it as-is, OR simply not arm the idle
timer when it has less than slice_idle time left and immediately select
a new queue.

-- 
Jens Axboe

