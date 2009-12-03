Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbZLCL5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbZLCL5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZLCL5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:57:03 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44703 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbZLCL5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:57:01 -0500
Date: Thu, 3 Dec 2009 12:57:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH]cfq-iosched: make nonrot check logic consistent
Message-ID: <20091203115707.GL8742@kernel.dk>
References: <20091203035135.GA13165@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203035135.GA13165@sli10-desk.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03 2009, Shaohua Li wrote:
> Send again, last post seems lost.
> 
> cfq_arm_slice_timer() has logic to disable idle window for SSD device. The same
> thing should be done at cfq_select_queue() too, otherwise we will still see
> idle window. This makes the nonrot check logic consistent in cfq.
> Tests in a intel SSD with low_latency knob close, below patch can triple disk
> thoughput for muti-thread sequential read.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  block/cfq-iosched.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux/block/cfq-iosched.c
> ===================================================================
> --- linux.orig/block/cfq-iosched.c	2009-11-11 13:44:00.000000000 +0800
> +++ linux/block/cfq-iosched.c	2009-11-11 13:45:33.000000000 +0800
> @@ -1215,7 +1215,8 @@ static struct cfq_queue *cfq_select_queu
>  	 * conditions to happen (or time out) before selecting a new queue.
>  	 */
>  	if (timer_pending(&cfqd->idle_slice_timer) ||
> -	    (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
> +	    (cfqq->dispatched && cfq_cfqq_idle_window(cfqq)
> +	    && !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))) {
>  		cfqq = NULL;
>  		goto keep_queue;
>  	}

Thanks, applied to 2.6.33 queue.

-- 
Jens Axboe

