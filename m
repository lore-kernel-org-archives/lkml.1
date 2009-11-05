Return-Path: <linux-kernel-owner+w=401wt.eu-S1751261AbZKEAGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbZKEAGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZKEAGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:06:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZKEAGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:06:42 -0500
Date: Wed, 4 Nov 2009 19:05:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 02/20] blkio: Change CFQ to use CFS like queue time
	stamps
Message-ID: <20091105000552.GQ2870@redhat.com>
References: <1257291837-6246-1-git-send-email-vgoyal@redhat.com> <1257291837-6246-3-git-send-email-vgoyal@redhat.com> <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911041318w68bd774qf110d1abd7f946e4@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 10:18:15PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Wed, Nov 4, 2009 at 12:43 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o Previously CFQ had one service tree where queues of all theree prio classes
> >  were being queued. One side affect of this time stamping approach is that
> >  now single tree approach might not work and we need to keep separate service
> >  trees for three prio classes.
> >
> Single service tree is no longer true in cfq for-2.6.33.
> Now we have a matrix of service trees, with first dimension being the
> priority class, and second dimension being the workload type
> (synchronous idle, synchronous no-idle, async).
> You can have a look at the series: http://lkml.org/lkml/2009/10/26/482 .
> It may have other interesting influences on your work, as the idle
> introduced at the end of the synchronous no-idle tree, that provides
> fairness also for seeky or high-think-time queues.
> 

I am sorry that I am asking questions about a different patchset in this
mail. I don't have ready access to other mail thread currently.

I am looking at your patchset and trying to understand how have you
ensured fairness for different priority level queues.

Following seems to be the key piece of code which determines the slice
length of the queue dynamically.


static inline void
cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
{
	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
	if (cfqd->cfq_latency) {
		/* interested queues (we consider only the ones with the same
		 * priority class) */
		unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
		unsigned sync_slice = cfqd->cfq_slice[1];
		unsigned expect_latency = sync_slice * iq;
		if (expect_latency > cfq_target_latency) {
			unsigned base_low_slice = 2 * cfqd->cfq_slice_idle;
			/* scale low_slice according to IO priority
			 * and sync vs async */
			unsigned low_slice =
				min(slice, base_low_slice * slice / sync_slice);
			/* the adapted slice value is scaled to fit all iqs
			 * into the target latency */
			slice = max(slice * cfq_target_latency / expect_latency,
				    low_slice);
		}
	}
	cfqq->slice_end = jiffies + slice;
	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
}

A question.

- expect_latency seems to be being calculated based on based slice lenth
  for sync queues (100ms). This will give right number only if all the
  queues in the system were of prio 4. What if there are 3 prio 0 queues.
  They will/should get 180ms slice each resulting in max latency of 540 ms
  but we will be calculating expect_latency to = 100 * 3 =300 ms which is
  less than cfq_target_latency and we will not adjust slice length?

- With "no-idle" group, who benefits? As I said, all these optimizations
  seems to be for low latency. In that case user will set "low_latency"
  tunable in CFQ. If that's the case, then we will anyway enable idling
  random seeky processes having think time less than 8ms. So they get
  their fair share.

  I guess this will provide benefit if user has not set "low_latency" and
  in that case we will not enable idle on random seeky readers and we will
  gain in terms of throughput on NCQ hardware because we dispatch from
  other no-idle queues and then idle on the no-idle group.

Time for some testing...

Thanks
Vivek
