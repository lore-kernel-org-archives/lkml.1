Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669Ab0AMLKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0AMLKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556Ab0AMLKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:10:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab0AMLKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:10:15 -0500
Date: Wed, 13 Jan 2010 06:10:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com,
       guijianfeng@cn.fujitsu.com, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async requests
	pending
Message-ID: <20100113111005.GA3087@redhat.com>
References: <20100113074442.GA10492@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113074442.GA10492@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 03:44:42PM +0800, Shaohua Li wrote:
> My SSD speed of direct write is about 80m/s, while I test page writeback,
> the speed can only go to 68m/s. Below patch fixes this.
> It appears we missused cfq_should_idle in cfq_may_dispatch. cfq_should_idle
> means a queue should idle because it's seekless sync queue or it's the last queue,
> which is to maintain service tree time slice. So it doesn't mean the
> last queue is always a sync queue. If the last queue is asyn queue,
> we definitely shouldn't stop dispatch requests because of pending async
> requests.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 918c7fd..8198079 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2222,7 +2222,8 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  	/*
>  	 * Drain async requests before we start sync IO
>  	 */
> -	if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
> +	if (cfq_cfqq_sync(cfqq) && cfq_should_idle(cfqd, cfqq)
> +		&& cfqd->rq_in_driver[BLK_RW_ASYNC])
>  		return false;

So are we driving queue depth as 1 when pure buffered writes are going on?
Because in that case service_tree->count=1 and cfq_should_idle() will
return 1 and looks like we will not dispatch next write till previous
write is over?

A general question. Why do we need to drain async requests before we start
sync IO? How does that help?

A related question, even if we have to do that, why do we check for
cfq_should_idle()? Why can't we just do following.

	if (cfq_cfqq_sync(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])

Thanks
Vivek
