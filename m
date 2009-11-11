Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZKKAvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZKKAvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZKKAvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:51:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57046 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755303AbZKKAvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:51:54 -0500
Message-ID: <4AFA09C9.9050001@cn.fujitsu.com>
Date: Wed, 11 Nov 2009 08:48:09 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time stamps
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1257291837-6246-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
>  
> @@ -1245,10 +1429,10 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
>  	struct cfq_queue *cfqq;
>  	int dispatched = 0;
>  
> -	while ((cfqq = cfq_rb_first(&cfqd->service_tree)) != NULL)
> +	while ((cfqq = cfq_get_next_queue(cfqd)) != NULL)
>  		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
>  
> -	cfq_slice_expired(cfqd, 0);
> +	cfq_slice_expired(cfqd);
>  
>  	BUG_ON(cfqd->busy_queues);
>  
> @@ -1391,7 +1575,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
>  	    cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
>  	    cfq_class_idle(cfqq))) {
>  		cfqq->slice_end = jiffies + 1;
> -		cfq_slice_expired(cfqd, 0);
> +		cfq_slice_expired(cfqd);

Hi Vivek,

I think here you should make sure that when updating cfqq->slice_end, cfqq->slice_end doesn't 
equal to 0. Because if cfqq->slice_end == 0, cfq_slice_expired() just charge for 1 jiffy, but
if cfqq->slice_end is updated when it equals to 0(first request still in the air), at that time
cfqq->slice_start == 0, and slice_used is charged as "jiffies - cfqq->slice_start". Following
patch fixes this bug.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f23d713..12afc14 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1999,7 +1999,8 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 	if (cfqd->busy_queues > 1 && ((!cfq_cfqq_sync(cfqq) &&
 	    cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
 	    cfq_class_idle(cfqq))) {
-		cfqq->slice_end = jiffies + 1;
+		if (cfqq->slice_end)
+			cfqq->slice_end = jiffies + 1;
 		cfq_slice_expired(cfqd);
 	}
 
-- 
1.5.4.rc3

