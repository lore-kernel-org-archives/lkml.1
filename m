Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZLCXx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZLCXx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbZLCXx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:53:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbZLCXx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:53:56 -0500
Date: Thu, 3 Dec 2009 18:51:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: Block IO Controller V4
Message-ID: <20091203235153.GG2735@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4B15C828.4080407@cn.fujitsu.com> <20091202142508.GA31715@redhat.com> <4B1779CE.1050801@cn.fujitsu.com> <20091203143641.GA3887@redhat.com> <20091203181003.GD2735@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203181003.GD2735@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 01:10:03PM -0500, Vivek Goyal wrote:

[..]
> Hi Gui,
> 
> Can you please try following patch and see if it helps you. If not, then
> we need to figure out why we choose to not idle and delete the group from
> service tree.
> 

Hi Gui,

Please try this version of the patch instead of previous one. During more
testing I saw some additional deletions where we should have waited and
the reason being that we were hitting boundary condition. At the request
completion time slice has not expired but after 4-5 ns, select_queue hits
and jiffy has incremented by then and slice expires.

ttime_mean, is not covering this condition because this workload is so
sequential that ttime_mean=0.

So I am checking for new condition where if we are into last ms of slice,
mark the queue wait_busy.

Thanks
Vivek

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

Index: linux11/block/cfq-iosched.c
===================================================================
--- linux11.orig/block/cfq-iosched.c	2009-12-03 15:10:53.000000000 -0500
+++ linux11/block/cfq-iosched.c	2009-12-03 18:37:35.000000000 -0500
@@ -3248,6 +3248,29 @@ static void cfq_update_hw_tag(struct cfq
 		cfqd->hw_tag = 0;
 }
 
+static inline bool
+cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	struct cfq_io_context *cic = cfqd->active_cic;
+
+	/* If there are other queues in the group, don't wait */
+	if (cfqq->cfqg->nr_cfqq > 1)
+		return false;
+
+	if (cfq_slice_used(cfqq))
+		return true;
+
+	if (cfqq->slice_end - jiffies == 1)
+		return true;
+
+	/* if slice left is less than think time, wait busy */
+	if (cic && sample_valid(cic->ttime_samples)
+	    && (cfqq->slice_end - jiffies < cic->ttime_mean))
+		return true;
+
+	return false;
+}
+
 static void cfq_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
@@ -3286,11 +3309,10 @@ static void cfq_completed_request(struct
 		}
 
 		/*
-		 * If this queue consumed its slice and this is last queue
-		 * in the group, wait for next request before we expire
-		 * the queue
+		 * Should we wait for next request to come in before we expire
+		 * the queue.
 		 */
-		if (cfq_slice_used(cfqq) && cfqq->cfqg->nr_cfqq == 1) {
+		if (cfq_should_wait_busy(cfqd, cfqq)) {
 			cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
 			cfq_mark_cfqq_wait_busy(cfqq);
 		}
