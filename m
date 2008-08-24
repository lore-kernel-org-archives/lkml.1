Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYHXUYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYHXUYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 16:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYHXUYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 16:24:40 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:63873 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYHXUYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 16:24:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WjOU5W3uRgIxu6tqxIkyVIrj6CKu1B9OUkcX2DRuIJqAVdZzOQ8HyijVcreuHQ6RKL
         LDU70Llu479mFLrE/RMo7FT7JLvSmXPS6dUmdBS/EjqG1vU4VlwozvkkBJ+3umt+Qs7x
         nn1uX3GCuHjsw4jKLMrI5IZp6UIep2/ViWJ/U=
Message-ID: <6278d2220808241324j117725efq8e87025313fb025f@mail.gmail.com>
Date: Sun, 24 Aug 2008 21:24:37 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Fabio Checconi" <fchecconi@gmail.com>,
       "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: performance "regression" in cfq compared to anticipatory, deadline and noop
Cc: Matthew <jackdachef@gmail.com>, "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080515122156.GA11600@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e85b9d30805130558l502addbcq21996b92fdbfdc5b@mail.gmail.com>
	 <e85b9d30805130842p3a34305l4ab1e7926e4b0dba@mail.gmail.com>
	 <20080513180334.GS16217@kernel.dk> <20080513184057.GU16217@kernel.dk>
	 <6278d2220805140105x27292033u6a97dcf13ab54263@mail.gmail.com>
	 <20080514082622.GA16217@kernel.dk>
	 <6278d2220805141352s3624d7b7qc90567f6b7a410dc@mail.gmail.com>
	 <e85b9d30805141437u6a4b4caby1712c6f04bd4cc05@mail.gmail.com>
	 <20080515070127.GH16217@kernel.dk>
	 <20080515122156.GA11600@gandalf.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio, Jens,

On Thu, May 15, 2008 at 1:21 PM, Fabio Checconi <fchecconi@gmail.com> wrote:
>> From: Jens Axboe <jens.axboe@oracle.com>
>> Date: Thu, May 15, 2008 09:01:28AM +0200
>>
>> I don't think it's 2.6.25 vs 2.6.26-rc2, I can still reproduce some
>> request size offsets with the patch. So still fumbling around with this,
>> I'll be sending out another test patch when I'm confident it's solved
>> the size issue.
>
> IMO an interesting thing is how/why anticipatory doesn't show the
> issue.  The device is not put into ANTIC_WAIT_NEXT if there is no
> dispatch returning no requests while the queue is not empty.  This
> seems to be enough in the reported workloads.
>
> I don't think this behavior is the correct one (it is still racy
> WRT merges after breaking anticipation) anyway it should make things
> a little bit better.  I fear that a complete solution would not
> involve only the scheduler.
>
> Introducing the very same behavior in cfq seems to be not so easy
> (i.e., start idling only if there was a dispatch round while the
> last request was being served) but an approximated version can be
> introduced quite easily.  The patch below should do that, rescheduling
> the dispatch only if necessary; it is not tested at all, just posted
> for discussion.
>
> ---
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index b399c62..41f1e0e 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -169,6 +169,7 @@ enum cfqq_state_flags {
>        CFQ_CFQQ_FLAG_queue_new,        /* queue never been serviced */
>        CFQ_CFQQ_FLAG_slice_new,        /* no requests dispatched in slice */
>        CFQ_CFQQ_FLAG_sync,             /* synchronous queue */
> +       CFQ_CFQQ_FLAG_dispatched,       /* empty dispatch while idling */
>  };
>
>  #define CFQ_CFQQ_FNS(name)                                             \
> @@ -196,6 +197,7 @@ CFQ_CFQQ_FNS(prio_changed);
>  CFQ_CFQQ_FNS(queue_new);
>  CFQ_CFQQ_FNS(slice_new);
>  CFQ_CFQQ_FNS(sync);
> +CFQ_CFQQ_FNS(dispatched);
>  #undef CFQ_CFQQ_FNS
>
>  static void cfq_dispatch_insert(struct request_queue *, struct request *);
> @@ -749,6 +751,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
>                cfqq->slice_end = 0;
>                cfq_clear_cfqq_must_alloc_slice(cfqq);
>                cfq_clear_cfqq_fifo_expire(cfqq);
> +               cfq_clear_cfqq_dispatched(cfqq);
>                cfq_mark_cfqq_slice_new(cfqq);
>                cfq_clear_cfqq_queue_new(cfqq);
>        }
> @@ -978,6 +981,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
>         */
>        if (timer_pending(&cfqd->idle_slice_timer) ||
>            (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
> +               cfq_mark_cfqq_dispatched(cfqq);
>                cfqq = NULL;
>                goto keep_queue;
>        }
> @@ -1784,7 +1788,10 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>                if (cfq_cfqq_wait_request(cfqq)) {
>                        cfq_mark_cfqq_must_dispatch(cfqq);
>                        del_timer(&cfqd->idle_slice_timer);
> -                       blk_start_queueing(cfqd->queue);
> +                       if (cfq_cfqq_dispatched(cfqq)) {
> +                               cfq_clear_cfqq_dispatched(cfqq);
> +                               cfq_schedule_dispatch(cfqd);
> +                       }
>                }
>        } else if (cfq_should_preempt(cfqd, cfqq, rq)) {
>                /*

This was the last test I didn't get around to. Alas, is did help, but
didn't give the merging required for full performance:

# echo 1 >/proc/sys/vm/drop_caches; dd if=/dev/sda of=/dev/null
bs=128k count=2000
262144000 bytes (262 MB) copied, 2.47787 s, 106 MB/s

# echo 1 >/proc/sys/vm/drop_caches; hdparm -t /dev/sda
Timing buffered disk reads:  308 MB in  3.01 seconds = 102.46 MB/sec

It is an improvement over the baseline performance of 2.6.27-rc4:

# echo 1 >/proc/sys/vm/drop_caches; dd if=/dev/sda of=/dev/null
bs=128k count=2000
262144000 bytes (262 MB) copied, 2.56514 s, 102 MB/s

# echo 1 >/proc/sys/vm/drop_caches; hdparm -t /dev/sda
Timing buffered disk reads:  294 MB in  3.02 seconds =  97.33 MB/sec

Note that platter speed is around 125MB/s (which I get near at smaller
read sizes).

I feel 128KB read requests are perhaps important, as this is a
commonly-used RAID stripe size, and may explain the read-performance
drop sometimes we see in hardware vs software RAID benchmarks.

How can we generate some ideas or movement on fixing/improving this behaviour?

Thanks!
  Daniel
-- 
Daniel J Blueman
