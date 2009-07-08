Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbZGHD2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbZGHD2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 23:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757574AbZGHD2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 23:28:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49972 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757059AbZGHD2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 23:28:02 -0400
Message-ID: <4A54121D.5090008@cn.fujitsu.com>
Date: Wed, 08 Jul 2009 11:27:25 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [PATCH 21/25] io-controller: Per cgroup request descriptor support
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-22-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1246564917-19603-22-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
>  }
> +#ifdef CONFIG_GROUP_IOSCHED
> +static ssize_t queue_group_requests_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(q->nr_group_requests, (page));
> +}
> +
> +static ssize_t
> +queue_group_requests_store(struct request_queue *q, const char *page,
> +					size_t count)
> +{
> +	unsigned long nr;
> +	int ret = queue_var_store(&nr, page, count);
> +	if (nr < BLKDEV_MIN_RQ)
> +		nr = BLKDEV_MIN_RQ;
> +
> +	spin_lock_irq(q->queue_lock);
> +	q->nr_group_requests = nr;
> +	spin_unlock_irq(q->queue_lock);
> +	return ret;
> +}
> +#endif

Hi Vivek,

Do we need to update the congestion thresholds for allocated io groups?

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-sysfs.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 577ed42..92b9f25 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -83,17 +83,32 @@ static ssize_t queue_group_requests_show(struct request_queue *q, char *page)
 	return queue_var_show(q->nr_group_requests, (page));
 }
 
+extern void elv_io_group_congestion_threshold(struct request_queue *q,
+					      struct io_group *iog);
+
 static ssize_t
 queue_group_requests_store(struct request_queue *q, const char *page,
 					size_t count)
 {
+	struct hlist_node *n;
+	struct io_group *iog;
+	struct elv_fq_data *efqd;
 	unsigned long nr;
 	int ret = queue_var_store(&nr, page, count);
+
 	if (nr < BLKDEV_MIN_RQ)
 		nr = BLKDEV_MIN_RQ;
 
 	spin_lock_irq(q->queue_lock);
+
 	q->nr_group_requests = nr;
+
+	efqd = &q->elevator->efqd;
+
+	hlist_for_each_entry(iog, n, &efqd->group_list, elv_data_node) {
+		elv_io_group_congestion_threshold(q, iog);
+	}
+
 	spin_unlock_irq(q->queue_lock);
 	return ret;
 }
-- 
1.5.4.rc3 

