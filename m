Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbZHDCFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbZHDCFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 22:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbZHDCFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 22:05:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45786 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbZHDCFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 22:05:40 -0400
Message-ID: <4A7796D2.4030104@ds.jp.nec.com>
Date: Mon, 03 Aug 2009 22:02:58 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Subject: Re: [PATCH] io-controller: implement per group request allocation
 limitation
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com> <4A569FC5.7090801@cn.fujitsu.com>
In-Reply-To: <4A569FC5.7090801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gui Jianfeng wrote, on 07/09/2009 09:56 PM:
> Hi Vivek,
>
> This patch exports a cgroup based per group request limits interface.
> and removes the global one. Now we can use this interface to perform
> different request allocation limitation for different groups.
>
> Signed-off-by: Gui Jianfeng<guijianfeng@cn.fujitsu.com>
> ---
(snip)

Hi Jianfeng,

If this helps.

If calling elv_io_group_congestion_threshold() before
setting iog->iocg_id, iocg->nr_group_requests cannot be
referred.  As a result of it, iog->nr_congestion_on is
always misculculated as 0.
This patch moves the calling of
elv_io_group_congestion_threshold() after setting
iog->iocg_id.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
  block/elevator-fq.c |    3 ++-
  1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/elevator-fq.c b/block/elevator-fq.c
index 7c83d1e..3368a7f 100644
--- a/block/elevator-fq.c
+++ b/block/elevator-fq.c
@@ -2195,7 +2195,6 @@ static struct io_group *io_alloc_root_group(struct request_queue *q,
  		iog->sched_data.service_tree[i] = IO_SERVICE_TREE_INIT;
  
  	blk_init_request_list(&iog->rl);
-	elv_io_group_congestion_threshold(q, iog);
  
  	iocg = &io_root_cgroup;
  	spin_lock_irq(&iocg->lock);
@@ -2204,6 +2203,8 @@ static struct io_group *io_alloc_root_group(struct request_queue *q,
  	iog->iocg_id = css_id(&iocg->css);
  	spin_unlock_irq(&iocg->lock);
  
+	elv_io_group_congestion_threshold(q, iog);
+
  #ifdef CONFIG_DEBUG_GROUP_IOSCHED
  	io_group_path(iog, iog->path, sizeof(iog->path));
  #endif
-- 
1.6.2.5




-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com

