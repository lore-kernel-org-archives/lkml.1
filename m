Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbYEPIxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbYEPIxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYEPIxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:53:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:27996 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYEPIxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Lw2UyT7M6eU7N8a9tga9oh59mm/k3RcbGs+XLb80evxn8WUIA3NWaGNPxJqx8cKNV9nhD85EIERnmZruWmpsdWmGzTkNt/8Svr78x3MyBkBYFfiBdabwcHFb/9FviOHaLaBgaD6FmDFuowFzrICYM3xaE3TFXCk59GQtNExWyuY=
Message-ID: <6278d2220805160153s280d304di37b3bb62d770b81@mail.gmail.com>
Date: Fri, 16 May 2008 09:53:41 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Cc: "Fabio Checconi" <fchecconi@gmail.com>, Matthew <jackdachef@gmail.com>,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080516075715.GX16217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513184057.GU16217@kernel.dk>
	 <20080514082622.GA16217@kernel.dk>
	 <6278d2220805141352s3624d7b7qc90567f6b7a410dc@mail.gmail.com>
	 <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com>
	 <20080515070127.GH16217@kernel.dk>
	 <20080515122156.GA11600@gandalf.sssup.it>
	 <20080516064002.GL16217@kernel.dk>
	 <20080516074628.GA17802@gandalf.sssup.it>
	 <20080516074913.GW16217@kernel.dk> <20080516075715.GX16217@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 8:57 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Fri, May 16 2008, Jens Axboe wrote:
>> On Fri, May 16 2008, Fabio Checconi wrote:
>> > > From: Jens Axboe <jens.axboe@oracle.com>
>> > > Date: Fri, May 16, 2008 08:40:03AM +0200
>> > >
>> > ...
>> > > I think we can improve this further without getting too involved. If a
>> > > 2nd request is seen in cfq_rq_enqueued(), then DO schedule a dispatch
>> > > since this likely means that we wont be doing more merges on the first
>> > > one.
>> > >
>> >
>> > But isn't there the risk that even the second request would be
>> > dispatched, while it still could have grown?
>>
>> Certainly, you'd only want to dispatch the first request. Ideally we'd
>> just get rid of this logic of 'did empty dispatch round' and only
>> dispatch requests once merging is done, it's basically the wrong thing
>> to do to make it visible to the io scheduler so soon. Well of course
>> even more ideally we'd always get big requests submitted, but
>> unfortunately many producers aren't that nice.
>>
>> The per-process plugging actually solves this nicely, since we do the
>> merging outside of the io scheduler. Perhaps just not dispatch on a
>> plugged queue would help a bit. I'm somewhat against this principle of
>> messing too much with dispatch logic in the schedulers, it'd be nicer to
>> solve this higher up.
>
> Something like this...
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 5dfb7b9..5ab1a17 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1775,6 +1775,9 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>
>        cic->last_request_pos = rq->sector + rq->nr_sectors;
>
> +       if (blk_queue_plugged(cfqd->queue))
> +               return;
> +
>        if (cfqq == cfqd->active_queue) {
>                /*
>                 * if we are waiting for a request for this queue, let it rip
> @@ -1784,7 +1787,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>                if (cfq_cfqq_wait_request(cfqq)) {
>                        cfq_mark_cfqq_must_dispatch(cfqq);
>                        del_timer(&cfqd->idle_slice_timer);
> -                       blk_start_queueing(cfqd->queue);
> +                       cfq_schedule_dispatch(cfqd);
>                }
>        } else if (cfq_should_preempt(cfqd, cfqq, rq)) {
>                /*
> @@ -1794,7 +1797,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>                 */
>                cfq_preempt_queue(cfqd, cfqq);
>                cfq_mark_cfqq_must_dispatch(cfqq);
> -               blk_start_queueing(cfqd->queue);
> +               cfq_schedule_dispatch(cfqd);
>        }
>  }
>
> @@ -1997,11 +2000,10 @@ static void cfq_kick_queue(struct work_struct *work)
>        struct cfq_data *cfqd =
>                container_of(work, struct cfq_data, unplug_work);
>        struct request_queue *q = cfqd->queue;
> -       unsigned long flags;
>
> -       spin_lock_irqsave(q->queue_lock, flags);
> +       spin_lock_irq(q->queue_lock);
>        blk_start_queueing(q);
> -       spin_unlock_irqrestore(q->queue_lock, flags);
> +       spin_unlock_irq(q->queue_lock);
>  }
>
>  /*

Platter speed at 64KB stride, but 16% (101MB/s) less performance at
4KB stride - perhaps merging isn't quite right?

Both traces at http://quora.org/blktrace-profiles-3.tar.bz2 ; let me
know if you'd like me to test Fabio's patch still.

Thanks,
  Daniel
-- 
Daniel J Blueman
