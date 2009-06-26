Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZFZCTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZFZCTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZFZCTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:19:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:58924 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZFZCTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:19:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,294,1243839600"; 
   d="scan'208";a="158694121"
Date: Fri, 26 Jun 2009 10:19:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Ralf Gross <rg@STZ-Softwaretechnik.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: io-scheduler tuning for better read/write ratio
Message-ID: <20090626021905.GA23981@localhost>
References: <20090616154342.GA7043@p15145560.pureserver.info> <4A37CB2A.6010209@davidnewall.com> <20090616184027.GB7043@p15145560.pureserver.info> <4A37E7DB.7030100@redhat.com> <20090616185600.GC7043@p15145560.pureserver.info> <x49d494c4u0.fsf@segfault.boston.devel.redhat.com> <x49fxdsl46y.fsf@segfault.boston.devel.redhat.com> <20090622163113.GD12483@p15145560.pureserver.info> <x49hby8jbrd.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49hby8jbrd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 03:42:46AM +0800, Jeff Moyer wrote:
> Ralf Gross <rg@STZ-Softwaretechnik.com> writes:
> 
> > Jeff Moyer schrieb:
> >> Jeff Moyer <jmoyer@redhat.com> writes:
> >> 
> >> > Ralf Gross <rg@stz-softwaretechnik.com> writes:
> >> >
> >> >> Casey Dahlin schrieb:
> >> >>> On 06/16/2009 02:40 PM, Ralf Gross wrote:
> >> >>> > David Newall schrieb:
> >> >>> >> Ralf Gross wrote:
> >> >>> >>> write throughput is much higher than the read throughput (40 MB/s
> >> >>> >>> read, 90 MB/s write).
> >> >>> > 
> >> >>> > Hm, but I get higher read throughput (160-200 MB/s) if I don't write
> >> >>> > to the device at the same time.
> >> >>> > 
> >> >>> > Ralf
> >> >>> 
> >> >>> How specifically are you testing? It could depend a lot on the
> >> >>> particular access patterns you're using to test.
> >> >>
> >> >> I did the basic tests with tiobench. The real test is a test backup
> >> >> (bacula) with 2 jobs that create 2 30 GB spool files on that device.
> >> >> The jobs partially write to the device in parallel. Depending which
> >> >> spool file reaches the 30 GB first, one starts reading from that file
> >> >> and writing to tape, while to other is still spooling.
> >> >
> >> > We are missing a lot of details, here.  I guess the first thing I'd try
> >> > would be bumping up the max_readahead_kb parameter, since I'm guessing
> >> > that your backup application isn't driving very deep queue depths.  If
> >> > that doesn't work, then please provide exact invocations of tiobench
> >> > that reprduce the problem or some blktrace output for your real test.
> >> 
> >> Any news, Ralf?
> >
> > sorry for the delay. atm there are large backups running and using the
> > raid device for spooling. So I can't do any tests.
> >
> > Re. read ahead: I tested different settings from 8Kb to 65Kb, this
> > didn't help.
> >
> > I'll do some more tests when the backups are done (3-4 more days).
> 
> The default is 128KB, I believe, so it's strange that you would test
> smaller values.  ;)  I would try something along the lines of 1 or 2 MB.
> 
> I'm CCing Fengguang in case he has any suggestions.

Jeff, thank you for the forwarding (and sorry for the long delay)!

The read:write (or rather sync:async) ratio control is an IO scheduler
feature. CFQ has parameters slice_sync and slice_async for that.
What's more, CFQ will let async IO wait if there are any in flight
sync IO. This is good, but not quite enough. Normally sync IOs come
one by one, with some small idle time window in between. If we only
start dispatching async IOs after the last sync IO has completed for
eg. 1ms, then we may stop the async background write IOs when there
are active sync foreground read IO stream.

This simple patch aims to address the writes-push-aside-reads problem.
Ralf, you can try applying this patch and run your workload with this
(huge) CFQ parameter:

        echo 1000 > /sys/block/sda/queue/iosched/slice_sync 

The patch is based on 2.6.30, but can be trivially backported if you
want to use some old kernel.

It may impact overall (sync+async) IO throughput when there are one or
more ongoing sync IO streams, so requires considerable benchmarks and
adjustments.

Thanks,
Fengguang
---

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a55a9bd..14011b7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1064,7 +1064,6 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
 		return;
 
-	WARN_ON(!RB_EMPTY_ROOT(&cfqq->sort_list));
 	WARN_ON(cfq_cfqq_slice_new(cfqq));
 
 	/*
@@ -2175,8 +2174,6 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	 * or if we want to idle in case it has no pending requests.
 	 */
 	if (cfqd->active_queue == cfqq) {
-		const bool cfqq_empty = RB_EMPTY_ROOT(&cfqq->sort_list);
-
 		if (cfq_cfqq_slice_new(cfqq)) {
 			cfq_set_prio_slice(cfqd, cfqq);
 			cfq_clear_cfqq_slice_new(cfqq);
@@ -2190,8 +2187,8 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
 			cfq_slice_expired(cfqd, 1);
-		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq, 1) &&
-			 sync && !rq_noidle(rq))
+		else if (sync && !rq_noidle(rq) &&
+			 !cfq_close_cooperator(cfqd, cfqq, 1))
 			cfq_arm_slice_timer(cfqd);
 	}
 
