Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZLEIus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZLEIus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 03:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZLEIuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 03:50:46 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35128 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbZLEIuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 03:50:46 -0500
Date: Sat, 5 Dec 2009 09:50:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC]cfq-iosched: no dispatch limit for single queue
Message-ID: <20091205085051.GC8742@kernel.dk>
References: <20091203035330.GB13165@sli10-desk.sh.intel.com> <20091203115740.GM8742@kernel.dk> <4e5e476b0912041034h2a2c53fdh16ddb6523c4917cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0912041034h2a2c53fdh16ddb6523c4917cd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04 2009, Corrado Zoccolo wrote:
> Hi Shaohua, Jens,
> On Thu, Dec 3, 2009 at 12:57 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Thu, Dec 03 2009, Shaohua Li wrote:
> >> Since commit 2f5cb7381b737e24c8046fd4aeab571fb71315f5, each queue can send
> >> up to 4 * 4 requests if only one queue exists. I wonder why we have such limit.
> >> Device supports tag can send more requests. For example, AHCI can send 31
> >> requests. Test (direct aio randread) shows the limits reduce about 4% disk
> >> thoughput.
> >> On the other hand, since we send one request one time, if other queue
> >> pop when current is sending more than cfq_quantum requests, current queue will
> >> stop send requests soon after one request, so sounds there is no big latency.
> >>
> >> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> >>
> >> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> >> index aa1e953..e05650f 100644
> >> --- a/block/cfq-iosched.c
> >> +++ b/block/cfq-iosched.c
> >> @@ -1298,9 +1298,9 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> >>                       return false;
> >>
> >>               /*
> >> -              * Sole queue user, allow bigger slice
> >> +              * Sole queue user, no limit
> >>                */
> >> -             max_dispatch *= 4;
> >> +             max_dispatch = -1;
> >>       }
> >>
> >>       /*
> >
> > As you mention, we do dispatches in bites of 1. In reality, there's
> > going to be little difference when we get this far in the depth process,
> > so I think the patch looks good. I have applied it, thanks.
> 
> I think the limit should be removed only for sync queues.
> For async queues, if cfq_latency is not set, removing the limit here can
> cause very high latencies to sync queues (almost 100% increase),
> without a noticeable throughput gain.

It's always problematic to say 'without a noticable throughput gain', as
on some workloads/storage, the difference between 16 and eg 32 in depth
WILL be noticeable. 16 is already high enough that if we hit that limit,
it will cause a latency hit. The hope here is that larger wont make it
much worse, but we'll see.

-- 
Jens Axboe

