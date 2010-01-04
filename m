Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464Ab0ADQg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0ADQg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068Ab0ADQgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:36:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54442 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0ADQgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PU1KRJXbiuNOaPF5AMOAHQo2HyKxhEROhI/aRe5AWGEjWCyy2Lhh0dy9HXG+fcP90m
         s+7KfB9vNG6nTmBYjnAniz4skjUMD0N9VpF8/XVEnEwwEaXD3ZpopNa6fu6uB9lLHRf3
         X09Nt5N75FJ2uuojDgzSEq5+lqPlgEWFkmhCg=
MIME-Version: 1.0
In-Reply-To: <20100104144711.GA7968@redhat.com>
References: <20091230213439.GQ4489@kernel.dk>
	 <1262211768-10858-1-git-send-email-czoccolo@gmail.com>
	 <20100104144711.GA7968@redhat.com>
Date: Mon, 4 Jan 2010 17:36:21 +0100
Message-ID: <4e5e476b1001040836p2c8d7486x807a1a89b61c2458@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue 
	merging
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivkek,

On Mon, Jan 4, 2010 at 3:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Dec 30, 2009 at 11:22:47PM +0100, Corrado Zoccolo wrote:
>> Non rotational devices' performances are not affected by
>> distance of read requests, so there is no point in having
>> overhead to merge such queues.
>> This doesn't apply to writes, so this patch changes the
>> queued[] field, to be indexed by READ/WRITE instead of
>> SYNC/ASYNC, and only compute proximity for queues with
>> WRITE requests.
>>
>
> Hi Corrado,
>
> What's the reason that reads don't benefit from merging queues and hence
> merging requests and only writes do on SSD?

On SSDs, reads are just limited by the maximum transfer rate, and
larger (i.e. merged) reads will just take proportionally longer.

>> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
>> ---
>>  block/cfq-iosched.c |   20 +++++++++++---------
>>  1 files changed, 11 insertions(+), 9 deletions(-)
>>
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index 918c7fd..7da9391 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -108,9 +108,9 @@ struct cfq_queue {
>>       struct rb_root sort_list;
>>       /* if fifo isn't expired, next request to serve */
>>       struct request *next_rq;
>> -     /* requests queued in sort_list */
>> +     /* requests queued in sort_list, indexed by READ/WRITE */
>>       int queued[2];
>> -     /* currently allocated requests */
>> +     /* currently allocated requests, indexed by READ/WRITE */
>>       int allocated[2];
>
> Sometime back Jens had changed all READ/WRITE indexing to SYNC/ASYNC
> indexing throughout IO schedulers and block layer.
Not completely. The allocated field (for which I fixed only the
comment) is still addressed as READ/WRITE.
> Personally I would
> prefer to keep it that way and not have a mix of SYNC/ASYNC and READ/WRITE
> indexing in code.
I think that, as long as it is documented, it should be fine.

> What are we gaining by this patch? Save some cpu cycles by not merging
> and splitting the read cfqq on ssd?
Yes. We should save a lot of cycles by saving the rb tree management
to achieve those operations.
Jens' position is that for fast SSDs, we need to save CPU cycles if we
want to perform well.

> Do you have any numbers how much is
> the saving. My knee jerk reaction is that if gains are not significant,
> lets not do this optimization and let the code be simple.
I think we are actually simplifying the code, removing an optimization
(queue merging) when it is not needed.
When you want to reason about how the code performs on SSD, removing
the unknown of queue merging renders the problem easier.
>
>
>>       /* fifo list of requests in sort_list */
>>       struct list_head fifo;
>> @@ -1268,7 +1268,8 @@ static void cfq_prio_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>               return;
>>       if (!cfqq->next_rq)
>>               return;
>> -
>> +     if (blk_queue_nonrot(cfqd->queue) && !cfqq->queued[WRITE])
>> +             return;
>
> A 1-2 line comment here will help about why writes still benefit and not
> reads.
>
It's because low-end SSDs are penalized by small writes. I don't have
an high end SSD to test with, but Jens is going to do more testing,
and eventually he can disable merging also for writes if he sees
improvement. Note that this is not the usual async write, but sync
write with aio, that I think is quite a niche.

>>       cfqq->p_root = &cfqd->prio_trees[cfqq->org_ioprio];
>>       __cfqq = cfq_prio_tree_lookup(cfqd, cfqq->p_root,
>>                                     blk_rq_pos(cfqq->next_rq), &parent, &p);
>> @@ -1337,10 +1338,10 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>>  static void cfq_del_rq_rb(struct request *rq)
>>  {
>>       struct cfq_queue *cfqq = RQ_CFQQ(rq);
>> -     const int sync = rq_is_sync(rq);
>> +     const int rw = rq_data_dir(rq);
>>
>> -     BUG_ON(!cfqq->queued[sync]);
>> -     cfqq->queued[sync]--;
>> +     BUG_ON(!cfqq->queued[rw]);
>> +     cfqq->queued[rw]--;
>>
>>       elv_rb_del(&cfqq->sort_list, rq);
>>
>> @@ -1363,7 +1364,7 @@ static void cfq_add_rq_rb(struct request *rq)
>>       struct cfq_data *cfqd = cfqq->cfqd;
>>       struct request *__alias, *prev;
>>
>> -     cfqq->queued[rq_is_sync(rq)]++;
>> +     cfqq->queued[rq_data_dir(rq)]++;
>>
>>       /*
>>        * looks a little odd, but the first insert might return an alias.
>> @@ -1393,7 +1394,7 @@ static void cfq_add_rq_rb(struct request *rq)
>>  static void cfq_reposition_rq_rb(struct cfq_queue *cfqq, struct request *rq)
>>  {
>>       elv_rb_del(&cfqq->sort_list, rq);
>> -     cfqq->queued[rq_is_sync(rq)]--;
>> +     cfqq->queued[rq_data_dir(rq)]--;
>>       cfq_add_rq_rb(rq);
>>  }
>>
>> @@ -1689,7 +1690,8 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
>>       struct cfq_queue *__cfqq;
>>       sector_t sector = cfqd->last_position;
>>
>> -     if (RB_EMPTY_ROOT(root))
>> +     if (RB_EMPTY_ROOT(root) ||
>> +         (blk_queue_nonrot(cfqd->queue) && !cur_cfqq->queued[WRITE]))
>>               return NULL;
>>
>>       /*
>> --
>> 1.6.4.4
>
Thanks
Corrado
