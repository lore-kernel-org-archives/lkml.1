Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546Ab0AMW0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0AMW0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032Ab0AMW0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:26:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab0AMW0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:26:11 -0500
Date: Wed, 13 Jan 2010 17:26:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, jmoyer@redhat.com,
       guijianfeng@cn.fujitsu.com, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async requests
	pending
Message-ID: <20100113222603.GK6123@redhat.com>
References: <20100113074442.GA10492@sli10-desk.sh.intel.com> <20100113111005.GA3087@redhat.com> <4e5e476b1001131330l75f5d949u13b615d408206c92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b1001131330l75f5d949u13b615d408206c92@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 10:30:52PM +0100, Corrado Zoccolo wrote:
> On Wed, Jan 13, 2010 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Jan 13, 2010 at 03:44:42PM +0800, Shaohua Li wrote:
> >> My SSD speed of direct write is about 80m/s, while I test page writeback,
> >> the speed can only go to 68m/s. Below patch fixes this.
> >> It appears we missused cfq_should_idle in cfq_may_dispatch. cfq_should_idle
> >> means a queue should idle because it's seekless sync queue or it's the last queue,
> >> which is to maintain service tree time slice. So it doesn't mean the
> >> last queue is always a sync queue. If the last queue is asyn queue,
> >> we definitely shouldn't stop dispatch requests because of pending async
> >> requests.
> >>
> >> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> >>
> >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >> index 918c7fd..8198079 100644
> >> --- a/block/cfq-iosched.c
> >> +++ b/block/cfq-iosched.c
> >> @@ -2222,7 +2222,8 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> >>       /*
> >>        * Drain async requests before we start sync IO
> >>        */
> >> -     if (cfq_should_idle(cfqd, cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
> >> +     if (cfq_cfqq_sync(cfqq) && cfq_should_idle(cfqd, cfqq)
> >> +             && cfqd->rq_in_driver[BLK_RW_ASYNC])
> >>               return false;
> >
> > So are we driving queue depth as 1 when pure buffered writes are going on?
> > Because in that case service_tree->count=1 and cfq_should_idle() will
> > return 1 and looks like we will not dispatch next write till previous
> > write is over?
> 
> Yes, it seems so. It has to be fixed.
> 
> >
> > A general question. Why do we need to drain async requests before we start
> > sync IO? How does that help?
> >
> > A related question, even if we have to do that, why do we check for
> > cfq_should_idle()? Why can't we just do following.
> >
> >        if (cfq_cfqq_sync(cfqq) && cfqd->rq_in_driver[BLK_RW_ASYNC])
> >
> This would wait also for seeky queues. I think we drain to avoid
> disrupting a sync
> stream with far writes, but it is not needed when the queues are already seeky.

Ok, that makes sense. But again the conflict is single disk vs RAID. RAID
array will most likely be doing some write caching or writes and reads
might be travelling to different disks hence sequential reads should not
be significantly impacted. Another case to optimize if we can reliably
identify RAIDs.

Thanks
Vivek
