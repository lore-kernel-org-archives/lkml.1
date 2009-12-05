Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZLELNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZLELNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 06:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbZLELNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 06:13:32 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:44902 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbZLELNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 06:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=W602+2UU5H3OGMkiAyDecyblArspN2z3+eoKPCIz6OBGzDFcKU8sTTBptVsYhBGaYE
         tQgFQwpA5y8V5RIX2rvd1jUwg/NJw5/Csc3AlY0wL95p7iy3NDCtvqa+kRqHLTd4fl5U
         prMuVhDjwMDD3xuJ3FTc8dmr8tnjgJXDyHaw0=
MIME-Version: 1.0
In-Reply-To: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
Date: Sat, 5 Dec 2009 12:13:37 +0100
Message-ID: <4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 1:35 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> The introduction of ramp-up formula for async queue depths has
> slowed down dirty page reclaim, by reducing async write performance.
> This patch makes sure the formula kicks in only when sync request
> was recently delayed.
>
> Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
> ---
>  block/cfq-iosched.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index b00ca4c..a594388 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -284,7 +284,7 @@ struct cfq_data {
>         */
>        struct cfq_queue oom_cfqq;
>
> -       unsigned long last_end_sync_rq;
> +       unsigned long last_delayed_sync;
>
>        /* List of cfq groups being managed on this device*/
>        struct hlist_head cfqg_list;
> @@ -2264,7 +2264,7 @@ static bool cfq_may_dispatch(struct cfq_data *cfqd,
> struct cfq_queue *cfqq)
>         * based on the last sync IO we serviced
>         */
>        if (!cfq_cfqq_sync(cfqq) && cfqd->cfq_latency) {
> -               unsigned long last_sync = jiffies - cfqd->last_end_sync_rq;
> +               unsigned long last_sync = jiffies - cfqd->last_delayed_sync;
>                unsigned int depth;
>
>                depth = last_sync / cfqd->cfq_slice[1];
> @@ -3272,7 +3272,8 @@ static void cfq_completed_request(struct request_queue
> *q, struct request *rq)
>
>        if (sync) {
>                RQ_CIC(rq)->last_end_request = now;
> -               cfqd->last_end_sync_rq = now;
> +               if (time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
> +                       cfqd->last_delayed_sync = now;

Sorry, the check be reversed (!time_after).

>        }
>
>        /*
> @@ -3706,7 +3707,7 @@ static void *cfq_init_queue(struct request_queue *q)
>        cfqd->cfq_latency = 1;
>        cfqd->cfq_group_isolation = 0;
>        cfqd->hw_tag = -1;
> -       cfqd->last_end_sync_rq = jiffies;
> +       cfqd->last_delayed_sync = jiffies - HZ;
>        return cfqd;
>  }
>
> --
> 1.6.2.5
>
>
>
>
