Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbZLYJon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbZLYJon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 04:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZLYJom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 04:44:42 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:59167 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZLYJol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 04:44:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eBt9WS7ZEqK2flnkznH8mqYw0QM++ATq9HRrpjG4wpp7wpBTYTK3ymTMMoOaDiO7n8
         YQBmA9ek64CxZHoBdrSI3q5IACXoMt50ZuYNqxQHwmbynvfqM0MEnYBTY6OpqoBDmBxm
         OznLPqfDT9LFacNmkCzNt2vRsDzWHU3Oy6v/c=
MIME-Version: 1.0
In-Reply-To: <20091225091030.GA28365@sli10-desk.sh.intel.com>
References: <20091225091030.GA28365@sli10-desk.sh.intel.com>
Date: Fri, 25 Dec 2009 10:44:40 +0100
Message-ID: <4e5e476b0912250144l96c4d34v300910216e5c7a08@mail.gmail.com>
Subject: Re: [RFC]cfq-iosched: quantum check tweak
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       yanmin.zhang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 10:10 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> Currently a queue can only dispatch up to 4 requests if there are other queues.
> This isn't optimal, device can handle more requests, for example, AHCI can
> handle 31 requests. I can understand the limit is for fairness, but we could
> do some tweaks:
> 1. if the queue still has a lot of slice left, sounds we could ignore the limit
ok. You can even scale the limit proportionally to the remaining slice
(see below).

> 2. we could keep the check only when cfq_latency is on. For uses who don't care
> about latency should be happy to have device fully piped on.
I wouldn't overload low_latency with this meaning. You can obtain the
same by setting the quantum to 32.
>
> I have a test of random direct io of two threads, each has 32 requests one time
> without patch: 78m/s
> with tweak 1: 138m/s
> with two tweaks and disable latency: 156m/s

Please, test also with competing seq/random(depth1)/async workloads,
and measure also introduced latencies.

>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  block/cfq-iosched.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/block/cfq-iosched.c
> ===================================================================
> --- linux-2.6.orig/block/cfq-iosched.c
> +++ linux-2.6/block/cfq-iosched.c
> @@ -2242,6 +2242,18 @@ static int cfq_forced_dispatch(struct cf
>        return dispatched;
>  }
>
> +static inline bool cfq_slice_used_soon(struct cfq_data *cfqd,
> +       struct cfq_queue *cfqq)
> +{
> +       /* the queue hasn't finished any request, can't estimate */
> +       if (cfq_cfqq_slice_new(cfqq))
> +               return 1;
> +       if (time_after(jiffies + cfqd->cfq_slice_idle, cfqq->slice_end))
here I would use
jiffies + cfqd->cfq_slice_idle * (cfqq->queued[0] + cfqq->queued[1])
to obtain the proper scaling
> +               return 1;
> +
> +       return 0;
> +}
> +
>  static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
>        unsigned int max_dispatch;

Thanks,
Corrado

-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
