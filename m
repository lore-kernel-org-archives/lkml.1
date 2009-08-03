Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZHCCPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZHCCPb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 22:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZHCCPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 22:15:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54664 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbZHCCP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 22:15:29 -0400
Message-ID: <4A7647DA.5050607@cn.fujitsu.com>
Date: Mon, 03 Aug 2009 10:13:46 +0800
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
Subject: Re: [PATCH 20/25] io-controller: map async requests to appropriate
 cgroup
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-21-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1246564917-19603-21-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
...
> +
> +struct io_group *io_get_io_group_bio(struct request_queue *q, struct bio *bio,
> +					int create)
> +{
> +	struct page *page = NULL;
> +
> +	/*
> +	 * Determine the group from task context. Even calls from
> +	 * blk_get_request() which don't have any bio info will be mapped
> +	 * to the task's group
> +	 */
> +	if (!bio)
> +		goto sync;
> +
> +	if (bio_barrier(bio)) {
> +		/*
> +		 * Map barrier requests to root group. May be more special
> +		 * bio cases should come here
> +		 */
> +		return q->elevator->efqd.root_group;
> +	}
> +
> +	/* Map the sync bio to the right group using task context */
> +	if (elv_bio_sync(bio))
> +		goto sync;
> +
> +#ifdef CONFIG_TRACK_ASYNC_CONTEXT
> +	/* Determine the group from info stored in page */
> +	page = bio_iovec_idx(bio, 0)->bv_page;
> +	return io_get_io_group(q, page, create);
> +#endif
> +
> +sync:
> +	return io_get_io_group(q, NULL, create);

Fix build warning.

block/elevator-fq.c: In function ‘io_get_io_group_bio’:
block/elevator-fq.c:2075: warning: unused variable ‘page’

---
diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 66b10eb..d304f79 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2102,7 +2102,7 @@ struct io_group *io_get_io_group_bio(struct request_queue *q, struct bio *bio,
 #endif
 
 sync:
-	return io_get_io_group(q, NULL, create);
+	return io_get_io_group(q, page, create);
 }
 EXPORT_SYMBOL(io_get_io_group_bio);


> +}
> +EXPORT_SYMBOL(io_get_io_group_bio);
> +


-- 
Regards
Gui Jianfeng

