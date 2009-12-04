Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZLDIVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZLDIVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZLDIVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:21:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:6177 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbZLDIVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:21:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,339,1257148800"; 
   d="scan'208";a="752765985"
Date: Fri, 4 Dec 2009 16:21:20 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH]cfq-iosched: make nonrot check logic consistent
Message-ID: <20091204082120.GA20557@sli10-desk.sh.intel.com>
References: <20091203035135.GA13165@sli10-desk.sh.intel.com>
 <20091203115707.GL8742@kernel.dk>
 <20091203120021.GN8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203120021.GN8742@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 08:00:21PM +0800, Jens Axboe wrote:
> On Thu, Dec 03 2009, Jens Axboe wrote:
> > On Thu, Dec 03 2009, Shaohua Li wrote:
> > > Send again, last post seems lost.
> > > 
> > > cfq_arm_slice_timer() has logic to disable idle window for SSD device. The same
> > > thing should be done at cfq_select_queue() too, otherwise we will still see
> > > idle window. This makes the nonrot check logic consistent in cfq.
> > > Tests in a intel SSD with low_latency knob close, below patch can triple disk
> > > thoughput for muti-thread sequential read.
> > > 
> > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > ---
> > >  block/cfq-iosched.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > Index: linux/block/cfq-iosched.c
> > > ===================================================================
> > > --- linux.orig/block/cfq-iosched.c	2009-11-11 13:44:00.000000000 +0800
> > > +++ linux/block/cfq-iosched.c	2009-11-11 13:45:33.000000000 +0800
> > > @@ -1215,7 +1215,8 @@ static struct cfq_queue *cfq_select_queu
> > >  	 * conditions to happen (or time out) before selecting a new queue.
> > >  	 */
> > >  	if (timer_pending(&cfqd->idle_slice_timer) ||
> > > -	    (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
> > > +	    (cfqq->dispatched && cfq_cfqq_idle_window(cfqq)
> > > +	    && !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))) {
> > >  		cfqq = NULL;
> > >  		goto keep_queue;
> > >  	}
> > 
> > Thanks, applied to 2.6.33 queue.
> 
> On second check, we now hide that logic in cfq_should_idle() and as such
> your patch no longer applies. I suggest you re-test with -next or my
> for-2.6.33 branch, it has a big number of pending CFQ updates for
> 2.6.33.
-next has the same issue too. Below is updated patch.

cfq_arm_slice_timer() has logic to disable idle window for SSD device. The same
thing should be done at cfq_select_queue() too, otherwise we will still see
idle window. This makes the nonrot check logic consistent in cfq.
Tests in a intel SSD with low_latency knob close, below patch can triple disk
thoughput for muti-thread sequential read.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 08b057b..abc5206 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1795,7 +1795,8 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		return false;
 
 	/* We do for queues that were marked with idle window flag. */
-	if (cfq_cfqq_idle_window(cfqq))
+	if (cfq_cfqq_idle_window(cfqq) &&
+	   !(blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag))
 		return true;
 
 	/*
