Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZK3Hd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZK3Hd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 02:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZK3Hd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 02:33:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57266 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbZK3Hd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 02:33:56 -0500
Message-ID: <4B137470.3000601@cn.fujitsu.com>
Date: Mon, 30 Nov 2009 15:29:52 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
Subject: Re: [RFC] Block IO Controller V3
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Hi Jens,
> 
> This is V3 of the Block IO controller patches on top of "for-2.6.33" branch
> of block tree.
> 
...

Hi Vivek,

If an idle task is running group A and a normal task is running in group B, these
two group have the same weight, I think IO Controller should isolate group A and
group B, these two group should get 50% of the IO bw for each, right? But for this case,
we don't see any isolation, instead, group B monopolizes almost all IO BW. I guess
the major reason is idle cfqq is only allowed to dispatch one request and get expired.
I think in order to get better isolation, we shouldn't expire the idle cfqq immediately
if this idle queue is the only one this its group. The following patch enable idling
for idle queue and prevent expiring it immediately after dispatch one request if it's 
the only one in group. This patch is working for V3, hasn't tested on V4 yet.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/cfq-iosched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6f9d019..3440837 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -900,7 +900,7 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	struct cfq_rb_root *service_tree = cfqq->service_tree;
 
 	/* We never do for idle class queues. */
-	if (prio == IDLE_WORKLOAD)
+	if (prio == IDLE_WORKLOAD && cfqq->cfqg->nr_cfqq > 1)
 		return false;
 
 	/* We do for queues that were marked with idle window flag. */
@@ -2336,7 +2336,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 	 * expire an async queue immediately if it has used up its slice. idle
 	 * queue always expire after 1 dispatch round.
 	 */
-	if (cfqd->busy_queues > 1 && ((!cfq_cfqq_sync(cfqq) &&
+	if (cfqq->cfqg->nr_cfqq  > 1 && ((!cfq_cfqq_sync(cfqq) &&
 	    cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
 	    cfq_class_idle(cfqq))) {
 		cfqq->slice_end = jiffies + 1;
-- 
1.5.4.rc3

-- 
Regards
Gui Jianfeng

