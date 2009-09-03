Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbZICNBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbZICNBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZICNBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:01:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZICNBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:01:16 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] cfq: adapt slice to number of processes doing I/O
References: <4e5e476b0909030407k8a7b534v42bdffcad06127bd@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 03 Sep 2009 09:01:12 -0400
In-Reply-To: <4e5e476b0909030407k8a7b534v42bdffcad06127bd@mail.gmail.com>
	(Corrado Zoccolo's message of "Thu, 3 Sep 2009 13:07:01 +0200")
Message-ID: <x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> When the number of processes performing I/O concurrently increases,  a
> fixed time slice per process will cause large latencies.
> In the patch, if there are more than 3 processes performing concurrent
> I/O, we scale the time slice down proportionally.
> To safeguard sequential bandwidth, we impose a minimum time slice,
> computed from cfq_slice_idle (the idea is that cfq_slice_idle
> approximates the cost for a seek).
>
> I performed two tests, on a rotational disk:
> * 32 concurrent processes performing random reads
> ** the bandwidth is improved from 466KB/s to 477KB/s
> ** the maximum latency is reduced from 7.667s to 1.728
> * 32 concurrent processes performing sequential reads
> ** the bandwidth is reduced from 28093KB/s to 24393KB/s
> ** the maximum latency is reduced from 3.781s to 1.115s
>
> I expect numbers to be even better on SSDs, where the penalty to
> disrupt sequential read is much less.

Interesting approach.  I'm not sure what the benefits will be on SSDs,
as the idling logic is disabled for them (when nonrot is set and they
support ncq).  See cfq_arm_slice_timer.

> Signed-off-by: Corrado Zoccolo <czoccolo@gmail-com>
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index fd7080e..cff4ca8 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -306,7 +306,15 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct
> cfq_queue *cfqq)
>  static inline void
>  cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
> -       cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
> +       unsigned low_slice = cfqd->cfq_slice_idle * (1 + cfq_cfqq_sync(cfqq));
> +       unsigned interested_queues = cfq_class_rt(cfqq) ?
> cfqd->busy_rt_queues : cfqd->busy_queues;

Either my mailer displayed this wrong, or yours wraps lines.

> +       unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
> +       if (interested_queues > 3) {
> +               slice *= 3;

How did you come to this magic number of 3, both for the number of
competing tasks and the multiplier for the slice time?  Did you
experiment with this number at all?

> +               slice /= interested_queues;

Of course you realize this could disable the idling logic completely,
right?  I'll run this patch through some tests and let you know how it
goes.

Thanks!

-Jeff
