Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZJUP50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZJUP50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZJUP50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:57:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZJUP5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:57:25 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC V2 PATCH 1/5] cfq-iosched: adapt slice to number of processes doing I/O
References: <200910202011.53858.czoccolo@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Oct 2009 11:57:24 -0400
In-Reply-To: <200910202011.53858.czoccolo@gmail.com> (Corrado Zoccolo's
	message of "Tue, 20 Oct 2009 20:11:53 +0200")
Message-ID: <x49aazk91uj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Corrado!

Sorry if folks receive this twice, but my mailer and I had an argument
about this message.  ;-)

Corrado Zoccolo <czoccolo@gmail.com> writes:

> When the number of processes performing I/O concurrently increases,
> a fixed time slice per process will cause large latencies.
>
> This patch, if low_latency mode is enabled,  will scale the time slice
> assigned to each process according to a 300ms target latency.
>
> In order to keep fairness among processes:
> * The number of active processes is computed using a special form of
> running average, that quickly follows sudden increases (to keep latency low),
> and decrease slowly (to have fairness in spite of rapid decreases of this
> value).
>
> To safeguard sequential bandwidth, we impose a minimum time slice
> (computed using 2*cfq_slice_idle as base, adjusted according to priority
> and async-ness).

I like the idea as well, but I have a question and some nits to pick.

>  static inline void
>  cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
> -	cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
> +	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
> +	if (cfqd->cfq_latency) {
> +		unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
> +		unsigned process_thr = cfq_target_latency / cfqd->cfq_slice[1];
> +		if (iq > process_thr) {
> +			unsigned low_slice = 2 * slice * cfqd->cfq_slice_idle
> +				/ cfqd->cfq_slice[1];
> +			slice = max(slice * cfq_target_latency /
> +				(cfqd->cfq_slice[1] * iq),

Couldn't you have just divided the slice by iq?  And why iq?  Why not
nr_qs or avg_qlen or something?  It's a minor nit; I can live with it.

> +				min(slice, low_slice));
> +		}
> +	}
> +	cfqq->slice_end = jiffies + slice;
>  	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);

Wow.  That function is *dense*.  I tried to write it in a more
readable fashion, but please chime in if I misinterpreted anything.

static inline void
cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
{
        unsigned slice = cfq_prio_to_slice(cfqd, cfqq);

	if (cfqd->cfq_latency) {
		unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
		unsigned slice_sync = cfqd->cfq_slice[1];
		unsigned process_thr = cfq_target_latency / slice_sync;

		if (iq > process_thr) {
			/*
			 * Minimum slice is computed using 2*slice_idle as
			 * a base, and then scaling it by priority and
			 * async-ness.
			 */
			unsigned total_sync = slice_sync * iq;
			unsigned slice_fraction = cfq_target_latency / total_sync;
			unsigned min_slice = (2 * cfqd->cfq_slice_idle) *
				(slice / slice_sync);
			min_slice = min(slice, min_slice);
			slice *= slice_fraction;
			slice = max(slice, min_slice);
		}
	}
	cfqq->slice_end = jiffies + slice;
	cfq_log_cfqq(cfqd, cfqq, "set_slice=%lu", cfqq->slice_end - jiffies);
}


Cheers,
Jeff
