Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZLCSL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZLCSL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZLCSL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:11:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbZLCSL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:11:58 -0500
Date: Thu, 3 Dec 2009 13:10:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: Re: Block IO Controller V4
Message-ID: <20091203181003.GD2735@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com> <4B15C828.4080407@cn.fujitsu.com> <20091202142508.GA31715@redhat.com> <4B1779CE.1050801@cn.fujitsu.com> <20091203143641.GA3887@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203143641.GA3887@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 09:36:41AM -0500, Vivek Goyal wrote:
> On Thu, Dec 03, 2009 at 04:41:50PM +0800, Gui Jianfeng wrote:
> > Vivek Goyal wrote:
> > > On Wed, Dec 02, 2009 at 09:51:36AM +0800, Gui Jianfeng wrote:
> > >> Vivek Goyal wrote:
> > >>> Hi Jens,
> > >>>
> > >>> This is V4 of the Block IO controller patches on top of "for-2.6.33" branch
> > >>> of block tree.
> > >>>
> > >>> A consolidated patch can be found here:
> > >>>
> > >>> http://people.redhat.com/vgoyal/io-controller/blkio-controller/blkio-controller-v4.patch
> > >>>
> > >> Hi Vivek,
> > >>
> > >> It seems this version doesn't work very well for "direct(O_DIRECT) sequence read" mode.
> > >> For example, you can create group A and group B, then assign weight 100 to group A and
> > >> weight 400 to group B, and you run "direct sequence read" workload in group A and B 
> > >> simultaneously. Ideally, we should see 1:4 disk time differentiation for group A and B. 
> > >> But actually, I see almost 1:2 disk time differentiation for group A and B. I'm looking
> > >> into this issue.
> > >> BTW, V3 works well for this case.
> > > 
> > > Hi Gui,
> > > 
> > > In my testing of 8 fio jobs in 8 cgroups, direct sequential reads seems to
> > > be working fine.
> > > 
> > > http://lkml.org/lkml/2009/12/1/367
> > > 
> > > I suspect that in some case we choose not to idle on the group and it gets
> > > deleted from service tree hence we loose share. Can you have a look at
> > > blkio.dequeue files. If there are excessive deletions, that will signify
> > > that we are loosing share because we chose not to idle.
> > > 
> > > If yes, please also run blktrace to see in what cases we chose not to
> > > idle.
> > > 
> > > In V3, I had a stronger check to idle on the group if it is empty using
> > > wait_busy() function. In V4 I have removed that and trying to wait busy
> > > on a queue by extending its slice if it has consumed its allocated slice.
> > 
> > Hi Vivek,
> > 
> > I ckecked the blktrace output, it seems that io group was deleted all the time,
> > because we don't have group idle any more. I pulled the wait_busy code back to
> > V4, and retest it, problem seems disappeared.
> > 
> > So i suggest that we need to retain the wait_busy code.
> 
> Hi Gui,
> 
> We need to figure out why the existing code is not working on your system.
> In V4, I introduced the functionality to extend the slice by slice_idle
> so that we will arm slice idle timer and wait for new request to come in
> and then expire the queue. Following is the code to extend the slice.
> 
>                 /*
>                  * If this queue consumed its slice and this is last queue
>                  * in the group, wait for next request before we expire
>                  * the queue
>                  */
>                 if (cfq_slice_used(cfqq) && cfqq->cfqg->nr_cfqq == 1) {
>                         cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
>                         cfq_mark_cfqq_wait_busy(cfqq);
>                 }
> 
> One loop hole I see is that, I extend the slice only if current slice has
> been used. If if we on the boundary and slice has not been used yet, then
> I will not extend the slice. We also might not arm the timer thinking that
> remaining slice is less than think time of process and that can lead to
> expiry of queue. To rule out this possibility, can you remove following
> code in arm_slice_timer() and try it again.
> 
>         /*
>          * If our average think time is larger than the remaining time
>          * slice, then don't idle. This avoids overrunning the allotted
>          * time slice.
>          */
>         if (sample_valid(cic->ttime_samples) &&
>             (cfqq->slice_end - jiffies < cic->ttime_mean))
>                 return;
> 
> The other possiblity is that at the request completion time slice has not
> expired hence we don't extend the slice and arm the timer. But then
> select_queue() hits and by that time slice has expired and we expire the
> queue. I thought this will not happen very frequently.
> 
> Can you figure out what is happening on your system. Why we are not doing
> wait busy on the queue/group (new queue wait_busy and wait_busy_done
> flags) and instead expiring the queue and hence group.
> 
> You can send your blktrace logs to me also. I can also try figuring out
> what is happening.

Hi Gui,

Can you please try following patch and see if it helps you. If not, then
we need to figure out why we choose to not idle and delete the group from
service tree.

Thanks
Vivek


Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

Index: linux11/block/cfq-iosched.c
===================================================================
--- linux11.orig/block/cfq-iosched.c	2009-12-03 11:54:50.000000000 -0500
+++ linux11/block/cfq-iosched.c	2009-12-03 12:39:26.000000000 -0500
@@ -3248,6 +3248,26 @@ static void cfq_update_hw_tag(struct cfq
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
@@ -3286,11 +3306,10 @@ static void cfq_completed_request(struct
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
