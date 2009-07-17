Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbZGQAT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbZGQAT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933739AbZGQAT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:19:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54359 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933232AbZGQAT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:19:27 -0400
Message-ID: <4A5FC2CA.1040609@ds.jp.nec.com>
Date: Thu, 16 Jul 2009 20:16:10 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH 22/25] io-controller: Per io group bdi congestion interface
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <1246564917-19603-23-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1246564917-19603-23-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Vivek Goyal wrote, on 07/02/2009 04:01 PM:
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2035c20..79fe6a9 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -90,6 +90,27 @@ void blk_queue_congestion_threshold(struct request_queue *q)
>   	q->nr_congestion_off = nr;
>   }
> 
> +#ifdef CONFIG_GROUP_IOSCHED
> +int blk_queue_io_group_congested(struct backing_dev_info *bdi, int bdi_bits,
> +					struct page *page)
> +{
> +	int ret = 0;
> +	struct request_queue *q = bdi->unplug_io_data;
> +
> +	if (!q&&  !q->elevator)
> +		return bdi_congested(bdi, bdi_bits);

It causes NULL pointer dereference for brd etc.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 block/blk-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 79fe6a9..39fab66 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -97,7 +97,7 @@ int blk_queue_io_group_congested(struct backing_dev_info *bdi, int bdi_bits,
 	int ret = 0;
 	struct request_queue *q = bdi->unplug_io_data;
 
-	if (!q && !q->elevator)
+	if (!q || !q->elevator)
 		return bdi_congested(bdi, bdi_bits);
 
 	/* Do we need to hold queue lock? */
-- 
1.6.2.5


-- 
IKEDA, Munehiro
  NEC Corporation of America
    m-ikeda@ds.jp.nec.com

