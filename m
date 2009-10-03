Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZJCMsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZJCMsV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 08:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZJCMsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 08:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbZJCMsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 08:48:20 -0400
Date: Sat, 3 Oct 2009 08:40:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
Subject: Do not overload dispatch queue (Was: Re: IO scheduler based IO
	controller V10)
Message-ID: <20091003124049.GB12925@redhat.com>
References: <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk> <1254507215.8667.7.camel@marge.simson.net> <20091002181903.GN31616@kernel.dk> <1254548931.8299.18.camel@marge.simson.net> <1254549378.8299.21.camel@marge.simson.net> <20091003112915.GA12925@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091003112915.GA12925@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 07:29:15AM -0400, Vivek Goyal wrote:
> On Sat, Oct 03, 2009 at 07:56:18AM +0200, Mike Galbraith wrote:
> > On Sat, 2009-10-03 at 07:49 +0200, Mike Galbraith wrote:
> > > On Fri, 2009-10-02 at 20:19 +0200, Jens Axboe wrote:
> > > 
> > > > If you could do a cleaned up version of your overload patch based on
> > > > this:
> > > > 
> > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=1d2235152dc745c6d94bedb550fea84cffdbf768
> > > > 
> > > > then lets take it from there.
> > 
> 
> > Note to self: build the darn thing after last minute changes.
> > 
> > Block:  Delay overloading of CFQ queues to improve read latency.
> > 
> > Introduce a delay maximum dispatch timestamp, and stamp it when:
> >         1. we encounter a known seeky or possibly new sync IO queue.
> >         2. the current queue may go idle and we're draining async IO.
> >         3. we have sync IO in flight and are servicing an async queue.
> >         4  we are not the sole user of disk.
> > Disallow exceeding quantum if any of these events have occurred recently.
> > 
> 
> So it looks like primarily the issue seems to be that we done lot of
> dispatch from async queue and if some sync queue comes in now, it will
> experience latencies.
> 
> For a ongoing seeky sync queue issue will be solved up to some extent
> because previously we did not choose to idle for that queue now we will
> idle, hence async queue will not get a chance to overload the dispatch
> queue.
> 
> For the sync queues where we choose not to enable idle, we still will see
> the latencies. Instead of time stamping on all the above events, can we 
> just keep track of last sync request completed in the system and don't
> allow async queue to flood/overload the dispatch queue with-in certain 
> time limit of that last sync request completion. This just gives a buffer
> period to that sync queue to come back and submit more requests and
> still not suffer large latencies?
> 
> Thanks
> Vivek
> 

Hi Mike,

Following is a quick hack patch for the above idea. It is just compile and
boot tested. Can you please see if it helps in your scenario.

Thanks
Vivek


o Do not allow more than max_dispatch requests from an async queue, if some
  sync request has finished recently. This is in the hope that sync activity
  is still going on in the system and we might receive a sync request soon.
  Most likely from a sync queue which finished a request and we did not enable
  idling on it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux22/block/cfq-iosched.c
===================================================================
--- linux22.orig/block/cfq-iosched.c	2009-10-03 08:20:26.000000000 -0400
+++ linux22/block/cfq-iosched.c	2009-10-03 08:23:24.000000000 -0400
@@ -181,6 +181,8 @@ struct cfq_data {
 	 * Fallback dummy cfqq for extreme OOM conditions
 	 */
 	struct cfq_queue oom_cfqq;
+
+	unsigned long last_end_sync_rq;
 };
 
 enum cfqq_state_flags {
@@ -1314,6 +1316,8 @@ static int cfq_dispatch_requests(struct 
 	 * Does this cfqq already have too much IO in flight?
 	 */
 	if (cfqq->dispatched >= max_dispatch) {
+		unsigned long load_at = cfqd->last_end_sync_rq + cfq_slice_sync;
+
 		/*
 		 * idle queue must always only have a single IO in flight
 		 */
@@ -1327,6 +1331,14 @@ static int cfq_dispatch_requests(struct 
 			return 0;
 
 		/*
+		 * If a sync request has completed recently, don't overload
+		 * the dispatch queue yet with async requests.
+		 */
+		if (cfqd->cfq_desktop && !cfq_cfqq_sync(cfqq)
+		    && time_before(jiffies, load_at))
+			return 0;
+
+		/*
 		 * we are the only queue, allow up to 4 times of 'quantum'
 		 */
 		if (cfqq->dispatched >= 4 * max_dispatch)
@@ -2158,8 +2170,10 @@ static void cfq_completed_request(struct
 	if (cfq_cfqq_sync(cfqq))
 		cfqd->sync_flight--;
 
-	if (sync)
+	if (sync) {
 		RQ_CIC(rq)->last_end_request = now;
+		cfqd->last_end_sync_rq = now;
+	}
 
 	/*
 	 * If this is the active queue, check if it needs to be expired,
@@ -2483,7 +2497,7 @@ static void *cfq_init_queue(struct reque
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->cfq_desktop = 1;
 	cfqd->hw_tag = 1;
-
+	cfqd->last_end_sync_rq = jiffies;
 	return cfqd;
 }
 

