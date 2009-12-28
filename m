Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZL1Iw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZL1Iw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZL1IwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:52:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:8000 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbZL1IwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:52:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,461,1257148800"; 
   d="scan'208";a="582499394"
Date: Mon, 28 Dec 2009 16:52:21 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [PATCH]cfq-iosched: split seeky coop queues after one slice
Message-ID: <20091228085221.GA3769@sli10-desk.sh.intel.com>
References: <20091224005506.GA7879@sli10-desk.sh.intel.com>
 <4e5e476b0912250216n2b4aceacyf22a0e73425efd3a@mail.gmail.com>
 <20091228031951.GA15242@sli10-desk.sh.intel.com>
 <4e5e476b0912280040ue2eb50ftd3945f28270899c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0912280040ue2eb50ftd3945f28270899c0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 04:40:30PM +0800, Corrado Zoccolo wrote:
> On Mon, Dec 28, 2009 at 4:19 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > On Fri, Dec 25, 2009 at 06:16:27PM +0800, Corrado Zoccolo wrote:
> >> Hi Shaohua,
> >> On Thu, Dec 24, 2009 at 1:55 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> >> > df5fe3e8e13883f58dc97489076bbcc150789a21
> >> > b3b6d0408c953524f979468562e7e210d8634150
> >> > The coop merge is too aggressive. For example, if two tasks are reading two
> >> > files where the two files have some adjecent blocks, cfq will immediately
> >> > merge them. cfq_rq_close() also has trouble, sometimes the seek_mean is very
> >> > big. I did a test to make cfq_rq_close() always checks the distence according
> >> > to CIC_SEEK_THR, but still saw a lot of wrong merge. (BTW, why we take a long
> >> > distence far away request as close. Taking them close doesn't improve any thoughtput
> >> > to me. Maybe we should always use CIC_SEEK_THR as close criteria).
> >> Yes, when deciding if two queues are going to be merged, we should use
> >> the constant CIC_SEEK_THR.
> >> > So sounds we need make split more aggressive. But the split is too lazay,
> >> > which requires to wait 1s. Time based check isn't reliable as queue might not
> >> > run at given time, so uses a small time isn't ok.
> >> 1s is too much, but I wouldn't abandon a time based approach. To fix
> >> the problem of queue not being run, you can consider a slice. If at
> >> the end of the slice, the queue is seeky, you split it.
> >
> > Currently we split seeky coop queues after 1s, which is too big. Below patch
> > marks seeky coop queue split_coop flag after one slice. After that, if new
> > requests come in, the queues will be splitted. Patch is suggested by Corrado.
> >
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> You can also remove the no longer used define:
> #define CFQQ_COOP_TOUT          (HZ)
> 
> Reviewed-by: Corrado Zoccolo <czoccolo@gmail.com>
forgot about that macro, updated patch.


Currently we split seeky coop queues after 1s, which is too big. Below patch
marks seeky coop queue split_coop flag after one slice. After that, if new
requests come in, the queues will be splitted. Patch is suggested by Corrado.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Corrado Zoccolo <czoccolo@gmail.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e2f8046..348618f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -42,16 +42,13 @@ static const int cfq_hist_divisor = 4;
  */
 #define CFQ_MIN_TT		(2)
 
-/*
- * Allow merged cfqqs to perform this amount of seeky I/O before
- * deciding to break the queues up again.
- */
-#define CFQQ_COOP_TOUT		(HZ)
-
 #define CFQ_SLICE_SCALE		(5)
 #define CFQ_HW_QUEUE_MIN	(5)
 #define CFQ_SERVICE_SHIFT       12
 
+#define CFQQ_SEEK_THR		8 * 1024
+#define CFQQ_SEEKY(cfqq)	((cfqq)->seek_mean > CFQQ_SEEK_THR)
+
 #define RQ_CIC(rq)		\
 	((struct cfq_io_context *) (rq)->elevator_private)
 #define RQ_CFQQ(rq)		(struct cfq_queue *) ((rq)->elevator_private2)
@@ -137,7 +134,6 @@ struct cfq_queue {
 	u64 seek_total;
 	sector_t seek_mean;
 	sector_t last_request_pos;
-	unsigned long seeky_start;
 
 	pid_t pid;
 
@@ -317,6 +313,7 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
 	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
+	CFQ_CFQQ_FLAG_split_coop,	/* shared cfqq will be splitted */
 	CFQ_CFQQ_FLAG_deep,		/* sync cfqq experienced large depth */
 	CFQ_CFQQ_FLAG_wait_busy,	/* Waiting for next request */
 };
@@ -345,6 +342,7 @@ CFQ_CFQQ_FNS(prio_changed);
 CFQ_CFQQ_FNS(slice_new);
 CFQ_CFQQ_FNS(sync);
 CFQ_CFQQ_FNS(coop);
+CFQ_CFQQ_FNS(split_coop);
 CFQ_CFQQ_FNS(deep);
 CFQ_CFQQ_FNS(wait_busy);
 #undef CFQ_CFQQ_FNS
@@ -1574,6 +1572,15 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfq_clear_cfqq_wait_busy(cfqq);
 
 	/*
+	 * If this cfqq is shared between multiple processes, check to
+	 * make sure that those processes are still issuing I/Os within
+	 * the mean seek distance.  If not, it may be time to break the
+	 * queues apart again.
+	 */
+	if (cfq_cfqq_coop(cfqq) && CFQQ_SEEKY(cfqq))
+		cfq_mark_cfqq_split_coop(cfqq);
+
+	/*
 	 * store what was left of this slice, if the queue idled/timed out
 	 */
 	if (timed_out && !cfq_cfqq_slice_new(cfqq)) {
@@ -1671,9 +1678,6 @@ static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
 		return cfqd->last_position - blk_rq_pos(rq);
 }
 
-#define CFQQ_SEEK_THR		8 * 1024
-#define CFQQ_SEEKY(cfqq)	((cfqq)->seek_mean > CFQQ_SEEK_THR)
-
 static inline int cfq_rq_close(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			       struct request *rq)
 {
@@ -3027,19 +3031,6 @@ cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	total = cfqq->seek_total + (cfqq->seek_samples/2);
 	do_div(total, cfqq->seek_samples);
 	cfqq->seek_mean = (sector_t)total;
-
-	/*
-	 * If this cfqq is shared between multiple processes, check to
-	 * make sure that those processes are still issuing I/Os within
-	 * the mean seek distance.  If not, it may be time to break the
-	 * queues apart again.
-	 */
-	if (cfq_cfqq_coop(cfqq)) {
-		if (CFQQ_SEEKY(cfqq) && !cfqq->seeky_start)
-			cfqq->seeky_start = jiffies;
-		else if (!CFQQ_SEEKY(cfqq))
-			cfqq->seeky_start = 0;
-	}
 }
 
 /*
@@ -3474,14 +3465,6 @@ cfq_merge_cfqqs(struct cfq_data *cfqd, struct cfq_io_context *cic,
 	return cic_to_cfqq(cic, 1);
 }
 
-static int should_split_cfqq(struct cfq_queue *cfqq)
-{
-	if (cfqq->seeky_start &&
-	    time_after(jiffies, cfqq->seeky_start + CFQQ_COOP_TOUT))
-		return 1;
-	return 0;
-}
-
 /*
  * Returns NULL if a new cfqq should be allocated, or the old cfqq if this
  * was the last process referring to said cfqq.
@@ -3490,9 +3473,9 @@ static struct cfq_queue *
 split_cfqq(struct cfq_io_context *cic, struct cfq_queue *cfqq)
 {
 	if (cfqq_process_refs(cfqq) == 1) {
-		cfqq->seeky_start = 0;
 		cfqq->pid = current->pid;
 		cfq_clear_cfqq_coop(cfqq);
+		cfq_clear_cfqq_split_coop(cfqq);
 		return cfqq;
 	}
 
@@ -3531,7 +3514,7 @@ new_queue:
 		/*
 		 * If the queue was seeky for too long, break it apart.
 		 */
-		if (cfq_cfqq_coop(cfqq) && should_split_cfqq(cfqq)) {
+		if (cfq_cfqq_coop(cfqq) && cfq_cfqq_split_coop(cfqq)) {
 			cfq_log_cfqq(cfqd, cfqq, "breaking apart cfqq");
 			cfqq = split_cfqq(cic, cfqq);
 			if (!cfqq)
