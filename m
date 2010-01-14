Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971Ab0ANCvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab0ANCvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823Ab0ANCvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:51:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60647 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab0ANCvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:51:46 -0500
Message-ID: <4B4E8590.8060403@cn.fujitsu.com>
Date: Thu, 14 Jan 2010 10:46:40 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com,
       vgoyal@redhat.com, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async requests
 pending
References: <20100113074442.GA10492@sli10-desk.sh.intel.com>
In-Reply-To: <20100113074442.GA10492@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
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

It seems only sync queue could open the idle window, so i don't think we really need this.

Thanks,
Gui

